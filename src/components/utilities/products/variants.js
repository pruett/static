const VARIANTS = {
  rx: "rx",
  rxPhoto: "rx_photo",
  progRx: "prog_rx",
  progRxPhoto: "prog_rx_photo",
};

const CHOICES = {
  rx: "rx",
  progRx: "prog_rx",
  clear: "clear",
  photo: "photo",
};

module.exports = {
  VARIANTS: VARIANTS,
  CHOICES: CHOICES,

  isProgRx: variant => {
    return [VARIANTS.progRx, VARIANTS.progRxPhoto].indexOf(variant) > -1;
  },

  isPhoto: variant => {
    return [VARIANTS.rxPhoto, VARIANTS.progRxPhoto].indexOf(variant) > -1;
  },

  getNextVariant: (prevVariant, nextVariant) => {
    switch (prevVariant) {
      case VARIANTS.progRxPhoto:
        return (
          {
            [CHOICES.rx]: VARIANTS.rxPhoto,
            [CHOICES.progRx]: VARIANTS.progRxPhoto,
            [CHOICES.clear]: VARIANTS.progRx,
            [CHOICES.photo]: VARIANTS.progRxPhoto,
          }[nextVariant] || prevVariant
        );
      case VARIANTS.rxPhoto:
        return (
          {
            [CHOICES.rx]: VARIANTS.rxPhoto,
            [CHOICES.progRx]: VARIANTS.progRxPhoto,
            [CHOICES.clear]: VARIANTS.rx,
            [CHOICES.photo]: VARIANTS.rxPhoto,
          }[nextVariant] || prevVariant
        );
      case VARIANTS.progRx:
        return (
          {
            [CHOICES.rx]: VARIANTS.rx,
            [CHOICES.progRx]: VARIANTS.progRx,
            [CHOICES.clear]: VARIANTS.progRx,
            [CHOICES.photo]: VARIANTS.progRxPhoto,
          }[nextVariant] || prevVariant
        );
      case VARIANTS.rx:
        return (
          {
            [CHOICES.rx]: VARIANTS.rx,
            [CHOICES.progRx]: VARIANTS.progRx,
            [CHOICES.clear]: VARIANTS.rx,
            [CHOICES.photo]: VARIANTS.rxPhoto,
          }[nextVariant] || prevVariant
        );
      default:
        return prevVariant;
    }
  },
};
