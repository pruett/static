[
  React
] = [
  require 'react/addons'
]

# This component is an interface to the Google Static Maps API. Read more here:
# https://developers.google.com/maps/documentation/static-maps/intro

BASE_IMG_URL = '//maps.googleapis.com/maps/api/staticmap?'

API_KEY = 'AIzaSyBka1QGYiPJP7PV7xg2Hr_1L3Iyr6CI-I4'

module.exports = React.createClass
  BLOCK_CLASS: 'c-map-google-static'

  propTypes:
    center: React.PropTypes.string
    zoom: React.PropTypes.number
    width: React.PropTypes.number
    height: React.PropTypes.number
    scale: React.PropTypes.number
    format: React.PropTypes.string
    markers: React.PropTypes.string
    path: React.PropTypes.string
    visible: React.PropTypes.string
    key: React.PropTypes.string

    cssModifier: React.PropTypes.string

  getDefaultProps: ->
    width: 400
    height: 320
    scale: 1
    format: 'png'
    maptype: 'roadmap'
    key: API_KEY

    cssModifier: ''

  getImgSrc: ->
    requiredParams = @getRequiredParams()

    if requiredParams
      "#{BASE_IMG_URL}\
        #{requiredParams}&\
        size=#{@props.width}x#{@props.height}&\
        scale=#{@props.scale}&\
        key=#{@props.key}"

  getRequiredParams: ->
    # The API requires the presence of at least one of the following URL
    # parameters or combinations of parameters:
    # * `zoom` and `center`
    # * `markers`
    # * `path
    # (`size` is also required, but gets a default value in `getDefaultProps`.)

    if @props.zoom and @props.center
      "zoom=#{@props.zoom}&center=#{@props.center}"
    else if @props.markers
      "markers=#{@props.markers}"
    else if @props.path
      "path=#{@props.path}"
    else
      null

  render: ->
    imgSrc = @getImgSrc()
    return false unless imgSrc

    <img src=imgSrc
      className="#{@BLOCK_CLASS} #{@props.cssModifier}" />
