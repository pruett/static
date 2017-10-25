Logger = require '../common/logger'

Logger.setup(
  # Preferred browser logging format.
  relativeTime: true
  style: 'justified'
  historyMax: 100
)

module.exports = Logger
