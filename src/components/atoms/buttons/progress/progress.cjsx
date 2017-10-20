[
  _
  React
] = [
  require 'lodash'
  require 'react/addons'

  require './progress.scss'
]

ReactCSSTransitionGroup = React.addons.CSSTransitionGroup

module.exports = React.createClass

  BLOCK_CLASS: 'c-cta-progress-button'

  propTypes:
    mode: React.PropTypes.oneOf ['default', 'confirm', 'loading', 'complete']

    children: React.PropTypes.node

    tag: React.PropTypes.oneOf ['a', 'div', 'button']

    txtConfirm: React.PropTypes.string
    txtLoading: React.PropTypes.string
    txtComplete: React.PropTypes.string
    txtPostive: React.PropTypes.string
    txtNegative: React.PropTypes.string

    cssUtility: React.PropTypes.string
    cssUtilityPositive: React.PropTypes.string
    cssUtilityNegative: React.PropTypes.string

    cssModifier: React.PropTypes.string

  getDefaultProps: ->
    mode: 'default'  # default|confirm|loading|complete

    children: 'Delete Address'

    txtConfirm: 'Are you sure?'
    txtLoading: 'Deleting...'
    txtComplete: '✓'
    txtPositive: 'YES'
    txtNegative: 'NO'

    tag: 'button'

    cssUtility: 'u-button -button-blue'
    cssUtilityPositive: 'u-button -button-blue -button-small -button-left
      u-reset u-fs12 u-fws'
    cssUtilityNegative: 'u-button -button-small -button-left
      u-reset u-fs12 u-fws'

    cssModifier: ''

  render: ->
    cssMode = "#{@BLOCK_CLASS}__text #{@BLOCK_CLASS}__text--#{@props.mode}"

    <@props.tag {...@props}
      className={[
        @BLOCK_CLASS
        @props.cssUtility
        "-#{@props.mode}"
        @props.cssModifier if @props.cssModifier
      ].join ' '}>

      <div className={"#{@BLOCK_CLASS}__content"}>
        <ReactCSSTransitionGroup transitionName='slide'>

          {switch @props.mode
            when 'complete'
              <div key={@props.mode} className={cssMode}>
                {@props.txtComplete}
              </div>

            when 'confirm'
              <div key={@props.mode} className={cssMode}>
                <span className="#{@BLOCK_CLASS}__question">
                  {@props.txtConfirm}
                </span>
                <span className="#{@BLOCK_CLASS}__answers">
                  <div className="#{@BLOCK_CLASS}__answer">
                    <a className="#{@BLOCK_CLASS}__positive #{@props.cssUtilityPositive}">
                      {@props.txtPositive}
                    </a>
                  </div>
                  <div className="#{@BLOCK_CLASS}__answer">
                    <a className="#{@BLOCK_CLASS}__negative #{@props.cssUtilityNegative}">
                      {@props.txtNegative}
                    </a>
                  </div>
                </span>
              </div>

            when 'loading'
              <div key={@props.mode} className={cssMode}>
                {@props.txtLoading}
              </div>

            when 'default'
              <div key={@props.mode} className={cssMode}>
                {@props.children}
              </div>}

        </ReactCSSTransitionGroup>
      </div>
    </@props.tag>
