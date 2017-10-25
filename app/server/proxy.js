"use strict";

var log = require('hedeia/server/logger').get('Proxy').log;

var updateCookieDomain = function (res) {
  if (!res.headers['set-cookie']) return;
  return res.headers['set-cookie'].map( function(cookie) {
    return cookie.split(';').map(function (cookiePart) {
      if (cookiePart.includes('Domain=')) return ' Domain=' + Config.get('server.config.cookie_domain');
      if (cookiePart.includes('secure') && Config.isDev) return '';
      return cookiePart;
    }).join(';');
  },[]);
};

var onResponse = function (err, res, request, reply, settings, ttl) {
  log([
    'Proxy',
    res.statusCode,
    request.method.toUpperCase(),
    request.path,
    request.info.remoteAddress,
    (new Date() - request.info.received) + 'ms'].join(' '));
  if (err) return reply(res);
  res.headers['set-cookie'] = updateCookieDomain(res);
  reply(res);
};

var proxyHandler = function (request, reply) {
  reply.proxy({
      host: Config.get('server.api.servers.us.host'),
      port: Config.get('server.api.servers.us.port'),
      protocol: Config.get('server.api.servers.us.protocol'),
      passThrough: true,
      xforward: true,
      onResponse: onResponse,
      timeout: 10000
  });
};


var registerHandlers = function(server) {
  server.route({
      method: '*',
      path: '/api/v2/{endpoint*}',
      config: {
        handler: proxyHandler,
        payload: {
          parse: false
        }
      }
  });
};

var init = function (server) {
  server.register({
      register: require('h2o2')
  }, function (err) {
      if (err) {
          console.log('Failed to load h2o2');
      }
      registerHandlers(server);
  });
};


module.exports = {
  init: init
};
