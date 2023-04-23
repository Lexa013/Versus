local posUi = WebUI("Position", "file://ui/position/index.html", false)

local tickEvent

Events.Subscribe("PlayerEnteredTrigger", function(trigger, actor_triggering)
    if (trigger:GetValue("identifier") ~= "pos") then return end

    posUi:SetVisible(true)

    tickEvent = Client.Subscribe("Tick", function (delta_time)
        local charPos = Client.GetLocalPlayer():GetControlledCharacter():GetLocation()
     
        if (charPos ~= nil) then
            posUi:CallEvent("UpdateCharPos", tostring(charPos))
        end
    end)
end)

Events.Subscribe("PlayerExitedTrigger", function(trigger, actor_triggering)
    if (trigger:GetValue("identifier") ~= "pos") then return end

    Events.Unsubscribe("Tick", tickEvent)
    posUi:SetVisible(false)
end)