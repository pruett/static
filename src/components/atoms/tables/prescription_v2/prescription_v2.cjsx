[
  React

  Mixins
] = [
  require 'react/addons'

  require 'components/mixins/mixins'
]

module.exports = React.createClass

  mixins: [
    Mixins.classes
    Mixins.conversion
  ]

  getDefaultProps: ->
    prescription: {}

  getStaticClasses: ->
    block: '
      u-pt4
    '
    table: '
      u-tac
      u-color--dark-gray-alt-3
      u-bss u-bc--light-gray u-bw1
    '
    headers: '
      u-fs12 u-ls3 u-fws
      u-color--dark-gray-alt-2
      u-color-bg--light-gray-alt-2
    '
    cellHeader: '
      u-pt6 u-pb6 u-pl12 u-pr12
      u-blss u-bc--light-gray u-bw1
    '
    cell: '
      u-p12
      u-bbss u-blss u-bc--light-gray u-bw1
    '

  render: ->
    classes = @getClasses()
    prescription = @formatted 'prescription', @props.prescription

    showAdd = prescription.os_add or prescription.od_add

    <div className=classes.block>
      <table className=classes.table>
        <thead>
          <tr className=classes.headers>
            <th />
            <th className=classes.cellHeader children='SPH' />
            <th className=classes.cellHeader children='CYL' />
            <th className=classes.cellHeader children='AXIS' />
            {<th className=classes.cellHeader children='ADD' /> if showAdd}
          </tr>
        </thead>
        <tbody>
          <tr>
            <td className="#{classes.cell} u-tal" children='Right (OD)' />
            <td className=classes.cell children=prescription.od_sphere />
            <td className=classes.cell children=prescription.od_cylinder />
            <td className=classes.cell children=prescription.od_axis />
            {<td className=classes.cell children=prescription.od_add /> if showAdd}
          </tr>
          <tr>
            <td className="#{classes.cell} u-tal" children='Left (OS)' />
            <td className=classes.cell children=prescription.os_sphere />
            <td className=classes.cell children=prescription.os_cylinder />
            <td className=classes.cell children=prescription.os_axis />
            {<td className=classes.cell children=prescription.os_add /> if showAdd}
          </tr>
        </tbody>
      </table>
    </div>
