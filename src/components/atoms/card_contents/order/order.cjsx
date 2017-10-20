[
  _
  React

  Img
  Alert
  RightArrow
  Mixins
] = [
  require 'lodash'
  require 'react/addons'

  require 'components/atoms/images/img/img'
  require 'components/quanta/icons/alert/alert'
  require 'components/quanta/icons/right_arrow/right_arrow'
  require 'components/mixins/mixins'

  require './order.scss'
]

module.exports = React.createClass
  BLOCK_CLASS: 'c-card-contents--order'

  mixins: [
    Mixins.classes
    Mixins.conversion
  ]

  propTypes:
    placed: React.PropTypes.string
    line_items: React.PropTypes.arrayOf React.PropTypes.object

  getDefaultProps: ->
    placed: ''
    line_items: [
      label: ''
      display_name: ''
      color: ''
      image_url: ''
      category: ''
    ]

  getStaticClasses: ->
    block: @BLOCK_CLASS
    wrapper:
      "#{@BLOCK_CLASS}__wrapper"
    body:
      "#{@BLOCK_CLASS}__body"
    thumbnail_wrapper:
      "#{@BLOCK_CLASS}__thumbnail-wrap"
    thumbnail_body:
      "#{@BLOCK_CLASS}__thumbnail"
    trigger:
      "#{@BLOCK_CLASS}__trigger"
    status:
      "#{@BLOCK_CLASS}__status"
    alert:
      "#{@BLOCK_CLASS}__alert"
    arrow:
      "#{@BLOCK_CLASS}__arrow"
    line_items:
      "#{@BLOCK_CLASS}__line-items"
    label: [
      "#{@BLOCK_CLASS}__label"
      "u-reset"
    ]
    image:
      "#{@BLOCK_CLASS}__image"
    item:
      "#{@BLOCK_CLASS}__item"
    other: [
      "#{@BLOCK_CLASS}__other"
      "u-reset"
      "u-fws"
    ]
    hto:
      "#{@BLOCK_CLASS}__hto"

  classesWillUpdate: ->
    status:
      'u-color--yellow-alt-1 u-fws': @props.order_issue


  getImageProps: (line_item) ->
    classes = @getClasses()
    imageProps =
      cssModifier: classes.image
      alt: "
        #{line_item.display_name}
        #{if line_item.color then " in #{line_item.color}" else ""}
        "

    _.assign imageProps,
      if line_item?.image_set?.fill?.front
        sizes: '125px'
        imageSet: line_item.image_set.fill.front
      else
        src: line_item?.image_url

  renderHTOLineItem: (line_item, i) ->
    classes = @getClasses()
    <span key=i
      className=classes.hto
      children=line_item.display_name />

  renderBody: ->
    classes = @getClasses()
    line_item = _.first @props.line_items
    datePlaced = @convert('date', 'object', @props.placed) if @props.placed

    <div className=classes.line_item>
      <div className="#{classes.label} u-ffs">
        {datePlaced?.month} {datePlaced?.date}, {datePlaced?.year}
      </div>
      <div className="#{classes.label} u-color--dark-gray-alt-2">
        Order no. {@props.id}
      </div>
      {if line_item?.option_type is 'hto' then [
        <div className="#{classes.label} u-fws">
          {line_item?.label}
        </div>
        _.map @props.line_items, @renderHTOLineItem
      ] else
        <div className=classes.item>
          <span className='u-reset u-ttc u-fws'>
            {line_item?.display_name}
          </span>
          {if line_item?.category is 'frame'
            [
              <span key='in' className='u-reset u-fws'> in </span>
              <span className='u-reset u-ttc u-fws' key='color'>
                {line_item?.color}
              </span>
            ]}
        </div>}
      {if @props.line_items.length > 1
        all_frames = _.every @props.line_items, (i) -> i.category is 'frame'
        if all_frames
          product = 'frame'
        else
          product = 'product'
        <div className=classes.other>
          {if @props.line_items.length > 2
            " + #{@props.line_items.length - 1} more #{product}s"
          else if @props.line_items.length is 2
            " + #{@props.line_items.length - 1} more #{product}"
          else
            ''}
        </div>}
    </div>

  render: ->
    @classes = @getClasses()
    line_item = _.first @props.line_items

    <div className=@classes.block>
      <div className=@classes.wrapper>
        <div>
          {if line_item?.image_url
            <div className=@classes.thumbnail_wrapper>
              <div className=@classes.thumbnail_body>
                <Img {...@getImageProps(line_item)} />
              </div>
            </div>}
          <div className="#{@classes.body} #{unless line_item?.image_url then '-full' else ''}" children=@renderBody() />
        </div>
      </div>
      <div className=@classes.trigger>
        {if @props.order_issue?
            <div className=@classes.status>
                We need some more info!
            </div>
        else
            <div className=@classes.status children=@props.status.headline />
        }
        <RightArrow cssModifier=@classes.arrow />
      </div>
    </div>
