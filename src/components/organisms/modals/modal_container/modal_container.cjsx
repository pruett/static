[
  _
  React

  ModalLoader

  Mixins
] = [
  require 'lodash'
  require 'react/addons'

  require 'components/molecules/modals/loader/loader'

  require 'components/mixins/mixins'
]

ReactCSSTransitionGroup = React.addons.CSSTransitionGroup

module.exports = React.createClass

  mixins: [
    Mixins.dispatcher
  ]

  receiveStoreChanges: -> [
    'modals'
  ]

  render: ->
    currentModal = @getStore('modals').modal or {}

    <ReactCSSTransitionGroup transitionName='-transition-fade'>
      {if not _.isEmpty(currentModal.caption)
        <ModalLoader {...currentModal} />}
    </ReactCSSTransitionGroup>
