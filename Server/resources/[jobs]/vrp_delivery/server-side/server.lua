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
Tunnel.bindInterface("vrp_delivery",cRP)
vTASKBAR = Tunnel.getInterface("vrp_taskbar")
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local locates = {
	{ 10.3,-1604.19,29.38,11.17,-1605.62,29.4,nil }
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local itemCheck = {}
local itemFooding = false
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local itemList = {
	[1] = { "tacos","hamburger","hotdog","soda","cola","chocolate","sandwich","fries","absolut","chandon","dewars","donut","hennessy" }
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- PAYMENTMETHOD
-----------------------------------------------------------------------------------------------------------------------------------------
function cRP.paymentMethod()
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		if vRP.tryGetInventoryItem(user_id,"delivery",1) then
			local myBonus = vRP.bonusDelivery(user_id)
			if vRP.getInventoryItemAmount(user_id,"dollars2") >= 10 then
				local value = math.random(75,115)

				vRP.giveInventoryItem(user_id,"dollars",parseInt(value+(value*myBonus/100)),true)

				if vRP.tryGetInventoryItem(user_id,"dollars2",10) then
					vRP.giveInventoryItem(user_id,"dollars",parseInt(math.random(100,155)),true)
				end
			else
				local value = math.random(75,115)

				vRP.giveInventoryItem(user_id,"dollars",parseInt(value+(value*myBonus/100)),true)
			end

			TriggerClientEvent("vrp_sound:source",source,"coin",0.5)
			return true
		end
		return false
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- DROPFOOD
-----------------------------------------------------------------------------------------------------------------------------------------
function cRP.dropFood(locate)
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		if locates[locate][7] ~= nil and not itemFooding then
			if vRP.getInventoryItemAmount(user_id,"paperbag") >= 1 and vRP.getInventoryItemAmount(user_id,locates[locate][7]) >= 1 then
				itemFooding = true

				local taskResult = vTASKBAR.taskOne(source)
				if taskResult then
					vRP.removeInventoryItem(user_id,"paperbag",1,false)
					vRP.giveInventoryItem(user_id,"dollars",300,true)
					vRP.removeInventoryItem(user_id,locates[locate][7],1,false)
					itemCheck[locate] = true
					locates[locate][7] = nil

					TriggerClientEvent("vrp_delivery:updateItem",-1,locates)
				end

				itemFooding = false
			end
		end
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- CHECKDELIVERY
-----------------------------------------------------------------------------------------------------------------------------------------
function cRP.checkDelivery(locate)
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		if itemCheck[locate] ~= nil then
			return itemCheck[locate]
		end
	end
	return false
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- TAKEDELIVERY
-----------------------------------------------------------------------------------------------------------------------------------------
function cRP.takeDelivery(locate)
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		if itemCheck[locate] then
			itemCheck[locate] = nil
			locates[locate][7] = itemList[locate][math.random(#itemList[locate])]
			vRP.giveInventoryItem(user_id,"delivery",1,true)
			TriggerClientEvent("vrp_delivery:updateItem",-1,locates)
		end
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADSTART
-----------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
	for k,v in pairs(locates) do
		v[7] = itemList[k][math.random(#itemList[k])]
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- PLAYERSPAWN
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("vRP:playerSpawn",function(user_id,source)
	TriggerClientEvent("vrp_delivery:updateItem",source,locates)
end)