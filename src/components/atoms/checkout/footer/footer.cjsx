[
  _
  React

  Markdown

  Mixins
] = [
  require 'lodash'
  require 'react/addons'

  require 'components/molecules/markdown/markdown'

  require 'components/mixins/mixins'

  require './footer.scss'
]

module.exports = React.createClass
  BLOCK_CLASS: 'c-checkout-footer'
  CONTENT_PATH: '/checkout/footer'

  mixins: [
    Mixins.analytics
    Mixins.classes
    Mixins.dispatcher
  ]

  fetchVariations: -> [
    @CONTENT_PATH
  ]

  getDefaultProps: ->
    border: true

  getStaticClasses: ->
    block: '
      u-tac
      u-fws
      u-mbn24
      u-bc--light-gray
    '
    title: '
      u-fs18 u-fws
      u-mt24 u-mt36--600
      u-mb12
    '
    description: "
      #{@BLOCK_CLASS}__description
      u-fwn
      u-fs16 u-ffss
      u-mt0 u-mb18 u-mra u-mla
      u-color--dark-gray-alt-3
    "
    container: '
      u-w3c u-wauto--600
      u-dib
      u-fs14 u-fs16--600
      u-ml12--600 u-mr12--600
    '
    image: "
      #{@BLOCK_CLASS}__image
    "
    link: '
      u-p6
    '
    inactive: "
      #{@BLOCK_CLASS}__inactive
      u-color--dark-gray
    "
    mobile: '
      u-db u-dn--600
    '
    desktop: '
      u-dn u-db--600
    '
    markdown: "
      #{@BLOCK_CLASS}__markdown
    "

  classesWillUpdate: ->
    block:
      'u-mt24 u-mt36--600 u-btss u-bw1': @props.border

  isLinkActive: (link) ->
    now = new Date()
    offset = _.get @content, 'timezone.offset', ''
    dateFields = @getDateFields now
    # if link is unavailable today
    return false if link.unavailable_days.indexOf(dateFields.day.toLowerCase()) > -1
    # if no hours set for the day, it's available
    return true unless link.available_hours.start

    startTime = @parseDate dateFields, link.available_hours.start, offset
    endTime = @parseDate dateFields, link.available_hours.end, offset
    nowTime = now.getTime()

    nowTime > startTime and nowTime < endTime

  getDateFields: (date) ->
    rfcMonths = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec']
    rfcDays = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat']

    day: rfcDays[date.getDay()]
    date: date.getDate()
    month: rfcMonths[date.getMonth()]
    year: date.getFullYear()

  parseDate: (fields, time, offset) ->
    Date.parse "#{fields.day}, #{fields.date}
      #{fields.month} #{fields.year}
      #{time}:00 #{offset}"

  getAvailabilityString: ->
    copy = []
    _.reduce @content.links, (result, link) =>
      result.push(link.availablity_string) unless @isLinkActive(link)
      result
    , copy
    copy.reverse()
    "We’re #{copy.join(' and ')}." if copy.length

  renderLink: (link) ->
    active = @isLinkActive link
    if active
      <div key=link.title className=@classes.container>
        <a
          href=link.route
          className=@classes.link
          onClick={@trackInteraction.bind @, "checkoutFooter-click-#{_.camelCase link.title}"}>
          <img src=link.image className=@classes.image />
          <div children=link.title />
        </a>
      </div>
    else
      <div key=link.title className="#{@classes.container} #{@classes.inactive}">
        <span className=@classes.link>
          <img src=link.image className=@classes.image />
          <div children=link.title />
        </span>
      </div>

  render: ->
    @classes = @getClasses()
    @content = @getContentVariation @CONTENT_PATH
    return false if _.isEmpty @content

    <footer className=@classes.block>
      <h3 className=@classes.title children=@content.title />
      <Markdown
        className="#{@classes.description} #{@classes.desktop}"
        rawMarkdown=@content.description
        cssModifiers={p: 'u-mb8'}
        cssBlock=@classes.markdown />
      <p
        className="#{@classes.description} #{@classes.mobile}"
        children={@getAvailabilityString()} />

      {@content.links.map @renderLink}

    </footer>
