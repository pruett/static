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
  BLOCK_CLASS: 'c-address'

  mixins: [
    Mixins.classes
    Mixins.context
  ]

  getDefaultProps: ->
    cssUtility: '
      u-fs16 u-ffss
      u-color--dark-gray-alt-3
    '
    cssModifier: ''

  getStaticClasses: ->
    block: "
      #{@BLOCK_CLASS}
      #{@props.cssUtility}
      #{@props.cssModifier}
    "
    addressLine: 'u-m0'
    name: 'u-m0 u-color--dark-gray u-fws'

  render: ->
    classes = @getClasses()
    name = _.filter([
      @props.first_name
      @props.last_name
    ]).join ' '

    <div className=classes.block>
      {if name
        <p className=classes.addressLine>
          <span className=classes.name children=name />
          {<span children=", #{@props.company}" /> if @props.company}
        </p>
      else if @props.company
        <p className=classes.name children=@props.company />}

      <p className=classes.addressLine children=@props.street_address>
        <span children=@props.street_address />
        {<span children=", #{@props.extended_address}" /> if @props.extended_address}
      </p>

      <p className=classes.addressLine
        children="#{@props.locality}, #{@props.region} #{@props.postal_code}" />

      {if @props.country_code isnt @getLocale('country') or @getLocale('country') isnt 'US'
        switch @props.country_code
          when 'CA' then <p className=classes.addressLine children='Canada' />
          when 'US' then <p className=classes.addressLine children='United States' />}
    </div>
