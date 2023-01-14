local playerOptin = {}
local enableplayerids = false
ESX = nil

local currentAmbu = 0
local currentMech = 0

CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Wait(0)
	end
end)

-- Code

RegisterNetEvent('QBCore:Client:OnPlayerLoaded')
AddEventHandler('QBCore:Client:OnPlayerLoaded', function()
    isLoggedIn = true

    ESX.TriggerServerCallback('qb-scoreboard:server:GetConfig', function(config)
        Config.IllegalActions = config
    end)
end)

local scoreboardOpen = false

RegisterCommand("scoreboard", function()
    if not scoreboardOpen then
        ESX.TriggerServerCallback('qb-scoreboard:server:GetActiveCops', function(cops)
            Config.CurrentCops = cops
            ESX.TriggerServerCallback('qb-scoreboard:server:GetActiveAmbulance', function(ambulance)
                currentAmbu = ambulance
                ESX.TriggerServerCallback('qb-scoreboard:server:GetActiveMechanic', function(mechanic)
                currentMech = mechanic
                    SendNUIMessage({
                        action = "open",
                        players = GetCurrentPlayers(),
                        maxPlayers = Config.MaxPlayers,
                        requiredCops = Config.IllegalActions,
                        currentCops = Config.CurrentCops,
                        currentAmbu = currentAmbu,
                        currentMech = currentMech,
                    })
                    scoreboardOpen = true
                    enableplayerids = true

                end)
            end)
        end)
    else
        SendNUIMessage({
            action = "close",
        })
        scoreboardOpen = false
        enableplayerids = false
    end
end, false)

function GetCurrentPlayers()
    local TotalPlayers = 0

    for _, player in ipairs(GetActivePlayers()) do
        TotalPlayers = TotalPlayers + 1
    end

    return TotalPlayers
end

RegisterNetEvent('qb-scoreboard:client:SetActivityBusy')
AddEventHandler('qb-scoreboard:client:SetActivityBusy', function(activity, busy)
    Config.IllegalActions[activity].busy = busy
end)

RegisterKeyMapping('scoreboard', 'Alternar panel de disponibilidad y usuarios', 'keyboard', 'F9')



---------------------------------------------- IDS ABOVE HEAD (PITOS CALIENTES) ------------------------------------------------

-- Functions

local function DrawText3D(x, y, z, text)
	SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(true)
    AddTextComponentString(text)
    SetDrawOrigin(x,y,z, 0)
    DrawText(0.0, 0.0)
    ClearDrawOrigin()
end

local function GetPlayers()
    local players = {}
    local activePlayers = GetActivePlayers()
    for i = 1, #activePlayers do
        local player = activePlayers[i]
        local ped = GetPlayerPed(player)
        if DoesEntityExist(ped) then
            players[#players+1] = player
        end
    end
    return players
end

local function GetPlayersFromCoords(coords, distance)
    local players = GetPlayers()
    local closePlayers = {}

	coords = coords or GetEntityCoords(PlayerPedId())
    distance = distance or  5.0

    for i = 1, #players do
        local player = players[i]
		local target = GetPlayerPed(player)
		local targetCoords = GetEntityCoords(target)
		local targetdistance = #(targetCoords - vector3(coords.x, coords.y, coords.z))
		if targetdistance <= distance then
            closePlayers[#closePlayers+1] = player
		end
    end

    return closePlayers
end

RegisterCommand('ids', function()
    if not enableplayerids then
        enableplayerids = true
    elseif enableplayerids then
        enableplayerids = false
    end
end)


CreateThread(function()
    while true do
        local loop = 1000
        if enableplayerids then
            for _, player in pairs(GetPlayersFromCoords(GetEntityCoords(PlayerPedId()), 10.0)) do
                local playerId = GetPlayerServerId(player)
                local playerPed = GetPlayerPed(player)
                local playerCoords = GetEntityCoords(playerPed)
                if enableplayerids then
                    loop = 0
                    DrawText3D(playerCoords.x, playerCoords.y, playerCoords.z + 1.0, '[ '..playerId..' ]')
                end
            end
        end
        Wait(loop)
    end
end)

---------------------------------------------- IDS ABOVE HEAD (PITOS CALIENTES) ------------------------------------------------