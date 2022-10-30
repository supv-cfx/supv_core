local tr <const> = Config.SelectedLanguage
local message <const> = {
    needUpate = "^3Veuillez mettre à jour la ressource %s\n^3votre version : ^1%s ^7->^3 nouvelle version : ^2%s\n^3liens : ^4%s",
    error = "^1Impossible de vérifier la version du script"
}
local message <const> = {
	['fr'] = {
		needUpate = "^3Veuillez mettre à jour la ressource %s\n^3votre version : ^1%s ^7->^3 nouvelle version : ^2%s\n^3liens : ^4%s",
		error = "^1Impossible de vérifier la version du script"
	},

	['en'] = {
		needUpate = "^3Update this resource %s\n^3your version : ^1%s ^7->^4 new version : ^2%s\n^3link : ^4%s",
		error = "^1Impossible to check version of script"
	}
}

supv.version.check("https://raw.githubusercontent.com/SUP2Ak/supv_core/main/fxmanifest.lua", message[tr].needUpate, message[tr].error, 'lua', "https://github.com/SUP2Ak/supv_core")

-------------------------------------------------------------------------------------------
--------------------------------VERSION CHECK----------------------------------------------
-------------------------------------------------------------------------------------------
-- Ne pas toucher! / Don't touch it!

local HTTPrequest = "https://raw.githubusercontent.com/SUP2Ak/supv_core/main/version.json"

local function replaceString(str, args)
	for i = 1, #args do
		str = string.gsub(str, "#value#", args[i], 1)
	end
	return str
end

CreateThread(function()
	Wait(5000)
	local files, x = LoadResourceFile(GetCurrentResourceName(), 'version.json')
	if files then x = json.decode(files) else return print("[^1ERROR^0] Impossible de vérifier la version car le fichier n'existe pas!") end
	PerformHttpRequest(HTTPrequest, function(code, text, headers)
		if code == 200 then
			local versionArray = json.decode(text)
			local gitVersion, gitScript, gitLink = versionArray.version, versionArray.script, versionArray.link
			if gitScript ~= x.script then return ("[^1ERROR^0] Impossible de vérifier la version car le fichier a été renommée!") 
			else
				if gitVersion ~= x.version then
					print("\n^6----------------------------------------------------------------------")
					local changelog = versionArray.changelog
					local patchnote = ''
					for _,v in pairs(changelog)do
						patchnote = patchnote..v..'\n'
					end
					--print(patchnote, 'p')
					print(replaceString("^4Nouvelle version de supv_core disponible (votre version :^1 #value# ^4| nouvelle version :^2 #value#^4)", {x.version, gitVersion}))
					print(patchnote)
					print(("^8Download here : ^5%s"):format(gitLink))
					print("\n^6----------------------------------------------------------------------")
				end
			end
		else
			print(('[^6%s^0] [^1ERROR^0] Impossible de vérifier la version!'):format(tostring(x.script)))
		end
	end, 'GET')
end)

-------------------------------------------------------------------------------------------
--------------------------------VERSION CHECK----------------------------------------------
-------------------------------------------------------------------------------------------