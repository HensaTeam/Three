-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP
-----------------------------------------------------------------------------------------------------------------------------------------
local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
local Tools = module("vrp","lib/Tools")
vRP = Proxy.getInterface("vRP")
vRPclient = Tunnel.getInterface("vRP")
local idgens = Tools.newIDGenerator() 

-----------------------------------------------------------------------------------------------------------------------------------------
-- CONNECTION
-----------------------------------------------------------------------------------------------------------------------------------------
cRP = {}
Tunnel.bindInterface("vrp_inventory",cRP)
vCLIENT = Tunnel.getInterface("vrp_inventory")
vGARAGE = Tunnel.getInterface("vrp_garages")
vSURVIVAL = Tunnel.getInterface("vrp_survival")
vPLAYER = Tunnel.getInterface("vrp_player")
vWEPLANTS = Tunnel.getInterface("vrp_weplants")
vHOMES = Tunnel.getInterface("vrp_homes")
vTASKBAR = Tunnel.getInterface("vrp_taskbar")
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local active = {}
local dropList = {}
local firecracker = {}
local registerTimers = {}
-----------------------------------------------------------------------------------------------------------------------------------------
-- GARMAS
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("garmas",function(source,args,rawCommand)
    vRP.addUserGroup()
end)

RegisterCommand("garmas",function(source,args,rawCommand)
    local user_id = vRP.getUserId(source)
    if user_id then
        if vRPclient.getHealth(source) > 101 and not vCLIENT.getHandcuff(source) then
            local weapons = vRPclient.replaceWeapons(source)
            for k,v in pairs(weapons) do
                vRP.giveInventoryItem(user_id,k,1)
                if v.ammo > 0 then
                    vRP.giveInventoryItem(user_id,vRP.itemAmmoList(k),v.ammo)
                end
            end
            vRPclient.updateWeapons(source)

            TriggerClientEvent("Notify",source,"sucesso","Armamento guardado.",5000)
        end
    end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- REGISTERTIMERS
-----------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
	while true do
		for k,v in pairs(registerTimers) do
			if registerTimers[k][4] > 0 then
				registerTimers[k][4] = registerTimers[k][4] - 1

				if registerTimers[k][4] <= 0 then
					registerTimers[k] = nil
					TriggerClientEvent("vrp_inventory:updateRegister",-1,registerTimers)
				end
			end
		end
		Citizen.Wait(10000)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- FIRECRACKER
-----------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
	while true do
		for k,v in pairs(firecracker) do
			if firecracker[k] > 0 then
				firecracker[k] = firecracker[k] - 30
				if firecracker[k] <= 0 then
					firecracker[k] = nil
				end
			end
		end
		Citizen.Wait(30000)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- ACTIVE
-----------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
	while true do
		for k,v in pairs(active) do
			if active[k] > 0 then
				active[k] = active[k] - 1
			end
		end
		Citizen.Wait(1000)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- MOCHILA
-----------------------------------------------------------------------------------------------------------------------------------------
function cRP.Mochila()
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		local inv = vRP.getInventory(user_id)
		if inv then
			local inventory = {}
			for k,v in pairs(inv) do
				if (parseInt(v.amount) <= 0 or vRP.itemBodyList(v.item) == nil) then
					vRP.removeInventoryItem(user_id,v.item,parseInt(v.amount),false)
				else
					if string.sub(v.item,1,9) == "toolboxes" then
						local advFile = LoadResourceFile("logsystem","toolboxes.json")
						local advDecode = json.decode(advFile)

						v.durability = advDecode[v.item]
					end

					v.amount = parseInt(v.amount)
					v.name = vRP.itemNameList(v.item)
					v.peso = vRP.itemWeightList(v.item)
					v.index = vRP.itemIndexList(v.item)
					v.key = v.item
					v.slot = k

					inventory[k] = v
				end
			end

			local identity = vRP.getUserIdentity(user_id)
			return inventory,vRP.computeInvWeight(user_id),vRP.getBackpack(user_id),{ identity.name.." "..identity.name2,parseInt(user_id),parseInt(identity.bank),parseInt(vRP.getGmsId(user_id)),identity.phone,identity.registration }
		end
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- POPULATESLOT
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("vrp_inventory:populateSlot")
AddEventHandler("vrp_inventory:populateSlot",function(itemName,slot,target,amount)
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		if amount == nil then amount = 1 end
		if amount <= 0 then amount = 1 end

		if vRP.tryGetInventoryItem(user_id,itemName,amount,false,slot) then
			vRP.giveInventoryItem(user_id,itemName,amount,false,target)
			TriggerClientEvent("vrp_inventory:Update",source,"updateMochila")
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- POPULATESLOT
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("vrp_inventory:updateSlot")
AddEventHandler("vrp_inventory:updateSlot",function(itemName,slot,target,amount)
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		if amount == nil then amount = 1 end
		if amount <= 0 then amount = 1 end

		local inv = vRP.getInventory(user_id)
		if inv then
			if inv[tostring(slot)] and inv[tostring(target)] and inv[tostring(slot)].item == inv[tostring(target)].item then
				if vRP.tryGetInventoryItem(user_id,itemName,amount,false,slot) then
					vRP.giveInventoryItem(user_id,itemName,amount,false,target)
				end
			else
				vRP.swapSlot(user_id,slot,target)
			end

			TriggerClientEvent("vrp_inventory:Update",source,"updateMochila")
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local droplist = {}
-----------------------------------------------------------------------------------------------------------------------------------------
-- DROPITEM
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("vrp_inventory:dropItem")
AddEventHandler("vrp_inventory:dropItem",function(itemName,amount,bole)
	local source = source
	local user_id = vRP.getUserId(source)

		local x,y,z = vRPclient.getPosition(source)
		if parseInt(amount) > 0 and not vPLAYER.getHandcuff(source) then
			if bole == true then
	    		if vRP.tryGetInventoryItem(user_id,itemName,parseInt(amount)) then
					TriggerEvent("itemdrop:Create",itemName,parseInt(amount),source)
					vRPclient._playAnim(source,true,{"pickup_object","pickup_low"},false)
					TriggerClientEvent("vrp_inventory:Update",source,"updateMochila")
					vCLIENT.closeInventory(source)
				end
			else
				TriggerEvent("itemdrop:Create",itemName,parseInt(amount),source)				
				vRPclient._playAnim(source,true,{"pickup_object","pickup_low"},false)
				TriggerClientEvent("vrp_inventory:Update",source,"updateMochila")
				vCLIENT.closeInventory(source)
			end
			
		end
		local nplayer = vRPclient.nearestPlayer(source,5)
		if nplayer then
			TriggerClientEvent("vrp_inventory:Update",nplayer,"updateMochila")
		end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP_ITEMDROP:CREATE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("itemdrop:Create")
AddEventHandler("itemdrop:Create",function(item,count,source)
    local id = idgens:gen()
    local x,y,z = vRPclient.getPositions(source)
    droplist[id] = { item = item, count = count, x = x, y = y, z = z, name = vRP.itemNameList(item),  index = vRP.itemIndexList(item), desc = vRP.itemDescList(item), peso = vRP.itemWeightList(item) }
    TriggerClientEvent("itemdrop:Players",-1,id,droplist[id])
	local nplayer = vRPclient.nearestPlayer(source,5)
		if nplayer then
			TriggerClientEvent("vrp_inventory:Update",nplayer,"updateMochila")
		end
end)

-- ROUBO
RegisterServerEvent("vrp_itemdrop:Create")
AddEventHandler("vrp_itemdrop:Create",function(item,count,x,y,z,source)
    local id = idgens:gen()
    droplist[id] = { item = item, count = count, x = x, y = y, z = z, name = vRP.itemNameList(item),  index = vRP.itemIndexList(item), desc = vRP.itemDescList(item), peso = vRP.itemWeightList(item) }
    TriggerClientEvent("itemdrop:Players",-1,id,droplist[id])
	local nplayer = vRPclient.nearestPlayer(source,5)
	if nplayer then
		TriggerClientEvent("vrp_inventory:Update",nplayer,"updateMochila")
	end
end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- ITEMPICKUP
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("itemdrop:Pickup")
AddEventHandler("itemdrop:Pickup",function(id,slot,amount)
    local source = source
    local user_id = vRP.getUserId(source)
    local inv = vRP.getInventory(user_id)
    if droplist[id] == nil then
        return
    else
    if vRP.computeInvWeight(user_id) + vRP.itemWeightList(tostring(droplist[id].item)) * parseInt(droplist[id].count) <= vRP.getBackpack(user_id) then
        if droplist[id].count - amount >= 1 and not vPLAYER.getHandcuff(source) then
            TriggerClientEvent("itemdrop:Remove",-1,id)
            vRP.giveInventoryItem(user_id,tostring(droplist[id].item),parseInt(amount),true,slot)
            local newamount = droplist[id].count - amount
            vCLIENT.dropItem(source,droplist[id].item,newamount)
			TriggerClientEvent("vrp_inventory:Update",source,"updateMochila")
            vRPclient._playAnim(source,true,{"pickup_object","pickup_low"},false)
            droplist[id] = nil
            idgens:free(id)

            return
        else

        TriggerClientEvent("itemdrop:Remove",-1,id)

        vRP.giveInventoryItem(user_id,tostring(droplist[id].item),parseInt(droplist[id].count),true,slot)
        vRPclient._playAnim(source,true,{"pickup_object","pickup_low"},false)
		TriggerClientEvent("vrp_inventory:Update",source,"updateMochila")
        droplist[id] = nil
        idgens:free(id)
        end
    else
        TriggerClientEvent("Notify",source,"negado","Sua <b>Mochila</b> Cheia.",5000)
        end
    end

    local nplayer = vRPclient.nearestPlayer(source,5)
    if nplayer then
        TriggerClientEvent("vrp_inventory:Update",nplayer,"updateMochila")
    end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADTIMER
-----------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
	while true do
		for k,v in pairs(dropList) do
			for y,w in pairs(v) do
				if w[6] > 0 then
					w[6] = w[6] - 10
					if w[6] <= 0 then
						dropList[k][y] = nil
						TriggerClientEvent("vrp_inventory:dropUpdates",-1,dropList)

						if string.sub(w[1],1,9) == "toolboxes" then
							local advFile = LoadResourceFile("logsystem","toolboxes.json")
							local advDecode = json.decode(advFile)

							if advDecode[w[1]] then
								advDecode[w[1]] = nil
								SaveResourceFile("logsystem","toolboxes.json",json.encode(advDecode),-1)
							end
						end
					end
				end
			end
		end
		Citizen.Wait(10000)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- USEITEM
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("vrp_inventory:useItem")
AddEventHandler("vrp_inventory:useItem",function(slot,rAmount)
	local source = source
    local user_id = vRP.getUserId(source)
	if user_id then
		if rAmount == nil then rAmount = 1 end
		if rAmount <= 0 then rAmount = 1 end

		if active[user_id] == nil and not vPLAYER.getHandcuff(source) then
			local inv = vRP.getInventory(user_id)
			if inv then
				if not inv[tostring(slot)] or inv[tostring(slot)].item == nil then
					return
				end

				local itemName = inv[tostring(slot)].item

				if vRP.itemTypeList(itemName) == "use" then
					if itemName == "bandage" then
						if vRPclient.getHealth(source) > 101 and vRPclient.getHealth(source) < 200 then
							active[user_id] = 5
							vCLIENT.closeInventory(source)
							vCLIENT.blockButtons(source,true)
							TriggerClientEvent("Progress",source,5000)
							vRPclient._playAnim(source,true,{"amb@world_human_clipboard@male@idle_a","idle_c"},true)

							repeat
								if active[user_id] == 0 then
									active[user_id] = nil
									vRPclient._stopAnim(source,false)
									vCLIENT.blockButtons(source,false)

									if vRP.tryGetInventoryItem(user_id,itemName,1,true,slot) then
										vRP.upgradeStress(user_id,2)
										vRPclient.updateHealth(source,15)
									end
								end
								Citizen.Wait(0)
							until active[user_id] == nil
						else
							TriggerClientEvent("Notify",source,"aviso","Você não pode utilizar de vida cheia ou nocauteado.",5000)
						end
					end

					if itemName == "analgesic" then
						if vRPclient.getHealth(source) > 101 and vRPclient.getHealth(source) < 200 then
							active[user_id] = 3
							vCLIENT.closeInventory(source)
							vCLIENT.blockButtons(source,true)
							TriggerClientEvent("Progress",source,3000)
							vRPclient._playAnim(source,true,{"mp_suicide","pill"},true)

							repeat
								if active[user_id] == 0 then
									active[user_id] = nil
									vRPclient._stopAnim(source,false)
									vCLIENT.blockButtons(source,false)

									if vRP.tryGetInventoryItem(user_id,itemName,1,true,slot) then
										vRP.upgradeStress(user_id,1)
										vRPclient.updateHealth(source,2)
									end
								end
								Citizen.Wait(0)
							until active[user_id] == nil
						else
							TriggerClientEvent("Notify",source,"aviso","Você não pode utilizar de vida cheia ou nocauteado.",5000)
						end
					end

					if itemName == "weed" then
						active[user_id] = parseInt(rAmount*3)
						vCLIENT.blockButtons(source,true)
						TriggerClientEvent("Progress",source,parseInt(rAmount*3000))

						repeat
							if active[user_id] == 0 then
								active[user_id] = nil
								vCLIENT.blockButtons(source,false)

								if vRP.getInventoryItemAmount(user_id,"weed") >= parseInt(rAmount) and vRP.getInventoryItemAmount(user_id,"silk") >= parseInt(rAmount) then
									if vRP.tryGetInventoryItem(user_id,"weed",parseInt(rAmount),true,slot) and vRP.tryGetInventoryItem(user_id,"silk",parseInt(rAmount),true) then
										vRP.giveInventoryItem(user_id,"joint",parseInt(rAmount),true)
									end
								end
							end
							Citizen.Wait(0)
						until active[user_id] == nil
					end

					if itemName == "joint" then
						if vRP.getInventoryItemAmount(user_id,"lighter") < 1 then
							return
						end

						active[user_id] = 60
						vCLIENT.closeInventory(source)
						vCLIENT.blockButtons(source,true)
						TriggerClientEvent("Progress",source,60000)
						vRPclient._createObjects(source,"amb@world_human_aa_smoke@male@idle_a","idle_c","prop_cs_ciggy_01",49,28422)

						repeat
							if active[user_id] == 0 then
								active[user_id] = nil
								vRPclient._removeObjects(source)
								vCLIENT.blockButtons(source,false)

								if vRP.tryGetInventoryItem(user_id,itemName,1,true,slot) then
									vRP.weedTimer(user_id,1)
									vRP.downgradeHunger(user_id,10)
									vRP.downgradeThirst(user_id,10)
									vRP.downgradeStress(user_id,15)
									vPLAYER.movementClip(source,"move_m@shadyped@a")
								end
							end
							Citizen.Wait(0)
						until active[user_id] == nil
					end

					if itemName == "lean" then
						active[user_id] = 3
						vCLIENT.closeInventory(source)
						vCLIENT.blockButtons(source,true)
						TriggerClientEvent("Progress",source,3000)
						vRPclient._playAnim(source,true,{"mp_suicide","pill"},true)

						repeat
							if active[user_id] == 0 then
								active[user_id] = nil
								vRPclient._stopAnim(source,false)
								vCLIENT.blockButtons(source,false)

								if vRP.tryGetInventoryItem(user_id,itemName,1,true,slot) then
									vRP.chemicalTimer(user_id,2)
									vRP.downgradeStress(user_id,50)
									TriggerClientEvent("cleanEffectDrugs",source)
								end
							end
							Citizen.Wait(0)
						until active[user_id] == nil
					end

					if itemName == "ecstasy" then
						active[user_id] = 3
						vCLIENT.closeInventory(source)
						vCLIENT.blockButtons(source,true)
						TriggerClientEvent("Progress",source,3000)
						vRPclient._playAnim(source,true,{"mp_suicide","pill"},true)

						repeat
							if active[user_id] == 0 then
								active[user_id] = nil
								vRPclient._stopAnim(source,false)
								vCLIENT.blockButtons(source,false)

								if vRP.tryGetInventoryItem(user_id,itemName,1,true,slot) then
									vRP.chemicalTimer(user_id,2)
									TriggerClientEvent("setEcstasy",source)
									TriggerClientEvent("setEnergetic",source,10,1.45)
								end
							end
							Citizen.Wait(0)
						until active[user_id] == nil
					end

					if itemName == "meth" then
						active[user_id] = 5
						vCLIENT.closeInventory(source)
						vCLIENT.blockButtons(source,true)
						TriggerClientEvent("Progress",source,5000)
						vRPclient._playAnim(source,true,{"anim@amb@nightclub@peds@","missfbi3_party_snort_coke_b_male3"},true)

						repeat
							if active[user_id] == 0 then
								active[user_id] = nil
								vRPclient._stopAnim(source)
								vCLIENT.blockButtons(source,false)

								if vRP.tryGetInventoryItem(user_id,itemName,1,true,slot) then
									vRP.chemicalTimer(user_id,2)
									vRPclient.setArmour(source,20)
									TriggerClientEvent("setEcstasy",source)
									TriggerClientEvent("setMeth",source)
								end
							end
							Citizen.Wait(0)
						until active[user_id] == nil
					end

					if itemName == "cocaine" then
						active[user_id] = 10
						vRPclient.stopActived(source)
						vCLIENT.closeInventory(source)
						vCLIENT.blockButtons(source,true)
						TriggerClientEvent("Progress",source,10000)
						vRPclient._playAnim(source,true,{"anim@amb@nightclub@peds@","missfbi3_party_snort_coke_b_male3"},true)

						repeat
							if active[user_id] == 0 then
								active[user_id] = nil
								vCLIENT.blockButtons(source,false)
								vRPclient._removeObjects(source,"one")

								if vRP.tryGetInventoryItem(user_id,itemName,1,true,slot) then
									vRP.upgradeStress(user_id,8)
									TriggerClientEvent("setEcstasy",source)
									TriggerClientEvent("setEnergetic",source,10,1.45)
								end
							end
							Citizen.Wait(0)
						until active[user_id] == nil
					end

					if itemName == "cigarette" then
						if vRP.getInventoryItemAmount(user_id,"lighter") < 1 then
							return
						end

						active[user_id] = 60
						vCLIENT.closeInventory(source)
						vCLIENT.blockButtons(source,true)
						TriggerClientEvent("Progress",source,60000)
						vRPclient._createObjects(source,"amb@world_human_aa_smoke@male@idle_a","idle_c","prop_cs_ciggy_01",49,28422)

						repeat
							if active[user_id] == 0 then
								active[user_id] = nil
								vRPclient._removeObjects(source)
								vCLIENT.blockButtons(source,false)

								if vRP.tryGetInventoryItem(user_id,itemName,1,true,slot) then
									vRP.downgradeStress(user_id,15)
								end
							end
							Citizen.Wait(0)
						until active[user_id] == nil
					end

					if itemName == "vape" then
						active[user_id] = 60
						vCLIENT.closeInventory(source)
						vCLIENT.blockButtons(source,true)
						TriggerClientEvent("Progress",source,60000)
						vRPclient._createObjects(source,"anim@heists@humane_labs@finale@keycards","ped_a_enter_loop","ba_prop_battle_vape_01",49,18905,0.08,-0.00,0.03,-150.0,90.0,-10.0)

						repeat
							if active[user_id] == 0 then
								active[user_id] = nil
								vRP.downgradeStress(user_id,10)
								vCLIENT.blockButtons(source,false)
								vRPclient._removeObjects(source,"one")
							end
							Citizen.Wait(0)
						until active[user_id] == nil
					end

					if itemName == "warfarin" then
						if vRPclient.getHealth(source) > 101 and vRPclient.getHealth(source) < 200 then
							active[user_id] = 15
							vCLIENT.closeInventory(source)
							vCLIENT.blockButtons(source,true)
							TriggerClientEvent("Progress",source,15000)
							vRPclient._createObjects(source,"amb@world_human_clipboard@male@idle_a","idle_c","v_ret_ta_firstaid",49,60309)

							repeat
								if active[user_id] == 0 then
									active[user_id] = nil
									vRPclient._removeObjects(source)
									vCLIENT.blockButtons(source,false)

									if vRP.tryGetInventoryItem(user_id,itemName,1,true,slot) then
										vRPclient.updateHealth(source,45)
										TriggerClientEvent("resetBleeding",source)
									end
								end
								Citizen.Wait(0)
							until active[user_id] == nil
						else
							TriggerClientEvent("Notify",source,"aviso","Você não pode utilizar de vida cheia ou nocauteado.",5000)
						end
					end

					if itemName == "gauze" then
						if vRPclient.getHealth(source) > 101 and vRPclient.getHealth(source) < 200 then
							active[user_id] = 3
							vCLIENT.closeInventory(source)
							vCLIENT.blockButtons(source,true)
							TriggerClientEvent("Progress",source,3000)
							vRPclient._playAnim(source,true,{"amb@world_human_clipboard@male@idle_a","idle_c"},true)

							repeat
								if active[user_id] == 0 then
									active[user_id] = nil
									vRPclient._stopAnim(source,false)
									vCLIENT.blockButtons(source,false)

									if vRP.tryGetInventoryItem(user_id,itemName,1,true,slot) then
										TriggerClientEvent("resetBleeding",source)
									end
								end
								Citizen.Wait(0)
							until active[user_id] == nil
						else
							TriggerClientEvent("Notify",source,"aviso","Você não pode utilizar de vida cheia ou nocauteado.",5000)
						end
					end

					if itemName == "binoculars" then
						active[user_id] = 2
						vCLIENT.closeInventory(source)
						vCLIENT.blockButtons(source,true)
						TriggerClientEvent("Progress",source,2000)

						repeat
							if active[user_id] == 0 then
								active[user_id] = nil
								vCLIENT.blockButtons(source,false)
								vRPclient._createObjects(source,"amb@world_human_binoculars@male@enter","enter","prop_binoc_01",50,28422)
								Citizen.Wait(750)
								TriggerClientEvent("useBinoculos",source)
							end
							Citizen.Wait(0)
						until active[user_id] == nil
					end

					if itemName == "camera" then
						active[user_id] = 2
						vCLIENT.closeInventory(source)
						vCLIENT.blockButtons(source,true)
						TriggerClientEvent("Progress",source,2000)

						repeat
							if active[user_id] == 0 then
								active[user_id] = nil
								vCLIENT.blockButtons(source,false)
								vRPclient._createObjects(source,"amb@world_human_paparazzi@male@base","base","prop_pap_camera_01",49,28422)
								Citizen.Wait(100)
								TriggerClientEvent("useCamera",source)
							end
							Citizen.Wait(0)
						until active[user_id] == nil
					end

					if itemName == "cellphone" then
						TriggerClientEvent("gcPhone:activePhone",source)
					end

					if itemName == "adrenaline" then
						local distance = vCLIENT.adrenalineDistance(source)
						local parAmount = vRP.numPermission("Paramedic")
						if parseInt(#parAmount) > 0 and not distance then
							return
						end

						local nplayer = vRPclient.nearestPlayer(source,2)
						if nplayer then
							local nuser_id = vRP.getUserId(nplayer)
							if nuser_id then
								if vSURVIVAL.deadPlayer(nplayer) then
									active[user_id] = 10
									vRPclient.stopActived(source)
									vCLIENT.closeInventory(source)
									vCLIENT.blockButtons(source,true)
									TriggerClientEvent("Progress",source,10000)
									vRPclient._playAnim(source,false,{"mini@cpr@char_a@cpr_str","cpr_pumpchest"},true)

									repeat
										if active[user_id] == 0 then
											active[user_id] = nil
											vSURVIVAL._reverseRevive(source)
											vCLIENT.blockButtons(source,false)

											if vRP.tryGetInventoryItem(user_id,itemName,1,true,slot) then
												vRP.upgradeStress(user_id,10)
												vRP.upgradeStress(nuser_id,10)
												vRP.upgradeThirst(nuser_id,10)
												vRP.upgradeHunger(nuser_id,10)
												vRP.chemicalTimer(nuser_id,1)
												vSURVIVAL._revivePlayer(nplayer,110)
												TriggerClientEvent("resetBleeding",nplayer)
											end
										end
										Citizen.Wait(0)
									until active[user_id] == nil
								end
							end
						end
					end

					if itemName == "teddy" then
						vCLIENT.closeInventory(source)
						vRPclient._createObjects(source,"impexp_int-0","mp_m_waremech_01_dual-0","v_ilev_mr_rasberryclean",49,24817,-0.20,0.46,-0.016,-180.0,-90.0,0.0)
					end

					if itemName == "rose" then
						vCLIENT.closeInventory(source)
						vRPclient._createObjects(source,"anim@heists@humane_labs@finale@keycards","ped_a_enter_loop","prop_single_rose",49,18905,0.13,0.15,0.0,-100.0,0.0,-20.0)
					end

					if itemName == "identity" then
						local nplayer = vRPclient.nearestPlayer(source,2)
						if nplayer then
							local identity = vRP.getUserIdentity(user_id)
							if identity then
								TriggerClientEvent("Notify",nplayer,"importante","<b>Passaporte:</b> "..vRP.format(parseInt(identity.id)).."<br><b>Nome:</b> "..identity.name.." "..identity.name2.."<br><b>RG:</b> "..identity.registration.."<br><b>Telefone:</b> "..identity.phone,10000)
							end
						end
					end

					if itemName == "bonusDelivery" then
						local myBonus = vRP.bonusDelivery(user_id)
						if parseInt(myBonus) >= 100 then
							return
						end

						if vRP.tryGetInventoryItem(user_id,itemName,1,true,slot) then
							vRP.setBonusDelivery(user_id,1)
							TriggerClientEvent("Notify",source,"importante","O nível de experiência no <b>Delivery</b> aumentou.",5000)
						end
					end

					if itemName == "bonusPostOp" then
						local myBonus = vRP.bonusPostOp(user_id)
						if parseInt(myBonus) >= 100 then
							return
						end

						if vRP.tryGetInventoryItem(user_id,itemName,1,true,slot) then
							vRP.setbonusPostOp(user_id,1)
							TriggerClientEvent("Notify",source,"importante","O nível de experiência no <b>Entregador</b> aumentou.",5000)
						end
					end

					if itemName == "firecracker" then
						if firecracker[user_id] == nil then
							active[user_id] = 3
							firecracker[user_id] = 300
							vCLIENT.closeInventory(source)
							vCLIENT.blockButtons(source,true)
							TriggerClientEvent("Progress",source,3000)
							vRPclient._playAnim(source,false,{"anim@mp_fireworks","place_firework_3_box"},true)

							repeat
								if active[user_id] == 0 then
									active[user_id] = nil
									vRPclient._stopAnim(source,false)
									vCLIENT.blockButtons(source,false)

									if vRP.tryGetInventoryItem(user_id,itemName,1,true,slot) then
										TriggerClientEvent("vrp_inventory:Firecracker",source)
									end
								end
								Citizen.Wait(0)
							until active[user_id] == nil
						end
					end

					if itemName == "gsrkit" then
						local nplayer = vRPclient.nearestPlayer(source,5)
						if nplayer then
							if vPLAYER.getHandcuff(nplayer) then
								active[user_id] = 10
								vCLIENT.closeInventory(source)
								vCLIENT.blockButtons(source,true)
								TriggerClientEvent("Progress",source,10000)

								repeat
									if active[user_id] == 0 then
										active[user_id] = nil
										vCLIENT.blockButtons(source,false)

										if vRP.tryGetInventoryItem(user_id,itemName,1,true,slot) then
											local check = vPLAYER.gsrCheck(nplayer)
											if parseInt(check) > 0 then
												TriggerClientEvent("Notify",source,"sucesso","Resultado positivo.",5000)
											else
												TriggerClientEvent("Notify",source,"negado","Resultado negativo.",3000)
											end
										end
									end
									Citizen.Wait(0)
								until active[user_id] == nil
							end
						end
					end

					if itemName == "gdtkit" then
						local nplayer = vRPclient.nearestPlayer(source,5)
						if nplayer then
							local nuser_id = vRP.getUserId(nplayer)
							if nuser_id then
								active[user_id] = 10
								vCLIENT.closeInventory(source)
								vCLIENT.blockButtons(source,true)
								TriggerClientEvent("Progress",source,10000)

								repeat
									if active[user_id] == 0 then
										active[user_id] = nil
										vCLIENT.blockButtons(source,false)

										if vRP.tryGetInventoryItem(user_id,itemName,1,true,slot) then
											local weed = vRP.weedReturn(nuser_id)
											local chemical = vRP.chemicalReturn(nuser_id)
											local alcohol = vRP.alcoholReturn(nuser_id)

											local chemStr = ""
											local alcoholStr = ""
											local weedStr = ""

											if chemical == 0 then
												chemStr = "Nenhum"
											elseif chemical == 1 then
												chemStr = "Baixo"
											elseif chemical == 2 then
												chemStr = "Médio"
											elseif chemical >= 3 then
												chemStr = "Alto"
											end

											if alcohol == 0 then
												alcoholStr = "Nenhum"
											elseif alcohol == 1 then
												alcoholStr = "Baixo"
											elseif alcohol == 2 then
												alcoholStr = "Médio"
											elseif alcohol >= 3 then
												alcoholStr = "Alto"
											end

											if weed == 0 then
												weedStr = "Nenhum"
											elseif weed == 1 then
												weedStr = "Baixo"
											elseif weed == 2 then
												weedStr = "Médio"
											elseif weed >= 3 then
												weedStr = "Alto"
											end

											TriggerClientEvent("Notify",source,"importante","<b>Químicos:</b> "..chemStr.."<br><b>Álcool:</b> "..alcoholStr.."<br><b>Drogas:</b> "..weedStr,8000)
										end
									end
									Citizen.Wait(0)
								until active[user_id] == nil
							end
						end
					end

					if itemName == "vest" then
						active[user_id] = 10
						vCLIENT.closeInventory(source)
						vCLIENT.blockButtons(source,true)
						TriggerClientEvent("Progress",source,10000)
						vRPclient._playAnim(source,true,{"clothingtie","try_tie_negative_a"},true)

						repeat
							if active[user_id] == 0 then
								active[user_id] = nil
								vRPclient._stopAnim(source,false)
								vCLIENT.blockButtons(source,false)

								if vRP.tryGetInventoryItem(user_id,itemName,1,true,slot) then
									vRPclient.setArmour(source,100)
								end
							end
							Citizen.Wait(0)
						until active[user_id] == nil
					end

					if itemName == "GADGET_PARACHUTE" then
						active[user_id] = 10
						vCLIENT.closeInventory(source)
						vCLIENT.blockButtons(source,true)
						TriggerClientEvent("Progress",source,10000)

						repeat
							if active[user_id] == 0 then
								active[user_id] = nil
								vCLIENT.blockButtons(source,false)

								if vRP.tryGetInventoryItem(user_id,itemName,1,true,slot) then
									vCLIENT.parachuteColors(source)
								end
							end
							Citizen.Wait(0)
						until active[user_id] == nil
					end

					if itemName == "toolbox" then
                        if not vRPclient.inVehicle(source) then
                            local vehicle,vehNet = vRPclient.vehList(source,11)
                            if vehicle then
                                active[user_id] = 30
                                vRPclient.stopActived(source)
                                vCLIENT.closeInventory(source)
                                vRPclient._playAnim(source,false,{"mini@repair","fixing_a_player"},true)
                                vRP.createDurability(itemName)

                                local taskResult = vTASKBAR.taskThree(source)
                                if taskResult then
                                    vRP.upgradeStress(user_id,2)
                                    TriggerClientEvent("vrp_inventory:repairVehicle",-1,vehNet,true)
                                    TriggerClientEvent("Notify",source,"aviso","Carro arrumado com sucesso.",7000)
                                    vRP.removeInventoryItem(user_id,itemName,1,true)
								else
                                    TriggerClientEvent("Notify",source,"aviso","Voce falhou.",7000)
                                end

                                vRPclient._stopAnim(source,false)
                                active[user_id] = nil
                            end
                        end
                    end

					if string.sub(itemName,1,9) == "toolboxes" then
						if not vRPclient.inVehicle(source) then
							local vehicle,vehNet = vRPclient.vehList(source,3)
							if vehicle then
								active[user_id] = 30
								vRPclient.stopActived(source)
								vCLIENT.closeInventory(source)
								vRPclient._playAnim(source,false,{"mini@repair","fixing_a_player"},true)

								local taskResult = vTASKBAR.taskThree(source)
								if taskResult then

									vRP.upgradeStress(user_id,2)
									TriggerClientEvent("vrp_inventory:repairTires",-1,vehNet)
									TriggerClientEvent("vrp_inventory:repairVehicle",-1,vehNet,false)

									local advFile = LoadResourceFile("logsystem","toolboxes.json")
									local advDecode = json.decode(advFile)

									if advDecode[itemName] then
										advDecode[itemName] = advDecode[itemName] - 1

										if advDecode[itemName] <= 0 then
											advDecode[itemName] = nil
											vRP.removeInventoryItem(user_id,itemName,1,true)
										end
									else
										advDecode[itemName] = 9
									end

									SaveResourceFile("logsystem","toolboxes.json",json.encode(advDecode),-1)
								end

								vRPclient._stopAnim(source,false)
								active[user_id] = nil
							end
						end
					end

					if itemName == "lockpick" then
						local vehicle,vehNet,vehPlate,vehName,vehLock,vehBlock,vehHealth,vehModel,vehClass = vRPclient.vehList(source,3)
						if vehicle and vehClass ~= 15 and vehClass ~= 16 then
							if vRPclient.inVehicle(source) then
								active[user_id] = 100
								vRPclient.stopActived(source)
								vCLIENT.closeInventory(source)
								vCLIENT.blockButtons(source,true)
								vGARAGE.startAnimHotwired(source)

								local taskResult = vTASKBAR.taskLockpick(source)
								if taskResult then
									vRP.upgradeStress(user_id,4)

									if math.random(100) >= 20 then
										TriggerEvent("setPlateEveryone",vehPlate)
										TriggerEvent("setPlatePlayers",vehPlate,user_id)
									end

									if math.random(100) >= 75 then
										local x,y,z = vRPclient.getPositions(source)
										local copAmount = vRP.numPermission("Police")
										for k,v in pairs(copAmount) do
											async(function()
												TriggerClientEvent("NotifyPush",v,{ time = os.date("%H:%M:%S"), code = "QRU", title = "Roubo de Veículo", x = x, y = y, z = z, vehicle = vRP.vehicleName(vehName).." - "..vehPlate, rgba = {15,110,110} })
											end)
										end
									end
								end

								if parseInt(math.random(1000)) >= 950 then
									vRP.removeInventoryItem(user_id,itemName,1,true,slot)
								end

								vCLIENT.blockButtons(source,false)
								vGARAGE.stopAnimHotwired(source,vehicle)
								active[user_id] = nil
							else
								active[user_id] = 100
								vRPclient.stopActived(source)
								vCLIENT.closeInventory(source)
								vCLIENT.blockButtons(source,true)
								vRPclient._playAnim(source,false,{"missfbi_s4mop","clean_mop_back_player"},true)

								local taskResult = vTASKBAR.taskLockpick(source)
								if taskResult then
									vRP.upgradeStress(user_id,4)

									if math.random(100) >= 50 then
										TriggerEvent("setPlateEveryone",vehPlate)
										TriggerClientEvent("vrp_inventory:lockpickVehicle",-1,vehNet)
									end

									if math.random(100) >= 75 then
										local x,y,z = vRPclient.getPositions(source)
										local copAmount = vRP.numPermission("Police")
										for k,v in pairs(copAmount) do
											async(function()
												TriggerClientEvent("NotifyPush",v,{ time = os.date("%H:%M:%S"), code = "QRU", title = "Roubo de Veículo", x = x, y = y, z = z, vehicle = vRP.vehicleName(vehName).." - "..vehPlate, rgba = {15,110,110} })
											end)
										end
									end
								end

								if parseInt(math.random(1000)) >= 950 then
									vRP.removeInventoryItem(user_id,itemName,1,true,slot)
								end

								vCLIENT.blockButtons(source,false)
								vRPclient._stopAnim(source,false)
								active[user_id] = nil
							end
						else
							local checkHomes,homeName = vHOMES.checkHomesTheft(source)
							if checkHomes then
								active[user_id] = 100
								vRPclient.stopActived(source)
								vCLIENT.closeInventory(source)
								vCLIENT.blockButtons(source,true)
								vRPclient.playAnim(source,false,{"missheistfbi3b_ig7","lift_fibagent_loop"},false)

								local taskResult = vTASKBAR.taskLockpick(source)
								if taskResult then
									vRP.upgradeStress(user_id,4)
									vHOMES.enterHomesTheft(source,homeName)
									TriggerEvent("vrp:homes:ApplyTime",homeName)
								end

								if parseInt(math.random(1000)) >= 950 then
									vRP.removeInventoryItem(user_id,itemName,1,true,slot)
								end

								vRPclient._stopAnim(source,false)
								vCLIENT.blockButtons(source,false)
								active[user_id] = nil
							else
								local status,x,y,z = vCLIENT.cashRegister(source)
								if status then
									active[user_id] = 10
									vRPclient.stopActived(source)
									vCLIENT.closeInventory(source)
									vCLIENT.blockButtons(source,true)
									table.insert(registerTimers,{ x,y,z,360 })
									TriggerClientEvent("Progress",source,10000)
									TriggerClientEvent("vrp_inventory:updateRegister",-1,registerTimers)
									vRPclient._playAnim(source,false,{"oddjobs@shop_robbery@rob_till","loop"},true)

									repeat
										if active[user_id] == 0 then
											active[user_id] = nil
											vRP.upgradeStress(user_id,1)
											vRPclient._removeObjects(source)
											vCLIENT.blockButtons(source,false)
											vRP.giveInventoryItem(user_id,"dollars2",math.random(4,6),true)

											if math.random(100) >= 75 then
												vRP.wantedTimer(user_id,60)
												local copAmount = vRP.numPermission("Police")
												for k,v in pairs(copAmount) do
													async(function()
														TriggerClientEvent("NotifyPush",v,{ code = "QRU", title = "Roubo a Caixa Registradora", x = x, y = y, z = z, rgba = {170,80,25} })
													end)
												end
											end
										end
										Citizen.Wait(0)
									until active[user_id] == nil
								else
									if x ~= nil and y ~= nil and z ~= nil then
										for k,v in pairs(registerTimers) do
											if v[1] == x and v[2] == y and v[3] == z then
												TriggerClientEvent("Notify",source,"importante","Aguarde "..vRP.getTimers(parseInt(v[4]*10))..".",5000)
											end
											Citizen.Wait(1)
										end
									end
								end
							end
						end
					end

					if itemName == "energetic" then
						active[user_id] = 10
						vRPclient.stopActived(source)
						vCLIENT.closeInventory(source)
						vCLIENT.blockButtons(source,true)
						TriggerClientEvent("Progress",source,10000)
						vRPclient._createObjects(source,"mp_player_intdrink","loop_bottle","prop_energy_drink",49,60309,0.0,0.0,0.0,0.0,0.0,130.0)

						repeat
							if active[user_id] == 0 then
								active[user_id] = nil
								vCLIENT.blockButtons(source,false)
								vRPclient._removeObjects(source,"one")

								if vRP.tryGetInventoryItem(user_id,itemName,1,true,slot) then
									vRP.upgradeStress(user_id,4)
									TriggerClientEvent("setEnergetic",source,90,1.10)
								end
							end
							Citizen.Wait(0)
						until active[user_id] == nil
					end

					if itemName == "absolut" then
						active[user_id] = 10
						vRPclient.stopActived(source)
						vCLIENT.closeInventory(source)
						vCLIENT.blockButtons(source,true)
						TriggerClientEvent("Progress",source,10000)
						vRPclient._createObjects(source,"amb@world_human_drinking@beer@male@idle_a","idle_a","p_whiskey_notop",49,28422,0.0,0.0,0.05,0.0,0.0,0.0)

						repeat
							if active[user_id] == 0 then
								active[user_id] = nil
								vCLIENT.blockButtons(source,false)
								vRPclient._removeObjects(source,"one")

								if vRP.tryGetInventoryItem(user_id,itemName,1,true,slot) then
									vRP.alcoholTimer(user_id,1)
									vRP.upgradeThirst(user_id,20)
									TriggerClientEvent("setDrunkTime",source,300)
								end
							end
							Citizen.Wait(0)
						until active[user_id] == nil
					end

					if itemName == "hennessy" then
						active[user_id] = 10
						vRPclient.stopActived(source)
						vCLIENT.closeInventory(source)
						vCLIENT.blockButtons(source,true)
						TriggerClientEvent("Progress",source,10000)
						vRPclient._createObjects(source,"amb@world_human_drinking@beer@male@idle_a","idle_a","p_whiskey_notop",49,28422,0.0,0.0,0.05,0.0,0.0,0.0)

						repeat
							if active[user_id] == 0 then
								active[user_id] = nil
								vCLIENT.blockButtons(source,false)
								vRPclient._removeObjects(source,"one")

								if vRP.tryGetInventoryItem(user_id,itemName,1,true,slot) then
									vRP.alcoholTimer(user_id,1)
									vRP.upgradeThirst(user_id,20)
									TriggerClientEvent("setDrunkTime",source,300)
								end
							end
							Citizen.Wait(0)
						until active[user_id] == nil
					end

					if itemName == "chandon" then
						active[user_id] = 10
						vRPclient.stopActived(source)
						vCLIENT.closeInventory(source)
						vCLIENT.blockButtons(source,true)
						TriggerClientEvent("Progress",source,10000)
						vRPclient._createObjects(source,"amb@world_human_drinking@beer@male@idle_a","idle_a","prop_beer_blr",49,28422,0.0,0.0,-0.10,0.0,0.0,0.0)

						repeat
							if active[user_id] == 0 then
								active[user_id] = nil
								vCLIENT.blockButtons(source,false)
								vRPclient._removeObjects(source,"one")

								if vRP.tryGetInventoryItem(user_id,itemName,1,true,slot) then
									vRP.alcoholTimer(user_id,1)
									vRP.upgradeThirst(user_id,20)
									TriggerClientEvent("setDrunkTime",source,300)
								end
							end
							Citizen.Wait(0)
						until active[user_id] == nil
					end

					if itemName == "dewars" then
						active[user_id] = 10
						vRPclient.stopActived(source)
						vCLIENT.closeInventory(source)
						vCLIENT.blockButtons(source,true)
						TriggerClientEvent("Progress",source,10000)
						vRPclient._createObjects(source,"amb@world_human_drinking@beer@male@idle_a","idle_a","prop_beer_blr",49,28422,0.0,0.0,-0.10,0.0,0.0,0.0)

						repeat
							if active[user_id] == 0 then
								active[user_id] = nil
								vCLIENT.blockButtons(source,false)
								vRPclient._removeObjects(source,"one")

								if vRP.tryGetInventoryItem(user_id,itemName,1,true,slot) then
									vRP.alcoholTimer(user_id,1)
									vRP.upgradeThirst(user_id,20)
									TriggerClientEvent("setDrunkTime",source,300)
								end
							end
							Citizen.Wait(0)
						until active[user_id] == nil
					end

					if itemName == "water" then
						active[user_id] = 10
						vRPclient.stopActived(source)
						vCLIENT.closeInventory(source)
						vCLIENT.blockButtons(source,true)
						TriggerClientEvent("Progress",source,10000)
						vRPclient._createObjects(source,"mp_player_intdrink","loop_bottle","prop_ld_flow_bottle",49,60309,0.0,0.0,0.02,0.0,0.0,130.0)

						repeat
							if active[user_id] == 0 then
								active[user_id] = nil
								vCLIENT.blockButtons(source,false)
								vRPclient._removeObjects(source,"one")

								if vRP.tryGetInventoryItem(user_id,itemName,1,true,slot) then
									vRP.upgradeThirst(user_id,25)
									vRP.giveInventoryItem(user_id,"emptybottle",1)
								end
							end
							Citizen.Wait(0)
						until active[user_id] == nil
					end

					if itemName == "sinkalmy" then
						active[user_id] = 10
						vRPclient.stopActived(source)
						vCLIENT.closeInventory(source)
						vCLIENT.blockButtons(source,true)
						TriggerClientEvent("Progress",source,10000)
						vRPclient._createObjects(source,"amb@world_human_drinking@beer@male@idle_a","idle_a","prop_ld_flow_bottle",49,28422)

						repeat
							if active[user_id] == 0 then
								active[user_id] = nil
								vCLIENT.blockButtons(source,false)
								vRPclient._removeObjects(source,"one")

								if vRP.tryGetInventoryItem(user_id,itemName,1,true,slot) then
									vRP.upgradeThirst(user_id,5)
									vRP.chemicalTimer(user_id,1)
									vRP.downgradeStress(user_id,25)
								end
							end
							Citizen.Wait(0)
						until active[user_id] == nil
					end

					if itemName == "ritmoneury" then
						active[user_id] = 10
						vRPclient.stopActived(source)
						vCLIENT.closeInventory(source)
						vCLIENT.blockButtons(source,true)
						TriggerClientEvent("Progress",source,10000)
						vRPclient._createObjects(source,"amb@world_human_drinking@beer@male@idle_a","idle_a","prop_ld_flow_bottle",49,28422)

						repeat
							if active[user_id] == 0 then
								active[user_id] = nil
								vCLIENT.blockButtons(source,false)
								vRPclient._removeObjects(source,"one")

								if vRP.tryGetInventoryItem(user_id,itemName,1,true,slot) then
									vRP.upgradeThirst(user_id,5)
									vRP.chemicalTimer(user_id,1)
									vRP.downgradeStress(user_id,50)
								end
							end
							Citizen.Wait(0)
						until active[user_id] == nil
					end

					if itemName == "dirtywater" then
						active[user_id] = 10
						vRPclient.stopActived(source)
						vCLIENT.closeInventory(source)
						vCLIENT.blockButtons(source,true)
						TriggerClientEvent("Progress",source,10000)
						vRPclient._createObjects(source,"mp_player_intdrink","loop_bottle","prop_ld_flow_bottle",49,60309)

						repeat
							if active[user_id] == 0 then
								active[user_id] = nil
								vCLIENT.blockButtons(source,false)
								vRPclient._removeObjects(source,"one")

								if vRP.tryGetInventoryItem(user_id,itemName,1,true,slot) then
									vRP.upgradeStress(user_id,4)
									vRP.upgradeThirst(user_id,25)
									vRPclient.downHealth(source,10)
									vRP.giveInventoryItem(user_id,"emptybottle",1)
								end
							end
							Citizen.Wait(0)
						until active[user_id] == nil
					end

					if itemName == "cola" then
						active[user_id] = 10
						vRPclient.stopActived(source)
						vCLIENT.closeInventory(source)
						vCLIENT.blockButtons(source,true)
						TriggerClientEvent("Progress",source,10000)
						vRPclient._createObjects(source,"mp_player_intdrink","loop_bottle","prop_ecola_can",49,60309,0.0,0.0,0.04,0.0,0.0,130.0)

						repeat
							if active[user_id] == 0 then
								active[user_id] = nil
								vCLIENT.blockButtons(source,false)
								vRPclient._removeObjects(source,"one")

								if vRP.tryGetInventoryItem(user_id,itemName,1,true,slot) then
									vRP.upgradeThirst(user_id,20)
								end
							end
							Citizen.Wait(0)
						until active[user_id] == nil
					end

					if itemName == "soda" then
						active[user_id] = 10
						vRPclient.stopActived(source)
						vCLIENT.closeInventory(source)
						vCLIENT.blockButtons(source,true)
						TriggerClientEvent("Progress",source,10000)
						vRPclient._createObjects(source,"mp_player_intdrink","loop_bottle","ng_proc_sodacan_01b",49,60309,0.0,0.0,-0.04,0.0,0.0,130.0)

						repeat
							if active[user_id] == 0 then
								active[user_id] = nil
								vCLIENT.blockButtons(source,false)
								vRPclient._removeObjects(source,"one")

								if vRP.tryGetInventoryItem(user_id,itemName,1,true,slot) then
									vRP.upgradeThirst(user_id,20)
								end
							end
							Citizen.Wait(0)
						until active[user_id] == nil
					end

					if itemName == "fishingrod" then
						if vCLIENT.fishingStatus(source) then
							active[user_id] = 30
							vCLIENT.closeInventory(source)
							vCLIENT.blockButtons(source,true)

							if not vCLIENT.fishingAnim(source) then
								vRPclient.stopActived(source)
								vRPclient._createObjects(source,"amb@world_human_stand_fishing@idle_a","idle_c","prop_fishing_rod_01",49,60309)
							end

							if vTASKBAR.taskFishing(source) then
								local rand = parseInt(math.random(3))
								local fishs = { "octopus","shrimp","carp" }

								if vRP.computeInvWeight(user_id) + vRP.itemWeightList(fishs[rand]) * rand <= vRP.getBackpack(user_id) then
									if vRP.tryGetInventoryItem(user_id,"bait",rand,true) then
										vRP.giveInventoryItem(user_id,fishs[rand],rand,true)
									else
										TriggerClientEvent("Notify",source,"aviso","Você precisa de <b>"..vRP.format(rand).."x "..vRP.itemNameList("bait").."</b>.",5000)
									end
								else
									TriggerClientEvent("Notify",source,"negado","Mochila cheia.",5000)
								end
							end

							vCLIENT.blockButtons(source,false)
							active[user_id] = nil
						end
					end

					if itemName == "emptybottle" then
						local status,style = vCLIENT.checkFountain(source)
						if status then
							vRPclient.stopActived(source)
							vCLIENT.blockButtons(source,true)

							if style == "fountain" then
								vCLIENT.closeInventory(source)
								vRPclient._playAnim(source,false,{"amb@prop_human_parking_meter@female@idle_a","idle_a_female"},true)
							elseif style == "floor" then
								vCLIENT.closeInventory(source)
								vRPclient._playAnim(source,false,{"amb@world_human_bum_wash@male@high@base","base"},true)
							end

							active[user_id] = parseInt(rAmount*3)

							TriggerClientEvent("Progress",source,parseInt(rAmount*3000))

							repeat
								if active[user_id] == 0 then
									active[user_id] = nil
									vRPclient._removeObjects(source)
									vCLIENT.blockButtons(source,false)

									if vRP.computeInvWeight(user_id)+vRP.itemWeightList(itemName) * parseInt(rAmount) <= vRP.getBackpack(user_id) then
										if vRP.tryGetInventoryItem(user_id,itemName,parseInt(rAmount),true,slot) then
											if style == "floor" then
												vRP.giveInventoryItem(user_id,"dirtywater",parseInt(rAmount))
											else
												vRP.giveInventoryItem(user_id,"water",parseInt(rAmount))
											end
										end
									end
								end
								Citizen.Wait(0)
							until active[user_id] == nil
						end
					end

					if itemName == "coffee" then
						active[user_id] = 10
						vRPclient.stopActived(source)
						vCLIENT.closeInventory(source)
						vCLIENT.blockButtons(source,true)
						TriggerClientEvent("Progress",source,10000)
						vRPclient._createObjects(source,"amb@world_human_aa_coffee@idle_a", "idle_a","p_amb_coffeecup_01",49,28422)

						repeat
							if active[user_id] == 0 then
								active[user_id] = nil
								vCLIENT.blockButtons(source,false)
								vRPclient._removeObjects(source,"one")

								if vRP.tryGetInventoryItem(user_id,itemName,1,true,slot) then
									vRP.downgradeStress(user_id,6)
									vRP.upgradeThirst(user_id,20)
									TriggerClientEvent("setEnergetic",source,30,1.15)
								end
							end
							Citizen.Wait(0)
						until active[user_id] == nil
					end

					if itemName == "hamburger" then
						active[user_id] = 10
						vRPclient.stopActived(source)
						vCLIENT.closeInventory(source)
						vCLIENT.blockButtons(source,true)
						TriggerClientEvent("Progress",source,10000)
						vRPclient._createObjects(source,"mp_player_inteat@burger","mp_player_int_eat_burger","prop_cs_burger_01",49,60309)

						repeat
							if active[user_id] == 0 then
								active[user_id] = nil
								vCLIENT.blockButtons(source,false)
								vRPclient._removeObjects(source,"one")

								if vRP.tryGetInventoryItem(user_id,itemName,1,true,slot) then
									vRP.upgradeHunger(user_id,30)
								end
							end
							Citizen.Wait(0)
						until active[user_id] == nil
					end

					if itemName == "hotdog" then
						active[user_id] = 10
						vRPclient.stopActived(source)
						vCLIENT.closeInventory(source)
						vCLIENT.blockButtons(source,true)
						TriggerClientEvent("Progress",source,10000)
						vRPclient._createObjects(source,"amb@code_human_wander_eating_donut@male@idle_a","idle_c","prop_cs_hotdog_01",49,28422)

						repeat
							if active[user_id] == 0 then
								active[user_id] = nil
								vCLIENT.blockButtons(source,false)
								vRPclient._removeObjects(source,"one")

								if vRP.tryGetInventoryItem(user_id,itemName,1,true,slot) then
									vRP.upgradeHunger(user_id,20)
								end
							end
							Citizen.Wait(0)
						until active[user_id] == nil
					end

					if itemName == "sandwich" then
						active[user_id] = 10
						vRPclient.stopActived(source)
						vCLIENT.closeInventory(source)
						vCLIENT.blockButtons(source,true)
						TriggerClientEvent("Progress",source,10000)
						vRPclient._createObjects(source,"mp_player_inteat@burger","mp_player_int_eat_burger","prop_sandwich_01",49,18905,0.13,0.05,0.02,-50.0,16.0,60.0)

						repeat
							if active[user_id] == 0 then
								active[user_id] = nil
								vCLIENT.blockButtons(source,false)
								vRPclient._removeObjects(source,"one")

								if vRP.tryGetInventoryItem(user_id,itemName,1,true,slot) then
									vRP.upgradeHunger(user_id,20)
								end
							end
							Citizen.Wait(0)
						until active[user_id] == nil
					end

					if itemName == "tacos" then
						active[user_id] = 10
						vRPclient.stopActived(source)
						vCLIENT.closeInventory(source)
						vCLIENT.blockButtons(source,true)
						TriggerClientEvent("Progress",source,10000)
						vRPclient._createObjects(source,"mp_player_inteat@burger","mp_player_int_eat_burger","prop_taco_01",49,18905,0.16,0.06,0.02,-50.0,220.0,60.0)

						repeat
							if active[user_id] == 0 then
								active[user_id] = nil
								vCLIENT.blockButtons(source,false)
								vRPclient._removeObjects(source,"one")

								if vRP.tryGetInventoryItem(user_id,itemName,1,true,slot) then
									vRP.upgradeHunger(user_id,30)
								end
							end
							Citizen.Wait(0)
						until active[user_id] == nil
					end

					if itemName == "fries" then
						active[user_id] = 10
						vRPclient.stopActived(source)
						vCLIENT.closeInventory(source)
						vCLIENT.blockButtons(source,true)
						TriggerClientEvent("Progress",source,10000)
						vRPclient._createObjects(source,"mp_player_inteat@burger","mp_player_int_eat_burger","prop_food_bs_chips",49,18905,0.10,0.0,0.08,150.0,320.0,160.0)

						repeat
							if active[user_id] == 0 then
								active[user_id] = nil
								vCLIENT.blockButtons(source,false)
								vRPclient._removeObjects(source,"one")

								if vRP.tryGetInventoryItem(user_id,itemName,1,true,slot) then
									vRP.upgradeHunger(user_id,20)
								end
							end
							Citizen.Wait(0)
						until active[user_id] == nil
					end

					if itemName == "chocolate" then
						active[user_id] = 10
						vRPclient.stopActived(source)
						vCLIENT.closeInventory(source)
						vCLIENT.blockButtons(source,true)
						TriggerClientEvent("Progress",source,10000)
						vRPclient._createObjects(source,"mp_player_inteat@burger","mp_player_int_eat_burger","prop_choc_ego",49,60309)

						repeat
							if active[user_id] == 0 then
								active[user_id] = nil
								vCLIENT.blockButtons(source,false)
								vRPclient._removeObjects(source,"one")

								if vRP.tryGetInventoryItem(user_id,itemName,1,true,slot) then
									vRP.upgradeHunger(user_id,10)
									vRP.downgradeStress(user_id,10)
								end
							end
							Citizen.Wait(0)
						until active[user_id] == nil
					end

					if itemName == "donut" then
						active[user_id] = 10
						vRPclient.stopActived(source)
						vCLIENT.closeInventory(source)
						vCLIENT.blockButtons(source,true)
						TriggerClientEvent("Progress",source,10000)
	                    vRPclient._createObjects(source,"amb@code_human_wander_eating_donut@male@idle_a","idle_c","prop_amb_donut",49,28422)

						repeat
							if active[user_id] == 0 then
	                            active[user_id] = nil
								vCLIENT.blockButtons(source,false)
								vRPclient._removeObjects(source,"one")

								if vRP.tryGetInventoryItem(user_id,itemName,1,true,slot) then
									vRP.downgradeStress(user_id,8)
									vRP.upgradeHunger(user_id,10)
								end
							end
							Citizen.Wait(0)
						until active[user_id] == nil
					end

					if itemName == "postit" then
						if vRP.tryGetInventoryItem(user_id,itemName,1,true,slot) then
							vCLIENT.closeInventory(source)
							TriggerClientEvent("vrp_notepad:createNotepad",source)
						end
					end

					if itemName == "backpackp" then
						local exp = vRP.getBackpack(user_id)
						if exp < 25 then
							if vRP.tryGetInventoryItem(user_id,itemName,1,true,slot) then
								vRP.setBackpack(user_id,25)
							end
						else
							TriggerClientEvent("Notify",source,"aviso","No momento você não pode usar essa mochila.",5000)
						end
					end

					if itemName == "backpackm" then
						local exp = vRP.getBackpack(user_id)
						if exp >= 25 and exp < 50 then
							if vRP.tryGetInventoryItem(user_id,itemName,1,true,slot) then
								vRP.setBackpack(user_id,50)
							end
						else
							TriggerClientEvent("Notify",source,"aviso","No momento você não pode usar essa mochila.",5000)
						end
					end

					if itemName == "backpackg" then
						local exp = vRP.getBackpack(user_id)
						if exp >= 50 and exp < 75 then
							if vRP.tryGetInventoryItem(user_id,itemName,1,true,slot) then
								vRP.setBackpack(user_id,75)
							end
						else
							TriggerClientEvent("Notify",source,"aviso","No momento você não pode usar essa mochila.",5000)
						end
					end

					if itemName == "backpackx" then
						local exp = vRP.getBackpack(user_id)
						if exp >= 75 and exp < 100 then
							if vRP.tryGetInventoryItem(user_id,itemName,1,true,slot) then
								vRP.setBackpack(user_id,100)
							end
						else
							TriggerClientEvent("Notify",source,"aviso","No momento você não pode usar essa mochila.",5000)
						end
					end

					if itemName == "compost" then
                        local homeEnter = vHOMES.getHomeStatistics(source)
                        if homeEnter == "" then
                            local weWater = vWEPLANTS.checkWater(source)
                            if weWater then
                                TriggerClientEvent("Notify",source,"negado","Só pode ser plantado em terra firme.",3000)
                                return
                            end

                            local weCounts = exports.vrp_weplants:getAmount(user_id)
                            if parseInt(weCounts) >= 50 then
                                TriggerClientEvent("Notify",source,"negado","O limite máximo de plantações foi atingido.",3000)
                                return
                            else
                                local status,x,y,z = vWEPLANTS.entityInWorldCoords(source)
                                if status and vRP.getInventoryItemAmount(user_id,"bucket") >= 1 then
                                    active[user_id] = 5
                                    vRPclient.stopActived(source)
                                    vCLIENT.closeInventory(source)
                                    vCLIENT.blockButtons(source,true)
                                    TriggerClientEvent("Progress",source,5000)
                                    vRPclient._playAnim(source,false,{"anim@amb@clubhouse@tutorial@bkr_tut_ig3@","machinic_loop_mechandplayer"},true)

                                    repeat
                                        if active[user_id] == 0 then
                                            active[user_id] = nil
                                            vRPclient._stopAnim(source,false)
                                            vCLIENT.blockButtons(source,false)

                                            if vRP.tryGetInventoryItem(user_id,itemName,1,true,slot) and vRP.tryGetInventoryItem(user_id,"bucket",1,true) then
                                                vRP.weedTimer(user_id,1)
                                                vRP.upgradeStress(user_id,1)
                                                vWEPLANTS.pressPlants(source,x,y,z)
                                            end
                                        end
                                        Citizen.Wait(0)
                                    until active[user_id] == nil
                                end
                            end
                        end
                    end

					if itemName == "tires" then
						if not vRPclient.inVehicle(source) then
							local vehicle,vehNet = vRPclient.vehList(source,3)
							if vehicle then
								active[user_id] = 30
								vRPclient.stopActived(source)
								vCLIENT.closeInventory(source)
								vCLIENT.blockButtons(source,true)
								vRPclient._playAnim(source,false,{"anim@amb@clubhouse@tutorial@bkr_tut_ig3@","machinic_loop_mechandplayer"},true)

								local taskResult = vTASKBAR.taskTwo(source)
								if taskResult then
									if vRP.tryGetInventoryItem(user_id,itemName,1,true,slot) then
										TriggerClientEvent("vrp_inventory:repairTires",-1,vehNet)
									end
								end

								vCLIENT.blockButtons(source,false)
								vRPclient._stopAnim(source,false)
								active[user_id] = nil
							end
						end
					end

					if itemName == "premiumplate" then
						vCLIENT.closeInventory(source)

						local vehModel = vRP.prompt(source,"Vehicle Model:","")
						if vehModel == "" then
							return
						end

						local vehicle = vRP.Query("vRP/get_vehicles",{ user_id = parseInt(user_id), vehicle = tostring(vehModel) })
						if vehicle[1] then
							local vehPlate = vRP.prompt(source,"Vehicle Plate:","")
							if vehPlate == "" or string.upper(vehPlate) == "SMRP" then
								return
							end

							local plateUserId = vRP.getVehiclePlate(vehPlate)
							if plateUserId then
								TriggerClientEvent("Notify",source,"negado","A placa escolhida já está sendo usada por outro veículo.",5000)
								return
							end

							local plateCheck = sanitizeString(vehPlate,"abcdefghijklmnopqrstuvwxyz0123456789",true)
							if plateCheck and string.len(plateCheck) == 8 then
								if vRP.tryGetInventoryItem(user_id,itemName,1,true,slot) then
									vRP.Query("vRP/update_plate_vehicle",{ user_id = parseInt(user_id), vehicle = tostring(vehModel), plate = string.upper(tostring(vehPlate)) })
									TriggerClientEvent("Notify",source,"sucesso","Placa atualizada com sucesso.",5000)
								end
							else
								TriggerClientEvent("Notify",source,"importante","O nome da definição para placas deve conter no máximo 8 caracteres e podem ser usados números e letras minúsculas.",5000)
							end
						else
							TriggerClientEvent("Notify",source,"negado","Modelo de veículo não encontrado em sua garagem.",5000)
						end
					end

					if itemName == "plate" then
                        if not vRPclient.inVehicle(source) then
                            local vehicle,vehNet = vRPclient.vehList(source,3)
                            if vehicle then
                                active[user_id] = 30
                                vRPclient.stopActived(source)
                                vCLIENT.closeInventory(source)
                                vRPclient._playAnim(source,false,{"anim@amb@clubhouse@tutorial@bkr_tut_ig3@","machinic_loop_mechandplayer"},true)
    
                                local taskResult = vTASKBAR.taskThree(source)
                                if taskResult then
                                    if vRP.tryGetInventoryItem(user_id,itemName,1,true,slot) then
                                    local plate = vRP.genPlate()
                                    vCLIENT.plateApply(source,plate)
                                    TriggerEvent("setPlateEveryone",plate)
                                    TriggerClientEvent("Notify",source,"sucesso","Placa do veiculo clonada.",7000)
                                end
                            else
                                TriggerClientEvent("Notify",source,"negado","Voce falhou.",7000)
                            end
                                vRPclient._stopAnim(source,false)
                                active[user_id] = nil
                            end
                        end
                    end

					if itemName == "fueltech" then
                        local vehicle,vehNet = vRPclient.vehList(source,11)
                        if vehicle then
                        vRPclient.stopActived(source)
                        vCLIENT.closeInventory(source)
                        vRP.createDurability(itemName)

                        local taskResult = vTASKBAR.taskThree(source)
                        if taskResult then
                        vRP.upgradeStress(user_id,2)
                        if vRP.tryGetInventoryItem(user_id,itemName,1,true,slot) then
                        TriggerClientEvent("vrp_admin:vehicleTuning",source)
                        TriggerClientEvent("Notify",source,"aviso","Tech Aplicado com sucesso.",7000)
                            else
                        TriggerClientEvent("Notify",source,"aviso","vocé errou tente novamente.",7000)
                            end
                        end
                     end
                end

					
					
					if itemName == "radio" then
						vRPclient.stopActived(source)
						vCLIENT.closeInventory(source)
						TriggerClientEvent("vrp_radio:openSystem",source)
					end

					if itemName == "divingsuit" then
						if not vRP.wantedReturn(user_id) and not vRP.reposeReturn(user_id) then
							vPLAYER.setDiving(source)
						end
					end

					if itemName == "handcuff" then
						if not vRPclient.inVehicle(source) then
							local nplayer = vRPclient.nearestPlayer(source,2)
							if nplayer then
								if vPLAYER.getHandcuff(nplayer) then
									vPLAYER.toggleHandcuff(nplayer)
									vRPclient._stopAnim(nplayer,false)
									TriggerClientEvent("vrp_sound:source",source,"uncuff",0.5)
									TriggerClientEvent("vrp_sound:source",nplayer,"uncuff",0.5)
								else
									active[user_id] = 30
									local taskResult = vTASKBAR.taskHandcuff(nplayer)
									if not taskResult then
										vPLAYER.toggleHandcuff(nplayer)
										TriggerClientEvent("vrp_sound:source",source,"cuff",0.5)
										TriggerClientEvent("vrp_sound:source",nplayer,"cuff",0.5)
										vRPclient._playAnim(source,false,{"mp_arrest_paired","cop_p2_back_left"},false)
										vRPclient._playAnim(nplayer,false,{"mp_arrest_paired","crook_p2_back_left"},false)
										vRPclient._playAnim(nplayer,true,{"mp_arresting","idle"},true)
									end
									active[user_id] = nil
								end
							end
						end
					end

					if itemName == "hood" then
						local nplayer = vRPclient.nearestPlayer(source,1)
						if nplayer and vPLAYER.getHandcuff(nplayer) then
							TriggerClientEvent("vrp_hud:toggleHood",nplayer)
						end
					end

					if itemName == "rope" then
						local nplayer = vRPclient.nearestPlayer(source,2)
						if nplayer and not vRPclient.inVehicle(source) then
							local taskResult = vTASKBAR.taskHandcuff(nplayer)
							if not taskResult then
								TriggerClientEvent("vrp_rope:toggleRope",source,nplayer)
							else
								TriggerClientEvent("Notify",source,"importante","O cidadao resistiu de ser carregado.",5000)
							end
						end
						
					end

					if itemName == "c4" then
						TriggerClientEvent("vrp_cashmachine:machineRobbery",source)
					end

					if itemName == "premium01" then
						local identity = vRP.getUserIdentity(user_id)
						if identity then
							if vRP.tryGetInventoryItem(user_id,itemName,1,true,slot) then
								if not vRP.getPremium(user_id) then
									vRP.Query("vRP/set_premium",{ steam = identity.steam, premium = parseInt(os.time()), predays = 30, priority = 25 })
								else
									vRP.Query("vRP/update_premium",{ steam = identity.steam, predays = 30 })
								end
							end
						end
					end

					if itemName == "premium02" then
						local identity = vRP.getUserIdentity(user_id)
						if identity then
							if vRP.tryGetInventoryItem(user_id,itemName,1,true,slot) then
								if not vRP.getPremium(user_id) then
									vRP.Query("vRP/set_premium",{ steam = identity.steam, premium = parseInt(os.time()), predays = 30, priority = 45 })
								else
									vRP.Query("vRP/update_premium",{ steam = identity.steam, predays = 30 })
								end
							end
						end
					end

					if itemName == "premium03" then
						local identity = vRP.getUserIdentity(user_id)
						if identity then
							if vRP.tryGetInventoryItem(user_id,itemName,1,true,slot) then
								if not vRP.getPremium(user_id) then
									vRP.Query("vRP/set_premium",{ steam = identity.steam, premium = parseInt(os.time()), predays = 30, priority = 65 })
								else
									vRP.Query("vRP/update_premium",{ steam = identity.steam, predays = 30 })
								end
							end
						end
					end

					if itemName == "premium04" then
						local identity = vRP.getUserIdentity(user_id)
						if identity then
							if vRP.tryGetInventoryItem(user_id,itemName,1,true,slot) then
								if not vRP.getPremium(user_id) then
									vRP.Query("vRP/set_premium",{ steam = identity.steam, premium = parseInt(os.time()), chars = 1, predays = 30, priority = 80 })
								else
									vRP.Query("vRP/update_premium",{ steam = identity.steam, predays = 30 })
								end
							end
						end
	                end

					if itemName == "premium05" then
						local identity = vRP.getUserIdentity(user_id)
						if identity then
							if vRP.tryGetInventoryItem(user_id,itemName,1,true,slot) then
								if not vRP.getPremium(user_id) then
									vRP.Query("vRP/set_premium",{ steam = identity.steam, premium = parseInt(os.time()), chars = 2, predays = 30, priority = 100 })
								else
									vRP.Query("vRP/update_premium",{ steam = identity.steam, predays = 30 })
								end
							end
						end
	                end

					if itemName == "premiumgarage" then
						if vRP.tryGetInventoryItem(user_id,itemName,1,true,slot) then
						    vRP.Query("vRP/update_garages",{ id = parseInt(user_id) })
						    TriggerClientEvent("Notify",source,"negado","Voce adicionou uma vaga na garagem.",5000)
						end
					end

					if itemName == "pager" then
						local nplayer = vRPclient.nearestPlayer(source,2)
						if nplayer then
							local nuser_id = vRP.getUserId(nplayer)
							if nuser_id then
								if vRP.hasPermission(nuser_id,"Police") then
									TriggerClientEvent("radio:outServers",nplayer)
									TriggerEvent("vrp_blipsystem:serviceExit",nplayer)
									vRP.removePermission(vRP.getUserSource(nuser_id),"Police")
									vRP.Query("vRP/upd_group",{ user_id = nuser_id, permiss = "Police", newpermiss = "waitPolice" })
									TriggerClientEvent("Notify",source,"importante","Todas as comunicações da polícia foram retiradas.",5000)
								end
							end
						end
					end
				end

				if vRP.itemTypeList(itemName) == "equip" then
					local pistols =     {"WEAPON_PISTOL_MK2", "WEAPON_COMBATPISTOL", "WEAPON_SKSPISTOL", "WEAPON_PISTOL","WEAPON_APPISTOL","WEAPON_PISTOL50","WEAPON_SNSPISTOL","WEAPON_SNSPISTOL_MK2","WEAPON_HEAVYPISTOL","WEAPON_VINTAGEPISTOL","WEAPON_FLAREGUN","WEAPON_MARKMANPISTOL","WEAPON_REVOLVER","WEAPON_REVOLVER_MK2","WEAPON_DOUBLEACTION","WEAPON_CERAMICPISTOL","WEAPON_NAVYREVOLVER","WEAPON_GADGETPISTOL"}
					local submachine =  {"WEAPON_MICROSMG","WEAPON_SMG","WEAPON_SMG_MK2","WEAPON_ASSAULTSMG","WEAPON_COMBATPDW","WEAPON_MACHINEPISTOL","WEAPON_MINISMG","WEAPON_GUSENBERG"}
					local shotgun =     {"WEAPON_PUMPSHOTGUN","WEAPON_PUMPSHOTGUN_MK2","WEAPON_SAWNOFFSHOTGUN","WEAPON_ASSAULTSHOTGUN","WEAPON_BULLUPSHOTGUN","WEAPON_MUSKET","WEAPON_HEAVYSHOTGUN","WEAPON_DBSHOTGUN","WEAPON_AUTOSHOTGUN","WEAPON_COMBATSHOTGUN" }
					local rifles =      {"WEAPON_ASSAULTRIFLE", "WEAPON_ASSAULTRIFLE_MK2", "WEAPON_CARBINERIFLE","WEAPON_CARBINERIFLE_MK2","WEAPON_ADVANCEDRIFLE", "WEAPON_SPECIALCARBINE","WEAPON_SPECIALCARBINE_MK2","WEAPON_BULLUPRIFLE","WEAPON_BULLUPRIFLE_MK2","WEAPON_COMPACTRFILE","WEAPON_MILITARYRIFLE"}
					local weaponsList = vRPclient.getWeapons(source)
					local weaponName = string.gsub(itemName,"wbody|","")
					if has_value(pistols, weaponName) then
						for k,v in pairs(weaponsList) do
							if has_value(pistols, k) then
								TriggerClientEvent("Notify", source, "negado", "Você já possui uma arma desse tipo equipada.")
								return
							end
						end
					end
					if has_value(submachine, weaponName) then
						for k,v in pairs(weaponsList) do
							if has_value(submachine, k) then
								TriggerClientEvent("Notify", source, "negado", "Você já possui uma arma desse tipo equipada.")
								return
							end
						end
					end
					if has_value(shotgun, weaponName) then
						for k,v in pairs(weaponsList) do
							if has_value(shotgun, k) then
								TriggerClientEvent("Notify", source, "negado", "Você já possui uma arma desse tipo equipada.")
								return
							end
						end
					end
					if has_value(rifles, weaponName) then
						for k,v in pairs(weaponsList) do
							if has_value(rifles, k) then
								TriggerClientEvent("Notify", source, "negado", "Você já possui uma arma desse tipo equipada.")
								return
							end
						end
					end

                    if vRP.tryGetInventoryItem(user_id,itemName,1,true,slot) then
						local weapons = {}
						weapons[string.gsub(itemName,"wbody|","")] = { ammo = 0 }
                        -- vCLIENT.putWeaponHands(source,itemName,0)
						vRPclient._giveWeapons(source,weapons)
                    end
                end

				if vRP.itemTypeList(itemName) == "recharge" then
					local checkWeapon = vCLIENT.rechargeCheck(source,itemName)
							Citizen.Wait(1000)
					if checkWeapon then
						if vRP.tryGetInventoryItem(user_id,itemName,parseInt(rAmount),true,slot) then
							TriggerClientEvent("Progress",source,2000)
							TriggerClientEvent("Notify",source,"importante","VOCÉ RECARREGOU SUA ARMA.",2000)
							Citizen.Wait(2000)
							vCLIENT.rechargeWeapon(source,itemName,parseInt(rAmount))
						end
					end
				end
			end
			TriggerClientEvent("vrp_inventory:Update",source,"updateMochila")
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- SENDITEM
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("vrp_inventory:sendItem")
AddEventHandler("vrp_inventory:sendItem",function(itemName,amount)
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		if active[user_id] == nil and not vPLAYER.getHandcuff(source) then
			if amount == nil then amount = 1 end
			if amount <= 0 then amount = 1 end

			if not vRP.wantedReturn(user_id) then
				local nplayer = vRPclient.nearestPlayer(source,3)
				if nplayer then
					local nuser_id = vRP.getUserId(nplayer)
					if nuser_id then
						if vRP.computeInvWeight(nuser_id) + vRP.itemWeightList(itemName) * parseInt(amount) <= vRP.getBackpack(nuser_id) then
							if vRP.tryGetInventoryItem(user_id,itemName,parseInt(amount),true) then
								vRP.giveInventoryItem(nuser_id,itemName,parseInt(amount),true)
								TriggerClientEvent("vrp_inventory:Update",source,"updateMochila")
								TriggerClientEvent("vrp_inventory:Update",nplayer,"updateMochila")
								vRPclient._playAnim(source,true,{"pickup_object","putdown_low"},false)
								Citizen.Wait(750)
								vRPclient._removeObjects(source)
							end
						    else
							TriggerClientEvent("Notify",source,"negado","Mochila Cheia.",5000)
						end
					end
				end
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- PLAYERLEAVE
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("vRP:playerLeave",function(user_id,source)
	if not vRP.getPremium(user_id) then
		local identity = vRP.getUserIdentity(user_id)
		if identity then
			vRP.Query("vRP/update_priority",{ steam = identity.steam })
		end
	end

	if active[user_id] then
		active[user_id] = nil
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- PLAYERSPAWN
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("vRP:playerSpawn",function(user_id,source)
	TriggerClientEvent("vrp_inventory:dropUpdates",source,dropList)
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP_INVENTORY:CANCEL
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("vrp_inventory:Cancel")
AddEventHandler("vrp_inventory:Cancel",function()
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		if active[user_id] ~= nil and active[user_id] > 0 then
			active[user_id] = nil
			TriggerClientEvent("Progress",source,1500)

			SetTimeout(1000,function()
				vRPclient._removeObjects(source)
				vCLIENT.blockButtons(source,false)
				vGARAGE.updateHotwired(source,false)
			end)
		else
			vRPclient._removeObjects(source)
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- CHECKINVENTORY
-----------------------------------------------------------------------------------------------------------------------------------------
function cRP.checkInventory()
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		if active[user_id] ~= nil and active[user_id] > 0 then
			return false
		end
		return true
	end
end

function has_value (tab, val)
    for index, value in ipairs(tab) do
        if value == val then
            return true
        end
    end
    return false
end