-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP
-----------------------------------------------------------------------------------------------------------------------------------------
local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")
-----------------------------------------------------------------------------------------------------------------------------------------
-- CONNECTION
-----------------------------------------------------------------------------------------------------------------------------------------
cRP = {}
Tunnel.bindInterface("vrp_makeraces",cRP)
vCLIENT = Tunnel.getInterface("vrp_makeraces")
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local races = {}
local playerRaces = {}
-----------------------------------------------------------------------------------------------------------------------------------------
-- RACE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("races",function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	if user_id then
		if parseInt(args[1]) > 0 and races[parseInt(args[1])] then
			vCLIENT.selectRaces(source,parseInt(args[1]))
			playerRaces[source] = parseInt(args[1])
		elseif args[1] == "make" then
			vCLIENT.makeRaces(source)
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- INPUTRACE
-----------------------------------------------------------------------------------------------------------------------------------------
function cRP.inputRaces(status)
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		races[user_id] = status
		TriggerClientEvent("vrp_makeraces:updateRaces",-1,races)
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- INPUTRACE
-----------------------------------------------------------------------------------------------------------------------------------------
function cRP.finishRaces(raceSelected)
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		local identity = vRP.getUserIdentity(user_id)
		for k,v in pairs(playerRaces) do
			if parseInt(raceSelected) == parseInt(v) then
				async(function()
					vCLIENT.finishRaces(k,parseInt(raceSelected))
					TriggerClientEvent("Notify",k,"sucesso","<b>"..identity.name.." "..identity.name2.."</b> venceu.",5000)
				end)
			end
		end
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- PLAYERSPAWN
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("vRP:playerSpawn",function(user_id,source)
	TriggerClientEvent("vrp_makeraces:updateRaces",source,races)
end)