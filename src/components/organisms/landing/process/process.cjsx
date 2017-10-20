[
  _
  React

  GlassesNav
  Hero
  ProcessBlockStacked
  ProcessBlockSplit
  Video

  Mixins
] = [
  require 'lodash'
  require 'react/addons'

  require 'components/molecules/glasses_nav/glasses_nav'
  require 'components/molecules/landing/process/hero/hero'
  require 'components/molecules/landing/process/process_block_stacked/process_block_stacked'
  require 'components/molecules/landing/process/process_block_split/process_block_split'
  require 'components/molecules/landing/process/video/video'

  require 'components/mixins/mixins'

  require './process.scss'
]

module.exports = React.createClass

  mixins: [
    Mixins.classes
  ]

  BLOCK_CLASS: 'c-landing-process'

  getStaticClasses: ->
    grid: '
      u-grid -maxed u-mla u-mra u-tac
    '
    row: '
      u-grid__row
    '
    columnDivider: '
      u-grid__col u-w12c -c-8--900
    '
    divider: "
      #{@BLOCK_CLASS}__divider
      u-color-bg--dark-gray
      u-mb60 u-mb96--900
    "
    glassesNavWrapper: '
      u-pt60
      u-btw1 u-btss u-bc--light-gray
    '
    glassesNavHeader: '
      u-heading-sm u-tac
    '

  classesWillUpdate: ->
    divider:
      'u-dn--900': @props.hero.show_image

  renderBlock: (block, i) ->
    if block.callout_type is 'split'
      <ProcessBlockSplit {...block} key=i />
    else if block.callout_type is 'text_only' or block.callout_type is 'stacked'
      <ProcessBlockStacked {...block} key=i />
    else if block.callout_type is 'full_video'
      <Video {...block} key=i />

  renderDivider: ->
    <div className=@classes.grid>
      <div className=@classes.row>
        <div className=@classes.columnDivider>
          <div className=@classes.divider />
        </div>
      </div>
    </div>

  render: ->
    @classes = @getClasses()
    blocks = _.get @props, 'blocks', []
    hero = _.get @props, 'hero', {}
    glassesNav = _.get @props, 'glasses_nav', {}

    <div className=@classes.block>

      <Hero {...hero} />

      { @renderDivider() }

      <div>
        { _.map blocks, @renderBlock }
      </div>

      <section className=@classes.grid>
        <div className=@classes.glassesNavWrapper>
          <h1 className=@classes.glassesNavHeader children=glassesNav.header />
          <GlassesNav glasses=glassesNav.glasses />
        </div>
      </section>

    </div>
