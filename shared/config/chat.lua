local config = {}

config.chat_cfx = GetResourceState('chat') == 'missing'
config.chat_supv = not config.chat_cfx and true or false

return config