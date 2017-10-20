const React = require("react/addons");

const CLASSES = {
  heading: "u-reset u-ffs u-fs30 u-fs40--900 u-fws u-mb6 u-mb12--900",
  title: "u-reset u-ffss u-fs16 u-fs20--900 u-fws u-mb6",
  body: "u-reset u-ffss u-fs16 u-fs18--900 u-color--dark-gray-alt-3",
  grid: "u-grid -maxed u-tac u-ma",
  row: "u-grid__row",
  col: `u-grid__col u-w12c u-w5c--900  -col-middle`,
  img: `u-dib u-vam u-w5c`,
  address: `u-dib u-vam u-tal u-pl18 u-pr18 u-w7c`,
  header: `u-grid__col u-w12c u-mb48`,
  secondary: "u-grid__col -col-middle u-mw600 u-mt24",
  subtitle: "u-fws u-fs24 u-fs30--900 u-ffs u-mb24 u-w10c u-ma",
  list: "u-reset u-tal u-mb30 u-pl18 u-pr18",
  item: "u-reset u-color--dark-gray-alt-3 u-mb6 u-fs16 u-ffss",
  store: "u-bc--light-gray-alt-1 u-bw1 u-bss u-br4 u-mb24 u-mb60--900 u-oh",
  eyebrow:
    "u-db u-tac u-fs12 u-ffss u-ttu u-ls3 u-color--dark-gray-alt-2 u-fws u-mb24"
};

const Success = ({ rxCheckStores = [] }) => {
  return (
    <div className={CLASSES.grid}>
      <div className={CLASSES.row}>
        <header className={CLASSES.header}>
          <h1 className={CLASSES.heading}>Wahoo!</h1>
          <p className={CLASSES.body}>
            The doctor will see you shortly.
          </p>
        </header>
        {rxCheckStores.length > 0 && (
          <main>
            <h3 className={CLASSES.eyebrow}>Where to go</h3>
            {rxCheckStores.slice(0, 2).map((store, i) => {
              const info = store.info || {};
              const { address = {}, cms_content = {} } = info;

              return (
                <div className={CLASSES.col} key={i}>
                  <div className={CLASSES.store}>
                    <img src={cms_content.card_photo} className={CLASSES.img} />
                    <div className={CLASSES.address}>
                      <a href={`/retail/${info.city_slug}/${info.location_slug}`}>
                        <h1 className={CLASSES.title}>{info.name}</h1>
                      </a>
                      <p className={CLASSES.body}>
                        {address.street_address}
                        <br />
                        {address.locality}, {address.region_code} {address.postal_code}
                      </p>
                    </div>
                  </div>
                </div>
              );
            })}
          </main>
        )}
      </div>
    </div>
  );
};

module.exports = Success;
