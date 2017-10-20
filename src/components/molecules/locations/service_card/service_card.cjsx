[
  _
  React

  Img

  Mixins
] = [
  require 'lodash'
  require 'react/addons'

  require 'components/atoms/images/img/img'

  require 'components/mixins/mixins'

  require './service_card.scss'
]

module.exports = React.createClass
  BLOCK_CLASS: 'c-locations-service-card'

  mixins: [
    Mixins.classes
    Mixins.image
  ]

  propTypes:
    image: React.PropTypes.string
    heading: React.PropTypes.string
    body: React.PropTypes.string
    cssModifier: React.PropTypes.string

  getDefaultProps: ->
    image: ''
    heading: ''
    body: ''
    cssModifier: ''

  getStaticClasses: ->
    block:
      "#{@BLOCK_CLASS}
      #{@props.cssModifier}"
    image:
      "#{@BLOCK_CLASS}__image"
    heading:
      'u-reset u-fs20 u-mb24 u-fws u-ffs'
    bodyContainer:
      'u-grid__row'
    body:
      'u-grid__col -c-10 -c-12--900
      u-reset u-fs16'

  render: ->
    classes = @getStaticClasses()

    <section className=classes.block>
      {if @props.image
        widths = [220, 275, 330, 385, 440]

        <Img cssModifier=classes.image
          srcSet={@getSrcSet {url: @props.image, widths}} />
      }

      <h2 className=classes.heading
        children=@props.heading />

      <div className=classes.bodyContainer>
        <p className=classes.body
          children=@props.body />
      </div>
    </section>
