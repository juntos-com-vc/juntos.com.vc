App.addChild('Admin', {
  el: '.admin',

  events: {
    'click .project-admin-menu' : "toggleAdminMenu",
  },


  toggleAdminMenu: function(event){
    var link = $(event.target);
    var path = this.$('.w-dropdown-btn').parent().next();
    this.$dropdown = link.parent().next('.user-menu');
    this.$dropdown.toggleClass('w--open');

    if (path.hasClass('w--open')){
      path.removeClass('w--open');
      this.$dropdown.addClass('w--open');
    }

    return false;
  },
});
