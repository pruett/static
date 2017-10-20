React = require 'react/addons'

HeadturnContainer = require 'components/molecules/products/headturn_container/headturn_container'
TechnicalDetails = require 'components/molecules/products/technical_details/technical_details'
LiteraryCallout = require 'components/molecules/literary_callout/literary_callout'
Center = require 'components/molecules/landing/frame/center/center'

Mixins = require 'components/mixins/mixins'


module.exports = React.createClass
  BLOCK_CLASS: 'c-editions-secondary'

  MAX_RECOMMENDATIONS: 2

  mixins: [
    Mixins.analytics
    Mixins.classes
    Mixins.context
    Mixins.dispatcher
  ]

  propTypes:
    product: React.PropTypes.object
    heading: React.PropTypes.string

  getStaticClasses: ->
    block:
      'u-pr
      u-mw1440
      u-m0a
      u-mln18
      u-mrn18 u-mln36--600 u-mrn36--600
      u-mln48--900 u-mrn48--900
      u-mln60--1200 u-mrn60--1200
      '
    headturn:
      'u-pb4x3 u-pb2x1--900
      u-h0'
    textGrid:
      'u-grid -maxed
      u-w100p
      u-m0a
      u-pr u-pa--900
      u-t0--900
      u-center-y--900
      u-pen'
    text:
      'u-w12c u-w4c--900
      u-tac u-tal--900'
    heading:
      'u-fs20 u-fs30--900
      u-fws u-ffs
      u-mt36 u-mt0--900
      u-mb12 u-mb18--900'
    description:
      'u-fs16 u-fs18--900
      u-ffss
      u-color--dark-gray-alt-3'
    title: "
      u-tac u-fs34 u-fws u-ffs
    "

  formatHeadturnImageSet: (imageSet) ->
    Object.keys(imageSet).reduce (acc, size) ->
      if imageSet[size]
        {modes, images} = imageSet[size]

        acc.concat {
          size,
          image: images.map (image) ->
            "#{modes.fill}/#{image}"
        }
      else
        acc
    , []

  manageProductClick: (product = {}) ->
    id = product.product_id or product.id

    @trackInteraction "PDP_editions-clickProduct-#{id}"

    # Track custom GA ecommerce event.
    @commandDispatcher 'analytics', 'pushProductEvent',
      type: 'productClick'
      products: [
        brand: 'Warby Parker'
        id: id
        list: 'Editions_Recommendations'
        name: product.display_name
        sku: product.sku
        url: product.path
      ]

  render: ->
    classes = @getClasses()

    {product, heading, technicalDetails, recommendations} = @props
    {class_key, description, display_name, sized_headturn_image_set} =
      product

    headturnImageSet = @formatHeadturnImageSet sized_headturn_image_set

    <div>
      <section className=classes.block>
        {if headturnImageSet.length
          <div className=classes.headturn>
            <HeadturnContainer
              analyticsCategory="PDP_editions_#{class_key}"
              alt=display_name
              urls=headturnImageSet />
          </div>
        }

        <div className=classes.textGrid>
          <div className=classes.text>
            <h2 children=heading
              className=classes.heading />
            <p children=description
              className=classes.description
              itemProp='description' />
          </div>
        </div>

      </section>

      <section>
        { <TechnicalDetails details=technicalDetails /> if technicalDetails.length }

        {if @getFeature('freeReturns') and @getFeature('freeShipping')
          <LiteraryCallout
            label='Our Promise'
            headline='Free shipping and free returns, always'
            copy='We have a 30-day, no-questions-asked return policy for all items purchased online or at any Warby Parker store.' />
        }

        {if recommendations.length
          <div>
            <h3 className=classes.title>More fun stuff for you</h3>

            {for recommendation, i in recommendations when i < @MAX_RECOMMENDATIONS
              <Center
                key="reco-frame-#{i}"
                product=recommendation
                show_price=true
                manageProductClick=@manageProductClick
                two_up=true />
            }
          </div>
        }
      </section>
    </div>
