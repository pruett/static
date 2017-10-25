"use strict";

const BaseCollectionHandler = require("hedeia/server/handlers/base_collection_handler");

class IntakeFormHandler extends BaseCollectionHandler {
  name() {
    return "IntakeForm";
  }
}

module.exports = IntakeFormHandler;
