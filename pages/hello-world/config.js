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
    foo: {
      endpoint: "https://api.endpoint.com/thing",
      transformation: data => filter(data => data > 0)
    },
    bar: {
      endpoint: "https://api.endpoint.com/thing2"
    }
  },
  localData: {
    foo: "foo",
    bar: "bar",
    baz: val => `${val}!!`
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
