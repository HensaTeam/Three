$(document).ready(function(){
	window.addEventListener("message",function(event){
		var html = `<div class="item" style="background-image: url('nui://vrp_inventory/web-side/images/${event.data.item}.png');">
			<div id="peso"></div>
			<div id="quantity">${event.data.mode} ${event.data.amount}x</div>
			<div id="itemname">${event.data.name}</div>
		</div>`;

		$(html).fadeIn(500).appendTo("#notifyitens").delay(3000).fadeOut(500);
	})
});