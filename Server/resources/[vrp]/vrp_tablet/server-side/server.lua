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
Tunnel.bindInterface("vrp_tablet",cRP)
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local twitter = {}
local policia = {}
local paramedico = {}
local anonimo = {}
-----------------------------------------------------------------------------------------------------------------------------------------
-- REQUESTTWITTER
-----------------------------------------------------------------------------------------------------------------------------------------
function cRP.requestMedia(media)
	if media == "Twitter" then
		return twitter
	elseif media == "Policia" then
		return policia
	elseif media == "Paramedico" then
		return paramedico
	elseif media == "Anonimo" then
		return anonimo
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- REQUESTTWITTER
-----------------------------------------------------------------------------------------------------------------------------------------
function cRP.messageMedia(message,page)
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		local text = ""
		local identity = vRP.getUserIdentity(user_id)
		if identity then
			if page == "Anonimo" then
				text = "<b>Anônimo</b> <i>("..os.date("%H")..":"..os.date("%M")..")</i><b>:</b> "..message
			else
				text = "<b>"..identity.name.." "..identity.name2.."</b> <i>("..os.date("%H")..":"..os.date("%M")..")</i><b>:</b> "..message
			end

			if page == "Twitter" then
				if vRP.getPremium(user_id) then
					table.insert(twitter,{ text = text, back = true })
					TriggerClientEvent("vrp_tablet:updateMedia",-1,page,{ text = text, back = true })
				else
					table.insert(twitter,{ text = text })
					TriggerClientEvent("vrp_tablet:updateMedia",-1,page,{ text = text })
				end
				TriggerClientEvent("Notify",-1,"importante","Novo tweet de <b>"..identity.name.." "..identity.name2.."</b>.",1000)
			elseif page == "Policia" then
				if vRP.getPremium(user_id) then
					table.insert(policia,{ text = text, back = true })
					TriggerClientEvent("vrp_tablet:updateMedia",-1,page,{ text = text, back = true })
				else
					table.insert(policia,{ text = text })
					TriggerClientEvent("vrp_tablet:updateMedia",-1,page,{ text = text })
				end
			elseif page == "Paramedico" then
				if vRP.getPremium(user_id) then
					table.insert(paramedico,{ text = text, back = true })
					TriggerClientEvent("vrp_tablet:updateMedia",-1,page,{ text = text, back = true })
				else
					table.insert(paramedico,{ text = text })
					TriggerClientEvent("vrp_tablet:updateMedia",-1,page,{ text = text })
				end
			elseif page == "Anonimo" then
				table.insert(anonimo,{ text = text })
				TriggerClientEvent("vrp_tablet:updateMedia",-1,page,{ text = text })
			end
		end
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADSTART
-----------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
	local twitterFile = LoadResourceFile("logsystem","twitter.json")
	local policiaFile = LoadResourceFile("logsystem","policia.json")
	local paramedicoFile = LoadResourceFile("logsystem","paramedico.json")
	local anonimoFile = LoadResourceFile("logsystem","anonimo.json")

	twitter = json.decode(twitterFile)
	policia = json.decode(policiaFile)
	paramedico = json.decode(paramedicoFile)
	anonimo = json.decode(anonimoFile)
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP_ADMIN:KICKALL
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("vrp_admin:KickAll")
AddEventHandler("vrp_admin:KickAll",function()
	SaveResourceFile("logsystem","twitter.json",json.encode(twitter),-1)
	SaveResourceFile("logsystem","policia.json",json.encode(policia),-1)
	SaveResourceFile("logsystem","paramedico.json",json.encode(paramedico),-1)
	SaveResourceFile("logsystem","anonimo.json",json.encode(anonimo),-1)
end)