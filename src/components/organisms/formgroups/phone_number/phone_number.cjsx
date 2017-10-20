[
  _
  React

  FormGroupText
  SmsOptInCheckbox
] = [
  require 'lodash'
  require 'react/addons'

  require 'components/organisms/formgroups/text_v2/text_v2'
  require 'components/organisms/formgroups/sms_opt_in/sms_opt_in'
]

module.exports = React.createClass

  getDefaultProps: ->
    showSmsCheckbox: false
    valueLink: {}
    errorIsRed: true
    isVisible: true

  formatNumber: (value) ->
    format = if value[0] is '1' then '1-555-555-5555' else '555-555-5555'
    digits = value.replace(/\D/g, '').substr(0, format.replace(/\D/g, '').length)
    # Add spacers
    formatted = _.reduce digits, (result, digit, i) ->
      if format[result.length] and isNaN(parseInt(format[result.length]))
        result += format[result.length]
      result += digit
    , ''
    # Trailing spacer
    if format[formatted.length] and isNaN parseInt(format[formatted.length])
      formatted += format[formatted.length]
      prevValue = @props.valueLink.value
      # Deleting a trailing spacer
      if isNaN(parseInt(prevValue.slice(-1))) and value.length < prevValue.length
        formatted = formatted.slice(0, -2)

    formatted

  handleChange: (evt) ->
    @props.valueLink.requestChange @formatNumber(evt.target.value)
    @props.onChange(evt) if _.isFunction @props.onChange

  handleBlur: (evt) ->
    @props.valueLink.requestChange @formatNumber(evt.target.value)
    @props.onBlur(evt) if _.isFunction @props.onBlur

  render: ->
    props = _.omit @props, 'valueLink', 'onChange', 'onBlur', 'cssModifierBlock'

    <div className={@props.cssModifierBlock}>
      <FormGroupText {...props}
        type='tel'
        autoComplete='tel'
        pattern='[0-9]*'
        value={_.get @props, 'valueLink.value'}
        cssModifierField="#{props.cssModifierField} inspectletIgnore"
        onChange=@handleChange
        onBlur=@handleBlur />

      {<SmsOptInCheckbox isVisible={@props.isVisible} /> if @props.showSmsCheckbox}
    </div>
