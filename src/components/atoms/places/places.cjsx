[
  _
  React

  Mixins
] = [
  require 'lodash'
  require 'react/addons'

  require 'components/mixins/mixins'

  require './places.scss'
]

module.exports = React.createClass

  BLOCK_CLASS: 'c-places'

  mixins: [
    Mixins.classes
  ]

  propTypes:
    suggestions: React.PropTypes.array
    address: React.PropTypes.string
    handleClick: React.PropTypes.func
    handleFocus: React.PropTypes.func
    handleBlur: React.PropTypes.func

  getDefaultProps: ->
    suggestions: []
    address: ''
    show: false
    handleClick: ->
    handleFocus: ->
    handleBlur: ->

  getStaticClasses: ->
    block: "
      #{@BLOCK_CLASS}
      #{@props.cssModifier}
    "
    place:
      "#{@BLOCK_CLASS}__place u-button -button-small"
    result: [
      "#{@BLOCK_CLASS}__result"
      'u-reset u-fs12'
    ]
    resultHighlight: "
      #{@BLOCK_CLASS}__highlight
    "
    google: "
      #{@BLOCK_CLASS}__google
    "

  classesWillUpdate: ->
    block:
      '-show': @shouldShowPlaces()

  onClick: (index, evt) ->
    evt.preventDefault()
    @props.handleClick(index, evt)

  onKeyDown: (index, evt) ->
    if evt.key is 'Enter'
      evt.preventDefault()
      @props.handleClick(index, evt)

  shouldShowPlaces: ->
    not _.isEmpty(@props.suggestions) and @props.show and @props.address

  printPlace: (place, index) ->
    description = place.description.toLowerCase()
    address = @props.address.toLowerCase()

    # A tag used to combat Safari bug.

    <a href='javascript:void(0)'
      key="places-#{index}"
      onClick={@onClick.bind(@, index)}
      onKeyDown={@onKeyDown.bind(@, index)}
      className=@classes.place>

      {if description.indexOf(address) is 0
        <span className=@classes.result>
          <span className=@classes.resultHighlight>
            {place.description.substring(0, @props.address.length)}
          </span>
          {place.description.substring(@props.address.length)}
        </span>
      else
        <span className=@classes.result>{place.description}</span>
      }
    </a>

  render: ->
    return false if _.isEmpty @props.suggestions

    @classes = @getClasses()

    <div className=@classes.block>

      {_.map @props.suggestions, @printPlace}

      <div className=@classes.google>
        <img width="94" height="16" src="/assets/img/vendor/google/powered-by-google.png" />
      </div>
    </div>
