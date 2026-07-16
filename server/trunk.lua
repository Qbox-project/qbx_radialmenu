local trunkBusy = {}

---@param plate any
---@return string?
local function normalizePlate(plate)
    if type(plate) ~= 'string' or #plate > 16 then return end
    return plate:match('^%s*(.-)%s*$')
end

---@param source number
---@param plate string
---@return number?
local function getNearbyVehicle(source, plate)
    local playerCoords = GetEntityCoords(GetPlayerPed(source))
    for _, vehicle in ipairs(GetAllVehicles()) do
        if #(playerCoords - GetEntityCoords(vehicle)) <= 8.0
            and normalizePlate(GetVehicleNumberPlateText(vehicle)) == plate
        then
            return vehicle
        end
    end
end

RegisterNetEvent('qb-radialmenu:trunk:server:Door', function(open, plate, door)
    plate = normalizePlate(plate)
    if not plate or type(open) ~= 'boolean' or math.type(door) ~= 'integer' or door < 0 or door > 7 or not getNearbyVehicle(source, plate) then return end
    TriggerClientEvent('qb-radialmenu:trunk:client:Door', -1, plate, door, open)
end)

RegisterNetEvent('qb-trunk:server:setTrunkBusy', function(plate, busy)
    plate = normalizePlate(plate)
    if not plate or type(busy) ~= 'boolean' or not getNearbyVehicle(source, plate) then return end
    if busy then
        if trunkBusy[plate] and trunkBusy[plate] ~= source then return end
        trunkBusy[plate] = source
    elseif trunkBusy[plate] == source then
        trunkBusy[plate] = nil
    end
end)

RegisterNetEvent('qb-trunk:server:KidnapTrunk', function(targetId, vehicleNetId)
    if math.type(targetId) ~= 'integer' or targetId == source then return end
    local player = exports.qbx_core:GetPlayer(source)
    local target = exports.qbx_core:GetPlayer(targetId)
    if not player or not target then return end
    local metadata = target.PlayerData.metadata
    if not (metadata.ishandcuffed or metadata.isdead or metadata.inlaststand) then return end
    if #(GetEntityCoords(GetPlayerPed(source)) - GetEntityCoords(GetPlayerPed(targetId))) > 3.0 then return end
    if math.type(vehicleNetId) ~= 'integer' then return end
    local closestVehicle = NetworkGetEntityFromNetworkId(vehicleNetId)
    if not DoesEntityExist(closestVehicle)
        or #(GetEntityCoords(GetPlayerPed(source)) - GetEntityCoords(closestVehicle)) > 8.0
    then
        return
    end
    TriggerClientEvent('qb-trunk:client:KidnapGetIn', targetId, vehicleNetId)
end)

lib.callback.register('qb-trunk:server:getTrunkBusy', function(_, plate)
    plate = normalizePlate(plate)
    return plate and trunkBusy[plate] ~= nil
end)

AddEventHandler('playerDropped', function()
    for plate, owner in pairs(trunkBusy) do
        if owner == source then trunkBusy[plate] = nil end
    end
end)

lib.addCommand('getintrunk', {
    help = locale("general.getintrunk_command_desc"),
}, function(source)
    TriggerClientEvent('qb-trunk:client:GetIn', source)
end)

lib.addCommand('putintrunk', {
    help = locale("general.putintrunk_command_desc"),
}, function(source)
    TriggerClientEvent('qb-trunk:server:KidnapTrunk', source)
end)
