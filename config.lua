Config = Config or {}

Config.MaxPlayers = GetConvarInt('sv_maxclients', 64)

Config.IllegalActions = {
    ["policia"] = {
        minimum = 1,
        busy = false,
    },
    ["badus"] = {
        minimum = 2,
        busy = false,
    },
    ["joyeria"] = {
        minimum = 5,
        busy = false,
    },
    ["humane"] = {
        minimum = 5,
        busy = false,
    },
    ["bancos"] = {
        minimum = 5,
        busy = false,
    },
}

Config.CurrentCops = 0
