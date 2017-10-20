[
  React

  CalloutOverlap
  CalloutOverlapMobile
  CalloutOverlapMobileShort
  CalloutParallel
  CalloutStacked

] = [
  require 'react/addons'

  require 'components/molecules/callout/callout_overlap/callout_overlap'
  require 'components/molecules/callout/callout_overlap_mobile/callout_overlap_mobile'
  require 'components/molecules/callout/callout_overlap_mobile_short/callout_overlap_mobile_short'
  require 'components/molecules/callout/callout_parallel/callout_parallel'
  require 'components/molecules/callout/callout_stacked/callout_stacked'

  require './callout.scss'
]

module.exports = React.createClass

  BLOCK_CLASS: 'c-callout'

  getTemplate: ->
    switch @props.template
      when 'overlap' then CalloutOverlap
      when 'overlap-mobile' then CalloutOverlapMobile
      when 'overlap-mobile-short' then CalloutOverlapMobileShort
      when 'parallel' then CalloutParallel
      else CalloutStacked

  render: ->
    Template = @getTemplate()

    <Template {...@props} />
