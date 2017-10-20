[
  _
  React

  Mixins
] = [
  require 'lodash'
  require 'react/addons'

  require 'components/mixins/mixins'

  require '../purchase/purchase.scss'
]

module.exports = React.createClass
  BLOCK_CLASS: 'c-product-popover-purchase'

  mixins: [
    Mixins.analytics
    Mixins.classes
    Mixins.context
    Mixins.dispatcher
  ]

  getStaticClasses: ->
    block: "
      #{@BLOCK_CLASS}
      u-tac
    "
    header: '
      u-pr
      u-bbss u-bw1 u-bc--light-gray
      u-clearfix
    '
    title: '
      u-fws u-fs16
      u-mt18 u-mb18
    '
    container: '
      u-pr6 u-pb24 u-pl6
    '
    message: '
      u-mt18 u-mr24 u-mb18 u-ml24
      u-fs14
      u-color--dark-gray-alt-1
    '
    link: '
      u-dib
      u-fs14 u-fws
      u-link--underline
      u-button-reset
      u-ml8 u-mr8
    '

  getInitialState: ->
    alreadyInCart: false

  componentWillMount: ->
    @setState alreadyInCart: @isInCart()

  handleRemoveItem: (evt) ->
    @trackInteraction "#{@props.analyticsCategory}-click-removeHto", evt
    variant_id = _.get @props.variants, 'hto.variant_id'
    items = _.get @props.cart, 'items', []
    item = _.find(items, product_id: @props.id, variant_id: variant_id)
    if item
      item.option_type = 'hto'
      @props.manageRemoveItem item
    @props.handleClose()

  isInStock: ->
    _.reduce @props.variants, (acc, attrs) ->
      acc or (attrs.in_stock and attrs.active)
    , false

  isFull: ->
    _.get @props.cart, 'hto_limit_reached', false

  isInCart: ->
    variant_id = _.get @props.variants, 'hto.variant_id'
    items = _.get @props.cart, 'items', []
    _.findIndex(items, product_id: @props.id, variant_id: variant_id) isnt -1

  getGalleryUrl: ->
    genderDir = switch @props.gender
      when 'f'
        'women'
      when 'm'
        'men'

    if @props.assembly_type and genderDir
      "/#{@props.assembly_type}/#{genderDir}?availability=hto"
    else
      '/'

  getCopy: ->
    count = "#{_.get(@props.cart, 'hto_quantity', 0)} of 5"
    frame = "#{@props.display_name} in #{_.startCase @props.color}"

    if not _.get(@props.variants, 'hto')
      title: 'Not available for Home Try-On'
      message: 'Due to limited quantities of this frame, it is not available for Home Try-On.'
    else if not @isInStock()
      title: 'Currently not available'
      message: 'Good news: The frame you chose is very popular for Home Try-On.
       Bad news: It’s not available at this moment.'
    else if @isFull()
      title: 'Your box is full'
      message: 'Well done! Your Home Try-On box is full and ready to be shipped.'
    else if @state.alreadyInCart
      title: "Frame #{count}"
      message: "#{frame} is already in your Home Try-On."
    else
      title: "Success! #{count} added"
      message: "#{frame} is now in your Home Try-On."

  renderLinkBack: ->
    classes = @getClasses()

    if (
      @requestDispatcher('cookies', 'get', 'hasQuizResults') and
      @inExperiment('linkPdpToQuizResults', 'enabled')
    )
      <a href={'/quiz/results'}
        className={classes.link}
        onClick={@trackInteraction.bind(@, "#{@props.analyticsCategory}-click-htoQuizResults")}
        children={'See quiz results'} />
    else
      <a href={@getGalleryUrl()}
        className={classes.link}
        onClick={@trackInteraction.bind(@, "#{@props.analyticsCategory}-click-htoFindAnother")}
        children={'Find another frame'} />

  render: ->
    classes = @getClasses()

    copy = @getCopy()

    <div className=classes.block>
      <div className=classes.header>
        <h3 className=classes.title children=copy.title />
      </div>
      <div className=classes.container>
        <p className=classes.message children=copy.message />

        {if @state.alreadyInCart
          <button
            className=classes.link
            children='Remove'
            onClick=@handleRemoveItem />

        else unless @isFull()
          @renderLinkBack()
        }

        {if @isInCart() or @isFull()
          <a href='/cart'
            className=classes.link
            children='View cart'
            onClick={@trackInteraction.bind @,
              "#{@props.analyticsCategory}-click-cart"} />}
      </div>
    </div>
