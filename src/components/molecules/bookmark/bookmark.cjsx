[
  _
  React

  BookmarkFrame
] = [
  require 'lodash'
  require 'react/addons'
  require 'components/atoms/bookmark_frame/bookmark_frame'
]

module.exports = React.createClass
  BLOCK_CLASS: 'c-bookmark'

  propTypes:
    notes: React.PropTypes.string
    updated: React.PropTypes.string
    facility_name: React.PropTypes.string
    id: React.PropTypes.number
    frames: React.PropTypes.arrayOf React.PropTypes.object

  getDefaultProps: ->
    notes: ''
    frames: []
    updated: ''
    facility_name: ''
    id: 1

  render: ->
    propsBookmark = _.omit @props, 'frames'
    <div className={@BLOCK_CLASS}>
      { _.map @props.frames, (frame) ->
        <BookmarkFrame {...propsBookmark} {...frame} key={frame.color} />}
    </div>
