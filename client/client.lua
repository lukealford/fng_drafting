
ESX = nil
TriggerEvent('esx:getSharedObject', function(obj)
    ESX = obj
end)

local playersInRace = {}

Citizen.CreateThread(function()
	while true do
        Citizen.Wait(0)
        local ped = GetPlayerPed(-1)
        local veh = GetVehiclePedIsIn(ped, false)
        local closestVeh = GetLeadCar(veh,Config.maxDistance)
        local closestPlayer, closestPlayerDist = GetClosestPlayer()
        if Config.requireRaces then
            local playerInRace = table.find(playersInRace,closestPlayer)
            --print('players in race', table.unpack(playersInRace))
            if(closestPlayerDist <= Config.maxDistance) and (closestPlayerDist >= Config.minDistance) and (GetAngleOfAttack(closestVeh, veh) <= Config.AngleOfAttack) and playerInRace and maxSpeedCheck(veh) and minSpeedCheck(veh) and closestVeh then
                    boostCar(closestPlayerDist,veh)
                    screenBlur(ped, 5000)
                    --debugs
                    --print('Car in front is player in race',playerInRace)
                    --print('Boosting Car')
                else
                    setBoost(veh,1.0,1.0)
            end
        else 
            if(closestPlayerDist <= Config.maxDistance) and (closestPlayerDist >= Config.minDistance)  and (GetAngleOfAttack(closestVeh, veh) <= Config.AngleOfAttack) and maxSpeedCheck(veh) and minSpeedCheck(veh) and closestVeh then
                    boostCar(closestPlayerDist,veh)
                    screenBlur(ped, 5000)
                    --debugs
                    --print('Car in front is player in race',playerInRace)
                    --print('Boosting Car')
                else
                    setBoost(veh,1.0,1.0)
            end
        end
    end
end)


--Client event for getting client ID's in race
RegisterNetEvent("Drafting:draftMonitor")
AddEventHandler("Drafting:draftMonitor", function(racers)
    playersInRace = racers
end)