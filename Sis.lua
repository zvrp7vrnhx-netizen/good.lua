--== Powers GUI ==--
local gui = Instance.new("ScreenGui", game.CoreGui)
gui.ResetOnSpawn = false

-- Variables
local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local hrp = character:WaitForChild("HumanoidRootPart")
local flying = false
local speedEnabled = false
local godMode = false

-- Function to create buttons
local function createButton(text, pos)
    local btn = Instance.new("TextButton", gui)
    btn.Size = UDim2.new(0,150,0,50)
    btn.Position = pos
    btn.Text = text
    btn.TextScaled = true
    btn.BackgroundColor3 = Color3.fromRGB(0,0,0)
    btn.TextColor3 = Color3.fromRGB(255,255,255)
    btn.Active = true
    btn.Draggable = true
    return btn
end

-- Buttons
local godBtn = createButton("God Mode", UDim2.new(0,20,0,100))
local speedBtn = createButton("Speed", UDim2.new(0,20,0,160))
local flyBtn = createButton("Fly", UDim2.new(0,20,0,220))

------------------------------
-- GOD MODE --
------------------------------
godBtn.MouseButton1Click:Connect(function()
    godMode = not godMode
    if godMode then
        godBtn.BackgroundColor3 = Color3.fromRGB(0,120,0)
        godBtn.Text = "God ON"
    else
        godBtn.BackgroundColor3 = Color3.fromRGB(120,0,0)
        godBtn.Text = "God OFF"
    end
end)

-- Prevent health loss
game:GetService("RunService").Stepped:Connect(function()
    if godMode then
        humanoid.Health = humanoid.MaxHealth
    end
end)

------------------------------
-- SPEED --
------------------------------
local normalSpeed = humanoid.WalkSpeed
local fastSpeed = 100 -- سرعة خارقة

speedBtn.MouseButton1Click:Connect(function()
    speedEnabled = not speedEnabled
    if speedEnabled then
        humanoid.WalkSpeed = fastSpeed
        speedBtn.BackgroundColor3 = Color3.fromRGB(0,120,0)
        speedBtn.Text = "Speed ON"
    else
        humanoid.WalkSpeed = normalSpeed
        speedBtn.BackgroundColor3 = Color3.fromRGB(120,0,0)
        speedBtn.Text = "Speed OFF"
    end
end)

------------------------------
-- FLY --
------------------------------
local bodyVelocity = Instance.new("BodyVelocity")
bodyVelocity.MaxForce = Vector3.new(400000,400000,400000)
bodyVelocity.Velocity = Vector3.new(0,0,0)
bodyVelocity.Parent = hrp
bodyVelocity.Enabled = false

flyBtn.MouseButton1Click:Connect(function()
    flying = not flying
    if flying then
        flyBtn.BackgroundColor3 = Color3.fromRGB(0,120,0)
        flyBtn.Text = "Fly ON"
        bodyVelocity.Enabled = true
    else
        flyBtn.BackgroundColor3 = Color3.fromRGB(120,0,0)
        flyBtn.Text = "Fly OFF"
        bodyVelocity.Enabled = false
    end
end)

-- Control fly with WASD
local uis = game:GetService("UserInputService")
local flyDirection = Vector3.new(0,0,0)

uis.InputBegan:Connect(function(input)
    if flying then
        if input.KeyCode == Enum.KeyCode.W then flyDirection = Vector3.new(0,0,-1) end
        if input.KeyCode == Enum.KeyCode.S then flyDirection = Vector3.new(0,0,1) end
        if input.KeyCode == Enum.KeyCode.A then flyDirection = Vector3.new(-1,0,0) end
        if input.KeyCode == Enum.KeyCode.D then flyDirection = Vector3.new(1,0,0) end
        if input.KeyCode == Enum.KeyCode.Space then flyDirection = Vector3.new(0,1,0) end
        if input.KeyCode == Enum.KeyCode.LeftShift then flyDirection = Vector3.new(0,-1,0) end
    end
end)

uis.InputEnded:Connect(function(input)
    if flying then
        if input.KeyCode == Enum.KeyCode.W or input.KeyCode == Enum.KeyCode.S or
           input.KeyCode == Enum.KeyCode.A or input.KeyCode == Enum.KeyCode.D or
           input.KeyCode == Enum.KeyCode.Space or input.KeyCode == Enum.KeyCode.LeftShift then
            flyDirection = Vector3.new(0,0,0)
        end
    end
end)

RunService.RenderStepped:Connect(function()
    if flying then
        bodyVelocity.Velocity = flyDirection * 100 -- سرعة الطيران
    end
end)
