local playersInRace = {}

Citizen.CreateThread(function()
	while true do
        Citizen.Wait(0)
        --testPlayers()
        local ped = GetPlayerPed(-1)
        local veh = GetVehiclePedIsIn(ped, false)
        local closestVeh = GetLeadCar(veh,Config.distance)
        local closestPlayer, closestPlayerDist = GetClosestPlayer()
        print('closest player', closestPlayer)
        if Config.requireRaces then
            local playerInRace = table.find(playersInRace,GetPlayerServerId(closestPlayer))
            --print('players in race', table.unpack(playersInRace))
            if(closestPlayerDist <= Config.distance) and (closestPlayerDist >= Config.minDistance) and playerInRace and closestVeh then
                boostCar(closestPlayerDist,veh)
                --debugs
                --print('Car in front is player in race',playerInRace)
                print('Boosting Car')
            end
        else 
            if(closestPlayerDist <= Config.distance) and (closestPlayerDist >= Config.minDistance) and closestVeh then
                boostCar(closestPlayerDist,veh)
                --debugs
                --print('Car in front is player in race',playerInRace)
                print('Boosting Car')
            end
        end
    end
end)


function boostCar(leadDistance, veh)
    -- boost car if it meets requirements
    if(leadDistance >= Config.distance) then
        SetVehicleBoostActive(veh,false)
        SetVehicleEnginePowerMultiplier(veh,1.0)
        SetVehicleEngineTorqueMultiplier(veh,1.0)
    elseif(leadDistance <= Config.distance) then
        SetVehicleBoostActive(veh,true)
        SetVehicleEnginePowerMultiplier(veh,Config.boost)
        SetVehicleEngineTorqueMultiplier(veh,Config.boost/2)
    elseif(leadDistance <= Config.distance/2) then
        SetVehicleBoostActive(veh,true)
        SetVehicleEnginePowerMultiplier(veh,Config.boost/2)
        SetVehicleEngineTorqueMultiplier(veh,Config.boost/4)
    end
end

function GetLeadCar(chaseCar, distance)
    --[[
        Gets the first vehicle ahead of the chase car.
        Returns a vehicle entity or nil.
        Thanks hattie :)
    --]]
    local coords = GetOffsetFromEntityInWorldCoords(chaseCar,0.0,1.0,0.3)
    local coords2 = GetOffsetFromEntityInWorldCoords(chaseCar, 0.0,distance,0.0)
    local rayhandle = CastRayPointToPoint(coords, coords2, 10, chaseCar, 0)
    local _, _, _, _, entityHit = GetRaycastResult(rayhandle)


    if entityHit>0 and IsEntityAVehicle(entityHit) and GetIsVehicleEngineRunning(entityHit) and IsPedAPlayer(GetPedInVehicleSeat(entityHit,-1)) then
        return entityHit
    else
        return nil
    end
end


--Client event for getting client ID's in race
RegisterNetEvent("Drafting:draftMonitor")
AddEventHandler("Drafting:draftMonitor", function(racers)
    playersInRace = racers
end)

