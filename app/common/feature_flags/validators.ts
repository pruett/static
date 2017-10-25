export interface CutoverStrategyParams {
  type: string;
  value_before: boolean;
  value_at_and_after: boolean;
  cutover: string;
}

export interface StaticValueStrategyParams {
  type: string;
  value: boolean;
}


export interface FeatureParams {
  strategy: StaticValueStrategyParams | CutoverStrategyParams;
  name: string;
  meta: object;
}

/**
 * Returns true iff the object provided is in the shape of a CutoverStrategyParams.
 */
export function isCutoverStrategyParams(x: any): x is CutoverStrategyParams {
  return typeof x.type === 'string'
    && typeof x.value_before === 'boolean'
    && typeof x.value_at_and_after === 'boolean'
    && typeof x.cutover === 'string';
}

/**
 * Returns true iff the object provided is in the shape of a StaticValueStrategyParams.
 */
export function isStaticValueStrategyParams(x: any): x is StaticValueStrategyParams {
  return typeof x.type === 'string'
    && typeof x.value === 'boolean';
}

/**
 * Returns true iff the object provided is in the shape of a FeatureParams.
 */
export function isFeatureParams(x: any): x is FeatureParams {
  return typeof x.name === 'string'
    && typeof x.meta === 'object'
    && (isCutoverStrategyParams(x.strategy) || isStaticValueStrategyParams(x.strategy));
}
