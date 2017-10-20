React = require 'react/addons'

ProductImageSlide = require 'components/molecules/products/slides/product_image/product_image'
SliderActive = require 'components/molecules/sliders/active/active'

Mixins = require 'components/mixins/mixins'


module.exports = React.createClass
  BLOCK_CLASS: 'c-product-slides'

  mixins: [Mixins.classes]

  propTypes:
    capabilities: React.PropTypes.object
    cssModififer: React.PropTypes.string
    images: React.PropTypes.arrayOf(
      React.PropTypes.shape(
        alt: React.PropTypes.string
        sizes: React.PropTypes.string
        srcSet: React.PropTypes.string
      )
    )

  render: ->
    <SliderActive capabilities=@props.capabilities
      showDots=true>
      {@props.images.map (image, i) =>
        {alt, sizes, srcSet} = image

        <ProductImageSlide key=i
          altText=alt
          cssModifier=@props.cssModifier
          sizes=sizes
          srcSet=srcSet />
      }
    </SliderActive>
