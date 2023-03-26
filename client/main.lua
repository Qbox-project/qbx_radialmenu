QBCore = exports['qb-core']:GetCoreObject()
PlayerData = QBCore.Functions.GetPlayerData()

-- Functions
local function convert(table)
    if table.items then
        local items = {}
        for _, v in pairs(table.items) do
            items[#items+1] = convert(v)
        end
        lib.registerRadial({
            id = table.id..'_menu',
            items = items
        })
        return { id = table.id, label = table.title or table.label, icon = table.icon, menu = table.id..'_menu' }
    end
    local action
    if table.event then
        if table.type == 'client' then
            action = function() TriggerEvent(table.event, table.arg or nil) end
        elseif table.type == 'server' then
            action = function() TriggerServerEvent(table.event, table.arg or nil) end
        elseif table.action then
            action = function() table.action(table.arg) end
        end
    end
    if table.command then
        if table.type == 'command' then
            action = function() ExecuteCommand(v.event) end
        elseif table.type == 'qbcommand' then
            action = function() TriggerServerEvent('QBCore:CallCommand', table.event, table.arg or nil) end
        end
    end
    local onSelect = table.onSelect or function()
        if action then action() end
        if table.shouldClose then lib.hideRadial() end
    end
    return { id = table.id, label = table.title or table.label, icon = table.icon, onSelect = onSelect }
end

local function getNearestVeh()
    local pos = GetEntityCoords(PlayerPedId())
    local entityWorld = GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0.0, 20.0, 0.0)
    local rayHandle = CastRayPointToPoint(pos.x, pos.y, pos.z, entityWorld.x, entityWorld.y, entityWorld.z, 10, PlayerPedId(), 0)
    local _, _, _, _, vehicleHandle = GetRaycastResult(rayHandle)
    return vehicleHandle
end

local function SetupRadialMenu()
    for _, v in pairs(Config.MenuItems) do
        lib.addRadialItem(convert(v))
    end
    if PlayerData.job.onduty then
        if Config.JobInteractions[PlayerData.job.name] then
            lib.addRadialItem(convert({
                id = 'jobinteractions',
                label = 'Travail',
                icon = 'briefcase',
                items = Config.JobInteractions[PlayerData.job.name]
            }))
        end
    end
    if Config.GangInteractions[PlayerData.gang.name] then
        lib.addRadialItem(convert({
            id = 'ganginteractions',
            label = 'Gang',
            icon = 'skull-crossbones',
            items = Config.GangInteractions[PlayerData.gang.name]
        }))

    end
end

local function IsPolice()
    return (PlayerData.job.type == "leo" and PlayerData.job.onduty == true)
end

local function IsEMS()
    return (PlayerData.job.type == "medic" and PlayerData.job.onduty == true)
end

-- Events
RegisterNetEvent('radialmenu:client:deadradial', function(isDead)
    if isDead then
        local ispolice, isems = IsPolice(), IsEMS()
        if not ispolice or isems then return lib.disableRadial(true) end
        lib.clearRadialItems()
        lib.addRadialItem({
            id = 'emergencybutton2',
            label = Lang:t("options.emergency_button"),
            icon = 'circle-exclamation',
            onSelect = function (_, _)
                if ispolice then
                    TriggerEvent('police:client:SendPoliceEmergencyAlert')
                elseif isems then
                    TriggerEvent('ambulance:client:SendAmbulanceEmergencyAlert')
                end
                lib.hideRadial()
            end
        })
    else
        lib.disableRadial(false)
    end
end)

RegisterNetEvent('qb-radialmenu:client:ChangeSeat', function(data)
    local Veh = GetVehiclePedIsIn(PlayerPedId())
    local IsSeatFree = IsVehicleSeatFree(Veh, data.id)
    local speed = GetEntitySpeed(Veh)
    local HasHarnass = exports['qb-smallresources']:HasHarness()
    if not HasHarnass then
        local kmh = speed * 3.6
        if IsSeatFree then
            if kmh <= 100.0 then
                SetPedIntoVehicle(PlayerPedId(), Veh, data.id)
                QBCore.Functions.Notify(Lang:t("info.switched_seats", {seat = data.title}))
            else
                QBCore.Functions.Notify(Lang:t("error.vehicle_driving_fast"), 'error')
            end
        else
            QBCore.Functions.Notify(Lang:t("error.seat_occupied"), 'error')
        end
    else
        QBCore.Functions.Notify(Lang:t("error.race_harness_on"), 'error')
    end
end)

RegisterNetEvent('qb-radialmenu:trunk:client:Door', function(plate, door, open)
    local veh = GetVehiclePedIsIn(PlayerPedId())
    if veh ~= 0 then
        local pl = QBCore.Functions.GetPlate(veh)
        if pl == plate then
            if open then
                SetVehicleDoorOpen(veh, door, false, false)
            else
                SetVehicleDoorShut(veh, door, false)
            end
        end
    end
end)

RegisterNetEvent('qb-radialmenu:client:noPlayers', function()
    QBCore.Functions.Notify(Lang:t("error.no_people_nearby"), 'error', 2500)
end)

