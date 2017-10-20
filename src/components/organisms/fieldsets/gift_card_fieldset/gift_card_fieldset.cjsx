[
  _
  React

  FormGroupText

  Mixins
] = [
  require 'lodash'
  require 'react/addons'

  require 'components/organisms/formgroups/text/text'

  require 'components/mixins/mixins'

  require './gift_card_fieldset.scss'
]

module.exports = React.createClass
  BLOCK_CLASS: 'c-gift-card-fieldset'

  mixins: [
    Mixins.classes
    Mixins.dispatcher
  ]

  getStaticClasses: ->
    block: "
      #{@BLOCK_CLASS}
      u-fieldset-reset"
    cta:
      '-cta-full -cta-large'
    noteLabel: "
      #{@props.cssModifierLabel or ''}
      -sticky"
    noteActions:
      'u-dn'
    noteField: "
      #{@BLOCK_CLASS}__note-field
      -no-resize"
    max:
      "#{@BLOCK_CLASS}__max"
    half:
      "#{@BLOCK_CLASS}__half"

  propTypes:
    isEGiftCard: React.PropTypes.bool
    giftCardErrors: React.PropTypes.object
    maxLengthNote: React.PropTypes.number
    placeholders: React.PropTypes.object
    labels: React.PropTypes.object
    recipient_name: React.PropTypes.string
    recipient_email: React.PropTypes.string
    sender_name: React.PropTypes.string
    sender_email: React.PropTypes.string
    note: React.PropTypes.string

  getDefaultProps: ->
    isEGiftCard: true
    giftCardErrors: {}
    maxLengthNote: 200
    placeholders: {}
    labels: {}
    recipient_name: ''
    recipient_email: ''
    sender_name: ''
    sender_email: ''
    note: ''

    manageChangeField: ->

  handleChange: (name, event) ->
    @props.manageChangeField(name, event) if _.isFunction @props.manageChangeField

  render: ->
    classes = @getClasses()

    inputErrors = @props.giftCardErrors

    # Defaults
    labels = _.defaults @props.labels,
      recipient_name: 'Recipient’s name'
      recipient_email: 'Recipient’s email'
      sender_name: 'Your name'
      sender_email: 'Your email'
      note: 'Add a note (if you want)'

    placeholders = _.defaults @props.placeholders,
      note: 'Say a little something sweet.'

    <fieldset className=classes.block>

      <div className=classes.half>
        <FormGroupText
          cssModifierLabel=@props.cssModifierLabel
          txtError=inputErrors.recipient_name
          txtLabel=labels.recipient_name
          value=@props.recipient_name
          placeholder=placeholders.recipient_name
          onChange={@handleChange.bind(@, 'recipient_name')}
          onBlur={@handleChange.bind(@, 'recipient_name')} />

        {if @props.isEGiftCard
          <FormGroupText
            cssModifierLabel=@props.cssModifierLabel
            txtError=inputErrors.recipient_email
            txtLabel=labels.recipient_email
            value=@props.recipient_email
            placeholder=placeholders.recipient_email
            onChange={@handleChange.bind(@, 'recipient_email')}
            onBlur={@handleChange.bind(@, 'recipient_email')} />}
      </div>

      <div className=classes.half>
        <FormGroupText
          cssModifierLabel=@props.cssModifierLabel
          txtError=inputErrors.sender_name
          txtLabel=labels.sender_name
          value=@props.sender_name
          placeholder=placeholders.sender_name
          onChange={@handleChange.bind(@, 'sender_name')}
          onBlur={@handleChange.bind(@, 'sender_name')} />

        {if @props.isEGiftCard
          <FormGroupText
            cssModifierLabel=@props.cssModifierLabel
            txtError=inputErrors.sender_email
            txtLabel=labels.sender_email
            value=@props.sender_email
            placeholder=placeholders.sender_email
            onChange={@handleChange.bind(@, 'sender_email')}
            onBlur={@handleChange.bind(@, 'sender_email')} />}
      </div>

      <FormGroupText
        isTextarea=true
        txtError=inputErrors.note
        txtLabel=labels.note
        placeholder=placeholders.note
        value=@props.note
        cssModifierField=classes.noteField
        cssModifierLabel=classes.noteLabel
        cssModifierActions=classes.noteActions
        onChange={@handleChange.bind(@, 'note')}
        onBlur={@handleChange.bind(@, 'note')} >

        <span className=classes.max>
          {@props.maxLengthNote - @props.note.length}
        </span>
      </FormGroupText>

    </fieldset>
