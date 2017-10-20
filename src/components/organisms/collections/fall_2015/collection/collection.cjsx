[
  _
  React

  Callout
  FramesGrid
  IntroSection

  Mixins
] = [
  require 'lodash'
  require 'react/addons'

  require 'components/molecules/collections/fall_2015/callout/callout'
  require 'components/molecules/collections/fall_2015/frames_grid_deprecated/frames_grid_deprecated'
  require 'components/organisms/collections/fall_2015/intro_section/intro_section'

  require 'components/mixins/mixins'
]

module.exports = React.createClass
  BLOCK_CLASS: 'c-fall-2015'

  mixins: [
    Mixins.context
  ]

  propTypes:
    version: React.PropTypes.oneOf(['fans', 'men', 'women'])

  getDefaultProps: ->
    version: 'fans'

  render: ->
    frames = _.groupBy @props.content.frame_groups, (frame) -> frame.section
    country = @getLocale('country')

    <div className=@BLOCK_CLASS>
      <IntroSection
        country=country
        header=@props.content.header
        version=@props.version />
      <FramesGrid version=@props.version frames={frames[1]} />
      <Callout {...@props.content.callout_block_1} />
      <FramesGrid version=@props.version frames={frames[2]} />
      <Callout
        cssModifier='-border-top -border-bottom'
        cssModifierDivider='-amber'
        cssModifierText='-text-left -narrow -vertical-center'
        cssModifierImage='-image-right'
        {...@props.content.callout_block_2} />
      <FramesGrid version=@props.version frames={frames[3]} />
      {if country is 'US'
        <Callout
          cssModifier='-border-top -tall -last'
          cssModifierDivider='-blue'
          cssModifierText='-text-right -narrow'
          {...@props.content.callout_block_hto} />}
    </div>
