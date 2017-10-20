[
  _
  React

  RightArrow
  LeftArrow
  HolidayLogotype
  ButtonsLogotype
  Markdown
  MarketingPromo

  Mixins
] = [
  require 'lodash'
  require 'react/addons'

  require 'components/quanta/icons/right_arrow/right_arrow'
  require 'components/quanta/icons/left_arrow/left_arrow'
  require 'components/atoms/icons/holiday_logotype/holiday_logotype'
  require 'components/atoms/icons/holiday_buttons_logotype/holiday_buttons_logotype'
  require 'components/molecules/markdown/markdown'
  require 'components/molecules/landing/holiday/marketing_promo/marketing_promo'

  require 'components/mixins/mixins'
]

module.exports = React.createClass
  # This page is based closely on the See Summer Better landing page,
  # so for now it has the same block class and will use modifiers for style
  # changes.
  BLOCK_CLASS: 'c-see-summer-better'

  mixins: [
    Mixins.context
  ]

  getDefaultProps: ->
    content:
      shoppable_grid: {}
      marketing_promos: []
      media_hero: {}
      additional_links: []
      featured_frame: {}
      introduction_block: {}
      staff_picks: {}
    giftCardBackgroundImage: '//i.warbyparker.com/v/c/assets/holiday-2015/image/gift-card-background/1/e4a8e936dc/1437x810/e7fc.jpg'

  handlePlayClick: ->
    @setState showVideo: true

  imageGridNavLeft: ->
    new_index = @state.carouselIndex - 1
    if new_index < 0
      new_index = @state.carouselSize - 1
    @setState carouselIndex: new_index

  imageGridNavRight: ->
    new_index = @state.carouselIndex + 1
    if new_index >= @state.carouselSize
      new_index = 0
    @setState carouselIndex: new_index

  shoppableImageTouch: (evt) ->
    return if evt.target.tagName is 'A'
    current = @state.shoppableImageOverlay
    @setState shoppableImageOverlay: !current

  getInitialState: ->
    carouselIndex:         0
    carouselSize:          4
    showVideo:             false
    touchEnabled:          window? and 'ontouchstart' of window
    shoppableImageOverlay: false

  render: ->
    content = @props.content
    return null unless content

    carouselStyle = marginLeft: @state.carouselIndex * -100 + '%'

    blockClasses =
      mediaHero:      'c-media-hero'
      introBlock:     'c-introduction-block--holiday c-introduction-block'
      featuredFrame:  'c-featured-frame'
      imageGrid:      'c-image-grid'
      shoppableImage: 'c-shoppable-image'
      recFrameGroup:  'c-recommended-frame-group'
      recFrame:       'c-recommended-frame-section'
      links:          'c-additional-links'
      shopNow:        'c-shop-now'

    classes =
      mediaHero:
        block: "
          #{blockClasses.mediaHero}
          "
        video: "
          #{blockClasses.mediaHero}__video
          "
        imageContainer: "
          #{blockClasses.mediaHero}__image-container
          #{['-hidden' if @state.showVideo]}
          "
        overlay: "
          #{blockClasses.mediaHero}__overlay
          "
        headline: "
          #{blockClasses.mediaHero}__headline
          "
        playButton: "
          #{blockClasses.mediaHero}__button
          "
        holidayPlayButtonWrapper: "
          #{blockClasses.mediaHero}__button-wrapper
          -holiday
          "
        playImage: "
          #{blockClasses.mediaHero}__play
          "
        buttonText: "
          #{blockClasses.mediaHero}__button-text
          "
        posterImage: "
          #{blockClasses.mediaHero}__image
          "

      introBlock:
        block: "
          #{blockClasses.introBlock}
          "
        ruleContainer: "
          #{blockClasses.introBlock}__rule-container
          "
        rule: "
          #{blockClasses.introBlock}__rule
          "
        headline: "
          #{blockClasses.introBlock}__headline
          "
        description: "
          #{blockClasses.introBlock}__description
          "

      featuredFrame:
        block: "
          #{blockClasses.featuredFrame}
          #{blockClasses.shopNow}
          -holiday
          "
        image: "
          #{blockClasses.featuredFrame}__image
          "

      shopNow:
        block: "
          #{blockClasses.shopNow}
          "
        name: "
          #{blockClasses.shopNow}__name  -holiday
          "
        nameFeatured: "
          #{blockClasses.shopNow}__name  -white
          "
        color: "
          #{blockClasses.shopNow}__color
          "
        description: "
          #{blockClasses.shopNow}__description
          "
        descriptionFeatured: "
          #{blockClasses.shopNow}__description -featured
          "
        links: "
          #{blockClasses.shopNow}__links
          "
        button: "
          u-button -button-white -button-pair -button-medium
          u-reset u-ffs u-fs16
          "

       shoppableImage:
        block: "
          #{blockClasses.shoppableImage}
          #{['-no-touch' unless @state.touchEnabled]}
          "
        group: "
          #{blockClasses.shoppableImage}-group
          "
        image: "
          #{blockClasses.shoppableImage}__image
          "
        overlay: "
          #{blockClasses.shoppableImage}__overlay
          #{['-enabled' if @state.shoppableImageOverlay]}
          "
        title: "
          #{blockClasses.shoppableImage}__title
          "
        linkGroup: "
          #{blockClasses.shoppableImage}__link-group
          "
        linkContainer: "
          #{blockClasses.shoppableImage}__link-container
          "
        link: "
          #{blockClasses.shoppableImage}__link
          "
        attribution: "
          #{blockClasses.shoppableImage}__attribution
          "

      imageGrid:
        block: "
          #{blockClasses.imageGrid}
          "
        container: "
          #{blockClasses.imageGrid}__container
          "
        arrowLeft: "
          c-image-grid__arrow-left
          "
        arrowRight: "
          c-image-grid__arrow-right
          "
        arrow: "
          u-fill--dark-gray -icon-margin-2x -size-300
          "

      recFrameGroup:
        block: "
          #{blockClasses.recFrameGroup}
          "
        container: "
          #{blockClasses.recFrameGroup}__container
          "

      recFrame:
        sectionFrame: "
          #{blockClasses.recFrame}
          #{blockClasses.recFrame}__frame
          "
        sectionLinks: "
          #{blockClasses.recFrame}
          #{blockClasses.recFrame}__links
          "

      links:
        block: "
          #{blockClasses.links}
          "
        content: "
          #{blockClasses.links}__content
          "
        name: "
          #{blockClasses.links}__name -holiday
          "
        link: "
          #{blockClasses.links}__link
          "
        arrow: "
          #{blockClasses.links}__arrow
          "

    giftCardBackgroundStyle =
      background: "url(#{@props.giftCardBackgroundImage}) repeat"
      backgroundSize: "100% 100%"

    <div className="#{@BLOCK_CLASS}__content">

      <div className=classes.mediaHero.block>
        {if @state.showVideo
          <iframe className=classes.mediaHero.video
                  src="https://www.youtube.com/embed/#{content.media_hero.video_id}?autoplay=1&controls=0&rel=0&showinfo=0"
                  frameBorder='0' allowFullScreen>
          </iframe>}
        <div className=classes.mediaHero.imageContainer>
          <div className=classes.mediaHero.overlay>
            <ButtonsLogotype />
            <div className=classes.mediaHero.holidayPlayButtonWrapper>
              <div
                   className=classes.mediaHero.playButton
                   onClick=@handlePlayClick>
                <img className=classes.mediaHero.playImage src=content.media_hero.button_image />
                <div className=classes.mediaHero.buttonText
                     children=content.media_hero.button_text />
              </div>
            </div>
          </div>
          <img className=classes.mediaHero.posterImage src=content.media_hero.poster_image />
        </div>
      </div>

      <div className=classes.introBlock.block>
        <HolidayLogotype />
        <div className=classes.introBlock.description>
          <Markdown rawMarkdown=content.introduction_block.description />
        </div>
        <div className=classes.introBlock.ruleContainer />
      </div>
      <div
        style=giftCardBackgroundStyle
        className=classes.featuredFrame.block>
        <img className=classes.featuredFrame.image src=content.featured_frame.image />
        <div className=classes.shopNow.nameFeatured>
          {content.featured_frame.name} <span className=classes.shopNow.color children=content.featured_frame.color />
        </div>
        <Markdown
          className=classes.shopNow.descriptionFeatured
          rawMarkdown=content.featured_frame.description />
        <div className=classes.shopNow.links>
          {if content.featured_frame.shop_link_women or content.featured_frame.shop_link_men
            <a
               className=classes.shopNow.button
               href={content.featured_frame.shop_link_women or content.featured_frame.shop_link_men}
               children='Shop Now' />}
        </div>
      </div>

      {if content.marketing_promos.length
        <MarketingPromo
          cssModifier='-no-padding-top'
          cssModifierName='-holiday' {...content.marketing_promos[0]} />}

      <div className=classes.shoppableImage.group>
        <div className=classes.imageGrid.container>
          <div className=classes.imageGrid.block>
            { _.map content.shoppable_grid.shoppable_images, (shoppable_image, i) =>
              <div key=i className=classes.shoppableImage.block
                   style={carouselStyle if i is 0}
                   onTouchStart={@shoppableImageTouch if @state.touchEnabled}>
                <img className=classes.shoppableImage.image src=shoppable_image.image />
                <div className=classes.shoppableImage.overlay>
                  <div className=classes.shoppableImage.title
                       children=shoppable_image.title />
                  <div className=classes.shoppableImage.linkGroup>
                    {if shoppable_image.shop_link_men
                      <div className=classes.shoppableImage.linkContainer>
                        <a
                           className=classes.shoppableImage.link
                           href=shoppable_image.shop_link_men
                           children='Shop Men' />
                      </div>}
                    {if shoppable_image.shop_link_women
                      <div className=classes.shoppableImage.linkContainer>
                        <a
                           className=classes.shoppableImage.link
                           href=shoppable_image.shop_link_women
                           children='Shop Women' />
                      </div>}
                  </div>
                  <div className=classes.shoppableImage.attribution
                       children=shoppable_image.attribution_text />
                </div>
              </div>
            }
          </div>
          <div
               className=classes.imageGrid.arrowLeft
               onClick=@imageGridNavLeft>
            <LeftArrow cssModifier=classes.imageGrid.arrow />
          </div>
          <div
               className=classes.imageGrid.arrowRight
               onClick=@imageGridNavRight>
            <LeftArrow cssModifier="#{classes.imageGrid.arrow} -icon-mirror" />
          </div>
        </div>
        <h2 className=classes.shopNow.name
            children=content.shoppable_grid.headline />
        <div className="#{classes.shopNow.description} -narrow">
          <Markdown rawMarkdown=content.shoppable_grid.description />
        </div>
      </div>

      {if content.marketing_promos.length > 1
        <MarketingPromo cssModifierName='-holiday' {...content.marketing_promos[1]} />}
      {if content.marketing_promos.length > 2
        <MarketingPromo cssModifierName='-holiday' {...content.marketing_promos[2]} />}

      <div className=classes.recFrameGroup.container>
        <h2 className=classes.shopNow.name
            children=content.staff_picks.headline />
        <p className=classes.shopNow.description
           children=content.staff_picks.description />
        <div className=classes.recFrameGroup.block>
          { _.map content.staff_picks.recommended_frames, (frame, i) =>
            <div row=i className=classes.recFrame.sectionFrame>
              <img src=frame.image />
              <div className="#{classes.shopNow.name} -recommended">
                {frame.name} <span className=classes.shopNow.color children=frame.color />
              </div>
              <div className="#{classes.shopNow.description} -recommended u-reset u-ffss u-fws">
                <Markdown rawMarkdown=frame.description />
              </div>
            </div>
          }
          { _.map content.staff_picks.recommended_frames, (frame, i) =>
            <div row=i className=classes.recFrame.sectionLinks>
              {if frame.shop_link_men
                <a
                   className=classes.shopNow.button
                   href=frame.shop_link_men
                   children='Shop Men' />}
              {if frame.shop_link_women
                <a
                   className=classes.shopNow.button
                   href=frame.shop_link_women
                   children='Shop Women' />}
            </div>
          }
        </div>
      </div>

      {if @getLocale('country') isnt 'CA'
        <div className=classes.links.block>
          { _.map content.additional_links, (link, i) ->
            <div row=i className=classes.links.content>
              <h2 className=classes.links.name
                  children=link.headline />
              <a
                 className=classes.links.link
                 href=link.link_url>
                  {link.link_text}
                  <RightArrow cssModifier=classes.links.arrow />
              </a>
            </div>
          }
        </div>}

    </div>
