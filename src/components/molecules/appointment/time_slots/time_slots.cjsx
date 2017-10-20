[
  _
  React

  AppointmentTimeSlot

  Mixins
] = [
  require 'lodash'
  require 'react/addons'

  require 'components/atoms/appointment/time_slot/time_slot'

  require 'components/mixins/mixins'

  require './time_slots.scss'
]

module.exports = React.createClass
  BLOCK_CLASS: 'c-appointment-time-slots'

  mixins: [
    Mixins.classes
  ]

  propTypes:
    active: React.PropTypes.bool
    manageSetDate: React.PropTypes.func
    manageSetTimeSlot: React.PropTypes.func
    slots: React.PropTypes.array
    slotsBucketed: React.PropTypes.object

  getDefaultProps: ->
    slots: []
    slotsBucketed: {}

  getStaticClasses: ->
    block:
      "#{@BLOCK_CLASS}
      u-grid__row"
    morning:
      "#{@BLOCK_CLASS}__time-of-day
      u-grid__col u-w12c -c-3--600"
    afternoon:
      "#{@BLOCK_CLASS}__time-of-day
      u-grid__col u-w12c -c-6--600"
    evening:
      "#{@BLOCK_CLASS}__time-of-day
      u-grid__col u-w12c -c-3--600"
    heading:
      "u-fs12 u-fws
      u-ls2_5
      u-color--dark-gray-alt-3
      u-pt30 u-pb30
      u-tac
      u-reset
      u-ttu"
    headingLeft:
      'u-tal'
    headingCenter:
      'u-tac'
    headingRight:
      'u-tar'
    timeSlotContainer:
      "#{@BLOCK_CLASS}__time-slot-container u-blss u-blw1 u-bc--light-gray"
    timeSlot:
      "#{@BLOCK_CLASS}__time-slot
      u-dib"
    timeSlotUnavailable:
      "#{@BLOCK_CLASS}__time-slot-unavailable
      u-fs16
      u-color--dark-gray-alt-3
      u-tac
      u-color-bg--white
      u-pt18 u-pr12 u-pb18 u-pl12
      u-mt8 u-mr4--600 u-ml4--600"
    nextAvailable:
      'u-button-reset
      u-color--blue
      u-mt18
      u-fws'

  handleNextAvailableClick: (date) ->
    ((evt) ->
      if _.isFunction @props.manageSetDate
        @props.manageSetDate date
    ).bind @

  renderTimeSlot: (cssModifier, slot, i) ->
    <AppointmentTimeSlot
      cssModifier="#{@classes.timeSlot} #{cssModifier}"
      manageSetTimeSlot=@props.manageSetTimeSlot
      key=i
      {...slot} />

  renderAppointmentsSection: (attrs) ->
    {timeOfDay, colWidth, cssModifiers} = attrs

    <div className={"#{@classes[timeOfDay]} -#{timeOfDay}"} key=timeOfDay>
      <h3 className="#{@classes.heading} #{cssModifiers.heading}"
        children={_.startCase timeOfDay} />

      {if @props.slotsBucketed[timeOfDay].length > 0
        renderTimeSlot = @renderTimeSlot.bind @, cssModifiers.slot
        slots = @props.slotsBucketed[timeOfDay].map renderTimeSlot

        <div children=slots
          className=@classes.timeSlotContainer />
      else
        nextAvailable = _.get @props, "nextAvailable.#{timeOfDay}"

        <p className="#{@classes.timeSlotUnavailable} #{cssModifiers.slot}">
          {"We\'re all booked! Find another time or day."}

          {if nextAvailable
            <button
              children="Our next available #{timeOfDay} exam is
                #{nextAvailable.day_of_week},
                #{nextAvailable.month_decimal}/#{nextAvailable.day_of_month}"
              className=@classes.nextAvailable
              onClick={@handleNextAvailableClick nextAvailable.date}
              type='button' />
          }
        </p>
      }
    </div>

  render: ->
    @classes = @getClasses()

    return false unless @props.active

    <section className=@classes.block>
      {@renderAppointmentsSection(
        timeOfDay: 'morning'
        colWidth: 'narrow'
        cssModifiers:
          heading: '-left'
          slot: '-col--narrow -col--left'
      )}

      {@renderAppointmentsSection(
        timeOfDay: 'afternoon'
        colWidth: 'wide'
        cssModifiers:
          heading: ''
          slot: '-col--wide'
      )}

      {@renderAppointmentsSection(
        timeOfDay: 'evening'
        colWidth: 'narrow'
        cssModifiers:
          heading: '-right'
          slot: '-col--narrow -col--right'
      )}
    </section>
