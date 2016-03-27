App.addChild('ProjectForm', _.extend({
  el: 'form#project_form',

  events: {
    'blur input' : 'checkInput',
  },

  activate: function(){
    this.setupForm();
  }

}, Skull.Form));

// Put subview here to avoid dependency issues

App.views.ProjectForm.addChild('VideoUrl', _.extend({
  el: 'input#project_video_url',

  events: {
    'timedKeyup' : 'checkVideoUrl'
  },

  checkVideoUrl: function(){
    var that = this;
    $.get(this.$el.data('path') + '?url=' + encodeURIComponent(this.$el.val())).success(function(data){
      if(!data || !data.provider){
        that.$el.trigger('invalid');
      }
    });
  },

  activate: function(){
    this.setupTimedInput();
  }
}, Skull.TimedInput));

App.views.ProjectForm.addChild('Permalink', _.extend({
  el: 'input#project_permalink',

  events: {
    'timedKeyup' : 'checkPermalink'
  },

  checkPermalink: function(){
    var that = this;
    if(this.re.test(this.$el.val())){
      $.get('/pt/' + this.$el.val()).complete(function(data){
        if(data.status != 404){
          that.$el.trigger('invalid');
        }
      });
    }
  },

  activate: function(){
    this.re = new RegExp(this.$el.prop('pattern'));
    this.setupTimedInput();
  }
}, Skull.TimedInput));

App.addChild('RemoveProjectImage', {
  el: 'a[data-remove-submitted-image]',

  events: {
    'click': 'removeProjectImage'
  },

  removeProjectImage: function (e) {
    e.preventDefault();
    $(e.currentTarget).siblings('[data-destroy-image]').val(true);
    $(e.currentTarget)
      .closest('[data-thumbnail-card]')
      .addClass('card-secondary--removed');
  }

});

App.addChild('RemoveProjectPartner', {
  el: 'a.js-remove_project_partner',

  events: {
    'click': 'removeProjectPartner'
  },

  removeProjectPartner: function(event){
    event.preventDefault();
    var removeProjectPartner = this.el;
    var parent = $(removeProjectPartner).parents('.w-col.thumbnail-card');
    parent.find('.thumbnail').remove();
    parent.find('input[name*="_destroy"]').val('true');
    $('.js-btn-submit').click();
    return false;
  }

});

App.views.ProjectForm.addChild('ProjectGalleryUploader', _.extend({
  el: '[data-project-gallery-uploader]',
  thumbGallery: $('[data-thumbnail-gallery]'),
  template: _.template($('[data-thumbnail-card-template]').html()),
  limit: 8
}, App.ProjectImageUploader));
