App.addChild('Admin', {
  el: '.admin',

  events: {
    'click .project-admin-menu' : "toggleAdminMenu",
  },

  toggleAdminMenu: function(event){
    var link = $(event.target);
    this.$dropdown = link.parent().next('.user-menu');
    this.$dropdown.toggleClass('w--open');
    return false;
  },
});
