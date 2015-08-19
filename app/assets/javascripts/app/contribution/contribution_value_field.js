$(function() {
  $("#donation-value-field").change(function() {
    var options = $("label.back-reward-radio-reward");
    for(var i = options.length - 1; i >= 0; i--) {
      if ($(options[i]).children("label").data("minimum-value") <= $(this).val()) {
        $("label.back-reward-radio-reward").removeClass("selected");
        
        $(options[i]).addClass("selected");
        $(options[i]).children("input").prop("checked", true)
        break;
      }
    }
  });
});
