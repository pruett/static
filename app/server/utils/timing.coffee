module.exports =
  # Helper methods for reporting on the timing of functions.
  start: ->
    # Return a node-specific high-resolution timestamp tuple.
    # https://nodejs.org/api/process.html#process_process_hrtime
    process.hrtime()

  since: (start) ->
    # Accepts a plain number (assumed to be a Date.getTime() milliseconds) or a
    # node high-resolution timestamp tuple. Returns the number of milliseconds
    # 'since' the start argument.
    if typeof(start) is 'number'
      ms = (new Date().getTime() - start).toFixed(3)
    else
      diff = process.hrtime(start)
      ms = (diff[0] * 1000 + diff[1] * 1e-6).toFixed(3)
    ms
