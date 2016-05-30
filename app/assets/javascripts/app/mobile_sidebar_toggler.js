App.addChild('MobileSidebarToggler', {
  el: '#sidebarToggle',

  events: {
    'click .btn-header-menu': 'toggleSidebar'
  },

  activate: function(){
    this.sidebar = $('#mobileSidebar');
  },

  toggleSidebar: function () {
    this.sidebar.fadeIn();
    $('.mobile-sidebar').animate({width: '300px'});
  }
});
