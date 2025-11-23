--== Block Spin Simple AimLock GUI ==--

-- Create ScreenGui
local gui = Instance.new("ScreenGui", game.CoreGui)
gui.ResetOnSpawn = false

-- Draggable Button
local btn = Instance.new("TextButton", gui)
btn.Size = UDim2.new(0, 120, 0, 40)
btn.Position = UDim2.new(0.5, -60, 0.5, -20)
btn.Text = "Aim Lock"
btn.BackgroundColor3 = Color3.fromRGB(0,0,0)
btn.TextColor3 = Color3.fromRGB(255,255,255)
btn.Active = true
btn.Draggable = true

local aimEnabled = false

-- Function to get closest player
local function getClosest()
    local plr = game.Players.LocalPlayer
    local char = plr.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end

    local closestDist = math.huge
    local target = nil

    for _, v in pairs(game.Players:GetPlayers()) do
        if v ~= plr and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
            local dist = (char.HumanoidRootPart.Position - v.Character.HumanoidRootPart.Position).Magnitude
            if dist < closestDist then
                closestDist = dist
                target = v.Character.HumanoidRootPart
            end
        end
    end
    return target
end

-- AimLock Loop
task.spawn(function()
    while true do
        task.wait()
        if aimEnabled then
            local plr = game.Players.LocalPlayer
            local cam = workspace.CurrentCamera
            local target = getClosest()
            if target then
                cam.CFrame = CFrame.new(cam.CFrame.Position, target.Position)
            end
        end
    end
end)

-- Button Toggle
btn.MouseButton1Click:Connect(function()
    aimEnabled = not aimEnabled
    if aimEnabled then
        btn.Text = "Aim ON"
        btn.BackgroundColor3 = Color3.fromRGB(0,150,0)
    else
        btn.Text = "Aim OFF"
        btn.BackgroundColor3 = Color3.fromRGB(150,0,0)
    end
end)
