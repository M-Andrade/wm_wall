VorpCore = {}
playersJobs = {}

TriggerEvent("getCore",function(core)
    VorpCore = core
end)

RegisterCommand('wall', function(source, args, raw)
    local source = source
    local User = VorpCore.getUser(source)
    local Character = User.getUsedCharacter

    if Character.group == 'admin' then
        TriggerClientEvent("wm-wall:client:active", source)
        Wait(500)
        TriggerClientEvent("wm-wall:client:jobs", source, playersJobs)
    else
        VorpCore.NotifyRightTip(source, "Voce nao é staff.", 4000)
    end
end)

RegisterNetEvent("wm-wall:server:jobs")
AddEventHandler("wm-wall:server:jobs", function(id)
    local source = id
    local User = VorpCore.getUser(source)
    local Character = User.getUsedCharacter
    local Job = Character.job

    table.insert(playersJobs, {["user"]=source, ["job"]=Job})
end)