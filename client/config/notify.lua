return {
    type = 'react', -- native | react <wip>

    -- native notify (gta5/redm)
    native = {
        
    },

    -- react notify
    react = {
        maxNotification = 6, -- queue max size
        notificationStyles = GetConvar('supv_core:interface:notification:simple'),
    }
}