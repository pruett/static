[
  _
  React

  Mixins
] = [
  require 'lodash'
  require 'react/addons'

  require 'components/mixins/mixins'
]

module.exports = React.createClass

  BLOCK_CLASS: 'c-callout--labels'

  mixins: [
    Mixins.classes
    Mixins.callout
  ]

  propTypes:
    css_modifiers: React.PropTypes.object
    css_utilities: React.PropTypes.string
    show_labels: React.PropTypes.bool

  getDefaultProps: ->
    css_utilities: ''
    css_modifiers:
      orientation: 'LLL'
      frame_color: 'standard'
      frame_name: 'standard'
    show_labels: true

  reduceOrientationToCss: (css, letter, index) ->
    utility = switch letter.toLowerCase()
      when 'c' then 'u-tac'
      when 'r' then 'u-tar'
      else 'u-tal'

    breakpoint = switch index
      when 1 then '--600'
      when 2 then '--900'
      when 3 then '--1200'
      else ''

    "#{css} #{utility}#{breakpoint}"

  getStaticClasses: ->
    cssModifers = _.get @props, 'css_modifiers', {}

    block:"
      #{@props.css_utilities or 'u-pa u-ma u-w100p u-b0 u-pb18'}
      #{_.reduce cssModifers.orientation, @reduceOrientationToCss, ''}
    "
    grid: '
      u-grid -maxed u-ma
    '
    row: '
      u-grid__row
    '
    column: '
      u-grid__col w-12c
    '
    frameName: "
      u-fs10 u-fs14--600
      u-ffs
      u-fwb
      u-di
      #{@COLOR_LOOKUP[cssModifers.frame_name] or ''}
    "
    frameColor: "
      u-fs10 u-fs14--600
      u-ffs
      u-fsi
      u-di
      #{@COLOR_LOOKUP[cssModifers.frame_color] or ''}
    "
    labelsMobile: '
      u-dn--600
    '
    labelsTablet: '
      u-dn u-db--600 u-dn--900
    '
    labelsDesktop: '
      u-dn u-db--900
    '

  renderlabel: (classes, label, i) ->
    <div key=i className=label.css_utility>
      <span children=label.frame_name className=classes.frameName />
      <span children=label.frame_color className=classes.frameColor />
    </div>

  render: ->
    return false unless @props.show_labels
    classes = @getClasses()
    mobile = _.get @props, 'labels.mobile'
    tablet = _.get @props, 'labels.tablet'
    desktopSd = _.get @props, 'labels.desktop-sd'

    <section className=classes.block>
      <div className=classes.grid>
        <div className=classes.row>
          <div className=classes.column>
            <div className=classes.labelsMobile>
              {_.map mobile, @renderlabel.bind(@, classes)}
            </div>
            <div className=classes.labelsTablet>
              {_.map tablet, @renderlabel.bind(@, classes)}
            </div>
            <div className=classes.labelsDesktop>
              {_.map desktopSd, @renderlabel.bind(@, classes)}
            </div>
          </div>
        </div>
      </div>

    </section>
