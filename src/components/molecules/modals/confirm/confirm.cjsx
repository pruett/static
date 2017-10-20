[
  React

  ModalWrapper
  Form
] = [
  require 'react/addons'
  require 'components/molecules/modals/wrapper/wrapper'
  require 'components/atoms/forms/form/form'

  require './confirm.scss'
]

module.exports = React.createClass
  BLOCK_CLASS: 'c-modal-confirm'

  propTypes:
    children: React.PropTypes.node

    id: React.PropTypes.string

    routeCancel: React.PropTypes.string
    routeConfirm: React.PropTypes.string

    txtHeading: React.PropTypes.string
    txtConfirm: React.PropTypes.string
    txtCancel: React.PropTypes.string

    onConfirm: React.PropTypes.func

  getDefaultProps: ->
    children: 'Hi there! All of your information is below.'

    id: ''
    routeCancel: ''
    routeConfirm: ''

    txtHeading: 'Are you sure you want to do this thing?'
    txtConfirm: 'Yes'
    txtCancel: 'Nevermind'

  render: ->
    <ModalWrapper routeCancel=@props.routeCancel>

      <Form
        id=@props.id
        method='post'
        className=@BLOCK_CLASS
        onSubmit=@props.onConfirm>

        <h1 children=@props.txtHeading
          className="
            #{@BLOCK_CLASS}__heading
            u-reset u-fs20 u-fws" />

        <div className="#{@BLOCK_CLASS}__content" children=@props.children />

        <div className="#{@BLOCK_CLASS}__buttons">
          {if @props.onConfirm
            <button
              type='submit'
              children=@props.txtConfirm
              className="#{@BLOCK_CLASS}__button-confirm
                u-button -button-white -button-inline -button-medium"/>}

          {if @props.routeConfirm
            <a href=@props.routeConfirm
              children=@props.txtConfirm
              className="#{@BLOCK_CLASS}__button-confirm
                u-button -button-white -button-inline -button-medium"/>}

          {if @props.routeCancel
            <a href=@props.routeCancel
              children=@props.txtCancel
              className="#{@BLOCK_CLASS}__button-cancel
                u-button -button-inline -button-medium"/>}
        </div>

      </Form>
    </ModalWrapper>
