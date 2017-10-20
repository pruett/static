[
  React

  CTA

  Mixins
] = [
  require 'react/addons'

  require 'components/atoms/buttons/cta/cta'

  require 'components/mixins/mixins'
]

module.exports = React.createClass
  BLOCK_CLASS: 'c-empty-with-cta'

  mixins: [
    Mixins.classes
  ]

  propTypes:
    ctaLink: React.PropTypes.string
    ctaChildren: React.PropTypes.string
    headline: React.PropTypes.string

  getDefaultProps: ->
    ctaLink: '/'
    ctaChildren: ''
    headline: ''

  getStaticClasses: ->
    block:
      'u-tac
      u-m0a
      u-w10c u-w8c--900
      u-color-bg--light-gray-alt-2'
    headline:
      'u-fs24 u-ffs u-fws
      u-mb24'

  render: ->
    classes = @getClasses()

    <div className=classes.block>
      <h3 children=@props.headline className=classes.headline />
      <CTA
        analyticsSlug=@props.analyticsSlug
        children=@props.ctaChildren
        cssModifier='u-reset u-fs16 u-mb24 -cta-inline'
        href=@props.ctaLink
        tagName='a'
        variation='secondary' />
    </div>
