import * as _ from 'lodash';
import * as util from 'util';
import * as consul from 'consul';
import * as FeatureFlags from './common/feature_flags';
import { Config, ConsulKV } from './config.model';


/**
 * One-stop shop for processing each of our config strings for uniform behavior!
 * @param configString config string to process
 * @returns {*} the correctly processed config string
 */
const processConfigString = function (configString: string): string | boolean {
  try {
    return castToBoolean(configString);
  } catch (e) {
    return configString;
  }
};

/**
 * Casts a string to its boolean value. Returns undefined if the string is not a boolean.
 * @param s string to cast
 * @returns {*} true or false if the strings match either, otherwise an exception is raised
 */
const castToBoolean = function (s: string): boolean {
  if (s === 'true' || s === 'True') {
    return true;
  } else if (s === 'false' || s === 'False') {
    return false;
  } else {
    throw new TypeError('string cannot be cast to a boolean');
  }
};

/**
 * Adds to the given config tree derived parameters about the available locales.
 * @param config config tree to add in parameters
 * @returns {*} the config tree
 */
const setupLocales = function (config: Config): Config {
  const cookie_prefix = config.environment.name + '-helios';

  config.server.locales.ca = _.assign(config.server.locales.ca, {
    'static_hostname': config.server.config.static_hostname,
    'cookie_prefix': cookie_prefix + '-canada-',
    'alternates': [_.pick(config.server.locales.us, 'host', 'lang', 'country')]
  });

  config.server.locales.us = _.assign(config.server.locales.us, {
    'static_hostname': config.server.config.static_hostname,
    'cookie_prefix': config.isProduction ? 'wp-' : cookie_prefix + '-store-',
    'alternates': [_.pick(config.server.locales.ca, 'host', 'lang', 'country')]
  });

  return config;
};


const is_dev = function () : boolean {
  return (['dev', 'development', 'local', 'localy'].indexOf(process.env.NODE_ENV) !== -1);
};

