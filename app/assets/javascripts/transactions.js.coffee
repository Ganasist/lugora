purchase = ->
	original = parseInt($('#purchase_cost').text().replace(/,/g, ''))

	commaSeparateNumber = (val) ->
	  val = val.toString().replace(/(\d+)(\d{3})/, "$1" + "," + "$2")  while /(\d+)(\d{3})/.test(val.toString())
	  val
  
	$('#item_quantity').change ->
		quantity = $('#item_quantity').val()
		$("#purchase_cost").html commaSeparateNumber(quantity * original)


$(document).ready(purchase)
$(document).on('page:load', purchase)