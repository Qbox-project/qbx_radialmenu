local VEHICLE_MENU_ID = 'vehicleDoors'
local FLIP_VEHICLE_MENU_ID = 'flip-vehicle'

function SetupVehicleMenu()
    -- local carMenu = {
    --     id = VEHICLE_MENU_ID,
    --     label = locale('options.vehicle'),
    --     icon = 'car',
    --     menu = 'vehicleMenu'
    -- }

    local vehicleItems = {}

    vehicleItems[#vehicleItems + 1] = Convert(Config.vehicleDoors)

    -- if Config.enableExtraMenu then
    --     vehicleItems[#vehicleItems + 1] = Convert(Config.vehicleExtras)
    -- end

    --[[if config.vehicleSeats then
        CreateThread(addVehicleSeats)
        vehicleItems[#vehicleItems + 1] = config.vehicleSeats
    end]]--

    -- lib.registerRadial({
    --     id = 'vehicleMenu',
    --     items = vehicleItems
    -- })

    lib.addRadialItem(vehicleItems)
end

local function setupFlipVehicle()

    lib.addRadialItem({
        id = FLIP_VEHICLE_MENU_ID,
        label = locale('options.flip'),
        icon = 'car',
        onSelect = function()
            TriggerEvent('radialmenu:flipVehicle')
            lib.hideRadial()
        end
    })

end

lib.onCache('vehicle', function(vehicle)

    if vehicle == false or vehicle == 0 then
        lib.removeRadialItem(VEHICLE_MENU_ID)
        setupFlipVehicle()
        -- User got out of vehicle, we don't want or need to recalibrate
        return
    end

    lib.removeRadialItem(FLIP_VEHICLE_MENU_ID)
    SetupVehicleMenu()

end)