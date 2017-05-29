$(document).on('turbolinks:load', function() {
  $("#automatico").on("change", function() {
    if (this.checked) {
      $(".map_bans").show();
      $(".numero_maximo_mapas").show();
    } else {
      $(".map_bans .nested-fields").remove()
      $(".map_bans").hide();
      $(".numero_maximo_mapas").hide();
    }
  });
  $("#times_automatico").on("change", function() {
    if (this.checked) {
      $(".times .nested-fields").remove()
      $(".times").hide();
    } else {
      $(".times").show();
    }
  });
});
