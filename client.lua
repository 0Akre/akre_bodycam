local QBCore = exports['qb-core']:GetCoreObject()

local displayBodycam = false
local displayBackground = false

RegisterCommand("bodycam", function()
    local playerData = QBCore.Functions.GetPlayerData()
    local jobName = playerData.job.name

    if (jobName == "police" or jobName == "sheriff" or jobName == "sahp") then
        displayBodycam = not displayBodycam
        local playerName = playerData.charinfo.firstname .. " " .. playerData.charinfo.lastname

        SendNUIMessage({
            type = "updateBodycam",
            playerName = playerName,
            display = displayBodycam,
            background = displayBackground
        })
    else
        exports.ox_lib:notify({
            title = "Bodycam",
            description = "You do not have permission to show/hide the bodycam because you are not a state authority or are not on duty!",
            type = "error"
        })
    end
end, false)

RegisterCommand("bodycamb", function()
    if displayBodycam then
        displayBackground = not displayBackground
        SendNUIMessage({
            type = "updateBodycam",
            background = displayBackground
        })
    else
        exports.ox_lib:notify({
            title = "Bodycam",
            description = "The bodycam must be turned on before enabling the background!",
            type = "error"
        })
    end
end, false)

RegisterNetEvent('QBCore:Client:OnJobUpdate', function(job)
    if (job.name == "police" or job.name == "sheriff" or job.name == "sahp") then
        displayBodycam = true
        local playerData = QBCore.Functions.GetPlayerData()
        local playerName = playerData.charinfo.firstname .. " " .. playerData.charinfo.lastname

        SendNUIMessage({
            type = "updateBodycam",
            playerName = playerName,
            display = displayBodycam,
            background = displayBackground
        })
    else
        displayBodycam = false
        SendNUIMessage({
            type = "updateBodycam",
            display = false,
            background = false
        })
    end
end)

RegisterNetEvent('QBCore:Client:OnPlayerUnload', function()
    displayBodycam = false
    SendNUIMessage({
        type = "updateBodycam",
        display = false,
        background = false
    })
end)

RegisterNetEvent('QBCore:Client:OnPlayerLoaded', function()
    local playerData = QBCore.Functions.GetPlayerData()

    if playerData and playerData.charinfo and playerData.job then
        local jobName = playerData.job.name

        if (jobName == "police" or jobName == "sheriff" or jobName == "sahp") then
            displayBodycam = true
            local playerName = playerData.charinfo.firstname .. " " .. playerData.charinfo.lastname

            SendNUIMessage({
                type = "updateBodycam",
                playerName = playerName,
                display = displayBodycam,
                background = displayBackground
            })
        else
            displayBodycam = false
            SendNUIMessage({
                type = "updateBodycam",
                display = false,
                background = false
            })
        end
    else
        displayBodycam = false
        SendNUIMessage({
            type = "updateBodycam",
            display = false,
            background = false
        })
    end
end)

CreateThread(function()
    SendNUIMessage({
        type = "updateBodycam",
        display = false,
        background = false,
        playerName = ""
    })
end)