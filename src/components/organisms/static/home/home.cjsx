[
  _
  React

  Callout
  GlassesNav
  OptIn

  Mixins

] = [
  require 'lodash'
  require 'react/addons'

  require 'components/organisms/callout/callout'
  require 'components/molecules/glasses_nav/glasses_nav'
  require 'components/organisms/static/opt_in_modal/opt_in_modal'

  require 'components/mixins/mixins'
]

module.exports = React.createClass

  BLOCK_CLASS: 'c-home'

  mixins: [
    Mixins.context
    Mixins.dispatcher
    Mixins.image
  ]

  propTypes:
    routeQuery: React.PropTypes.object

  getInitialState: ->
    isModalActive: true

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

  closeModal: (evt) ->
    evt?.preventDefault()
    @commandDispatcher 'layout', 'hideTakeover'
    @setState { isModalActive: false }

  render: ->
    propsHero = _.first(@props.callouts) or {}
    propsRest = _.drop(@props.callouts) or []

    <section className=@BLOCK_CLASS>

      {
        if _.get(@props, 'routeQuery.modal') is 'optin'
          <OptIn
            closeModal=@closeModal
            isModalActive=@state.isModalActive
          />
      }

      <Callout {...propsHero} />

      <GlassesNav glasses=@props.glasses />

      {_.map propsRest, (props, i) -> <Callout key=i {...props} />}

    </section>
