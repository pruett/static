'use strict';
const _ = require('lodash');
const BaseDispatcher = require('./base_dispatcher');
const BirthdayModel = require('../backbone/models/birthday_model');
const Backbone = require('../backbone/backbone');

class BirthdayDispatcher extends BaseDispatcher {
  get copy() {
    return { contest_over: 'Sorry, contest is over.' };
  }

  mixins() {
    return ['api'];
  }

  channel() {
    return 'birthday';
  }

  events() {
    return { 'sync birthday': this.__onSync };
  }

  models() {
    return {
      birthday: {
        class: BirthdayModel,
        fetchOnWake: true
      }
    };
  }

  getInitialStore() {
    return this.__buildStoreData();
  }

  __buildStoreData() {
    return {
      active: this.model('birthday').get('is_birthday_contest_active'),
      success: false,
      validated: [],
      birthdayErrors: {}
    };
  }

  __onBirthdaySuccess() {
    this.setStore({ success: true, birthdayErrors: {} });
  }

  __onBirthdayError(model, xhr) {
    this.setStore({ birthdayErrors: this.__parseApiError(xhr.response) });
  }

  __onSync() {
    this.setStore({
      active: this.model('birthday').get('is_birthday_contest_active')
    });
  }

  __parseApiError(resp) {
    // Add full_name error if available..
    const errors = this.parseApiError(resp) || {};
    if (errors.first_name || errors.last_name) {
      errors.full_name = errors.first_name || errors.last_name;
    }
    return errors;
  }

  __splitName(name) {
    if (!name || typeof name !== 'string') return;
    const split = name.trim().replace(/\s+/g, ' ').split(' ');
    return { first_name: split[0], last_name: split.slice(1).join(' ') };
  }

  __checkAndSaveModel(attrs) {
    const model = this.model('birthday');
    const attrsWithName = _.assign(this.__splitName(attrs.full_name), attrs);
    const errors = model.set(attrsWithName).validate();

    if (errors) {
      // Return and replace store with errors.
      const country = this.getLocale('country');
      return this.replaceStore({
        birthdayErrors: Backbone.Labels.format(errors, country)
      });
    }

    return model.save(null, {
      success: this.__onBirthdaySuccess.bind(this),
      error: this.__onBirthdayError.bind(this)
    });
  }

  __validateAttribute(key, value) {
    const errorMsg = this.model('birthday').preValidate(key, value);
    const wasValidated = this.store.validated.indexOf(key) > -1;
    const newStore = {};

    if (errorMsg) {
      // Error present, add key to errors.
      const error = { [key]: errorMsg };
      newStore.birthdayErrors = _.assign({}, this.store.birthdayErrors, error);

      if (wasValidated) {
        // Remove key from validated if present.
        newStore.validated = _.filter(this.store.validated, key);
      }
    } else if (!wasValidated) {
      // No error, add key to validated.
      newStore.validated = this.store.validated.concat(key);
      if (this.store.birthdayErrors[key]) {
        // Remove from error if present.
        newStore.birthdayErrors = _.omit(this.store.birthdayErrors, key);
      }
    }

    if (newStore.validated || newStore.birthdayErrors) {
      // Only update store if changed.
      this.replaceStore(newStore);
    }
  }

  __randomPassword() {
    const r = () => Math.random().toString(36).substr(2, 8);
    return [r(), r(), r(), r()].join('');
  }

  __createNewCustomer(attrs) {
    // Try to create new customer if email isn't same as signed in.
    const email = _.get(this.getStore('session'), 'customer.email');
    if (email !== attrs.email) {
      const customerAttrs = _.assign(
        { password: this.__randomPassword() },
        _.pick(attrs, 'email', 'wants_marketing_emails'),
        this.__splitName(attrs.full_name)
      );
      this.commandDispatcher('session', 'createNewCustomer', customerAttrs);
    }
  }

  get commands() {
    return {
      submit(attrs) {
        if (!this.store.active) {
          // Inform user that contest is over.
          return this.setStore({
            birthdayErrors: { generic: this.copy.contest_over }
          });
        }
        this.__createNewCustomer(attrs);
        this.__checkAndSaveModel(attrs);
      },
      validate(key, value) {
        this.__validateAttribute(key, value);
      }
    };
  }
}

module.exports = BirthdayDispatcher;
