local ShowPlayerNames = false
local TagDrawDistance = 50
local ActivePlayers = {}
local playersJobs = {}
local MyCoords = vector3(0, 0, 0)

local VORPcore = exports.vorp_core:GetCore()

RegisterNetEvent("wm-wall:client:active")
AddEventHandler("wm-wall:client:active", function(source)
	ShowPlayerNames = not ShowPlayerNames

	Citizen.CreateThread(function()
		while ShowPlayerNames do
			ActiveWall()
			MyCoords = GetEntityCoords(PlayerPedId())
	
			Citizen.Wait(5)
		end
	end)
	Citizen.CreateThread(function()
		while ShowPlayerNames do
			CheckPlayersJobs()
	
			Citizen.Wait(5000)
		end
	end)
end)

RegisterNetEvent("wm-wall:client:jobs")
AddEventHandler("wm-wall:client:jobs", function(tableJobs)
	playersJobs = tableJobs
end)

function CheckPlayersJobs()
	ActivePlayers = GetActivePlayers()
	for _, playerId in ipairs(ActivePlayers) do
		local id = GetPlayerServerId(playerId)
		TriggerServerEvent("wm-wall:server:jobs", id)
	end
end

function DrawText3D(x, y, z, text)
	local onScreen, screenX, screenY = GetScreenCoordFromWorldCoord(x, y, z)

	SetTextScale(0.35, 0.35)
	SetTextFontForCurrentCommand(1)
	SetTextColor(255, 255, 255, 223)
	SetTextCentre(1)
	DisplayText(CreateVarString(10, "LITERAL_STRING", text), screenX, screenY)
end

function GetPedCrouchMovement(ped)
	return Citizen.InvokeNative(0xD5FE956C70FF370B, ped)
end

function VoiceChatIsPlayerSpeaking(player)
	return Citizen.InvokeNative(0xEF6F2A35FAAF2ED7, player)
end

function ActiveWall()
	if ShowPlayerNames then
		for _, playerId in ipairs(ActivePlayers) do
			local ped = GetPlayerPed(playerId)
			local pedCoords = GetEntityCoords(ped)
			local id = GetPlayerServerId(playerId)

			for k,v in ipairs(playersJobs) do
				if id == v.user then
					if #(MyCoords - pedCoords) <= TagDrawDistance and not GetPedCrouchMovement(ped) then
						local text = "ID: "..id.. " / "..GetPlayerName(playerId).."\n Job: "..v.job
						

						if VoiceChatIsPlayerSpeaking(playerId) then
							text = "~d~Talking: ~s~" .. text
						end

						DrawText3D(pedCoords.x, pedCoords.y, pedCoords.z + 1, text)
					end
				end
			end
		end
	end
end

Citizen.CreateThread(function()
	TriggerEvent('chat:addSuggestion', '/wall', 'Show/hide player infos')
end)
