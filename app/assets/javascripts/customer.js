$(document).on('turbolinks:load', function() {
	$("#customer_documento").inputmask({mask: ['999.999.999-99', '99.999.999/9999-99'], keepStatic: true });
	$("#customer_telefone").inputmask({mask: ['(99) 9999-9999', '(99) 9 9999-9999'], keepStatic: true });
	$("#customer_data_nascimento").inputmask({mask: ['99/99/9999'], keepStatic: true });
	$(".valor").mask("000.000.000.000.000,00", {reverse: true});
});