React = require 'react/addons'
Mixins = require 'components/mixins/mixins'

require './quiz_promo.scss'

ReactCSSTransitionGroup = React.addons.CSSTransitionGroup

module.exports = React.createClass
  BLOCK_CLASS: 'c-quiz-promo'

  mixins: [
    Mixins.analytics
    Mixins.classes
  ]

  getDefaultProps: ->
    active: false
    hasQuizResults: false
    gender: ''
    image: '//i.warbycdn.com/v/c/assets/frames-quiz/image/gallery-promo/0/2a9007a99a.png'
    copy:
      header: 'Find frames in a snap'
      subhead: 'Take this quick quiz, and we’ll suggest some great-looking glasses to fill your Home Try-On.'
      cta: 'Take our quiz'
    hasResultsCopy:
      header: 'See my recommendations'
      subhead: 'Wanna take a look at the frames we recommended based on your quiz results?'
      cta: 'Show me'

  getStaticClasses: ->
    block: "
      #{@BLOCK_CLASS}
      u-oh
      u-mw1440
      u-mla u-mra
      u-pt48 u-pb48
      u-pl18 u-pr18
      u-tac
      u-color-bg--light-gray-alt-5
    "
    transition: "
      #{@BLOCK_CLASS}__transition
    "
    image: "
      #{@BLOCK_CLASS}__image
      u-mb12
    "
    header: '
      u-ffs u-fs24 u-fws
      u-m0
    '
    subhead: "
      #{@BLOCK_CLASS}__subhead
      u-mla u-mra u-mt6 u-mb24
      u-lh24
      u-color--dark-gray-alt-3
    "
    cta: "
      #{@BLOCK_CLASS}__cta
      u-button -button-medium -button-clear
      u-fws
    "

  render: ->
    classes = @getClasses()

    copy = if @props.hasQuizResults then @props.hasResultsCopy else @props.copy
    gender = if @props.gender is 'men' then 'm' else 'f'
    link = if @props.hasQuizResults then '/quiz/results' else "/quiz?gender=#{gender}"
    analytics = "gallery-click-#{if @props.hasQuizResults then 'quizResultsPromo' else 'quizPromo'}"

    <ReactCSSTransitionGroup transitionName=classes.transition>
      {if @props.active
        <section className=classes.block ref='block'>
          <img className=classes.image src=@props.image alt="frames illustration" />
          <h1 className=classes.header children=copy.header />
          <p className=classes.subhead children=copy.subhead />
          <a href=link
            onClick={@trackInteraction.bind(@, analytics)}
            className=classes.cta
            children=copy.cta />
        </section>}
    </ReactCSSTransitionGroup>
