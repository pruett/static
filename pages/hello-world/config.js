/*
 *
 *
 *
 *
 *
 *
 */

import { filter } from "lodash";

// interface IRemoteData {
//   endpoint: string;
//   key: string;
//   transformation: function;
// }

// interface IConfig {
//   remoteData: Array<RemoteDataConfig>;
//   localData: object;
// }

export default {
  remoteData: {
    remoteA: {
      endpoint: "https://jsonplaceholder.typicode.com/users/1",
      transformation: data => filter(data => data > 0)
    },
    remoteB: {
      endpoint: "https://jsonplaceholder.typicode.com/users/2",
      transformation: data => filter(data => data > 0)
    }
  },
  localData: {
    localA: "localA",
    localB: "localB",
    localC: { localD: "localD" }
  },
  pureStatic: false
};

/*
{
  thing: a: 'a' ...,
  foo: 'foo',
  bar: 'bar',
  baz: '(something)!!'
}
 */
