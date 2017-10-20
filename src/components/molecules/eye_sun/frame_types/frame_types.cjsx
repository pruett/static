[
  _
  React

  TabBar
  Img

  Mixins

] = [
  require 'lodash'
  require 'react/addons'

  require 'components/molecules/tab_bar/tab_bar'
  require 'components/atoms/images/img/img'

  require 'components/mixins/mixins'

  require './frame_types.scss'
]

module.exports = React.createClass

  BLOCK_CLASS: 'c-eyesun-frame-types'

  mixins: [
    Mixins.classes
    Mixins.image
  ]

  getDefaultProps: ->
    heading: ''
    description: ''
    types: []

  getStaticClasses: ->
    block:
      "#{@BLOCK_CLASS}
      u-grid__col -c-12 -c-10--600 -c-8--900"
    heading:
      'u-ffs u-fws u-reset u-fs20 u-fs30--600 u-fs34--900 u-fs40--1200 u-mb24'
    description:
      'u-reset u-fs16 u-fs18--900
      u-color--dark-gray-alt-3
      u-ffss
      u-pb48 u-pb60--600 u-pb72--900'
    content:
      'u-grid__row
      u-tac'
    image:
      'u-db
      u-mb24 u-mra u-mla'
    bullets:
      'u-grid__col u-w12c -c-8--600
      u-tal
      u-list-reset'
    bullet:
      "#{@BLOCK_CLASS}__bullet
      u-reset u-fs16 u-mb24 u-fs18--900 u-mb12--900
      u-color--dark-gray-alt-3
      u-ffss
      u-pr"

  mapBullet: (bullet, i) ->
    <li className=@classes.bullet children=bullet key=i />

  mapTab: (type, i) ->
    attrsSrcSet =
      url: type.image
      quality: type.quality or 70
      widths: _.range 320, 1500, 200

    heading: type.name
    content:
      <div className=@classes.content key=i>
        <Img cssModifier=@classes.image
          srcSet={@getSrcSet attrsSrcSet}
          sizes='(min-width: 1200px) 676px, (min-width: 600px) 60vw, 100vw' />

        <ul className=@classes.bullets>
          { _.map type.bullet_points, @mapBullet}
        </ul>
      </div>

  getSpacerIndex: ->
    # Count characters to get longest tab
    maxTab = _.maxBy @props.types, (type) ->
      _.reduce type.bullet_points, (acc, bullet) ->
        acc + bullet.length
      , 0

    _.indexOf @props.types, maxTab

  render: ->
    @classes = @getClasses()

    <div className=@classes.block>
      <h2 className=@classes.heading children=@props.heading />
      <p className=@classes.description children=@props.description />
      <TabBar tabs={_.map @props.types, @mapTab} spacerIndex=@getSpacerIndex() />
    </div>
