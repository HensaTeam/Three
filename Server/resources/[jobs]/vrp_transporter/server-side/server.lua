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
Tunnel.bindInterface("vrp_transporter",cRP)
vCLIENT = Tunnel.getInterface("vrp_transporter")
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local collect = {}
local collectMin = 2
local collectMax = 4

local amount = {}
local amountMin = 4
local amountMax = 8

local paymentMin = 80
local paymentMax = 100
local consumeItem = "pouch"
-----------------------------------------------------------------------------------------------------------------------------------------
-- TRANSPORTER
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("transportador",function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	if user_id then
		vCLIENT.toggleService(source)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- AMOUNTCOLLECT
-----------------------------------------------------------------------------------------------------------------------------------------
function cRP.amountCollect()
	local source = source
	if collect[source] == nil then
		collect[source] = math.random(collectMin,collectMax)
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- AMOUNTSERVICE
-----------------------------------------------------------------------------------------------------------------------------------------
function cRP.amountService()
	local source = source
	if amount[source] == nil then
		amount[source] = math.random(amountMin,amountMax)
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- COLLECTMETHOD
-----------------------------------------------------------------------------------------------------------------------------------------
function cRP.collectMethod()
	cRP.amountCollect()

	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		if vRP.computeInvWeight(user_id) + vRP.itemWeightList(tostring(consumeItem)) * parseInt(collect[source]) <= vRP.getBackpack(user_id) then
			vRPclient.stopActived(source)
			TriggerClientEvent("Progress",source,5000)
			TriggerClientEvent("cancelando",source,true)
			vRP.giveInventoryItem(user_id,tostring(consumeItem),parseInt(collect[source]))
			vRPclient._playAnim(source,false,{"amb@prop_human_atm@male@idle_a","idle_a"},false)
			collect[source] = nil

			return true
		end
		return false
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- PAYMENTMETHOD
-----------------------------------------------------------------------------------------------------------------------------------------
function cRP.paymentMethod()
	cRP.amountService()

	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		if vRP.tryGetInventoryItem(user_id,tostring(consumeItem),parseInt(amount[source])) then
			vRP.upgradeStress(user_id,1)
			local value = math.random(paymentMin,paymentMax) * amount[source]

			vRP.giveInventoryItem(user_id,"dollars",parseInt(value),true)
			TriggerClientEvent("vrp_sound:source",source,"coin",0.5)
			amount[source] = nil

			return true
		else
			TriggerClientEvent("Notify",source,"aviso","Você precisa de <b>"..vRP.format(parseInt(amount[source])).."x "..vRP.itemNameList(consumeItem).."</b>.",5000)
		end

		return false
	end
end