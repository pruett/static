const REJECTIONS = require("./rejections");
const { INPUT_TYPES, STEP_KEYS, YES_NO } = require("./constants");
const React = require("react/addons");

const reject = body => ({
  type: INPUT_TYPES.REJECT,
  copy: { body }
});

const STEPS = {
  START: {
    answerKey: "START",
    type: INPUT_TYPES.CHOICE,
    answers: ["Get started"],
    next: () => cb => cb(STEPS.ZIP_CODE),
    copy: {
      title: "Wanna see if you’re eligible?",
      body: `Before you come by, find out if the In-store Prescription Check service is right \
        for you. All you have to do is answer a few quick questions.`
    }
  },

  ZIP_CODE: {
    answerKey: "ZIP_CODE",
    type: INPUT_TYPES.INPUT,
    next: val => cb => cb(!!val.length ? STEPS.AGE : STEPS.REJECTION_AGE),
    placeholder: "ZIP code",
    copy: {
      title: "Enter your ZIP code"
    }
  },

  AGE: {
    answerKey: "AGE",
    type: INPUT_TYPES.INPUT,
    placeholder: "(In years, please.)",
    copy: {
      title: "How old are you?"
    },
    next: val => cb => {
      const age = parseInt(val);
      if (isNaN(age) || age < 18 || age > 50) {
        return cb(STEPS.REJECTION_AGE);
      } else if (age <= 40) {
        return cb(STEPS.EYEGLASSES);
      } else {
        return cb(STEPS.PROGRESSIVES);
      }
    }
  },

  PROGRESSIVES: {
    answerKey: "PROGRESSIVES",
    type: INPUT_TYPES.CHOICE,
    next: index => cb => cb(index === 1 ? STEPS.EYEGLASSES : STEPS.REJECTION_PROGRESSIVES),
    answers: YES_NO,
    copy: {
      title: "Do you currently wear reading glasses (readers), progressives, or bifocals?",
      body: (
        <span>
          <p>If you’re not sure, here’s a little guide:</p>

          <p>
            <b>Readers</b>: Glasses that you only put on for looking at things up close. (They might
            make your distance vision blurry.)
          </p>

          <p>
            <b>Progressives</b>: Glasses with multiple prescriptions in the lens. (When you look
            straight ahead you look through the distance portion; when you drop your eyes down to
            read, you look through the reading portion.)
          </p>

          <p>
            <b>Bifocals</b>: These are similar to progressives, except that you can see the line in
            the lens where the distance prescription meets the reading prescription.
          </p>
        </span>
      )
    }
  },

  EYEGLASSES: {
    answerKey: "EYEGLASSES",
    type: INPUT_TYPES.CHOICE,
    answers: ["Yep, my glasses", "Yep, my prescription", "I don't have either"],
    next: index => cb => cb(index !== 2 ? STEPS.LAST_EYE_EXAM : STEPS.REJECTION_EYEGLASSES),
    copy: {
      title: `Can you bring your most recent prescription eyeglasses with you to the store?`,
      body: `(If not, your most recent glasses prescription will work.) It’s O.K. if either is expired!`
    }
  },

  LAST_EYE_EXAM: {
    answerKey: "LAST_EYE_EXAM",
    type: INPUT_TYPES.CHOICE,
    answers: ["Within 2 years", "2–5 years ago", "Over 5 years ago"],
    next: index => cb => cb(index !== 2 ? STEPS.EXPERIENCING : STEPS.REJECTION_LAST_EYE_EXAM),
    copy: {
      title: "When was your most recent comprehensive eye exam?"
    }
  },

  EXPERIENCING: {
    answerKey: "EXPERIENCING",
    type: INPUT_TYPES.MULTI,
    answers: [
      "Eye pain",
      "New floaters",
      "Seeing flashes of light",
      "New or unusual light sensitivity"
    ],
    next: (answers = []) => cb =>
      cb(answers.length === 0 ? STEPS.EYE_CONDITIONS : STEPS.REJECTION_HEALTH),
    copy: { title: "Are you experiencing any of the below?" }
  },

  EYE_CONDITIONS: {
    answerKey: "EYE_CONDITIONS",
    type: INPUT_TYPES.MULTI,
    answers: [
      "Amblyopia (lazy eye)",
      "Strabismus (eye turn)",
      "Eye movement problems (like nystagmus)",
      "Severe dry eye",
      "Cornea problems (like keratoconus)",
      "Glaucoma or high eye pressure",
      "Macular degeneration",
      "Optic neuritis",
      "Cataracts"
    ],
    next: (answers = []) => cb =>
      cb(answers.length === 0 ? STEPS.REDUCED_VISION : STEPS.REJECTION_HEALTH),
    copy: {
      title: "Have you ever had any of the below eye conditions?"
    }
  },

  REDUCED_VISION: {
    answerKey: "REDUCED_VISION",
    type: INPUT_TYPES.CHOICE,
    answers: YES_NO,
    next: index => cb => cb(index === 1 ? STEPS.HEALTH_HISTORY : STEPS.REJECTION_REDUCED_VISION),
    copy: {
      title: "Do you have reduced vision in one or both eyes due to an injury or infection?"
    }
  },

  HEALTH_HISTORY: {
    answerKey: "HEALTH_HISTORY",
    type: INPUT_TYPES.CHOICE,
    answers: YES_NO,
    next: index => cb => cb(index === 1 ? STEPS.SURGERY : STEPS.REJECTION_HEALTH_HISTORY),
    copy: {
      title: "Your health history",
      body: `Have you ever had or do you currently have any disease that may affect eyesight, such as diabetes, uncontrolled high blood pressure, or any neurological conditions?
      `
    }
  },

  SURGERY: {
    answerKey: "SURGERY",
    type: INPUT_TYPES.CHOICE,
    answers: YES_NO,
    next: index => cb => cb(index === 1 ? STEPS.SUCCESS : STEPS.REJECTION_SURGERY),
    copy: {
      title: "Have you had eye surgery, including LASIK, or any other refractive procedures?"
    }
  },

  SUCCESS: {
    type: INPUT_TYPES.SUCCESS
  },

  // Rejections
  REJECTION_LAST_EYE_EXAM: reject(REJECTIONS.LAST_EYE_EXAM),
  REJECTION_REDUCED_VISION: reject(REJECTIONS.REDUCED_VISION),
  REJECTION_AGE: reject(REJECTIONS.AGE),
  REJECTION_EYEGLASSES: reject(REJECTIONS.EYEGLASSES),
  REJECTION_HEALTH_HISTORY: reject(REJECTIONS.HEALTH_HISTORY),
  REJECTION_HEALTH: reject(REJECTIONS.HEALTH),
  REJECTION_SURGERY: reject(REJECTIONS.SURGERY),
  REJECTION_NO_STORES: reject(REJECTIONS.NO_STORES),
  REJECTION_DOWNLOAD_APP: reject(REJECTIONS.DOWNLOAD_APP),
  REJECTION_GET_EYE_EXAM: reject(REJECTIONS.GET_EYE_EXAM),
  REJECTION_PROGRESSIVES: reject(REJECTIONS.PROGRESSIVES)
};

module.exports = STEPS;
