[
  _
  React

  ModalWrapper
] = [
  require 'lodash'
  require 'react/addons'

  require 'components/molecules/modals/wrapper/wrapper'

  require './loader.scss'
]

ReactCSSTransitionGroup = React.addons.CSSTransitionGroup

module.exports = React.createClass
  BLOCK_CLASS: 'c-modal-loader'

  propTypes:
    caption: React.PropTypes.string
    mode: React.PropTypes.string

  getDefaultProps: ->
    caption: ''
    mode: 'loading'

  render: ->
    <ModalWrapper cssModifier='-loader'>

      <div className="#{@BLOCK_CLASS} u-tac">

        <ReactCSSTransitionGroup transitionName='-transition-fade' transitionLeave=false>

          <div key=@props.caption
            children=@props.caption
            className="#{@BLOCK_CLASS}__text u-reset u-fs16 u-fws u-mb24"/>

          {if @props.mode is 'loading'
            <div className="#{@BLOCK_CLASS}__bar">
              <div className="#{@BLOCK_CLASS}__fill" />
            </div>}

        </ReactCSSTransitionGroup>
      </div>

    </ModalWrapper>
