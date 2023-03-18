--[[__Blacklisted__]]--
Config.Blacklisted = {
    enable = true,
    entity = { -- you can put every entity model here (npc, vehicle, obj ...)
        [`rhino`] = true,
        [`hydra`] = true,
    }
}
--[[__Register Webhook__]]--
Config.Webhook = {
    channel = {
        ['supv_core'] = 'https://discord.com/api/webhooks/1037204560680329326/HYaU-R09r7fHNEGXcBfGUC3', -- Mettre le liens de votre webhook discord ici pour avoir l'info d'update de supv_core
        ['salon1'] = '', -- put link,
        ['salon2'] = '', -- ...
        -- ...
    },
    
    default = {
        bot_name = 'sublime_core',
        color = 7055103,
        localisation = 'fr_FR',
        dof = 'letter', -- 'letter' or 'numeric'
        foot_icon = 'https://avatars.githubusercontent.com/u/95303960?s=280&v=4',
        avatar = "https://avatars.githubusercontent.com/u/95303960?s=280&v=4"
    }
}
