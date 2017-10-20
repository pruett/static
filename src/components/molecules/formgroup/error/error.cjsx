[
  _
  React

  Error
] = [
  require 'lodash'
  require 'react/addons'

  require 'components/atoms/forms/error/error'

  require './error.scss'
]

ReactCSSTransitionGroup = React.addons.CSSTransitionGroup

module.exports = React.createClass
  BLOCK_CLASS: 'c-formgroup-error'

  propTypes:
    txtError: React.PropTypes.string

  getDefaultProps: ->
    txtError: ''

  render: ->
    <ReactCSSTransitionGroup transitionName='error'>
      {if not _.isEmpty(@props.txtError)
        <div className="#{@BLOCK_CLASS}" key='error'>
          <div className="#{@BLOCK_CLASS}__text">
            <Error children=@props.txtError />
          </div>
        </div>}
    </ReactCSSTransitionGroup>