RegisterNetEvent('qb-radialmenu:client:openDoor', function(data)
    local string = data.id
    local replace = string:gsub("door", "")
    local door = tonumber(replace)
    local ped = PlayerPedId()
    local closestVehicle = GetVehiclePedIsIn(ped) ~= 0 and GetVehiclePedIsIn(ped) or getNearestVeh()
    if closestVehicle ~= 0 then
        if closestVehicle ~= GetVehiclePedIsIn(ped) then
            local plate = QBCore.Functions.GetPlate(closestVehicle)
            if GetVehicleDoorAngleRatio(closestVehicle, door) > 0.0 then
                if not IsVehicleSeatFree(closestVehicle, -1) then
                    TriggerServerEvent('qb-radialmenu:trunk:server:Door', false, plate, door)
                else
                    SetVehicleDoorShut(closestVehicle, door, false)
                end
            else
                if not IsVehicleSeatFree(closestVehicle, -1) then
                    TriggerServerEvent('qb-radialmenu:trunk:server:Door', true, plate, door)
                else
                    SetVehicleDoorOpen(closestVehicle, door, false, false)
                end
            end
        else
            if GetVehicleDoorAngleRatio(closestVehicle, door) > 0.0 then
                SetVehicleDoorShut(closestVehicle, door, false)
            else
                SetVehicleDoorOpen(closestVehicle, door, false, false)
            end
        end
    else
        QBCore.Functions.Notify(Lang:t("error.no_vehicle_found"), 'error', 2500)
    end
end)

RegisterNetEvent('qb-radialmenu:client:setExtra', function(data)
    local string = data.id
    local replace = string:gsub("extra", "")
    local extra = tonumber(replace)
    local ped = PlayerPedId()
    local veh = GetVehiclePedIsIn(ped)
    if veh ~= nil then
        if GetPedInVehicleSeat(veh, -1) == ped then
            SetVehicleAutoRepairDisabled(veh, true) -- Forces Auto Repair off when Toggling Extra [GTA 5 Niche Issue]
            if DoesExtraExist(veh, extra) then
                if IsVehicleExtraTurnedOn(veh, extra) then
                    SetVehicleExtra(veh, extra, 1)
                    QBCore.Functions.Notify(Lang:t("error.extra_deactivated", {extra = extra}), 'error', 2500)
                else
                    SetVehicleExtra(veh, extra, 0)
                    QBCore.Functions.Notify(Lang:t("success.extra_activated", {extra = extra}), 'success', 2500)
                end
            else
                QBCore.Functions.Notify(Lang:t("error.extra_not_present", {extra = extra}), 'error', 2500)
            end
        else
            QBCore.Functions.Notify(Lang:t("error.not_driver"), 'error', 2500)
        end
    end
end)

RegisterNetEvent('radialmenu:flipVehicle', function()
    TriggerEvent('animations:client:EmoteCommandStart', {"mechanic"})
    QBCore.Functions.Progressbar("pick_grape", Lang:t("progress.flipping_car"), Config.Fliptime, false, true, {
        disableMovement = true,
        disableCarMovement = true,
        disableMouse = false,
        disableCombat = true,
    }, {}, {}, {}, function() -- Done
        local vehicle = getNearestVeh()
        SetVehicleOnGroundProperly(vehicle)
        TriggerEvent('animations:client:EmoteCommandStart', {"c"})
    end, function() -- Cancel
        QBCore.Functions.Notify(Lang:t("task.cancel_task"), "error")
        TriggerEvent('animations:client:EmoteCommandStart', {"c"})
    end)
end)

AddEventHandler('onResourceStart', function(resource)
    if resource == GetCurrentResourceName() then
        SetupRadialMenu()
    end
end)

AddEventHandler('onResourceStop', function(resource)
   if resource == GetCurrentResourceName() then
        lib.clearRadialItems()
   end
end)

-- Sets the metadata when the player spawns
AddEventHandler('QBCore:Client:OnPlayerLoaded', function()
    PlayerData = QBCore.Functions.GetPlayerData()
    SetupRadialMenu()
end)

-- Sets the playerdata to an empty table when the player has quit or did /logout
RegisterNetEvent('QBCore:Client:OnPlayerUnload', function()
    PlayerData = {}
end)

-- This will update all the PlayerData that doesn't get updated with a specific event other than this like the metadata
RegisterNetEvent('QBCore:Player:SetPlayerData', function(val)
    PlayerData = val
end)

AddEventHandler('QBCore:Client:OnJobUpdate', function(job)
    lib.removeRadialItem('jobinteractions')
    PlayerData.job = job
    if job.onduty and Config.JobInteractions[job.name] then
       lib.addRadialItem(convert({
            id = 'jobinteractions',
            label = 'Travail',
            icon = 'briefcase',
            items = Config.JobInteractions[job.name]
        }))
    end
end)

RegisterNetEvent('QBCore:Client:SetDuty', function(onduty)
    lib.removeRadialItem('jobinteractions')
    if onduty and Config.JobInteractions[PlayerData.job.name] then
       lib.addRadialItem(convert({
            id = 'jobinteractions',
            label = 'Travail',
            icon = 'briefcase',
            items = Config.JobInteractions[PlayerData.job.name]
        }))
    end
end)

RegisterNetEvent('QBCore:Client:OnGangUpdate', function(gang)
    lib.removeRadialItem('ganginteractions')
    PlayerData.gang = gang
    if Config.GangInteractions[gang.name] and next(Config.GangInteractions[gang.name]) then
        lib.addRadialItem(convert({
            id = 'ganginteractions',
            label = 'Gang',
            icon = 'skull-crossbones',
            items = Config.GangInteractions[gang.name]
        }))
    end
end)

exports('AddOption', function(data, id)
    data.id = data.id or id and id
    lib.addRadialItem(convert(data))
    return data.id
end)

exports('RemoveOption', function(id)
    lib.removeRadialItem(id)
end)
