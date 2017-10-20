[
  _
  React

  Takeover
  IconX
  Img
  Markdown

  Mixins
] = [
  require 'lodash'
  require 'react/addons'

  require 'components/molecules/modals/takeover/takeover'
  require 'components/quanta/icons/x/x'
  require 'components/atoms/images/img/img'
  require 'components/molecules/markdown/markdown'

  require 'components/mixins/mixins'
]

require './opt_in_modal.scss'

module.exports = React.createClass
  BLOCK_CLASS: 'c-opt-in-modal'

  mixins: [
    Mixins.classes
    Mixins.dispatcher
  ]

  propType:
    isModalActive: React.PropTypes.bool
    closeModal: React.PropTypes.func

  getStaticClasses: ->
    modal: '
      u-db
      u-w100p u-w6c--900
      u-mla u-mra
      u-pr
      u-color-bg--white
      u-bw0 u-bw1--600 u-bss u-br2 u-bc--light-gray
    '
    contentContainer: '
      u-pt84 u-pb84
    '
    close: '
      u-button-reset
      u-pa u-t0 u-r0
      u-mt18 u-mr18
    '
    heading: '
      u-tac
      u-fws u-fs30 u-fs45--900
      u-ffs
      u-mb24 u-mt0
    '
    illustration: "
      #{@BLOCK_CLASS}__illustration
      u-db u-mla u-mra u-mt60 u-mb60
    "

    body: "
      #{@BLOCK_CLASS}__body
      u-tac
      u-fs16 u-fs18--900
      u-mt0 u-mb0 u-mra u-mla
    "
    subHeading: '
      u-tac
      u-fs24 u-fs34--900
      u-fws
      u-ffs
      u-mb24 u-mt0
    '
  renderBodyCopy: (args={}) ->
    <Markdown
      cssBlock="#{args.class} markdown"
      rawMarkdown="It’s official:
        You're on our email list.
        Glad you're still in the mix.
        (You can always update your
        email preferences [here](/account/profile)
        at any time.)"
    />

  componentWillMount: ->
    # We'll immediately remove the query string
    # that triggered this modal as it's not needed
    @commandDispatcher 'routing', 'replaceState', '/'

  render: ->
    classes = @getClasses()

    <Takeover
      analyticsSlug=''
      cssModifier='u-color-bg--white-95p'
      active=@props.isModalActive
      hasHeader=false
      verticallyCenter=true >

      <div className=classes.modal>
        <button className=classes.close onClick=@props.closeModal >
          <IconX cssModifier=classes.iconX cssUtility='u-icon u-fill--light-gray' />
        </button>
        <div className=classes.contentContainer>
          <div>
            <h1 className=classes.heading children='Excellent.' />
            {@renderBodyCopy({class: classes.body})}
            <Img
              cssModifier=classes.illustration
              srcSet='https://i.warbycdn.com/v/c/assets/home/image/balloon/0/82529b04be.png'
            />
          </div>
        </div>
      </div>
    </Takeover>
