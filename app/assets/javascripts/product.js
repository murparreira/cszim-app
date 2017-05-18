$(document).on('turbolinks:load', function() {
	$("#product_valor").mask("000.000.000.000.000,00", {reverse: true});
	$(".valor").mask("000.000.000.000.000,00", {reverse: true});
});