Config = {} -- Config from client-side
oncache = {}
--[[__Manage rewards of your server__]]--
Config.Rewards = {vehicle = false, npc = false, clearPickUpsRewards = true, listVehicle = {[`polmav`] = true, [`fbi`] = true, [`fib2`] = true, [`police`] = true, [`police2`] = true, [`police3`] = true, [`police4`] = true, [`policeb`] = true, [`policet`] = true, [`policeold1`] = true, [`policeold2`] = true, [`pranger`] = true, [`riot`] = true, [`sheriff`] = true, [`sheriff2`] = true}} -- false to desactivate rewards & true to active them / clearPickUpsRewards set true if npc = false
--[[__Manage traffic of your server & dispatch__]]--
Config.Traffic = {
    amount = {traffic = 1, npc = 1, parked = 1}, -- 0 = none / 3 is normal (max is maximum) (type: integrer, so don't write 2.5...)
    enable = {polices = false, garbageTruck = true, boats = true, trains = true},
    dispatch = { -- https://docs.fivem.net/natives/?_0xDC0F817884CDD856
        polices = {enable = false, list = {1,2,4,6,7,8,9,10,12,13}},
        army = {enable = false, list = {14}},
        ambulance = {enable = false, list = {5,3}}, -- & FireDepartement
        gang = {enable = false, list = {11,15}},
        unknow = {enable = false, list = {0}}
    },
}
--[[__Manage AudioFlag of your server__]]--
Config.AudioFlag = { -- https://docs.fivem.net/natives/?_0xB9EFD5C25018725A
    enable = true, -- turn on true to activate script
    list = {
        {enable = false, name = 'PoliceScannerDisabled'}, -- in an example how to use it, copy/past (enable = false you desactivate AudioFlag of name)
    }
}
--[[__Manage Relationship of your server__]]--
Config.Relationship = { -- https://docs.fivem.net/natives/?_0xBF25EB89375A37AD
    enable = false, -- turn on true to activate script
    list = {
        {relation = 1, group1 = {`CIVMALE`, `CIVFEMALE`, `GANG_1`, `GANG_2`, `GANG_9`, `GANG_10`, `AMBIENT_GANG_LOST`, `AMBIENT_GANG_MEXICAN`, `AMBIENT_GANG_FAMILY`, `AMBIENT_GANG_BALLAS`, `AMBIENT_GANG_MARABUNTE`, `AMBIENT_GANG_CULT`, `AMBIENT_GANG_SALVA`, `AMBIENT_GANG_WEICHENG`, `AMBIENT_GANG_HILLBILLY`, `DEALER`,`COP`, `PRIVATE_SECURITY`, `SECURITY_GUARD`, `ARMY`, `MEDIC`, `FIREMAN`, `HATES_PLAYER`, `NO_RELATIONSHIP`, `SPECIAL`, `MISSION2`, `MISSION3`, `MISSION4`, `MISSION5`, `MISSION6`, `MISSION7`, `MISSION8`}, group2 = {`PLAYER`}} -- in this example all ped are neutral with player you can make table in group1 and group2 if you want set a lot type of relationship between ped and player or ped and ped
    }
}
--[[__Manage a lot of options for any player are loaded__]]--
Config.PlayerOptions = { 
    flag = { -- https://docs.fivem.net/natives/?_0x9CFBE10D
        enable = true, -- true active script
        list = {
            {value = false, flagId = 35}, -- for player don't auto put helmet when he is on bike
            --{value = true, flagId = 429}, -- disable auto start engin when player entered in vehicle 
        }
    },
    hideHudComponent = { -- https://docs.fivem.net/natives/?_0x6806C51AD12B83B8
        enable = false,
        list = {3,4,6,7,8,9,13,14},
        scopeList = {[`WEAPON_SNIPERRIFLE`] = true,[`WEAPON_HEAVYSNIPER`] = true,[`WEAPON_MARKSMANRIFLE`] = true,[`WEAPON_HEAVYSNIPER_MKII`] = true,[`WEAPON_MARKSMANRIFLE_MK2`] = true} -- if you got 14 in list add scope weapon
    },
    canDoDriveBy = nil, -- nil per default (true can shoot in vehicle / false can't)
    noRollingGunFight = false, -- turn on true to clear task when player try press escape with weapon to roll on the ground
    noPunchRunning = false, -- turn on true to clear task when player melee attack during run
    unlimitedStamina = false, -- turn on true for sprint everytime
    CrossHit = true, -- false if you want turn off cross hit with weapon  
    afkCam = false, -- true per default, false desactivate afkCam
    canRagdoll = true, -- true per default, false desactivate ragdoll
    gotDamagedOnlyByPlayers = false, -- false per default, true active script
    showRadar = {visible = true, blacklist = {[`sanchez`] = true, [`bmx`] = true}}, -- visible: true/false or 'vehicle', if visible = 'vehicle' then you can blacklist some vehicle
}
--[[__Manage Radio Control in vehicle__]]--
Config.AudioRadio = {
    enable = 'full', -- turn on true and you use blacklist to turn off radio center key is name of car and true desable radio center, if enable = 'full' blacklist  is useless and isn't possible switch, turn off radio in every vehicle, false ignore this script
    blacklist = {
        [`police`] = true, -- some example, write hashName only
        --[`taxi`] = true,
        --- ....
    }
}
--[[__Edit echap menu__]]--
Config.PauseMenu = {
    enable = true,
    title = 'sublime_core',
    map = 'sublime city',
    game = 'you want left?',
    disconnect = 'quit city',
    quit = 'quit game',
    information = 'breafing',
    stats = 'statistique',
    setting = 'settigs',
    fivemKey = 'key fivem' ,
    gallery = 'gallery',
    editor = 'editor',
}




Config.import = {
    marker = {
        m1 = {
            visible = true,
            id = 27,
            z = -0.99,
            color1 = {6,34,86,100},
            color2 = {255,255,255,100},
            dir = {0.0,0.0,0.0},
            rot = {0.0,0.0,0.0},
            scale = {2.0,2.0,2.0},
            updown = false,
            faceToCam = false,
            p19 = 2,
            rotate = false,
            textureDict = nil,
            textureName = nil,
            drawOnEnts = false
        },
        m2 = {
            visible = true,
            id = 20,
            z = 0.5,
            color1 = {6,34,86,100},
            color2 = {255,255,255,100},
            dir = {0.0,0.0,0.0},
            rot = {0.0,180.0,0.0},
            scale = {0.5,0.5,0.2},
            updown = false,
            faceToCam = false,
            p19 = 2,
            rotate = true,
            textureDict = nil,
            textureName = nil,
            drawOnEnts = false
        },
    },
    draw = {
        progressbar = {
            text = '',
            progressAnim = "simple",
            progressType = "sprite",
            color1 = {0, 0, 0, 100},
            color2 = {6, 34, 86,125},
            colorCancel = {255, 0, 0, 125},
            police = 0,
            canCancel = false,
            textCancel = "Canceled...",
            showCancelStatus = false,
            cancelStatus0 = {"mpsafecracking", "lock_closed"}, -- {"mpleaderboard", "leaderboard_votecross_icon"}
            cancelStatus1 = {"mpsafecracking", "lock_open"}, -- {"mpleaderboard", "leaderboard_votetick_icon"}
            animation = nil,
            prop = nil,
            time = 0,
            x = 0,
            y = 900,
            w = 431,
            h = 33,
            badgeleft = nil,
            -- only for sprite
            textureDict1 = "commonmenu",
            textureDict2 = "commonmenu",
            textureAnim1 = "gradient_bgd",
            textureAnim2 = "interaction_bgd",
            heading = 0.0
        },
    },
    npc = {
        client = {
            hash = ``,
            data = {
                blockevent = true,
                freeze = true,
                godmode = true,
                variation = nil,
            },
            weapon = {
                hash = nil, -- `WEAPON_PISTOL`
                ammo = 250,
                visible = false,
            },
        },
        syncClient = {
            hash = ``,
            data = {
                blockevent = true,
                freeze = true,
                godmode = true,
                variation = nil,
            },
            weapon = {
                hash = nil, -- `WEAPON_PISTOL`
                ammo = 250,
                visible = false,
            },
        }
    },
}
