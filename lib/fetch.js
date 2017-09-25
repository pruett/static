import fetch from "node-fetch";

export default async url => {
  const response = await fetch(url);
  return await response.json();
};
