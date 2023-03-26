QBCore = exports['qb-core']:GetCoreObject()

AddEventHandler('hospital:server:SetDeathStatus', function(isDead)
    TriggerClientEvent('radialmenu:client:deadradial', source, isDead)
end)
