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

