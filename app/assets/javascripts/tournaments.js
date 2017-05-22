$(document).on('turbolinks:load', function() {
	$("#automatico").on("change", function() {
    if (this.checked) {
      $(".map_bans").show();
    } else {
			$(".map_bans .nested-fields").remove()
			$(".map_bans").hide();
    }
  });
});
