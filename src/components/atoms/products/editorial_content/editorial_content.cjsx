[
  _
  React

  Mixins
] = [
  require 'lodash'
  require 'react/addons'

  require 'components/mixins/mixins'
]

module.exports = React.createClass
  BLOCK_CLASS: 'c-product-editorial-content'

  mixins: [
    Mixins.classes
  ]

  propTypes:
    cssModifier: React.PropTypes.string

  getDefaultProps: ->
    cssModifier: ''
    product: {}

  getStaticClasses: ->
    block:
      "#{@BLOCK_CLASS} #{@props.cssModifier}"
    heading: 'u-mt0 u-mb0
      u-pb6
      u-heading-sm
      u-tac u-tal--900'
    description:
      'u-ffss u-fwn u-fs16 u-fs18--1200
      u-color--dark-gray-alt-3
      u-tac u-tal--900'
    descriptionCalloutBorder:
      'u-bw1 u-bss u-bc--subtle-gray u-mb60 u-mb30--1200'
    descriptionCallout:
      'u-fs14 u-ffs u-color--dark-gray-alt-3 u-tac u-tal--900 u-m20'

  render: ->
    classes = @getClasses()

    description = @props.product.description
    description_callout = @props.product.description_callout

    <section className=classes.block>
      {if description
        [
          <h2 key='heading'
            className=classes.heading
            children='About the frames' />
          <p key='description'
            className=classes.description
            children=description />
        ]
      }
      {if description_callout
        <div className=classes.descriptionCalloutBorder>
          <p key='description_callout'
            className=classes.descriptionCallout
            children=description_callout />
        </div>
      }
    </section>
