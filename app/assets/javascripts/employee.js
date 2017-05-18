$(document).on('turbolinks:load', function() {
	$("#employee_documento").inputmask({mask: ['999.999.999-99'], keepStatic: true });
	$("#employee_telefone").inputmask({mask: ['(99) 9999-9999', '(99) 9 9999-9999'], keepStatic: true });
});