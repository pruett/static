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

  require './discount_code_input.scss'
]

module.exports = React.createClass
  BLOCK_CLASS: 'c-discount-code-input'

  mixins: [
    Mixins.classes
  ]

  getDefaultProps: ->
    txtError: ''

  getInitialState: ->
    code: ''

  getStaticClasses: ->
    block: "
      #{@BLOCK_CLASS}
      u-mt12 u-mbn18
    "
    input: "
      #{@BLOCK_CLASS}__input
      u-dib
    "
    button: "
      #{@BLOCK_CLASS}__button
      u-button u-button-reset
      u-fs14 u-fws
      u-dib
    "

  classesWillUpdate: ->
    button:
      '-button-blue': @state.code.length > 0
      '-button-white': @state.code.length is 0

  handleClickApply: ->
    @props.manageApply(@state.code) if _.isFunction @props.manageApply

  handleChange: (evt) ->
    @setState code: evt.target.value
    @props.onChange(evt) if _.isFunction @props.onChange

  componentDidMount: ->
    # Delay focus so CSS transition can complete
    _.delay @focusInput, 200

  focusInput: ->
    input = React.findDOMNode(@refs.formgroupText).getElementsByTagName('input')[0]
    input?.focus()

  render: ->
    classes = @getClasses()

    <div className=classes.block>
      <FormGroupText
        name='code'
        cssModifier=classes.input
        ref='formgroupText'
        onChange=@handleChange
        txtError=@props.txtError
        txtPlaceholder='Enter code'
        validation=false
        value=@state.code />

      <button type='button'
        className=classes.button
        disabled={@state.code.length is 0}
        onClick=@handleClickApply
        children='Apply' />
    </div>
