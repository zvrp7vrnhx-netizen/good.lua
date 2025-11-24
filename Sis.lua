--== Powers GUI ==--
local gui = Instance.new("ScreenGui", game.CoreGui)
gui.ResetOnSpawn = false

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer

local character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local hrp = character:WaitForChild("HumanoidRootPart")

-- Variables
local flying = false
local speedEnabled = false
local godMode = false

-- Speeds
local normalSpeed = 16
local fastSpeed = 200 -- زيادة السرعة الخارقة

-- Create Buttons
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

RunService.RenderStepped:Connect(function()
    if godMode and humanoid.Health < humanoid.MaxHealth then
        humanoid.Health = humanoid.MaxHealth
    end
end)

------------------------------
-- SPEED --
------------------------------
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
bodyVelocity.MaxForce = Vector3.new(1e5,1e5,1e5)
bodyVelocity.Velocity = Vector3.new(0,0,0)
bodyVelocity.Parent = hrp
bodyVelocity.Enabled = false

local flyDirection = Vector3.new(0,0,0)
local flySpeed = 100 -- سرعة الطيران

flyBtn.MouseButton1Click:Connect(function()
    flying = not flying
    bodyVelocity.Enabled = flying
    if flying then
        flyBtn.BackgroundColor3 = Color3.fromRGB(0,120,0)
        flyBtn.Text = "Fly ON"
        humanoid.PlatformStand = true -- منع سقوط الجسم الطبيعي
    else
        flyBtn.BackgroundColor3 = Color3.fromRGB(120,0,0)
        flyBtn.Text = "Fly OFF"
        humanoid.PlatformStand = false
        bodyVelocity.Velocity = Vector3.new(0,0,0)
    end
end)

-- Control fly with WASD + Space/Shift
UserInputService.InputBegan:Connect(function(input)
    if flying then
        if input.KeyCode == Enum.KeyCode.W then flyDirection = Vector3.new(0,0,-1) end
        if input.KeyCode == Enum.KeyCode.S then flyDirection = Vector3.new(0,0,1) end
        if input.KeyCode == Enum.KeyCode.A then flyDirection = Vector3.new(-1,0,0) end
        if input.KeyCode == Enum.KeyCode.D then flyDirection = Vector3.new(1,0,0) end
        if input.KeyCode == Enum.KeyCode.Space then flyDirection = Vector3.new(0,1,0) end
        if input.KeyCode == Enum.KeyCode.LeftShift then flyDirection = Vector3.new(0,-1,0) end
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if flying then
        local keys = {Enum.KeyCode.W, Enum.KeyCode.S, Enum.KeyCode.A, Enum.KeyCode.D, Enum.KeyCode.Space, Enum.KeyCode.LeftShift}
        for _, key in ipairs(keys) do
            if input.KeyCode == key then
                flyDirection = Vector3.new(0,0,0)
            end
        end
    end
end)

RunService.RenderStepped:Connect(function()
    if flying then
        bodyVelocity.Velocity = flyDirection * flySpeed
    end
end)
