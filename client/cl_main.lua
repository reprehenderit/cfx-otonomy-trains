local trains = {}
local trainBlips = {}
local trainModels = {
    "freight",
    "freightcar",
    "freightcar2",
    "freightgrain",
    "freightcont1",
    "freightcont2",
    "tankercar",
    "metrotrain",
    "s_m_m_lsmetro_01"
}

Config = Config or {}

function requestTrainModels()
    for _, model in pairs(trainModels) do
        RequestModel(model)
        while not HasModelLoaded(model) do
            Wait(1)
        end
    end
end

function spawnTrain(x, y, z)
    local train = CreateMissionTrain(24, x, y, z, true)
    SetEntityAsMissionEntity(train, true, true)
    SetEntityCoords(train, x, y, z)
    SetTrainSpeed(train, Config.TrainSpeed)
    SetTrainCruiseSpeed(train, Config.TrainSpeed)

    -- blips
    local blip = nil
    if Config.TrainBlips then
        local blip = AddBlipForEntity(train)
        SetBlipSprite(blip, 36)
        SetBlipColour(blip, 3)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString("Train")
        EndTextCommandSetBlipName(blip)
    end

    return train, blip
end

RegisterNetEvent('trains:spawn')
AddEventHandler('trains:spawn', function (data)
    print("Spawning train at coordinates:", data.x, data.y, data.z)
    requestTrainModels()
    local train, blip = spawnTrain(data.x, data.y, data.z)
    trains[data.id] = train
    trainBlips[data.id] = blip
end)

RegisterNetEvent('trains:sync')
AddEventHandler('trains:sync', function (data)
    print("Syncing train with ID:", data.id)
    requestTrainModels()
    if not trains[data.id] then
        trains[data.id], trainBlips[data.id] = spawnTrain(data.x, data.y, data.z)
    end
    SetEntityCoords(trains[data.id], data.x, data.y, data.z)
    SetTrainSpeed(trains[data.id], data.speed)
    SetTrainCruiseSpeed(trains[data.id], data.speed)
end)

RegisterNetEvent('trains:delete')
AddEventHandler('trains:delete', function(id)
    if trains[id] then
        DeleteMissionTrain(trains[id])
        if trainBlips[id] then
            RemoveBlip(trainBlips[id])
            trainBlips[id] = nil
        end
        trains[id] = nil
    end
end)

Citizen.CreateThread(function ()
    requestTrainModels()
    while true do
        Wait(1000)
        for id, train in pairs(trains) do
            if DoesEntityExist(train) then
                local coords = GetEntityCoords(train)
                local speed  = 20.0
                TriggerServerEvent('trains:update', {id = id, x = coords.x, y = coords.y, z = coords.z, speed = speed})
            end
        end
    end
end)

AddEventHandler('playerSpawned', function()
    TriggerServerEvent('trains:playerReady')
end)