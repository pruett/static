[
  _
  React

  Markdown
  XIcon

  Mixins
] = [
  require 'lodash'
  require 'react/addons'

  require 'components/molecules/markdown/markdown'
  require 'components/quanta/icons/x/x'

  require 'components/mixins/mixins'

  require './notice.scss'
]

module.exports = React.createClass
  BLOCK_CLASS: 'c-appointment-notice'

  mixins: [
    Mixins.analytics
    Mixins.classes
  ]

  propTypes:
    cssModifier: React.PropTypes.string
    manageDismissNotice: React.PropTypes.func
    notice: React.PropTypes.object

  getDefaultProps: ->
    cssModifier: ''
    notice: {}

  getStaticClasses: ->
    block:
      "#{@props.cssModifier}
      u-mln18 u-ml0--600
      u-mrn18 u-mr0--600"
    closeButton:
      'u-button-reset
      u-fr'
    heading:
      "#{@BLOCK_CLASS}__heading
      u-reset u-fs14 u-fs16--600
      u-fwn
      u-ttu"
    body:
      "#{@BLOCK_CLASS}__body"
    row:
      'u-grid__row -center'
    col:
      'u-grid__col u-w12c -c-10--900
      u-tal'
    content:
      'u-p24
      u-bss u-bw1 u-bc--light-gray'
    closeIcon:
      "#{@BLOCK_CLASS}__close-icon"

  handleClick: (evt) ->
    if _.isFunction @props.manageDismissNotice
      @props.manageDismissNotice evt
    @trackInteraction 'appointments-close-notice', evt

  render: ->
    classes = @getClasses()
    notice = @props.notice or {}
    noticeDescription = 'notice-description'
    noticeId = 'notice-id'

    <div aria-describedby=noticeDescription
      aria-labelledby=noticeId
      className=classes.block
      role='alertdialog'>
      <div className=classes.row>
        <div className=classes.col>
          <div className=classes.content>
            <button className=classes.closeButton
              aria-label='Close'
              onClick=@handleClick>
              <XIcon cssModifier=classes.closeIcon />
            </button>

            {if notice.heading
              <h1 className=classes.heading
                children=notice.heading
                id=noticeId />
            }

            {if notice.body
              <Markdown cssBlock=classes.body
                rawMarkdown=notice.body
                id=noticeDescription />
            }
          </div>
        </div>
      </div>
    </div>
