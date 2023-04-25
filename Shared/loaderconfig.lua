VS.Modules = {
    [1] = {
        displayName = "Utils";
        pathName = "utils";
        files = {
            shared = {
                "sh_stringutils.lua"
            },
            server = {
                "sv_triggerutils.lua"
            },
            client = {
                
            },
        }
    },
    [2] = {
        displayName = "Database";
        pathName = "database";
        files = {
            shared = {
            },
            server = {
                "sv_migrations.lua",
                "sv_database.lua",
                "/repositories/user_repository.lua",
                "/repositories/cooldown_repository.lua",
                "/repositories/iam_repository.lua"
            },
            client = {
            },
        }
    },
    [3] = {
        displayName = "Identity & Access Management";
        pathName = "iam";
        files = {
            shared = {
            },
            server = {
                "sv_iam.lua"
            },
            client = {
            },
        }
    },
    [4] = {
        displayName = "Commands";
        pathName = "commands";
        files = {
            shared = {
                "sh_commandsconfigs.lua"
            },
            server = {
                "sv_commands.lua",
                "sv_cooldownhandler.lua",
                "sv_converters.lua",
            },
            client = {
            },
        }
    },
    [5] = {
        displayName = "Core module";
        pathName = "core";
        files = {
            shared = {
            },
            server = {
                "sv_functions.lua",
                "sv_core.lua",
            },
            client = {
                "cl_core.lua"
            },
        }
    },
}