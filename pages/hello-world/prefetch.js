import { fetchData } from "../../lib/utils/dataFetchingUtils";

export default const prefetch = (datafile) => {
  import(datafile).then(data => {
    fetchData(data.default).then(res => {
      return res
    });
  });
}
