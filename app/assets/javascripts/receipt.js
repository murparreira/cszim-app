$(document).on('turbolinks:load', function() {
  $("#receipt_data_recebimento").flatpickr({});
  $(".data").flatpickr({});
	$(".valor").mask("000.000.000.000.000,00", {reverse: true});
  
  $(document).on('change', '#receipt_customer_id', function(e) {
    receiptCustomerId();
  });
  $(document).ready(function() {
    receiptCustomerId();
  });

  function receiptCustomerId() {
    customer_id = $("#receipt_customer_id option:selected").val();
    if (typeof(customer_id) !== 'undefined' && customer_id !== '') {
      $("#customer_id_path").attr("href", "/customers/"+customer_id+"/bill")
      $.ajax({
        url: '/receipts/get_infos',
        type: 'GET',
        data: { customer_id: $("#receipt_customer_id option:selected").val() },
        error: function(jqXHR, textStatus, errorThrown) {
          console.log("AJAX Erro: " + textStatus);
        },
        success: function(data, textStatus, jqXHR) {
          console.log("Select Dependente");
        }
      });
      $.ajax({
        url: '/receipts/get_companies',
        type: 'GET',
        data: { customer_id: $("#receipt_customer_id option:selected").val() },
        error: function(jqXHR, textStatus, errorThrown) {
          console.log("AJAX Erro: " + textStatus);
        },
        success: function(data, textStatus, jqXHR) {
          console.log("Select Dependente");
        }
      });      
    }
  }
});