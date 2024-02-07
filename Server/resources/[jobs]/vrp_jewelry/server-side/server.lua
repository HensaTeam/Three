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
Tunnel.bindInterface("vrp_jewelry",cRP)
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local jewelryStatus = false
local jewelryDrawer = {}
local jewelryTimer = 0
local jewelryCooldown = 0
-----------------------------------------------------------------------------------------------------------------------------------------
-- JEWELRYUPDATESTATUS
-----------------------------------------------------------------------------------------------------------------------------------------
function cRP.jewelryUpdateStatus(status)
	TriggerClientEvent("vrp_jewelry:jewelryFunctionStart",-1,status)
	jewelryStatus = status
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- JEWELRYCHECKITENS
-----------------------------------------------------------------------------------------------------------------------------------------
function cRP.jewelryCheckItens()
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		if jewelryCooldown > 0 then
			TriggerClientEvent("Notify",source,"aviso","Aguarde "..vRP.getTimers(parseInt(jewelryCooldown)),5000)
			return false
		end

		local copAmount = vRP.numPermission("Police")
		if parseInt(#copAmount) <= 4 then
			TriggerClientEvent("Notify",source,"aviso","Sistema indisponível no momento, tente mais tarde.",5000)
			return false
		end

		if vRP.getInventoryItemAmount(user_id,"c4") >= 1 and vRP.getInventoryItemAmount(user_id,"bluecard") >= 1 then
			vRP.removeInventoryItem(user_id,"bluecard",1)
			vRP.removeInventoryItem(user_id,"c4",1)
			jewelryCooldown = 7200
			jewelryTimer = 2700

			for k,v in pairs(copAmount) do
				async(function()
					TriggerClientEvent("NotifyPush",v,{ code = 20, title = "Roubo a Joalheria", x = -1311.87, y = -829.86, z = 17.15, rgba = {170,80,25} })
				end)
			end

			return true
		end

		return false
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- OPENDRAWER
-----------------------------------------------------------------------------------------------------------------------------------------
function cRP.openDrawer(number)
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		if jewelryDrawer[number] or not jewelryStatus then
			return
		else
			jewelryDrawer[number] = true
			TriggerClientEvent("cancelando",source,true)
			vRPclient.playAnim(source,false,{"oddjobs@shop_robbery@rob_till","loop"},true)
			Citizen.Wait(20000)
			vRP.giveInventoryItem(user_id,"watch",parseInt(math.random(14,16)))
			TriggerClientEvent("cancelando",source,false)
			vRPclient._removeObjects(source)
		end
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- JEWELRYTIMERS
-----------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
	while true do
		if jewelryStatus and jewelryTimer > 0 then
			jewelryTimer = jewelryTimer - 1
			if jewelryTimer <= 0 then
				jewelryDrawer = {}
				cRP.jewelryUpdateStatus(false)
				TriggerEvent("vrp_doors:doorsStatistics",17,true)
			end
		end

		if jewelryCooldown > 0 then
			jewelryCooldown = jewelryCooldown - 1
		end
		Citizen.Wait(1000)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- PLAYERSPAWN
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("vRP:playerSpawn",function(user_id,source)
	TriggerClientEvent("vrp_jewelry:jewelryFunctionStart",source,bankStatus)
end)