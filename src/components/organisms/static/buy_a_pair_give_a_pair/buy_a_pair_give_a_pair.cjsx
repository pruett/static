[
  _
  React
  Picture
  Img
  SliderActive
  BapGapIntroduction
  BapGapHowItWorks
  BapGapPowerOnePair
  BapGapOurPartners
  BapGapDoingGoodWork
  BapGapConclusion
  Mixins
] = [
  require 'lodash'
  require 'react/addons'
  require 'components/atoms/images/picture/picture'
  require 'components/atoms/images/img/img'
  require 'components/molecules/sliders/active/active'
  require 'components/molecules/buy_a_pair_give_a_pair/introduction/introduction'
  require 'components/molecules/buy_a_pair_give_a_pair/how_it_works/how_it_works'
  require 'components/molecules/buy_a_pair_give_a_pair/power_one_pair/power_one_pair'
  require 'components/molecules/buy_a_pair_give_a_pair/our_partners/our_partners'
  require 'components/molecules/buy_a_pair_give_a_pair/doing_good_work/doing_good_work'
  require 'components/molecules/buy_a_pair_give_a_pair/conclusion/conclusion'
  require 'components/mixins/mixins'
  require './buy_a_pair_give_a_pair.scss'
]

module.exports = React.createClass

  BLOCK_CLASS: 'c-bapgap'

  mixins: [
    Mixins.analytics,
    Mixins.classes,
    Mixins.context,
    Mixins.dispatcher
    Mixins.image
  ]

  receiveStoreChanges: -> [
    'capabilities'
  ]

  getStaticClasses: ->
    block: "
      #{@BLOCK_CLASS}
    "

  render: ->
    classes = @getClasses()
    capabilities = @getStore 'capabilities'

    <div className=classes.block>

      <BapGapIntroduction
        header=@props.introduction.header
        subHeader=@props.introduction.subHeader
        description=@props.introduction.description
        images=@props.introduction.images />

      <BapGapHowItWorks
        header=@props.how_it_works.header
        description=@props.how_it_works.description
        images=@props.how_it_works.images />

      <BapGapPowerOnePair
        header=@props.power_one_pair.header
        footnote=@props.power_one_pair.footnote
        formula=@props.power_one_pair.formula />

      <BapGapOurPartners
        capabilities=capabilities
        header=@props.our_partners.header
        description=@props.our_partners.description
        slides=@props.our_partners.slides />

      <BapGapDoingGoodWork
        header=@props.doing_good_work.header
        subHeader=@props.doing_good_work.subHeader
        description=@props.doing_good_work.description
        images=@props.doing_good_work.images
        pins=@props.doing_good_work.pins />

      <BapGapConclusion
        description=@props.conclusion.description
        icon=@props.conclusion.icon
        images=@props.conclusion.images />

    </div>
