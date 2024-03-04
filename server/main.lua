AddStateBagChangeHandler('qbx_medical:deathState', nil, function(bagName, _, value)
    local playerId = GetPlayerFromStateBagName(bagName)
    TriggerClientEvent('radialmenu:client:deadradial', playerId, value == 2 or value == 3)
end)

-- qb-amublancejob compatibility
RegisterNetEvent('hospital:server:SetDeathStatus', function(isDead)
    TriggerClientEvent('radialmenu:client:deadradial', source, isDead)
end)
