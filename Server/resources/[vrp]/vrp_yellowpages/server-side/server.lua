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
Tunnel.bindInterface("vrp_yellowpages",cRP)
vCLIENT = Tunnel.getInterface("vrp_yellowpages")
vPLAYER = Tunnel.getInterface("vrp_player")
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local array = {}
-----------------------------------------------------------------------------------------------------------------------------------------
-- YP
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("yp",function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	if user_id then
		if vRPclient.getHealth(source) > 101 and not vPLAYER.getHandcuff(source) then
			TriggerClientEvent("vrp_yellowpages:Command",source)
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- UPDATEPOST
-----------------------------------------------------------------------------------------------------------------------------------------
function cRP.updatePost(text)
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		local position = 0
		for k,v in pairs(array) do
			if user_id == v.id then
				if text == "" then
					table.remove(array,k)
				else
					position = k
				end

				break
			end
			Citizen.Wait(1)
		end

		if position ~= 0 then
			local temp = array[position]
			temp.text = text

			table.remove(array,position)
			table.insert(array,1,temp)
		elseif text ~= "" then
			local identity = vRP.getUserIdentity(user_id)
			TriggerClientEvent("Notify",-1,"aviso","Nova postagem de <b>"..identity.name.." "..identity.name2.."</b>.",5000)
			table.insert(array,1,{ phone = identity.phone, name = identity.name.." "..identity.name2, text = text, id = user_id })
		end

		TriggerClientEvent("vrp_yellowpages:Update",-1)
	end
	return array
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- GETPOSTS
-----------------------------------------------------------------------------------------------------------------------------------------
function cRP.getPosts()
	return array
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- GETNUMBER
-----------------------------------------------------------------------------------------------------------------------------------------
function cRP.getNumber()
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		return vRP.getUserIdentity(user_id).phone
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- PLAYERLEAVE
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("vRP:playerLeave",function(user_id,source)
	for k,v in pairs(array) do
		if user_id == v.id then
			table.remove(array,k)
			break
		end
		Citizen.Wait(1)
	end
end)