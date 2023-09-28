local emit <const> = require 'imports.emit.server'

function supv.notify(source, select, data)
    emit.net('notify', source, select, data)
end