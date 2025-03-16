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

for _, v in {'AnimationPlayer', 'Blink', 'Freecam', 'Disabler', 'ServerHop', 'SafeWalk', 'Parkour', 'FOV', 'ChatSpammer', 'HitBoxes', 'Killaura', 'MouseTP', 'LongJump', 'Reach', 'AutoClicker'} do
    vape:Remove(v)
end


run(function()
    local HitBox
    local size = 10   
    local Players = game:GetService("Players")

    HitBox = vape.Categories.Combat:CreateModule({
        Name = "HitBox",
        Function = function(callback)
            if callback then
                task.spawn(function()
                    while callback do
                        task.wait()
                        for _, v in pairs(Players:GetPlayers()) do
                            if v ~= lplr and v.Character then
                                local parts = {"RightUpperLeg", "LeftUpperLeg", "HeadHB", "HumanoidRootPart"}
                                for _, part in pairs(parts) do
                                    local skib = v.Character:FindFirstChild(part)
                                    if skib then
                                        skib.CanCollide = false
                                        skib.Transparency = 1
                                        skib.Size = Vector3.new(size, size, size)
                                    end
                                end
                            end
                        end
                    end
                end)
            else
                for _, v in pairs(Players:GetPlayers()) do
                    if v ~= lplr and v.Character then
                        local parts = {"RightUpperLeg", "LeftUpperLeg", "HeadHB", "HumanoidRootPart"}
                        for _, part in pairs(parts) do
                            local skib = v.Character:FindFirstChild(part)
                            if skib then
                                skib.CanCollide = true
                                skib.Transparency = 0
                                skib.Size = Vector3.new(1, 1, 1)
                            end
                        end
                    end
                end
            end
        end,
        Tooltip = "Expand hitboxes"
    })

    Size = HitBox:CreateSlider({
        Name = "Size",
        Min = 1,
        Max = 25,
        Default = 10,
        Function = function(value)
            size = value
        end
    })
end)

run(function()
    local InfiniteAmmo
    local Amount
 -- i was forced into adding the amount, changing it wont really matter. 
    InfiniteAmmo = vape.Categories.Utility:CreateModule({
        Name = "InfiniteAmmo",
        Function = function(callback)
            if callback then
                task.spawn(function()
                    while callback do
                        local ammoVar = lplr:FindFirstChild("PlayerGui") and lplr.PlayerGui:FindFirstChild("GUI") and 
                        lplr.PlayerGui.GUI:FindFirstChild("Client") and lplr.PlayerGui.GUI.Client:FindFirstChild("Variables")

                        if ammoVar then
                            ammoVar.ammocount.Value = Amount.Value   
                            ammoVar.ammocount2.Value = Amount.Value
                        end
                        task.wait()  
                    end
                end)
            end
        end,
        Tooltip = "Infinite ammo"
    })
    Amount = InfiniteAmmo:CreateSlider({
        Name = 'Amount',
        Min = 1,
        Max = 999,
        Default = 100,
        Value = Default  
    })
end)


run(function()
    local GunColor = vape.Categories.Render:CreateModule({
        Name = "GunColor",
        Function = function(callback)
            if callback then
                game:GetService("RunService").RenderStepped:Connect(function()
                    if game.Workspace.Camera:FindFirstChild('Arms') then
                        for i, v in pairs(game.Workspace.Camera.Arms:GetDescendants()) do
                            if v.ClassName == 'MeshPart' then
                                v.Color = cColor
                                if CustomMaterial then
                                    v.Material = GunMaterial
                                end
                            end
                        end
                    end 
                end)
            end
        end,
        Tooltip = "Changes the gun colors"
    })
    
    Material = GunColor:CreateDropdown({
        Name = 'Material',
        List = {'ForceField', 'Neon', 'SmoothPlastic', 'Plastic'},
        Function = function(choice)
            if choice == "Plastic" then
                GunMaterial = Enum.Material.Plastic
            elseif choice == "SmoothPlastic" then
                GunMaterial = Enum.Material.SmoothPlastic
            elseif choice == "Neon" then
                GunMaterial = Enum.Material.Neon
            elseif choice == "ForceField" then
                GunMaterial = Enum.Material.ForceField
            end
        end
    })

    Color = GunColor:CreateColorSlider({
        Name = 'Color',
        Function = function(hue, sat, val)
            cColor = Color3.fromHSV(hue, sat, val)
        end
    })
    CustomMaterialToggle = GunColor:CreateToggle({
        Name = 'Custom Material',
        Function = function(enabled)
            CustomMaterial = enabled
        end
    })
end)
