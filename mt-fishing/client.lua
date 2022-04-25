local QBCore = exports['qb-core']:GetCoreObject()


-- Eventos
RegisterNetEvent('mt-fishing:client:MenuCompras', function(data)
    exports['qb-menu']:openMenu({
        {
            header = "Fishing Shop",
            isMenuHeader = true,
        },
        {
            header = "Fishing Rod",
            txt = "Price: <br> 100$",
            params = {
                event = "mt-fishing:client:ComprarCana",
            }
        },
        {
            header = "Fishing Bait",
            txt = "Price: <br> 10$",
            params = {
                event = "mt-fishing:client:ComprarIsco",
            }
        },
        {
            header = "Rent a Boat",
            txt = "Price: <br> 1000$",
            params = {
                event = "mt-fishing:client:AlugarBarco",
            }
        },
        {
            header = "< Close",
            txt = "",
            params = {
                event = "qb-menu:closeMenu",
            }
        },
    })
end)

RegisterNetEvent('mt-fishing:client:ComprarCana', function(data)
    TriggerServerEvent('mt-fishing:server:ComprarCana')
    TriggerEvent('mt-fishing:client:MenuCompras')
end)

RegisterNetEvent('mt-fishing:client:ComprarIsco', function(data)
    TriggerServerEvent('mt-fishing:server:ComprarIsco')
    TriggerEvent('mt-fishing:client:MenuCompras')
end)

RegisterNetEvent('mt-fishing:client:AlugarBarco', function(data)
    local vehicle = 'dinghy'
    local coords = vector4(-1600.0, 5211.65, 0.15, 115.64)
    TriggerServerEvent('mt-fishing:server:RemoverDinheiroAluger')
    QBCore.Functions.SpawnVehicle(vehicle, function(veh)
        SetVehicleNumberPlateText(veh, "FISH"..tostring(math.random(1000, 9999)))
        exports['LegacyFuel']:SetFuel(veh, 100.0)
        --SetEntityHeading(veh, coords.h)
        TaskWarpPedIntoVehicle(GetPlayerPed(-1), veh, -1)
        TriggerEvent("vehiclekeys:client:SetOwner", GetVehicleNumberPlateText(veh))
        SetVehicleEngineOn(veh, true, true)
    end, coords, true) 
end)

RegisterNetEvent('mt-fishing:client:AbrirLoja', function(data)
    QBCore.Functions.Progressbar('fishing_store', 'TALKING TO EMPLOYEE...', 1000, false, true, { -- Name | Label | Time | useWhileDead | canCancel
        disableMovement = true,
        disableCarMovement = true,
        disableMouse = false,
        disableCombat = true,
    }, {}, {}, {}, function() -- Play When Done
        TriggerServerEvent("InteractSound_SV:PlayOnSource", "monkeyopening", 0.1)
        TriggerEvent('mt-fishing:client:MenuCompras')
    end)
end)

RegisterNetEvent('mt-fishing:client:MenuVendas', function(data)
    QBCore.Functions.Progressbar('fishing_store', 'TALKING TO EMPLOYEE...', 1000, false, true, { -- Name | Label | Time | useWhileDead | canCancel
        disableMovement = true,
        disableCarMovement = true,
        disableMouse = false,
        disableCombat = true,
    }, {}, {}, {}, function() -- Play When Done
        TriggerServerEvent("InteractSound_SV:PlayOnSource", "monkeyopening", 0.1)
        exports['qb-menu']:openMenu({
            {
                header = "Sell Fish Employee",
                isMenuHeader = true,
            },
            {
                header = "Sell All Fish",
                txt = "You'll sell all fish that you have on you <br> Prices: <br> Exotic Fish - 100$ <br> Fish - 10$",
                params = {
                    event = "mt-fishing:client:VenderPeixe",
                }
            },
            {
                header = "< Close",
                txt = "",
                params = {
                    event = "qb-menu:closeMenu",
                }
            },
        })
    end)
end)

RegisterNetEvent('mt-fishing:client:VenderPeixe', function(data)
    TriggerServerEvent('mt-fishing:server:VenderPeixe')
end)


RegisterNetEvent('mt-fishing:client:ComecarPesca', function(data)
    local ped = PlayerPedId()
    local time = math.random(1000, 5000)
    local pos = GetEntityCoords(ped)

    QBCore.Functions.TriggerCallback('QBCore:HasItem', function(HasItem)
        if HasItem and GetWaterHeight(pos.x, pos.y, pos.z-2, pos.z - 3.0) then
            local ped = PlayerPedId()
            local animDict = "amb@world_human_stand_fishing@idle_a"
            local animName = "idle_c" 
            local pedPos = GetEntityCoords(ped)
            local fishingRodHash = `prop_fishing_rod_01`
            local bone = GetPedBoneIndex(ped, 18905)
            RequestAnimDict(animDict)
			while not HasAnimDictLoaded(animDict) do
				Wait(100)
			end
			TaskPlayAnim(ped, animDict, animName, 1.0, -1.0, 1.0, 11, 0, 0, 0, 0)   
            rodHandle = CreateObject(fishingRodHash, pedPos, true)
            AttachEntityToEntity(rodHandle, ped, bone, 0.1, 0.05, 0, 80.0, 120.0, 160.0, true, true, false, true, 1, true)
            Wait(time)
            local success = exports['qb-lock']:StartLockPickCircle(5,20)
            if success then
                TriggerServerEvent('mt-fishing:server:DarPeixe')
                ClearPedTasks(ped)
                DeleteObject(fishingRodHash)
                DeleteEntity(fishingRodHash)
            else
                TriggerServerEvent('mt-fishing:server:PerderIsco')
                QBCore.Functions.Notify('The fish scape...', 'error', 7500)
                ClearPedTasks(ped)
                DeleteObject(fishingRodHash)
                DeleteEntity(fishingRodHash)
            end
        else
        QBCore.Functions.Notify("You dont have any fishing bait or not near water...", "error")
        end
      end, 'isco_pesca')
end)

-- Threads
Citizen.CreateThread(function()
    local blip = AddBlipForCoord(-1592.64, 5202.2, 4.31)
	SetBlipSprite(blip, 88)
	SetBlipDisplay(blip, 4)
	SetBlipScale(blip, 0.7)
	SetBlipAsShortRange(blip, true)
	SetBlipColour(blip, 37) -- Mudar cor aqui!
	BeginTextCommandSetBlipName("STRING")
	AddTextComponentSubstringPlayerName("Fishing Shop")
    EndTextCommandSetBlipName(blip)
end)