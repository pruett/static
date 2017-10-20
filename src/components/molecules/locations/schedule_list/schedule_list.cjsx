[
  _
  React

  LocationsHoursTable

  Mixins
] = [
  require 'lodash'
  require 'react/addons'

  require 'components/molecules/locations/hours_table/hours_table'

  require 'components/mixins/mixins'

  require './schedule_list.scss'
]

module.exports = React.createClass
  BLOCK_CLASS: 'c-locations-schedule-list'

  mixins: [
    Mixins.classes
  ]

  propTypes:
    schedules: React.PropTypes.array
    currentStatus: React.PropTypes.string
    isOpenDaily: React.PropTypes.bool
    cssModifier: React.PropTypes.string

  getInitialState: ->
    showCurrentStatus: false

  getStaticClasses: ->
    block:
      "#{@BLOCK_CLASS}
      #{@props.cssModifier}"
    currentStatus:
      "#{@BLOCK_CLASS}__current-status
      u-reset  u-fs12 u-ls2_5 u-ttu u-fws
      u-color-bg--subtle-gray
      u-bc--light-gray
      u-dib"
    name:
      "#{@BLOCK_CLASS}__name
      u-reset
      u-color--dark-gray-alt-2"
    hours:
      "#{@BLOCK_CLASS}__hours"

  classesWillUpdate: ->
    currentStatus:
      'u-color--dark-gray': @props.currentStatus is 'open'
      'u-color--dark-gray-alt-2': @props.currentStatus is 'closed'
      'u-vh': not @state.showCurrentStatus

  componentDidMount: ->
    @setState showCurrentStatus: true

  statuses:
    open: 'Open now'
    closed: 'Closed now'

  getStoreSchedule: ->
    _.find @props.schedules, name: 'Store'

  render: ->
    classes = @getClasses()
    storeSchedule = @getStoreSchedule()

    <div className=classes.block>
      <p className=classes.currentStatus
        children=@statuses[@props.currentStatus] />

      {if storeSchedule
        [
          <LocationsHoursTable key='store'
            cssModifier=classes.hours
            schedule=storeSchedule
            isOpenDaily=@props.isOpenDaily
            />
        ]
      }

      {@props.schedules.map (schedule, i) ->
        return '' if schedule.name is 'Store'
        [
          <p key="name-#{i}"
            className=classes.name
            children="#{schedule.name} Hours" />
          ,
          <LocationsHoursTable key="table-#{i}"
            cssModifier=classes.hours
            schedule=schedule />
        ]
      , @}
    </div>
