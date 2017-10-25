[
  _
  Radio

  Logger
] = [
  require 'lodash'
  require 'backbone.radio'

  require './logger'
]

log = Logger.get('Radio').log

_.assign Radio,
  request: (channelName) ->
    channel = Radio.channel(channelName)
    channel.request.apply channel, _.tail(arguments)

  command: (channelName) ->
    channel = Radio.channel(channelName)
    channel.request.apply channel, _.tail(arguments)

  freezeChannels: ->
    Radio.__frozen = true

  channel: (channelName) ->
    if Radio.__frozen and not _.includes(_.keys(Radio._channels), channelName)
      throw new Error "new channels are not allowed [#{channelName}]"

    if Radio._channels[channelName]
      Radio._channels[channelName]
    else
      Radio._channels[channelName] = new Radio.Channel(channelName)

  reset: (channelName) ->
    Radio.__frozen = false
    channels = if not channelName then @_channels else [@_channels[channelName]]
    _.invoke channels, 'reset'


module.exports = Radio
