AddStateBagChangeHandler('qbx_medical:deathState', nil, function(bagName, _, value)
    local playerId = GetPlayerFromStateBagName(bagName)
    TriggerClientEvent('radialmenu:client:deadradial', playerId, value == 2 or value == 3)
end)

-- qb-amublancejob compatibility
RegisterNetEvent('hospital:server:SetDeathStatus', function(isDead)
    TriggerClientEvent('radialmenu:client:deadradial', source, isDead)
end)

RegisterNetEvent('qbx_radialmenu:server:saveBlipPreferences', function(blipPreferences)
    local playerData<const> = exports.qbx_core:GetPlayer(source)

    if playerData then
        playerData.Functions.SetMetaData("blipPreferences", blipPreferences)
    end
end)