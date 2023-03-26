QBCore = exports['qb-core']:GetCoreObject()
PlayerData = QBCore.Functions.GetPlayerData()

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

AddEventHandler('QBCore:Client:OnPlayerLoaded', function()
    SetupRadialMenu()
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
    QBCore.Debug(data)
    QBCore.Debug(id)
    data.id = data.id or id and id
    lib.addRadialItem(convert(data))
    return data.id
end)

exports('RemoveOption', function(id)
    lib.removeRadialItem(id)
end)
