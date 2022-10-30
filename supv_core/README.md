<h1 align="center"><u><b>supv_core v0.3b</b></u></h1>

:fr:

<h3><u>Configuration :</u></h3>

- Vous y trouverez toutes les configuration dans le fichier supv_core/resources/config


<h3><u>Liste des exports :</u></h3>

(La doc n'est pas complétement à jour car beaucoups d'ajout et pas le temps de compléter)

https://sup2ak.gitbook.io/documentation/supv-documentation/fivem-script/supv_core --> non mise à jour

<h2><u>Features :</u></h2>

``Config => client-side :``
- Gestion du traffic (npc/véhicule/véhicule en parking/trains...) - ``conso : 0.00ms``
- Gestion des récompenses (npc/véhicule) - ``conso : 0.00ms`` *système inédit qui passe par le gameEvent de GTAV*
- Gestion des audio {flag} (personnalisé) - ``conso : 0.00ms``
- Gestion des dispatch (personnalisé) - ``conso : 0.00ms``
- Gestion des relations (personnalisé) - ``conso : 0.00ms``
(cette liste n'est pas à jour... beaucoups d'ajout etc voir les changelog en dessous pour le moment)

<h1>CHANGELOG - MEMORY</h1>

<h2> supv_core </h2>

[0.3b]
- [Global] : (init des variables global, changement sur les notification, beaucoups d'ajout et de modification sur les modules et le système de cache)
- [Resources] :
    - Update cache management [client]
    - Organisation fichier config [client/config/server]
    - Voir en détails le commit sur tout les autres petits changement
- [Modules] : 
    - Add vehicle (get/set properties | spawn & spawnLocal)
    - Add stream (request)
    - Add entity (voir le commit, beaucoups de fonction disponible)
    - Edit object (tool & create)
    - Edit draw (draw.text3d)
    - Voir commit pour plus de détails car beaucoups de changement...

[0.2b]
- [Global] : (stock en mémoire la ref des native utilisable en boucle)
- [Resources] : 
    - Add gestion SyncData
    - Add gestion PlayersConnected via SyncData
    - Correction HideHud / Rewards Vehicle / Radar (option vehicle) / oncache.currentvehicle
- [Modules] :
    - Add controleActions.define() [client]
    - Add promt [client] : loading() | instructions : .set() - .draw()
    - Add json [client] : load() | [server] : load() / write()
    - Update npc [client] : Add onNet (avec syncData module) / [server] Add server (avec syncData module)
    - Update draw : remplacement de la native GetTextScreenLineCount par EndTextCommandLineCount
    - Add syncData [client/server] .set() / .get()
    
[0.1b] : beta et passage sur supv
- [Modules] : Re structuration du système modulaire afin de charger uniquement les modules utiliser sur l'importation
    - Adaptation de tout les modules au nouveaux système
    
<h2> sublime_core </h2>

[0.9a]
- [Global] :
    - Optimisation du code
- [Resources] :
    - Add noRollingGunFight
    - Add noPunchRunning
    - Add unlimitedStamina
    - Add canDoDriveBy
- [Modules] :
    - Add native notification.simple()
    - Add native notification.advanced()
    - Add native notification.help()
    - Add native notification.float()

[0.8a]
- [Global] : 
    - Change config system for import modules
- [Resources] :
    - Add Config for import
- [Modules] :
    - Add draw.progressBar (99% completed, don't try to change parameter for now : [x,y,w,h] and text form)
    - Add keyboard.input
    - Add config[service].import
    - Correct animation.strict on methods stop() [forget RemoveAnimDict]

[0.7a]
- [Global] : 
    - Resources is fixed (faute de frappe dans le config/client)
- [Modules] :
    - Add animation.strict (Possibilité de faire jouer une anim + props)
    - Add object.new (création d'un objet)

[0.6a]
- [Global] : 
    - Update version checker...
- [Resources] :
    - Add canRagdoll (possibilité de désactiver le ragdoll)",
    - Add gotDamageOnlyByPlayers (possibilité que les joueurs subissent que desdégât par des joueurs",
    - Add hideHudComponenent (possibilité de cacher les hud de gta vous pouvezajoutez celle que vous voulez cacher)",
    - Add showRadar (possibilité de cacher la minimap et de l'afficheruniquement dans des véhicule voir même le retirer de certain véhicule",
    - Add setflag (possibilité de set des flags au joueurs quand il charge)",
    - Add afkcam (possibilité de désactiver le changement de caméra quand lejoueur est afk)",
    - Add CrossHit (possibilité de désactiver les coups de crosses",
    - Add Menu Echap (possibilité de personnalisé le menu echap)",
    - Add des webhook discord (message / embed, vous pouvez toutpréconfigurer pour une utilisation rapide)",
- [Modules] :
    - Add des webhook discord dans les modules (fonctions server side etevent client side)"
    - Add string.firstToUpper

[0.5a] - Init Cache system
- [Resources] :
    - Remove gameEventTriggered
    - Init Cache and Cache.player
    - Update system for remove weapons rewards et vehicle rewards
    - Update delete police vehicle (because some bike spawn persist...)
- [Modules] : 
    - Update player with cache system (add player.currentVehicle)

[0.4a]
- [Modules] : 
    - Add Wrapper noSQL

[0.3a]
- [Resources]
    - Correction Relationship

[0.2a] - Add Modules Imports System
- [Modules] : 
    - Init draw (draw.text, draw.rect, draw.sprite, draw.text3D),
    - Init player (player.pedId, player.id, player.coords, player.serverId, player.screen[x or y]),
    - Init math (math.round),
    - Init string (string.starts),
    - Init marker (marker.new, markerObj:hidden, markerObj:remove, markerObj:visible),
- [Resources] :
    - Add RadioAudio controler
