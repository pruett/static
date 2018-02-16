import fetch from "isomorphic-fetch";

const isObject = obj => obj instanceof Object;
const isPromise = obj => typeof obj.then === "function";

const promisifiedMap = ({ remoteData = false, localData = false } = {}) => {
  if (!remoteData && !localData) return;
  if (!remoteData && localData) return localData;

  const promisified = Object.entries(remoteData).reduce(
    (acc, [key, { endpoint, transformation }]) => ({
      ...acc,
      [key]: fetch(endpoint).then(res => res.json())
    }),
    localData || {}
  );

  debugger;
  return resolveAllDeep(promisified);
};

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
      ]).then(([acc, value]) => {
        debugger;
        return { ...acc, [key]: value };
      }),
    Promise.resolve({})
  );

const fetchData = obj => {
  // const promiseObj = mapDeepIf(
  //   x => x.toString().includes("http"),
  //   x =>
  //     fetch(x)
  //       .then(res => res.json())
  //       .then(json => Promise.resolve(json))
  //       .catch(_ => Promise.resolve(x)),
  //   obj
  // );

  // debugger;
  const myPromises = promisifiedMap(obj);
  debugger;

  // return resolveAllDeep(promiseObj);
};

const resolveRemoteData = obj => {
  obj.remoteData.reduce((acc, { endpoint, key, transformation }) => {});
};

const fetchComponentData = async path => {
  const dataImport = await import(path);
  return await fetchData(dataImport.default);
};

export { fetchData, fetchComponentData };
