App.addChild('WhoWeAre', {
  el: 'nav#who_we_are_menu',

  events: {
    'click a#history_link' : 'toggleHistoryContent',
    'click a#people_link' : 'togglePeopleContent'
  },

  activate: function() {
    this.$history = $('#who_we_are_history');
    this.$historyLink = $('#history_link');
    this.$people = $('#who_we_are_people');
    this.$peopleLink = $('#people_link');
  },

  toggleHistoryContent: function(){
    this.$history.removeClass('w-lightbox-hide');
    this.$people.addClass('w-lightbox-hide');
    this.$historyLink.addClass('selected');
    this.$peopleLink.removeClass('selected');
  },

  togglePeopleContent: function(){
    this.$people.removeClass('w-lightbox-hide');
    this.$history.addClass('w-lightbox-hide');
    this.$peopleLink.addClass('selected');
    this.$historyLink.removeClass('selected');
  }

});
