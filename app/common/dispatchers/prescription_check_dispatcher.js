'use strict';
const _ = require('lodash');

const Backbone = require('../backbone/backbone');
const BaseDispatcher = require('./base_dispatcher');

class QuizModel extends Backbone.BaseModel {
  url() {
    return this.apiBaseUrl('survey/rx_check_app_survey');
  }

  defaults() {
    return {
      activeQuestionIndex: 0,
      answers: {},
      errors: null,
      failed: false,
      open: false,
      signupSubmitted: false,
      succeeded: false
    };
  }
}

class PrescriptionCheckDispatcher extends BaseDispatcher {

  mixins() {
    return ['api'];
  }

  channel() {
    return 'prescriptionCheck';
  }

  models() {
    return {
      quiz: {
        class: QuizModel
      }
    };
  }

  events() {
    return { 'change quiz': this.__onChange };
  }

  getInitialStore() {
    return this.__buildStoreData();
  }

  __buildStoreData() {
    return {
      quiz: this.data('quiz')
    };
  }

  __onChange() {
    this.replaceStore(this.__buildStoreData());
  }

  __failQuiz() {
    this.model('quiz').set({failed: true});
  }

  __finishQuiz() {
    this.model('quiz').set({succeeded: true});
  }

  __openQuiz() {
    this.model('quiz').set({open: true});
  }

  __submitSignup() {
    this.model('quiz').save(this.data('quiz').answers, {
      success: this.__onSignupSuccess.bind(this),
      error: this.__onSignupError.bind(this)
    });
  }

  __onSignupSuccess() {
    this.model('quiz').set({
      errors: null,
      signupSubmitted: true
    });
  }

  __onSignupError(quiz, xhr, options) {
    this.model('quiz').set({errors: this.parseApiError(xhr.response)});
  }

  get commands() {
    return {
      enterQuiz() {
        this.__openQuiz();
      },

      answerQuestion(question, answer, finish, fail) {
        const answerKey = `answers.${question}`;
        const newAnswer = {};
        newAnswer[answerKey] = answer;
        this.model('quiz').set(newAnswer);

        if (fail) {
          this.__failQuiz();
        }
        else if (finish) {
          this.__finishQuiz();
        }
        else {
          this.model('quiz').set({
            activeQuestionIndex: this.data('quiz').activeQuestionIndex + 1
          });
        }
      },

      updateSignup(field, value) {
        const fieldKey = `answers.${field}`;
        const update = {};
        update[fieldKey] = value;
        this.model('quiz').set(update);
      },

      submitSignup() {
        this.__submitSignup();
      }
    }
  }
}

module.exports = PrescriptionCheckDispatcher;
