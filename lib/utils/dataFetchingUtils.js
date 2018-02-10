import fetch from "isomorphic-fetch";

const isObject = obj => obj instanceof Object;

const isPromise = obj => typeof obj.then === "function";

const mapDeepIf = (pr, fn, obj) =>
  Object.entries(obj).reduce(
    (acc, [key, value]) => ({
      ...acc,
      [key]: isObject(value)
        ? mapDeepIf(pr, fn, value)
        : pr(value) ? fn(value) : value
    }),
    {}
  );

const resolveAllDeep = obj =>
  Object.entries(obj).reduce(
    (acc, [key, value]) =>
      Promise.all([
        acc,
        isPromise(value)
          ? value
          : isObject(value) ? resolveAllDeep(value) : Promise.resolve(value)
      ]).then(([acc, value]) => ({ ...acc, [key]: value })),
    Promise.resolve({})
  );

const fetchData = obj => {
  const promiseObj = mapDeepIf(
    x => x.toString().includes("http"),
    x =>
      fetch(x)
        .then(res => res.json())
        .then(json => Promise.resolve(json))
        .catch(_ => Promise.resolve(x)),
    obj
  );

  return resolveAllDeep(promiseObj);
};

export { fetchData };
