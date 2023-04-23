VS.Commands.Cooldown = VS.Commands.Cooldown or {}
VS.Commands.Cooldown.Player = VS.Commands.Cooldown.Player or {}
VS.Commands.Cooldown.Server = VS.Commands.Cooldown.Server or {}

function VS.Commands.Cooldown.HandlePersistentCooldown(command_name, command_config, converted_args, executor)
    local db_connection = VS.SQL.Connection
    local unix_time = os.time(os.date("!*t"))

    if (command_config.cooldown_bucket == VS.CooldownBucket.Player) then
        -- player bucket
    else
        -- server bucket
    end
end

function VS.Commands.Cooldown.HandleCooldown(command_name, command_config, converted_args, executor)
    local unix_time = os.time(os.date("!*t"))

    if (command_config.cooldown_bucket == VS.CooldownBucket.Player) then

        if (not VS.Commands.Cooldown.Player[executor:GetSteamID()]) then
            VS.Commands.Cooldown.Player[executor:GetSteamID()] = {}
        end

        local player_cooldowns = VS.Commands.Cooldown.Player[executor:GetSteamID()]

        if (player_cooldowns[command_name]) then
            local current_cooldown = player_cooldowns[command_name]

            if (current_cooldown + command_config.cooldown > unix_time) then
                local time_remaining = math.abs(unix_time - (current_cooldown + command_config.cooldown))

                Server.SendChatMessage(executor, "This command is in cooldown, please wait another ".. time_remaining .." seconds.")
                return
            end
        end
        
        player_cooldowns[command_name] = unix_time
        VS.Commands.ExecuteCommand(command_name, executor, table.unpack(converted_args)) 
    else
        local server_cooldowns = VS.Commands.Cooldown.Server

        if (server_cooldowns[command_name]) then
            local current_cooldown = server_cooldowns[command_name]

            if (current_cooldown + command_config.cooldown > unix_time) then
                local time_remaining = math.abs(unix_time - (current_cooldown + command_config.cooldown))

                Server.SendChatMessage(executor, "This command is in global cooldown, please wait another ".. time_remaining .." seconds.")
                return
            end
        end

        server_cooldowns[command_name] = unix_time
        VS.Commands.ExecuteCommand(command_name, executor, table.unpack(converted_args))
    end
    
end