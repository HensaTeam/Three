-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP
-----------------------------------------------------------------------------------------------------------------------------------------
local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")
vRPclient = Tunnel.getInterface("vRP")
-----------------------------------------------------------------------------------------------------------------------------------------
-- CONNECTION
-----------------------------------------------------------------------------------------------------------------------------------------
cRP = {}
Tunnel.bindInterface("vrp_weplants",cRP)
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local wePlants = {}
local weAmount = {}
local weCounts = {}
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADTIMERS
-----------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
	local wePlantsFile = LoadResourceFile("logsystem","weplants.json")
	wePlants = json.decode(wePlantsFile)

	local weCountsFile = LoadResourceFile("logsystem","wecounts.json")
	weCounts = json.decode(weCountsFile)

	while true do
		Citizen.Wait(72000)

		for k,v in pairs(wePlants) do
			v[4] = v[4] + 2
			if v[4] >= 300 then
				weCounts[tostring(v[5])] = weCounts[tostring(v[5])] - 1
				if weCounts[tostring(v[5])] <= 0 then
					weCounts[tostring(v[5])] = nil
				end

				wePlants[k] = nil
				TriggerClientEvent("vrp_weplants:removeExists",-1,k)
			end
		end

		TriggerClientEvent("vrp_weplants:tableUpdate",-1,wePlants)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- MATHLEGTH
-----------------------------------------------------------------------------------------------------------------------------------------
function mathLegth(n)
	return math.ceil(n*100) / 100
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- PRESSPLANTS
-----------------------------------------------------------------------------------------------------------------------------------------
function cRP.pressPlants(x,y,z)
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		local number = 0
		repeat
			number = number + 1
		until wePlants[tostring(number)] == nil

		if weCounts[tostring(user_id)] then
			weCounts[tostring(user_id)] = weCounts[tostring(user_id)] + 1
		else
			weCounts[tostring(user_id)] = 1
		end

		wePlants[tostring(number)] = { mathLegth(x),mathLegth(y),mathLegth(z),0,parseInt(user_id) }
		TriggerClientEvent("vrp_weplants:tableUpdate",-1,wePlants)
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- REMOVEPLANTS
-----------------------------------------------------------------------------------------------------------------------------------------
function cRP.removePlants(id)
	TriggerClientEvent("vrp_weplants:removeExists",-1,id)
	TriggerClientEvent("vrp_weplants:tableUpdate",-1,wePlants)
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- AMOUNTSERVICE
-----------------------------------------------------------------------------------------------------------------------------------------
function cRP.amountService()
	local source = source
	if weAmount[source] == nil then
		weAmount[source] = math.random(6,8)
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- AMOUNTSERVICE
-----------------------------------------------------------------------------------------------------------------------------------------
function getAmount(user_id)
	if weCounts[tostring(user_id)] then
		return weCounts[tostring(user_id)]
	end
	return 0
end
exports("getAmount",getAmount)
-----------------------------------------------------------------------------------------------------------------------------------------
-- CHECKTIMERS
-----------------------------------------------------------------------------------------------------------------------------------------
function cRP.checkTimers(id)
	cRP.amountService()

	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		if vRP.hasPermission(user_id,"Admin") then
			TriggerClientEvent("Notify",source,"aviso",parseInt(wePlants[id][5]),1000)
		end

		if wePlants[id] ~= nil and parseInt(wePlants[id][4]) >= 100 then
			if vRP.computeInvWeight(user_id) + vRP.itemWeightList("weed") * parseInt(weAmount[source]) <= vRP.getBackpack(user_id) then
				weCounts[tostring(wePlants[id][5])] = weCounts[tostring(wePlants[id][5])] - 1

				if weCounts[tostring(wePlants[id][5])] <= 0 then
					weCounts[tostring(wePlants[id][5])] = nil
				end

				wePlants[id] = nil

				TriggerClientEvent("Progress",source,10000)
				TriggerClientEvent("cancelando",source,true)
				vRPclient._playAnim(source,false,{"anim@amb@clubhouse@tutorial@bkr_tut_ig3@","machinic_loop_mechandplayer"},true)

				Citizen.Wait(10000)

				vRPclient._stopAnim(source,false)
				TriggerClientEvent("cancelando",source,false)
				vRP.giveInventoryItem(user_id,"weed",parseInt(weAmount[source]))
				vRP.giveInventoryItem(user_id,"bucket",1)
				weAmount[source] = nil
				return true
			end
		end
		return false
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- PLAYERSPAWN
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("vRP:playerSpawn",function(user_id,source)
	TriggerClientEvent("vrp_weplants:tableUpdate",source,wePlants)
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP_ADMIN:KICKALL
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("vrp_admin:KickAll")
AddEventHandler("vrp_admin:KickAll",function()
	SaveResourceFile("logsystem","weplants.json",json.encode(wePlants),-1)
	SaveResourceFile("logsystem","wecounts.json",json.encode(weCounts),-1)
end)