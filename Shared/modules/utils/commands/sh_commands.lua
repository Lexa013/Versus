VS.CooldownBucket = {
    Player = 1,
    Server = 2,
}

VS.Commands = {
    ["test"] = {
        description = "This is a test command",
        cooldown_bucket = VS.CooldownBucket.Server,
        cooldown = 10,
        persistent_cooldown = false,
        args = {
            [1] = {
                name = "num",
                description = "A random number",
                type = "number",
            },
            [2] = {
                name = "player",
                description = "A cool player",
                type = "player",
            },
            [3] = {
                name = "reason",
                description = "A nice reason",
                type = "string",
                default = "No reason given"
            },
        }
    },

    ["listgroups"] = {
        description = "Get the usergroups",
    },

    ["addusergroup"] = {
        description = "Get the usergroups",
        args = {
            [1] = {
                name = "name",
                type = "string"
            },
            [2] = {
                name = "power",
                type = "number"
            }
        }
    },
}