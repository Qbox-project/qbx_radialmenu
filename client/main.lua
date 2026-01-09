local config = require 'config.client'

local lastOutSideVehicle = false
local lastNearVehicle = false
local onVehicle = false
local lastNearPlayer = false
local vehicleFlipped = false

local toggleableBlips = {}
local categoryVisible = {}
local metadataLoaded = false

-----------------------
------- Events --------
-----------------------

lib.onCache('vehicle', function(vehicle)
    if vehicle then
        onVehicle = true
        setupVehicleMenu(true)
    else
        onVehicle = false
        setupVehicleMenu(false)
    end
end)

if config.vehicleSeats then
    lib.onCache('vehicle', function(vehicle)
        if vehicle then
            setupVehicleMenu(true)
            local vehicleSeats = {}
            local veh = vehicle
            local amountOfSeats = GetVehicleModelNumberOfSeats(GetEntityModel(veh))

            local seatTable = {
                [1] = locale('options.driver_seat'),
                [2] = locale('options.passenger_seat'),
                [3] = locale('options.rear_left_seat'),
                [4] = locale('options.rear_right_seat')
            }

            for i = 1, amountOfSeats do
                vehicleSeats[#vehicleSeats + 1] = {
                    id = 'vehicleSeat' .. i,
                    label = seatTable[i] or locale('options.other_seats'),
                    icon = 'caret-up',
                    onSelect = function()
                        if cache.vehicle then
                            TriggerEvent('radialmenu:client:ChangeSeat', i,
                                seatTable[i] or locale('options.other_seats'))
                        else
                            exports.qbx_core:Notify(locale('error.not_in_vehicle'), 'error')
                        end
                        lib.hideRadial()
                    end
                }
            end

            lib.registerRadial({
                id = 'vehicleSeatsMenu',
                items = vehicleSeats
            })
        else
            setupVehicleMenu(false)
        end
    end)

end

-----------------------
------ Functions ------
-----------------------

