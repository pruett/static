[
  React

  LayoutDefault
  Mixins
] = [
  require 'react/addons'

  require 'components/layouts/layout_default/layout_default'
  require 'components/mixins/mixins'

  require './error.scss'
]

module.exports = React.createClass
  BLOCK_CLASS: 'c-error-template'

  propTypes:
    appState: React.PropTypes.shape
      location: React.PropTypes.shape
        error: React.PropTypes.shape
          message: React.PropTypes.string
          statusCode: React.PropTypes.number
          stack: React.PropTypes.string

  getDefaultProps: ->
    appState:
      location:
        error:
          message: 'Internal Server Error'
          statusCode: 500
          stack: ''

  mixins: [
    Mixins.context
    Mixins.classes
  ]

  getStaticClasses: ->
    block: "
      #{@BLOCK_CLASS}
      u-tac
    "
    statusCode: 'u-fs12 u-ffs'
    headline: 'u-fs30 u-ffs'
    errorMessage: 'u-fs16 u-ffs u-mb24 u-mw960 u-m0a'
    stack: 'u-fs16 u-ffs u-mb24'

  render: ->
    classes = @getClasses()
    errorData = @props.appState.location.error

    <LayoutDefault {...@props}>
      <div className=classes.block>
        <p className=classes.statusCode>{errorData.statusCode}</p>
        <h1 className=classes.headline>Our Apologies</h1>
        <p className=classes.errorMessage>{errorData.message}</p>
        <p>{'Return '}<a href='/' onclick='try{window.history.back();}catch(e){}'>to the previous page</a>
          {' or go back to our '}<a href='/'>homepage</a>.
        </p>
        {if errorData.stack
          <pre className=classes.stack children=errorData.stack />}
      </div>
    </LayoutDefault>
