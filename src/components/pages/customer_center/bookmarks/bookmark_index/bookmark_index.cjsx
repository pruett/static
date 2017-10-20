[
  _
  React

  LayoutDefault

  Breadcrumbs
  Container
  Bookmark

  Mixins

] = [
  require 'lodash'
  require 'react/addons'

  require 'components/layouts/layout_default/layout_default'

  require 'components/atoms/breadcrumbs/breadcrumbs'
  require 'components/organisms/customer_center/container/container'
  require 'components/molecules/bookmark/bookmark'

  require 'components/mixins/mixins'

  require './bookmark_index.scss'
]

module.exports = React.createClass
  BLOCK_CLASS: 'c-customer-center-bookmark-index'

  mixins: [
    Mixins.context
    Mixins.dispatcher
  ]

  statics:
    route: ->
      path: '/account/bookmarks'
      handler: 'AccountBookmarks'
      bundle: 'customer-center'
      title: 'Bookmarks'

  propTypes:
    bookmarks: React.PropTypes.arrayOf React.PropTypes.object

  getDefaultProps: ->
    bookmarks: []

  receiveStoreChanges: -> [
    'account'
  ]

  render: ->
    account = @getStore 'account'
    bookmarks = account.bookmarks or []
    breadcrumbs = [
      { text: 'Account', href: '/account' }
      { text: 'Bookmarks' }
    ]

    <LayoutDefault {...@props}>
      <Breadcrumbs links=breadcrumbs />
      <Container {...@props} heading='Bookmarks'>
        {if account.__fetched
          <div className=@BLOCK_CLASS>
            {_.map bookmarks, (bookmark) ->
              <Bookmark {...bookmark} key=bookmark.id />}
          </div>}
      </Container>
    </LayoutDefault>
