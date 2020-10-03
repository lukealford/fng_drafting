
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
       Draws a marker on lead car // this was a debug function
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
        SetPedMotionBlur(player, true) 
    else
        SetPedMotionBlur(player, true) 
        Citizen.CreateThread(function() -- force stop the screen effect after duration+1 seconds
            Citizen.Wait(math.floor((duration+1)*1000))
            SetPedMotionBlur(player, false) 
        end)
    end
end


function maxSpeedCheck(veh)
    local maxS = GetEntitySpeed(veh) 
    local maxSMph = convertToMph(maxS)
    if (maxSMph <= Config.maxSpeed) then
        --print('Less than max speed')
        return true
    else
        return false
    end
end

function minSpeedCheck(veh)
    local minS = GetEntitySpeed(veh) 
    local minSMph = convertToMph(minS)
    if ( minSMph >= Config.minSpeed) then
        --print('Over min speed')
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