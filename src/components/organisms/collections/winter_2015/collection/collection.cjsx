[
  _
  React


  FramesGrid
  Callout
  Intro

  Mixins
] = [

  require 'lodash'
  require 'react/addons'


  require 'components/molecules/collections/winter_2015/frames_grid/frames_grid'
  require 'components/molecules/collections/winter_2015/callout/callout'
  require 'components/organisms/collections/winter_2015/intro_section/intro_section'

  require 'components/mixins/mixins'
]


module.exports = React.createClass

  BLOCK_CLASS: 'c-winter-2015'

  mixins: [
    Mixins.locale
    Mixins.context
    Mixins.dispatcher
  ]

  getStaticClasses: ->
    introTextWrapper: "
      #{@BLOCK_CLASS}__intro-text-wrapper u-reset u-ffs u-fs16
    "
    introTextBody: "
      #{@BLOCK_CLASS}__intro-text-body
    "
    introTextPrice: "
      #{@BLOCK_CLASS}__intro-text-price
    "
    mobileLogo: "
      #{@BLOCK_CLASS}__mobile-logo
    "

  getFansFrames: ->
    _.groupBy @props.content.frame_groups, (frame) -> frame.section

  getGenderedFrames: (gender) ->
    sortedFrames = _.filter @props.content.frame_groups, (frame) -> frame[gender]

    #The keys here correspond to the index numbers of the arrays coming from the CMS
    #Add one to i because the render function expects 1,2 or 3
    newGroup =
      1: []
      2: []
      3: []

    frameOrder = @props.content.frame_order[gender]

    _.forEach frameOrder, (frameArray, i) ->
      _.forEach frameArray, (name) ->
        _.forEach sortedFrames, (assembly) ->
          if assembly.name is name
            newGroup[i+1].push assembly
    newGroup

  getFrames: ->
    switch @props.version
      when 'men' then @getGenderedFrames('men')
      when 'women' then @getGenderedFrames('women')
      when 'fans' then @getFansFrames()
      else @getFansFrames()

  render: ->
    country = @getLocale('country')
    classes = @getStaticClasses()
    frames = @getFrames()

    introContent = _.get @props, 'content.header'
    firstCallout = _.get @props, 'content.callout_block_1'
    secondCallout = _.get @props, 'content.callout_block_2'
    htoCallout = _.get @props, 'content.callout_block_hto'

    <div className=@BLOCK_CLASS>
      <Intro {...introContent}
        version=@props.version
        country=country />
      <img className=classes.mobileLogo src=introContent.mobile_logo.image />
      <div className=classes.introTextWrapper >
        <div
          className=classes.introTextBody
          children=introContent.intro_text.text />
        <div
          className=classes.introTextPrice
          children={
            if country is 'CA'
              introContent.intro_text.pricing_text_canada
            else
              introContent.intro_text.pricing_text
            }
         />
      </div>
      <FramesGrid country=country version=@props.version frames=frames[1] />
      <Callout {...firstCallout}
         cssModifierText='-text-right'
         cssModifierDividerColor='-grey'
         cssModifierDividerPosition='-right'
         version=@props.version />
      <FramesGrid country=country version=@props.version frames=frames[2] />
      <Callout {...secondCallout}
         cssModifierText='-text-left'
         cssModifierDividerColor='-blue'
         cssModifierDividerPosition='-left'
         cssCalloutModifier='-middle'
         version=@props.version />
      <FramesGrid country=country version=@props.version frames=frames[3] />
      {
        if country is 'US'
          <Callout {...htoCallout} hto=true
             cssModifierText='-text-hto'
             cssModifierDividerColor='-blue'
             cssModifierDividerPosition='-hto'
             cssCalloutModifier='-hto'
          />
      }
    </div>
