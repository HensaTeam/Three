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
Tunnel.bindInterface("vrp_helicam",cRP)
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent('heli:forward.spotlight')
AddEventHandler('heli:forward.spotlight',function(state)
	local source = source
	TriggerClientEvent('heli:forward.spotlight',-1,source,state)
end)

RegisterServerEvent('heli:tracking.spotlight')
AddEventHandler('heli:tracking.spotlight',function(target_netID,target_plate,targetposx,targetposy,targetposz)
	local source = source
	TriggerClientEvent('heli:Tspotlight',-1,source,target_netID,target_plate,targetposx,targetposy,targetposz)
end)

RegisterServerEvent('heli:tracking.spotlight.toggle')
AddEventHandler('heli:tracking.spotlight.toggle',function()
	local source = source
	TriggerClientEvent('heli:Tspotlight.toggle',-1,source)
end)

RegisterServerEvent('heli:pause.tracking.spotlight')
AddEventHandler('heli:pause.tracking.spotlight',function(pause_Tspotlight)
	local source = source
	TriggerClientEvent('heli:pause.Tspotlight',-1,source,pause_Tspotlight)
end)

RegisterServerEvent('heli:manual.spotlight')
AddEventHandler('heli:manual.spotlight',function()
	local source = source
	TriggerClientEvent('heli:Mspotlight',-1,source)
end)

RegisterServerEvent('heli:manual.spotlight.toggle')
AddEventHandler('heli:manual.spotlight.toggle',function()
	local source = source
	TriggerClientEvent('heli:Mspotlight.toggle',-1,source)
end)

RegisterServerEvent('heli:radius.up')
AddEventHandler('heli:radius.up',function()
	local source = source
	TriggerClientEvent('heli:radius.up',-1,source)
end)

RegisterServerEvent('heli:radius.down')
AddEventHandler('heli:radius.down',function()
	local source = source
	TriggerClientEvent('heli:radius.down',-1,source)
end)