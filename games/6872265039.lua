local run = function(...)
	local suc, res = pcall(...)
	if not suc then
		warn("A module had issues loading;\n"..res)
		return
	end
	return res
end
local cloneref = cloneref or function(obj) return obj end

local playersService = cloneref(game:GetService('Players'))
local replicatedStorage = cloneref(game:GetService('ReplicatedStorage'))
local inputService = cloneref(game:GetService('UserInputService'))

local lplr = playersService.LocalPlayer
local vape = shared.vape
local entitylib = vape.Libraries.entity
local sessioninfo = vape.Libraries.sessioninfo
local bedwars = {}

local function notif(...)
	return vape:CreateNotification(...)
end

run(function()
	local function dumpRemote(tab)
		local ind = table.find(tab, 'Client')
		return ind and tab[ind + 1] or ''
	end

	local KnitInit, Knit
	repeat
		KnitInit, Knit = pcall(function() return debug.getupvalue(require(lplr.PlayerScripts.TS.knit).setup, 6) end)
		if KnitInit then break end
		task.wait()
	until KnitInit
	if not debug.getupvalue(Knit.Start, 1) then
		repeat task.wait() until debug.getupvalue(Knit.Start, 1)
	end
	local Flamework = require(replicatedStorage['rbxts_include']['node_modules']['@flamework'].core.out).Flamework
	local Client = require(replicatedStorage.TS.remotes).default.Client

	bedwars = setmetatable({
		Client = Client,
		CrateItemMeta = debug.getupvalue(Flamework.resolveDependency('client/controllers/global/reward-crate/crate-controller@CrateController').onStart, 3),
		Store = require(lplr.PlayerScripts.TS.ui.store).ClientStore
	}, {
		__index = function(self, ind)
			rawset(self, ind, Knit.Controllers[ind])
			return rawget(self, ind)
		end
	})

	local kills = sessioninfo:AddItem('Kills')
	local beds = sessioninfo:AddItem('Beds')
	local wins = sessioninfo:AddItem('Wins')
	local games = sessioninfo:AddItem('Games')

	vape:Clean(function()
		table.clear(bedwars)
	end)
end)

for _, v in vape.Modules do
	if v.Category == 'Combat' or v.Category == 'Minigames' then
		vape:Remove(i)
	end
end

for _, v in {'AimAssist', 'AutoClicker', 'Reach', 'HitBoxes', 'Killaura', 'MouseTP', 'TargetStrafe', 'Tracers', 'Disabler'} do
    vape:Remove(v)
end

run(function()
	local Sprint
	local old
	
	Sprint = vape.Categories.Combat:CreateModule({
		Name = 'Sprint',
		Function = function(callback)
			if callback then
				if inputService.TouchEnabled then pcall(function() lplr.PlayerGui.MobileUI['2'].Visible = false end) end
				old = bedwars.SprintController.stopSprinting
				bedwars.SprintController.stopSprinting = function(...)
					local call = old(...)
					bedwars.SprintController:startSprinting()
					return call
				end
				Sprint:Clean(entitylib.Events.LocalAdded:Connect(function() bedwars.SprintController:stopSprinting() end))
				bedwars.SprintController:stopSprinting()
			else
				if inputService.TouchEnabled then pcall(function() lplr.PlayerGui.MobileUI['2'].Visible = true end) end
				bedwars.SprintController.stopSprinting = old
				bedwars.SprintController:stopSprinting()
			end
		end,
		Tooltip = 'Sets your sprinting to true.'
	})
end)
	
run(function()
	local AutoGamble
	
	AutoGamble = vape.Categories.Minigames:CreateModule({
		Name = 'AutoGamble',
		Function = function(callback)
			if callback then
				AutoGamble:Clean(bedwars.Client:GetNamespace('RewardCrate'):Get('CrateOpened'):Connect(function(data)
					if data.openingPlayer == lplr then
						local tab = bedwars.CrateItemMeta[data.reward.itemType] or {displayName = data.reward.itemType or 'unknown'}
						notif('AutoGamble', 'Won '..tab.displayName, 5)
					end
				end))
	
				repeat
					if not bedwars.CrateAltarController.activeCrates[1] then
						for _, v in bedwars.Store:getState().Consumable.inventory do
							if v.consumable:find('crate') then
								bedwars.CrateAltarController:pickCrate(v.consumable, 1)
								task.wait(1.2)
								if bedwars.CrateAltarController.activeCrates[1] and bedwars.CrateAltarController.activeCrates[1][2] then
									bedwars.Client:GetNamespace('RewardCrate'):Get('OpenRewardCrate'):SendToServer({
										crateId = bedwars.CrateAltarController.activeCrates[1][2].attributes.crateId
									})
								end
								break
							end
						end
					end
					task.wait(1)
				until not AutoGamble.Enabled
			end
		end,
		Tooltip = 'Automatically opens lucky crates, piston inspired!'
	})
end)
	



