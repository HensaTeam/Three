-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP
-----------------------------------------------------------------------------------------------------------------------------------------
local Proxy = module("lib/Proxy")
local Tunnel = module("lib/Tunnel")
-----------------------------------------------------------------------------------------------------------------------------------------
-- CONNECTION
-----------------------------------------------------------------------------------------------------------------------------------------
vRP = {}
vRP.users = {}
vRP.rusers = {}
vRP.user_tables = {}
vRP.user_sources = {}
Proxy.addInterface("vRP",vRP)

tvRP = {}
Tunnel.bindInterface("vRP",tvRP)
vRPclient = Tunnel.getInterface("vRP")
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local db_driver
local showIds = {}
local addPlayer = {}
local db_drivers = {}
local cached_queries = {}
local cached_prepares = {}
local db_initialized = false
-----------------------------------------------------------------------------------------------------------------------------------------
-- QUERIES
-----------------------------------------------------------------------------------------------------------------------------------------
local Prepares = {}
-----------------------------------------------------------------------------------------------------------------------------------------
-- PREPARE
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.Prepare(Name, Query)
	Prepares[Name] = Query
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- QUERY
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.Query(Name, Params)
	return exports.oxmysql:query_async(Prepares[Name], Params)
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- FORMAT
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.format(n)
	local left,num,right = string.match(n,'^([^%d]*%d)(%d*)(.-)$')
	return left..(num:reverse():gsub('(%d%d%d)','%1.'):reverse())..right
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- UPDATETXT
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.updateTxt(archive,text)
	archive = io.open("resources/logsystem/"..archive,"a")
	if archive then
		archive:write(text.."\n")
	end
	archive:close()
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- ISBANNED
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.isBanned(steam)
	local rows = vRP.getInfos(steam)
	if rows[1] then
		return rows[1].banned
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- ISWHITELISTED
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.isWhitelisted(steam)
	local rows = vRP.getInfos(steam)
	if rows[1] then
		return rows[1].whitelist
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- SETUDATA
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.setUData(user_id,key,value)
	vRP.Query("vRP/set_userdata",{ user_id = parseInt(user_id), key = key, value = value })
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- GETUDATA
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.getUData(user_id,key)
	local rows = vRP.Query("vRP/get_userdata",{ user_id = parseInt(user_id), key = key })
	if #rows > 0 then
		return rows[1].dvalue
	else
		return ""
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- SETSDATA
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.setSData(key,value)
	vRP.Query("vRP/set_srvdata",{ key = key, value = value })
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- GETSDATA
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.getSData(key)
	local rows = vRP.Query("vRP/get_srvdata",{ key = key })
	if #rows > 0 then
		return rows[1].dvalue
	else
		return ""
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- GETUSERDATATABLE
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.getUserDataTable(user_id)
	return vRP.user_tables[user_id]
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- GETINVENTORY
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.getInventory(user_id)
	local data = vRP.user_tables[user_id]
	if data then
		return data.inventorys
	end
	return false
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- UPDATESELECTSKIN
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.updateSelectSkin(user_id,hash)
	local data = vRP.user_tables[user_id]
	if data then
		data.skin = hash
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- GETUSERID
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.getUserId(source)
	if source ~= nil then
		local ids = GetPlayerIdentifiers(source)
		if ids ~= nil and #ids > 0 then
			return vRP.users[ids[1]]
		end
	end
	return nil
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- GETUSERS
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.getUsers()
	local users = {}
	for k,v in pairs(vRP.user_sources) do
		users[k] = v
	end
	return users
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- GETUSERSOURCE
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.getUserSource(user_id)
	return vRP.user_sources[user_id]
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- PLAYERDROPPED
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("playerDropped",function()
	vRP.rejoinServer(source)

	if addPlayer[source] then
		addPlayer[source] = nil
	end
	TriggerClientEvent("vRP:updateList",-1,addPlayer)
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- KICK
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.kick(user_id,reason)
	if vRP.user_sources[user_id] then
		local source = vRP.user_sources[user_id]

		vRP.rejoinServer(source)
		DropPlayer(source,reason)
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- DROPPLAYER
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.rejoinServer(source)
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		local identity = vRP.getUserIdentity(user_id)
		if identity then
			TriggerEvent("vRP:playerLeave",user_id,source)
			vRP.setUData(user_id,"Datatable",json.encode(vRP.user_tables[user_id]))
			vRP.users[identity.steam] = nil
			vRP.user_sources[user_id] = nil
			vRP.user_tables[user_id] = nil
			vRP.rusers[user_id] = nil
			showIds[source] = nil

			TriggerClientEvent("vRP:showIds",-1,showIds)
		end
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- GETSTEAM
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.getSteam(source)
	local identifiers = GetPlayerIdentifiers(source)
	for k,v in ipairs(identifiers) do
		if string.sub(v,1,5) == "steam" then
			return v
		end
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- PLAYERCONNECTING
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("queue:playerConnecting",function(source,ids,name,setKickReason,deferrals)
	deferrals.defer()
	local source = source
	local steam = vRP.getSteam(source)
	if steam then
		if not vRP.isBanned(steam) then
			if vRP.isWhitelisted(steam) then
				deferrals.done()
			else
				local newUser = vRP.getInfos(steam)
				if newUser[1] == nil then
					vRP.Query("vRP/create_user",{ steam = steam })
				end

				deferrals.done("Envie na sala liberação: "..steam)
				TriggerEvent("queue:playerConnectingRemoveQueues",ids)
			end
		else
			deferrals.done("Você foi banido da cidade.")
			TriggerEvent("queue:playerConnectingRemoveQueues",ids)
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- PLAYERSPAWNED
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("vRP:playerSpawned")
AddEventHandler("vRP:playerSpawned",function()
	local source = source
	TriggerClientEvent("vrp_spawn:setupChars", source)

	addPlayer[source] = true
	TriggerClientEvent("vRP:updateList",-1,addPlayer)
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- PLAYERSPAWNED
-----------------------------------------------------------------------------------------------------------------------------------------
--TODO: refatorar vrp_spawn e fazer uma criação de personagem
RegisterServerEvent("baseModule:idLoaded")
AddEventHandler("baseModule:idLoaded",function(source,user_id,model)
	local source = source
	if vRP.rusers[user_id] == nil then
		local playerData = vRP.getUData(parseInt(user_id),"Datatable")
		local resultData = json.decode(playerData) or {}

		vRP.user_tables[user_id] = resultData
		vRP.user_sources[user_id] = source

		if model ~= nil then
			vRP.user_tables[user_id].skin = GetHashKey(model)
			vRP.user_tables[user_id].inventorys = {}
			vRP.user_tables[user_id].inventorys["1"] = { item = "cellphone", amount = 1 }
			vRP.user_tables[user_id].inventorys["2"] = { item = "identity", amount = 1 }
			vRP.user_tables[user_id].inventorys["3"] = { item = "water", amount = 5 }
			vRP.user_tables[user_id].inventorys["4"] = { item = "sandwich", amount = 5 }
		end


		local identity = vRP.getUserIdentity(user_id)
		if identity then
			vRP.users[identity.steam] = user_id
			vRP.rusers[user_id] = identity.steam
		end

		showIds[source] = user_id
		TriggerClientEvent("vRP:showIds",-1,showIds)

		local registration = vRP.getUserRegistration(user_id)
		if registration == nil then
			vRP.Query("vRP/update_characters",{ id = parseInt(user_id), registration = vRP.generateRegistrationNumber(), phone = vRP.generatePhoneNumber() })
		end

		TriggerEvent("vRP:playerSpawn", user_id, source)
	end
end)