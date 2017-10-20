module.exports = {
  LENS_DETAILS: [
    {
      label: "prescription_offerings",
      header: "Prescription options",
      borderBottom: true,
      flip: false,
      cssModifierTransition: "-transition-fast",
      choices: [
        {
          text: "SINGLE-VISION",
          key: "rx",
          variants: ["rx", "rx_photo"],
          bulletPoints: [
            "Corrects one field of vision (distance or reading)—and is the option most people choose",
            "Includes standard polycarbonate lenses—the most impact-resistant material for eyeglasses",
            "Also choose this option if you would like reading or non-prescription glasses",
          ],
        },
        {
          text: "PROGRESSIVE",
          key: "prog_rx",
          variants: ["prog_rx", "prog_rx_photo"],
          bulletPoints: [
            "Offers multiple corrections in one lens: distance, computer, and reading—so you don’t have to switch between multiple pairs",
            "If there is an \"ADD\" value on your prescription, you’re eligible for progressives",
            "Includes standard polycarbonate lenses—the most impact-resistant material for eyeglasses",
          ],
        },
      ],
    },
    {
      label: "lens_offerings",
      header: "Lens offerings",
      borderBottom: false,
      flip: true,
      cssModifierTransition: "c-product-lens-details__fade-in",
      choices: [
        {
          text: "CLEAR (STANDARD)",
          key: "clear",
          variants: ["rx", "prog_rx"],
          bulletPoints: [
            "Made from thin, light, impact-resistant polycarbonate",
            "Includes superhydrophobic, anti-reflective coating and scratch-resistant treatment",
            "Offers 100% UV protection",
          ],
        },
        {
          text: "LIGHT-RESPONSIVE",
          key: "photo",
          variants: ["rx_photo", "prog_rx_photo"],
          bulletPoints: [
            "Upon UV exposure, lenses immediately start changing from clear to dark grey",
            "Includes superhydrophobic, anti-reflective coating and scratch-resistant treatment",
            "Offers 100% UV protection",
            "Add to any eyeglasses for + $100",
          ],
        },
      ],
    },
  ],

  DISPLAY_SHAPE_LOOKUP: {
    lens_offerings: {
      square: [
        [
          {
            size: "mobile",
            image:
              "https://i.warbycdn.com/v/c/assets/photochromics-pdp/image/square-clear-mobile/0/9d141fa66a.jpg",
          },
          {
            size: "tablet",
            image:
              "https://i.warbycdn.com/v/c/assets/photochromics-pdp/image/square-clear-tablet/0/093ef60234.jpg",
          },
          {
            size: "desktop-sd",
            image:
              "https://i.warbycdn.com/v/c/assets/photochromics-pdp/image/square-clear-desktop/0/77e400561f.jpg",
          },
        ],
        [
          {
            size: "mobile",
            image:
              "https://i.warbycdn.com/v/c/assets/photochromics-pdp/image/square-transitioned-mobile/0/bece7887af.jpg",
          },
          {
            size: "tablet",
            image:
              "https://i.warbycdn.com/v/c/assets/photochromics-pdp/image/square-transitioned-tablet/0/ab6edaaed4.jpg",
          },
          {
            size: "desktop-sd",
            image:
              "https://i.warbycdn.com/v/c/assets/photochromics-pdp/image/square-transitioned-desktop/0/44ffdc7c6b.jpg",
          },
        ],
      ],
      rectangle: [
        [
          {
            size: "mobile",
            image:
              "https://i.warbycdn.com/v/c/assets/photochromics-pdp/image/rectangle-clear-mobile/0/4aba5c270b.jpg",
          },
          {
            size: "tablet",
            image:
              "https://i.warbycdn.com/v/c/assets/photochromics-pdp/image/rectangle-clear-tablet/1/80259f6348.jpg",
          },
          {
            size: "desktop-sd",
            image:
              "https://i.warbycdn.com/v/c/assets/photochromics-pdp/image/rectangle-clear-desktop/0/289367d1ec.jpg",
          },
        ],
        [
          {
            size: "mobile",
            image:
              "https://i.warbycdn.com/v/c/assets/photochromics-pdp/image/rectangle-transitioned-mobile/0/5525e49e1e.jpg",
          },
          {
            size: "tablet",
            image:
              "https://i.warbycdn.com/v/c/assets/photochromics-pdp/image/rectangle-transitioned-tablet/0/2db9371703.jpg",
          },
          {
            size: "desktop-sd",
            image:
              "https://i.warbycdn.com/v/c/assets/photochromics-pdp/image/rectangle-transitioned-desktop/0/5fde6e1f9c.jpg",
          },
        ],
      ],
      catEye: [
        [
          {
            size: "mobile",
            image:
              "https://i.warbycdn.com/v/c/assets/photochromics-pdp/image/cat-eye-clear-mobile/0/01388ba359.jpg",
          },
          {
            size: "tablet",
            image:
              "https://i.warbycdn.com/v/c/assets/photochromics-pdp/image/cat-eye-clear-tablet/0/fa23180f76.jpg",
          },
          {
            size: "desktop-sd",
            image:
              "https://i.warbycdn.com/v/c/assets/photochromics-pdp/image/cat-eye-clear-desktop/0/5c88813d3c.jpg",
          },
        ],
        [
          {
            size: "mobile",
            image:
              "https://i.warbycdn.com/v/c/assets/photochromics-pdp/image/cat-eye-transitioned-mobile/0/2b701ca7ae.jpg",
          },
          {
            size: "tablet",
            image:
              "https://i.warbycdn.com/v/c/assets/photochromics-pdp/image/cat-eye-transitioned-tablet/0/c41b6ce25e.jpg",
          },
          {
            size: "desktop-sd",
            image:
              "https://i.warbycdn.com/v/c/assets/photochromics-pdp/image/cat-eye-transitioned-desktop/0/2a993f755a.jpg",
          },
        ],
      ],
      round: [
        [
          {
            size: "mobile",
            image:
              "https://i.warbycdn.com/v/c/assets/photochromics-pdp/image/clear-mobile/0/f95455785c.jpg",
          },
          {
            size: "tablet",
            image:
              "https://i.warbycdn.com/v/c/assets/photochromics-pdp/image/clear-tablet/0/ca51785780.jpg",
          },
          {
            size: "desktop-sd",
            image:
              "https://i.warbycdn.com/v/c/assets/photochromics-pdp/image/clear-desktop/0/c6f6d4d57a.jpg",
          },
        ],
        [
          {
            size: "mobile",
            image:
              "https://i.warbycdn.com/v/c/assets/photochromics-pdp/image/transitioned-mobile/0/dbcccdf43e.jpg",
          },
          {
            size: "tablet",
            image:
              "https://i.warbycdn.com/v/c/assets/photochromics-pdp/image/transitioned-tablet/0/dcec397537.jpg",
          },
          {
            size: "desktop-sd",
            image:
              "https://i.warbycdn.com/v/c/assets/photochromics-pdp/image/transitioned-desktop/0/f3768dc794.jpg",
          },
        ],
      ],
    },
    prescription_offerings: {
      square: [
        [
          {
            size: "mobile",
            image:
              "https://i.warbycdn.com/v/c/assets/photochromics-pdp/image/square-single-vision-mobile/0/c082c43e66.jpg",
          },
          {
            size: "tablet",
            image:
              "https://i.warbycdn.com/v/c/assets/photochromics-pdp/image/square-single-vision-tablet/0/36aec3ca71.jpg",
          },
          {
            size: "desktop-sd",
            image:
              "https://i.warbycdn.com/v/c/assets/photochromics-pdp/image/square-single-vision-desktop/0/2afb472aae.jpg",
          },
        ],
        [
          {
            size: "mobile",
            image:
              "https://i.warbycdn.com/v/c/assets/photochromics-pdp/image/square-progressives-mobile/0/195c76d954.jpg",
          },
          {
            size: "tablet",
            image:
              "https://i.warbycdn.com/v/c/assets/photochromics-pdp/image/square-progressives-tablet/0/62c5493e67.jpg",
          },
          {
            size: "desktop-sd",
            image:
              "https://i.warbycdn.com/v/c/assets/photochromics-pdp/image/square-progressives-desktop/0/812a7ede34.jpg",
          },
        ],
      ],
      rectangle: [
        [
          {
            size: "mobile",
            image:
              "https://i.warbycdn.com/v/c/assets/photochromics-pdp/image/rectangle-single-vision-mobile/0/c2db46b3f0.jpg",
          },
          {
            size: "tablet",
            image:
              "https://i.warbycdn.com/v/c/assets/photochromics-pdp/image/rectangle-single-vision-tablet/0/b1f999ccba.jpg",
          },
          {
            size: "desktop-sd",
            image:
              "https://i.warbycdn.com/v/c/assets/photochromics-pdp/image/rectangle-single-vision-desktop/0/4d70930eee.jpg",
          },
        ],
        [
          {
            size: "mobile",
            image:
              "https://i.warbycdn.com/v/c/assets/photochromics-pdp/image/rectangle-progressive-mobile/0/1716487079.jpg",
          },
          {
            size: "tablet",
            image:
              "https://i.warbycdn.com/v/c/assets/photochromics-pdp/image/rectangle-progressive-tablet/0/246013b462.jpg",
          },
          {
            size: "desktop-sd",
            image:
              "https://i.warbycdn.com/v/c/assets/photochromics-pdp/image/rectangle-progressive-desktop/0/e6d03a7bf6.jpg",
          },
        ],
      ],
      catEye: [
        [
          {
            size: "mobile",
            image:
              "https://i.warbycdn.com/v/c/assets/photochromics-pdp/image/cat-eye-single-vision-mobile/0/355b34d2b6.jpg",
          },
          {
            size: "tablet",
            image:
              "https://i.warbycdn.com/v/c/assets/photochromics-pdp/image/cat-eye-single-vision-tablet/0/f4942a2f6a.jpg",
          },
          {
            size: "desktop-sd",
            image:
              "https://i.warbycdn.com/v/c/assets/photochromics-pdp/image/cat-eye-single-vision-desktop/0/7924dc45d5.jpg",
          },
        ],
        [
          {
            size: "mobile",
            image:
              "https://i.warbycdn.com/v/c/assets/photochromics-pdp/image/cat-eye-progressives-mobile/0/0845f880e0.jpg",
          },
          {
            size: "tablet",
            image:
              "https://i.warbycdn.com/v/c/assets/photochromics-pdp/image/cat-eye-progressives-tablet/0/0289e4093e.jpg",
          },
          {
            size: "desktop-sd",
            image:
              "https://i.warbycdn.com/v/c/assets/photochromics-pdp/image/cat-eye-progressives-desktop/0/9c92dc9540.jpg",
          },
        ],
      ],
      round: [
        [
          {
            size: "mobile",
            image:
              "https://i.warbycdn.com/v/c/assets/photochromics-pdp/image/round-single-vision-mobile/0/fa356467be.jpg",
          },
          {
            size: "tablet",
            image:
              "https://i.warbycdn.com/v/c/assets/photochromics-pdp/image/round-single-vision-tablet/0/e8cb98df07.jpg",
          },
          {
            size: "desktop-sd",
            image:
              "https://i.warbycdn.com/v/c/assets/photochromics-pdp/image/round-single-vision-desktop/0/1179c74748.jpg",
          },
        ],
        [
          {
            size: "mobile",
            image:
              "https://i.warbycdn.com/v/c/assets/photochromics-pdp/image/round-progressives-mobile/0/9471d827ff.jpg",
          },
          {
            size: "tablet",
            image:
              "https://i.warbycdn.com/v/c/assets/photochromics-pdp/image/round-progressives-tablet/0/e5893d1d41.jpg",
          },
          {
            size: "desktop-sd",
            image:
              "https://i.warbycdn.com/v/c/assets/photochromics-pdp/image/round-progressives-desktop/0/fdce551047.jpg",
          },
        ],
      ],
    },
  },

  ID_TO_SHAPE_STRING_LOOKUP: {
    2600: "catEye",
    1365: "rectangle",
    1366: "round",
    1367: "square",
  },

  FRAME_SHAPE_CONSTANTS: {
    // These represent possible frame shape combinations returned by the API.
    ROUND_SQUARE: [1366, 1367],
    SQUARE_RECTANGLE: [1367, 1365],
    ROUND_RECTANGLE: [1366, 1365],
  },
};
