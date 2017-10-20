[
  _
  React

  TitleBlock
  TablePrescription
  TablePD
  Mixins
] = [
  require 'lodash'
  require 'react/addons'
  require 'components/atoms/title_block/title_block'
  require 'components/atoms/tables/prescription/prescription'
  require 'components/atoms/tables/pupillary_distance/pupillary_distance'
  require 'components/mixins/mixins'

  require './prescription.scss'
]

module.exports = React.createClass
  BLOCK_CLASS: 'c-prescription'

  mixins: [
    Mixins.conversion
  ]

  getDefaultProps: ->
    created: '2015-01-22T23:19:43Z'
    expiration_date: '2016-01-08T00:00:00Z'
    id: 2387981
    name: 'Prescription'
    od_add: '+2.00'
    od_axis: '162'
    od_cylinder: '0.25'
    od_sphere: '-3.00'
    os_add: "+2.00"
    os_axis: '170'
    os_cylinder: '-0.50'
    os_sphere: '1.75'
    pd_binocular: ''
    pd_od: '30.00'
    pd_os: '32.50'
    status: 'accepted'
    updated: '2015-03-13T00:30:08Z'
    use_high_index: false

  getPrescriptionType: (prescription) ->
    if @props.os_add and @props.os_axis
      type = 'Progressives'
    else if @props.os_add
      type = 'Readers'
    else
      type = 'Single-vision'

  render: ->
    utc = @convert 'date', 'object', @props.expiration_date
    isExpired = @convert('date', 'days-since', @props.expiration_date) > 0

    cssExpiration = [
      "#{@BLOCK_CLASS}__expiration"
      'u-reset u-color--dark-gray-alt-2' if isExpired
    ].join ' '

    <div className=@BLOCK_CLASS>
      <TitleBlock txtTitle={@getPrescriptionType()}>
        <span className=cssExpiration>
          Expires: {utc.month} {utc.date}, {utc.year}
        </span>
      </TitleBlock>

      <div className="#{@BLOCK_CLASS}__container u-tac">
        <div className="#{@BLOCK_CLASS}__content u-tal">
          <TablePrescription {...@props} />

          {if @props.pd_os or @props.pd_binocular
            <TablePD {...@props} />}
        </div>
      </div>
    </div>
