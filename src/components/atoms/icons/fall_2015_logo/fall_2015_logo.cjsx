[
  React
  Rsvg

  Mixins
] = [
  require 'react/addons'
  require 'components/quanta/rsvg/rsvg'

  require 'components/mixins/mixins'

  require './fall_2015_logo.scss'
]

ReactCSSTransitionGroup = React.addons.CSSTransitionGroup

module.exports = React.createClass

  SVG:
    class: 'c-icon-fall-2015-logo'
    width: 383.3
    height: 210.3

  propTypes:
    cssUtility: React.PropTypes.string
    cssModifier: React.PropTypes.string
    version: React.PropTypes.oneOf(['fans', 'men', 'women'])

  mixins: [
    Mixins.classes
  ]

  getDefaultProps: ->
    cssUtility: 'u-icon'
    cssModifier: ''
    version: 'fans'

  getStaticClasses: ->
    type: "#{@SVG.class}__type"
    line: ["#{@SVG.class}__line"
           "#{@SVG.class}__line--#{if @props.version is 'women'\
              then 'gray-line'\
              else 'blue-line'}"
          ].join ' '

  getInitialState: ->
    fadeIn: false;

  render: ->
    classes = @getClasses()

    <ReactCSSTransitionGroup
      transitionName='-transition-fade'
      transitionAppear=true
      transitionEnter=true
      transitionLeave=false >
      <Rsvg {...@props}
      cssModifier={
        [
          @props.cssModifier
          @props.cssUtility
        ].join ' '}
      key='logo'
      SVG={@SVG}>
        <g>
          <path className=classes.type d="M98.1,72v12.9h-1.7c-2.7-8.1-4.5-10.7-11.5-10.7h-3.9c-1.9,0-2.4,0.6-2.4,
            2.5v18.1h8.4c4.1,0,5-1.7,6.2-6.8h1.7v15.8h-1.7c-1.2-5.1-2.1-6.8-6.2-6.8h-8.4v16.8c0,3.5,0.5,3.7,6.1,
            4v1.7H62.4v-1.7c4.3-0.2,5-0.5,5-4V77.7c0-3.5-0.2-3.8-5-4V72H98.1z"/>
          <path className=classes.type d="M130.3,112c0,3.9,0.6,4.7,1.7,5.2c0.8,0.3,1.7,0.3,2.6,0.3l-0.1,
            1.1c-2.3,1.3-5.2,1.9-8.8,1.9c-3.7,0-5-2.1-5.6-4.3c-2.4,1.6-5,4.3-9.4,4.3c-6.9,0-9.9-4.8-9.9-9.9c0-3.9,
            1.6-6.8,7.1-8.3c4.8-1.2,10.3-2.7,12-4.5v-4.5c0-4-1.6-5.9-4.1-5.9c-2.3,0-4.3,1.4-5.9,8.4c-0.4,1.8-1.5,
            2.4-3,2.4c-1.8,0-5-1-5-4.2c0-3.7,4.9-8.4,15-8.4c12.2,0,13.5,5.9,13.5,10.1V112z M119.9,99.7c-1.7,0.7-3.9,
            1.9-5.8,3.1c-1.9,1.2-2.6,2.7-2.6,5.9c0,4.2,1.7,7.6,4.9,7.6c1.3,0,3.5-0.9,3.5-4.3V99.7z"/>
          <path className=classes.type d="M140.3,74.6c0-2.7-0.6-3.3-1.5-3.5l-2.4-0.4v-1.6l14.4-1.3l0.1,
            0.1v46.7c0,2.7,0.3,3,4,3.2v1.7h-18.6v-1.7 c3.7-0.2,4-0.5,4-3.2V74.6z"/>
          <path className=classes.type d="M160.8,74.6c0-2.7-0.6-3.3-1.5-3.5l-2.4-0.4v-1.6l14.4-1.3l0.1,
            0.1v46.7c0,2.7,0.3,3,4,3.2v1.7h-18.6v-1.7c3.7-0.2,4-0.5,4-3.2V74.6z"/>
          <path className=classes.type d="M222.2,119.5h-30.7l-0.4-0.4c0-4.5,2.4-9.2,12.2-18.2c7.3-6.8,8.1-12,
            8.1-16.3c0-5-1.3-9.3-5.6-9.3c-3.6,0-5,2.7-6.7,11c-0.4,1.9-1.9,2.5-3.4,2.5c-2.4,0-4.2-1.9-4.2-4.5c0-5.3,
            4.8-10.9,15.6-10.9c9.3,0,15.8,3.5,15.8,13.5c0,7.9-4.3,11.2-12.1,14.7c-7.6,3.4-13.5,7.5-14.6,9.6h22.2c1.1,
            0,2.7-0.1,5.5-5.4l1.4,0.4L222.2,119.5z"/>
          <path className=classes.type d="M262.2,96.9c0,12.3-3.7,23.4-16.8,23.4c-13,
            0-16.8-11.3-16.8-23.4c0-12.4,3.7-23.4,16.9-23.4C258.3,73.5,262.2,84.7,262.2,96.9z M239.9,96.9c0,9.6,0,21.6,
            5.5,21.6c5.3,0,5.4-11.8,5.4-21.6c0-8.9-0.1-21.6-5.5-21.6C239.8,75.3,239.9,88,239.9,96.9z"/>
          <path className=classes.type d="M263.4,119.5v-1.6l4.5-0.4c1.7-0.1,2.4-0.4,
            2.4-2.7V81c0-2.4-0.6-3-2.4-3.3l-4-0.5v-1.4l17-2.3l0.4,0.2v41.1c0,2.1,0.7,2.5,2.4,2.7l4.5,0.4v1.6H263.4z"/>
          <path className=classes.type d="M297.4,83c-1.5,0-2,0.3-2.3,1.8l-1.9,13v0.1c2.5-2.1,7.1-5.7,
            13.4-5.7c12.4,0,14.3,7.3,14.3,13c0,8.1-4.5,15.2-17.6,15.2c-12.5,0-13.8-5.2-13.8-7.5s2.3-4.2,4.5-4.2c1.6,
            0,2.2,1.2,2.7,2.7c2.2,6.4,3.5,7.4,6.8,7.4c3.7,0,5.3-4.7,5.3-12c0-7.6-2.8-10.5-7.1-10.5c-3.7,0-5.8,
            0.4-8.9,4.5l-1.6-1l2.2-25.1l0.4-0.3h15.4c6.3,0,8.5,0,9.9-0.6l0.4,0.5l-2.8,8.8H297.4z"/>
        </g>
        <line
        className=classes.line
          x1="141.7"
          y1="148.3"
          x2="241.7"
          y2="148.3"/>
      </Rsvg>
    </ReactCSSTransitionGroup>
