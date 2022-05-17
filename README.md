# mt-fishing
Simple fishing script for QBCore

# preview
https://www.youtube.com/watch?v=GfIvCs8g32k

# Our Discord
https://discord.gg/AQHbsahZsV

# Add to qb-target/init.lua
to model targets
```
    ["pesca-compra"] = {
        models = {
            "a_m_m_eastsa_01",

        },
        options = {
            {
                type = "client",
                event = "mt-fishing:client:AbrirLoja",
                icon = "fas fa-fish", 
                label = "Talk to emplyee",
            }
        },
        distance = 2.5,
    },
    ["pesca-venda"] = {
        models = {
            "a_f_m_fatbla_01",

        },
        options = {
            {
                type = "client",
                event = "mt-fishing:client:MenuVendas",
                icon = "fas fa-fish", 
                label = "Talk to girl",
            }
        },
        distance = 2.5,
    },
    
 ```
    
to ped models
```
    { --mt-fishing shop
        model = 'a_m_m_eastsa_01',
        coords = vector4(-1592.97, 5202.71, 3.31, 292.61),
        gender = 'male',
        freeze = true,
        invincible = false,
        blockevents = false,
    },
    { --mt-fishing shell
        model = 'a_f_m_fatbla_01',
        coords = vector4(-1038.57, -1397.1, 4.55, 80.44),
        gender = 'female',
        freeze = true,
        invincible = false,
        blockevents = false,
    },
```

# Add to qb-core/shared/items.lua

```
	-- mt-fishing
	['cana_pesca'] 			 = {['name'] = 'cana_pesca', 				['label'] = 'Fishing Rod', 				['weight'] = 100, 		['type'] = 'item', 		['image'] = 'fishingrod.png', 		['unique'] = false, 		['useable'] = true, 	['shouldClose'] = true,	   ['combinable'] = nil,   ['description'] = ''},
	['isco_pesca'] 			 = {['name'] = 'isco_pesca', 				['label'] = 'Fishing Bait', 				['weight'] = 100, 		['type'] = 'item', 		['image'] = 'fishingbait.png', 		['unique'] = false, 		['useable'] = false, 	['shouldClose'] = true,	   ['combinable'] = nil,   ['description'] = ''},
	['peixe_pesca'] 			 = {['name'] = 'peixe_pesca', 				['label'] = 'Fish', 				['weight'] = 100, 		['type'] = 'item', 		['image'] = 'fish.png', 		['unique'] = false, 		['useable'] = false, 	['shouldClose'] = true,	   ['combinable'] = nil,   ['description'] = ''},
	['peixe_exotico_pesca'] 			 = {['name'] = 'peixe_exotico_pesca', 				['label'] = 'Exotic Fish', 				['weight'] = 100, 		['type'] = 'item', 		['image'] = 'fishingshark.png', 		['unique'] = false, 		['useable'] = false, 	['shouldClose'] = true,	   ['combinable'] = nil,   ['description'] = ''},
```
# Add to qb-core/client/functions.lua
```
function QBCore.Functions.SpawnObject(model, coords, cb)
    local model = (type(model) == 'number' and model or GetHashKey(model))

    Citizen.CreateThread(function()
        RequestModel(model)
        local obj = CreateObject(model, coords.x, coords.y, coords.z, true, false, true)
        SetModelAsNoLongerNeeded(model)

        if cb then
            cb(obj)
        end
    end)
end

function QBCore.Functions.SpawnLocalObject(model, coords, cb)
    local model = (type(model) == 'number' and model or GetHashKey(model))

    Citizen.CreateThread(function()
        RequestModel(model)
        local obj = CreateObject(model, coords.x, coords.y, coords.z, false, false, true)
        SetModelAsNoLongerNeeded(model)

        if cb then
            cb(obj)
        end
    end)
end

function QBCore.Functions.DeleteObject(object)
    SetEntityAsMissionEntity(object, false, true)
    DeleteObject(object)
end
```

# Dependencies
qb-core: https://github.com/qbcore-framework/qb-core 
qb-target: https://github.com/BerkieBb/qb-target 
qb-lock: https://github.com/M-Middy/qb-lock 
qb-menu: https://github.com/qbcore-framework/qb-menu
