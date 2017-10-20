React = require 'react/addons'
Mixins = require 'components/mixins/mixins'

module.exports = React.createClass
  BLOCK_CLASS: 'c-external-svg'

  mixins: [
    Mixins.classes
  ]

  propTypes: ->
    altText: React.PropTypes.string
    cssModifier: React.PropTypes.string

    # Block class of the parent, whose CSS should set background-image and,
    # optionally, padding-bottom on its {block}__image child. For example, if
    # @props.parentClass is 'my-icon', expect to find in _my_icon.scss:
    #   .c-my-icon__image {
    #     background-image: url(/path/to/my-icon.svg);
    #     padding-bottom: 150%; // defaults to 100%
    #   }
    parentClass: React.PropTypes.string

  getDefaultProps: ->
    altText: ''
    cssModifier: ''
    parentClass: ''

  getStaticClasses: ->
    block:
      "#{@BLOCK_CLASS}
      #{@props.parentClass}
      #{@props.cssModifier}"
    image:
      "#{@props.parentClass}__image
      u-db
      u-h0
      u-pb1x1
      u-bgr--nr"
    altText:
      'u-hide--visual'

  render: ->
    classes = @getClasses()

    <span className=classes.block>
      <span className=classes.image>
        <span children=@props.altText
          className=classes.altText />
      </span>
    </span>
