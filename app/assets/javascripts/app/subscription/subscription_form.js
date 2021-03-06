App.addChild('SubscriptionForm', _.extend({
  el: 'form#subscription_form',

  DATEPICKER_CONFIG: {
    minDate:    0,
    maxDate:    '+1M -1D',
    dateFormat: 'dd',
  },

  activate: function () {
    this.creditCardFields = this.$('#credit-card-fields');
    this.bankBilletRadioButton = this.$('#subscription_payment_method_bank_billet');
    this.chargingDayInput = this.$('#charing-day');
    this.datePickerInit();
    this.maskFields();
  },

  events: {
    'click #subscription_payment_method_credit_card': 'showCardFields',
    'click #subscription_payment_method_bank_billet': 'hideCardFields',
    'click [data-recurring=true]': 'sendSubscription',
  },

  sendSubscription: function (e) {
    e.preventDefault();
    var fieldVal = parseInt($('#subscription_new_value').val());
    var msg = '';
    if (!Number.isInteger(fieldVal))
      msg = 'Informe um valor válido (apenas inteiros e somento números)';
    else {
      if(fieldVal < 10 || fieldVal > 3000)
        msg = 'Informe um valor entre 10 e 3.000 reais para doação';
    }
    if(msg != '') {
      $('#subscription_new_value').focus();
      $('#error-msg').html(msg);
      return false;
    }
    if (this.bankBilletRadioButton.is(':checked')) {
      this.$el.submit();
    } else {
      this.submitSubscriptionPaidWithCard(e);
    }
  },

  submitSubscriptionPaidWithCard: function (e) {
    PagarMe.encryption_key = $(e.currentTarget).data('pagarme-encryption');

    creditCardValidator = new CreditCardValidator({
      creditCard: new PagarMe.creditCard(), cardAttributes: this.cardAttributes(), form: this,
    });

    if (creditCardValidator.process()) {
      this.generateHash(creditCardValidator.creditCard, function () {
        this.$el.submit();
      });
    }
  },

  generateHash: function (creditCard, callback) {
    creditCard.generateHash(_.bind(function (hash) {
      this.$el.find('[data-card-info]').attr('disabled', true);
      this.$el.append('<input id="teste" type="hidden" name="subscription[card_hash]" value="' + hash + '">');
      callback.call(this);
    }, this));
  },

  cardAttributes: function () {
    return ({
      cardHolderName: this.$('[data-payment-card-holder-name]').val(),
      cardNumber: this.$('[data-payment-card-number]').val(),
      cardExpirationMonth: this.$('[data-payment-card-expiration-month]').val(),
      cardExpirationYear: this.$('[data-payment-card-expiration-year]').val(),
      cardCVV: this.$('[data-payment-card-cvv]').val(),
    });
  },

  datePickerInit: function () {
    this.setDatePickerLocale();
    this.activateDatePickerInputs();
  },

  activateDatePickerInputs: function () {
    this.chargingDayInput.datepicker(this.DATEPICKER_CONFIG);
    this.chargingDayInput.removeAttr('disabled');
  },

  setDatePickerLocale: function () {
    var windowLocationPaths = window.location.pathname.split('/').filter(String);

    $.datepicker.setDefaults($.datepicker.regional[windowLocationPaths[0]]);
  },

  maskFields: function () {
    this.$('#subscription_donator_cpf').mask('999.999.999-99');
    this.$('.payment_card_date').mask('99');
  },

  showCardFields: function () {
    this.creditCardFields.fadeIn();
  },

  hideCardFields: function () {
    this.creditCardFields.fadeOut();
  },
}, Skull.Form));
