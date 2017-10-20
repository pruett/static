[
  _
  React

  Img

  Mixins
] = [
  require 'lodash'
  require 'react/addons'

  require 'components/atoms/images/img/img'

  require 'components/mixins/mixins'
]

module.exports = React.createClass
  mixins: [
    Mixins.analytics
    Mixins.classes
    Mixins.image
  ]

  propTypes:
    activeColor: React.PropTypes.object
    content: React.PropTypes.object
    cssModifier: React.PropTypes.string

  getDefaultProps: ->
    activeColor: {}
    content: {}
    cssModifier: ''

  getStaticClasses: ->
    block: @props.cssModifier
    image: 'u-w7c u-w5c--600
      u-db u-di--600
      u-mla u-mra u-mb30 u-mb0--600'
    content: 'u-fr--600
      u-w6c--600
      u-tac u-tal--600'
    heading: 'u-mt0 u-mb12
      u-heading-sm'
    copy: 'u-mb18
      u-ffss u-fs16 u-fs18--1200 u-color--dark-gray-alt-3'
    link: 'u-bw0 u-bbw1 u-bbw0--900 u-bss
      u-pb4
      u-ffss u-fws u-fs16 u-fs18--1200'

  handleClickBridgeLearnMore: (evt) ->
    @trackInteraction "#{@props.activeColor.analytics_category}-click-bridgeLearnMore", evt

  getLandingUrl: ->
    gender = _.get @props.activeColor, 'gender'
    "/low-bridge-fit/#{
      if gender is 'f'
        'women'
      else if gender is 'm'
        'men'
      else
        ''
    }"

  render: ->
    classes = @getClasses()

    <section className=classes.block>
      <Img srcSet="#{_.get @props.content, 'image'} 2x"
        sizes=@getImgSizes()
        cssModifier=classes.image
      />
      <div className=classes.content>
        <h3 className=classes.heading children='Low Bridge Fit' />
        <div className=classes.copy
          children={_.get @props.content, 'frame_description', ''} />
        <a children='Learn more'
          href=@getLandingUrl()
          className=classes.link
          onClick=@handleClickBridgeLearnMore
        />
      </div>
    </section>
