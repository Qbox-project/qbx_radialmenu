local config = require 'config.client'
local inTrunk = false
local isKidnapped = false
local isKidnapping = false
local cam = 0
local disabledTrunk = {
    [`penetrator`] = "penetrator",
    [`vacca`] = "vacca",
    [`monroe`] = "monroe",
    [`turismor`] = "turismor",
    [`osiris`] = "osiris",
    [`comet`] = "comet",
    [`ardent`] = "ardent",
    [`jester`] = "jester",
    [`nero`] = "nero",
    [`nero2`] = "nero2",
    [`vagner`] = "vagner",
    [`infernus`] = "infernus",
    [`zentorno`] = "zentorno",
    [`comet2`] = "comet2",
    [`comet3`] = "comet3",
    [`comet4`] = "comet4",
    [`bullet`] = "bullet",
}

-- Functions

local function DrawText3Ds(x, y, z, text)
	SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(true)
    SetTextColour(255, 255, 255, 215)
    BeginTextCommandDisplayText("STRING")
    SetTextCentre(true)
    AddTextComponentSubstringPlayerName(text)
    SetDrawOrigin(x,y,z, 0)
    EndTextCommandDisplayText(0.0, 0.0)
    local factor = string.len(text) / 370
    DrawRect(0.0, 0.0 + 0.0125, 0.017 + factor, 0.03, 0, 0, 0, 75)
    ClearDrawOrigin()
end

local function TrunkCam(bool)
    local vehicle = GetEntityAttachedTo(cache.ped)
    local drawPos = GetOffsetFromEntityInWorldCoords(vehicle, 0, -5.5, 0)
    local vehHeading = GetEntityHeading(vehicle)
    if bool then
        RenderScriptCams(false, false, 0, true, false)
        if DoesCamExist(cam) then
            DestroyCam(cam, false)
            cam = 0
        end

        cam = CreateCam('DEFAULT_SCRIPTED_CAMERA', true)
        SetCamActive(cam, true)
        SetCamCoord(cam, drawPos.x, drawPos.y, drawPos.z + 2)
        SetCamRot(cam, -2.5, 0.0, vehHeading, 0.0)
        RenderScriptCams(true, false, 0, true, true)
    else
        RenderScriptCams(false, false, 0, true, false)
        if DoesCamExist(cam) then
            DestroyCam(cam, false)
            cam = 0
        end
    end
end

local function getClosestPlayer(distance)
    local coords = GetEntityCoords(cache.ped)
    local player, playerPed = lib.getClosestPlayer(coords, (distance or 2.5))
    if not player then
        exports.qbx_core:Notify(locale('error.no_people_nearby'), 'error')
        return
    end
    return player, playerPed
end

-- Events

RegisterNetEvent('qb-kidnapping:client:SetKidnapping', function(bool)
    isKidnapping = bool
end)

RegisterNetEvent('qb-trunk:client:KidnapTrunk', function()
    local closestPlayer = getClosestPlayer()
    if not closestPlayer then return end

    local closestVehicle = lib.getClosestVehicle(GetEntityCoords(cache.ped))
    if not isKidnapping or not closestVehicle then return exports.qbx_core:Notify(locale("error.not_kidnapped"), 'error') end

    TriggerEvent('police:client:KidnapPlayer')
    TriggerServerEvent("police:server:CuffPlayer", GetPlayerServerId(closestPlayer), false)
    Wait(50)
    TriggerServerEvent("qb-trunk:server:KidnapTrunk", GetPlayerServerId(closestPlayer), closestVehicle)
end)

