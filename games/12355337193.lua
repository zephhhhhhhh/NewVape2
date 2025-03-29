-- MSVD

local run = function(func) 
	func() 
end
local cloneref = cloneref or function(obj) 
	return obj 
end

local playersService = cloneref(game:GetService('Players'))
local inputService = cloneref(game:GetService('UserInputService'))
local replicatedStorage = cloneref(game:GetService('ReplicatedStorage'))
local runService = cloneref(game:GetService('RunService'))
local tweenService = cloneref(game:GetService('TweenService'))

local gameCamera = workspace.CurrentCamera
local lplr = playersService.LocalPlayer

local vape = shared.vape
local entitylib = vape.Libraries.entity
local targetinfo = vape.Libraries.targetinfo
local prediction = vape.Libraries.prediction
local color = vape.Libraries.color
local uipallet = vape.Libraries.uipallet
local getcustomasset = vape.Libraries.getcustomasset

for _, v in {'AnimationPlayer', 'Blink', 'Disabler', 'SafeWalk', 'Parkour', 'HitBoxes', 'Killaura', 'Reach', 'AutoClicker'} do
    vape:Remove(v)
end


run(function()
	local size = 10
	local transparency = 0.7
	local color = Color3.fromRGB(0, 162, 255)
	local teamCheck = true
	local wallCheck = false
	local plrs = game:GetService("Players")

	Name = vape.Categories.Combat:CreateModule({
		Name = "HitBox",
		Function = function(callback)
			if callback then
				connection = game:GetService("RunService").RenderStepped:Connect(function()
					for _, v in ipairs(plrs:GetPlayers()) do
						if v ~= lplr and v.Team ~= lplr.Team and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
							local canhit = true
							if wallCheck then
								local org = lplr.Character.HumanoidRootPart.Position
								local des = v.Character.HumanoidRootPart.Position
								local ray = Ray.new(org, (des - org).unit * (des - org).magnitude)
								local hp = workspace:FindPartOnRayWithIgnoreList(ray, {lplr.Character, v.Character})
								if hp and not hp:IsDescendantOf(v.Character) then
									canhit = false
								end
							end
							if canhit then
								pcall(function()
									v.Character.HumanoidRootPart.Size = Vector3.new(size, size, size)
									v.Character.HumanoidRootPart.Transparency = transparency
									v.Character.HumanoidRootPart.Color = color
									v.Character.HumanoidRootPart.Material = Enum.Material.Neon
									v.Character.HumanoidRootPart.CanCollide = false
								end)
							end
						end
					end
				end)
			else
				if connection then
					connection:Disconnect()
				end
				for _, v in ipairs(plrs:GetPlayers()) do
					if v ~= lplr and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
						pcall(function()
							v.Character.HumanoidRootPart.Size = Vector3.new(2, 2, 1)
							v.Character.HumanoidRootPart.Transparency = 0
							v.Character.HumanoidRootPart.Color = Color3.fromRGB(255, 255, 255)
							v.Character.HumanoidRootPart.Material = Enum.Material.Plastic
							v.Character.HumanoidRootPart.CanCollide = true
						end)
					end
				end
			end
		end,
		Tooltip = "Expands hitboxes with team check and wall check"
	})

	Size = Name:CreateSlider({
		Name = "Size",
		Min = 1,
		Max = 25,
		Default = 10,
		Function = function(value)
			size = value
		end
	})

	Transparency = Name:CreateSlider({
		Name = "Transparency",
		Min = 1,
		Max = 10,
		Default = 7,
		Function = function(value)
			transparency = value / 10
		end
	})

	Color = Name:CreateColorSlider({
		Name = "Color",
		DefaultOpacity = 0.5,
		Function = function(h, s, v, o)
			color = Color3.fromHSV(h, s, v)
		end
	})

	WallCheck = Name:CreateToggle({
		Name = "WallCheck",
		Default = false,
		Function = function(state)
			wallCheck = state
		end
	})
end)

run(function()
	local AntiShroud
	AntiShroud = vape.Categories.Utility:CreateModule({
		Name = "AntiShroud",
		Function = function(callback)
			if callback then
				game:GetService("RunService").RenderStepped:Connect(function()
					if game.Workspace:FindFirstChild("ShadowProjectile") then
						game.Workspace.ShadowProjectile:Destroy()
					end
				end)

				local mt = getrawmetatable(game)
				setreadonly(mt, false)
				local oldNamecall = mt.__namecall

				mt.__namecall = newcclosure(function(self, ...)
					local method = getnamecallmethod()
					if method == "FireServer" and self == game:GetService("ReplicatedStorage").Ability.ActivateShroud then
						return
					end
					if method == "FireServer" and self == game:GetService("ReplicatedStorage").Ability.RenderShroudProjectile then
						return
					end
					return oldNamecall(self, ...)
				end)
			end
		end,
		Tooltip = "Disables shroud ability"
	})
end)
