## A basic Drafting resource for FiveM

### dependencies
* StreetRaces

Currently I've used the StreetRaces resource to do the checks if a player is in a race, you will need to modified your race resource as well to do so the following Events/Triggers need to be added.

```RegisterNetEvent("StreetRaces:getRacers")
AddEventHandler("StreetRaces:getRacers", function(index)
    -- print('race index id:', index)
    -- print('sending racer ids to', source)
    local  players = races[index].players
    TriggerClientEvent("Drafting:draftMonitor", source, players)
end)
```


The following TriggerServerEvent needs to be added to the race client script this needs to happen near the start of a race to send the clients the player ID's in the race.
```
TriggerServerEvent("StreetRaces:getRacers",  raceStatus.index)
```

Finally add 
`start fng_drafting`
to your server.cfg

### Credits
Hattiehats - helped a lot with some functions / debugging
Juzty - for testing enviroment