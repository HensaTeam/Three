RegisterCommand("cr",function(source,args)
	local ped = PlayerPedId()
	local veh = GetVehiclePedIsUsing(ped)
	local maxspeed = GetVehicleMaxSpeed(GetEntityModel(veh))
	local vehspeed = GetEntitySpeed(veh) * 2.236936
	if GetPedInVehicleSeat(veh,-1) == ped and math.ceil(vehspeed) >= 5 and not IsEntityInAir(veh) then
		if args[1] == nil then
			SetEntityMaxSpeed(veh,maxspeed)
			TriggerEvent("Notify","sucesso","Controle de cruzeiro desativado.",3000)
		else
			SetEntityMaxSpeed(veh,0.45*args[1]-0.45)
			TriggerEvent("Notify","sucesso","Controle de cruzeiro ativado.",3000)
		end
	end
end)