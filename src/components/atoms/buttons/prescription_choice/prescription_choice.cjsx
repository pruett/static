[
  _
  React

  RightArrowIcon

  Mixins
] = [
  require 'lodash'
  require 'react/addons'

  require 'components/quanta/icons/right_arrow/right_arrow'

  require 'components/mixins/mixins'

  require './prescription_choice.scss'
]

module.exports = React.createClass
  BLOCK_CLASS: 'c-prescription-choice'

  mixins: [
    Mixins.conversion
    Mixins.classes
  ]

  propTypes:
    prescription: React.PropTypes.object
    txtExpiration: React.PropTypes.string
    txtUpdated: React.PropTypes.string
    txtOS: React.PropTypes.string
    txtOD: React.PropTypes.string
    cssModifier: React.PropTypes.string

  getDefaultProps: ->
    prescription: {}
    txtExpiration: "Expires: "
    txtUpdated: "Last used on"
    txtOS: 'Left (OS): '
    txtOD: 'Right (OD): '
    cssModifier: ''

  getStaticClasses: ->
    block: "
      #{@BLOCK_CLASS}
      #{@props.cssModifier}
      u-button -button-block -button-left -button-white
      u-reset u-fs16 u-fwn u-ffss
      inspectlet-sensitive
    "
    title: "
      #{@BLOCK_CLASS}__title
      u-reset u-fs16
      u-db
    "
    type:
      'u-reset u-fws'
    eyes:
      'u-color--dark-gray-alt-2'
    eye: "
      #{@BLOCK_CLASS}__eye
      u-dib u-fws u-fs16
    "
    eyeContainer: "
      #{@BLOCK_CLASS}__eye-container
      u-db u-pr12
      u-fs14
    "
    arrow: "
      #{@BLOCK_CLASS}__arrow -v2
      u-fill--light-gray
    "
    expiration: '
      u-ml8 u-ffss
      u-fs12 u-fs14--600
      u-color--dark-gray-alt-2
    '
    updated: '
      u-dib u-mt12 u-fs14
      u-color--dark-gray-alt-3
    '

  classesWillUpdate: ->
    isExpired = _.get @props, 'prescription.expired', false

    block:
      '-expired': isExpired
    expiration:
      'u-color--yellow': isExpired

  getType: ->
    if @props.prescription.os_axis and @props.prescription.os_add
      'Progressives'
    else if @props.prescription.os_add
      'Readers'
    else
      'Single-vision'

  printDate: (date) ->
    "#{date.month.substr(0,3)} #{date.date}, #{date.year}"

  render: ->
    return false if _.isEmpty(@props.prescription)

    classes = @getClasses()

    utcExpire = @convert 'date', 'object', @props.prescription.expiration_date
    utcUpdate = @convert 'date', 'object', @props.prescription.updated
    prescription = @formatted('prescription', @props.prescription)

    txtExpiration =
      if _.get(@props, 'prescription.expired') then '(Expired)'
      else "(#{@props.txtExpiration} #{@printDate(utcExpire)})"

    <button {...@props} type='button' className=classes.block>

      <span className=classes.title>
        <span className=classes.type children=@getType() />

        <span className=classes.expiration children=txtExpiration />
      </span>

      <span className=classes.eyes>
        <span className=classes.eyeContainer>
          <span className=classes.eye children=@props.txtOD />
          {_.compact([
            prescription.od_sphere or '0.00'
            prescription.od_cylinder or '0.00'
            prescription.od_axis or '0'
            prescription.od_add
          ]).join(' / ')}
        </span>

        <span className=classes.eyeContainer>
          <span className=classes.eye children=@props.txtOS />
          {_.compact([
            prescription.os_sphere or '0.00'
            prescription.os_cylinder or '0.00'
            prescription.os_axis or '0'
            prescription.os_add
          ]).join(' / ')}
        </span>
      </span>

      <span className=classes.updated
        children="#{@props.txtUpdated} #{@printDate(utcUpdate)}" />

      <RightArrowIcon cssModifier=classes.arrow />
    </button>
