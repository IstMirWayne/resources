voiceData = {}
radioData = {}
callData = {}

mumbleConfig = {
	debug = false, -- Debug-Nachrichten aktivieren
	voiceModes = {
		{2.5, "Flüstern"},   -- Flüstermodus: Sprachreichweite in GTA-Einheiten
		{8.0, "Normal"},     -- Normalmodus: Sprachreichweite in GTA-Einheiten
		{20.0, "Schreien"},  -- Schreimodus: Sprachreichweite in GTA-Einheiten
	},
	speakerRange = 1.5, -- Reichweite des Lautsprechermodus (z. B. für Funk oder Telefon)
	callSpeakerEnabled = true, -- Umstehende können Telefonate mithören, wenn sie nah genug stehen
	radioEnabled = true, -- Funkgerät aktivieren oder deaktivieren
	micClicks = true, -- Mikrofonklick-Geräusche aktivieren
	micClickOn = true, -- Mikrofonklick bei Aktivierung
	micClickOff = true, -- Mikrofonklick bei Deaktivierung
	micClickVolume = 0.1, -- Lautstärke der Mikrofonklicks
	radioClickMaxChannel = 100, -- Maximaler Funkkanal mit lokalen Klickgeräuschen
	controls = {
		proximity = {
			key = 20, -- Taste Z
		}, -- Sprachreichweite wechseln
		radio = {
			pressed = false, -- nicht ändern
			key = 137, -- Feststelltaste
		}, -- Funk verwenden
		speaker = {
			key = 20, -- Taste Z
			secondary = 21, -- Linke Umschalttaste
		} -- Lautsprechermodus (Telefon)
	},
	radioChannelNames = {
		[1] = "Polizei Tac 1",
		[2] = "Polizei Tac 2",
		[3] = "Rettung Tac 1",
		[4] = "Rettung Tac 2",
		[500] = "Testkanal 500",
	},
	callChannelNames = {
		-- Anrufkanäle benennen (optional)
	},
	use3dAudio = true, -- 3D-Audio aktivieren
	useSendingRangeOnly = true, -- Nur Sendereichweite berücksichtigen (empfohlen)
	useNativeAudio = false, -- Native Audio-Funktion (z. B. Innenräume)
	useExternalServer = false, -- Externen Sprachserver verwenden
	externalAddress = "127.0.0.1", -- IP-Adresse des externen Servers
	externalPort = 30120, -- Port des externen Servers
	use2dAudioInVehicles = true, -- 2D-Audio im Fahrzeug bei hohen Geschwindigkeiten aktivieren
	showRadioList = true, -- Spieler im Funkkanal anzeigen
}

resourceName = GetCurrentResourceName()

phoneticAlphabet = {
	"Alpha", "Bravo", "Charlie", "Delta", "Echo", "Foxtrot",
	"Golf", "Hotel", "India", "Juliet", "Kilo", "Lima",
	"Mike", "November", "Oscar", "Papa", "Quebec", "Romeo",
	"Sierra", "Tango", "Uniform", "Victor", "Whisky", "XRay",
	"Yankee", "Zulu"
}

if IsDuplicityVersion() then
	function DebugMsg(msg)
		if mumbleConfig.debug then
			print("\x1b[32m[" .. resourceName .. "]\x1b[0m ".. msg)
		end
	end
else
	function DebugMsg(msg)
		if mumbleConfig.debug then
			print("[" .. resourceName .. "] ".. msg)
		end
	end

	-- Konfiguration von außerhalb anpassen
	function SetMumbleProperty(key, value)
		if mumbleConfig[key] ~= nil and mumbleConfig[key] ~= "controls" and mumbleConfig[key] ~= "radioChannelNames" then
			mumbleConfig[key] = value

			if key == "callSpeakerEnabled" then
				SendNUIMessage({ speakerOption = mumbleConfig.callSpeakerEnabled })
			end
		end
	end

	-- Namen für Funkkanäle setzen
	function SetRadioChannelName(channel, name)
		local channel = tonumber(channel)

		if channel ~= nil and name ~= nil and name ~= "" then
			if not mumbleConfig.radioChannelNames[channel] then
				mumbleConfig.radioChannelNames[channel] = tostring(name)
			end
		end
	end

	-- Namen für Anrufkanäle setzen
	function SetCallChannelName(channel, name)
		local channel = tonumber(channel)

		if channel ~= nil and name ~= nil and name ~= "" then
			if not mumbleConfig.callChannelNames[channel] then
				mumbleConfig.callChannelNames[channel] = tostring(name)
			end
		end
	end

	-- Exportfunktionen registrieren
	exports("SetMumbleProperty", SetMumbleProperty)
	exports("SetTokoProperty", SetMumbleProperty)
	exports("SetRadioChannelName", SetRadioChannelName)
	exports("SetCallChannelName", SetCallChannelName)
end

-- Zufälliger Buchstabe aus dem phonetischen Alphabet
function GetRandomPhoneticLetter()
	math.randomseed(GetGameTimer())
	return phoneticAlphabet[math.random(1, #phoneticAlphabet)]
end

-- Spieler in bestimmtem Funkkanal erhalten
function GetPlayersInRadioChannel(channel)
	local channel = tonumber(channel)
	local players = false

	if channel ~= nil then
		if radioData[channel] ~= nil then
			players = radioData[channel]
		end
	end

	return players
end

-- Spieler aus mehreren Funkkanälen erhalten
function GetPlayersInRadioChannels(...)
	local channels = { ... }
	local players = {}

	for i = 1, #channels do
		local channel = tonumber(channels[i])

		if channel ~= nil then
			if radioData[channel] ~= nil then
				players[#players + 1] = radioData[channel]
			end
		end
	end

	return players
end

-- Alle Funkkanäle und ihre Spieler zurückgeben
function GetPlayersInAllRadioChannels()
	return radioData
end

-- Spieler, die sich im gleichen Funkkanal wie ein anderer Spieler befinden
function GetPlayersInPlayerRadioChannel(serverId)
	local players = false

	if serverId ~= nil then
		if voiceData[serverId] ~= nil then
			local channel = voiceData[serverId].radio
			if channel > 0 then
				if radioData[channel] ~= nil then
					players = radioData[channel]
				end
			end
		end
	end

	return players
end

-- Funkkanal eines Spielers abfragen
function GetPlayerRadioChannel(serverId)
	if serverId ~= nil then
		if voiceData[serverId] ~= nil then
			return voiceData[serverId].radio
		end
	end
end

-- Anrufkanal eines Spielers abfragen
function GetPlayerCallChannel(serverId)
	if serverId ~= nil then
		if voiceData[serverId] ~= nil then
			return voiceData[serverId].call
		end
	end
end

-- Exporte für Zugriff von anderen Ressourcen
exports("GetPlayersInRadioChannel", GetPlayersInRadioChannel)
exports("GetPlayersInRadioChannels", GetPlayersInRadioChannels)
exports("GetPlayersInAllRadioChannels", GetPlayersInAllRadioChannels)
exports("GetPlayersInPlayerRadioChannel", GetPlayersInPlayerRadioChannel)
exports("GetPlayerRadioChannel", GetPlayerRadioChannel)
exports("GetPlayerCallChannel", GetPlayerCallChannel)
