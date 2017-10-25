"use strict";

const BaseCollectionHandler = require("hedeia/server/handlers/base_collection_handler");

class PrescriptionServicesHandler extends BaseCollectionHandler {
  name() {
    return "PrescriptionServices";
  }
}

module.exports = PrescriptionServicesHandler;
