[
  _
  React

] = [
  require 'lodash'
  require 'react/addons'

  require './design.scss'
]

TypeKit = require 'components/atoms/scripts/typekit/typekit'

module.exports = React.createClass

  shouldComponentUpdate: ->
    false

  render: ->
    <div id="c-design">
      <TypeKit typeKitModifier='jsl1ymy' />
      <div id="page" className="design-page do-good-page">
        <div className="container">
          <div className="os-title">
            <h2>Design</h2>
            <span className="bottom-border"></span>
          </div>

          <h2 className="large">How your frames
          are made</h2>

          <h3 className="subtitle">Building a better pair</h3>

          <div className="photo-bridge"><img width="100%" src=
          "/assets/img/legacy/our_story/design/mobile/photo-bridge-2x.jpg?v=3e63d29247a87d79711352ff3c51c1ff" /></div>

          <div className="content">
            <div className="section">
              <h3>Inspiration</h3>

              <p>Our in-house design team gathers inspiration from around the globe.</p>
            </div>

            <div className="section">
            <h3>Perspiration</h3>

            <p>Each frame is designed in-house from initial sketch to prototype testing to
            final design.</p><img src=
            "/assets/img/legacy/our_story/design/mobile/perspiration-2x.png?v=dfb202f19d3178ab20f607b2ae0eda97"
            className="perspiration-section-img" /></div>

            <div className="section">
            <h3>Innovation</h3>

            <p>Our designers cook up custom pattern variations and features, like our
            never-before-seen triple-gradient lenses.</p><img src=
            "/assets/img/legacy/our_story/design/mobile/innovation-2x.jpg?v=a128f286a798777f9f9f2fdf59ccbae5"
            className="innovation-section-img" /></div>

            <div className="section">
            <h3>Materials&nbsp;<span className='small'>(only the good stuff)</span></h3>

            <p>From ultra-lightweight titanium to custom single-sheet cellulose acetate sourced from a family-run Italian factory, we only use premium materials for our frames.</p><img src=
            "/assets/img/legacy/our_story/design/mobile/materials-2x.jpg?v=38518ff194aaf24d233d17736a9e8695"
            className="materials-section-img" /></div>

            <div className="section">
              <h3>Sightseeing</h3>

              <p>Our lenses are impact-resistant and UV 400 protected. All optical lenses
              include super hydrophobic anti-reflective and anti-scratch coatings.</p>
            </div>

            <div className="section">
            <h3>Construction work</h3>

            <p>Acetate frames are hand-polished and tumbled for at least three days. An
            imported German polishing wax compound helps us achieve the highest
            shine.</p><img src=
            "/assets/img/legacy/our_story/design/mobile/construction-2x.jpg?v=df4b13e6378482a4b4bd8e84eb4dc68f" /></div>

            <div className="section">
              <h3>Off they go!</h3>

              <p>All frames are inspected at least twice before finding their way to
              you.</p>
            </div>
          </div>
        </div>
      </div>
    </div>
