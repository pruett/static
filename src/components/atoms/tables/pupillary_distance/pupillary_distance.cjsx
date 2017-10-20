[
  _
  React

  Mixins
] = [
  require 'lodash'
  require 'react/addons'

  require 'components/mixins/mixins'
]

module.exports = React.createClass
  BLOCK_CLASS: 'c-table-pd'

  mixins: [
    Mixins.conversion
  ]

  getDefaultProps: ->
    pd_binocular: '61.0'
    pd_od: '30.5'
    pd_os: '30.5'

  getFormattedPd: ->
    pd = _.clone @props

    for eye in ['od', 'os', 'binocular']
      measure = _.get(pd, "pd_#{eye}", '')
      pd["pd_#{eye}"] = @convert('prescription', 'pd', measure)

    pd

  render: ->
    utilityClass = 'u-data-table'

    pd = @getFormattedPd()

    if pd.pd_binocular
      thead =
        <tr className="#{utilityClass}__headers">
          <th className="#{utilityClass}__header u-tal">BINOCULAR</th>
        </tr>
      tbody =
        <tr className="#{utilityClass}__cells">
          <td className="#{utilityClass}__cell">{pd.pd_binocular}</td>
        </tr>
    else
      thead =
        <tr className="#{utilityClass}__headers">
          <th className="#{utilityClass}__header u-tal" colSpan='2'>
            MONOCULAR
          </th>
        </tr>
      tbody =
        <tr className="#{utilityClass}__cells">
          <td className="#{utilityClass}__cell">
            {pd.pd_od}
            <span className='u-reset u-fs12 -margin u-ffss'> Right (OD)</span>
          </td>
          <td className="#{utilityClass}__cell">
            {pd.pd_os}
            <span className='u-reset u-fs12 -margin u-ffss '> Left (OS)</span>
          </td>
        </tr>

    <div className={@BLOCK_CLASS}>
      <h2 className='u-reset u-fs24 -margin u-ffs u-fwn'>
        Pupillary distance
      </h2>
      <table className="#{utilityClass} u-reset u-ffss">
        <thead>
          {thead}
        </thead>
        <tbody>
          {tbody}
        </tbody>
      </table>
    </div>
