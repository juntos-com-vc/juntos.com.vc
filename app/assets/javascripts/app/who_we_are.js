App.addChild('WhoWeAre', {
  el: 'nav#who_we_are_menu',

  events: {
    'click a#history_link' : 'toggleHistoryContent',
    'click a#people_link' : 'togglePeopleContent',
    'click a#transparency_link' : 'toggleTransparencyContent'
  },

  activate: function() {
    this.$history = $('#who_we_are_history');
    this.$historyLink = $('#history_link');
    this.$people = $('#who_we_are_people');
    this.$peopleLink = $('#people_link');
    this.$transparency = $('#who_we_are_transparency');
    this.$transparencyLink = $('#transparency_link');
  },

  toggleHistoryContent: function(){
    this.$history.removeClass('w-lightbox-hide');
    this.$historyLink.addClass('selected');

    this.$people.addClass('w-lightbox-hide');
    this.$peopleLink.removeClass('selected');
    this.$transparency.addClass('w-lightbox-hide');
    this.$transparencyLink.removeClass('selected');
  },

  togglePeopleContent: function(){
    this.$people.removeClass('w-lightbox-hide');
    this.$peopleLink.addClass('selected');

    this.$history.addClass('w-lightbox-hide');
    this.$historyLink.removeClass('selected');
    this.$transparency.addClass('w-lightbox-hide');
    this.$transparencyLink.removeClass('selected');
  },

  toggleTransparencyContent: function(){
    this.$transparency.removeClass('w-lightbox-hide');
    this.$transparencyLink.addClass('selected');

    this.$history.addClass('w-lightbox-hide');
    this.$historyLink.removeClass('selected');
    this.$people.addClass('w-lightbox-hide');
    this.$peopleLink.removeClass('selected');
  }

});
