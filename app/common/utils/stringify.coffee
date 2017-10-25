module.exports = (obj) ->
  # Unicode safe JSON.
  # https://gist.github.com/RandomEtc/2657669
  JSON.stringify(obj)
    .replace /\//g, (c) ->
      '\\/'
    .replace /[\u003c\u003e]/g, (c) ->
      '\\u' + ('0000' + c.charCodeAt(0).toString(16)).slice(-4).toUpperCase()
    .replace /[\u007f-\uffff]/g, (c) ->
      '\\u' + ('0000' + c.charCodeAt(0).toString(16)).slice(-4)
