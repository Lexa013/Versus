VS.Commands= VS.Commands or {}
VS.Commands.Configurations = VS.Commands.Configurations or {}

VS.CooldownBucket = {
    Player = 1,
    Server = 2,
}

function VS.Commands.RegisterCommandConfiguration(command_name, config)
    VS.Commands.Configurations[command_name] = config
end

VS.Commands.RegisterCommandConfiguration("listgroups", {
    description = "Get the usergroups",
})

VS.Commands.RegisterCommandConfiguration("spawn", {
    description = "Spawn",
})