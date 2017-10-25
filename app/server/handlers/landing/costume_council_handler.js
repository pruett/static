"use strict";

const BaseCollectionHandler = require("hedeia/server/handlers/base_collection_handler");

class CostumeCouncilHandler extends BaseCollectionHandler {
  name() {
    return "CostumeCouncil";
  }
}

module.exports = CostumeCouncilHandler;
