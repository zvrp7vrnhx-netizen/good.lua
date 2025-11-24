--== High Jump Toggle GUI ==--

local player = game.Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local humanoid = char:WaitForChild("Humanoid")

local gui = Instance.new("ScreenGui", game.CoreGui)
gui.ResetOnSpawn = false

-- زر القفزة
local btn = Instance.new("TextButton", gui)
btn.Size = UDim2.new(0, 180, 0, 50)
btn.Position = UDim2.new(0.5, -90, 0.7, 0)
btn.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
btn.TextColor3 = Color3.fromRGB(255, 255, 255)
btn.Text = "High Jump OFF"
btn.TextScaled = true
btn.Active = true
btn.Draggable = true

local highJump = false
local jumpPowerDefault = humanoid.JumpPower
local highJumpPower = 180 -- تقدر تعدل قوة القفزة

btn.MouseButton1Click:Connect(function()
    highJump = not highJump
    
    if highJump then
        humanoid.JumpPower = highJumpPower
        btn.Text = "High Jump ON"
        btn.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
    else
        humanoid.JumpPower = jumpPowerDefault
        btn.Text = "High Jump OFF"
        btn.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
    end
end)

-- يرجع القوة الأصلية إذا مت
player.CharacterAdded:Connect(function(newChar)
    char = newChar
    humanoid = newChar:WaitForChild("Humanoid")
    if not highJump then
        humanoid.JumpPower = jumpPowerDefault
    else
        humanoid.JumpPower = highJumpPower
    end
end)
