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
Tunnel.bindInterface("vrp_blipsystem",cRP)
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local userList = {}
local userBlips = {}
-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP_BLIPSYSTEM:UPDATEBLIPS
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("vrp_blipsystem:updateBlips")
AddEventHandler("vrp_blipsystem:updateBlips",function(status)
	userList = status
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP_BLIPSYSTEM:CLEANBLIPS
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("vrp_blipsystem:cleanBlips")
AddEventHandler("vrp_blipsystem:cleanBlips",function()
	for k,v in pairs(userBlips) do
		RemoveBlip(userBlips[k])
	end

	userList = {}
	userBlips = {}
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP_BLIPSYSTEM:CLEANBLIPS
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("vrp_blipsystem:removeBlips")
AddEventHandler("vrp_blipsystem:removeBlips",function(source)
	if DoesBlipExist(userBlips[source]) then
		RemoveBlip(userBlips[source])
		userBlips[source] = nil
		userList[source] = nil
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREAD:UPDATEBLIPS
-----------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
	while true do
		for k,v in pairs(userList) do
			if DoesBlipExist(userBlips[k]) then
				SetBlipCoords(userBlips[k],v[1],v[2],v[3])
			else
				userBlips[k] = AddBlipForCoord(v[1],v[2],v[3])
				SetBlipSprite(userBlips[k],1)
				SetBlipScale(userBlips[k],0.5)
				SetBlipColour(userBlips[k],v[5])
				SetBlipAsShortRange(userBlips[k],false)
				BeginTextCommandSetBlipName("STRING")
				AddTextComponentString(v[4])
				EndTextCommandSetBlipName(userBlips[k])
			end
		end

		Citizen.Wait(500)
	end
end)