RegisterNetEvent('qb-trunk:client:KidnapGetIn', function(veh)
    local closestVehicle = veh
    local vehClass = GetVehicleClass(closestVehicle)
    local plate = qbx.getVehiclePlate(closestVehicle)
    if config.trunkClasses[vehClass].allowed then
        local isBusy = lib.callback.await('qb-trunk:server:getTrunkBusy', false, plate)
        if not disabledTrunk[GetEntityModel(closestVehicle)] then
            if not inTrunk then
                if not isBusy then
                    if not isKidnapped then
                        if GetVehicleDoorAngleRatio(closestVehicle, 5) > 0 then
                            local offset = {
                                x = config.trunkClasses[vehClass].x,
                                y = config.trunkClasses[vehClass].y,
                                z = config.trunkClasses[vehClass].z,
                            }
                            lib.playAnim(cache.ped, "fin_ext_p1-7", "cs_devin_dual-7", 8.0, 8.0, -1, 1, 999.0, false, false, false)
                            AttachEntityToEntity(cache.ped, closestVehicle, 0, offset.x, offset.y, offset.z, 0, 0, 40.0, true, true, true, true, 1, true)
                            TriggerServerEvent('qb-trunk:server:setTrunkBusy', plate, true)
                            inTrunk = true
                            Wait(500)
                            SetVehicleDoorShut(closestVehicle, 5, false)
                            exports.qbx_core:Notify(locale("success.entered_trunk"), 'success', 4000)
                            TrunkCam(true)
                            isKidnapped = true
                        else
                            exports.qbx_core:Notify(locale("error.trunk_closed"), 'error', 2500)
                        end
                    else
                        local vehicle = GetEntityAttachedTo(cache.ped)
                        plate = qbx.getVehiclePlate(vehicle)
                        if GetVehicleDoorAngleRatio(vehicle, 5) > 0 then
                            local vehCoords = GetOffsetFromEntityInWorldCoords(vehicle, 0, -5.0, 0)
                            DetachEntity(cache.ped, true, true)
                            ClearPedTasks(cache.ped)
                            inTrunk = false
                            TriggerServerEvent('qb-smallresources:trunk:server:setTrunkBusy', plate, nil)
                            SetEntityCoords(cache.ped, vehCoords.x, vehCoords.y, vehCoords.z, false, false, false, false)
                            SetEntityCollision(cache.ped, true, true)
                            TrunkCam(false)
                        else
                            exports.qbx_core:Notify(locale("error.trunk_closed"), 'error', 2500)
                        end
                    end
                else
                    exports.qbx_core:Notify(locale("error.someone_in_trunk"), 'error', 2500)
                end
            else
                exports.qbx_core:Notify(locale("error.already_in_trunk"), 'error', 2500)
            end
        else
            exports.qbx_core:Notify(locale("error.cant_enter_trunk"), 'error', 2500)
        end
    else
        exports.qbx_core:Notify(locale("error.cant_enter_trunk"), 'error', 2500)
    end
end)

RegisterNetEvent('qb-trunk:client:GetIn', function()
    local coords = GetEntityCoords(cache.ped)
    local closestVehicle = lib.getClosestVehicle(coords, 5.0, false)
    if closestVehicle ~= 0 then
        local vehClass = GetVehicleClass(closestVehicle)
        local plate = qbx.getVehiclePlate(closestVehicle)
        if config.trunkClasses[vehClass].allowed then
            local isBusy = lib.callback.await('qb-trunk:server:getTrunkBusy', false, plate)
            if not disabledTrunk[GetEntityModel(closestVehicle)] then
                if not inTrunk then
                    if not isBusy then
                        if GetVehicleDoorAngleRatio(closestVehicle, 5) > 0 then
                            local offset = {
                                x = config.trunkClasses[vehClass].x,
                                y = config.trunkClasses[vehClass].y,
                                z = config.trunkClasses[vehClass].z,
                            }
                            lib.playAnim(cache.ped, "fin_ext_p1-7", "cs_devin_dual-7", 8.0, 8.0, -1, 1, 999.0, false, false, false)
                            AttachEntityToEntity(cache.ped, closestVehicle, 0, offset.x, offset.y, offset.z, 0, 0, 40.0, true, true, true, true, 1, true)
                            TriggerServerEvent('qb-trunk:server:setTrunkBusy', plate, true)
                            inTrunk = true
                            Wait(500)
                            SetVehicleDoorShut(closestVehicle, 5, false)
                            exports.qbx_core:Notify(locale("success.entered_trunk"), 'success', 4000)
                            TrunkCam(true)
                        else
                            exports.qbx_core:Notify(locale("error.trunk_closed"), 'error', 2500)
                        end
                    else
                        exports.qbx_core:Notify(locale("error.someone_in_trunk"), 'error', 2500)
                    end
                else
                    exports.qbx_core:Notify(locale("error.already_in_trunk"), 'error', 2500)
                end
            else
                exports.qbx_core:Notify(locale("error.cant_enter_trunk"), 'error', 2500)
            end
        else
            exports.qbx_core:Notify(locale("error.cant_enter_trunk"), 'error', 2500)
        end
    else
        exports.qbx_core:Notify(locale("error.no_vehicle_found"), 'error', 2500)
    end
end)

