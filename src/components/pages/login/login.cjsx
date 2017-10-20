[
  _
  React

  LayoutDefault

  AccountForm

  Mixins
] = [
  require 'lodash'
  require 'react/addons'

  require 'components/layouts/layout_default/layout_default'

  require 'components/organisms/account/account_form/account_form'

  require 'components/mixins/mixins'
]

module.exports = React.createClass
  statics:
    route: ->
      path: '/login'
      handler: 'Login'
      bundle: 'session'
      title: 'Sign-in'

  mixins: [
    Mixins.context
    Mixins.dispatcher
  ]

  propTypes:
    routeLoggedIn: React.PropTypes.string
    routeNewCustomerSuccess: React.PropTypes.string

  receiveStoreChanges: -> [
    'session'
  ]

  getDefaultProps: ->
    routeForgotPassword: '/account/forgot-password'
    routeLoginSuccess: '/account'
    routeNewCustomerSuccess: '/account'

  manageLoginSubmit: (attrs) ->
    @commandDispatcher 'session', 'login', attrs

  manageNewCustomerSubmit: (attrs) ->
    @commandDispatcher 'session', 'createNewCustomer',
      attrs, @props.routeNewCustomerSuccess

  render: ->
    session = @getStore('session') or {}

    <LayoutDefault {...@props}>
      <AccountForm
        {...@props}
        {...session}
        manageLoginSubmit=@manageLoginSubmit
        manageNewCustomerSubmit=@manageNewCustomerSubmit />
    </LayoutDefault>
