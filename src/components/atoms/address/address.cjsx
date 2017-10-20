React = require 'react/addons'

[
  _

  Mixins
] = [
  require 'lodash'

  require 'components/mixins/mixins'
]

module.exports = React.createClass
  BLOCK_CLASS: 'c-address'

  mixins: [
    Mixins.classes
    Mixins.context
  ]

  propTypes:
    first_name: React.PropTypes.string
    last_name: React.PropTypes.string
    company: React.PropTypes.string
    street_address: React.PropTypes.string
    extended_address: React.PropTypes.string
    locality: React.PropTypes.string
    region: React.PropTypes.string
    postal_code: React.PropTypes.oneOfType [
      React.PropTypes.string
      React.PropTypes.number
    ]
    country_code: React.PropTypes.string
    telephone: React.PropTypes.string
    showTelephone: React.PropTypes.bool
    cssUtility: React.PropTypes.string
    cssModifier: React.PropTypes.string

  getDefaultProps: ->
    first_name: ''
    last_name: ''
    company: ''
    street_address: ''
    extended_address: ''
    locality: ''
    region: ''
    postal_code: ''
    country_code: ''
    telephone: ''
    showTelephone: true
    cssUtility: 'u-reset u-fs16 u-mb24'
    cssModifier: ''

  getStaticClasses: ->
    block: "
      #{@BLOCK_CLASS}
      #{@props.cssUtility}
      #{@props.cssModifier}
    "
    addressLine: 'u-m0'

  formatTelephone: (telephone, options = {}) ->
    _.defaults options, delimiter: '-'

    telephone = "#{telephone}"

    if telephone.match /[^0-9\+\-\.\s\(\)]/
      return telephone

    stripped = telephone.replace /[^0-9]/g, ''

    if _.size(stripped) is 11 and _.first(stripped) is '1'
      [
        '+1'
        stripped.substr(1, 3)
        stripped.substr(4, 3)
        stripped.substr(7, 4)
      ].join options.delimiter
    else if _.size(stripped) is 10
      [
        stripped.substr(0, 3)
        stripped.substr(3, 3)
        stripped.substr(6, 4)
      ].join options.delimiter
    else
      telephone

  render: ->
    classes = @getClasses()
    name = _.filter([
      @props.first_name
      @props.last_name
    ]).join ' '

    <div className=classes.block>
      {<p className=classes.addressLine children=name /> if name}
      {<p className=classes.addressLine children=@props.company /> if @props.company}
      <p className=classes.addressLine children=@props.street_address />
      {<p className=classes.addressLine children=@props.extended_address /> if @props.extended_address}
      <p className=classes.addressLine children="#{@props.locality}, #{@props.region}" />
      <p className=classes.addressLine children=@props.postal_code />
      {if @props.country_code isnt @getLocale('country') or @getLocale('country') isnt 'US'
        switch @props.country_code
          when 'CA' then <p className=classes.addressLine children='Canada' />
          when 'US' then <p className=classes.addressLine children='United States' />}
      {<p className=classes.addressLine children=@formatTelephone(@props.telephone) /> if @props.telephone and @props.showTelephone}
    </div>