-- Threads

CreateThread(function()
    while true do
        local sleep = 1000
        local vehicle = GetEntityAttachedTo(cache.ped)
        local drawPos = GetOffsetFromEntityInWorldCoords(vehicle, 0, -5.5, 0)
        local vehHeading = GetEntityHeading(vehicle)
        if DoesCamExist(cam) then
            sleep = 0
            SetCamRot(cam, -2.5, 0.0, vehHeading, 0.0)
            SetCamCoord(cam, drawPos.x, drawPos.y, drawPos.z + 2)
        end
        Wait(sleep)
    end
end)

CreateThread(function()
    while true do
        local sleep = 1000
        if inTrunk then
            if not isKidnapped then
                local vehicle = GetEntityAttachedTo(cache.ped)
                local drawPos = GetOffsetFromEntityInWorldCoords(vehicle, 0, -2.5, 0)
                local plate = qbx.getVehiclePlate(vehicle)
                if DoesEntityExist(vehicle) then
                    sleep = 0
                    DrawText3Ds(drawPos.x, drawPos.y, drawPos.z + 0.75, locale("general.get_out_trunk_button"))

                    if IsControlJustPressed(0, 38) then
                        if GetVehicleDoorAngleRatio(vehicle, 5) > 0 then
                            local vehCoords = GetOffsetFromEntityInWorldCoords(vehicle, 0, -5.0, 0)
                            DetachEntity(cache.ped, true, true)
                            ClearPedTasks(cache.ped)
                            inTrunk = false
                            TriggerServerEvent('qb-trunk:server:setTrunkBusy', plate, false)
                            SetEntityCoords(cache.ped, vehCoords.x, vehCoords.y, vehCoords.z, false, false, false, false)
                            SetEntityCollision(cache.ped, true, true)
                            TrunkCam(false)
                        else
                            exports.qbx_core:Notify(locale("error.trunk_closed"), 'error', 2500)
                        end
                        Wait(100)
                    end
                    if GetVehicleDoorAngleRatio(vehicle, 5) > 0 then
                        DrawText3Ds(drawPos.x, drawPos.y, drawPos.z + 0.5, locale("general.close_trunk_button"))
                        if IsControlJustPressed(0, 47) then
                            if not IsVehicleSeatFree(vehicle, -1) then
                                TriggerServerEvent('qb-radialmenu:trunk:server:Door', false, plate, 5)
                            else
                                SetVehicleDoorShut(vehicle, 5, false)
                            end
                            Wait(100)
                        end
                    else
                        DrawText3Ds(drawPos.x, drawPos.y, drawPos.z + 0.5, locale("general.open_trunk_button"))
                        if IsControlJustPressed(0, 47) then
                            if not IsVehicleSeatFree(vehicle, -1) then
                                TriggerServerEvent('qb-radialmenu:trunk:server:Door', true, plate, 5)
                            else
                                SetVehicleDoorOpen(vehicle, 5, false, false)
                            end
                            Wait(100)
                        end
                    end
                end
            end
        end
        Wait(sleep)
    end
end)