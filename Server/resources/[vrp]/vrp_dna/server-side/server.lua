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
Tunnel.bindInterface("vrp_dna",cRP)
vCLIENT = Tunnel.getInterface("vrp_dna")
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local dnaList = {}
-----------------------------------------------------------------------------------------------------------------------------------------
-- DROPDNA
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("vrp_dna:dropDna")
AddEventHandler("vrp_dna:dropDna",function(r,g,b)
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		local x,y,z,grid = vCLIENT.getPostions(source)
		if dnaList[grid] == nil then
			dnaList[grid] = {}
		end

		table.insert(dnaList[grid],{ x,y,z,r,g,b,user_id,1800 })

		TriggerClientEvent("vrp_dna:dnaUpdates",-1,dnaList)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- REMOVEDNA
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("vrp_dna:removeDna")
AddEventHandler("vrp_dna:removeDna",function(grid,tables)
	dnaList[grid][tables] = nil
	TriggerClientEvent("vrp_dna:dnaUpdates",-1,dnaList)
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADTIMER
-----------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
	while true do
		for k,v in pairs(dnaList) do
			for y,w in pairs(v) do
				if w[8] > 0 then
					w[8] = w[8] - 10
					if w[8] <= 0 then
						dnaList[k][y] = nil
						TriggerClientEvent("vrp_dna:dnaUpdates",-1,dnaList)
					end
				end
			end
		end
		Citizen.Wait(10000)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- CHECKDNA
-----------------------------------------------------------------------------------------------------------------------------------------
local resultTimers = 0
local dnaResult = "Nenhum"
RegisterCommand("dna",function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	if user_id then
		if vCLIENT.checkDistance(source) and resultTimers <= 0 and vRP.hasPermission(user_id,"Paramedic") then
			if vRP.tryGetInventoryItem(user_id,"gsrkit",1,true) then
				local grid = parseInt(args[1])
				local tables = parseInt(args[2])
				if dnaList[grid][tables] then
					resultTimers = 120
					local identity = vRP.getUserIdentity(parseInt(dnaList[grid][tables][7]))
					if identity then
						dnaResult = identity.name.." "..identity.name2
					else
						dnaResult = "Individuo Indigente"
					end
					TriggerClientEvent("vrp_dna:lastResult",-1,"teste em andamento")
				end
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADRESULTIMERS
-----------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
	while true do
		if resultTimers > 0 then
			resultTimers = resultTimers - 10
			if resultTimers <= 0 then
				if math.random(100) >= 50 then
					TriggerClientEvent("vrp_dna:lastResult",-1,dnaResult)
				else
					TriggerClientEvent("vrp_dna:lastResult",-1,"falhou")
				end
			end
		end
		Citizen.Wait(10000)
	end
end)