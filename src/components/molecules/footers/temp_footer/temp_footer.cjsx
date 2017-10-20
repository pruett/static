React = require 'react/addons'

require './temp_footer.scss'

module.exports = React.createClass
  BLOCK_CLASS: 'c-temp-footer'

  propTypes:
    cssUtility: React.PropTypes.string

  getDefaultProps: ->
    cssUtility: 'u-template__footer u-flex--none'

  render: ->
    linkClass = "#{@BLOCK_CLASS}__link u-reset u-fs14 u-fws"

    <footer className="#{@BLOCK_CLASS} #{@props.cssUtility}">
      <ul className="#{@BLOCK_CLASS}__link-list">
        <li className="#{@BLOCK_CLASS}__link-list-item">
          <a className="#{linkClass}" href='/help'>
            FAQ
          </a>
        </li>
        <li className="#{@BLOCK_CLASS}__link-list-item">
          <a className="#{linkClass}" href='mailto:help@warbyparker.com'>
            help@warbyparker.com
          </a>
        </li>
        <li className="#{@BLOCK_CLASS}__link-list-item">
          <a className="#{linkClass}" href='tel:+1-888-492-7297'>
            888.492.7297
          </a>
        </li>
      </ul>
    </footer>