// Loads up the myriad of settings and configurations needed from consul
// TODO: Lots of these should be:
// 1.  Deleted
// 2.  Moved into some sort of secrets solution
// 3.  Use service discovery
// 4.  Use better consul naming convention so we can get these all in one get
const consulify = function* (config: Config): IterableIterator<any> {

  const client = consul({
    host: process.env.CONSUL_HOST,
    port: process.env.CONSUL_PORT,
    promisify: true
  });

  // Helper function to load up consul key/values
  const consul_get = function* (key: string, defaultz: any, is_bool?: boolean): IterableIterator<any> {
    const result: ConsulKV = yield client.kv.get(key);
    if (!result || !result.Value) {
      console.log('No consul entry available for ' + key);
      return defaultz;
    }
    if (is_bool) return result.Value;
    if (result.Value === '') return defaultz;
    return result.Value;
  };

  config.environment.debug = yield consul_get('helios/web/frontend/node/debug', config.environment.debug, true);
  config.amex.client_id = yield consul_get('helios/config/amex_express_checkout/client_id', config.amex.client_id);
  config.facebook.app_id = yield consul_get('helios/config/facebook/app_id', config.facebook.app_id);
  config.stripe.public_key = yield consul_get('helios/config/payment_gateway/stripe_apollo/public_key', config.stripe.public_key);
  config.friendbuy.enabled = yield consul_get('helios/app/friendbuy/enabled', config.friendbuy.enabled, true);
  config.friendbuy.site_id = yield consul_get('helios/app/friendbuy/site_id', config.friendbuy.site_id);
  config.friendbuy.widget_id = yield consul_get('helios/app/friendbuy/widget_id', config.friendbuy.widget_id);
  config.friendbuy.hto_widget_id = yield consul_get('helios/app/friendbuy/hto_widget_id', config.friendbuy.hto_widget_id);
  config.server.config.cookie_domain = yield consul_get('helios/web/frontend/store/cookie_domain', config.server.config.cookie_domain);
  config.server.config.hostname = yield consul_get('helios/web/frontend/node/hostname', config.server.config.hostname);
  config.server.config.static_hostname = yield consul_get('helios/web/frontend/node/static_hostname', config.server.config.static_hostname);
  config.server.circuit_breaker.redis_open = yield consul_get('helios/web/frontend/circuit_breaker/redis_open', config.server.circuit_breaker.redis_open, true);
  config.server.circuit_breaker.redis_closed = yield consul_get('helios/web/frontend/circuit_breaker/redis_closed', config.server.circuit_breaker.redis_closed, true);
  config.server.circuit_breaker.frontend_store_open = yield consul_get('helios/web/frontend/circuit_breaker/frontend_store_open', config.server.circuit_breaker.frontend_store_open, true);
  config.server.circuit_breaker.frontend_store_closed = yield consul_get('helios/web/frontend/circuit_breaker/frontend_store_closed', config.server.circuit_breaker.frontend_store_closed, true);
  config.server.locales.ca.host = yield consul_get('helios/web/frontend/canada/hostname', config.server.locales.ca.host);
  config.server.locales.ca.offline_host = yield consul_get('helios/web/frontend/canada/offline_hostname',  config.server.locales.us.host);
  config.server.locales.ca.mobile_host = yield consul_get('helios/web/frontend/canada/mobile_hostname', config.server.locales.ca.mobile_hostname);
  config.server.locales.ca.stripe_public_key = yield consul_get('helios/config/payment_gateway/stripe_artemis/public_key', config.server.locales.ca.stripe_public_key);
  config.server.locales.ca.features.giftCards = yield consul_get('helios/web/frontend/canada/gift_card_enabled', config.server.locales.ca.features.giftCards, true);
  config.server.locales.ca.features.homeTryOn = yield consul_get('helios/web/frontend/canada/hto_enabled', config.server.locales.ca.features.homeTryOn, true);
  config.server.locales.us.host = yield consul_get('helios/web/frontend/store/hostname',  config.server.locales.us.host);
  config.server.locales.us.offline_host = yield consul_get('helios/web/frontend/offline-store/hostname',  config.server.locales.us.host);
  config.server.locales.us.mobile_host = yield consul_get('helios/web/frontend/store/mobile_hostname',  config.server.locales.us.mobile_host);
  config.server.locales.us.stripe_public_key = yield consul_get('helios/config/payment_gateway/stripe_apollo/public_key',  config.stripe_public_key);
  config.server.newrelic.enabled = yield consul_get('shared/newrelic/enabled',  config.server.newrelic.enabled, true);
  config.server.newrelic.browser_enabled = yield consul_get('shared/newrelic/browser_enabled',  config.server.newrelic.browser_enabled, true);
  config.server.newrelic.license_key = yield consul_get('shared/newrelic/license_key',  config.server.newrelic.license_key);
  config.server.pre_react.enabled = yield consul_get('shared/pre_react/enabled',  config.server.pre_react.enabled, true);
  config.server.mpulse.enabled = yield consul_get('shared/mpulse/enabled',  config.server.mpulse.enabled, true);
  config.server.mpulse.boomId = yield consul_get('shared/mpulse/boom_id',  config.server.mpulse.boomId);
  config.server.mpulse.onErrorHookUrl = yield consul_get('shared/mpulse/on_error_hook_url',  config.server.mpulse.onErrorHookUrl);
  config.server.process.watch_mode = yield consul_get('helios/node/watch_mode',  config.server.process.watch_mode, true);
  config.server.process.num_forks = yield consul_get('helios/node/num_forks',  config.server.process.num_forks);
  config.server.memory.enforce = yield consul_get('helios/node/memory_enforce',  config.server.memory.enforce, true);
  config.server.memory.polling_interval = yield consul_get('helios/node/polling_interval',  config.server.memory.polling_interval);
  config.server.logging.metrics = yield consul_get('helios/node/logging_metrics',  config.server.logging.metrics, true);
  config.server.cache.engine = yield consul_get('helios/config/cache/backend',  config.server.cache.engine);
  config.server.cache.page_variants = yield consul_get('helios/node/cache/page_variants',  config.server.cache.page_variants);
  config.server.redis.host = yield consul_get('helios/config/cache/redis_host',  config.server.redis.host);
  config.server.redis.port = yield consul_get('helios/config/cache/redis_port',  config.server.redis.port);
  config.server.redis.read.host = yield consul_get('helios/config/cache/redis_read_host',  config.server.redis.read.host);
  config.server.redis.write.host = yield consul_get('helios/config/cache/redis_write_host',  config.server.redis.write.host);
  config.server.redis.read.port = yield consul_get('helios/config/cache/redis_port',  config.server.redis.read.port);
  config.server.redis.write.port = yield consul_get('helios/config/cache/redis_port',  config.server.redis.write.port);
  config.server.redis.gzip_enabled = yield consul_get('helios/node/redis_gzip_enabled',  config.server.redis.gzip_enabled, true);
  config.server.redis.pool_size = yield consul_get('helios/node/redis_pool_size',  config.server.redis.pool_size);
  config.server.redis.master_slave_enabled = yield consul_get('helios/node/redis_master_slave_enabled',  config.server.redis.master_slave_enabled, true);
  config.server.statsd.host = yield consul_get('shared/statsd/host_node',  config.server.statsd.host);
  config.server.statsd.port = yield consul_get('shared/statsd/port',  config.server.statsd.port);
  config.server.api.servers.us.port = yield consul_get('helios/web/frontend/store/port',  config.server.api.servers.us.port);
  config.server.api.servers.ca.port = yield consul_get('helios/web/frontend/canada/port',  config.server.api.servers.ca.port);
  config.server.gtm.enabled = yield consul_get('helios/node/google_tag_manager/enabled',  config.server.gtm.enabled, true);
  config.server.gtm.container_id = yield consul_get('helios/node/google_tag_manager/container_id',  config.server.gtm.container_id);
  config.featureFlagUrl = yield consul_get('helios/config/default/feature_flag_url', config.server.feature_flag_url, false);

  return config;
};

