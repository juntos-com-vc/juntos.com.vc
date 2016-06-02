App.addChild('MobileSidebar', {
  el: '#mobileSidebar',

  events: {
    'click': 'toggleSidebar'
  },

  activate: function(){

  },

  toggleSidebar: function () {
    $("#mobileSidebar").fadeOut();
    $('.mobile-sidebar').animate({width: '0'});
  }
});
