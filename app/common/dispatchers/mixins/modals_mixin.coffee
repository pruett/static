module.exports =
  modals: (options) ->
    if options.isShowing
      @requestDispatcher 'modals', 'isShowing', options.isShowing
    else if options.success
      @commandDispatcher 'modals', 'show', id: options.success, mode: 'success'
    else if options.loading
      @commandDispatcher 'modals', 'show', id: options.loading, mode: 'loading'
    else if options.error
      @commandDispatcher 'modals', 'hide', id: options.error
