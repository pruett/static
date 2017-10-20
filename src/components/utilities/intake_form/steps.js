const { INPUT_TYPES, STEP_KEYS, YES_NO, STATE_LIST, YEAR_LIST, MONTH_LIST, DAY_LIST } = require("./constants");
const React = require("react/addons");

const STEPS = {
  START: {
    answerKey: "START",
    type: INPUT_TYPES.INPUT,
    next: () => cb => cb(STEPS.LAST_NAME),
    copy: {
      title: "What's your first name?",
    }
  },

  LAST_NAME: {
    answerKey: "LAST_NAME",
    type: INPUT_TYPES.INPUT,
    next: () => cb => cb(STEPS.DOB_MONTH),
    copy: {
      title: "What's your last name?"
    }
  },

  DOB_MONTH: {
    answerKey: "DOB_MONTH",
    type: INPUT_TYPES.CHOICE,
    copy: {
      title: "What's your birthday month?"
    },
    answers: MONTH_LIST,
    next: () => cb => cb(STEPS.DOB_DAY),
  },

  DOB_DAY: {
    answerKey: "DOB_DAY",
    type: INPUT_TYPES.CHOICE,
    copy: {
      title: "What's your birthday day?"
    },
    answers: DAY_LIST,
    next: () => cb => cb(STEPS.DOB_YEAR),
  },

  DOB_YEAR: {
    answerKey: "DOB_YEAR",
    type: INPUT_TYPES.CHOICE,
    copy: {
      title: "What's your birthday year?"
    },
    answers: YEAR_LIST,
    next: () => cb => cb(STEPS.ADDRESS_LINE_1),
  },

  ADDRESS_LINE_1: {
    answerKey: "ADDRESS_LINE_1",
    type: INPUT_TYPES.INPUT,
    copy: {
      title: "What's your address?"
    },
    next: () => cb => cb(STEPS.ADDRESS_LINE_2),
  },

  ADDRESS_LINE_2: {
    answerKey: "ADDRESS_LINE_2",
    type: INPUT_TYPES.INPUT,
    copy: {
      title: "What's your address line 2?"
    },
    next: () => cb => cb(STEPS.ADDRESS_CITY),
  },

  ADDRESS_CITY: {
    answerKey: "ADDRESS_CITY",
    type: INPUT_TYPES.INPUT,
    copy: {
      title: "What's your address city?"
    },
    next: () => cb => cb(STEPS.ADDRESS_STATE),
  },

  ADDRESS_STATE: {
    answerKey: "ADDRESS_STATE",
    type: INPUT_TYPES.CHOICE,
    answers: STATE_LIST,
    copy: {
      title: "What's your address state?"
    },
    next: () => cb => cb(STEPS.ADDRESS_ZIP),
  },

  ADDRESS_ZIP: {
    answerKey: "ADDRESS_ZIP",
    type: INPUT_TYPES.INPUT,
    copy: {
      title: "What's your address zip?"
    },
    next: () => cb => cb(STEPS.PHONE),
  },

  PHONE: {
    answerKey: "PHONE",
    type: INPUT_TYPES.INPUT,
    copy: {
      title: "What's your phone number?"
    },
    next: () => cb => cb(STEPS.EMAIL),
  },

  EMAIL: {
    answerKey: "EMAIL",
    type: INPUT_TYPES.INPUT,
    copy: {
      title: "What's your email?"
    },
    next: () => cb => cb(STEPS.SUCCESS),
  },

  SUCCESS: {
    type: INPUT_TYPES.SUCCESS
  },

};

module.exports = STEPS;
