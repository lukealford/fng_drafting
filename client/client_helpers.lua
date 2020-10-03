
--lua function for finding a value in a table
function table.find(t,value)
    if t and type(t)=="table" and value then
        for _, v in ipairs (t) do
            if v == value then
                return true;
            end
        end
        return false;
    end
    return false;
end


--debug lead car function, send vehicle ID
function drawMarkerOnLead(vehID)
    --[[
        Draws a marker on lead car
        this was a debug function
    ]]--
    Citizen.CreateThread(function()
        while true do
            Citizen.Wait(0)
            local vx,vy,vz = table.unpack(GetEntityCoords(vehID, true))
            DrawMarker(2,vx,vy,vz+ 2, 0.0, 0.0, 0.0, 0.0, 180.0, 0.0, 2.0, 2.0, 2.0, 255, 128, 0, 50, false, true, 2, nil, nil, false)
        end
    end)

end

--function for getting closest players pretty self explanitory 
function GetClosestPlayer()
    local players = GetPlayers()
    local closestDistance = -1
    local closestPlayer = -1
    local ply = GetPlayerPed(-1)
    local plyCoords = GetEntityCoords(ply, 0)
    
    for index,value in ipairs(players) do
        local target = GetPlayerPed(value)
        if(target ~= ply) then
            local targetCoords = GetEntityCoords(GetPlayerPed(value), 0)
            local distance = Vdist(targetCoords["x"], targetCoords["y"], targetCoords["z"], plyCoords["x"], plyCoords["y"], plyCoords["z"])
            if(closestDistance == -1 or closestDistance > distance) then
                closestPlayer = value
                closestDistance = distance
            end
        end
    end
    
    return GetPlayerServerId(closestPlayer), closestDistance
end


--required for the above function
function GetPlayers()

    local esxPlayers = ESX.Game.GetPlayers()
    local players = {}
    for k,v in ipairs(esxPlayers) do
        table.insert(players, v)
    end
    return players
end


function GetAngleOfAttack(leadCar,chaseCar)
    return math.abs(GetEntityHeading(leadCar)-GetEntityHeading(chaseCar))
end


function screenBlur(duration, player)
    if duration < 0 then -- loop
        SetEntityMotionBlur(player, true) 
    else
        SetPedMotionBlur(player, true) 
        Citizen.CreateThread(function() -- force stop the screen effect after duration+1 seconds
            Citizen.Wait(math.floor((duration+1)*1000))
            SetEntityMotionBlur(player, false) 
        end)
    end
end


function maxSpeedCheck(veh)
    local maxS = GetEntitySpeed(veh) 
    local maxSMph = convertToMph(maxS)
    if (maxSMph <= Config.maxSpeed) then
        return true
    else
        return false
    end
end

function minSpeedCheck(veh)
    local minS = GetEntitySpeed(veh) 
    local minSMph = convertToMph(minS)
    if ( minSMph >= Config.minSpeed) then
        return true
    else
        return false
    end
end


function convertToMph(speed)
    mph = (speed * 2.236936)
    --print('current speed', mph)
    return mph
end 


function boostCar(leadDistance, veh)
    -- boost car if it meets requirements
    if(leadDistance >= Config.maxDistance) then
        SetVehicleBoostActive(veh,false)
        setBoost(veh,1.0,1.0)
    elseif(leadDistance <= Config.maxDistance) then
        SetVehicleBoostActive(veh,true)
        setBoost(veh,Config.boost,Config.boost/2)
    elseif(leadDistance <= Config.minDistance) then
        SetVehicleBoostActive(veh,true)
        setBoost(veh,Config.boost/2,Config.boost/4)
    else
        setBoost(veh,1.0,1.0)
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


function setBoost(veh, power, torque)
    SetVehicleEnginePowerMultiplier(veh,power)
    SetVehicleEngineTorqueMultiplier(veh,torque)
end