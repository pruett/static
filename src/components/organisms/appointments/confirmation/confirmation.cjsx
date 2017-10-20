[
  _
  React

  RightArrowIcon
  CTA
  StaticGoogleMap
  Markdown

  Mixins
] = [
  require 'lodash'
  require 'react/addons'

  require 'components/quanta/icons/right_arrow/right_arrow'
  require 'components/atoms/buttons/cta/cta'
  require 'components/atoms/maps/google/static/static'
  require 'components/molecules/markdown/markdown'

  require 'components/mixins/mixins'

  require './confirmation.scss'
]

module.exports = React.createClass
  BLOCK_CLASS: 'c-appointment-confirmation'

  COPY:
    calendarLink:
      details: """Please bring your most recent prescription (or current glasses) to the exam.
        Also, please arrive 5-10 minutes early to fill out some quick paperwork."""

  mixins: [
    Mixins.classes
    Mixins.conversion
  ]

  propTypes:
    appointment: React.PropTypes.object
    content: React.PropTypes.object

  getDefaultProps: ->
    appointment: {}
    content: {}

  getStaticClasses: ->
    block: "
      #{@BLOCK_CLASS}
      u-tac
      u-reset u-fs16
    "
    confirmationContent: "
      #{@BLOCK_CLASS}__confirmation-content
      u-mla u-mra
    "
    heading: '
      u-reset
      u-fs20 u-fs30--600 u-fs34--1200
      u-fws
      u-ffs'
    subhead: '
      u-reset
      u-fs20 u-fs24--600 u-fs24--1200
      u-fws
      u-ffs
      u-fsi'
    hr: "
      #{@BLOCK_CLASS}__hr
      u-hr -three
    "
    appointmentInfo: "
      #{@BLOCK_CLASS}__appointment-info
      u-grid
      u-mb36 u-mb72--900
      u-pl0 u-pr0
    "
    infoRow: "
      #{@BLOCK_CLASS}__info-row
      u-grid__row -center
      u-mt72
    "
    infoRowAlt: "
      #{@BLOCK_CLASS}__info-row -alt
      u-grid__row -center
      u-mt72
      u-pt36--900 u-pb36--900 u-pl12--900 u-pr12--900
    "
    appointmentDataChunk: "
      #{@BLOCK_CLASS}__appointment-data-chunk
      u-mt36 u-mt0--900
      u-grid__col u-w12c -c-4--900
      u-tac
      u-fs16
    "
    locationIcon: "
      #{@BLOCK_CLASS}__chunk-icon
      u-mb18 -location
    "
    timeIcon: "
      #{@BLOCK_CLASS}__chunk-icon
      u-mb12 -time
    "
    customerIcon: "
      #{@BLOCK_CLASS}__chunk-icon
      u-mt12 u-mb18 -customer
    "
    chunkDataLineItem: "
      #{@BLOCK_CLASS}__chunk-data-line-item
      u-reset u-ffss u-fs18
    "
    mapArea: "
      #{@BLOCK_CLASS}__map-area
      u-grid__col u-w12c -c-6--900
      u-mb48 u-mb0--900
      u-pb12 u-pb0--900
      u-tal
      u-fs16
    "
    mapEmbed: "
      #{@BLOCK_CLASS}__map-embed
      u-db u-mb12
    "
    mapLinkIcon: "
      #{@BLOCK_CLASS}__map-link-icon
      u-pr
      u-mt4 u-ml6
      u-fill--blue
    "
    details: "
      u-grid__col u-w12c -c-6--900
      u-tac u-tal--900
      u-fs16
    "
    detail: "#{@BLOCK_CLASS}__detail"
    detailHeading: "u-fs16 u-fws u-ffss u-pb12 u-di--900"
    detailContent: "u-fs16 u-ffss u-di--900"
    cta: "
      u-dib
      u-fs16 u-ffss
    "
    markdown: "#{@BLOCK_CLASS}__markdown"
    spacer: 'u-dn u-di--900'

  formatStoreAddress: (address) ->
    return '' if _.isEmpty address

    """#{address.street_address}
    #{address.locality}, #{address.region_code}
    #{address.postal_code}"""

  formatAddToCalendarDate: (date) ->
    date.toISOString().replace(/([-:]|\.\d*)/g,'')

  renderAddToCalendarLink: (location, timestamp) ->
    calendarURL = 'http://www.google.com/calendar/render?'
    storeName = _.get location, 'name', ''
    timezone = _.get location, 'timezone', 'America/New_York'

    appointmentInterval = []
    date = new Date(timestamp)
    appointmentInterval.push @formatAddToCalendarDate date
    date.setMinutes(date.getMinutes() + 40)
    appointmentInterval.push @formatAddToCalendarDate date

    searchParams =
      text: if storeName then "Eye exam at Warby Parker #{storeName}" else 'Eye exam at Warby Parker'
      dates: "#{appointmentInterval.join('/')}"
      details: @COPY.calendarLink.details
      location: @formatStoreAddress _.get(location, 'address', {})
      ctz: timezone
      action: 'TEMPLATE'
      trp: false
      sf: true

    queryComponents = _.map searchParams, (v, k) -> "#{k}=#{v}".replace /\s/g, '+'

    <a href={calendarURL.concat queryComponents.join('&')}
      target='_blank'
      children="Add to calendar" />

  render: ->
    appointment = @props.appointment or {}
    content = @props.content or {}
    location = @props.location or {}

    classes = @getClasses()

    timestamp = _.get appointment, 'date.timestamp'

    if timestamp
      parsedDatetime = @convert 'utcdate', 'object', "#{timestamp}Z"
      calendarLink = @renderAddToCalendarLink(location, timestamp)

      if parsedDatetime
        hours =
          if parsedDatetime.hours > 12
            parsedDatetime.hours - 12
          else
            parsedDatetime.hours

        appointmentTime = "#{hours}:"
        appointmentTime += "0#{parsedDatetime.minutes}".slice(-2)

        if parsedDatetime.hours < 12
          appointmentTime += ' a.m.'
        else
          appointmentTime += ' p.m.'

    userFirstName = _.get @props, 'session.customer.first_name'
    userFirstName = if userFirstName then ", #{userFirstName}" else ''

    <div className=classes.block>

      <div className=classes.confirmationContent>

        <p className=classes.subhead children="Thank you#{userFirstName}!" />

        <div className=classes.hr />

        <h1 className=classes.heading children={_.get content, 'confirmation.headline'} />

        <div className=classes.appointmentInfo>

          <div className=classes.infoRow>
            <div className=classes.appointmentDataChunk>
              <img className=classes.locationIcon
                src={_.get content, 'confirmation.summary_icons.location'}
                alt='Appointment location'
              />
              <div className=classes.chunkDataLineItem children={_.get location, 'name', ''} />
              <div className=classes.chunkDataLineItem
                children={_.compact([
                    _.get location, 'address.street_address'
                  ,
                    _.get location, 'address.extended_address'
                  ]).join ', '}
              />
              <div className=classes.chunkDataLineItem
                children="#{_.get location, 'address.locality', ''},
                  #{_.get location, 'address.region_code', ''}
                  #{_.get location, 'address.postal_code', ''}"
              />
            </div>

            {if parsedDatetime
              <div className=classes.appointmentDataChunk>
                <img className=classes.timeIcon
                  src={_.get content, 'confirmation.summary_icons.time'}
                  alt='Appointment time'
                />
                <div className=classes.chunkDataLineItem
                  children="#{parsedDatetime.month} #{parsedDatetime.date}" />
                <div className=classes.chunkDataLineItem
                  children=parsedDatetime.day />
                <div className=classes.chunkDataLineItem
                  children=appointmentTime />
                <div className=classes.chunkDataLineItem
                  children=calendarLink />
              </div>
            }

            {if appointment.first_name
              <div className=classes.appointmentDataChunk>
                <img className=classes.customerIcon
                  src={_.get content, 'confirmation.summary_icons.customer'}
                  alt='Appointment customer'
                />
                <div className=classes.chunkDataLineItem
                  children="#{appointment.first_name} #{appointment.last_name}" />
                <div className=classes.chunkDataLineItem children=appointment.email />
                <div className=classes.chunkDataLineItem children=appointment.telephone />
              </div>
            }
          </div>

          <div className=classes.infoRowAlt>
            <div className=classes.mapArea>
              <StaticGoogleMap key='map'
                cssModifier=classes.mapEmbed
                height=320
                markers="color:0x00a2e1|#{_.get location,
                  'cms_content.map_details.latitude'},#{_.get location,
                  'cms_content.map_details.longitude'}"
                scale=2
                width=480
                zoom=15
              />
              <a href={_.get location, 'cms_content.map_details.url'} target='_blank'>
                <span children='View map' />
                <RightArrowIcon cssModifier=classes.mapLinkIcon />
              </a>
            </div>

            <div className=classes.details>
              {_.get(content, 'confirmation.appointment_details', []).map (detail, i) ->
                detailBody = detail.body
                if detail.append_contact_info_sentence
                  locationPhone = _.get location, 'cms_content.phone'
                  if locationPhone
                    detailBody = "#{detail.body} Just give us a call at
                      [#{locationPhone}](tel:#{locationPhone.replace /[^0-9]/g, ''})."

                <div className=classes.detail key="detail-#{i}">
                  <h2 className=classes.detailHeading children=detail.headline />
                  <span children="  " className=classes.spacer />
                  <Markdown
                    className=classes.detailContent
                    cssBlock=classes.markdown
                    rawMarkdown=detailBody />
                </div>
              }
            </div>
          </div>

        </div>

        <CTA children='Return to store page'
          cssModifier="-cta-large"
          cssUtility=classes.cta
          href="/retail/#{location.location_slug or ''}"
          tagName='a'
          variation='primary'
        />

      </div>

    </div>
