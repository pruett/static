const React = require("react/addons");

const Step = ({ children, onClick, isActive }) => {
  const classActive = isActive
    ? "u-bc--dark-gray u-bbw2 u-bbss"
    : "u-color--dark-gray-alt-2";

  return (
    <li className="u-dib u-mr18 u-mr24--600 u-mw75p">
      <button
        className={`c-atc__step u-reset--button u-fws u-ffss u-pb3 u-tal u-lh20 ${classActive}`}
        onClick={onClick}
        children={children}
      />
    </li>
  );
};

Step.propTypes = {
  children: React.PropTypes.any,
  onClick: React.PropTypes.func,
  isActive: React.PropTypes.bool
};

module.exports = Step;
