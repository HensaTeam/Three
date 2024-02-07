window.addEventListener("load",function(){
	errdiv = document.createElement("div");
	if (true){
		errdiv.classList.add("console");
		document.body.appendChild(errdiv);
		window.onerror = function(errorMsg,url,lineNumber,column,errorObj){
			errdiv.innerHTML += '<br />Error: ' + errorMsg + ' Script: ' + url + ' Line: ' + lineNumber + ' Column: ' + column + ' StackTrace: ' +  errorObj;
		}
	}

	var wprompt = new WPrompt();
	var requestmgr = new RequestManager();

	requestmgr.onResponse = function(id,ok){ $.post("http://vrp/request",JSON.stringify({ act: "response", id: id, ok: ok })); }
	wprompt.onClose = function(){ $.post("http://vrp/prompt",JSON.stringify({ act: "close", result: wprompt.result })); }

	var pbars = {}
	var divs = {}

	window.addEventListener("message",function(evt){
		var data = evt.data;

		if(data.act == "cfg"){
			cfg = data.cfg
		}
		else if(data.act == "prompt"){
			wprompt.open(data.title,data.text);
		}
		else if(data.act == "request"){
			requestmgr.addRequest(data.id,data.text,data.time);
		}
		else if(data.act == "event"){
			if(data.event == "Y"){
				requestmgr.respond(true);
			}
			else if(data.event == "U"){
				requestmgr.respond(false);
			}
		}
	});
});