[
  _
  Backbone
] = [
  require 'lodash'
  require '../backbone'
]

class AppointmentsCollection extends Backbone.BaseCollection
  parse: (resp) ->
    appointmentsByDay = resp.availability

    # Bucket time slots by time of day.
    appointmentsByDay = appointmentsByDay.map (appointments, i) ->
      appointments.slots_bucketed = appointments.slots.reduce (bucketed, slot) ->
        date = new Date "#{slot.timestamp}Z"
        hours = date.getUTCHours()
        minutes = date.getUTCMinutes()
        if minutes < 10 then minutes = "0#{minutes}"

        if hours < 12
          slot.formattedTime = "#{hours}:#{minutes}a"
          bucketed.morning.push slot

        else if hours is 12
          slot.formattedTime = "#{hours}:#{minutes}p"
          bucketed.afternoon.push slot

        else if hours < 18
          slot.formattedTime = "#{hours - 12}:#{minutes}p"
          bucketed.afternoon.push slot

        else
          slot.formattedTime = "#{hours - 12}:#{minutes}p"
          bucketed.evening.push slot

        bucketed
      , {morning: [], afternoon: [], evening: []}

      appointments


    # If there are no appointments in a given time period, find the next date with
    # availability in that time period.
    appointmentsByDay = appointmentsByDay.map (appointments, i) ->
      appointments.next_available = {}

      _.forEach appointments.slots_bucketed, (slots, timeOfDay) ->
        if slots.length is 0
          dayOffset = 1

          # Advance through days until one has slots in this time period or we have
          # no more days available.
          while appointmentsByDay[dayOffset + i] and
            appointmentsByDay[dayOffset + i].slots_bucketed[timeOfDay].length is 0
              dayOffset += 1

          # If we found a future slot in this time period, add it.
          if appointmentsByDay[dayOffset + i] and
            appointmentsByDay[dayOffset + i].slots_bucketed[timeOfDay].length > 0
              appointments.next_available[timeOfDay] =
                _.omit appointmentsByDay[dayOffset + i], 'next_available'

      appointments

    appointmentsByDay


module.exports = AppointmentsCollection
