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
Tunnel.bindInterface("vrp_stockade",cRP)
vCLIENT = Tunnel.getInterface("vrp_stockade")
vTASKBAR = Tunnel.getInterface("vrp_taskbar")
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local stockadePlates = {}
local blockStockades = {}
local stockadeItem = "blackcard"
-----------------------------------------------------------------------------------------------------------------------------------------
-- CHECKPOLICE
-----------------------------------------------------------------------------------------------------------------------------------------
function cRP.checkPolice(vehPlate)
	if blockStockades[vehPlate] ~= nil then
		return false
	end

	local source = source
	local police = vRP.numPermission("Police")
	if parseInt(#police) <= 4 then
		TriggerClientEvent("Notify",source,"aviso","Sistema indisponível no momento, tente mais tarde.",5000)
		return false
	end
	return true
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- WITHDRAWMONEY
-----------------------------------------------------------------------------------------------------------------------------------------
function cRP.withdrawMoney(vehPlate,vehNet)
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		if stockadePlates[vehPlate] == nil then
			if vRP.getInventoryItemAmount(user_id,stockadeItem) >= 1 then
				local taskResult = vTASKBAR.taskThree(source)
				if taskResult then
					if vRP.tryGetInventoryItem(user_id,stockadeItem,1,true) then
						stockadePlates[vehPlate] = 30
						TriggerClientEvent("vrp_stockade:Destroy",-1,vehNet)
						TriggerClientEvent("Notify",source,"sucesso","Sistema violado e as autoridades foram notificadas.",5000)

						local x,y,z = vRPclient.getPositions(source)
						local copAmount = vRP.numPermission("Police")
						for k,v in pairs(copAmount) do
							async(function()
								TriggerClientEvent("NotifyPush",v,{ code = 31, title = "Roubo ao Carro Forte", x = x, y = y, z = z, rgba = {105,52,136} })
							end)
						end
					end
				end
			else
				TriggerClientEvent("Notify",source,"importante","Você não possui um <b>"..vRP.itemNameList(stockadeItem).."</b>.",5000)
			end
		else
			if stockadePlates[vehPlate] > 0 then
				vRP.wantedTimer(user_id,30)
				vCLIENT.freezePlayers(source,true)
				TriggerClientEvent("cancelando",source,true)
				stockadePlates[vehPlate] = stockadePlates[vehPlate] - 1
				vRPclient._playAnim(source,false,{ task = "PROP_HUMAN_BUM_BIN" },true)

				Citizen.Wait(20000)

				vRPclient._stopAnim(source,false)
				vCLIENT.freezePlayers(source,false)
				TriggerClientEvent("cancelando",source,false)
				vRP.giveInventoryItem(user_id,"dollars",math.random(2000,3500),true)
			else
				TriggerClientEvent("Notify",source,"negado","Nenhum dinheiro encontrado.",5000)
			end
		end
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- INPUTVEHICLE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("vrp_stockade:inputVehicle")
AddEventHandler("vrp_stockade:inputVehicle",function(vehPlate)
	blockStockades[vehPlate] = true
	TriggerClientEvent("vrp_stockade:Client",-1,blockStockades)
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- PLAYERSPAWN
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("vRP:playerSpawn",function(user_id,source)
	TriggerClientEvent("vrp_stockade:Client",source,blockStockades)
end)