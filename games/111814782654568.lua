-- dah hood support (i got bored)


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

for _, v in {'Blink', 'Freecam', 'Disabler', 'Cape', 'AimAssist',  'SafeWalk', 'Parkour', 'HitBoxes', 'Killaura', 'Reach', 'AutoClicker'} do
    vape:Remove(v)
end

run(function()
	local AimAssist
	local Targets
	local Part
	local FOV
	local Speed
	local Range
	local Prediction
	local CircleColor
	local CircleTransparency
	local CircleFilled
	local CircleObject
	local RightClick
	local ShowTarget
	local moveConst = Vector2.new(1, 0.77) * math.rad(0.5)

	local function wrapAngle(num)
		num = num % math.pi
		num -= num >= (math.pi / 2) and math.pi or 0
		num += num < -(math.pi / 2) and math.pi or 0
		return num
	end

	AimAssist = vape.Categories.Combat:CreateModule({
		Name = 'AimAssist',
		Function = function(callback)
			if CircleObject then
				CircleObject.Visible = callback
			end
			if callback then
				local ent
				local rightClicked = not RightClick.Enabled or inputService:IsMouseButtonPressed(1)
				AimAssist:Clean(runService.RenderStepped:Connect(function(dt)
					if CircleObject then
						CircleObject.Position = inputService:GetMouseLocation()
					end

					if rightClicked and not vape.gui.ScaledGui.ClickGui.Visible then
						ent = entitylib.EntityMouse({
							Range = FOV.Value,
							Part = Part.Value,
							Players = Targets.Players.Enabled,
							NPCs = Targets.NPCs.Enabled,
							Wallcheck = Targets.Walls.Enabled,
							Origin = gameCamera.CFrame.Position,
							MaxDistance = Range.Value
						})

						if ent and (gameCamera.CFrame.Position - ent[Part.Value].Position).Magnitude <= Range.Value then
							local epitaph = 0.187  
							local headOffset = Vector3.new(0, 0.1, 0) 
							
							local targetPosition = ent[Part.Value].Position
							if Prediction.Enabled then
								local predictedPosition = ent[Part.Value].CFrame.Position + 
									(ent[Part.Value].Velocity * epitaph) + headOffset
								targetPosition = predictedPosition or targetPosition
							end

							local facing = gameCamera.CFrame.LookVector
							local new = (targetPosition - gameCamera.CFrame.Position).Unit
							new = new == new and new or Vector3.zero

							if ShowTarget.Enabled then
								targetinfo.Targets[ent] = tick() + 1
							end

							if new ~= Vector3.zero then
								local diffYaw = wrapAngle(math.atan2(facing.X, facing.Z) - math.atan2(new.X, new.Z))
								local diffPitch = math.asin(facing.Y) - math.asin(new.Y)
								local angle = Vector2.new(diffYaw, diffPitch) // (moveConst * UserSettings():GetService('UserGameSettings').MouseSensitivity)

								angle *= math.min(Speed.Value * dt, 1)
								mousemoverel(angle.X, angle.Y)
							end
						end
					end
				end))

				if RightClick.Enabled then
					AimAssist:Clean(inputService.InputBegan:Connect(function(input)
						if input.UserInputType == Enum.UserInputType.MouseButton2 then
							ent = nil
							rightClicked = true
						end
					end))

					AimAssist:Clean(inputService.InputEnded:Connect(function(input)
						if input.UserInputType == Enum.UserInputType.MouseButton2 then
							rightClicked = false
						end
					end))
				end
			end
		end,
		Tooltip = 'Smoothly aims to closest valid target'
	})
	Targets = AimAssist:CreateTargets({Players = true})
	Part = AimAssist:CreateDropdown({
		Name = 'Part',
		List = {'RootPart', 'Head'}
	})
	FOV = AimAssist:CreateSlider({
		Name = 'FOV',
		Min = 0,
		Max = 1000,
		Default = 100,
		Function = function(val)
			if CircleObject then
				CircleObject.Radius = val
			end
		end
	})
	Speed = AimAssist:CreateSlider({
		Name = 'Speed',
		Min = 0,
		Max = 30,
		Default = 15
	})
	Range = AimAssist:CreateSlider({
		Name = 'Range',
		Min = 0,
		Max = 1000,
		Default = 30,
		Function = function()
		end
	})
	Prediction = AimAssist:CreateToggle({
		Name = 'Prediction',
		Function = function()
		end
	})
	AimAssist:CreateToggle({
		Name = 'Range Circle',
		Function = function(callback)
			if callback then
				CircleObject = Drawing.new('Circle')
				CircleObject.Filled = CircleFilled.Enabled
				CircleObject.Color = Color3.fromHSV(CircleColor.Hue, CircleColor.Sat, CircleColor.Value)
				CircleObject.Position = vape.gui.AbsoluteSize / 2
				CircleObject.Radius = FOV.Value
				CircleObject.NumSides = 100
				CircleObject.Transparency = 1 - CircleTransparency.Value
				CircleObject.Visible = AimAssist.Enabled
			else
				pcall(function()
					CircleObject.Visible = false
					CircleObject:Remove()
				end)
			end
			CircleColor.Object.Visible = callback
			CircleTransparency.Object.Visible = callback
			CircleFilled.Object.Visible = callback
		end
	})
	CircleColor = AimAssist:CreateColorSlider({
		Name = 'Circle Color',
		Function = function(hue, sat, val)
			if CircleObject then
				CircleObject.Color = Color3.fromHSV(hue, sat, val)
			end
		end,
		Darker = true,
		Visible = false
	})
	CircleTransparency = AimAssist:CreateSlider({
		Name = 'Transparency',
		Min = 0,
		Max = 1,
		Decimal = 10,
		Default = 0.5,
		Function = function(val)
			if CircleObject then
				CircleObject.Transparency = 1 - val
			end
		end,
		Darker = true,
		Visible = false
	})
	CircleFilled = AimAssist:CreateToggle({
		Name = 'Circle Filled',
		Function = function(callback)
			if CircleObject then
				CircleObject.Filled = callback
			end
		end,
		Darker = true,
		Visible = false
	})
	RightClick = AimAssist:CreateToggle({
		Name = 'Require right click',
		Function = function()
			if AimAssist.Enabled then
				AimAssist:Toggle()
				AimAssist:Toggle()
			end
		end
	})
	ShowTarget = AimAssist:CreateToggle({
		Name = 'Show target info'
	})
end)

