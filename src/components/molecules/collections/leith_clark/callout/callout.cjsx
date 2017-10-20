React = require 'react/addons'
_ = require 'lodash'

Callout = require 'components/molecules/collections/leith_clark/callout/callout'

Mixins = require 'components/mixins/mixins'


module.exports = React.createClass

  mixins: [
    Mixins.image
    Mixins.classes
  ]

  propTypes:
    content: React.PropTypes.object
    header: React.PropTypes.string
    body: React.PropTypes.string

  getDefaultProps: ->
    content: {}
    second: false
    header: ''
    body: ''

  getStaticClasses: ->
    block: '
      u-mw1440
      u-mla u-mra
      u-mb48
      u-oh
      u-ml36--600 u-mr36--600
      u-mr48--900 u-ml48--900
      u-mr60--1200 u-ml60--1200
    '
    row: '
      u-grid__row
      u-tac
    '
    column: '
      u-grid__col u-w12c
      u-pr
      u-bg-leith-clark
    '
    copyWrapper: '
      u-w8c--600
      u-l2c--600
      u-mla u-mra
      u-pt60 u-pb60
      u-pt72--600 u-pb72--600
      u-pt96--900 u-pb96--900
    '
    header: '
      u-fs20 u-ls2
      u-lh30 u-lh50--900
      u-fs40--900
      c-leith-clark__copy
      u-type-leith-clark
      u-mla u-mra
    '
    body: '
      u-color--black
      u-lh24
      u-fs18
      u-mla u-mra
      u-w9c u-w12c--600 u-w11c--1200
    '
    flower: '
      u-leith-clark-flower
      u-tac u-pr u-mla u-mra
    '

  classesWillUpdate: ->
    header:
      'u-w10c': @props.second
      'u-w9c': not @props.second
    body:
      'u-lh34--900': not @props.second
      'u-lh34--900 u-w10c--900': @props.second

  render: ->
    classes = @getClasses()

    <div className=classes.block>
      <div className=classes.row>
        <div className=classes.column>
          <div className=classes.copyWrapper>
            <h2 children=@props.header className=classes.header />
            <p children=@props.body className=classes.body />
          </div>
        </div>
        <img src=@props.icon className=classes.flower />
      </div>
    </div>
