[
  _
  React
] = [
  require 'lodash'
  require 'react/addons'
]

module.exports =

  # This mixin handles the sorting of versioned frame for collections
  # as well as the base product impressions for both versioned and fans pages.
  # The mixin uses methods from the
  # dispatcher mixin (components/mixins/dispatcher_mixin) as well

  groupCMSFrames: (frames, versions) ->
    # frames = {fans: [{name:"Roland", "colors": ["Blue, Green"]}], men: [{}], women: [{}]}
    # Return an object of gendered frame groups, properly ordered per the CMS
    fans: @orderFramesByVersion(frames, versions.fans)
    women: @orderFramesByVersion(frames, versions.women)
    men: @orderFramesByVersion(frames, versions.men)

  orderFramesByVersion: (frames, version) ->
    # Order frames by version
    _.map version, (options) =>
      match = _.find frames, (frame) ->
        frame.products[0].display_name is options.name
      @orderFrameColors(match, options.colors)

  orderFrameColors: (frame, colors) ->
    # Customize which swatch/color is displayed by default per version
    newFrameArray = _.map colors, (color) ->
      match = _.find frame.products, (frame) ->
        color is frame.color

    products: newFrameArray

  getGroupedFrames: (version) ->
    frames = _.get @props, "content.frames[#{version}]"
    _.groupBy frames, 'section'

  getProductImpressions: (version) ->
    frames = _.get @props, "content.frames[#{version}]"
    unless version is 'fans'
      @getVersionedImpressions(frames, version)
    else
      @getFansImpressions(frames)

  getVersionedImpressions: (frames, version, femaleKey=w) ->
    #  Most collections using this mixin have gendered details associated with the key 'w'
    #  However, frames coming from the product catalog for use with WARB-1601 are keyed under 'f'
    unless femaleKey is 'f'
      version = {men: 'm', women: 'w'}[version]
    else
      version = {men: 'm', women: 'f'}[version]

    impressions = _.map frames, (frame, i) =>
      impression =
        name: frame.products[0].name or frame.products[0].display_name
        position: i + 1
        color: _.get frame, 'products[0].color'
      @getVersionedIds(frame, version, impression)

    @dispatchImpressions(impressions)

  dispatchImpressions: (impressions) ->
    #we need to add some arbitrary data to each impression per the GA spec
    finalImpressions = _.map impressions, (impression) =>
      _.assign impression,
        brand: 'Warby Parker',
        category: 'Frame'
        list: @props.gaListModifier

    if _.isFunction(@commandDispatcher)
      @commandDispatcher 'analytics', 'pushProductEvent',
        type: 'productImpression'
        products: finalImpressions

  getVersionedIds: (frame, version, impression) ->
    #find the id of the assembly that matches the version being passed
    assembly = _.find _.get(frame, 'products[0].gendered_details'), (assembly) ->
      assembly.gender is version

    impression.id = assembly.product_id
    impression

  getFansImpressions: (frames) ->
    #here we need to build impressions for both genders, despite only one frame being shown
    #some frames are only available for one gender, so best to map through the available
    #gendered details, providing an object for any available variants
    impressions = []
    _.map frames, (frame, i) ->
      impression =
        name: frame.products[0].name or frame.products[0].display_name
        position: i + 1
        color: _.get frame, 'products[0].color'
      _.map _.get(frame, 'products[0].gendered_details'), (assembly) ->
        id = assembly.product_id
        newImpression = _.assign {}, impression
        newImpression.id = id

        impressions.push newImpression

    @dispatchImpressions(impressions)
