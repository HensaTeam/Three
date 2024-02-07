-----------------------------------------------------------------------------------------------------------------------------------------
-- ADDBLIPS
-----------------------------------------------------------------------------------------------------------------------------------------
function tvRP.addBlips(x,y,z,sprite,color,text,scale,route)
	local blip = AddBlipForCoord(x,y,z)
	SetBlipSprite(blip,sprite)
	SetBlipAsShortRange(blip,true)
	SetBlipColour(blip,color)
	SetBlipScale(blip,scale)

	if route then
		SetBlipRoute(blip,true)
	end

	if text then
		BeginTextCommandSetBlipName("STRING")
		AddTextComponentString(text)
		EndTextCommandSetBlipName(blip)
	end

	return blip
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- ADDBLIPSALPHA
-----------------------------------------------------------------------------------------------------------------------------------------
function tvRP.addBlipsAlpha(x,y,z,color)
	local blip = AddBlipForRadius(x,y,z,100.0)
	SetBlipHighDetail(blip,true)
	SetBlipColour(blip,color)
	SetBlipAlpha(blip,150)
	SetBlipAsShortRange(blip,true)

	return blip
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- REMOVEBLIP
-----------------------------------------------------------------------------------------------------------------------------------------
function tvRP.removeBlips(id)
	if DoesBlipExist(id) then
		RemoveBlip(id)
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- PLAYSOUND
-----------------------------------------------------------------------------------------------------------------------------------------
function tvRP.playSound(dict,name)
	PlaySoundFrontend(-1,dict,name,false)
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- GETMODELPLAYER
-----------------------------------------------------------------------------------------------------------------------------------------
function tvRP.getModelPlayer()
	local ped = PlayerPedId()
	if GetEntityModel(ped) == GetHashKey("mp_m_freemode_01") then
		return "mp_m_freemode_01"
	elseif GetEntityModel(ped) == GetHashKey("mp_f_freemode_01") then
		return "mp_f_freemode_01"
	elseif GetEntityModel(ped) == GetHashKey("s_f_y_scrubs_01") then
		return "s_f_y_scrubs_01"
	end
end