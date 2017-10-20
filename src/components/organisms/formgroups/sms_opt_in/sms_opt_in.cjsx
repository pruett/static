[
  React

  Tooltip
  FormGroupCheckbox

  Mixins
] = [
  require 'react/addons'

  require 'components/atoms/tooltip/tooltip'
  require 'components/organisms/formgroups/checkbox/checkbox'

  require 'components/mixins/mixins'
]

module.exports = React.createClass
  mixins: [
    Mixins.analytics
    Mixins.classes
    Mixins.dispatcher
  ]

  componentDidMount: ->
    # Set default unchecked value on the model
    @updateSmsOptIn false

  getDefaultProps: ->
    analyticsCategory: 'checkout'
    isVisible: true

  getStaticClasses: ->
    checkbox:
      'u-fs14 u-color--dark-gray-alt-2'
    checkboxLabel:
      'u-pt2'
    checkboxBox:
      '-border-light-gray'

  handleChange: (evt) ->
    @updateSmsOptIn evt.target.checked
    state = if evt.target.checked then 'selected' else 'deselected'
    @trackInteraction("#{@props.analyticsCategory}-toggle-smsOptIn-#{state}")

  updateSmsOptIn: (value) ->
    @commandDispatcher 'estimate', 'saveSmsOptIn', value

  render: ->
    classes = @getClasses()

    <FormGroupCheckbox
      cssModifier=classes.checkbox
      cssLabelModifier=classes.checkboxLabel
      cssModifierBox=classes.checkboxBox
      key='sms_opt_in'
      name='sms_opt_in'
      txtLabel={[
        'Text me updates about my order! And yes, I agree to these terms.'
        <Tooltip
          analyticsSlug="#{@props.analyticsCategory}-click-smsOptInTooltip"
          version=2
          isVisible={@props.isVisible}
          children='I agree to receive texts that might be considered marketing
            and that may be sent using an autodialer.
            I understand checking this box is not required to purchase.' />
      ]}
      onChange=@handleChange />
