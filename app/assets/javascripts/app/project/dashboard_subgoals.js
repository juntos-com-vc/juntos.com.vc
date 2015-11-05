App.addChild('DashboardSubgoals', {
  el: '#dashboard-subgoals-tab',

  events:{
    "click .show_subgoal_form": "showSubgoalForm",
    "click .subgoal-close-button": "closeForm",
    "click .fa-question-circle": "toggleExplanation"
  },

  activate: function() {
    this.$subgoals = this.$('#dashboard-subgoals');
    this.sortableSubgoals();
    this.showNewSubgoalForm();
  },

  toggleExplanation: function() {
    event.preventDefault();
    this.$('.subgoal-explanation').toggle();
  },

  closeForm: function(event) {
    event.preventDefault();
    var $target = this.$(event.currentTarget);
    $target.closest('.subgoal-card').hide();
    $target.closest('.subgoal-card').parent().prev().show();
  },

  sortableSubgoals: function() {
    this.$subgoals.sortable({
      axis: 'y',
      placeholder: "ui-state-highlight",
      start: function(e, ui) {
        return ui.placeholder.height(ui.item.height());
      },
      update: function(e, ui) {
        var csrfToken, position;
        position = $('#dashboard-subgoals .sortable').index(ui.item);
        csrfToken = $("meta[name='csrf-token']").attr("content");
        return $.ajax({
          type: 'POST',
          url: ui.item.data('update_url'),
          dataType: 'json',
          headers: {
            'X-CSRF-Token': csrfToken
          },
          data: {
            subgoal: {
              row_order_position: position
            }
          }
        });
      }
    })
  },

  showNewSubgoalForm: function(event) {
    var that = this;
    var $target = this.$('.new_subgoal_button');
    if(this.$('.sortable').length == 0)
    {
      $.get($target.data('path')).success(function(data){
        $($target.data('target')).html(data);
        that.subgoalForm;
      });

      this.$($target.data('target')).fadeIn('fast');
    }

  },

  showSubgoalForm: function(event) {
    var that = this;
    event.preventDefault();
    var $target = this.$(event.currentTarget);

    $.get($target.data('path')).success(function(data){
      $($target.data('target')).html(data);
      that.subgoalForm;
    });

    this.$($target.data('parent')).hide();
    this.$($target.data('target')).fadeIn('fast');

  }
});

App.views.DashboardSubgoals.addChild('SubgoalForm', _.extend({
  el: '.subgoal-card',

  events: {
    'ajax:complete' : 'onComplete',
    'blur input' : 'checkInput',
    'submit form' : 'validate'
  },

  onComplete: function(event, data){
    console.log(data);
    if(data.status === 302){
      window.location.reload();
    }
    else{
      var form = $(data.responseText).html();
      this.$el.html(form)
    }
  },

  activate: function(){
    this.setupForm();
  }
}, Skull.Form));
