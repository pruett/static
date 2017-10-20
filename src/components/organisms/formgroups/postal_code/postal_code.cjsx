[
  _
  React

  FormGroupText

  Mixins
] = [
  require 'lodash'
  require 'react/addons'

  require 'components/organisms/formgroups/text_v2/text_v2'

  require 'components/mixins/mixins'
]

module.exports = React.createClass

  mixins: [
    Mixins.context
  ]

  getDefaultProps: ->
    valueLink: {}

  formatCode: (value) ->
    prevValue = @props.valueLink.value

    if @getLocale('country') is 'CA'
      # Format = 'A1A 1A1'
      digits = value.replace(/[^0-9a-z]/gi, '').toUpperCase().substr(0, 6)
      # If deleting the spacer, also delete the last digit
      if prevValue.slice(-1) is ' ' and value.length < prevValue.length
        formatted = digits.size(0, -1)
      # Add the spacer
      else if digits[2]
        formatted = "#{digits.slice(0, 3)} #{digits.slice(3)}"
      else
        formatted = digits
    else
      # Format = '11111{-1111}'
      digits = value.replace(/\D/g, '')
      if digits.length < 6
        formatted = digits
      else
        formatted = "#{digits.slice(0, 5)}-#{digits.slice(5,9)}"

    formatted

  handleChange: (evt) ->
    @props.valueLink.requestChange @formatCode(evt.target.value)
    @props.onChange(evt) if _.isFunction @props.onChange

  handleBlur: (evt) ->
    @props.valueLink.requestChange @formatCode(evt.target.value)
    @props.onBlur(evt) if _.isFunction @props.onBlur

  render: ->
    props = _.omit @props, 'valueLink', 'onChange', 'onBlur'

    <FormGroupText {...props}
      pattern={'[0-9]*' if @getLocale('country') is 'US'}
      value={_.get @props, 'valueLink.value'}
      onChange=@handleChange
      onBlur=@handleBlur />
