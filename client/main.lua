-- Functions

local function convert(tbl)
    if tbl.items then
        local items = {}
        for _, v in pairs(tbl.items) do
            items[#items+1] = convert(v)
        end
        lib.registerRadial({
            id = tbl.id..'_menu',
            items = items
        })
        return { id = tbl.id, label = tbl.title or tbl.label, icon = tbl.icon, menu = tbl.id..'_menu' }
    end
    local action
    if tbl.event then
        if tbl.type == 'client' then
            action = function() TriggerEvent(tbl.event, tbl.arg or nil) end
        elseif tbl.type == 'server' then
            action = function() TriggerServerEvent(tbl.event, tbl.arg or nil) end
        end
    elseif tbl.action then
        action = tbl.action(tbl.arg)
    elseif tbl.command then
        action = function() ExecuteCommand(tbl.command .. " " .. tbl.arg) end
    end
    local onSelect = tbl.onSelect or function()
        if action then action() end
    end
    return { id = tbl.id, label = tbl.title or tbl.label, icon = tbl.icon, onSelect = onSelect, keepOpen = not tbl.shouldClose or false }
end

local function AddVehicleSeats()
    CreateThread(function()
        while true do
            Wait(50)
            if IsControlJustPressed(0, 23) and not cache.vehicle then
                local vehicle = GetClosestVehicle()
                if vehicle then
                    local vehicleseats = {}
                    local seatTable = {
                        [1] = Lang:t("options.driver_seat"),
                        [2] = Lang:t("options.passenger_seat"),
                        [3] = Lang:t("options.rear_left_seat"),
                        [4] = Lang:t("options.rear_right_seat"),
                    }

                    local AmountOfSeats = GetVehicleModelNumberOfSeats(GetEntityModel(vehicle))
                    for i = 1, AmountOfSeats do
                        vehicleseats[#vehicleseats+1] = {
                            id = 'vehicleseat'..i,
                            label = seatTable[i] or Lang:t("options.other_seats"),
                            icon = 'caret-up',
                            onSelect = function()
                                if cache.vehicle then
                                    TriggerEvent('radialmenu:client:ChangeSeat', i, seatTable[i] or Lang:t("options.other_seats"))
                                else
                                    exports.qbx_core:Notify(Lang:t('error.not_in_vehicle'), 'error')
                                end
                                lib.hideRadial()
                            end,
                        }
                    end
                    lib.registerRadial({
                        id = 'vehicleseatsmenu',
                        items = vehicleseats
                    })
                end
            end
        end
    end)
end

local function SetupVehicleMenu()
    local VehicleMenu = {
        id = 'vehicle',
        label = Lang:t("options.vehicle"),
        icon = 'car',
        menu = 'vehiclemenu'
    }

    local vehicleitems = {{
        id = 'vehicle-flip',
        label = Lang:t("options.flip"),
        icon = 'car-burst',
        onSelect = function()
            TriggerEvent('radialmenu:flipVehicle')
            lib.hideRadial()
        end,
    }}

    vehicleitems[#vehicleitems+1] = convert(Config.VehicleDoors)
    if Config.EnableExtraMenu then vehicleitems[#vehicleitems+1] = convert(Config.VehicleExtras) end

    if Config.VehicleSeats then
        AddVehicleSeats()
        vehicleitems[#vehicleitems+1] = Config.VehicleSeats
    end
    lib.registerRadial({
        id = 'vehiclemenu',
        items = vehicleitems
    })
    lib.addRadialItem(VehicleMenu)
end

local function SetupRadialMenu()
    SetupVehicleMenu()

    for _, v in pairs(Config.MenuItems) do
        lib.addRadialItem(convert(v))
    end

    if Config.GangInteractions[QBX.PlayerData.gang.name] then
        lib.addRadialItem(convert({
            id = 'ganginteractions',
            label = Lang:t("general.gang_radial"),
            icon = 'skull-crossbones',
            items = Config.GangInteractions[QBX.PlayerData.gang.name]
        }))
    end

    if not QBX.PlayerData.job.onduty then return end
    if not Config.JobInteractions[QBX.PlayerData.job.name] then return end

    lib.addRadialItem(convert({
        id = 'jobinteractions',
        label = Lang:t("general.job_radial"),
        icon = 'briefcase',
        items = Config.JobInteractions[QBX.PlayerData.job.name]
    }))
end

local function IsPolice()
    return QBX.PlayerData.job.type == "leo" and QBX.PlayerData.job.onduty
end

local function IsEMS()
    return QBX.PlayerData.job.type == "medic" and QBX.PlayerData.job.onduty
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
            onSelect = function ()
                if ispolice then
                    TriggerEvent('police:client:SendPoliceEmergencyAlert')
                elseif isems then
                    TriggerEvent('ambulance:client:SendAmbulanceEmergencyAlert')
                end
                lib.hideRadial()
            end
        })
    else
        lib.clearRadialItems()
        SetupRadialMenu()
        lib.disableRadial(false)
    end
end)

RegisterNetEvent('radialmenu:client:ChangeSeat', function(id, label)
    local Veh = cache.vehicle
    local IsSeatFree = IsVehicleSeatFree(Veh, id - 2)
    local speed = GetEntitySpeed(Veh)
    local HasHarness = exports['qbx_smallresources']:HasHarness()
    if HasHarness then
        return exports.qbx_core:Notify(Lang:t("error.race_harness_on"), 'error')
    end

    if not IsSeatFree then
        return exports.qbx_core:Notify(Lang:t("error.seat_occupied"), 'error')
    end

    local kmh = speed * 3.6

    if kmh > 100.0 then
        return exports.qbx_core:Notify(Lang:t("error.vehicle_driving_fast"), 'error')
    end

    SetPedIntoVehicle(cache.ped, Veh, id - 2)
    exports.qbx_core:Notify(Lang:t("info.switched_seats", {seat = label}))
end)

RegisterNetEvent('qb-radialmenu:trunk:client:Door', function(plate, door, open)
    local veh = cache.vehicle
    if not veh then return end

    local pl = GetPlate(veh)
    if pl ~= plate then return end

    if open then
        SetVehicleDoorOpen(veh, door, false, false)
    else
        SetVehicleDoorShut(veh, door, false)
    end
end)

RegisterNetEvent('qb-radialmenu:client:noPlayers', function()
    exports.qbx_core:Notify(Lang:t("error.no_people_nearby"), 'error', 2500)
end)

RegisterNetEvent('qb-radialmenu:client:openDoor', function(id)
    local door = id
    local closestVehicle = cache.vehicle or GetClosestVehicle()
    if closestVehicle ~= 0 then
        if closestVehicle ~= cache.vehicle then
            local plate = GetPlate(closestVehicle)
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
        exports.qbx_core:Notify(Lang:t("error.no_vehicle_found"), 'error', 2500)
    end
end)

RegisterNetEvent('radialmenu:client:setExtra', function(id)
    local extra = id
    local veh = cache.vehicle
    if veh ~= nil then
        if cache.seat == -1 then
            SetVehicleAutoRepairDisabled(veh, true) -- Forces Auto Repair off when Toggling Extra [GTA 5 Niche Issue]
            if DoesExtraExist(veh, extra) then
                if IsVehicleExtraTurnedOn(veh, extra) then
                    SetVehicleExtra(veh, extra, true)
                    exports.qbx_core:Notify(Lang:t("error.extra_deactivated", {extra = extra}), 'error', 2500)
                else
                    SetVehicleExtra(veh, extra, false)
                    exports.qbx_core:Notify(Lang:t("success.extra_activated", {extra = extra}), 'success', 2500)
                end
            else
                exports.qbx_core:Notify(Lang:t("error.extra_not_present", {extra = extra}), 'error', 2500)
            end
        else
            exports.qbx_core:Notify(Lang:t("error.not_driver"), 'error', 2500)
        end
    end
end)

RegisterNetEvent('radialmenu:flipVehicle', function()
    if cache.vehicle then return end
    TriggerEvent('animations:client:EmoteCommandStart', {"mechanic"})
    exports.qbx_core:Progressbar("flipping_car", Lang:t("progress.flipping_car"), Config.Fliptime, false, true, {
        disableMovement = true,
        disableCarMovement = true,
        disableMouse = false,
        disableCombat = true,
    }, {}, {}, {}, function() -- Done
        local vehicle, distance = GetClosestVehicle()
        if distance <= 15 then
            SetVehicleOnGroundProperly(vehicle)
        end
        TriggerEvent('animations:client:EmoteCommandStart', {"c"})
    end, function() -- Cancel
        exports.qbx_core:Notify(Lang:t("error.cancel_task"), "error")
        TriggerEvent('animations:client:EmoteCommandStart', {"c"})
    end)
end)

AddEventHandler('onResourceStart', function(resource)
    if resource == GetCurrentResourceName() then
        if LocalPlayer.state.isLoggedIn then
            SetupRadialMenu()
        end
    end
end)

AddEventHandler('onResourceStop', function(resource)
    if resource == GetCurrentResourceName() then
        lib.clearRadialItems()
    end
end)

-- Sets the metadata when the player spawns
AddEventHandler('QBCore:Client:OnPlayerLoaded', function()
    SetupRadialMenu()
end)

RegisterNetEvent('QBCore:Client:OnJobUpdate', function(job)
    lib.removeRadialItem('jobinteractions')
    if job.onduty and Config.JobInteractions[job.name] then
        lib.addRadialItem(convert({
            id = 'jobinteractions',
            label = Lang:t("general.job_radial"),
            icon = 'briefcase',
            items = Config.JobInteractions[job.name]
        }))
    end
end)

RegisterNetEvent('QBCore:Client:SetDuty', function(onduty)
    lib.removeRadialItem('jobinteractions')
    if onduty and Config.JobInteractions[QBX.PlayerData.job.name] then
        lib.addRadialItem(convert({
            id = 'jobinteractions',
            label = Lang:t("general.job_radial"),
            icon = 'briefcase',
            items = Config.JobInteractions[QBX.PlayerData.job.name]
        }))
    end
end)

RegisterNetEvent('QBCore:Client:OnGangUpdate', function(gang)
    lib.removeRadialItem('ganginteractions')
    if Config.GangInteractions[gang.name] and next(Config.GangInteractions[gang.name]) then
        lib.addRadialItem(convert({
            id = 'ganginteractions',
            label = Lang:t("general.gang_radial"),
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
