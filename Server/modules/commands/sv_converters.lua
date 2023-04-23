local commands = VS.Commands

commands.RegisterConverter("number", function(text, caller)
    local num = tonumber(text)

    if (num) then
        return num
    end

    return nil
end)

commands.RegisterConverter("string", function(text, caller)
    return text
end)

commands.RegisterConverter("player", function(text, caller)
    if (text == "*") then return Player.GetAll() end
    if (text == "^") then return { caller } end

    local integer = tonumber(text)

    if (not integer) then return nil end

    if (string.len(text) > 5 ) then
        if (VS.Players[integer]) then
            return { VS.Players[integer] }
        end
    else
        for _, v in pairs(Player.GetAll()) do
            if (v:GetID() == integer) then
                return { v }
            end
        end
    end

    return nil
end)