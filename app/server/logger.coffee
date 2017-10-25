Logger = require 'hedeia/common/logger'

Logger.setup(
  # Preferred server logging format.
  level: 'log'
  relativeTime: false
  style: 'json'
  historyMax: 0  # Don't store history on the server.
)

module.exports = Logger
