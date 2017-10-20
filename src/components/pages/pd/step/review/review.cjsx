[
  _
  React

  ReloadArrow
  CTA
  Picture
  LayoutMinimal
  AccountForm
  OnboardingStep
  Footer

  Mixins
] = [
  require 'lodash'
  require 'react/addons'

  require 'components/quanta/icons/reload_arrow/reload_arrow'
  require 'components/atoms/buttons/cta/cta'
  require 'components/atoms/images/picture/picture'
  require 'components/layouts/layout_minimal/layout_minimal'
  require 'components/organisms/account/account_form/account_form'
  require 'components/organisms/pd/onboarding_step/onboarding_step'
  require 'components/molecules/pd/footer/footer'

  require 'components/mixins/mixins'

  require './review.scss'
]

module.exports = React.createClass

  BLOCK_CLASS: 'c-pd-review'

  mixins: [
    Mixins.context
    Mixins.classes
    Mixins.dispatcher
  ]

  statics:
    route: ->
      path: '/pd/review'
      handler: 'Pd'
      bundle: 'pd'

  receiveStoreChanges: ->
    [
      'pd'
      'session'
    ]

  getDefaultProps: ->
    showFooter: false
    showHelpFooter: true
    heading: 'Review and Submit'
    description: 'Once you submit a photo, our eyewear experts will
      determine your pupillary distance and apply it to your order.'
    defaultImage:
      src: '//i.warbycdn.com/v/c/assets/pd/image/02M-Profile/1/95b2a1d605.jpg'
      alt: 'Example photo'
      width: '100%'
      height: '100%'
    routeForgotPassword: '/account/forgot-password'
    routeLoginSuccess: '/pd/review'
    routeNewCustomerSuccess: '/pd/review'
    buttonText: 'Submit photo'
    retakePhoto: 'Retake photo'
    checklistItems: [
      {
        text: 'Is the card under your nose and touching your face?'
      },
      {
        text: 'Is the magnetic strip facing outward and right side up?'
      },
      {
        text: 'Is the photo well lit and level with your face?'
      }
    ]

  getStaticClasses: ->
    block: "#{@BLOCK_CLASS} u-grid -maxed u-ma u-pr u-tac
      u-fs16 u-fs18--900 u-color--dark-gray-alt-3"
    heading: 'u-grid__col -c-12 -c-7--900 u-fs30 u-fs55--900
      u-ffs u-fws u-mt24 u-mb12 u-color--dark-gray'
    description: 'u-grid__col u-w12c -c-7--900
      u-ffss u-fs16 u-fs18--900 u-mt0 u-mb48'
    rowCenter: 'u-grid__row -center'
    imageWrapper: "#{@BLOCK_CLASS}__image-wrapper
      u-grid__col u-w12c u-w6c--900 u-fs16"
    textWrapper: "#{@BLOCK_CLASS}__text-wrapper
      u-grid__col u-w12c u-w6c--900 u-fs16 u-tal"
    layout: '-use-grid -full-page'
    retakePhoto: "#{@BLOCK_CLASS}__retake-photo
      u-button -button-white -button-large
      u-fs16 u-ffss u-fws u-mt18 u-mr6"
    submitPhoto: "#{@BLOCK_CLASS}__submit-photo
      u-button -button-blue -button-large
      u-fs16 u-ffss u-fws u-mt18 u-ml6"
    checklist: "#{@BLOCK_CLASS}__checklist u-reset"
    checklistItem: "#{@BLOCK_CLASS}__checklist-item
      u-ffss u-fs16 u-fs18--900 u-mb18 u-color--dark-gray-alt-3"
    subHeader: 'u-ffss u-fws u-fs18 u-fs20--900
      u-color--dark-gray u-mt24 u-mt48--900'

  manageLoginSubmit: (attrs) ->
    @commandDispatcher 'session', 'login', attrs,
      routeSuccess: @props.routeLoginSuccess

  manageNewCustomerSubmit: (attrs) ->
    @commandDispatcher 'session', 'createNewCustomer',
      attrs, @props.routeNewCustomerSuccess

  submitPhoto: ->
    @commandDispatcher 'pd', 'submit'
  
  retakePhoto: ->
    window.location.href = '/pd/webcam'

  render: ->
    session = @getStore('session')
    authenticated = session.__fetched? and session.customer?

    pdStore = @getStore('pd')
    imgSrc = pdStore.image?.src or @props.defaultImage?.src or {}

    classes = @getClasses()

    <LayoutMinimal cssModifier=classes.layout {...@props}>
      <div className=classes.block>
        <div className=classes.rowCenter>
          <h1 className=classes.heading children=@props.heading />
          <p className=classes.description children=@props.description />
        </div>
        <div className=classes.rowCenter>
          <div className=classes.imageWrapper >
            <img src=imgSrc />
          </div>
          <div className=classes.textWrapper>
            {if authenticated
              <div className=classes.textContainer>
                <h3 className=classes.subHeader>Photo checklist</h3>

                <ul className=classes.checklist>
                  {@props.checklistItems.map (checklistItem) =>
                    <li className=classes.checklistItem children={checklistItem.text} />
                  }
                </ul>

                <CTA
                  analyticsSlug='pd-click-retakePhoto'
                  variation='minimal'
                  cssUtility=classes.retakePhoto
                  children=@props.retakePhoto
                  onClick=@retakePhoto />

                <CTA
                  analyticsSlug='pd-click-submitPhoto'
                  variation={'minimal' if pdStore.image and authenticated}
                  cssUtility=classes.submitPhoto
                  disabled={not (pdStore.image and authenticated)}
                  children=@props.buttonText
                  onClick=@submitPhoto />
              </div>
            else
              <AccountForm {...@props} {...@getStore('session')}
                manageLoginSubmit=@manageLoginSubmit
                manageNewCustomerSubmit=@manageNewCustomerSubmit />
            }
          </div>
        </div>
      </div>
    </LayoutMinimal>
