[
  _
  React

  Callout
  GlassesNav
  FrameTypes
  TryBeforeBuy

  Mixins

] = [
  require 'lodash'
  require 'react/addons'

  require 'components/organisms/callout/callout'
  require 'components/molecules/glasses_nav/glasses_nav'
  require 'components/molecules/eye_sun/frame_types/frame_types'
  require 'components/molecules/eye_sun/try_before_buy/try_before_buy'

  require 'components/mixins/mixins'
]

require './general_electric.scss'

module.exports = React.createClass

  BLOCK_CLASS: 'c-general-electric'

  mixins: [
    Mixins.context
    Mixins.dispatcher
    Mixins.classes
  ]

  getStaticClasses: ->
    block:
      @BLOCK_CLASS
    heroDash: "
      #{@BLOCK_CLASS}__hero-dash
      u-bw0 u-btw3 u-btss u-bc--gray u-bw0--900 u-ma
      u-mb48 u-mb0--900
    "
    grid: '
      u-grid -maxed
      u-mla u-mra
    '
    row: '
      u-pt48 u-pb48
      u-pt72--600 u-pb72--600
      u-pt96--900 u-pb96--900
      u-tac
    '

  componentDidMount: ->
    # Simple impression push until we have actual position tracking.
    # Go through objects and push impression if analytics present.
    promos = _.reduce @props.callouts, (impressions, prop) ->
      impressions.push(prop.analytics) if _.has prop, 'analytics'
      impressions
    , []

    @commandDispatcher 'analytics', 'pushPromoEvent',
      type: 'promotionImpression'
      promos: promos

  render: ->
    classes = @getClasses()

    heroProps = _.head @props.topCallouts
    finalCalloutProps = _.last @props.topCallouts

    <section className=classes.block>

      <Callout {...heroProps} />

      <hr className=classes.heroDash />

      {_.map _.dropRight(_.tail(@props.topCallouts)), (props, i) -> <Callout key=i {...props} />}

      <GlassesNav
        glasses=@props.glassesNav
        linkTarget="_blank"
      />

      <Callout {...finalCalloutProps}  />

      <section className=classes.grid>
        <div className="#{classes.row} u-bbw1 u-bbss u-bc--light-gray">
          <TryBeforeBuy
            {...@props.try_before_buy}
            linkTarget='_blank'
          />
        </div>
      </section>

      <section className=classes.grid>
        <div className=classes.row>
          <FrameTypes {...@props.our_frames} />
        </div>
      </section>

      {_.map @props.bottomCallouts, (props, i) -> <Callout key=i {...props} />}

    </section>
