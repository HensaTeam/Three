-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP
-----------------------------------------------------------------------------------------------------------------------------------------
local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")
-----------------------------------------------------------------------------------------------------------------------------------------
-- ME
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("me",function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	if user_id then
		if args[1] then
			TriggerClientEvent("vrp_showme:pressMe",-1,source,rawCommand:sub(4),{ 10,250,0,255,100 })
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- CARD
-----------------------------------------------------------------------------------------------------------------------------------------
local cards = {
	[1] = "A",
	[2] = "2",
	[3] = "3",
	[4] = "4",
	[5] = "5",
	[6] = "6",
	[7] = "7",
	[8] = "8",
	[9] = "9",
	[10] = "10",
	[11] = "J",
	[12] = "Q",
	[13] = "K"
}

local naipes = {
	[1] = "^8♣",
	[2] = "^8♠",
	[3] = "^9♦",
	[4] = "^9♥"
}

RegisterCommand("carta",function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	if user_id then
		local card = math.random(13)
		local naipe = math.random(4)
		local identity = vRP.getUserIdentity(user_id)
		if identity then
			TriggerClientEvent("chatMessage",source,"",{},"^3* "..identity.name.." puxou do baralho um "..cards[card]..naipes[naipe])

			local players = vRPclient.nearestPlayers(source,7)
			for k,v in pairs(players) do
				async(function()
					TriggerClientEvent("chatMessage",k,"",{},"^3* "..identity.name.." puxou do baralho um "..cards[card]..naipes[naipe])
				end)
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- DICE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("dados",function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	if user_id then
		if (parseInt(args[1]) >= 1 and parseInt(args[1]) <= 6) and (parseInt(args[2]) >= 1 and parseInt(args[2]) <= 6) then
			local diceText = ""
			local amountDice = 0

			repeat
				amountDice = amountDice + 1
				if amountDice < parseInt(args[1]) then
					diceText = diceText..math.random(parseInt(args[2])).." / "..parseInt(args[2]).." - "
				else
					diceText = diceText..math.random(parseInt(args[2])).." / "..parseInt(args[2])
				end
			until amountDice >= parseInt(args[1])

			TriggerClientEvent("vrp_showme:pressMe",-1,source,diceText,{ 20,350,255,0,200 })
		end
	end
end)