const configure = function (): Config {
  // Loads up configuration data from config directory using the config lib
  const config: Config = require('config');

  // this is needed so cookie prefixes match up between python and node, checkout
  // doesn't work without this.  There is some assumed cookie prefixing/naming
  // that python and node both use that is hard to figure out
  if (config.environment.name === 'localy') config.environment.name = 'development';
  if (config.environment.name === 'stage') config.environment.name = 'awsstage';
  if (config.environment.name === 'production') config.environment.name = 'awsprod';
  config.environment.production = config.isProduction = process.env.NODE_ENV === 'production';

  // Some shortcuts setup from config.coffee
  config['revision'] = process.env.WWW_GIT_REVISION;
  config.debug = !!config.environment.debug;
  config.isDev = is_dev();

  let webSafeConfig: any = null;

  config.toBrowserJSON = function (): Config {
    if (!webSafeConfig) {
      webSafeConfig = _.cloneDeep(config);
      webSafeConfig.server = _.omit(webSafeConfig.server, 'redis');
    }

    return webSafeConfig;
  };

  config._processConfigTree = processConfigTree;

  return config;
};

/**
 * Performs a depth-first-search of the config tree to process the config strings with
 * processConfigString().
 * @param configObject configuration object to convert
 * @returns object a copy of the configuration with each string node run against
 * processConfigString().
 */
const processConfigTree = function (configObject: any): Config {
  for (const key in configObject) {
    if (typeof configObject[key] === 'object' || configObject[key] instanceof Object) {
      processConfigTree(configObject[key]);
    } else if (typeof configObject[key] === 'string' || configObject[key] instanceof String) {
      configObject[key] = processConfigString(configObject[key]);
    }
  }

  return configObject;
};

const bootstrap = function* ({ hideLogs } = { hideLogs: Boolean }) {

  // ENV VARS WE CAN DEFAULT WITH SANE DEFAULTS
  process.env.NODE_ENV = process.env.NODE_ENV || 'localy';
  process.env.PORT = process.env.PORT || 9011;
  process.env.REDIS_HOST = process.env.REDIS_HOST || 'localhost';
  process.env.REDIS_PORT = process.env.REDIS_PORT || 6379;
  process.env.PYTHON_API_HOST = process.env.PYTHON_API_HOST || 'www.wp-local.com';
  process.env.PYTHON_API_PORT = process.env.PYTHON_API_PORT || 9001;
  process.env.PYTHON_API_CANADA_PORT = process.env.PYTHON_API_CANADA_PORT || 9008;
  process.env.LOCAL_IP_ADDRESS = process.env.LOCAL_IP_ADDRESS || '127.0.0.1';
  process.env.NODE_STORE_URL = process.env.NODE_STORE_URL || 'www.wp-local.com';
  process.env.STATIC_URL = process.env.STATIC_URL || process.env.NODE_STORE_URL;
  process.env.NODE_CANADA_URL = process.env.NODE_CANADA_URL || 'ca.wp-local.com';
  process.env.BROWSER_PYTHON_URL = process.env.BROWSER_PYTHON_URL || process.env.PYTHON_API_HOST;
  process.env.WWW_GIT_REVISION = process.env.WWW_GIT_REVISION || Date.now().toString(16);
  // This renders the json files, some of which depend on env consts, so we must call it
  // after setting all the env consts above
  let config = configure();

  // Override any of our configurations with consul kvps if
  // a consul host is provided by the environment
  if (process.env.CONSUL_HOST) {
    process.env.CONSUL_PORT = process.env.CONSUL_PORT || 8500;
    config = yield consulify(config);
  }

  config = setupLocales(config);
  config = processConfigTree(config);
  
  if(!hideLogs) {
    console.log(util.inspect(config, { depth: 5 }));
  }

  FeatureFlags.init(config.featureFlagUrl);

  return config;
};


module.exports = bootstrap;
