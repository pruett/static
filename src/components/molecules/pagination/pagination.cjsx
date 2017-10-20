[
  _
  React

  RightArrow
  LeftArrow

  Mixins
] = [
  require 'lodash'
  require 'react/addons'

  require 'components/quanta/icons/right_arrow/right_arrow'
  require 'components/quanta/icons/left_arrow/left_arrow'

  require 'components/mixins/mixins'

  require './pagination.scss'
]

module.exports = React.createClass
  BLOCK_CLASS: 'c-pagination'

  mixins: [
    Mixins.classes
  ]

  propTypes:
    titleText: React.PropTypes.string
    recordsCount: React.PropTypes.number
    itemsPerPage: React.PropTypes.number
    initialPage: React.PropTypes.number
    baseHref: React.PropTypes.string

  getInitialState: ->
    currentPage: @props.currentPage

  getDefaultProps: ->
    titleText: ''
    baseHref: '#?page={page}'
    recordsCount: 15
    itemsPerPage: 3
    currentPage: 1

  getHref: (page) ->
    "#{@props.baseHref}".replace '{page}', page

  changePage: (current) ->
    @setState({currentPage: current})

  getPages: ->
    _.range(1, (@props.recordsCount / @props.itemsPerPage) + 1)

  getStaticClasses: ->
    block:
      @BLOCK_CLASS
    header:
      "#{@BLOCK_CLASS}__header"
    desktop:
      "#{@BLOCK_CLASS}__desktop u-dn u-db--720"
    mobile:
      "#{@BLOCK_CLASS}__mobile u-dn--720"
    nextPage:
      "#{@BLOCK_CLASS}__next"
    prevPage:
      "#{@BLOCK_CLASS}__prev"
    nextPageMobile:
      "#{@BLOCK_CLASS}__next-mobile"
    prevPageMobile:
      "#{@BLOCK_CLASS}__prev-mobile"
    currPage:
      "#{@BLOCK_CLASS}__curr"
    defaultPage:
      "#{@BLOCK_CLASS}__default"
    group:
      "#{@BLOCK_CLASS}__group"
    pageNum:
      "#{@BLOCK_CLASS}__page-num"

  maxPage: ->
    _.max @getPages()

  classesWillUpdate: ->
    nextPage:
     '-link-disabled' : @state.currentPage >= @maxPage()
    prevPage:
     '-link-disabled' : @state.currentPage <= 1
    nextPageMobile:
     '-link-disabled-mobile' : @state.currentPage >= @maxPage()
    prevPageMobile:
     '-link-disabled-mobile' : @state.currentPage <= 1

  getNext: (cssClass) ->
    <a className=cssClass
      href={@getHref(@props.currentPage + 1)}
      onClick={@changePage.bind(@, @state.currentPage + 1)}>
      <RightArrow />
    </a>

  getPrev: (cssClass) ->
    <a className=cssClass
      href={@getHref(@props.currentPage - 1)}
      onClick={@changePage.bind(@, @state.currentPage - 1)}>
      <LeftArrow />
    </a>

  render: ->
    classes = @getClasses()

    pages = _.map @getPages(), (pageNum) ->
      cssClass = if pageNum == @state.currentPage then classes.currPage else classes.defaultPage
      <a
        href={@getHref(pageNum)}
        key={pageNum}
        className={cssClass}
        onClick={@changePage.bind(@, pageNum)}>{pageNum}
      </a>
    , @

    <div className=classes.block>

      <div className=classes.desktop>
        {if @props.titleText
          <h4 className=classes.header>{@props.titleText}</h4>}

        <div className=classes.group>
          {@getPrev(classes.prevPage)}
          {pages}
          {@getNext(classes.nextPage)}
        </div>
      </div>

      <div className=classes.mobile>
        <div className=classes.group>
          {@getPrev(classes.prevPageMobile)}
          <div className=classes.pageNum>Page {@state.currentPage}</div>
          {@getNext(classes.nextPageMobile)}
        </div>
      </div>
    </div>
