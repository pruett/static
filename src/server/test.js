import fs from "fs";
import path from "path";
import express from "express";
import minimist from "minimist";
import http from "http";
import webpack from "webpack";
import webpackConfig from "../../webpack.config.development";
import renderMarkup from "../utils/staticMarkup";

const pages = fs.readdirSync(path.join(__dirname, "..", "..", "pages"));
console.log("hello: ", pages);
