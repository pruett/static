# Active Experiments
# photoCopy

[
  _
  React

  DetailsModal
  FavoriteLoginModal
  FitDetails

  Frames
  LayoutDefault

  Mixins
] = [
  require 'lodash'
  require 'react/addons'

  require 'components/molecules/products/details_modal/details_modal'
  require 'components/molecules/products/favorite_login_modal/favorite_login_modal'
  require 'components/molecules/products/fit_details/fit_details'

  require 'components/organisms/products/frames/frames'

  require 'components/layouts/layout_default/layout_default'

  require 'components/mixins/mixins'
]

module.exports = React.createClass
  mixins: [
    Mixins.analytics
    Mixins.context
    Mixins.dispatcher
  ]

  statics:
    route: ->
      path: [
        '/eyeglasses/men/{frame_name}/{frame_color?}'
        '/eyeglasses/women/{frame_name}/{frame_color?}'
        '/sunglasses/men/{frame_name}/{frame_color?}'
        '/sunglasses/women/{frame_name}/{frame_color?}'
        '/monocle/{frame_name}/{frame_color?}'
      ]
      asyncPrefetch: ['/.*']
      handler: 'FrameDetail'

  receiveStoreChanges: -> [
    'applePay'
    'capabilities'
    'favorites'
    'frameProduct'
    'session'
  ]

  componentDidMount: ->
    @commandDispatcher 'layout', 'hideOverlay'

  manageChangeColor: (activeIndex) ->
    @commandDispatcher 'frameProduct', 'changeActiveColor', activeIndex

  manageChangeSelectedVariantType: (variantType) ->
    @commandDispatcher 'frameProduct', 'changeSelectedVariantType', variantType

  manageAddItem: (attrs) ->
    if not attrs.added_via
      attrs.added_via = 'pdp'
    @commandDispatcher 'cart', 'addItem', attrs

  manageApplePay: (attrs = {}) ->
    @commandDispatcher 'applePay', 'checkout', 'frameProduct', {
        product_id: attrs.product_id,
        variant: attrs.variant
      }

  closeDetailsModal: (evt) ->
    evt?.preventDefault()
    @trackInteraction 'fitDetailsModal-click-closeModal'
    @commandDispatcher 'frameProduct', 'closeSizingDetails'

  getPhotoProps: ->
    isUS = @getLocale()?.country is 'US'
    variant = @getExperimentVariant 'photoCopy'
    enabled = isUS and variant in ['light', 'transitions']
    { photoEnabled: enabled, photoVariant: variant }

  isPhotoV2Enabled: (product) ->
    variant = @getExperimentVariant 'photochromics'
    activeProduct = @getActiveProduct(product)
    isPhoto = (variant) -> variant.indexOf("photo") > -1
    hasPhotoVariants = _.some(Object.keys(activeProduct.variants), isPhoto)

    variant is 'photochromics' and hasPhotoVariants and
      activeProduct.assembly_type is 'eyeglasses'

  getActiveProduct: (product) ->
    colors = product.colors || []
    activeColorIndex = product.activeColorIndex || 0
    colors[activeColorIndex] || {}

  render: ->
    capabilities = @getStore 'capabilities'
    product = @getStore 'frameProduct'
    productProps = _.omit product, ['__fetched', 'sizingDetailsOpen']
    session = @getStore 'session'
    favorites = @getStore 'favorites'

    activeProduct = @getActiveProduct(product)

    fitImages = _.get product, 'content.fitImages.images', []
    fitDetails = _.get product, 'content.fitDetails'

    showFavorites = (favorites.__fetched or not session.isLoggedIn) and window?
    showFitDetails = not _.isEmpty(fitDetails) and window?
    showStaffGallery = not _.isEmpty(fitImages) and
      _.includes ["enabled", "dualgender"], @getExperimentVariant('staffPhotosOnPdp')

    <LayoutDefault {...@props} cssModifier='-full-width -push-footer'>
      {if showFavorites
        <FavoriteLoginModal
          active=favorites.showLogin
          session=session />
      }

      {if showFitDetails
        <DetailsModal
          active={_.get product, 'sizingDetailsOpen', false}
          cssModifier={if showStaffGallery then 'u-color-bg--dark-gray-95p' else "u-color-bg--white-95p"} >
          <FitDetails
            capabilities=capabilities
            content=fitDetails
            fitImages=fitImages
            manageClose=@closeDetailsModal
            product=activeProduct
            staffGallery=showStaffGallery />
        </DetailsModal>
      }

      {if product.__fetched
        <Frames
          {...productProps}
          {...@getPhotoProps()}
          activeProduct=activeProduct
          applePay=@getStore('applePay')
          capabilities=capabilities
          favorites={_.get favorites, 'favoritedProducts', []}
          manageAddItem=@manageAddItem
          manageApplePay=@manageApplePay
          manageChangeColor=@manageChangeColor
          manageChangeSelectedVariantType=@manageChangeSelectedVariantType
          photoV2Enabled=@isPhotoV2Enabled(product)
          session=session
          showFavorites={showFavorites or false}
          staffGallery=showStaffGallery />
      }
    </LayoutDefault>
