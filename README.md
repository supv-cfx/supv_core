<h1 align='center'><u><b><a href='https://sup2ak.github.io/docs/category/supv_core'> DOCUMENTATION </a></b></u></h1>

---------

<h1 align="center"><u><b>supv_core v1.0 (work in progress!)</b></u></h1>

:fr:
- Ajouté ceci dans votre fichier `server.cfg` (Chaque paramètre est optionnel):
```cfg
## langage to use translate (default: fr)
setr supv:locale fr

## config auto loader
setr supv_core:auto_use {
    "famework": true, ## supv_core will be search for framework module (ESX, QB-Core, etc.)
    "inventory": true, ## supv_core will be search for inventory module (esx classic, qb-inventory, ox_inventory, etc.)
    "mysql": true, ## supv_core will be search for mysql module (oxmysql)
}

## config interface
setr supv_core:interface:notification:simple {
    "container": {
        "width": "fit-content",
        "maxWidth": 400,
        "minWidth": 200,
        "height": "fit-content",
        "backgroundColor": "dark.4",
        "fontFamily": "Ubuntu"
    },
    "title": {
        "fontWeight": 500,
        "lineHeight": "normal",
        "color": "gray.6"
    },
    "description": {
        "fontSize": 12,
        "color": "gray.4",
        "fontFamily": "Ubuntu",
        "lineHeight": "normal"
    },
    "descriptionOnly": {
        "fontSize": 14,
        "color": "gray.2",
        "fontFamily": "Ubuntu",
        "lineHeight": "normal"
    }
}
```

:uk: