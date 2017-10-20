[
  React

  LayoutCheckout

  RightArrow
  TermsAndConditions
  LoginForm

  Mixins
] = [
  require 'react/addons'

  require 'components/layouts/layout_checkout/layout_checkout'

  require 'components/quanta/icons/right_arrow/right_arrow'
  require 'components/atoms/terms_and_conditions/terms_and_conditions'
  require 'components/organisms/forms/login_form/login_form'

  require 'components/mixins/mixins'

  require './checkout_login.scss'
]

module.exports = React.createClass
  BLOCK_CLASS: 'c-checkout-login'

  mixins: [
    Mixins.context
    Mixins.classes
    Mixins.dispatcher
  ]

  propTypes:
    heading: React.PropTypes.string
    routeLoggedIn: React.PropTypes.string
    showTnc: React.PropTypes.bool

  getDefaultProps: ->
    routeLoggedIn: '/checkout/step/information'
    routeForgotPassword: '/checkout/forgot-password'
    heading: 'I’m new here'
    introCaption: 'You’ll have an opportunity to create an account later.'
    formHeading: 'Sign in'
    loginErrors: {}
    showTnc: false

  getStaticClasses: ->
    sections: '
      u-grid__row
      u-mt48 u-mt72--600
      u-tal u-tac--600
    '
    section: '
      u-grid__col u-w12c u-w6c--600
      u-fs16
    '
    sectionNew: '
      u-pb24 u-pb0--600 u-pr24--600
    '
    heading: '
      u-ffs u-fws
      u-fs24 u-mt0 u-mb24
    '
    introCaption: '
      u-ffss
      u-color--dark-gray-alt-2
    '
    continueArrow: '
      u-icon u-fill--blue -icon-inline
    '
    loginArrow: '
      u-icon u-fill--white -icon-inline
    '
    forgot: '
      u-mt24 u-mb24 u-tac
    '
    link: '
      u-link--underline
      u-fs12
    '
    cta: "#{@BLOCK_CLASS}__cta"
    bordered:'
      u-btss u-btw1 u-btw0--600
      u-blss--600 u-blw1--600
      u-bc--dark-gray-alt-2'
    sectionForm:
      'u-pt24 u-pt0--600 u-pl24--600'
    terms:
      'u-w6c--600
      u-mt8 u-mt48--600 u-mb12
      u-fs12'


  render: ->
    classes = @getClasses()

    txtSubmit = ['Checkout', <RightArrow cssUtility=classes.loginArrow />]

    <div>
      <div className=classes.sections>
        <section className=classes.section>
          <div className=classes.sectionNew>
            <h1 className=classes.heading children=@props.heading />
            <p className=classes.introCaption children=@props.introCaption />
            <a className=classes.continue href=@props.routeLoggedIn>
              Continue as a new customer
              <RightArrow cssUtility=classes.continueArrow />
            </a>
          </div>
        </section>

        <section className="#{classes.section} #{classes.bordered}">
          <div className=classes.sectionForm>
            <h1 className=classes.heading children=@props.formHeading />
            <LoginForm
              routeSubmitForm=@props.routeLoggedIn
              txtSubmit=txtSubmit
              manageSubmit=@props.manageLoginSubmit
              loginErrors=@props.loginErrors
              ctaModifier=classes.cta />

            <div className=classes.forgot>
              <a
                href=@props.routeForgotPassword
                className=classes.link
                children='Forgot password?' />
            </div>
          </div>
        </section>
      </div>

      {if @props.showTnc
        <TermsAndConditions
          variation='checkoutLogin'
          cssModifier=classes.terms />
      }
    </div>
