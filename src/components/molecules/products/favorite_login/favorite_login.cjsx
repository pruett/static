_ = require 'lodash'
React = require 'react/addons'
IconX = require 'components/quanta/icons/x/x'
Input = require 'components/atoms/forms/input/input'
Mixins = require 'components/mixins/mixins'
SuccessCheck = require 'components/quanta/icons/success_check/success_check'
LoginForm = require 'components/organisms/forms/login_form/login_form'
CTA = require 'components/atoms/buttons/cta/cta'

require './favorite_login.scss'

module.exports = React.createClass
  BLOCK_CLASS: 'c-frame-favorite-login-modal'

  mixins: [
    Mixins.analytics
    Mixins.classes
    Mixins.context
    Mixins.dispatcher
  ]

  propTypes: ->
    session: React.PropTypes.object
    routeForgotPassword: React.PropTypes.string

  getStaticClasses: ->
    modal: "
      #{@BLOCK_CLASS}
      u-db u-mla u-mra u-pr u-pt18 u-pb18
    "
    close: "
      #{@BLOCK_CLASS}__close
      u-pa
      u-button-reset
    "
    visualHeader: '
      u-tac
    '
    heading: "
      u-fs20 u-fs24--600 u-fs30--900 u-fws u-ffs u-tac
    "
    subheading: "
      u-fs16 u-fs18--900 u-ffss u-fwl u-tac
    "
    animationContainer: "
      #{@BLOCK_CLASS}__animation-container
      u-oh u-mla u-mra
    "
    animation: "
      #{@BLOCK_CLASS}__animation
    "
    animationImage: "
      #{@BLOCK_CLASS}__animation-image
      u-db u-w100p
    "
    action: '
      u-fs16 u-ffss u-fws u-db u-tac
      u-dib u-fs16 u-pb4 u-bss u-bw0 u-bbw1
    '
    ctaButton: "
      #{@BLOCK_CLASS}__cta-button
    "
    loginForm: '
      u-w10c u-m0a
    '
    forgot: '
      u-ffss u-fs12 u-tac
    '

  getInitialState: ->
    newAccount: true

  toggleAccountState: (slug) ->
    @trackInteraction slug
    @setState newAccount: !@state.newAccount

  manageSubmit: (attrs) ->
    if @state.newAccount
      @trackInteraction 'favoritesModal-click-createAccount'
      @commandDispatcher(
        'session'
        'createNewCustomer'
        _.extend attrs, { minimal: true, fromFavoriteModal: true, origin: 'web_store_favorites' }
      )
    else
      @trackInteraction 'favoritesModal-click-login'
      @commandDispatcher(
        'session'
        'login'
        attrs
        routeSuccess: null, fromFavoriteModal: true
      )

  getDefaultProps: ->
    routeForgotPassword: '/account/forgot-password'

  handleClose: ->
    slug = "close#{if _.get(@props, 'session.isLoggedIn') then 'Success' else ''}Modal"
    @trackInteraction "favoritesModal-click-#{slug}"
    @commandDispatcher 'favorites', 'closeLogin'

  render: ->
    classes = @getClasses()
    session = @props.session or {}

    copy =
      newAccount:
        heading: 'Let\'s get you signed up'
        subheading: 'Create an account so you\'ll have a place to store your favorites.'
        button: 'Create Account'
        link: 'I already have an account'
        clickTrack: 'favoritesModal-click-alreadyHaveAccount'
        validationError: session.newCustomerErrors

      hasAccount:
        heading: 'Sign In'
        subheading: 'Sign in to your account to access your favorites.'
        button: 'Log In'
        link: 'I need to create an account'
        clickTrack: 'favoritesModal-click-needToCreateAccount'
        validationError: session.loginErrors
        forgotPassword: 'Forgot password?'

    formCopy = if @state.newAccount then copy.newAccount else copy.hasAccount

    successCopy =
      CTA: 'Got It'
      subheading: 'Just click "account" to access your favorites page.'
      slug: 'favoritesModal-click-favoritesAddedGotIt'

    favoritesGlassesUrl = "https://i.warbycdn.com/v/c/assets/signup-animation/image/signup-animation/0/0195502638.png"

    <div className=classes.modal>
      <button className=classes.close onClick=@handleClose>
        <IconX cssModifier=classes.iconX cssUtility='u-icon u-fill--light-gray'/>
      </button>
      {if session.isLoggedIn
        <div>
          <div>
            <div className=classes.visualHeader><SuccessCheck/></div>
            <h1 className=classes.heading>Added to your favorites</h1>
            <p className=classes.subheading children=successCopy.subheading />
            <div className='u-tac'>
              <CTA
                children=successCopy.CTA
                analyticsSlug=successCopy.slug
                onClick=@props.manageSuccessClose
              />
            </div>
          </div>
        </div>
      else
        <div>
          <div>
            <div className=classes.visualHeader>
              <div className=classes.animationContainer>
                <div className=classes.animation>
                  <img className=classes.animationImage src=favoritesGlassesUrl />
                </div>
              </div>
            </div>
            <div className='u-tac'>
              <h1 className=classes.heading children=formCopy.heading />
              <p className=classes.subheading children=formCopy.subheading />
              <LoginForm
                txtSubmit=formCopy.button
                hideNameFields=true
                loginErrors=formCopy.validationError
                manageSubmit=@manageSubmit
                ctaModifier=classes.ctaButton
                cssModifier=classes.loginForm
                showEmailOptIn={@state.newAccount and @getLocale('country') is 'CA'}
                showTermsAndConditions=@state.newAccount
              />

              {unless @state.newAccount
                <div className=classes.forgot>
                  <a href=@props.routeForgotPassword children=formCopy.forgotPassword />
                </div>}

              <a
                className=classes.action
                onClick={@toggleAccountState.bind(@, formCopy.clickTrack)}
                children=formCopy.link
              />
            </div>
          </div>
        </div>
      }
    </div>
