"use strict";

const SingleEntryDependency = require("webpack/lib/dependencies/SingleEntryDependency.js");
const toposort = require("toposort");
const _ = require("lodash");

function StaticRenderPlugin(data = []) {
  this.data = data;
}

StaticRenderPlugin.prototype.apply = function(compiler) {
  const plugin = this;

  compiler.plugin("make", (compilation, cb) => {
    plugin.data.map(x => {
      compilation.addEntry(
        compiler.context,
        new SingleEntryDependency(x.entry),
        x.chunkName,
        cb
      );
    });
  });

  compiler.plugin("emit", (compilation, cb) => {
    const allChunks = compilation.getStats().toJson().chunks;
    const chunks = plugin.sortChunks(allChunks);
    const assets = plugin.getAssets(compilation, chunks);
    cb();
  });
};

StaticRenderPlugin.prototype.sortChunks = function(chunks) {
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

StaticRenderPlugin.prototype.getAssets = function(compilation, chunks) {
  // debugger;
  compilation.assets["terms-of-use/index.html"] = {
    source: () => "content",
    size: () => 10
  };
};

module.exports = StaticRenderPlugin;
