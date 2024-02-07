RegisterServerEvent("vrp_tackle:Update")
AddEventHandler("vrp_tackle:Update",function(Tackled,ForwardVectorX,ForwardVectorY,ForwardVectorZ,Tackler)
	TriggerClientEvent("vrp_tackle:Player",Tackled,ForwardVectorX,ForwardVectorY,ForwardVectorZ,Tackler)
end)