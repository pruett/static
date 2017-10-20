[
  _
  React
] = [
  require 'lodash'
  require 'react/addons'

  require './history.scss'
]

module.exports = React.createClass

  shouldComponentUpdate: ->
    false

  render: ->
    <div id="c-history">
      <div className="history-page">
        <div className="container">
          <div className="os-title">
            <h2>History</h2><span className="bottom-border"></span>
          </div>
          <div className="content">
            <div className="copy">
              <h3><img className="left" src="/assets/img/legacy/our_story/history/mobile/dropcap-edit-mobile2x.png" alt="W"/>
                <span className='u-dn'>W</span>arby Parker was founded with a rebellious spirit and a lofty objective:
              to offer designer eyewear at a revolutionary price, while leading
              the way for socially conscious businesses.</h3>
              <p>Every idea starts with a problem. Ours was simple: glasses are
              too expensive. We were students when one of us lost his glasses on
              a backpacking trip. The cost of replacing them was so high that he
              spent the first semester of grad school without them, squinting and
              complaining. (We don’t recommend this.) The rest of us had similar
              experiences, and we were amazed at how hard it was to find a pair
              of great frames that didn’t leave our wallets bare. Where were the
              options?</p>
              <p>It turns out there was a simple explanation. The eyewear
              industry is dominated by a single company that has been able to
              keep prices artificially high while reaping huge profits from
              consumers who have no other options.</p>
              <p>We started Warby Parker to create an alternative.</p>
              <p>By circumventing traditional channels, designing glasses
              in-house, and engaging with customers directly, we’re able to
              provide higher-quality, better-looking prescription eyewear at a
              fraction of the going price.</p>
              <p>We believe that buying glasses should be easy and fun. It should
              leave you happy and good-looking, with money in your pocket.</p>
              <p>We also believe that everyone has the right to see.</p>
              <p>Almost one billion people worldwide lack access to glasses,
              which means that 15% of the world’s population cannot effectively
              learn or work. To help address this problem, Warby Parker partners
              with non-profits like VisionSpring to ensure that for every pair of
              glasses sold, a pair is distributed to someone in need.</p>
              <p>There’s nothing complicated about it. Good eyewear, good
              outcome.</p>
              <div className="blue-foot"><img src=
              "/assets/img/legacy/our_story/history/mobile/History-Glasses-New2x.png" /></div>
            </div>
          </div>
        </div>
      </div>
    </div>