local function convert(tbl)
    if tbl.onVehicleOnly and not onVehicle then
        return
    end
    if tbl.outSideVehicleOnly and not lastOutSideVehicle then
        return
    end
    if tbl.nearByVehicleOnly and not lastNearVehicle then
        return
    end
    if tbl.nearByPlayerOnly and not lastNearPlayer then
        return
    end
    if tbl.items then
        local items = {}
        for _, v in pairs(tbl.items) do
            local converted<const> = convert(v)
            if converted then
                items[#items + 1] = converted
            end
        end
        if #items == 0 then return end

        lib.registerRadial({
            id = tbl.id .. 'Menu',
            items = items
        })

        return {
            id = tbl.id,
            label = tbl.label,
            icon = tbl.icon,
            menu = tbl.id .. 'Menu'
        }
    end

    local action
    if tbl.event then
        action = function()
            TriggerEvent(tbl.event, tbl.args or nil)
        end
    elseif tbl.serverEvent then
        action = function()
            TriggerServerEvent(tbl.serverEvent, tbl.args or nil)
        end
    elseif tbl.action then
        action = tbl.action(tbl.arg)
    elseif tbl.command then
        action = function()
            ExecuteCommand(tbl.command .. ' ' .. tbl.args)
        end
    end

    return {
        id = tbl.id,
        label = tbl.label,
        icon = tbl.icon,
        onSelect = tbl.onSelect or function()
            if action then
                action()
            end
        end,
        keepOpen = tbl.keepOpen,
        onVehicleOnly = tbl.onVehicleOnly,
        outSideVehicleOnly = tbl.outSideVehicleOnly,
        nearByVehicleOnly = tbl.nearByVehicleOnly,
        nearByPlayerOnly = tbl.nearByPlayerOnly
    }
end

function setupVehicleMenu(seat)
    local vehicleMenu = {
        id = 'vehicle',
        label = locale('options.vehicle'),
        icon = 'car',
        menu = 'vehicleMenu'
    }

    local vehicleItems = {}
    if vehicleFlipped then
      vehicleItems[#vehicleItems + 1] = {
          id = 'vehicle-flip',
          label = locale('options.flip'),
          icon = 'car-burst',
          onSelect = function()
              TriggerEvent('radialmenu:flipVehicle')
              lib.hideRadial()
          end
      }
    end

    if config.vehicleItems then
        for i = 1, #config.vehicleItems do
            vehicleItems[#vehicleItems + 1] = convert(config.vehicleItems[i])
        end
    end

    if config.vehicleWindows then
        vehicleItems[#vehicleItems + 1] = convert(config.vehicleWindows)
    end

    if config.vehicleDoors then
        vehicleItems[#vehicleItems + 1] = convert(config.vehicleDoors)
    end

    if config.enableExtraMenu then
        vehicleItems[#vehicleItems + 1] = convert(config.vehicleExtras)
    end

    if config.vehicleSeats and seat then
        vehicleItems[#vehicleItems + 1] = config.vehicleSeats
    end

    lib.registerRadial({
        id = 'vehicleMenu',
        items = vehicleItems
    })

    lib.addRadialItem(vehicleMenu)
end

local function setupRadialMenu()
    setupVehicleMenu()

    for _, v in pairs(config.menuItems) do
        local converted<const> = convert(v)
        if converted then
            lib.addRadialItem(converted)
        end
    end

    if config.gangItems[QBX.PlayerData.gang.name] then
        lib.addRadialItem(convert({
            id = 'gangInteractions',
            label = locale('general.gang_radial'),
            icon = 'skull-crossbones',
            items = config.gangItems[QBX.PlayerData.gang.name]
        }))
    end

    if not config.jobItems[QBX.PlayerData.job.name] or not QBX.PlayerData.job.onduty then
        return
    end

    lib.addRadialItem(convert({
        id = 'jobInteractions',
        label = locale('general.job_radial'),
        icon = 'briefcase',
        items = config.jobItems[QBX.PlayerData.job.name]
    }))
end

local function isPolice()
    return QBX.PlayerData.job.type == 'leo' and QBX.PlayerData.job.onduty
end

local function isEMS()
    return QBX.PlayerData.job.type == 'ems' and QBX.PlayerData.job.onduty
end

local loadBlipPreferences<const> = function()
    if metadataLoaded then return end

    local playerData<const> = QBX.PlayerData
    if playerData and playerData.metadata then
        local blipPreferences = playerData.metadata.blipPreferences or {}

        for category, isVisible in pairs(blipPreferences) do
            categoryVisible[category] = isVisible

            if toggleableBlips[category] then
                for blipId, _ in pairs(toggleableBlips[category]) do
                    if DoesBlipExist(blipId) then
                        SetBlipAlpha(blipId, isVisible and 255 or 0)
                    end
                end
            end
        end

        metadataLoaded = true
    end
end

-- Events
RegisterNetEvent('radialmenu:client:deadradial', function(isDead)
    if isDead then
        local ispolice, isems = isPolice(), isEMS()
        if not ispolice or isems then
            return lib.disableRadial(true)
        end
        lib.clearRadialItems()
        lib.addRadialItem({
            id = 'emergencybutton2',
            label = locale('options.emergency_button'),
            icon = 'circle-exclamation',
            onSelect = function()
                if ispolice then
                    TriggerEvent('police:client:SendPoliceEmergencyAlert')
                elseif isems then
                    TriggerServerEvent('hospital:server:emergencyAlert')
                end
                lib.hideRadial()
            end
        })
    else
        lib.clearRadialItems()
        setupRadialMenu()
        lib.disableRadial(false)
    end
end)

RegisterNetEvent('radialmenu:client:ChangeSeat', function(id, label)
    local isSeatFree = IsVehicleSeatFree(cache.vehicle, id - 2)
    local speed = GetEntitySpeed(cache.vehicle)
    local hasHarness = exports.qbx_seatbelt:HasHarness()
    if hasHarness then
        return exports.qbx_core:Notify(locale('error.race_harness_on'), 'error')
    end

    if not isSeatFree then
        return exports.qbx_core:Notify(locale('error.seat_occupied'), 'error')
    end

    local kmh = speed * 3.6

    if kmh > 100.0 then
        return exports.qbx_core:Notify(locale('error.vehicle_driving_fast'), 'error')
    end

    SetPedIntoVehicle(cache.ped, cache.vehicle, id - 2)
    exports.qbx_core:Notify(locale('info.switched_seats', label))
end)

RegisterNetEvent('qb-radialmenu:trunk:client:Door', function(plate, door, open)
    if not cache.vehicle then
        return
    end

    local pl = qbx.getVehiclePlate(cache.vehicle)
    if pl ~= plate then
        return
    end

    if open then
        SetVehicleDoorOpen(cache.vehicle, door, false, false)
    else
        SetVehicleDoorShut(cache.vehicle, door, false)
    end
end)

RegisterNetEvent('qb-radialmenu:client:noPlayers', function()
    exports.qbx_core:Notify(locale('error.no_people_nearby'), 'error', 2500)
end)

RegisterNetEvent('qb-radialmenu:client:openDoor', function(id)
    local door = id
    local coords = GetEntityCoords(cache.ped)
    local closestVehicle = cache.vehicle or lib.getClosestVehicle(coords, 5.0, false)
    if closestVehicle and closestVehicle ~= 0 then
        if closestVehicle ~= cache.vehicle then
            local plate = qbx.getVehiclePlate(closestVehicle)
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
        exports.qbx_core:Notify(locale('error.no_vehicle_found'), 'error', 2500)
    end
end)

RegisterNetEvent('qbx_radialmenu:client:toggleWindows', function(id)
    local window = id
    local vehicle = cache.vehicle

    if vehicle ~= false then
        if IsVehicleWindowIntact(vehicle, window) then
            RollDownWindow(vehicle, window)
        else
            RollUpWindow(vehicle, window)
        end
    else
        exports.qbx_core:Notify(locale('error.no_vehicle_found'), 'error', 2500)
    end
end)

RegisterNetEvent('radialmenu:client:setExtra', function(id)
    local extra = id
    if cache.vehicle ~= nil then
        if cache.seat == -1 then
            SetVehicleAutoRepairDisabled(cache.vehicle, true) -- Forces Auto Repair off when Toggling Extra [GTA 5 Niche Issue]
            if DoesExtraExist(cache.vehicle, extra) then
                if IsVehicleExtraTurnedOn(cache.vehicle, extra) then
                    qbx.setVehicleExtra(cache.vehicle, extra, false)
                    exports.qbx_core:Notify(locale('error.extra_deactivated', extra), 'error', 2500)
                else
                    qbx.setVehicleExtra(cache.vehicle, extra, true)
                    exports.qbx_core:Notify(locale('success.extra_activated', extra), 'success', 2500)
                end
            else
                exports.qbx_core:Notify(locale('error.extra_not_present', extra), 'error', 2500)
            end
        else
            exports.qbx_core:Notify(locale('error.not_driver'), 'error', 2500)
        end
    end
end)

RegisterNetEvent('radialmenu:flipVehicle', function()
    if cache.vehicle then
        return
    end
    local coords = GetEntityCoords(cache.ped)
    local vehicle = lib.getClosestVehicle(coords)
    if not vehicle then
        return exports.qbx_core:Notify(locale('error.no_vehicle_nearby'), 'error')
    end
    if lib.progressBar({
        label = locale('progress.flipping_car'),
        duration = config.flipTime,
        useWhileDead = false,
        canCancel = true,
        disable = {
            move = true,
            car = true,
            mouse = false,
            combat = true
        },
        anim = {
            dict = 'mini@repair',
            clip = 'fixing_a_ped'
        }
    }) then
        SetVehicleOnGroundProperly(vehicle)
        exports.qbx_core:Notify(locale('success.flipped_car'), 'success')
    else
        exports.qbx_core:Notify(locale('error.cancel_task'), 'error')
    end
end)

AddEventHandler('onResourceStart', function(resource)
    if cache.resource ~= resource then
        return
    end
    if LocalPlayer.state.isLoggedIn then
        setupRadialMenu()
    end
end)

AddEventHandler('onResourceStop', function(resource)
    if cache.resource ~= resource then
        return
    end
    lib.clearRadialItems()
end)

-- Sets the metadata when the player spawns
AddEventHandler('QBCore:Client:OnPlayerLoaded', function()
    setupRadialMenu()
    loadBlipPreferences()
end)

RegisterNetEvent('QBCore:Client:OnJobUpdate', function(job)
    lib.removeRadialItem('jobInteractions')
    setupRadialMenu()
end)

RegisterNetEvent('QBCore:Client:SetDuty', function(onDuty)
    lib.removeRadialItem('jobInteractions')
    if onDuty and config.jobItems[QBX.PlayerData.job.name] then
        lib.addRadialItem(convert({
            id = 'jobInteractions',
            label = locale('general.job_radial'),
            icon = 'briefcase',
            items = config.jobItems[QBX.PlayerData.job.name]
        }))
    end
end)

RegisterNetEvent('QBCore:Client:OnGangUpdate', function(gang)
    lib.removeRadialItem('gangInteractions')
    if config.gangItems[gang.name] and next(config.gangItems[gang.name]) then
        lib.addRadialItem(convert({
            id = 'gangInteractions',
            label = locale('general.gang_radial'),
            icon = 'skull-crossbones',
            items = config.gangItems[gang.name]
        }))
    end
end)

local saveBlipPreferences<const> = function ()
  TriggerServerEvent('radialmenu:server:saveBlipPreferences', categoryVisible)
end

---@param category string
local toggleBlipsForCategory<const> = function(category)
    if not category then
        lib.print.warn("No category provided for toggling blips.")
        return
    end
    local toggledCount = 0
    local blipCategoryName = string.gsub(category, "_", " ") -- Replaces underscores with spaces
    blipCategoryName = blipCategoryName:sub(1,1):upper() .. blipCategoryName:sub(2) -- Capitalizes the first letter

    if categoryVisible[category] == nil then
      categoryVisible[category] = true -- Default to visible
    else
      categoryVisible[category] = not categoryVisible[category]
    end
    local isVisible<const> = categoryVisible[category]

    if toggleableBlips[category] then
        for blipId, _ in pairs(toggleableBlips[category]) do
            if DoesBlipExist(blipId) then
                if isVisible then
                    SetBlipAlpha(blipId, 255) -- Show blip
                else
                    SetBlipAlpha(blipId, 0)   -- Hide blip
                end
                toggledCount = toggledCount + 1
            else
                if toggleableBlips[category] then
                    toggleableBlips[category][blipId] = nil
                end
            end
        end
    end

    saveBlipPreferences()

    local status<const> = isVisible and locale('general.blip_shown') or locale('general.blip_hidden')
    exports.qbx_core:Notify(("%s %s"):format(blipCategoryName, status), 'info')
    return isVisible
end

---@param blipHandle number
---@param category string
local registerToggleableBlip<const> = function(blipHandle, category)
    if not category then
        lib.print.error(("No category provided when registering blipId: %s"):format(tostring(blipHandle)))
        return
    end
    if not blipHandle then
        lib.print.error(("No blipId provided for registration in category: %s"):format(category))
        return
    end

    if DoesBlipExist(blipHandle) then
        if not toggleableBlips[category] then
            toggleableBlips[category] = {}
        end
        toggleableBlips[category][blipHandle] = true

        if not metadataLoaded then
            loadBlipPreferences()
        end

        local isCurrentlyVisible = categoryVisible[category]
        if isCurrentlyVisible == nil then
            isCurrentlyVisible = true -- default new categories/blips to visible
            categoryVisible[category] = true
            saveBlipPreferences()
        end

        if isCurrentlyVisible then
            SetBlipAlpha(blipHandle, 255)
        else
            SetBlipAlpha(blipHandle, 0)
        end
    else
        lib.print.warn(("Attempted to register non-existent blip %s for category: %s"):format(tostring(blipHandle), category))
    end
end


CreateThread(function()
    while true do
        local outSideVehicle<const> = lib.getClosestVehicle(GetEntityCoords(cache.ped), 5.0, false) ~= nil
        local nearByVehicle<const> = lib.getClosestVehicle(GetEntityCoords(cache.ped), 5.0, true) ~= nil
        local closestPlayer<const>, _<const> = lib.getClosestPlayer(GetEntityCoords(cache.ped))
        local nearPlayer<const> = closestPlayer ~= nil

        local playerCoords<const> = GetEntityCoords(cache.ped)
        local closestVehicle<const> = lib.getClosestVehicle(playerCoords, 3.0)
        local flipableVehicle<const> = closestVehicle and not IsVehicleOnAllWheels(closestVehicle)

        local outsideStatusChanged<const> = outSideVehicle ~= lastOutSideVehicle
        local nearByVehicleChanged<const> = nearByVehicle ~= lastNearVehicle
        local nearPlayerChanged<const> = nearPlayer ~= lastNearPlayer
        local vehicleFlipStateChanged<const> = IsVehicleOnAllWheels(closestVehicle) ~= flipableVehicle
        if outsideStatusChanged or nearByVehicleChanged or nearPlayerChanged or closestVehicle and not vehicleFlipStateChanged then
            lastOutSideVehicle = outSideVehicle
            lastNearVehicle = nearByVehicle
            lastNearPlayer = nearPlayer
            vehicleFlipped = flipableVehicle
            setupRadialMenu()
        end
        Wait(1500)
    end
end)

local function createQBExport(name, cb)
    AddEventHandler(('__cfx_export_qb-radialmenu_%s'):format(name), function(setCB)
        setCB(cb)
    end)
end

local function addOption(data, id)
    data.id = data.id or id and id
    lib.addRadialItem(convert(data))
    return data.id
end

exports('AddOption', addOption)
createQBExport('AddOption', addOption)

local function removeOption(id)
    lib.removeRadialItem(id)
end

exports('RemoveOption', removeOption)
createQBExport('RemoveOption', removeOption)

exports('toggleBlip', toggleBlipsForCategory)
exports('registerToggleableBlip', registerToggleableBlip)