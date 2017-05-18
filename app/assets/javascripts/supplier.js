$(document).on('turbolinks:load', function() {
	$("#supplier_documento").inputmask({mask: ['999.999.999-99', '99.999.999/9999-99'], keepStatic: true });
	$("#supplier_telefone").inputmask({mask: ['(99) 9999-9999', '(99) 9 9999-9999'], keepStatic: true });
});