-- new cape because idk, i had this as a module for a very old dahood script. So it might be a lil shitty 
run(function()
	local CapeColor
	local Material
	CapeD = vape.Categories.Render:CreateModule({
		Name = "Cape",
		Function = function(callback)
			if callback then
				if lplr.Character then
					local char = lplr.Character
					char:WaitForChild("HumanoidRootPart")

					local cape = Instance.new("Part")
					cape.Name = "Cape"
					cape.Size = Vector3.new(1.7, 3, 0.1)
					cape.Color = capeColor or Color3.fromRGB(255, 0, 0)
					cape.Material = selectedMaterial or Enum.Material.SmoothPlastic
					cape.Anchored = false
					cape.CanCollide = false

					local torso = char:FindFirstChild("UpperTorso") or char:FindFirstChild("Torso")
					if torso then
						local weld = Instance.new("Weld")
						weld.Part0 = cape
						weld.Part1 = torso
						weld.C0 = CFrame.new(0, 0.8, -0.5) * CFrame.Angles(math.rad(18), 0, 0)
						weld.Parent = cape
						cape.Parent = char
					end
				end
			else
				if lplr.Character and lplr.Character:FindFirstChild("Cape") then
					lplr.Character.Cape:Destroy()
				end
			end
		end,
		Tooltip = "Cape"
	})

	Material = CapeD:CreateDropdown({
		Name = "Material",
		List = {"SmoothPlastic", "Neon", "ForceField", "Glass"},
		Function = function(newMaterial)
			selectedMaterial = Enum.Material[newMaterial] or Enum.Material.SmoothPlastic
			if lplr.Character and lplr.Character:FindFirstChild("Cape") then
				lplr.Character.Cape.Material = selectedMaterial
			end
		end
	})

	CapeColor = CapeD:CreateColorSlider({
		Name = "Color",
		DefaultHue = 0,
		Function = function(hue, sat, val)
			capeColor = Color3.fromHSV(hue, sat, val)
			if lplr.Character and lplr.Character:FindFirstChild("Cape") then
				lplr.Character.Cape.Color = capeColor
			end
		end
	})
end)
