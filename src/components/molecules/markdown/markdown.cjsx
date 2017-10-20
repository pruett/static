[
  _
  React
  Marked

] = [

  require 'lodash'
  require 'react/addons'
  require 'marked'

  require './markdown.scss'
]


module.exports = React.createClass

  getMarkdown: (rawMarkdown, renderer = {}) ->
    #  Transform Markdown to React nodes
    Marked rawMarkdown, renderer: _.assign(new Marked.Renderer, renderer)

  handleClick: ->

  getRenderingObject: (cssModifiers) ->
    blockClass: null
    id: ''
    create: (tagName, props) ->
      className = ["#{@blockClass}__#{tagName}"]
      className.push cssModifiers[tagName] if cssModifiers[tagName]
      React.DOM[tagName]( _.assign props, className: className.join ' ' )

    escapeLink: (link) ->
      # Check for the existence of pipes (|) in the link body
      linkWithPipes = /^\|(.*)\|(.*)$/.exec(link)
      # and return the second capture pair if found
      return linkWithPipes[2] if linkWithPipes

      # Allow links to elements on page and relative URLs.
      if _.startsWith(link, '#') or _.startsWith(link, '/')
        return link

      try
        protocol = decodeURIComponent(unescape(link))
          .replace(/[^\w:]/g, '')
          .toLowerCase()
      catch
        return null

      for allowed in ['https:', 'http:', 'mailto:', 'tel:']
        # Don't allow [javascript:, vbscript:, data:]
        if _.startsWith(protocol, allowed)
          return link

      null

    getTarget: (link) ->
      ###
      If your markdown link follows a
      specific format, open link in a new tab

      i.e.
      [some link text](|_blank|http://google.com) => new tab
      [some link text](http://google.com) => normal link behavior (same tab)
      ###

      if /^\|\_blank\|/.test(link) then '_blank' else null

    combine: (out) -> out

    escape: (html, encode) -> html  # React handles the escaping of innerHtml.

    # Block Elements
    blockquote: (quote) -> @create 'blockquote', children: quote
    code: (code, language) -> @create 'pre', children: code
    heading: (text, level) -> @create "h#{level}", children: text
    hr: -> @create 'hr'
    html: (html) -> @create 'html', children: html
    list: (body, ordered) ->
      if ordered
        @create 'ol', children: body
      else
        @create 'ul', children: body
    listitem: (text) -> @create 'li', children: text
    paragraph: (text) -> @create 'p', children: text
    table: (header, body) -> @create 'table',
      children: [
        @create 'thead', children: header
        @create 'tbody', children: body
      ]
    tablecell: (content, flags) -> @create 'td', children: content
    tablerow: (content) -> @create 'tr', children: content

    # Inline elements
    strong: (text) -> @create 'strong', children: text
    em: (text) -> @create 'em', children: text
    codespan: (code) -> @create 'code', children: code
    br: -> @create 'br'
    del: (text) -> @create 'del', children: text

    link: (href, title, text) ->
      title = if title? then escape(title) else null
      @create('a', href: @escapeLink(href), target: @getTarget(href), title: title, children: text, id: "#{@id}", onClick: @handleClick)

    image: (src, title, text) ->
      title = if title? then escape(title) else null
      @create 'img', src: @escapeLink(src), title: title, alt: text


  BLOCK_CLASS: 'c-markdown'

  propTypes:
    className: React.PropTypes.string
    cssBlock: React.PropTypes.string
    cssModifiers: React.PropTypes.object # { tagName: className string }
    rawMarkdown: React.PropTypes.string

  getDefaultProps: ->
    rawMarkdown: ''
    className: ''
    tagName: 'div'
    cssModifiers: {}
    gaModifier: ''

  render: ->
    return false unless _.isString @props.rawMarkdown
    ###
    # All child elements of the main block div are given class names in the
    # format {block}__{element}. The value of {block} defaults to @BLOCK_CLASS,
    # but can be overridden via the `cssBlock` prop. The value of {element} is
    # the tag name targeted by the Markdown in question. Use `cssBlock` if you
    # need class names to style child elements, otherwise let this fall back to
    # sensible default styles.
    ###

    reactRenderer = @getRenderingObject(@props.cssModifiers)
    reactRenderer.blockClass = @props.cssBlock or @BLOCK_CLASS
    reactRenderer.id = @props.gaModifier
    if _.isFunction @props.handleClick
      reactRenderer.handleClick = @props.handleClick
    markdown = @getMarkdown(@props.rawMarkdown, reactRenderer)

    <@props.tagName {...@props}
      className="#{@BLOCK_CLASS} #{@props.className}"
      children=markdown />
