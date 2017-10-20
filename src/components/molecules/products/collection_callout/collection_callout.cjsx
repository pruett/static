[
  React

  Img

  Mixins
] = [
  require 'react/addons'

  require 'components/atoms/images/img/img'

  require 'components/mixins/mixins'

  require './collection_callout.scss'
]

module.exports = React.createClass
  BLOCK_CLASS: 'c-product-collection-callout'

  mixins: [
    Mixins.classes
  ]

  propTypes:
    title: React.PropTypes.string
    imageSet: React.PropTypes.array
    description: React.PropTypes.string
    link: React.PropTypes.string
    cssModifier: React.PropTypes.string

  getDefaultProps: ->
    cssModifier: ''

  getStaticClasses: ->
    block: [
      @BLOCK_CLASS
      @props.cssModifier
    ]
    image:
      "#{@BLOCK_CLASS}__image"
    text:
      "#{@BLOCK_CLASS}__text"
    description:
      "#{@BLOCK_CLASS}__description
      u-reset u-fs20 u-fws"
    link:
      'u-reset u-fs12'

  render: ->
    classes = @getClasses()

    <div className=classes.block>
      <Img
        alt=@props.title
        srcSet=@props.imageSet
        cssModifier=classes.image />
      <div className=classes.text>
        <p children=@props.description
          className=classes.description />
        <a href=@props.link
          className=classes.link
          children='See the entire collection ›' />
      </div>
    </div>
