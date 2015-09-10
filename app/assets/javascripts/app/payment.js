App.addChild('Payment', _.extend({
  el: '#payment-engines',

  events: {
    'click .nav-tab' : 'onClickPayment'
  },

  onClickPayment: function(event){
    this.$('.tab-loader img').show();
    this.onTabClick(event);
  },

  activate: function(){
  },

  show: function(){
    this.$el.slideDown('slow');
    if(this.$el.data('international-payment') != 'BR') {
      if (this.$el.data('show-national')) {
        this.selectNationalPayment();
      } else {
        this.selectInternationalPayment();
      }
    }
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
    this.$('.payments_type#MoIP_payment').hide();
  },

  selectInternationalPayment: function() {
    this.onTabClick({currentTarget: this.$('#PayPal')});
  },

  selectNationalPayment: function() {
    this.onTabClick({currentTarget: this.$('#MoIP')});
  },

  loadPaymentChoices: function() {
    if($('#contribution_country_id').val() == '36') {
      this.$('#MoIP').show();
      this.onTabClick({currentTarget: this.$('.nav-tab:first')});
    } else {
      this.hideNationalPayment();
      this.selectInternationalPayment();
    }

    this.on('selectTab', this.updatePaymentMethod);
  }
}, Skull.Tabs));

