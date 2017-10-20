[
  _
  React

  CTA
  Address
  IconDelete
  IconEdit

  Mixins
] = [
  require 'lodash'
  require 'react/addons'

  require 'components/atoms/buttons/cta/cta'
  require 'components/atoms/address/address'
  require 'components/quanta/icons/delete/delete'
  require 'components/quanta/icons/edit/edit'

  require 'components/mixins/mixins'

  require './editable_address.scss'
]

module.exports = React.createClass
  BLOCK_CLASS: 'c-editable-address'

  mixins: [
    Mixins.context
  ]

  propTypes:
    address: React.PropTypes.shape
      first_name: React.PropTypes.string
      last_name: React.PropTypes.string
      street_address: React.PropTypes.string
      extended_address: React.PropTypes.string
      locality: React.PropTypes.string
      region: React.PropTypes.string
      postal_code: React.PropTypes.string
      telephone: React.PropTypes.string
    cssModifier: React.PropTypes.string
    cssUtility: React.PropTypes.string
    cssVariation: React.PropTypes.string

  getDefaultProps: ->
    address: {}
    isDefault: false
    cssModifier: ''
    cssUtility: ''
    cssVariation: ''

  render: ->
    className = [
      "#{@BLOCK_CLASS}"
      "#{@props.cssModifier}"
      "#{@props.cssUtility}"
      "#{@props.cssVariation}"
    ].join ' '

    ctaEditProps =
      tagName: 'a'
      href: "/account/addresses/#{@props.address.id}/edit"
      cssModifier: [
        '-cta-small'
        '-cta-inline'
        '-cta-icon'
        '-cta-left'
        'u-ffss'
        'u-reset u-fs14'
        'u-fws'
        'u-mb8'
      ].join ' '

    ctaDeleteProps = _.assign {}, ctaEditProps,
      href: "/account/addresses/#{@props.address.id}/delete"

    <div className=className>

      <div className="#{@BLOCK_CLASS}__address">
        <Address {...@props.address} />
      </div>

      <div className="#{@BLOCK_CLASS}__actions">
        <CTA {...ctaEditProps} key='edit' analyticsSlug='address-click-edit'>
          <IconEdit cssUtility='u-icon u-fill--dark-gray -icon-margin-right' />Edit
        </CTA>
        <CTA {...ctaDeleteProps}
          analyticsSlug='address-click-delete'
          key='delete'>
          <IconDelete cssUtility='u-icon u-fill--dark-gray -icon-margin-right' />Delete
        </CTA>
      </div>
    </div>
