App.addChild('Payment', _.extend({
  el: '#payment-engines',

  events: {
    'click .nav-tab' : 'onClickPayment',
    'blur #user_document_payment_slip': 'checkUserDocumentErrors',
  },

  checkUserDocumentErrors: function (e) {
    e.preventDefault();
    var $el = $(e.currentTarget);
    var $btn = this.$el.find('#build_boleto');

    if ($el.hasClass('error')) {
      $btn.prop('disabled', true);
    } else {
      $btn.removeAttr('disabled');
    }
  },

  onClickPayment: function(event){
    this.$('.tab-loader img').show();
    this.onTabClick(event);
  },

  show: function(){
    this.$el.slideDown('slow');
  },

  updatePaymentMethod: function() {
    var $selected_tab = this.$('.nav-tab.selected');
    $.ajax({
      url: this.$el.data('update-info-path'),
      type: 'PUT',
      data: { contribution: { payment_method: $selected_tab.prop('id') } }
    });
  },

  hideNationalPayment: function() {
    this.$('#MoIP').hide();
    this.$('#MoIP_payment').hide();
  },

  showNationalPayment: function() {
    this.$('#MoIP').show();
    this.$('#MoIP_payment').show();
    this.$('#PayPal_payment').hide();
  },

  selectPayment: function(defaultPaymentMethod) {
    var tabTarget = $('#payment-methods').data('preferredEngine');

    tabTarget = tabTarget || defaultPaymentMethod;

    this.onTabClick({currentTarget: this.$(tabTarget)});
  },

  loadPaymentChoicesPerNationality: function(national) {
    if(national) {
      this.showNationalPayment();
      this.selectPayment("#MoIP");
    } else {
      this.hideNationalPayment();
      this.selectPayment("#PayPal");
    }

    this.on('selectTab', this.updatePaymentMethod);
  },
}, Skull.Tabs));
