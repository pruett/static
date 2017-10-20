[
  _
  React
  Mixins
] = [
  require 'lodash'
  require 'react/addons'
  require 'components/mixins/mixins'

  require './bookmark_frame.scss'
]

module.exports = React.createClass
  BLOCK_CLASS: 'c-bookmark-frame'

  mixins: [
    Mixins.conversion
  ]

  propTypes:
    notes: React.PropTypes.string
    color: React.PropTypes.string
    image_url: React.PropTypes.string
    product_url: React.PropTypes.string
    display_name: React.PropTypes.string
    customer_image: React.PropTypes.string
    updated: React.PropTypes.string
    facility_name: React.PropTypes.string
    id: React.PropTypes.number

  getDefaultProps: ->
    notes: ''
    color: ''
    image_url: ''
    product_url: ''
    display_name: ''
    customer_image: ''
    updated: ''
    facility_name: ''
    id: 1

  render: ->
    updated = @convert 'date', 'object', @props.updated

    classes =
      media: "
        #{@BLOCK_CLASS}__media
        #{@BLOCK_CLASS}__media--/
        #{if @props.customer_image then 'customer' else 'frame'}"
      name: "
        #{@BLOCK_CLASS}__name
        #{if @props.customer_image then "#{@BLOCK_CLASS}__name--customer-image"}
        u-reset u-fs18 u-ffs u-fws"
      color: "
        #{@BLOCK_CLASS}__color
        u-reset u-fs16 u-ffs u-fsi u-ttc"
      facility: "
        #{@BLOCK_CLASS}__facility
        u-reset u-fs12"
      notes: "
        #{@BLOCK_CLASS}__notes
        u-reset u-fs12"

    <div className=@BLOCK_CLASS>
      <a href=@props.product_url>
        <img src="#{@props.customer_image ? @props.image_url}.png"
          className=classes.media />
      </a>

      <div className="#{@BLOCK_CLASS}__content">
        {if @props.customer_image
          <div className="#{@BLOCK_CLASS}__container">
            <a href=@props.product_url>
              <img className="#{@BLOCK_CLASS}__reference"
                src="#{@props.image_url}.png" />
            </a>
          </div>}

        <div className=classes.name>
          <a className="#{@BLOCK_CLASS}__link" href=@props.product_url>
            {@props.display_name}
          </a>
        </div>
        <p className=classes.color>
          {@props.color}
        </p>
        <p className=classes.facility>
          <strong>{@props.facility_name} </strong>
          on {updated.month} {updated.date}, {updated.year}
        </p>
        {if @props.notes
          <p className=classes.notes>
            <strong>Notes:</strong> {@props.notes}
          </p>}
      </div>
    </div>
