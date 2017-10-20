[
  _
  React

  Mixins
] = [
  require 'lodash'
  require 'react/addons'

  require 'components/mixins/mixins'

  require './technical_details.scss'
]

module.exports = React.createClass
  BLOCK_CLASS: 'c-technical-details'

  mixins: [
    Mixins.classes
  ]

  propTypes:
    details: React.PropTypes.array

  getStaticClasses: ->
    block: "
      #{@BLOCK_CLASS}
      u-clearfix
    "
    title: '
      u-reset u-fs20 u-fs24--600 u-fs30--1200 u-ffs u-fws
    '
    listsContainer: 'u-clearfix'
    list: "
      #{@BLOCK_CLASS}__list
      u-grid__col u-w12c u-w6c--900
      u-pl24 u-ml12 u-ml0--900 u-mb0
      u-fs16 u-fs18--900 u-ffss u-fwl
    "
    listItem: 'u-color--light-gray u-pl12'
    listItemContent: '
      u-mt24 u-mb24 u-db u-color--dark-gray
    '

  render: ->
    classes = @getClasses()

    <div className=classes.block>
      <div children='Nothing but the best' className=classes.title />

      <div className=classes.listsContainer>
        <ul className=classes.list>
          {for detail, i in @props.details
            if i % 2 is 0
              <li className=classes.listItem key="detail-#{i}">
                <span className=classes.listItemContent>{detail}</span>
              </li>
          }
        </ul>

        <ul className=classes.list>
          {for detail, i in @props.details
            if i % 2 isnt 0
              <li className=classes.listItem key="detail-#{i}">
                <span className=classes.listItemContent>{detail}</span>
              </li>
          }
        </ul>
      </div>

    </div>
