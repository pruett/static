[
  _
  React
] = [
  require 'lodash'
  require 'react/addons'

  require './culture.scss'
]

module.exports = React.createClass

  shouldComponentUpdate: ->
    false

  handleClick: (evt) ->
    founder = evt.currentTarget.getAttribute('data-founder')
    document.querySelector("#founders-copy-cntr").classList.add('on')
    document.querySelector(".founders-toggles").classList.add('on')

    for el in document.querySelectorAll(".founder, .founders-copy, .dot")
      if el.getAttribute('data-founder') is founder
        el.classList.add('selected')
      else
        el.classList.remove('selected')

  handleClose: ->
    document.querySelector("#founders-copy-cntr").classList.remove('on')
    document.querySelector(".founders-toggles").classList.remove('on')

  render: ->
    <div id="c-culture" className="c-culture">
      <div id="founders-copy-cntr" data-founder="" className="founders-copy-cntr">
        <div className="founders-copy-all">
          <div data-founder="neil" className="founders-copy">
            <button href="#" className="close" onClick=@handleClose><img src="/assets/img/legacy/our_story/culture/mobile/founders/x.png?v=eef73a6e3fe10ebb8edddb7fa47663ce" /></button>
            <h3 className="name">Neil Blumenthal</h3>
            <div className="copy">
              <p>As the former director of non-profit VisionSpring, Neil spent the better part of five years distributing glasses to people living on less than $4 per day. A native of New York City, Neil is a Leo and enjoys long walks in the park. With Dave, he is co-CEO of Warby Parker.</p>
            </div>
            <div className="facts">
              <div className="fact">
                <h6>Karaoke pick</h6>
                <p>Hall and Oates, “Maneater”</p>
              </div>
              <div className="fact">
                <h6>Happy place</h6>
                <p>On a beach in the Galápagos, surrounded by blue-footed boobies.</p>
              </div>
            </div>
          </div>
          <div data-founder="dave" className="founders-copy">
            <button href="#" className="close" onClick=@handleClose><img src="/assets/img/legacy/our_story/culture/mobile/founders/x.png?v=eef73a6e3fe10ebb8edddb7fa47663ce" /></button>
            <h3 className="name">Dave Gilboa</h3>
            <div className="copy">
              <p>Like a Viking from his native Sweden, Dave spends his free time seeking adventure. Two recent conquests include trekking across Antarctica and becoming the fastest person ever to run a marathon in a flamingo costume. With Neil, he is co-CEO of Warby Parker.</p>
            </div>
            <div className="facts">
              <div className="fact">
                <h6>Karaoke pick</h6>
                <p>Lionel Richie, “Lady”</p>
              </div>
              <div className="fact">
                <h6>Happy place</h6>
                <p>In any ocean, but preferably Del Mar.</p>
              </div>
            </div>
          </div>
          <div data-founder="andy" className="founders-copy">
            <button href="#" className="close" onClick=@handleClose><img src="/assets/img/legacy/our_story/culture/mobile/founders/x.png?v=eef73a6e3fe10ebb8edddb7fa47663ce" /></button>
            <h3 className="name">Andy Hunt</h3>
            <div className="copy">
              <p>Andy has studied eyewear design in more than 40 countries. Rumors that he conceived the idea for Warby Parker at a temple in the jungle city of Angkor Wat remain unsubstantiated but plausible. Andy is currently continuing the adventure at Highland Capital Partners.</p>
            </div>
            <div className="facts">
              <div className="fact">
                <h6>Karaoke pick</h6>
                <p>The Rolling Stones, “Satisfaction”</p>
              </div>
              <div className="fact">
                <h6>Happy place</h6>
                <p>Any beach that requires a passport stamp.</p>
              </div>
            </div>
          </div>
          <div data-founder="jeff" className="founders-copy">
            <button href="#" className="close" onClick=@handleClose><img src="/assets/img/legacy/our_story/culture/mobile/founders/x.png?v=eef73a6e3fe10ebb8edddb7fa47663ce" /></button>
            <h3 className="name">Jeff Raider</h3>
            <div className="copy">
              <p>A bespectacled man for life, Jeff wanted to start Warby Parker because he couldn’t find any frames on the market that fit his quirky yet impeccable taste. Because his passion for glasses is matched only by his enthusiasm for a baby’s-bottom-caliber shave, Jeff went on to co-found Harry’s.</p>
            </div>
            <div className="facts">
              <div className="fact">
                <h6>Karaoke pick</h6>
                <p>“Monster Mash”</p>
              </div>
              <div className="fact">
                <h6>Happy place</h6>
                <p>Building elaborate sandcastles with wife and kids.</p>
              </div>
            </div>
          </div>
        </div>
        <div className="founders-copy-pager">
          <a href="#" className="previous-founder arrow"></a>
          <div className="dots">
            <button href="#" className="founder dot" data-founder='neil' onClick=@handleClick></button>
            <button href="#" className="founder dot" data-founder='dave' onClick=@handleClick></button>
            <button href="#" className="founder dot" data-founder='andy' onClick=@handleClick></button>
            <button href="#" className="founder dot" data-founder='jeff' onClick=@handleClick></button></div>
          <a href="#" className="next-founder arrow"></a>
        </div>
      </div>
      <div id="page" className="culture-page do-good-page">
        <div className="container">
          <div className="os-title">
            <h2>Culture</h2>
            <span className="bottom-border"></span>
          </div>
          <div className="content">
            <section className="ground-rules">
              <h2 className="large">We have a couple<br /> of ground rules at<br /> Warby Parker.<span className="asterisk">*</span></h2>
              <p className="disclaimer"><span>*</span>Nothing crazy.</p>
              <div className="rules">
                <div className="rule">
                  <div className="icon"><img src="/assets/img/legacy/our_story/culture/mobile/stakeholder-icons/Customer-Mobile2x.jpg?v=b6a143b1bd362725dfa725d0ae78037b"/></div>
                  <div className="copy">
                    <div className="num"><img src="/assets/img/legacy/our_story/numbers/01.png?v=9f3216911f24ebd48cf1966ee2406c39"/></div>
                    <h3>Treat customers the way we’d like to be treated.</h3>
                    <p>They don’t call it the golden rule for nothing. Shopping for glasses should be fun, easy, and not ridiculously expensive.</p>
                  </div>
                </div>
                <div className="rule">
                  <div className="icon"><img src="/assets/img/legacy/our_story/culture/mobile/stakeholder-icons/Employees-Mobile2x.jpg?v=3059098fea3b5a1bfdb6309afd5adbf2"/></div>
                  <div className="copy">
                    <div className="num"><img src="/assets/img/legacy/our_story/numbers/02.png?v=72d760a873b0963c04fdf818da036cfc"/></div>
                    <h3>Create an environment where employees can think big, have fun, and do good.</h3>
                    <p>Sometimes people say to us: “If you love your job so much, why don’t you marry it?” (Answer: we would if we could.)</p>
                  </div>
                </div>
                <div className="rule">
                  <div className="icon"><img src="/assets/img/legacy/our_story/culture/mobile/stakeholder-icons/Community-Mobile2x.jpg?v=bb0d347b850cb7e43b49dc434092e239"/></div>
                  <div className="copy">
                    <div className="num"><img src="/assets/img/legacy/our_story/numbers/03.png?v=b3d523c252ce5493d168ad52014d3018"/></div>
                    <h3>Get out there.</h3>
                    <p>No company is an island. Serving the community is in our DNA—from distributing a pair of frames for every pair sold to sponsoring local Little League teams (Go Giants! Go Skyscrapers!). We also work with&nbsp;<a href="http://www.verite.org/" target="_blank">Verité</a>&nbsp;to ensure that our factories have fair working conditions and happy employees.</p>
                  </div>
                </div>
                <div className="rule">
                  <div className="icon"><img src="/assets/img/legacy/our_story/culture/mobile/stakeholder-icons/Environment-Mobile2x.jpg?v=28e667f8026689b077a93feda5d71a20"/></div>
                  <div className="copy">
                    <div className="num"><img src="/assets/img/legacy/our_story/numbers/04.png?v=fda3cb5830c797026f071c9f34c61297"/></div>
                    <h3>Green is good.</h3>
                    <p>Warby Parker is one of the only carbon-neutral eyewear brands in the world.</p>
                  </div>
                </div>
              </div>
            </section>
            <section className="sigil-cntr">
              <img src="/assets/img/legacy/our_story/culture/mobile/Sigil-mobile2x.png?v=0e4b75248d77c6fde2ba933d66641741"/>
              <h3>Our customers, employees, community and environment are our stakeholders. We consider them in every decision that we make.</h3>
            </section>
            <section className="faq-cntr">
              <h2 className="large">Got questions?<br /> Here maybe we can answer ’em.</h2>
              <div className="question-answer first-question">
                <h4 className="question">Where does the name “Warby Parker” come from?</h4>
                <img src="/assets/img/legacy/our_story/culture/mobile/Stork-mobile2x.png?v=9a7cad0cf201993725641fb26666ca3e" className="the-stork" />
                <p>The stork. (Just kidding.)</p>
                <p>In May 2009, our co-founder Dave was wandering around the New York Public Library when he stumbled into an exhibition about Jack Kerouac. The four of us had long been inspired by Kerouac, who spurred a generation to take the road less traveled.</p>
                <p>The exhibit included some of Kerouac’s manuscripts, drafts, and journals. In one of the journals, Dave noticed two characters with interesting names: Warby Pepper and Zagg Parker. We  combined the two and came up with Warby Parker.</p>
              </div>
              <div className="question-answer book-question">
                <img src="/assets/img/legacy/our_story/culture/mobile/BooksMobile2x.png?v=05b9febf7b36b3544a58bacbaf83b370" />
                <h4>So your name comes from a book, huh. Will you recommend a book for me to read?</h4>
                <p>Sure! Jack Kerouac’s <i>Dharma Bums</i> is one of our favorites. (Employees get a copy on their first day, as part of our standard secret initiation rites.) If you like adventure, try <i>A High Wind in Jamaica</i> by Richard Hughes. If you’re the nonfiction type, John Jeremiah Sullivan’s <i>Pulphead</i> will knock you flat. (In a good way.)</p>
                <p>If you’re a fast reader and want more recommendations, our&nbsp;<a href="/retail">retail</a>&nbsp;stores are stocked with excellent books.</p>
              </div>
              <div className="question-answer">
                <h4 className="question">How is it possible to sell high-quality prescription glasses for $95?</h4>
                <p>Most high-end brands do not produce their own eyewear. Instead, they sell those rights to massive companies who design, manufacture, and sell branded glasses directly to optical shops. Those optical shops tack on additional mark-ups to frames and lenses before selling them to you.</p>
                <p>We cut out the middleman by designing and producing our own eyewear, then passing on the savings to customers. We effectively sell glasses wholesale (because it makes no sense for customers to pay for multiple mark-ups).</p>
              </div>
              <div className="question-answer">
                <h4 className="question">Who started Warby Parker?</h4>
                <p>Meet our founding fathers.</p>
                <div className="founders-toggles">
                  <button href="#" data-founder="neil" className="founder founder-neil" onClick=@handleClick>
                    <div className="img-cntr"><img src="/assets/img/legacy/our_story/culture/mobile/founders/Neil2x-mobile.png?v=e9ba79ce78485e4875de01f7db9b813a"/></div>
                    <span className="name">Neil Blumenthal</span><span className="more">More<img src="/assets/img/legacy/our_story/culture/mobile/Culture-mobile_plus-sign.png?v=32432fc45656751d0a7264c97ea1eb1e" className="plus"/></span>
                  </button>
                  <button href="#" data-founder="dave" className="founder founder-dave" onClick=@handleClick>
                    <div className="img-cntr"><img src="/assets/img/legacy/our_story/culture/mobile/founders/Dave2x-mobile.png?v=823371141f57f395ac98f45301b027f5"/></div>
                    <span className="name">Dave Gilboa</span><span className="more">More<img src="/assets/img/legacy/our_story/culture/mobile/Culture-mobile_plus-sign.png?v=32432fc45656751d0a7264c97ea1eb1e" className="plus"/></span>
                  </button>
                  <button href="#" data-founder="andy" className="founder founder-andy" onClick=@handleClick>
                    <div className="img-cntr"><img src="/assets/img/legacy/our_story/culture/mobile/founders/Andy2x-mobile.png?v=fade8cf74b0b9fbbeab07d7f0f53be4c"/></div>
                    <span className="name">Andy Hunt</span><span className="more">More<img src="/assets/img/legacy/our_story/culture/mobile/Culture-mobile_plus-sign.png?v=32432fc45656751d0a7264c97ea1eb1e" className="plus"/></span>
                  </button>
                  <button href="#" data-founder="jeff" className="founder founder-jeff" onClick=@handleClick>
                    <div className="img-cntr"><img src="/assets/img/legacy/our_story/culture/mobile/founders/Jeff2x-mobile.png?v=c78fb52f9dae5b2a1c812fd7fd683d1a"/></div>
                    <span className="name">Jeff Raider</span><span className="more">More<img src="/assets/img/legacy/our_story/culture/mobile/Culture-mobile_plus-sign.png?v=32432fc45656751d0a7264c97ea1eb1e" className="plus"/></span>
                  </button>
                </div>
              </div>
              <div className="question-answer padded-right">
                <h4 className="question">Why do you distribute glasses to people in need?</h4>
                <p>When we started the company, we had two goals:</p>
                <ol>
                  <li>Offer an alternative to the overpriced and underwhelming eyewear that was available to us.</li>
                  <li>Build a business that could solve problems instead of creating them.</li>
                </ol>
                <p className="hanging">In our efforts to fulfill requirement #2, we work with nonprofits to train individuals across the globe to give basic eye exams and bring glasses to their communities. You can get a step-by-step breakdown of the process&nbsp;<a href="/buy-a-pair-give-a-pair">here.</a></p>
              </div>
              <div className="question-answer">
                <h4 className="question">How do you calculate the impact of your Buy a Pair, Give a Pair program?</h4>
                <p>Excellent question. One of our main sources is the World Health Organization, an agency of the United Nations that focuses on public health worldwide. If you’re interested in exploring the topic of vision impairment,&nbsp;<a href="http://www.who.int/bulletin/volumes/90/10/12-104034/en/" target="_blank">here’s a paper</a>&nbsp;that goes into great depth on the subject (put on your thinking cap!). Another great resource is the website of one of our primary partners,&nbsp;<a href="http://visionspring.org/" target="_blank">VisionSpring</a>. There you can find more stats, stories, and research.</p>
              </div>
              <div className="question-answer padded-right">
                <h4 className="question">I read that Warby Parker is a<br className="portrait-only"/> “B Corporation”. What does that mean? Does the “B” stand for “bagpipe”?</h4>
                <p>Excellent guess, but no. A “B Corporation” is a company that has been independently evaluated by B Lab (a pioneering non-profit) and found to meet the highest standards of social and environmental performance, accountability, and transparency. For the full rundown on how we’re performing, read our most recent&nbsp;<a href="http://www.bcorporation.net/community/warby-parker" target="_blank">report card.</a>&nbsp;For bagpipes,&nbsp;<a href="https://www.youtube.com/watch?v=PSH0eRKq1lE" target="_blank">step this way.</a></p>
              </div>
            </section>
            <div className="culture-touts">
              <a href="/jobs" className="culture-tout culture-tout-1">
                <div className="img-cntr"><img src="/assets/img/legacy/our_story/culture/mobile/Clipboard-mobile-2x.png?v=065204c7923587e58ca69a27e9c4dea9"/></div>
                <div className="copy-cntr">
                  <div className="copy">
                    <h3>I want to work for Warby Parker. Where do I sign up?</h3>
                    <p>Well, that makes our day. Head over to the <strong>jobs page</strong> to learn about openings.</p>
                  </div>
                </div>
              </a>
              <a href="/monocle" className="culture-tout culture-tout-2">
                <div className="img-cntr"><img src="/assets/img/legacy/our_story/culture/mobile/MonocleForSale-mobile2x-145x130.png?v=3822dae42ee0d688bdea2486daf134b3"/></div>
                <div className="copy-cntr">
                  <div className="copy">
                    <h3>Do you really sell a monocle?</h3>
                    <p><strong>Yes.</strong> Yes we do.</p>
                  </div>
                </div>
              </a>
            </div>
          </div>
        </div>
      </div>
    </div>
