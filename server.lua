ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

ESX.RegisterServerCallback('qb-scoreboard:server:GetActiveCops', function(source, cb)
    local retval = 0

    for k, v in pairs(ESX.GetPlayers()) do
        local Player = ESX.GetPlayers(v)
        local _source = source
        local xPlayer = ESX.GetPlayerFromId(_source)
        
        if Player ~= nil then
            if xPlayer.job.name == "police" then
                retval = retval + 1
            end
        end
    end

    cb(retval)
end)

ESX.RegisterServerCallback('qb-scoreboard:server:GetActiveAmbulance', function(source, cb)
    local ambulance = 0

    for k, v in pairs(ESX.GetPlayers()) do
        local Player = ESX.GetPlayers(v)
        local _source = source
        local xPlayer = ESX.GetPlayerFromId(_source)
        
        if Player ~= nil then
            if xPlayer.job.name == "ambulance" then
                ambulance = ambulance + 1
            end
        end
    end

    cb(ambulance)
end)

ESX.RegisterServerCallback('qb-scoreboard:server:GetActiveMechanic', function(source, cb)
    local mechanic = 0

    for k, v in pairs(ESX.GetPlayers()) do
        local Player = ESX.GetPlayers(v)
        local _source = source
        local xPlayer = ESX.GetPlayerFromId(_source)
        
        if Player ~= nil then
            if xPlayer.job.name == "mechanic" then
                mechanic = mechanic + 1
            end
        end
    end

    cb(mechanic)
end)

ESX.RegisterServerCallback('qb-scoreboard:server:GetConfig', function(source, cb)
    cb(Config.IllegalActions)
end)

RegisterServerEvent('qb-scoreboard:server:SetActivityBusy')
AddEventHandler('qb-scoreboard:server:SetActivityBusy', function(activity, bool)
    Config.IllegalActions[activity].busy = bool
    TriggerClientEvent('qb-scoreboard:client:SetActivityBusy', -1, activity, bool)
end)