const _ = require("lodash");
const React = require("react");
const { renderToString, renderToStaticMarkup } = require("react-dom/server");
const SingleEntryDependency = require("webpack/lib/dependencies/SingleEntryDependency.js");
const toposort = require("toposort");
const RawSource = require("webpack-sources/lib/RawSource");

function StaticRenderPlugin(data = []) {
  this.data = data;
}

StaticRenderPlugin.prototype.apply = function(compiler) {
  const plugin = this;

  compiler.plugin("make", (compilation, cb) => {
    //* TODO: Map over entire data file and create new Dependency
    compilation.addEntry(
      compiler.context,
      new SingleEntryDependency(plugin.data[0].entry),
      plugin.data[0].chunkName,
      cb
    );
  });

  compiler.plugin("emit", (compilation, cb) => {
    const allChunks = compilation.getStats().toJson().chunks;
    const chunks = sortChunks(allChunks);
    const assets = plugin.getAssets(compilation, chunks);
    cb();
  });
};

var sortChunks = function sortChunks(chunks) {
  if (!chunks) {
    return chunks;
  }

  // We build a map (chunk-id -> chunk) for faster access during graph building.
  var nodeMap = {};

  chunks.forEach(chunk => {
    nodeMap[chunk.id] = chunk;
  });

  // Next, we add an edge for each parent relationship into the graph
  var edges = [];

  chunks.forEach(chunk => {
    if (chunk.parents) {
      // Add an edge for each parent (parent -> child)
      chunk.parents.forEach(function(parentId) {
        // webpack2 chunk.parents are chunks instead of string id(s)
        var parentChunk = _.isObject(parentId) ? parentId : nodeMap[parentId];
        // If the parent chunk does not exist (e.g. because of an excluded chunk)
        // we ignore that parent
        if (parentChunk) {
          edges.push([parentChunk, chunk]);
        }
      });
    }
  });
  // We now perform a topological sorting on the input chunks and built edges
  return toposort.array(chunks, edges);
};

StaticRenderPlugin.prototype.getAssets = function getAssets(
  compilation,
  chunks
) {
  debugger;

  compilation.assets[`${this.data[0].outputFolder}/index.html`] = {
    source: () => `<!doctype html>\n<div>hello</div>`,
    size: () => 10
  };
};

module.exports = StaticRenderPlugin;
