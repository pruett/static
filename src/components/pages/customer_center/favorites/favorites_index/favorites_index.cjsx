[
  _
  React

  LayoutDefault

  Breadcrumbs
  Container
  EditableAddress
  CTA
  IconAdd
  BuyableFrame
  LocationsLocationCard

  Mixins

] = [
  require 'lodash'
  require 'react/addons'

  require 'components/layouts/layout_default/layout_default'

  require 'components/atoms/breadcrumbs/breadcrumbs'
  require 'components/organisms/customer_center/container/container'
  require 'components/molecules/editable_address/editable_address'
  require 'components/atoms/buttons/cta/cta'
  require 'components/quanta/icons/add/add'
  require 'components/molecules/products/buyable_frame/buyable_frame'
  require 'components/molecules/locations/location_card/location_card'

  require 'components/mixins/mixins'

  require './favorites_index.scss'
]

module.exports = React.createClass
  BLOCK_CLASS: 'c-customer-center-favorites'

  mixins: [
    Mixins.analytics
    Mixins.classes
    Mixins.context
    Mixins.dispatcher
  ]

  statics:
    route: ->
      visibleBeforeMount: true
      path: '/account/favorites'
      handler: 'AccountFavorites'
      bundle: 'customer-center'
      title: 'Favorites'

  receiveStoreChanges: -> [
    'favorites'
    'geo'
    'session'
  ]

  getStaticClasses: ->
    block: "
      #{@BLOCK_CLASS}
      u-tac
    "

    favoriteItem:"
      #{@BLOCK_CLASS}__favorite-item
      u-grid__col -c-12 -c-6--900 -c-4--1200
    "

    instructions: "
      #{@BLOCK_CLASS}__instructions
      u-tac u-fs16 u-fwn u-fs18--900
      u-mla u-mra u-mb48
    "

    categoryContainer: "
      #{@BLOCK_CLASS}__category-container
      u-mb48 u-mla u-mra
    "

    category: "
      #{@BLOCK_CLASS}__category
      u-tac u-ffss u-fs12 u-fws u-ttu
    "

    linkContainer: "
      #{@BLOCK_CLASS}__link-container
      u-tac
    "

    genderLinks: "
      #{@BLOCK_CLASS}__gender-links
      u-dib u-tac u-fs16 u-fws u-ttc
    "

    cta: "
      #{@BLOCK_CLASS}__cta
      u-button -button-large -button-blue
      u-fs20 u-fws
    "
    allLocationsCta:
      "#{@BLOCK_CLASS}__all-locations-cta
      -cta-medium u-fs16 u-ffss"

    nearbyLocationsCard:
      "#{@BLOCK_CLASS}__nearby-locations-card
      u-grid__col u-w12c -c-4--600
      u-mb24 u-mb36--600 u-mb48--1200
      u-mt12--900 u-mt24--1200"

    address:
      "#{@BLOCK_CLASS}__address
      u-body-standard u-mt12 u-mb0"

    locationInfo:
      "#{@BLOCK_CLASS}__location-info
      u-ffss u-fws u-di
      u-bbss u-bbw1 u-bc--blue
      u-fs18 u-fs20--900 u-mt0"
    hr:
      "#{@BLOCK_CLASS}__horizontal-row
      u-mtn12 u-mtn24--900 u-mtn12--1200"
    locationsHeading:
      'u-ffs u-fws
      u-fs24 u-fs30--600 u-fs34--900 u-fs40--1200
      u-mt48 u-mt60--900 u-mt72--1200
      u-mb36'

  propTypes:
    analyticsCategory:  React.PropTypes.string

  componentDidMount: ->
    @commandDispatcher 'experiments', 'bucket', 'favoritesLocalRetail'

  getDefaultProps: ->
    analyticsCategory: ''

  renderLocationCard: (loc, i) ->
    <LocationsLocationCard
      key=i
      location=loc
      cssModifier=@classes.nearbyLocationsCard
      cssModifierHeading=@classes.locationInfo
      cssModifierBody=@classes.address
      showExtendedAddress=false
      locationSlug=loc.location_slug />

  renderStoreCTA: (props) ->
    nearbyStores = @getStore('geo')?.nearbyStores
    hasRetail = nearbyStores?.length > 0

    <div>
      <hr key='locations-hr'
        className=@classes.hr />

      <h1 key='cta-text-header'
        className=@classes.locationsHeading
        children='Try them on at a nearby store!' />
      <div>
        {if nearbyStores
          for i, loc of nearbyStores
            if loc?.info?.name?
              @renderLocationCard(loc.info, i)
        }
      </div>
      <div>
        <CTA key='all-locations'
          onClick={@trackInteraction.bind @, "favorites-clickStoreBtn-allLocations", hasRetail}
          tagName='a'
          cssModifier=@classes.allLocationsCta
          variation='primary'
          href='/retail'
          children='See all locations' />
      </div>
    </div>

  render: ->
    @classes = @getClasses()
    session = @getStore('session')
    favorites = @getStore('favorites')
    hasFavorites = _.get(favorites, 'detailedFavorites', []).length > 0
    showStores = @inExperiment('favoritesLocalRetail', 'localStores')

    zeroState =
      copy: 'Save frames you like by tapping the nearby heart. We\'ll store \'em safely here for you.'
      image: ''

    breadcrumbs = [
      { text: 'Account', href: '/account' }
      { text: 'Favorites' }
    ]

    imageSizes = [
      breakpoint: 0
      width: '100vw'
    ,
      breakpoint: 360
      width: '360px'
    ,
      breakpoint: 600
      width: '500px'
    ,
      breakpoint: 1200
      width: '400px'
  ]

    <LayoutDefault {...@props} cssModifier='-full-width -responsive-margin'>
      <Container
        {...@props}
        bigHeading=true
        breadcrumbs=breadcrumbs
        heading="#{if hasFavorites then 'Manage your favorites' else 'Add favorites'}"
        cssUtility="#{@classes.block} #{if hasFavorites then 'u-grid -maxed' else ''}"
      >
        <div className="#{if hasFavorites then 'u-grid__row' else ''}">
          {if hasFavorites
            for i, product of favorites.detailedFavorites
              <BuyableFrame
                addedVia='favorites'
                analyticsCategory='accountFavorites'
                cart={_.get session, 'cart', {}}
                canHto=true
                cssModifier=@classes.favoriteItem
                key=i
                product=product
                imageSizes=imageSizes
              />
          else
            <div>
              <p
                className=@classes.instructions
                children=zeroState.copy
              />

              <div className='u-tac'>
                <div className=@classes.categoryContainer>
                  <h2 className=@classes.category>browse optical</h2>
                  <div className=@classes.linkContainer>
                    <a className=@classes.genderLinks href='/eyeglasses/men'>Men</a>
                    <a className=@classes.genderLinks href='/eyeglasses/women'>Women</a>
                  </div>
                </div>

                <div className=@classes.categoryContainer>
                  <h2 className=@classes.category>browse sunwear</h2>
                  <div className=@classes.linkContainer>
                    <a className=@classes.genderLinks href='/sunglasses/men'>Men</a>
                    <a className=@classes.genderLinks href='/sunglasses/women'>Women</a>
                  </div>
                </div>
              </div>
            </div>
          }
        </div>
        {if showStores
          @renderStoreCTA(@classes, @props)
        }
      </Container>
    </LayoutDefault>
