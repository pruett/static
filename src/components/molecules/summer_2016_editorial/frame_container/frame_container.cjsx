[
  _
  React

  CTA
  Img

  Mixins

] = [

  require 'lodash'
  require 'react/addons'

  require 'components/atoms/buttons/cta/cta'
  require 'components/atoms/images/img/img'

  require 'components/mixins/mixins'

]

module.exports = React.createClass

  BLOCK_CLASS: 'c-summer-2016-editorial-frame-container'

  mixins: [
    Mixins.classes
    Mixins.image
  ]

  getStaticClasses: ->
    block: '
      u-grid
      u-mla u-mra
      u-mw1440
    '
    row: '
      u-grid__row
      u-tac
      u-btw1 u-btss u-bc--light-gray
      u-pt36 u-pt72--600 u-pt84--900
    '
    header: '
      u-reset
      u-summer-2016__cta-header
      u-typekit--filson
      u-mb36 u-mb48--600 u-mb84--900
      u-color--black
    '
    column: '
      u-grid__col u-w12c -c-5--600 -c-5--900
      u-mb48 u-mb72--600 u-mb120--900
      u-tac
    '
    columnLeft: '
      u-grid__col u-w12c -c-5--600 -c-5--900
      u-mb48 u-mb72--600 u-mb120--900
      u-mr48--600 u-mr72--900
      u-tac
    '
    cta: '
      u-button -button-white -button-modular
      u-mb12 u-mb0--600
    '
    img: '
      u-w100p
      u-mb36 u-mb48--600
    '
    newText: '
      u-reset
      u-summer-2016__cta-header
      u-color--blue
      u-fwb
    '

  frameSizes: [
    breakpoint: 0
    width: '100vw'
  ,
    breakpoint: 600
    width: '40vw'
  ,
    breakpoint: 900
    width: '60vw'
  ]

  getImgProps: (frame) ->
    url: frame.img
    widths: [200, 300, 400, 500, 600, 700, 800, 900]

  getWPEventSLug: (cta) ->
    #  Scheme: PromoBlock-Click-name_of_section_block__buttonName
    "PromoBlock-Click-#{cta.section_name}__#{_.camelCase cta.text}"

  renderSection: (section, i) ->
    <div key=i>
      <div className=@classes.header>
        {
          if section.new_text
            <span className=@classes.newText children=section.new_text />
        }
          <span children=section.headline />
      </div>
      {
        _.map section.frames, (frame, i) =>
          cta = frame.cta
          imgSrc = @getSrcSet @getImgProps(frame)
          sizes = @getImgSizes @sizes
          <div className={if i/2 is 0 then @classes.columnLeft else @classes.column} key=i>
            <Img srcSet=imgSrc sizes=sizes cssModifier=@classes.img />
            <CTA
              tagName='a'
              href=cta.href
              children=cta.text
              cssModifier=@classes.cta
              analyticsSlug={@getWPEventSLug(cta)}
            />
          </div>
      }
    </div>

  render: ->
    @classes = @getClasses()
    sunFrames = _.get @props, 'content.sun', {}
    opticalFrames = _.get @props, 'content.optical', {}

    <section className=@classes.block>
      <div className=@classes.row>
        {
          _.map [opticalFrames, sunFrames], @renderSection
        }
      </div>
    </section>
