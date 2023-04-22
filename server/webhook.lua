local cfg <const> = require 'server.config.webhook'

print(json.encode(cfg, {indent=true}))