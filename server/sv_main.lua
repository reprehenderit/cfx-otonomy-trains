local trainData = {}
local playerCount = 0

Config = Config or {}

local function initializeTrains()
    for id, data in ipairs(Config.TrainSpawns) do
        data.id = id
        trainData[id] = data
        TriggerClientEvent('trains:spawn', -1, data)
        print("Initialized train with ID:", id, "Coordinates:", data.x, data.y, data.z)
    end
end

local function deleteAllTrains()
    for id, data in pairs(trainData) do
        TriggerClientEvent('trains:delete', -1, id)
        print("Deleted train with ID:", id)
    end
    trainData = {}
end

RegisterServerEvent('trains:update')
AddEventHandler('trains:update', function(data)
    trainData[data.id] = data
    TriggerClientEvent('trains:sync', -1, data)
end)

AddEventHandler('playerDropped', function()
    playerCount = math.max(playerCount - 1, 0)
    if playerCount == 0 then
        deleteAllTrains()
    end
end)

RegisterNetEvent('trains:playerReady')
AddEventHandler('trains:playerReady', function()
    playerCount = playerCount + 1
    if playerCount == 1 then
        print("Initializing trains.")
        initializeTrains()
    end
end)

AddEventHandler('onResourceStart', function(resourceName)
    if GetCurrentResourceName() == resourceName then
        playerCount = 0
    end
end)