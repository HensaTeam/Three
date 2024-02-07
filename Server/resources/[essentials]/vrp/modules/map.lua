-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local wanted = {}
local repose = {}
-----------------------------------------------------------------------------------------------------------------------------------------
-- WANTEDDOWN
-----------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
	while true do
		for k,v in pairs(wanted) do
			if wanted[k] > 0 then
				wanted[k] = v - 1
				if wanted[k] <= 0 then
					wanted[k] = nil
				end
			end
		end
		Citizen.Wait(1000)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- REPOSEDOWN
-----------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
	while true do
		for k,v in pairs(repose) do
			if repose[k] > 0 then
				repose[k] = v - 1
				if repose[k] <= 0 then
					repose[k] = nil
				end
			end
		end
		Citizen.Wait(1000)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- WANTEDRETURN
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.wantedReturn(user_id)
	if wanted[user_id] ~= nil then
		TriggerClientEvent("Notify",vRP.getUserSource(user_id),"importante","Aguarde "..vRP.getTimers(wanted[user_id])..".",5000)
		return true
	else
		return false
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- REPOSERETURN
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.reposeReturn(user_id)
	if repose[user_id] ~= nil then
		TriggerClientEvent("Notify",vRP.getUserSource(user_id),"importante","Aguarde "..vRP.getTimers(repose[user_id])..".",5000)
		return true
	else
		return false
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- WANTEDTIMER
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.wantedTimer(user_id,timer)
	if wanted[user_id] ~= nil then
		wanted[user_id] = wanted[user_id] + timer
	else
		wanted[user_id] = timer
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- REPOSETIMER
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.reposeTimer(user_id,timer)
	if repose[user_id] ~= nil then
		repose[user_id] = repose[user_id] + timer * 60
	else
		repose[user_id] = timer * 60
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- WANTED
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("procurado",function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	if user_id then
		if wanted[user_id] ~= nil then
			TriggerClientEvent("Notify",source,"importante","Aguarde "..vRP.getTimers(wanted[user_id])..".",5000)
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- REPOSE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("repouso",function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	if user_id then
		if repose[user_id] ~= nil then
			TriggerClientEvent("Notify",source,"importante","Aguarde "..vRP.getTimers(repose[user_id])..".",5000)
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- GETUSERINFO
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.getInformation(user_id)
	return vRP.Query("vRP/get_vrp_users",{ id = parseInt(user_id) })
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- GETUSERINFO
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.getInfos(steam)
	return vRP.Query("vRP/get_vrp_infos",{ steam = steam })
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- GETTIMERS
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.getTimers(seconds)
	local days = math.floor(seconds/86400)
	seconds = seconds - days * 86400
	local hours = math.floor(seconds/3600)
	seconds = seconds - hours * 3600
	local minutes = math.floor(seconds/60)
	seconds = seconds - minutes * 60

	if days > 0 then
		return string.format("<b>%d Days</b>, <b>%d Hours</b>, <b>%d Minutes</b> and <b>%d Seconds</b>",days,hours,minutes,seconds)
	elseif hours > 0 then
		return string.format("<b>%d Hours</b>, <b>%d Minutes</b> and <b>%d Seconds</b>",hours,minutes,seconds)
	elseif minutes > 0 then
		return string.format("<b>%d Minutes</b> and <b>%d Seconds</b>",minutes,seconds)
	elseif seconds > 0 then
		return string.format("<b>%d Seconds</b>",seconds)
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- GETTIMERS
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.getTimersMinimal(seconds)
	local days = math.floor(seconds/86400)
	seconds = seconds - days * 86400
	local hours = math.floor(seconds/3600)
	seconds = seconds - hours * 3600
	local minutes = math.floor(seconds/60)
	seconds = seconds - minutes * 60

	if days > 0 then
		return string.format("<b>%d D</b>, <b>%d H</b>, <b>%d M</b>",days,hours,minutes)
	elseif hours > 0 then
		return string.format("<b>%d H</b>, <b>%d M</b>",hours,minutes)
	elseif minutes > 0 then
		return string.format("<b>%d Minutes</b>",minutes)
	elseif seconds > 0 then
		return string.format("<b>%d Seconds</b>",seconds)
	end
end