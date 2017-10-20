[
  React

  BackLink
  CTA

  Mixins
] = [
  require 'react/addons'

  require 'components/atoms/back_link/back_link'
  require 'components/atoms/buttons/cta/cta'

  require 'components/mixins/mixins'

  require '../forgot_password.scss'
]

module.exports = React.createClass
  BLOCK_CLASS: 'c-forgot-password-success'

  mixins: [
    Mixins.classes
  ]

  propTypes:
    password: React.PropTypes.shape
      email: React.PropTypes.string

  getDefaultProps: ->
    cssModifier: ''
    backLink: ''

  getStaticClasses: ->
    block:
      "#{@BLOCK_CLASS} #{@props.cssModifier}"
    backLink:
      "#{@BLOCK_CLASS}__back-link"
    heading:
      'u-reset u-fs24 u-mb12 u-ffs u-fws'
    subheading:
      'u-reset u-fs16 u-mb24'

  render: ->
    classes = @getClasses()

    <div className=classes.block>
      {if @props.backLink
        <BackLink backLink=@props.backLink cssModifier=classes.backLink />}

      <h1 className=classes.heading
        children='Thank you' />

      <p className=classes.subheading>
        We’ve sent new password instructions to: <strong
          children=@props.password.email />
      </p>

      <CTA
        analyticsSlug='forgotPassword-click-accept'
        tagName='a'
        variation='primary'
        cssModifier='-cta-full'
        href='/checkout/step/information'
        children='Got it.' />
    </div>
