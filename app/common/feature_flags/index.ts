/**
 * Feature Flags module.
 *
 * See wiki for information.
 * https://github.com/WarbyParker/helios/wiki/Feature-Flags-System
 */

'use strict';

const _ = require('lodash');
const AWS = require('aws-sdk');
const fs = require('fs');
const url = require('url');

import { StaticValueStrategyParams, CutoverStrategyParams, FeatureParams, isFeatureParams } from './validators';
import { FeatureFlagStrategy, StaticValueStrategy, CutoverStrategy } from './strategies';

type FeatureCacheType = {[key: string]: Feature};
const featureCache: FeatureCacheType = {};

let featureFlagUrl: string|null = null;


/**
 * Main accessor method for getting the value of a Feature Flag. Strategy-specific optional
 * parameters after the callback may be passed in depending on the strategy.
 *
 * @param featureName The name of the Feature Flag.
 * @param callback Callback for when the Feature Flag is evaluated or
 *   fails to be evaluated.
 * @param params Optional parameters dependent on the strategy.
 */
export function get(featureName: string, callback: (error: string|null, featureValue: boolean) => any, ...params: any[]): void {
  getFeature(featureName, function(error: string|null, feature: Feature|null): void {
    if (error) {
      callback(error, false);
      return;
    }

    if (feature != null) {
      feature.evaluate(callback, params);
    } else {
      throw 'Fatal error';
    }
  });
}


export function init(url: string): void {
  featureFlagUrl = url;
}


/**
 * Responsible for getting the Feature Flag definition.
 * @param featureName The name of the Feature Flag.
 * @param callback Callback for when the Feature Flag is evaluated or
 *   fails to be evaluated.
 */
function getFeature(featureName: string, callback: (error: string|null, feature: Feature|null) => void): void {
  if (_.has(featureCache, featureName)) {
    callback(null, featureCache[featureName]);
    return;
  }

  const parsedUrl = url.parse(featureFlagUrl);

  if (parsedUrl.protocol == 's3:') {
    const path = parsedUrl.pathname.replace(/^\//, '');  // No leading slashes
    getFeatureFromS3(parsedUrl.host, path, featureName, callback);
  } else if (parsedUrl.protocol == 'file:') {
    const path = parsedUrl.pathname.replace(/\/$/, '');  // No trailing slashes
    getFeatureFromFileSystem(path, featureName, callback);
  } else if (parsedUrl.protocol == 'null:') {
    callback(null, new FalseFeature());  // Null initialization always returns false
  } else {
    throw `Protocol ${parsedUrl.protocol} is unsupported`;
  }
}

/**
 * Responsible for getting the Feature Flag definition from Secret Agent / AWS S3.
 * @param bucket The bucket to search in.
 * @param path The path to the Feature Flag directory.
 * @param featureName The name of the Feature Flag.
 * @param callback Callback for when the Feature Flag is evaluated or
 *   fails to be evaluated.
 */
function getFeatureFromS3(bucket: string, path: string, featureName: string, callback: (error: string|null, feature: Feature|null) => void): void {
  const s3 = new AWS.S3();
  const key = `${path}/${featureName}`;

  const getParams = {
    Bucket: bucket,
    Key: key
  };

  s3.getObject(getParams, function(error: Error, data: any): void {
    if (error) {
      callback(`Error fetching from AWS: ${error.message} (bucket=${bucket} key=${key})`, null);
      return;
    }

    try {
      featureCache[featureName] = Feature.fromObject(JSON.parse(data.Body.toString()));
      callback(null, featureCache[featureName]);
    } catch (e) {
      callback('Error parsing from secret-agent: ' + e.message, null);
    }
  });
}

/**
 * Responsible for getting the Feature Flag definition from the file system.
 * @param path The path to the Feature Flag directory.
 * @param featureName The name of the Feature Flag.
 * @param callback Callback for when the Feature Flag is evaluated or
 *   fails to be evaluated.
 */
function getFeatureFromFileSystem(path: string, featureName: string, callback: (error: string|null, feature: Feature|null) => void): void {
  const filePath = `${path}/${featureName}`;

  fs.readFile(filePath, function(error: Error, bodyJson: any): void {
    if (error) {
      callback(`Error reading from file: ${error.message} (filePath=${filePath})`, null);
      return;
    }

    try {
      featureCache[featureName] = Feature.fromObject(JSON.parse(bodyJson));
      callback(null, featureCache[featureName]);
    } catch (e) {
      callback('Error parsing: ' + e.message, null);
    }
  });
}

/**
 * Data model and methods for Feature Flags.
 */
export class Feature {
  public name: string;
  public strategy: FeatureFlagStrategy;
  public meta: object;

  constructor(name: string, strategy: FeatureFlagStrategy, meta: object) {
    this.name = name;
    this.strategy = strategy;
    this.meta = meta;
  }

  /**
   * Runs the Feature Flag's strategy logic.
   * @param callback Callback for when the Feature Flag is evaluated or
   *   fails to be evaluated.
   * @param params Optional parameters dependent on the strategy.
   */
  public evaluate(callback: (error: string, featureValue: boolean) => any, ...params: any[]): void {
    this.strategy.evaluate(callback, params);
  }

  /**
   * Unmarshall a plain object into a Feature.
   * @param params The plain object to unmarshall.
   * @returns {Feature} The Feature representation of the data.
   */
  public static fromObject(params: object): Feature {
    let strategy = null;

    if (!isFeatureParams(params)) {
      throw 'Not a valid feature definition';
    }

    let featureParams = params as FeatureParams;

    switch (featureParams.strategy.type) {
      case 'static':
        strategy = new StaticValueStrategy(featureParams.strategy as StaticValueStrategyParams);
        break;
      case 'cutover':
        strategy = new CutoverStrategy(featureParams.strategy as CutoverStrategyParams);
        break;
      default:
        throw `No such strategy "${featureParams.strategy.type}"`;
    }

    return new Feature(featureParams.name, strategy, featureParams.meta);
  }
}

class FalseFeature extends Feature {
  constructor() {
    super("FalseFeature", new StaticValueStrategy({type: 'static', value: false}), {});
  }
}
