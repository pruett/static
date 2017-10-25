'use strict';

import { StaticValueStrategyParams, CutoverStrategyParams } from './validators';


export abstract class FeatureFlagStrategy {
  /**
   * The run the main logic of the Feature Flag strategy.
   * @param callback Callback for when the Feature Flag is evaluated or
   *   fails to be evaluated.
   * @param params Optional parameters dependent on the strategy.
   */
  public abstract evaluate(callback: (error: string|null, featureValue: boolean) => void, ...params: any[]): void;
}


/**
 * Your basic Feature Flag strategy.
 */
export class StaticValueStrategy extends FeatureFlagStrategy {
  protected value: boolean;

  constructor(params: StaticValueStrategyParams) {
    super();
    this.value = params.value;
  }

  /**
   * @param callback See parent class.
   * @param params Empty
   */
  public evaluate(callback: (error: string|null, featureValue: boolean) => void, ...params: any[]) {
    callback(null, this.value);
  }
}

/**
 * The value returned by this Feature Flag strategy is dependent on
 * when the Feature is called.
 */
export class CutoverStrategy extends FeatureFlagStrategy {
  protected valueBefore: boolean;
  protected valueAtAndAfter: boolean;
  protected cutover: Date;

  constructor(params: CutoverStrategyParams) {
    super();
    this.valueBefore = params.value_before;
    this.valueAtAndAfter = params.value_at_and_after;
    this.cutover = new Date(params.cutover);
  }

  /**
   * @param callback See parent class.
   * @param params Optional Date object for simulating the call time.
   */
  public evaluate(callback: (error: string|null, featureValue: boolean) => void, ...params: any[]) {
    if (params && params.length >= 1) {
      this.doEvaluate(callback, params[0] as Date);
    } else {
      this.doEvaluate(callback);
    }
  }

  protected doEvaluate(callback: (error: string|null, featureValue: boolean) => void, time?: Date) {
    if (!time) {
      time = new Date();
    }

    if (!(time instanceof Date)) {
      callback('Provided time is not of type Date', false);
      return;
    }

    if (time < this.cutover) {
      callback(null, this.valueBefore);
    } else {
      callback(null, this.valueAtAndAfter);
    }
  }
}
