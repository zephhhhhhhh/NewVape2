print("Rivals")
print("game :" .. game.PlaceId)
warn("NewAstroid loaded!")


local library = loadstring(game:HttpGet("https://raw.githubusercontent.com/lolpoppyus/Roblox-Lua/master/Pop%20UI%20Lib", true))()
local Players = game:GetService("Players")

local Combat = library:Tab("Combat")


Combat:Label("SilentAim")

Combat:Toggle("SilentAim", function(arg)
   print(arg)
end)


Combat:Toggle("FOV", function(arg)
    print(arg)
 end)


 Combat:Slider("HeadshotChance", 0, 100, function(arg)
    print(arg)
 end)

 Combat:Slider("FOV Size", 0, 360, function(arg)
    print(arg)
 end)

 Combat:Colorpicker("FOV Color", function(arg)
    print(arg)
end)
 
 


local Player = library:Tab("Player")


local Visuals = library:Tab("Visuals")

Visuals:Label("ESP")

local Players = game:GetService("Players")

local InsideTransparency = 0.5
local OutlineTransparency = 0.5

Visuals:Toggle("ESP", function(state)
    if state then
        for _, player in ipairs(Players:GetPlayers()) do
            if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                local char = player.Character
                local highlight = Instance.new("Highlight")
                highlight.Parent = char
                highlight.Name = "ESPHighlight"
                highlight.Adornee = char
                highlight.FillColor = InsideColor
                highlight.OutlineColor = OutlineColor
                highlight.FillTransparency = InsideTransparency
                highlight.OutlineTransparency = OutlineTransparency
                highlight.Enabled = true
            end
        end
    else
        for _, player in ipairs(Players:GetPlayers()) do
            if player.Character then
                local char = player.Character
                local highlight = char:FindFirstChild("ESPHighlight")
                if highlight then
                    highlight:Destroy()
                end
            end
        end
    end
end)

Visuals:Colorpicker("Inside Color", function(arg)
    InsideColor = arg
    for _, player in ipairs(Players:GetPlayers()) do
        if player.Character then
            local highlight = player.Character:FindFirstChild("ESPHighlight")
            if highlight then
                highlight.FillColor = InsideColor
            end
        end
    end
end)

Visuals:Colorpicker("Outline Color", function(arg)
    OutlineColor = arg
    for _, player in ipairs(Players:GetPlayers()) do
        if player.Character then
            local highlight = player.Character:FindFirstChild("ESPHighlight")
            if highlight then
                highlight.OutlineColor = OutlineColor
            end
        end
    end
end)

Visuals:Slider("Inside Transparency", 1, 10, function(arg)
    InsideTransparency = arg / 10
    for _, player in ipairs(Players:GetPlayers()) do
        if player.Character then
            local highlight = player.Character:FindFirstChild("ESPHighlight")
            if highlight then
                highlight.FillTransparency = InsideTransparency
            end
        end
    end
end)

Visuals:Slider("Outline Transparency", 1, 10, function(arg)
    OutlineTransparency = arg / 10
    for _, player in ipairs(Players:GetPlayers()) do
        if player.Character then
            local highlight = player.Character:FindFirstChild("ESPHighlight")
            if highlight then
                highlight.OutlineTransparency = OutlineTransparency
            end
        end
    end
end)





local UI = library:Tab("Misc")


UI:Textstring2("Created by - Zeph")

UI:Button("Rejoin", function()
    local tspmo = game:GetService("TeleportService")
    local plr = game:GetService("Players").LocalPlayer
    tspmo:Teleport(game.PlaceId, plr)
 end)

UI:Keybind("UI", function(enabled)
    game:GetService("CoreGui").OfficialUILib.Enabled = not game:GetService("CoreGui").OfficialUILib.Enabled;
 end,Enum.KeyCode.P)
 

while wait(1) do
   local players = game.Players:GetChildren()
   local array = {}

   for i,v in pairs(players) do
       table.insert(array,v.Name)
   end

   update(array)
   update2(array)
end;

