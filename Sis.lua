--== High Jump GUI Fixed ==--
local Players = game:GetService("Players")
local player = Players.LocalPlayer

local gui = Instance.new("ScreenGui", game.CoreGui)
gui.ResetOnSpawn = false

-- زر القفزة
local btn = Instance.new("TextButton", gui)
btn.Size = UDim2.new(0, 180, 0, 50)
btn.Position = UDim2.new(0.5, -90, 0.7, 0)
btn.BackgroundColor3 = Color3.fromRGB(150,0,0)
btn.TextColor3 = Color3.fromRGB(255,255,255)
btn.Text = "High Jump OFF"
btn.TextScaled = true
btn.Active = true
btn.Draggable = true

local highJump = false
local highJumpPower = 180 -- قوة القفزة العالية
local defaultJump = 50 -- القفزة الأصلية

local function setJump(humanoid)
    if highJump then
        humanoid.JumpPower = highJumpPower
    else
        humanoid.JumpPower = defaultJump
    end
end

local function onCharacter(char)
    local humanoid = char:WaitForChild("Humanoid")
    setJump(humanoid)
end

player.CharacterAdded:Connect(onCharacter)
if
