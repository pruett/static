[
  _
  React

  Picture

  Mixins

] = [

  require 'lodash'
  require 'react/addons'

  require 'components/atoms/images/picture/picture'

  require 'components/mixins/mixins'
]

module.exports = React.createClass

  mixins: [
    Mixins.classes
    Mixins.image
    Mixins.dispatcher
    Mixins.analytics
  ]

  getInitialState: ->
    gameStarted: false

  getDefaultProps: ->
    header: ''
    body: ''
    placeholder_image: []

  propTypes:
    placeholder_image: React.PropTypes.array
    header: React.PropTypes.string
    body: React.PropTypes.string

  getStaticClasses: ->
    block: '
      u-tac
      u-mw2000
      u-mla u-mra
    '
    backgroundImage: '
      u-w100p
    '
    grid: '
      u-grid
    '
    row: '
      u-grid__row
    '
    column: '
      u-grid__col u-w12c u-w10c--600 u-w8c--900 u-mb36 u-mb48--600
    '
    header: '
      u-fs20 u-fs36--900
      u-reset
      u-fws
      u-mb24
    '
    game: '
      u-mla u-mra
      u-w12c
      u-w10c--600
      u-mbn6 u-mbn0--600
    '
    gameTitle: '
      u-fsi
      u-fs20 u-fs36--900
      u-reset
      u-fws
    '

  handleGameStart: ->
    if not @state.gameStarted
      @setState gameStarted: true
      @trackInteraction 'LandingPage-Play-Worbs'

  componentDidMount: ->
    @commandDispatcher 'scripts', 'load',
      name: 'killscreen'
      src: '/assets/killscreen/game.js'
      timeout: 50000

  shouldComponentUpdate: ->
    return false

  render: ->
    @classes = @getClasses()

    <div className=@classes.block>
      <div className=@classes.grid>
        <div className=@classes.row>
          <div className=@classes.column>
            <span children=@props.header className=@classes.header />
            <span children=@props.title className=@classes.gameTitle />
          </div>
        </div>
      </div>
      <div className=@classes.game id='killscreen-game' onClick=@handleGameStart />
    </div>
