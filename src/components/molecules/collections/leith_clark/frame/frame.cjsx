React = require 'react/addons'
_ = require 'lodash'

Mixins = require 'components/mixins/mixins'

module.exports = React.createClass

  mixins: [
    Mixins.image
    Mixins.dispatcher
    Mixins.analytics
    Mixins.classes
  ]

  propTypes:
    content: React.PropTypes.object
    twoUp: React.PropTypes.bool
    frames: React.PropTypes.array
    startingPosition: React.PropTypes.number

  getDefaultProps: ->
    content: {}
    twoUp: true
    startingPosition: 0
    frames: []

  getStaticClasses: ->
    block: '
      u-grid
    '
    row: '
      u-grid__row
      u-tac
    '
    column: '
      u-grid__col u-w12c
      u-mb60 u-mb72--600
    '
    frameImage: '
      u-w100p
      u-mb24
      u-mb36--900
    '
    frameName: '
      u-fs16 u-color--black u-fwb u-ffs
    '
    frameColor: '
      u-fs16 u-color--black u-fsi u-ffs
    '
    link: '
      c-leith-clark-frame-link
    '

  classesWillUpdate: ->
    column:
      'u-w8c--600': not @props.twoUp
      'u-w6c--600': @props.twoUp

  handleFrameClick: (frame, gaPosition) ->
    details = @getWomenDetails(frame) or {}

    @trackInteraction "LandingPage-clickShopWomen-#{frame.sku}"

    @commandDispatcher 'analytics', 'pushProductEvent',
      type: 'productClick'
      products: [
        brand: 'Warby Parker'
        category: 'Eyeglasses'
        list: 'CollectionLeithClark'
        id: details.id
        name: frame.display_name
        position: gaPosition
        sku: frame.sku
        url: details.path
      ]

  renderFrame: (frame, i) ->
    details = @getWomenDetails(frame)
    gaPosition = @props.startingPosition + i

    <div className=@classes.column key=i>
      <a href=details.path
         onClick={@handleFrameClick.bind @, frame, gaPosition}
         className=@classes.link >
        <img src=frame.image className=@classes.frameImage />
      </a>
      <div className=@classes.frameCopyWrapper>
        <span children=frame.display_name className=@classes.frameName />
        <span children=' in ' className=@classes.frameColor />
        <span children=frame.color className=@classes.frameColor />
      </div>
    </div>

  getWomenDetails: (frame) ->
    _.find frame.gendered_details, gender: 'f' or {}

  render: ->
    @classes = @getClasses()
    frames = _.get @props, 'frames', []

    <div className=@classes.block>
      <div className=@classes.row>
        { _.map frames, @renderFrame }
      </div>
    </div>
