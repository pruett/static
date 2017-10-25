'use strict';
const Backbone = require('hedeia/common/backbone/backbone');

class BirthdayModel extends Backbone.BaseModel {
  url() {
    return this.apiBaseUrl('birthday');
  }

  permittedAttributes() {
    return [
      'first_name',
      'last_name',
      'full_name',
      'locality',
      'postal_code',
      'region',
      'street_address',
      'extended_address',
      'telephone',
      'email',
      'company',
      'is_birthday_contest_active'
    ];
  }

  validateFullName(value) {
    if (!value) {
      return 'Please fill in your name';
    }

    if (value.trim().indexOf(' ') < 0) {
      return 'Please add your last name';
    }
  }

  validation() {
    const required = { required: true };
    return {
      email: {
        required: true,
        pattern: 'email',
        msg: 'Email address must be valid.'
      },
      full_name: this.validateFullName,
      locality: required,
      postal_code: required,
      region: required,
      street_address: required,
      telephone: required
    };
  }
}

module.exports = BirthdayModel;
