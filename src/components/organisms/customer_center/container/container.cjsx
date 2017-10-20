_ = require 'lodash'
React = require 'react/addons'
BackLink = require 'components/atoms/back_link/back_link'
Mixins = require 'components/mixins/mixins'
Breadcrumbs = require 'components/atoms/breadcrumbs/breadcrumbs'

require './container.scss'

module.exports = React.createClass
  BLOCK_CLASS: 'c-customer-center-container'

  mixins: [
    Mixins.classes
  ]

  getStaticClasses: ->
    block: "
      #{@BLOCK_CLASS}
      u-mla u-mra u-pt60
    "

    contents: "
      #{@BLOCK_CLASS}__contents
    "

    headerImg: "
      #{@BLOCK_CLASS}__header-img
    "

    heading: '
      u-mb48
    '

  propTypes:
    heading: React.PropTypes.node
    previousRoute: React.PropTypes.string
    backLinkText: React.PropTypes.string
    cssModifier: React.PropTypes.string
    cssUtility: React.PropTypes.string
    cssVariation: React.PropTypes.string
    breadcrumbs: React.PropTypes.array
    bigHeading: React.PropTypes.bool

  getDefaultProps: ->
    heading: 'Account Detail'
    previousRoute: '/account'
    backLinkText: 'Account'
    cssModifier: ''
    cssUtility: ''
    cssVariation: ''
    bigHeading: false

  classesWillUpdate: ->
    heading:
      'u-fs30 u-fs40--600 u-fs60--1200
      u-mt0 u-mt10--1200 u-mb72--1200
      u-ffs u-fws u-tac': @props.bigHeading
      'u-fs24 u-ffs u-fwn': not @props.bigHeading

  render: ->
    classes = @getClasses()

    className = [
      classes.block
      @props.cssModifier
      @props.cssUtility
      @props.cssVariation
    ].join ' '

    <div className=className>
      <div className="#{classes.contents} #{@props.cssModifier}">

        <Breadcrumbs
          centered=true
          links=@props.breadcrumbs
        />

        <h1 className=classes.heading>
          {@props.heading}
        </h1>

        {@props.children}

      </div>
    </div>
