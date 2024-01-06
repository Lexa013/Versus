VS.SQL.Repositories.IAM = VS.SQL.Repositories.IAM or {}
local db_connection = VS.SQL.Connection

---@return "GetUsergroups", table<table> usergroups
function VS.SQL.Repositories.IAM.GetUsergroupsAsync(callback)
    db_connection:SelectAsync("SELECT * FROM vs_usergroups", callback)
end

---@param name string
---@param power number
function VS.SQL.Repositories.IAM.AddUsergroupAsync(name, power, callback)
    db_connection:ExecuteAsync("INSERT INTO vs_usergroups (name, power) VALUES (:0, :1)", callback, name, power)
end

function VS.SQL.Repositories.IAM.DeleteUsergroupAsync(name, callback)
    db_connection:ExecuteAsync("DELETE FROM vs_usergroups WHERE name = :0", callback, name)
end