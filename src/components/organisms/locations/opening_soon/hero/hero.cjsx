[
  _
  React

  Breadcrumbs
  Picture
  EmailCapture

  Mixins
] = [
  require 'lodash'
  require 'react/addons'

  require 'components/atoms/breadcrumbs/breadcrumbs'
  require 'components/atoms/images/picture/picture'
  require 'components/organisms/forms/retail_email_capture_form/retail_email_capture_form'

  require 'components/mixins/mixins'
]

require './hero.scss'

module.exports = React.createClass

  BLOCK_CLASS: 'c-opening-soon--hero'

  mixins: [
    Mixins.callout
    Mixins.classes
    Mixins.image
  ]

  propTypes:
    images: React.PropTypes.array
    locationShortName: React.PropTypes.string
    retailEmailCapture: React.PropTypes.shape
      emailCaptureErrors: React.PropTypes.object
      isEmailCaptureSuccessful: React.PropTypes.bool
    breadcrumbs: React.PropTypes.arrayOf(React.PropTypes.object)
    storeName: React.PropTypes.string
    locationShortName: React.PropTypes.string
    gmaps_url: React.PropTypes.string

  getDefaultProps: ->
    images: []

  getStaticClasses: ->
    block:
      "#{@BLOCK_CLASS}"
    wrapper:
      'u-pr u-h0--900 u-pb2x1--900'
    copyGrid:
      'u-grid -maxed u-ma'
    copyRow:
      'u-grid__row u-tal'
    copyCol:
      'u-pr--900
      u-grid__col
      u-w12c u-w10c--900 u-w8c--1200
      u-l2c--1200 u-l1c--900
      u-tac u-mb0--900'
    callout:
      'u-ma u-mw1440'
    copy:
      'u-pa--900 u-t50p--900 u-ttyn50--900
      u-l0--900 u-r0--900 u-ma--900 u-w100p--900'
    picture: '
      u-db u-oh u-pr
      u-pa--900 u-l0--900
      u-w100p u-h0
      u-pb2x1
    '
    content: "
      #{@BLOCK_CLASS}__content
      u-pb48 u-pr60--900 u-pl60--900 u-pt48--900 u-pb60--900
      u-color-bg--white--900
      u-bbw1 u-bbss u-bc--light-gray
      u-bw0--900
    "
    pictureWrapper: '
      u-pr u-ps--900
    '
    taglineContainer: "
      #{@BLOCK_CLASS}__tagline-container
      u-pr u-tac
      u-mt42 u-mt0--900
    "
    tagline: "
      #{@BLOCK_CLASS}__tagline
      u-fs12 u-fws u-ttu u-ls2 u-color--dark-gray-alt-2
      u-pr u-pt0 u-pb0 u-pr12 u-pl12 u-color-bg--white
    "
    locationHeadline: '
      u-ffs u-fws u-fs30 u-fs40--600
      u-mb12 u-mt66
    '
    locationLink: '
      u-ffss u-fs18 u-mb30
    '
  mapSize: (size) ->
    image = _.find _.get(@props, 'images'), size: size.name

    return size unless image
    switch size.name
      when 'desktop-hd'
        image.widths = _.range 1200, 1800, 100
        image.mediaQuery = '(min-width: 1200px)'
        image.sizes = '(min-width: 1440px) 1440px, 100vw'
      when 'desktop-sd'
        image.widths = _.range 900, 1800, 100
        image.mediaQuery = '(min-width: 900px)'
        image.sizes = '(min-width: 1440px) 1440px, 100vw'
      when 'tablet'
        image.widths = _.range 600, 900, 100
        image.mediaQuery = '(min-width: 600px)'
        image.sizes = '100vw'
      else
        image.widths = _.range 300, 600, 100
        image.mediaQuery = '(min-width: 0)'
        image.sizes = '100vw'
    image

  render: ->
    classes = @getClasses()
    style = if @props.border_color then borderColor: @props.border_color else {}

    <section className=classes.block>
      <div className=classes.callout>
        <div className=classes.wrapper>
          <div className=classes.pictureWrapper>
            <Picture
              cssModifier=classes.picture
              children={@getPictureChildren(
                sources: @SIZES.map @mapSize
                img:
                  className: 'u-db u-w100p'
                  alt: @props.alt
              )}/>
            <Breadcrumbs
              links=@props.breadcrumbs
              cssModifier='-over-hero' />
          </div>
          <div className=classes.copy>
            <div className=classes.copyGrid>
              <div className=classes.copyRow>
                <div className=classes.copyCol>
                  <div className=classes.content>
                    <div className=classes.taglineContainer>
                      <span className=classes.tagline>{@props.opening_tagline}</span>
                    </div>
                    <h1 className=classes.locationHeadline>{@props.storeName}</h1>
                    <a
                      target="_blank"
                      href=@props.gmaps_url
                      className=classes.locationLink
                      children=@props.address
                    />
                    <EmailCapture
                      {...@props.retailEmailCapture}
                      copy=@props.email_capture_copy
                      locationShortName=@props.locationShortName
                    />
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </section>
