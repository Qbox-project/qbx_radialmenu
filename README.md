# qbx_radialmenu
Radial Menu Used With qbx_Core :arrows_counterclockwise:

**Supports FontAwesome Icons!**
Get the name from [FontAwesome](https://fontawesome.com/v5.0/icons?d=gallery&p=2&s=brands,light,regular,solid&m=free) (v5) and use the icon's name in the config.lua for the icon (no `fa-` or `#` just the name like `arrow-right`)


## Blip Usage

## toggleBlip
```lua
exports.qbx_radialmenu:toggleBlip(category)
```
### Parameters
- `category` (string): The unique category of the blip to toggle


## registerToggleableBlip
```lua
exports.qbx_radialmenu:registerToggleableBlip(blipId, category)
```
### Parameters
- `blipId` (number): The blip handle to register
- `category` (string): The unique category of the blip

### Example
```lua
local blipHandle<const> = AddBlipForCoord(0.0, 0.0, 0.0)
exports.qbx_radialmenu:registerToggleableBlip(blipHandle, "shops")
```