run(function()
    local sslot = "1"
    local emoted = ""
    local emoteIDs = {}
    local pre = false

    if bedwars and bedwars.EmoteMeta then
        for i, emote in pairs(bedwars.EmoteMeta) do
            emoteIDs[emote.name] = i
        end
    end

    SetEmote = vape.Categories.Minigames:CreateModule({
        Name = "SetEmote",
        Function = function(callback)
            if callback then
                if pre then
                    lplr:SetAttribute("emote_slot_1", "nightmare_1")
                    lplr:SetAttribute("EmoteTypeSlot1", "nightmare_1")

                    lplr:SetAttribute("emote_slot_2", "griddy")
                    lplr:SetAttribute("EmoteTypeSlot2", "griddy")

                    lplr:SetAttribute("emote_slot_3", "funky_dance")
                    lplr:SetAttribute("EmoteTypeSlot3", "funky_dance")

                    lplr:SetAttribute("emote_slot_4", "tournament_winner")
                    lplr:SetAttribute("EmoteTypeSlot4", "tournament_winner")

                    lplr:SetAttribute("emote_slot_5", "top_assassin")
                    lplr:SetAttribute("EmoteTypeSlot5", "top_assassin")

                    lplr:SetAttribute("emote_slot_6", "disco_dance")
                    lplr:SetAttribute("EmoteTypeSlot6", "disco_dance")

                    lplr:SetAttribute("emote_slot_7", "rage_blade")
                    lplr:SetAttribute("EmoteTypeSlot7", "rage_blade")
                elseif emoted and sslot then
                    local emoteID = emoteIDs[emoted]
                    local slot = tonumber(sslot)

                    if emoteID and slot then
                        lplr:SetAttribute("emote_slot_" .. tostring(slot), emoteID)
                        lplr:SetAttribute("EmoteTypeSlot" .. tostring(slot), emoteID)
                    end
                end
            end
        end,
        Tooltip = "SetEmote v2"
    })

    Emote = SetEmote:CreateTextBox({
        Name = "Emote",
        Placeholder = "emote id (ex : nightmare_1)",
        Function = function(enter)
            emoted = enter
        end
    })

    Slot = SetEmote:CreateTextBox({
        Name = "Slot",
        Placeholder = "1 - 7",
        Function = function(enter)
            sslot = enter
        end
    })

    Preset = SetEmote:CreateToggle({
        Name = "Preset",
        Default = false,
        Function = function(val)
            pre = val
        end
    })
end)


-- shitter ver of autoqueue from old vape. 

run(function()
    local delay = 2
    local mode = ""
    local enabled = false
    local firstqueue = true

    local queues = {
        ["skywars"] = "skywars_to2",
        ["solos"] = "bedwars_to1",
        ["duos"] = "bedwars_to2",
        ["5v5"] = "bedwars_5v5"
    }

    AutoQueue = vape.Categories.Minigames:CreateModule({
        Name = "AutoQueue",
        Function = function(callback)
            enabled = callback
            if callback then
                task.spawn(function()
                    repeat
                        task.wait(delay)
                        firstqueue = false

                        if shared.vapeteammembers and bedwars.ClientStoreHandler:getState().Party then
                            repeat task.wait() until #bedwars.ClientStoreHandler:getState().Party.members >= shared.vapeteammembers or not enabled
                        end

                        if enabled and mode ~= "" then
                            local args = {
                                [1] = {
                                    queueType = queues[mode]
                                }
                            }
                            replicatedStorage:FindFirstChild("events-@easy-games/lobby:shared/event/lobby-events@getEvents.Events").joinQueue:FireServer(unpack(args))
                        end
                    until not enabled
                end)
            else
                firstqueue = false
                shared.vapeteammembers = nil
                replicatedStorage:FindFirstChild("events-@easy-games/lobby:shared/event/lobby-events@getEvents.Events").leaveQueue:FireServer()
            end
        end,
        Tooltip = "AutoQueue"
    })

    Mode = AutoQueue:CreateDropdown({
        Name = "Mode",
        List = {"skywars", "solos", "duos", "5v5"},
        Function = function(val)
            mode = val
            if enabled and not firstqueue then
                AutoQueue.ToggleButton(false)
                AutoQueue.ToggleButton(true)
            end
        end
    })

    Delay = AutoQueue:CreateSlider({
        Name = "Delay",
        Min = 1,
        Max = 20,
        Default = 2,
        Function = function(val)
            delay = val
        end
    })
end)