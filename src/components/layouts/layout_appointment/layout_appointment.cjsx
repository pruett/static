[
  _
  React

  Markdown
  Takeover
  UnsupportedBrowserNotice

  Mixins
] = [
  require 'lodash'
  require 'react/addons'

  require 'components/molecules/markdown/markdown'
  require 'components/molecules/modals/takeover/takeover'
  require 'components/atoms/unsupported_browser_notice/unsupported_browser_notice'

  require 'components/mixins/mixins'
]

require './layout_appointment.scss'

module.exports = React.createClass
  BLOCK_CLASS: 'c-layout-appointment'

  mixins: [
    Mixins.analytics
    Mixins.classes
    Mixins.dispatcher
    Mixins.conversion
  ]

  propTypes:
    appState: React.PropTypes.object

  getDefaultProps: ->
    appState: {}

  getInitialState: ->
    takeoverActive: false

  handleOpenTakeover: (evt) ->
    evt.preventDefault()
    @trackInteraction 'appointments-open-faq', evt
    @setState takeoverActive: true

  handleCloseTakeover: (evt) ->
    evt.preventDefault()
    @setState takeoverActive: false

  getStaticClasses: ->
    block: 'u-template'
    main: "#{@BLOCK_CLASS}__main u-template__main u-oh"
    footer: "
      #{@BLOCK_CLASS}__footer
      u-w100p
      u-mt72 u-mb72 u-mla u-mra
      u-pt24 u-pb48 u-pb0--600
      u-tac
    "
    footerButton: '
      u-button-reset
      u-color--blue
      u-fws
    '
    questionBlock: "
      u-mt36 u-mla u-mra
      u-pl18 u-pr18 u-pl36--600 u-pr36--600
      u-tal
    "
    question: "
      u-mb12
      u-reset u-fs20 u-ffs u-fws
    "
    footerActionContainer:
      "u-mt48 u-mb48 u-pt24 u-pt36--900 u-btss u-btw1 u-bc--light-gray"
    footerDateTime: "u-tac u-fs20 u-fws u-ffs u-mt0"
    footerAction: "u-fs16 u-db u-tac u-ffss u-tac"

  handleClickChange: (evt) ->
    evt.preventDefault()
    @commandDispatcher 'appointments', 'change'
    @trackInteraction 'appointments-change-appointment', evt

  render: ->
    classes = @getClasses()
    console.log('appointment layout props: ', @props)

    <div className=classes.block>
      <UnsupportedBrowserNotice />

      <main {...@props}
        role='main'
        className=classes.main />

      {if @props.appointment
        switch @props.appointment.booking_status
          when 'inProgress'
            dateObj = @convert 'utcdate', 'object', "#{@props.appointment.date.timestamp}Z"

            <footer className=classes.footerActionContainer key='date-time'>
              <p className=classes.footerDateTime>{"#{dateObj.month} #{dateObj.ordinalDate} at #{dateObj.formattedTime}"}</p>
              <a className=classes.footerAction
                onClick=@handleClickChange >
                Choose a different day or time
              </a>
            </footer>
          when 'complete'
            <footer className=classes.footerActionContainer key='book-another'>
              <a className=classes.footerAction>Book another appointment</a>
            </footer>
        }

    </div>
