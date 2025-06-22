voiceData = {}
radioData = {}
callData = {}

mumbleConfig = {
	debug = false, -- Debug-Nachrichten anzeigen
	voiceModes = {
		{2.5, "Flüstern"},   -- Sprachreichweite: Flüstern
		{8.0, "Normal"},     -- Sprachreichweite: Normal
		{20.0, "Rufen"},     -- Sprachreichweite: Rufen
	},
	speakerRange = 1.5, -- Entfernung, um Gespräche anderer (Funk/Telefon) mitzuhören
	callSpeakerEnabled = true, -- Telefongespräche für Umstehende hörbar
	radioEnabled = false, -- Funk aktivieren
	micClicks = true, -- Mikrofonklicks aktivieren
	micClickOn = true, -- Klick beim Sprechen
	micClickOff = true, -- Klick beim Loslassen
	micClickVolume = 0.1, -- Lautstärke der Klicks
	radioClickMaxChannel = 100, -- Klicks nur für Kanäle bis 100 aktiv

	controls = {
		proximity = {
			key = 57, -- F10 für Sprachreichweite
		},
		radio = {
			pressed = false,
			key = 137, -- CAPSLOCK für Funk
		},
		speaker = {
			key = 20, -- Z für Lautsprecher (Telefon)
			secondary = 21, -- LEFT SHIFT
		}
	},

	radioChannelNames = {
		[1] = "LSPD Funk",
		[2] = "BCSO Funk",
		[3] = "SAST Funk",
		[4] = "Gemeinsamer Funk 1",
		[5] = "Gemeinsamer Funk 2",
		[6] = "Gemeinsamer Funk 3",
	},

	callChannelNames = {
		-- Eigene Namen für Telefonkanäle (optional)
	},

	use3dAudio = true, -- 3D-Audio aktivieren
	useSendingRangeOnly = true, -- Nur die eigene Reichweite verwenden
	useNativeAudio = false, -- Kein natives GTA-Audio (z. B. Raumklang)
	useExternalServer = false, -- Kein externer Sprachserver notwendig
	externalAddress = "127.0.0.1",
	externalPort = 30120,
	use2dAudioInVehicles = true, -- Passagiere im Auto immer hörbar
	showRadioList = true, -- Liste der Spieler im Funkkanal anzeigen (wenn UI aktiv)
}

resourceName = GetCurrentResourceName()

phoneticAlphabet = {
	"Alpha", "Bravo", "Charlie", "Delta", "Echo", "Foxtrot", "Golf", "Hotel",
	"India", "Juliet", "Kilo", "Lima", "Mike", "November", "Oscar", "Papa",
	"Quebec", "Romeo", "Sierra", "Tango", "Uniform", "Victor", "Whisky",
	"XRay", "Yankee", "Zulu"
}

if IsDuplicityVersion() then
	function DebugMsg(msg)
		if mumbleConfig.debug then
			print("\x1b[32m[" .. resourceName .. "]\x1b[0m " .. msg)
		end
	end
else
	function DebugMsg(msg)
		if mumbleConfig.debug then
			print("[" .. resourceName .. "] " .. msg)
		end
	end

	function SetMumbleProperty(key, value)
		if mumbleConfig[key] ~= nil and key ~= "controls" and key ~= "radioChannelNames" then
			mumbleConfig[key] = value

			if key == "callSpeakerEnabled" then
				SendNUIMessage({ speakerOption = mumbleConfig.callSpeakerEnabled })
			end
		end
	end

	function SetRadioChannelName(channel, name)
		channel = tonumber(channel)
		if channel and name and name ~= "" then
			mumbleConfig.radioChannelNames[channel] = tostring(name)
		end
	end

	function SetCallChannelName(channel, name)
		channel = tonumber(channel)
		if channel and name and name ~= "" then
			mumbleConfig.callChannelNames[channel] = tostring(name)
		end
	end

	exports("SetMumbleProperty", SetMumbleProperty)
	exports("SetTokoProperty", SetMumbleProperty)
	exports("SetRadioChannelName", SetRadioChannelName)
	exports("SetCallChannelName", SetCallChannelName)
end

function GetRandomPhoneticLetter()
	math.randomseed(GetGameTimer())
	return phoneticAlphabet[math.random(1, #phoneticAlphabet)]
end

function GetPlayersInRadioChannel(channel)
	channel = tonumber(channel)
	return channel and radioData[channel] or false
end

function GetPlayersInRadioChannels(...)
	local channels = { ... }
	local players = {}

	for i = 1, #channels do
		local channel = tonumber(channels[i])
		if channel and radioData[channel] then
			players[#players + 1] = radioData[channel]
		end
	end

	return players
end

function GetPlayersInAllRadioChannels()
	return radioData
end

function GetPlayersInPlayerRadioChannel(serverId)
	if serverId and voiceData[serverId] then
		local channel = voiceData[serverId].radio
		if channel > 0 and radioData[channel] then
			return radioData[channel]
		end
	end
	return false
end

function GetPlayerRadioChannel(serverId)
	return serverId and voiceData[serverId] and voiceData[serverId].radio
end

function GetPlayerCallChannel(serverId)
	return serverId and voiceData[serverId] and voiceData[serverId].call
end

exports("GetPlayersInRadioChannel", GetPlayersInRadioChannel)
exports("GetPlayersInRadioChannels", GetPlayersInRadioChannels)
exports("GetPlayersInAllRadioChannels", GetPlayersInAllRadioChannels)
exports("GetPlayersInPlayerRadioChannel", GetPlayersInPlayerRadioChannel)
exports("GetPlayerRadioChannel", GetPlayerRadioChannel)
exports("GetPlayerCallChannel", GetPlayerCallChannel)