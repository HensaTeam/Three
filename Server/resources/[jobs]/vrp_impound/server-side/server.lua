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
Tunnel.bindInterface("vrp_impound",cRP)
vGARAGE = Tunnel.getInterface("vrp_garages")
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIÁVEIS
-----------------------------------------------------------------------------------------------------------------------------------------
local impoundVehs = {}
-----------------------------------------------------------------------------------------------------------------------------------------
-- CHECKIMPOUND
-----------------------------------------------------------------------------------------------------------------------------------------
function cRP.checkImpound()
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		local vehicle,vehNet,vehPlate,vehName = vRPclient.vehList(source,7)
		if vehicle then
			if impoundVehs[vehName.."-"..vehPlate] == nil then
				return
			else
				local value = math.random(2000,2500)

				impoundVehs[vehName.."-"..vehPlate] = nil
				vRP.giveInventoryItem(user_id,"dollars",parseInt(value),true)
				vGARAGE.deleteVehicle(source,vehicle)
			end
		end
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- IMPOUND
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("impound",function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	if user_id then
		if vRP.hasPermission(user_id,"Police") then
			local vehicle,vehNet,vehPlate,vehName = vRPclient.vehList(source,7)
			if vehicle then
				local x,y,z = vRPclient.getPositions(source)
				if impoundVehs[vehName.."-"..vehPlate] == nil then
					impoundVehs[vehName.."-"..vehPlate] = true
					TriggerEvent("vrp_towdriver:alertPlayers",x,y,z,vRP.vehicleName(vehName).." - "..vehPlate)
					TriggerClientEvent("Notify",source,"sucesso","Veículo <b>"..vRP.vehicleName(vehName).."</b> foi registrado no <b>DMV</b>.",3000)
				else
					TriggerClientEvent("Notify",source,"aviso","Veículo <b>"..vRP.vehicleName(vehName).."</b> já está na lista do <b>DMV</b>.",3000)
				end
			end
		end
	end
end)