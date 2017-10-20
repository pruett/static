[
  React
] = [
  require 'react/addons'
]

module.exports = React.createClass
  shouldComponentUpdate: -> false

  render: ->
    <div dangerouslySetInnerHTML={
      __html:
        '<!--[if lt IE 10]>
          <p class="u-fs20 u-fws u-m12">
            You are using a browser that we no longer support.
            <a href="https://www.google.com/chrome/">Use a modern browser</a> to
            utilize the functionality of this website.
          </p>
        <![endif]-->'
    } />
