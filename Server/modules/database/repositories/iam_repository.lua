VS.SQL.Repositories.IAM = VS.SQL.Repositories.IAM or {}
local db_connection = VS.SQL.Connection

---@async
---@return "GetUsergroups", table<table> usergroups
function VS.SQL.Repositories.IAM.GetUsergroups()
    db_connection:Select("SELECT * FROM vs_usergroups", function(data)
        Events.Call("SQL::QueryResult", "IAM.GetUsergroups", data)
    end)
end


---@async
---@param name string
---@param power number
function VS.SQL.Repositories.IAM.AddUsergroup(name, power)
    db_connection:Execute("INSERT INTO vs_usergroups (name, power) VALUES (:0, :1)", function(data, error)
        -- Tell that the usergroup has been created
        local result

        if(not error) then
            result = name
        end

        Events.Call("SQL::QueryResult", "IAM.AddUserGroup", result )
    end, name, power)
end