[
  _
  React

  Img
  LayoutMinimal

  Mixins
] = [
  require 'lodash'
  require 'react/addons'

  require 'components/atoms/images/img/img'
  require 'components/layouts/layout_minimal/layout_minimal'

  require 'components/mixins/mixins'

  require './success.scss'
]

module.exports = React.createClass
  BLOCK_CLASS: 'c-pd-success'

  mixins: [
    Mixins.classes
    Mixins.context
    Mixins.image
  ]

  statics:
    route: ->
      path: '/pd/success'
      handler: 'Pd'
      bundle: 'pd'

  getDefaultProps: ->
    showFooter: false
    showHelpFooter: true
    header: 'Photo received!'
    description: 'We’ll email you once our team reviews your pupillary distance.'
    image: 
      src: '//i.warbycdn.com/v/c/assets/pd/image/thumbs-up-2x/1/161ba4062f.jpg'
    steps: [
      {
        header: 'Download our app'
        description: <span>It’s the <a href="/app" className="u-fws">easiest way</a> to
          shop frames, order Home Try-Ons, and track packages.</span>
        image: 
          src: '//i.warbycdn.com/v/c/assets/pd/image/01-Download-the-app/0/e68704c524.jpg'
          alt: 'Download our app'
      },
      {
        header: 'Get reimbursed'
        description: <span>If you have <a href="/insurance" className="u-fws">vision insurance</a>, 
          you can apply for reimbursement. You can also use flexible spending account
          (<a href="/flexible-spending-accounts" className="u-fws">FSA</a>) and health savings account
          (<a href="/flexible-spending-accounts" className="u-fws">HSA</a>) dollars.</span>
        image:
          src: '//i.warbycdn.com/v/c/assets/pd/image/02-Reimbursement/0/c31d5c614e.jpg'
          alt: 'Get reimbursed'
      },
      {
        header: 'Visit us in real life'
        description: <span>Our <a href="/retail" className="u-fws">stores</a> offer glasses,
          books, photo booths, and comfy places to hang. Plus our Store Advisors are super friendly.</span>
        image:
          src: '//i.warbycdn.com/v/c/assets/pd/image/03-Retail/0/b7806d05de.jpg'
          alt: 'Visit us in real life'
      }
    ]

  getStaticClasses: ->
    block: "#{@BLOCK_CLASS} u-grid -maxed u-ma u-pr u-tac
      u-fs16 u-fs18--900 u-color--dark-gray-alt-3"
    rowCenter: 'u-grid__row -center'
    header: 'u-grid__col -c-12 -c-7--900 u-fs30 u-fs55--900
      u-ffs u-fws u-mt24 u-mb12 u-color--dark-gray'
    image: 'u-pt24 u-w1c u-m0a'
    description: 'u-grid__col u-w12c -c-7--900
      u-ffss u-fs16 u-fs18--900 u-mt0 u-mb48'
    stepsWrapper: 'u-grid__row -center u-pt72--900'
    stepWrapper: 'u-grid__col u-w12c -c-4--900'
    stepHeader: 'u-ffss u-fws u-fs18 u-fs20--900
      u-color--dark-gray u-mt24 u-mt36--900 u-mb12'
    stepDescription: 'u-fs16 u-fs18--900 u-ffss
      u-color--dark-gray-alt-3 u-mt0 u-mb48 u-mb0--900'
    dividerWrapper: 'u-grid__col u-w12c'
    divider: "#{@BLOCK_CLASS}__divider u-color--light-gray-alt-1
      u-color-bg--light-gray-alt-1 u-dn u-db--900"

  getImageProps: (image) ->
    alt: image.alt
    srcSet: @getSrcSet(
      url: image.src
      widths: [320, 448, 512, 622, 700, 870]
      quality: 80
    )
    sizes: @getImgSizes [
      {
        breakpoint: 0
        width: '100vw'
      },
      {
        breakpoint: 600
        width: '33vw'
      },
      {
        breakpoint: 1440
        width: '480px'
      }
    ]

  render: ->
    classes = @getClasses()

    <LayoutMinimal cssModifier='-use-grid -full-page' {...@props}>
      <div className=classes.block>
        <div className=classes.rowCenter>
          <div className=classes.image>
            <img {...@props.image} />
          </div>
        </div>
        <div className=classes.rowCenter>
          <h1 className=classes.header children=@props.header />
        </div>
        <div className=classes.rowCenter>
          <p className=classes.description children=@props.description />
        </div>
        <div className=classes.rowCenter>
          <div className=classes.dividerWrapper>
            <hr className=classes.divider />
          </div>
        </div>
        <div className=classes.stepsWrapper>
          {@props.steps.map (step) =>
            <div className=classes.stepWrapper>
              <Img {...@getImageProps(step.image)} />
              <h3 className=classes.stepHeader children=step.header />
              <p className=classes.stepDescription children=step.description />
            </div>
          }
        </div>
      </div>
    </LayoutMinimal>
