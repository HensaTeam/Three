$(document).ready(function(){
	var documentWidth = document.documentElement.clientWidth;
	var documentHeight = document.documentElement.clientHeight;
	var curTask = 0;
	var processed = []
	var percent = 0;

	document.onkeydown = function (data){
		if (data.which == 69){
			$(".divwrap").css("display","none");
			$.post("http://vrp_taskbar/taskEnd",JSON.stringify({ taskResult: percent }));
		}
	}

	window.addEventListener("message",function(event){
		var item = event.data;

		if (item.runProgress === true){
			percent = 0;
			$(".divwrap").css("display","block");
			$("#progress-bar").css("width","0%");
			$(".skillprogress").css("left",item.chance+"%")
			$(".skillprogress").css("width",item.skillGap+"%");
		}

		if (item.runUpdate === true){
			percent = item.Length
			$("#progress-bar").css("width",item.Length+"%");

			if (item.Length < (item.chance + item.skillGap) && item.Length > (item.chance)){
				$(".skillprogress").css("background-color","rgba(120,50,50,0.9)");
			} else {
				$(".skillprogress").css("background-color","rgba(255,250,250,0.4)");
			}
		}

		if (item.closeProgress === true){
			$(".divwrap").css("display","none");
		}
	});
});