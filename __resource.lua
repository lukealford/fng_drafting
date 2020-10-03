resource_manifest_version '44febabe-d386-4d18-afbe-5e627f4af937'

description 'TRP Drafting'

version '0.5.0'

client_scripts {
    'config.lua',
    'client_helpers.lua',
    'client.lua'
}
server_scripts {
    '@StreetRaces/races_sv.lua'
}
dependencies { 
    'StreetRaces',
}