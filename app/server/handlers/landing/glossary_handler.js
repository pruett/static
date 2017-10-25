"use strict";

const BaseCollectionHandler = require("hedeia/server/handlers/base_collection_handler");

class GlossaryHandler extends BaseCollectionHandler {
  name() {
    return "Glossary";
  }

  prefetch() {
    return [
      "/api/v2/variations/eyewear-a-z/callout",
      "/api/v2/variations/eyewear-a-z/definitions"
    ];
  }
}

module.exports = GlossaryHandler;
