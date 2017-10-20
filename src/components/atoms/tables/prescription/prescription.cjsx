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
  BLOCK_CLASS: 'c-table-prescription'

  mixins: [
    Mixins.conversion
  ]

  getDefaultProps: ->
    created: '2015-01-22T23:19:43Z'
    expiration_date: '2016-01-08T00:00:00Z'
    id: 2387981
    name: 'Progressives'
    od_add: '10'
    od_axis: '90.00'
    od_cylinder: '0.25'
    od_sphere: '0.25'
    os_add: '\u00a0'
    os_axis: '90.0'
    os_cylinder: '-0.5'
    os_sphere: '1.75'
    status: 'accepted'
    updated: '2015-03-13T00:30:08Z'
    use_high_index: false

  render: ->
    utility_class = 'u-data-table'
    prescription = @formatted('prescription', @props)

    <div className=@BLOCK_CLASS>
      <table className="#{@BLOCK_CLASS}__main #{utility_class} -table-inline">
        <thead>
          <tr className="#{utility_class}__headers">
            <th className="#{utility_class}__header"></th>
            <th className="#{utility_class}__header">SPH</th>
            <th className="#{utility_class}__header">CYL</th>
            <th className="#{utility_class}__header">AXIS</th>
          </tr>
        </thead>
        <tbody>
          <tr>
            <td className="#{utility_class}__cell">Right (OD)</td>
            <td className="#{utility_class}__cell">{prescription.od_sphere}</td>
            <td className="#{utility_class}__cell">{prescription.od_cylinder}</td>
            <td className="#{utility_class}__cell">{prescription.od_axis}</td>
          </tr>
          <tr className="#{utility_class}__cells">
            <td className="#{utility_class}__cell">Left (OS)</td>
            <td className="#{utility_class}__cell">{prescription.os_sphere}</td>
            <td className="#{utility_class}__cell">{prescription.os_cylinder}</td>
            <td className="#{utility_class}__cell">{prescription.os_axis}</td>
          </tr>
        </tbody>
      </table>

      {if prescription.os_add
        <table className="#{utility_class} -table-detachable -table-inline">
          <thead>
            <tr className="#{@BLOCK_CLASS}__headers--add
              #{utility_class}__headers">
              <th colSpan='2'
                className="#{utility_class}__header -header-detachable">
                ADD
                <span className='u-dn--720'> VALUE</span>
              </th>
            </tr>
          </thead>
          <tbody>
            <tr className="#{@BLOCK_CLASS}__cells--add
              #{utility_class}__cells -table-inline -flip">
              <td className="#{utility_class}__cell -flip">
                {prescription.od_add} <span
                  className='u-reset u-fs12 u-mb24 u-ffss
                    u-dn--720'>Right (OD)</span>
              </td>
            </tr>
            <tr className="#{@BLOCK_CLASS}__cells--add
              #{utility_class}__cells -flip">
              <td className="#{utility_class}__cell -flip -flip-no-border">
                {prescription.os_add} <span
                  className='u-reset u-fs12 u-mb24 u-ffss
                    u-dn--720'>Left (OS)</span>
              </td>
            </tr>
          </tbody>
        </table>}

      {if prescription.os_prism
        <table className="#{utility_class} -table-detachable -table-inline">
          <thead>
            <tr className="#{@BLOCK_CLASS}__headers--add #{utility_class}__headers">
              <th colSpan='2' className="#{utility_class}__header -header-detachable">
                PRISM
                <span className='u-dn--720'> VALUE</span>
              </th>
            </tr>
          </thead>
          <tbody>
            <tr className="#{@BLOCK_CLASS}__cells--add #{utility_class}__cells -flip">
              <td className="#{utility_class}__cell -flip text-left">
                {prescription.os_prism}
                <span className='u-reset u-fs12 -margin u-ffss u-dn--720'> Left (OS)</span>
              </td>
            </tr>
            <tr className="#{@BLOCK_CLASS}__cells--add #{utility_class}__cells -flip">
              <td className="#{utility_class}__cell -flip -flip-no-border text-left">
                {prescription.od_prism}
                <span className='u-reset u-fs12 -margin u-ffss u-dn--720'> Right (OD)</span>
              </td>
            </tr>
          </tbody>
        </table>}

    </div>
