_ = require 'lodash'
React = require 'react/addons'

Mixins = require 'components/mixins/mixins'

HeadturnContainer = require 'components/molecules/products/headturn_container/headturn_container'
SizingDetails = require 'components/molecules/products/sizing_details/sizing_details'
EditorialContent = require 'components/atoms/products/editorial_content/editorial_content'

module.exports = React.createClass
  BLOCK_CLASS: 'c-product-details-container'

  mixins: [
    Mixins.classes
  ]

  propTypes:
    activeColorIndex: React.PropTypes.number
    colors: React.PropTypes.array
    headturns: React.PropTypes.object
    photoV2Enabled: React.PropTypes.bool

  getStaticClasses: ->
    block:
      'u-pr
      u-pb48 u-pb0--900
      u-mw1440 u-mra u-mla
      u-bw0 u-btw1 u-bbw1 u-bss u-bc--light-gray-alt-1'
    detailsCopyGrid:
      "#{@BLOCK_CLASS}__copy-area
      u-grid -maxed
      u-mra u-mla
      u-pa--900 u-center--900
      u-w100p
      u-pen"
    detailsCopyRow:
      'u-grid__row u-tac u-tal--900'
    detailsCopyCol:
      'u-grid__col
      u-w12c u-w9c--600 u-w5c--900
      u-mt48 u-mt64--600 u-mt0--900 u-mla u-mra'
    editorial: 'u-mb18 u-mb12--900'
    items: 'u-reset u-ffss u-fs16 u-fs18--1200 u-mb24 u-tal'
    item: 'c-product-lens-details__bullet u-pr u-mb12'


  render: ->
    classes = @getClasses()

    <section className=classes.block>
      <HeadturnContainer {...@props.headturns} />

      <div className=classes.detailsCopyGrid>
        <div className=classes.detailsCopyRow>
          <div className=classes.detailsCopyCol>
            <EditorialContent
              cssModifier=classes.editorial
              product=@props.activeProduct />

            {if @props.photoV2Enabled
              <ul className=classes.items>
                {@props.technicalDetails.slice(0, 4).map( (detail, i) =>
                  <li key=i
                    className=classes.item
                    children=detail />
                )}
              </ul>
            }

            <SizingDetails
              product=@props.activeProduct
              staffGallery=@props.staffGallery
              fitThumbnail=@props.fitThumbnail />
          </div>
        </div>
      </div>
    </section>
