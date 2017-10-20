[
  _
  React
  Mixins
] = [
  require 'lodash'
  require 'react/addons'
  require 'components/mixins/mixins'

  require './tab_bar.scss'
]

module.exports = React.createClass
  BLOCK_CLASS: 'c-tab-bar'

  mixins: [
    Mixins.analytics
    Mixins.classes
  ]

  getDefaultProps: ->
    analyticsSlug: 'tabBar'
    spacerIndex: 0
    currentTabIndex: 0
    tabs: [
      heading: 'Acetate'
      content: 'this is acetate content'
    ,
      heading: 'Titanium'
      content: 'this is titanium content'
    ,
      heading: 'Mixed',
      content: 'this is mixed content'
    ]

  getStaticClasses: ->
    block: "
      #{@BLOCK_CLASS}
      #{@props.cssModifier}"
    radio: "
      #{@BLOCK_CLASS}__radio
      u-hide--visual"
    label: "
      #{@BLOCK_CLASS}__label
      u-body-standard u-fws u-ffss"
    tab:
      "#{@BLOCK_CLASS}__tab"
    container:
      "#{@BLOCK_CLASS}__container"
    content:
      "#{@BLOCK_CLASS}__content"
    spacer:
      "#{@BLOCK_CLASS}__spacer"

  getTab: (i) ->

  renderTab: (tab, i) ->
    id = "tab-#{i}"

    [
      <input
        type='radio'
        id=id
        name='tab-bar'
        key="radio-#{i}"
        defaultChecked={i is @props.currentTabIndex}
        className=@classes.radio />

      <label
        key="label=#{i}"
        children=tab.heading
        htmlFor=id
        className=@classes.label
        onClick={@trackInteraction.bind(@, "#{@props.analyticsSlug}-click-tab")} />

      <div key="content-#{i}"
        className=@classes.content
        children=tab.content />
    ]

  render: ->
    return false if _.isEmpty @props.tabs

    @classes = @getClasses()

    spacer = _.get(@props, "tabs[#{@props.spacerIndex}].content")

    <div className=@classes.block>

      {_.map @props.tabs, @renderTab}

      <div className=@classes.spacer children=spacer />

    </div>
