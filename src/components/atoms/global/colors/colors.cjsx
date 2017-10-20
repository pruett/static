React = require 'react/addons'

module.exports = React.createClass
  validProps:
    colors: React.PropTypes.arrayOf React.PropTypes.object

  getDefaultProps: ->
    # Ensure these values stay consistent with those used in the Sass color variables.
    colors: [
      value: '#00a2e1'
      variants: ['#18b3f0', '#009bd9']
    ,
      value: '#414b56'
      variants: ['#6b7b8c', '#171c21']
    ,
      value: '#d2d6d9'
      variants: ['#e1e5e6', '#c8cbcc']
    ,
      value: '#f2b600'
    ]

  buildSwatch: (colorValue) ->
    <div className='swatch' key={colorValue}>
      <div className='swatch__color' style={backgroundColor: colorValue} />
      <span className='swatch__value'>{colorValue}</span>
    </div>

  render: ->
    <div>
      {for color, i in @props.colors
        colors = [color.value]
        colors.push(color.variants...) if color.variants?

        <div key={i}>
          {@buildSwatch(variant) for variant in colors}
        </div>
      }
    </div>
