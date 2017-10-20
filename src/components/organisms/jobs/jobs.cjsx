[
  _
  React

  Img
  Picture

  Markdown
  TeamWarby

  Mixins
] = [
  require 'lodash'
  require 'react/addons'

  require 'components/atoms/images/img/img'
  require 'components/atoms/images/picture/picture'

  require 'components/molecules/markdown/markdown'
  require 'components/molecules/teamwarby/teamwarby'

  require 'components/mixins/mixins'

  require './jobs.scss'
]

module.exports = React.createClass

  BLOCK_CLASS: 'c-jobs'

  mixins: [
    Mixins.analytics
    Mixins.classes
    Mixins.dispatcher
    Mixins.image
    Mixins.scrolling
  ]

  propTypes:
    content: React.PropTypes.object
    featuredJobs: React.PropTypes.array
    groupedJobs: React.PropTypes.array

  getDefaultProps: ->
    content: {}
    featuredJobs: []
    groupedJobs: []

  getStaticClasses: ->
    block: "#{@BLOCK_CLASS}
      u-pb48"
    heroAreaWrap: 'u-mw1440
      u-mla u-mra'
    heroArea: 'u-pr
      u-h0
      u-ratio--1-1 u-ratio--3-2--600 u-ratio--2-1--900
      u-tac'
    heroImage: 'u-db u-w100p'
    heroCopyWrap: 'u-pa u-t0 u-b0 u-l0 u-r0
      u-df u-flexd--c u-ai--c u-jc--c'
    heroTitle: 'u-mt0 u-mb0
      u-pl60 u-pr60
      u-color--white
      u-fs30 u-fs40--600 u-fs45--900 u-ffs u-fws'
    heroSubtitle: 'u-w8c--600 u-w6c--900
      u-mla u-mra
      u-pl24 u-pr24
      u-color--white
      u-fs16 u-fs18--900 u-ffss'
    heroMarkdown: 'u-fs16 u-fs18--900 u-ffss'
    tabContainer: 'u-mw960
      u-mt30 u-mbn48 u-mla u-mra
      u-pl48--600 u-pr48--600 u-pl18--900 u-pr18--900
      u-tac'
    tab: "#{@BLOCK_CLASS}__tab
      u-pr
      u-dib
      u-mb3 u-ml9 u-mr9 u-ml18--600 u-mr18--600
      u-pb4
      u-color--dark-gray-alt-2
      u-fs16 u-fs18--900 u-ffss u-fws"
    tabActive: "#{@BLOCK_CLASS}__tab-active
      u-pr
      u-dib
      u-mb3 u-ml9 u-mr9 u-ml18--600 u-mr18--600
      u-pb2
      u-bw0 u-bbw2 u-bss
      u-color--dark-gray
      u-fs16 u-fs18--900 u-ffss u-fws"
    separator: 'u-reset
      u-mt18 u-mb36 u-ml12 u-mr12
      u-bc--light-gray
      u-btw1 u-bss'
    separatorWide: 'u-reset
      u-mt72 u-mb42 u-mb48--900
      u-bc--light-gray
      u-btw1 u-bss'
    featuredArea: 'u-mw960
      u-mla u-mra u-mbn12
      u-pl18 u-pr18 u-pl48--600 u-pr48--600 u-pl18--900 u-pr18--900'
    featuredTitle: 'u-mt0 u-mb12 u-mb24--900
      u-tac
      u-fs24 u-fs30--600 u-fs34--900 u-ffs u-fws'
    featuredJobs: 'u-df u-flexw--w u-ac--fs u-jc--c
      u-mb48'
    featuredJobWrap:'u-df
      u-w100p u-w6c--900
      u-mt30
      u-pl12--900 u-pr12--900'
    featuredJob: 'u-df u-flexd--c u-ai--c u-jc--c
      u-w100p
      u-pt30 u-pb30 u-pl30 u-pr30
      u-bw1 u-bss u-bc--light-gray
      u-color--dark-gray
      u-tac
      u-fs16 u-fs18--900'
    featuredJobTitle: 'u-db
      u-mb12
      u-fs18 u-fs20--900 u-ffss u-fws'
    featuredJobBlurb: 'u-db
      u-mb18
      u-fs16 u-fs18--900 u-ffss
      u-color--dark-gray-alt-3'
    featuredJobLink: "#{@BLOCK_CLASS}__featured-job-link
      u-pr
      u-pb5 u-pb7--900
      u-bbw2 u-bbw0--900 u-bbss u-bc--blue
      u-fws"
    allJobsArea: 'u-mw960
      u-mla u-mra
      u-pl18 u-pr18 u-pl48--600 u-pr48--600 u-pl18--900 u-pr18--900
      u-tac'
    allJobsTitle: 'u-mt42 u-mt54--900 u-mb12
      u-tac
      u-fs24 u-fs30--600 u-fs34--900 u-ffs u-fws'
    allJobsSubtitle: 'u-w9c--600 u-w8c--900
      u-mla u-mra u-mb60
      u-pl24 u-pr24
      u-tac
      u-color--dark-gray-alt-3
      u-fs16 u-fs18--900 u-ffss'
    group: 'u-tal'
    groupTitle: 'u-grid__col -c-6--600
      u-mt0
      u-fs18 u-fs20--900 u-ffss u-fws'
    groupJobs: 'u-grid__col u-w12c -c-6--600'
    jobLinkWrap: 'u-dt
      u-cl
      u-pr
      u-mb18
      u-pb2'
    jobLinkSubhead: 'u-dt
      u-cl
      u-pr
      u-mb4
      u-pb2
      u-fs16 u-fs18--900 u-ffss u-fws'
    jobLink: "#{@BLOCK_CLASS}__job-link
      u-color--blue
      u-bbw2 u-bbss u-bc--white
      u-fs16 u-fs18--900 u-ffss u-fws"
    jobLinkEmpty: 'u-dt
      u-cl
      u-mb24
      u-color--dark-gray-alt-2
      u-fs16 u-fs18--900 u-ffss'
    switcherArea: 'u-mt60 u-mb36 u-mla u-mra
      u-pl18 u-pr18 u-pl48--600 u-pr48--600 u-pl18--900 u-pr18--900
      u-tac'
    switcherImage: ''
    switcherTitle: 'u-w6c--600
      u-mt18 u-mb12 u-mla u-mra
      u-fs24 u-fs30--600 u-fs34--900 u-ffs u-fws'
    switcherSubtitle: 'u-w8c--600 u-w6c--900
      u-mla u-mra
      u-pl24 u-pr24
      u-color--dark-gray-alt-3
      u-fs16 u-fs18--900 u-ffss'
    switcherButton: 'u-dib
      u-button -button-white -button-medium
      u-mt30
      u-fs16 u-ffss u-fws'
    teamWarbyCallout: "#{@BLOCK_CLASS}__teamwarby
      u-db u-w12c u-pt48 u-pb48 u-mw1440 u-mla u-mra
      u-tac u-fs16 u-fs18--900 u-fws
      u-color-bg--light-gray-alt-2"
    teamWarbyLink: 'u-link--hover'

  getInitialState: ->
    expandDrawer: window?.location?.hash is '#teamwarby'

  componentDidUpdate: (prevProps, prevState) ->
    if prevState.expandDrawer is not @state.expandDrawer
      @scrollToNode React.findDOMNode(@refs.teamwarby),
        time: if @state.expandDrawer then 500 else 0

  handleClickTab: (subsection, evt) ->
    evt.preventDefault()
    @clickInteraction "subsection#{_.upperFirst _.camelCase(subsection)}", evt
    @commandDispatcher 'jobs', 'goToSubsection', subsection

  handleClickToggle: (evt) ->
    evt.preventDefault()
    @clickInteraction 'toggleSubsection', evt
    destSubsection = if @props.jobType is 'headquarters' then 'retail' else 'headquarters'
    @commandDispatcher 'jobs', 'goToSubsection', destSubsection

  handleClickJob: (jobName, evt) ->
    @clickInteraction "job#{_.upperFirst _.camelCase(jobName)}", evt

  handleClickFeaturedJob: (jobName, evt) ->
    @clickInteraction "featuredJob#{_.upperFirst _.camelCase(jobName)}", evt

  toggleTeamWarbyDrawer: (evt) ->
    evt.preventDefault()

    action = if @state.expandDrawer then 'close' else 'open'
    @clickInteraction "#{action}JobsDrawer", evt

    @setState expandDrawer: not @state.expandDrawer

  renderFeaturedJob: (classes, job, i) ->
    blurb = ''
    if @props.jobType is 'retail'
      locationName = _.get job, 'location.name'
      if locationName
        blurb = "Located in #{locationName}"
    else
      blurbData = _.find job.metadata, (md) -> _.kebabCase(md.name) is 'feature-blurb'
      if blurbData
        blurb = blurbData.value

    <div key="featured-job-#{i}" className=classes.featuredJobWrap>
      <div className=classes.featuredJob>
        <span className=classes.featuredJobTitle children=job.title />
        {if blurb
          <span className=classes.featuredJobBlurb children=blurb />
        }
        <a className=classes.featuredJobLink
          children='Apply'
          href=job.absolute_url
          target='_blank'
          onClick={@handleClickFeaturedJob.bind @, job.title}
        />
      </div>
    </div>

  renderHeroPicture: (images) ->
    widths = _.range 200, 1800, 200

    @getPictureChildren
      sources: [
        mediaQuery: '(min-width: 900px)'
        url: @getImageBySize(images, 'l')
        widths: widths
      ,
        mediaQuery: '(min-width: 600px)'
        url: @getImageBySize(images, 'm')
        widths: widths
      ,
        mediaQuery: '(min-width: 0px)'
        url: @getImageBySize(images, 's')
        widths: widths
      ]
      img:
        alt: 'Got your eyes on a new job?'
        className: @getClasses().heroImage

  renderJobs: (jobs) ->
    classes = @getClasses()
    <div className=classes.groupJobs>
      {if _.isEmpty(jobs)
        <span className=classes.jobLinkEmpty children='No open positions' />
      else
        labeledLocalities = {}
        _.map jobs, (job, i) =>
          preppedJob = <div key="job-#{i}" className=classes.jobLinkWrap>
            <a className=classes.jobLink
              href=job.absolute_url
              target='_blank'
              children=job.title
              onClick={@handleClickJob.bind @, job.title}
            />
          </div>

          if job.custom.locality and not labeledLocalities[job.custom.locality]
            labeledLocalities[job.custom.locality] = true
            [
              <div key="job-#{i}-locality"
                className=classes.jobLinkSubhead
                children=job.custom.locality />
            ,
              preppedJob
            ]
          else
            return preppedJob
      }
    </div>

  renderGroups: (groups) ->
    classes = @getClasses()
    groupComponents = _.map groups, (group, i) =>
      <div className=classes.group key="group-#{i}">
        <h3 className=classes.groupTitle children=group.name />
        {@renderJobs group.jobs}
      </div>
    _.map groupComponents, (group, i) ->
      [
        group
      ,
        <hr className=classes.separator key="group-separator-#{i}" />
      ]

  renderTab: (classes, jobType, i) ->
    <a key="tab-#{i}"
      className={if @props.jobType is jobType then classes.tabActive else classes.tab}
      href="/jobs/#{jobType}"
      onClick={@handleClickTab.bind @, jobType}
      children={_.get @props.content,
        "job_groups.#{@props.departmentData[jobType].name}.tab_title",
        ''}
    />

  render: ->
    classes = @getClasses()
    heroSectionData = _.get @props.content, 'hero_section', {}
    activeJobGroupData = _.get @props.content, "job_groups[#{@props.activeJobGroup}]", {}
    switcherJobGroupData = if @props.jobType is 'headquarters'
        _.get @props.content, 'job_groups.retail_stores', {}
      else
        _.get @props.content, 'job_groups.corporate', {}

    <div className=classes.block>

      <div className=classes.heroAreaWrap>
        <div className=classes.heroArea>
          <Picture children={@renderHeroPicture heroSectionData.hero_image}
            cssModifier=classes.heroImage
          />
          <div className=classes.heroCopyWrap>
            <h1 className=classes.heroTitle children=heroSectionData.hero_title />
            <Markdown className=classes.heroSubtitle
              cssBlock=classes.heroMarkdown
              rawMarkdown=heroSectionData.hero_subtitle
            />
          </div>
        </div>
      </div>

      <div className=classes.teamWarbyCallout ref='teamwarby' id='teamwarby'>
        <span children="What's it take to work here? " />
        <a className=classes.teamWarbyLink
          onClick=@toggleTeamWarbyDrawer children="We asked around." />
      </div>

      <TeamWarby
        isOpen=@state.expandDrawer
        handleClose=@toggleTeamWarbyDrawer />

      <div className=classes.tabContainer
        children={_.map @props.allJobTypes, @renderTab.bind(@, classes)}
      />

      {if not _.isEmpty(@props.featuredJobs)
        [
          <hr key='featuredAreaSeparator' className=classes.separatorWide />
        ,
          <div key='featuredArea' className=classes.featuredArea>
            <h2 className=classes.featuredTitle
              children=activeJobGroupData.featured_section_title
            />
            <div className=classes.featuredJobs
              children={_.map @props.featuredJobs, @renderFeaturedJob.bind(@, classes)}
            />
          </div>
        ]
      }

      <hr className=classes.separatorWide />

      <div className=classes.allJobsArea>
        <h2 className=classes.allJobsTitle
          children=activeJobGroupData.all_jobs_title
        />
        <div className=classes.allJobsSubtitle
          children=activeJobGroupData.all_jobs_subtitle
        />
        {@renderGroups @props.groupedJobs}
      </div>

      <div className=classes.switcherArea>
        <Img srcSet="#{switcherJobGroupData.switcher_image} 2x"
          sizes=@getImgSizes()
          cssModifier=classes.switcherImage
        />
        <h2 className=classes.switcherTitle
          children=switcherJobGroupData.switcher_title
        />
        <div className=classes.switcherSubtitle
          children=switcherJobGroupData.switcher_subtitle
        />
        <a className=classes.switcherButton
          href="/jobs/#{if @props.jobType is 'headquarters' then 'retail' else 'headquarters'}"
          children=switcherJobGroupData.switcher_button_text
          onClick=@handleClickToggle
        />
      </div>

    </div>
