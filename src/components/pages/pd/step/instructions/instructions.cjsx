[
  _
  React

  LayoutMinimal
  PhotoUpload
  OnboardingStep
  Footer

  Mixins
] = [
  require 'lodash'
  require 'react/addons'

  require 'components/layouts/layout_minimal/layout_minimal'
  require 'components/molecules/pd/photo_upload/photo_upload'
  require 'components/organisms/pd/onboarding_step/onboarding_step'
  require 'components/molecules/pd/footer/footer'

  require 'components/mixins/mixins'
]

module.exports = React.createClass
  BLOCK_CLASS: 'c-pd'

  statics:
    route: ->
      path: '/pd/instructions'
      handler: 'Pd'
      bundle: 'pd'

  mixins: [
    Mixins.context
    Mixins.classes
    Mixins.dispatcher
    Mixins.routing
    Mixins.analytics
  ]

  getDefaultProps: ->
    showFooter: false
    showHelpFooter: true
    header: 'Measure your pupillary distance (PD)'
    description: 'PD is the distance between your pupils, and it\'s used to help center a
      prescription correctly in your frames. Before using our PD tool, review the steps below.'
    steps: [
      {
        step: 1
        header: '1. Wearing glasses? Take them off for your photo.'
        description: 'It also helps to be in a well-lit area with a clean background.'
        image: [
          {
            srcSet: '//i.warbycdn.com/v/c/assets/pd/image/01DTM-Glasses-Off/2/f4e5cab5cf.jpg'
            alt: '1. Wearing glasses? Take them off for your photo.'
          }
        ]
        video: {
          mobile: {
            poster: '//i.warbycdn.com/v/c/assets/pd/image/01DTM-Glasses-Off/2/f4e5cab5cf.jpg'
            source: '//player.vimeo.com/external/225106950.hd.mp4?s=b52d4ba7f42e3f219f4fdfe41b8db6448296587d&profile_id=175'
          },
          tablet: {
            poster: '//i.warbycdn.com/v/c/assets/pd/image/01DTM-Glasses-Off/2/f4e5cab5cf.jpg'
            source: '//player.vimeo.com/external/225106950.hd.mp4?s=b52d4ba7f42e3f219f4fdfe41b8db6448296587d&profile_id=175'
          },
          desktop: {
            poster: '//i.warbycdn.com/v/c/assets/pd/image/01DTM-Glasses-Off/2/f4e5cab5cf.jpg'
            source: '//player.vimeo.com/external/225106950.hd.mp4?s=b52d4ba7f42e3f219f4fdfe41b8db6448296587d&profile_id=175'
          }
        }
        next:
          route: '/pd/instructions/card'
      },
      {
        step: 2
        header: '2. Adjust your screen and look directly at the camera.'
        description: 'It should be positioned straight on with your face centered.'
        image: [
          {
            srcSet: '//i.warbycdn.com/v/c/assets/pd/image/02M-Profile/2/62eb5725dd.jpg'
            alt: '2. Adjust your screen and look directly at the camera.'
          }
        ]
        video: {
          mobile: {
            poster: '//i.warbycdn.com/v/c/assets/pd/image/02M-Profile/2/62eb5725dd.jpg'
            source: '//player.vimeo.com/external/225439337.hd.mp4?s=2196d7a59e11082d8112ed3c6d9795e982251667&profile_id=175'
          },
          tablet: {
            poster: '//i.warbycdn.com/v/c/assets/pd/image/02T-Profile/2/92b6837a71.jpg'
            source: '//player.vimeo.com/external/225439148.hd.mp4?s=f9239ea80bc8917c396b6cf3f13f8cd07c7e241f&profile_id=175'
          },
          desktop: {
            poster: '//i.warbycdn.com/v/c/assets/pd/image/02D-Profile/2/45cdebab69.jpg'
            source: '//player.vimeo.com/external/225439482.hd.mp4?s=bc0c9b135966e8bf212c372d2f4892736d3fd36d&profile_id=175'
          }
        }
        prev:
          route: '/pd/instructions/glasses'
        next:
          route: '/pd/instructions/photo'
      },
      {
        step: 3
        header: '3. Place any card with a magnetic strip under your nose and snap a photo.'
        description: 'Make sure the card is touching your face, with the strip facing outward and right side up.'
        image: [
          {
            srcSet: '//i.warbycdn.com/v/c/assets/pd/image/profile-card-up/0/4b8db08191.jpg'
            alt: '3. Place any card with a magnetic strip under your nose and snap a photo.'
          }
        ]
        video: {
          mobile: {
            poster: '//i.warbycdn.com/v/c/assets/pd/image/profile-card-up/0/4b8db08191.jpg'
            source: '//player.vimeo.com/external/225169775.hd.mp4?s=702018b607d50fec85a02a90eb3c455a0c62df93&profile_id=175'
          },
          tablet: {
            poster: '//i.warbycdn.com/v/c/assets/pd/image/profile-card-up/0/4b8db08191.jpg'
            source: '//player.vimeo.com/external/225169775.hd.mp4?s=702018b607d50fec85a02a90eb3c455a0c62df93&profile_id=175'
          },
          desktop: {
            poster: '//i.warbycdn.com/v/c/assets/pd/image/profile-card-up/0/4b8db08191.jpg'
            source: '//player.vimeo.com/external/225169775.hd.mp4?s=702018b607d50fec85a02a90eb3c455a0c62df93&profile_id=175'
          }
        }
        prev:
          route: '/pd/instructions/card'
      }
    ]

  getStaticClasses: ->
    block: "#{@BLOCK_CLASS} u-grid -maxed u-ma u-pr u-tac
      u-fs16 u-fs18--900 u-color--dark-gray-alt-3"
    header: 'u-grid__col -c-12 -c-7--900 u-fs30 u-fs55--900
      u-ffs u-fws u-mt24 u-mb12 u-color--dark-gray'
    description: 'u-grid__col u-w12c -c-7--900
      u-ffss u-fs16 u-fs18--900 u-mt0 u-mb60'
    onboardingStep: 'u-grid__col u-w12c'
    onboardingWrapper: 'u-grid__row -center u-pr'
    photoUpload: 'u-grid__col -c-12 u-mb24 -c-6--900
      u-pr--900 u-l25p--900 u-tal--900 u-mt36--900 u-ml36--900'
    rowCenter: 'u-grid__row -center'

  getInitialState: ->
    activeIndex: 0
    isDesktop: @isDesktop()
    isTablet: @isTablet()

  componentDidMount: ->
    @setDesktop()
    @setTablet()
    @onResize = _.throttle @setMatchMedia, 250
    window.addEventListener('resize', @onResize)

    # set interval should be longer than the longest video
    @stepInterval = setInterval(@setIndex, 5000)

  componentWillUnmount: ->
    clearInterval @stepInterval
    window.removeEventListener 'resize', @onResize

  isDesktop: ->
    if window?
      window.matchMedia("(min-width: 1200px)").matches
    else
      false

  setDesktop: ->
    @setState isDesktop: @isDesktop()

  isTablet: ->
    if window?
      window.matchMedia("(min-width: 900px").matches
    else
      false

  setTablet: ->
    @setState isTablet: @isTablet()

  setMatchMedia: ->
    @setDesktop()
    @setTablet()

  setIndex: (index) ->
    if index?
      stepIndex = index
    else
      stepIndex = @state.activeIndex + 1
    if stepIndex > (@props.steps.length - 1)
      stepIndex = 0
    @setState activeIndex: stepIndex

  onClick: (stepIndex) ->
    clearInterval @stepInterval
    @setIndex stepIndex

  render: ->
    classes = @getClasses()

    <LayoutMinimal cssModifier='-use-grid -full-page' {...@props}>
      <div className=classes.block>
        <div className=classes.rowCenter>
          <h1 className=classes.header children=@props.header />
        </div>
        <div className=classes.rowCenter>
          <p className=classes.description children=@props.description />
        </div>
        <div className=classes.onboardingWrapper>
          {@props.steps.map (step, index) =>
            <OnboardingStep
              cssUtility=classes.onboardingStep
              key={step.step} {...step}
              stepIndex={index}
              onChange=@onClick
              onClick={@onClick.bind(@, index)}
              isActive={@state.activeIndex is index}
              isDesktop=@state.isDesktop
              isTablet=@state.isTablet />
          }
        </div>
        <div className=classes.rowCenter>
          <PhotoUpload cssModifier=classes.photoUpload />
        </div>
      </div>
    </LayoutMinimal>
