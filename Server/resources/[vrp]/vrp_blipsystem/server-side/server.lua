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
-- THREADSYSTEM
-----------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
	while true do
		for k,v in pairs(userList) do
			local ped = GetPlayerPed(k)
			if DoesEntityExist(ped) then
				local coords = GetEntityCoords(ped)

				userBlips[k] = { coords.x,coords.y,coords.z,v[1],v[2] }
			else
				userList[k] = nil
				userBlips[k] = nil
			end
		end

		for k,v in pairs(userList) do
			if v[1] ~= "Corredor" then
				async(function()
					TriggerClientEvent("vrp_blipsystem:updateBlips",k,userBlips)
				end)
			end
		end

		Citizen.Wait(1000)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP_BLIPSYSTEM:SERVICEENTER
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("vrp_blipsystem:serviceEnter")
AddEventHandler("vrp_blipsystem:serviceEnter",function(source,service,color)
	if userList[source] == nil then
		userList[source] = { tostring(service),parseInt(color) }
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP_BLIPSYSTEM:SERVICEEXIT
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("vrp_blipsystem:serviceExit")
AddEventHandler("vrp_blipsystem:serviceExit",function(source)
	serviceExit(source)
	TriggerClientEvent("vrp_blipsystem:cleanBlips",source)
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- PLAYERDROPPED
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("playerDropped",function()
	serviceExit(source)
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP_BLIPSYSTEM:SERVICEEXIT
-----------------------------------------------------------------------------------------------------------------------------------------
function serviceExit(source)
	if userList[source] then
		userList[source] = nil
		userBlips[source] = nil

		for k,v in pairs(userList) do
			async(function()
				TriggerClientEvent("vrp_blipsystem:removeBlips",k,source)
			end)
		end
	end
end