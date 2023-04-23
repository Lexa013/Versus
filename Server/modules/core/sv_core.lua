VS.Players = VS.Players or {}

local user_repository = VS.SQL.Repositories.User

-- Player data received
Events.Subscribe("SQL::QueryResult", function(dataName, data, steamid, _, __)
    if (dataName ~= "PlayerData") then return end
    local current_player = VS.Players[steamid]
    
    current_player:SetValue("PlayerData", {}, true)

    -- Contains: IP: Last time seen, First connection, 
    current_player:SetValue("SensitivePlayerdata", data, false)

    print(NanosUtils.Dump(data))

    user_repository.UpdateColumn("username", steamid, current_player:GetAccountName())
    user_repository.UpdateColumn("ip", steamid, current_player:GetIP())
end)

-- User creation suceed
Events.Subscribe("SQL::QueryResult", function(dataName, steamid, _, __, ___)
    if (dataName ~= "UserCreated") then return end
    user_repository.FetchData(steamid, true)
end)

-- Player joins check if 
Player.Subscribe("Ready", function(player)
    local steamid = player:GetSteamID()
    local id = player:GetID() 

    VS.Players[steamid] = player

    local exists = user_repository.IsExistingSync(steamid)

    if (not exists) then
       user_repository.CreateUser(steamid, player:GetIP())
       return
    end

    user_repository.FetchData(steamid, true)
end)

Player.Subscribe("Destroy", function(player)
    VS.Players[player:GetSteamID()] = nil
end)

VS.Commands.Register("test", function(caller, integer, players, reason)
    Server.BroadcastChatMessage(caller:GetName() .."choosed ".. integer .."and there is ".. #players .." on the server because ".. reason)
end)

VS.Commands.Register("listgroups", function(caller)
    VS.SQL.Repositories.IAM.GetUsergroups()
    local result

    result = Events.Subscribe("SQL::QueryResult", function(name, data)
        if (name ~= "IAM.GetUsergroups") then return end
        
        Server.SendChatMessage(caller, "List of existing usergroups")

        local text = ""
        for k, v in ipairs(data) do
            text = text .."\t- ".. v["name"] .."\n"
        end

        Server.SendChatMessage(caller, text)
        Events.Unsubscribe("SQL::QueryResult", result)
    end)
end)

VS.Commands.Register("addusergroup", function(caller, name, power)
    VS.SQL.Repositories.IAM.AddUsergroup(name, power)
    local result

    result = Events.Subscribe("SQL::QueryResult", function(name, usergroup_name)
        if (name ~= "IAM.AddUserGroup") then return end
        
        if (usergroup_name) then
            Server.SendChatMessage(caller, "Success, the ".. usergroup_name .." group has been created !")
        else
            Server.SendChatMessage(caller, "Something when wrong, the specified usergroup may already exist !")
        end

        Events.Unsubscribe("SQL::QueryResult", result)
    end)
end)