[
  React

  Hero
  Bapgap
  Discover
  FrameTypes
  Footer
  Instagram
  TryBeforeBuy

  Mixins

] = [
  require 'react/addons'

  require 'components/molecules/eye_sun/hero/hero'
  require 'components/molecules/eye_sun/bapgap/bapgap'
  require 'components/molecules/eye_sun/discover/discover'
  require 'components/molecules/eye_sun/frame_types/frame_types'
  require 'components/molecules/eye_sun/footer/footer'
  require 'components/molecules/eye_sun/instagram/instagram'
  require 'components/molecules/eye_sun/try_before_buy/try_before_buy'

  require 'components/mixins/mixins'
]

module.exports = React.createClass

  BLOCK_CLASS: 'c-eyesun'

  mixins: [
    Mixins.classes
    Mixins.dispatcher
  ]

  reduceImpression: (impressions, prop) ->
    impressions.push(prop.analytics) if _.has prop, 'analytics'

    if _.has(prop, 'posts') or _.has(prop, 'collections') or _.isArray(prop)
      # Kludgy way to grab collections
      _.reduce prop, @reduceImpression, impressions
    else
      impressions

  componentDidMount: ->
    # Simple impression push until we have actual position tracking.
    # Go through objects and push impression if analytics present.
    promos = _.reduce @props, @reduceImpression, []

    @commandDispatcher 'analytics', 'pushPromoEvent',
      type: 'promotionImpression'
      promos: promos

  getStaticClasses: ->
    block:
      @BLOCK_CLASS
    sectionAlt:
      'u-color-bg--light-gray-alt-2'
    grid: '
      u-grid -maxed
      u-mla u-mra
    '
    row: '
      u-pt48 u-pb48
      u-pt72--600 u-pb72--600
      u-pt96--900 u-pb96--900
      u-btw1 u-btss u-bc--light-gray
      u-tac'
    rowAlt: '
      u-pt48 u-pb48
      u-pt72--600 u-pb72--600
      u-pt96--900 u-pb96--900
      u-tac'
    hero: '
      u-mra u-mla'
  render: ->
    classes = @getClasses()

    <div className=classes.block>

      <section className=classes.hero>
        <Hero {...@props.hero}  />
      </section>

      <section className=classes.grid>
        <div className=classes.rowAlt>
          <FrameTypes {...@props.our_frames} />
        </div>
      </section>

      <section className=classes.grid>
        <div className=classes.row>
          <Discover {...@props.discover} />
        </div>
      </section>

      <section className=classes.grid>
        <div className=classes.row>
          <TryBeforeBuy {...@props.try_before_buy} />
        </div>
      </section>

      <section className=classes.sectionAlt>
        <div className=classes.grid>
          <div className=classes.rowAlt>
            <Bapgap {...@props.bapgap} />
          </div>
        </div>
      </section>

      <section className=classes.grid>
        <div className=classes.rowAlt>
          <Instagram {...@props.instagram} />
        </div>
      </section>

      <section className=classes.grid>
        <div className=classes.row>
          <Footer {...@props.footer} />
        </div>
      </section>

    </div>
