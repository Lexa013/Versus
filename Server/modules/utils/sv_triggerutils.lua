-- Code might be useless since Trigger can now be used on client side

--[[ local function CheckValidity(trigger, actor_triggering, enteredTrigger)
    local canTrigger = trigger:GetValue("canTrigger")
    local authors = trigger:GetValue("authors")
    local identifier = trigger:GetValue("identifier")

    local shouldActorTrigger = false;

    if (not canTrigger) then
        goto skipCheck
    end

    ::invalidRef::

    for k, v in ipairs(canTrigger) do
        if (not v:IsValid()) then
            canTrigger[k] = nil
            goto invalidRef
        end

        if (v:GetType() == "Player") then
            if (actor_triggering:GetType() ~= "Character") then return end

            -- Return a player or nil whether the char is controlled by a player
            local charPlayer = actor_triggering:GetPlayer()

            if (charPlayer == v) then
                shouldActorTrigger = true;
                break
            end
        else 
            if (v == actor_triggering) then
                shouldActorTrigger = true
                break
            end
        end
    end

    if (not shouldActorTrigger) then return end

    ::skipCheck::

    ::invalidAuthor::
    for k, v in ipairs(authors or Player.GetAll()) do
        if (authors and not v:IsValid()) then
            authors[k] = nil
            goto invalidAuthor
        end
        
        if(enteredTrigger) then
            Events.CallRemote("PlayerEnteredTrigger", v, trigger, actor_triggering)
        else
            Events.CallRemote("PlayerExitedTrigger", v, trigger, actor_triggering)
        end
    end
end

function Trigger:NotifyPlayer(triggerIdentifier, canTrigger, authors)
    if (type(triggerIdentifier) ~= "string") then return end

    self:SetValue("identifier", triggerIdentifier, true)
    self:SetValue("canTrigger", canTrigger, false)
    self:SetValue("authors", authors, false)

    self:Subscribe("BeginOverlap", function(trigger, actor_triggering)
        CheckValidity(trigger, actor_triggering, true)
    end)

    self:Subscribe("EndOverlap", function(trigger, actor_triggering)
        CheckValidity(trigger, actor_triggering, false)
    end)
end
 ]]