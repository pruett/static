const React = require('react/addons');
const Rsvg = require('components/quanta/rsvg/rsvg');

require('./frame_temple.scss');

module.exports = React.createClass({

  SVG: {
    'class': 'c-icon--frame-temple',
    width: 252,
    height: 109
  },

  getDefaultProps: function() {
    return({
      cssModifier: 'u-icon u-fill--dark-gray u-stroke--light-gray-alt-1 u-ffss',
      frameName: "Ames",
      measurements: "54-18-145",
    })
  },

  renderMeasurementNames: function(measureType, i) {
    const yVal = (53 + i*10);
    const xStart= (55 + i*5) + '%';
    const xEnd = (73 + i*5) +'%';
    const yStart = `${yVal - 2}%`;
    const yEnd = '41%';
    return (
      <svg>
        <text
          key={i}
          fontSize={'5px'}
          stroke={'none'}
          x={'40%'}
          y={`${yVal}%`}
          className={"c-icon--frame-temple__measurement u-fwb"} >
          {measureType}
        </text>
        <line x1={xStart} y1={yStart} x2={xEnd} y2={yStart}
          strokeWidth={'0.5'} strokeLinecap={'round'} />
        <line x1={xEnd} y1={yStart} x2={xEnd} y2={yEnd}
          strokeWidth={'0.5'} strokeLinecap={'round'} />
      </svg>
    );
  },
  render: function() {
    const measure = ["LENS WIDTH", "BRIDGE WIDTH", "TEMPLE ARM LENGTH"];
    return(
      <Rsvg {...this.props} SVG={this.SVG} title={'Frame temple'}>
        <path
          fill={'none'}
          strokeWidth={'0.5'}
          strokeLinecap={'round'}
          strokeLinejoin={'round'}
          d={'M17.4 80.7l-4.6-6.2c-1.5-2.3.7-3.5.7-3.5S49 47.8 56.4 43.8c15.5-8.4 33.8-7.7 50.8-8.1 13.9-.3 27.9-.6 41.8-.8l89-.8-2.3 13c-25.7.5-51.1-.4-76.3-.9-18.4-.4-36.8-1.2-55.2-2-10.4-.4-20.9-1.6-31.2.5-12.7 2.7-22.2 12.2-32 20-1.4 1.1-20 16.1-20 16-.1 0-2.1 2.1-3.6 0z'} />
        <text
          fontSize={'6px'}
          stroke={'none'}
          x={'85%'}
          y={'39%'}
          textAnchor={'end'}
          className={"u-fws"}>
          <tspan className={"u-fill--dark-gray-alt-2"}
            children={`${this.props.frameName} \u00a0\u00a0\u00a0`} />
          <tspan children={this.props.measurements} />
        </text>
        {measure.map(this.renderMeasurementNames.bind(this))}
        <text
          className={"u-fill--dark-gray-alt-2 u-fws"}
          fontSize={'6px'}
          stroke={'none'}
          x={'53%'}
          y={'90%'}
          children={"(in millimeters)"} >
        </text>
      </Rsvg>
    );
  }

});
