[
  _
  React

  CTA
  LayoutMinimal
  ModalAlert

  Mixins
] = [
  require 'lodash'
  require 'react/addons'

  require 'components/atoms/buttons/cta/cta'
  require 'components/layouts/layout_minimal/layout_minimal'
  require 'components/organisms/modals/modal_alert/modal_alert'

  require 'components/mixins/mixins'
]

ReactCSSTransitionGroup = React.addons.CSSTransitionGroup

module.exports = React.createClass
  BLOCK_CLASS: 'c-pd'

  statics:
    route: ->
      path: '/pd/error/photo'
      handler: 'Pd'
      bundle: 'pd'

  mixins: [
    Mixins.context
    Mixins.dispatcher
  ]

  receiveStoreChanges: -> [
    'capabilities'
  ]

  getDefaultProps: ->
    heading: 'Oops, we couldn’t read that photo—let’s try again!'
    buttonText: 'Got it.'

  render: ->
    <LayoutMinimal {...@props}>
      <div className='u-dn u-db--960'>
        <ModalAlert
          txtHeading=@props.heading
          txtConfirm=@props.buttonText
          routeConfirm='/pd/webcam'>
          <p>
            This time, make sure:
          </p>
          <ul>
            <li>The image is well-lit</li>
            <li>The angle of the photo is straight-on</li>
            <li>We can see your eyes and the magnetic strip on your card</li>
          </ul>
        </ModalAlert>
      </div>
      <div className='u-dn--960'>
        <ModalAlert
          txtHeading=@props.heading
          txtConfirm=@props.buttonText
          routeConfirm='/pd/instructions/photo'>
          <p>
            This time, make sure:
          </p>
          <ul>
            <li>The image is well-lit</li>
            <li>The angle of the photo is straight-on</li>
            <li>We can see your eyes and the magnetic strip on your card</li>
          </ul>
        </ModalAlert>
      </div>
    </LayoutMinimal>
