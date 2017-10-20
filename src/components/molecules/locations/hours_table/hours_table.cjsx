[
  _
  React

  Mixins
] = [
  require 'lodash'
  require 'react/addons'

  require 'components/mixins/mixins'
]

module.exports = React.createClass
  BLOCK_CLASS: 'c-locations-hours-table'

  mixins: [
    Mixins.classes
  ]

  propTypes:
    schedule: React.PropTypes.shape
      name: React.PropTypes.string
      hours: React.PropTypes.object

  getStaticClasses: ->
    block:
      "#{@BLOCK_CLASS} #{@props.cssModifier}"
    daysCell:
      'u-reset u-ttc
      u-tal'
    hoursCell:
      'u-reset u-ttl
      u-tar'

  formatSchedule: (acc, day) ->
    # Given `@props.schedule`'s hours by day, merge days with the same open/close
    # hours into one array for cleaner presentation, e.g. "Mon-Thu 10-6".

    hours = _.get @props, "schedule.hours.#{day}"

    dayCount = acc.length
    prevSched = if dayCount > 0 then acc[dayCount - 1] else null

    unless hours and hours.open and hours.close
      # No hours available for this day.

      if prevSched and prevSched.closed
        # If the previous day was closed, add current day to previous day's.
        acc[dayCount - 1].days.push day

      else
        # Start a new array for closed days.
        acc.push(
          closed: true
          days: [day]
        )

      return acc

    openTime = @formatTime hours.open
    closeTime = @formatTime hours.close

    if prevSched and
      prevSched.hours and
      prevSched.hours.open is openTime and
      prevSched.hours.close is closeTime
        # Current day's hours match the previous day's, so add current day to
        # previous day's array.
        acc[dayCount - 1].days.push day

    else
      # Current day is the first in the list, or its hours don't match the
      # previous day's, so add a new object.
      acc.push(
        hours:
          open: openTime
          close: closeTime
        days: [day]
      )

    acc

  formatTime: (time) ->
    if time.indexOf ':00' > 0
      time.split(':00').join ''
    else
      time

  renderRow: (data, i) ->
    return '' if data.closed

    if @props.isOpenDaily
      dayRange = 'daily'
    else
      dayRange = data.days[0]
      if data.days.length > 1
        dayRange += "–#{data.days.slice(-1)[0]}"

    hourRange = "#{data.hours.open}–#{data.hours.close}"

    <tr key=i>
      <td className=@classes.daysCell
        children=dayRange />
      <td className=@classes.hoursCell
        children=hourRange />
    </tr>

  render: ->
    @classes = @getClasses()

    days = ['mon', 'tue', 'wed', 'thu', 'fri', 'sat', 'sun']
    schedule = days.reduce @formatSchedule, []

    <table className=@classes.block>
      <tbody children={schedule.map @renderRow} />
    </table>
