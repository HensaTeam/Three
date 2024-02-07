RegisterCommand("polystart", function(src, args)
  local name = args[1]
  if name == nil then
    TriggerEvent('chat:addMessage', {
      color = { 255, 0, 0},
      multiline = true,
      args = {"Me", "Please add a name!"}
    })
    return
  end

  TriggerEvent("polyzone:polystart", name)
end)

RegisterCommand("polyadd", function(src, args)
  TriggerEvent("polyzone:polyadd")
end)

RegisterCommand("polyundo", function(src, args)
  TriggerEvent("polyzone:polyundo")
end)

RegisterCommand("polyfinish", function(src, args)
  TriggerEvent("polyzone:polyfinish")
end)

RegisterCommand("polycancel", function(src, args)
  TriggerEvent("polyzone:polycancel")
end)