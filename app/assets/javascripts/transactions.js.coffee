purchase = ->
	original = parseInt($('#purchase_cost').text())
	$('#item_quantity').change ->
		quantity = $('#item_quantity').val()
		$("#purchase_cost").html quantity * original


$(document).ready(purchase)
$(document).on('page:load', purchase)