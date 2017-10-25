[
  _

  BaseDispatcher
  Logger
] = [
  require 'lodash'

  require '../../common/dispatchers/base_dispatcher'
  require '../logger'
]

log = Logger.get('ModalsDispatcher').log
warn = Logger.get('ModalsDispatcher').warn

DEFAULT_MIN_TIMEOUT = 500  # The minimum time to show a modal.
DEFAULT_MAX_TIMEOUT = 30000
CAPTIONS =
  create:
    customer:
      loading:  'Creating account…'
      success: '✓ Account created!'
    estimate:
      loading: 'Sit tight…we’re getting a few things ready.'
  did:
    logout:
      success: '✓ Already signed out.'
  fill:
    homeTryOn:
      loading: 'Filling Home Try-On…'
  do:
    login:
      loading:  'Signing in…'
      success: '✓ Signed in!'
    logout:
      loading:  'Signing out…'
      success: '✓ Signed out!'
    upload:
      loading:  'Uploading photo…'
      success: '✓ Photo uploaded!'
    submit:
      loading:  'Submitting photo…'
      success: '✓ Photo submitted!'
  destroy:
    address:
      loading:  'Deleting address…'
      success: '✓ Address deleted.'
    cartItem:
      loading:  'Removing item…'
  fetch:
    addresses:
      loading:  'Loading your addresses…'
    account:
      loading:  'Loading account…'
    bookmarks:
      loading:  'Finding your bookmarks…'
    checkout:
      loading:  'Let’s get you some glasses…'
    cart:
      loading:  'Getting your cart…'
    estimate:
      loading:  'Getting a few things ready…'
    orders:
      loading:  'Loading your orders…'
    prescriptions:
      loading:  'Loading prescriptions…'
    stripe:
      loading:  'Loading…'
    quiz:
      loading:  'Calculating, plotting, etc. (JK. Just finding you some frames!)'
      success:  '✓ Success!'
  forgot:
    password:
      loading:  'Sending instructions…'
      success: '✓ Instructions sent!'
  save:
    address:
      loading:  'Saving address…'
      success: '✓ Address saved!'
    customer:
      loading:  'Saving profile…'
      success: '✓ Profile saved!'
    information:
      loading:  'Saving…'
      success: '✓ Saved!'
    password:
      loading:  'Changing password…'
      success: '✓ Password changed!'
    prescription:
      loading:  'Saving…'
      success: '✓ Saved!'
  update:
    total:
      loading: 'Updating total…'
      error: '× Oops. There was a problem updating your order.'
  submit:
    order:
      loading: 'Placing order…'
      success: '✓ Success!'
      error: '× Oops. There was a problem placing your order.'
  upload:
    prescription:
      loading:  'Uploading image…'
      success: '✓ Image saved!'

class ModalDispatcher extends BaseDispatcher
  channel: -> 'modals'

  getInitialStore: ->
    queue: []
    count: 0
    modal: {}

  nextModal: ->
    now = Date.now()

    clearTimeout @timeout

    if @store.modal
      if now < @store.modal.minTimeoutAt
        # We're showing a modal, but we haven't shown it long enough to make
        # changes.
        @timeout = _.delay @nextModal.bind(@), @store.modal.minTimeoutAt - now
        return

      nextModal = _.first(@store.queue)
      sameQueuedId = nextModal? and @store.modal.id is nextModal.id

      if now >= @store.modal.maxTimeoutAt or sameQueuedId
        # The modal we are showing has timed out, it should be discarded.
        if (now - @store.modal.shownAt) >= DEFAULT_MAX_TIMEOUT
          warn "modal with id '#{@store.modal.id}' timed out"
        @setStore modal: {}

    if _.size(@store.queue) is 0
      # Nothing is queued to be next.
    else if _.isEmpty(@store.modal)
      modal = _.first(@store.queue)

      @replaceStore(
        queue: _.tail(@store.queue)
        count: @store.count + 1
        modal:
          id: modal.id
          caption: modal.caption
          shownAt: now
          minTimeoutAt: now + modal.minTimeout
          maxTimeoutAt: now + modal.maxTimeout
          maxTimeout: modal.maxTimeout
          minTimeout: modal.minTimeout
          mode: modal.mode
      )

      @timeout = _.delay @nextModal.bind(@), modal.maxTimeout

  requests:
    isShowing: (id) -> _.get(@store.modal, 'id') is id

  commands:
    show: (options) ->
      _.defaults options,
        mode: 'loading'
        minTimeout: DEFAULT_MIN_TIMEOUT
        maxTimeout: if options.mode is 'loading'
          DEFAULT_MAX_TIMEOUT
        else
          DEFAULT_MIN_TIMEOUT

      options.minTimeout = Math.min(options.minTimeout, options.maxTimeout)

      if options.id?
        # Find modal caption based on id.
        splitId = _.kebabCase(options.id).split('-')
        action = _.first(splitId)
        target = _.camelCase(_.tail(splitId))
        path = "#{action}.#{target}.#{options.mode}"
        caption = _.get CAPTIONS, path

      queue = @store.queue
      modal = @store.modal

      if _.isEmpty(caption)
        @command 'hide', options
        return

      newModal =
        id: options.id
        mode: options.mode
        minTimeout: options.minTimeout
        maxTimeout: options.maxTimeout
        caption: caption

      if options.id is modal.id
        modal.maxTimeout = Date.now()
        queue.unshift newModal
      else
        queue.push newModal

      @replaceStore modal: modal, queue: queue
      @nextModal()

    hide: (options) ->
      modal = @store.modal

      queue = _.filter @store.queue, (queuedModal) ->
        options.id isnt queuedModal.id

      modal.maxTimeoutAt = Date.now() if modal.id is options.id

      @replaceStore modal: modal, queue: queue
      @nextModal()

module.exports = ModalDispatcher
