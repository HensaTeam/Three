$(document).ready(function(){
	window.addEventListener('message',function(event){
		switch(event.data.action){
			case "openNUI":
				updateGarages();
				$("#actionmenu").fadeIn(100);
			break;

			case "closeNUI":
				$("#actionmenu").fadeOut(100);
			break;
		}
	});

	document.onkeyup = function(data){
		if (data.which == 27){
			$.post("http://vrp_garages/close");
		}
	};
});
/* --------------------------------------------------- */
const updateGarages = () => {
	$.post('http://vrp_garages/myVehicles',JSON.stringify({}),(data) => {
		const nameList = data.vehicles.sort((a,b) => (a.name2 > b.name2) ? 1: -1);
		$('#cars').html(`
			${nameList.map((item) => (`
				<div class="imagem-carro"><img src="http://191.96.225.237/imagens/${item.name}.png"/></div>
					</div>
				</div>
					<div class="vehicle" data-name="${item.name}">
						<div class="vehicle-name">
							<div class="vehicle-name2">
								<p><b>${item.name2}</b></p>
							</div>
						</div>
						<div id="infos">
							<div class="vehicle-engine">
								<b>Motor:</b>
								<div class="vehicle-display">
									<div class="vehicle-back" style="width: ${item.engine}%;"></div>
								</div>
							</div>
							<div class="vehicle-chassi">
								<b>Chassi:</b>
								<div class="vehicle-display">
									<div class="vehicle-back" style="width: ${item.body}%;"></div>
								</div>
							</div>
							<div class="vehicle-gas">
								<b>Gasolina:</b>
								<div class="vehicle-display">
									<div class="vehicle-back" style="width: ${item.fuel}%;"></div>
								</div>
							</div>
						</div>
					</div>
			`)).join('')}
		`);
	});
}
/* --------------------------------------------------- */
$(document).on('click','.vehicle',function(){
	let $el = $(this);
	let isActive = $el.hasClass('active');
	$('.vehicle').removeClass('active');
	if(!isActive) $el.addClass('active');
});
/* --------------------------------------------------- */
$(document).on('click','.spawn',debounce(function(){
	let $el = $('.vehicle.active').attr('data-name');
	if($el){
		$.post('http://vrp_garages/spawnVehicles',JSON.stringify({
			name: $el
		}));
	}
}));
/* --------------------------------------------------- */
$(document).on('click','.store',debounce(function(){
	$.post('http://vrp_garages/deleteVehicles');
}));
/* ----------DEBOUNCE---------- */
function debounce(func,immediate){
	var timeout
	return function(){
		var context = this,args = arguments
		var later = function(){
			timeout = null
			if (!immediate) func.apply(context,args)
		}
		var callNow = immediate && !timeout
		clearTimeout(timeout)
		timeout = setTimeout(later,500)
		if (callNow) func.apply(context,args)
	}
}