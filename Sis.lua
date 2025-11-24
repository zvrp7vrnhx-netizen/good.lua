--== MAIN GUI ==--
local gui = Instance.new("ScreenGui", game.CoreGui)
gui.ResetOnSpawn = false

-----------------------------------------------------
--== AIM LOCK BUTTON ==--
-----------------------------------------------------
local btn = Instance.new("TextButton", gui)
btn.Size = UDim2.new(0, 150, 0, 50)
btn.Position = UDim2.new(0.5, -75, 0.8, 0)
btn.Text = "Aim Lock"
btn.BackgroundColor3 = Color3.fromRGB(0,0,0)
btn.TextColor3 = Color3.fromRGB(255,255,255)
btn.TextScaled = true
btn.Active = true
btn.Draggable = true

local aimEnabled = false
local lockedTarget = nil

local function getClosest()
    local plr = game.Players.LocalPlayer
    local char = plr.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end

    local closestDist = math.huge
    local target = nil

    for _, v in pairs(game.Players:GetPlayers()) do
        if v ~= plr and v.Character and v.Character:FindFirstChild("Head") then
            local dist = (char.HumanoidRootPart.Position - v.Character.Head.Position).Magnitude
            if dist < closestDist then
                closestDist = dist
                target = v.Character
            end
        end
    end
    return target
end

task.spawn(function()
    while true do
        task.wait()
        if aimEnabled and lockedTarget and lockedTarget:FindFirstChild("Head") then
            local cam = workspace.CurrentCamera
            cam.CFrame = CFrame.new(cam.CFrame.Position, lockedTarget.Head.Position)
        end
    end
end)

btn.MouseButton1Click:Connect(function()
    aimEnabled = not aimEnabled

    if aimEnabled then
        lockedTarget = getClosest()
        btn.Text = "Aim ON"
        btn.BackgroundColor3 = Color3.fromRGB(0,120,0)

        if not lockedTarget then
            btn.Text = "No Target"
            aimEnabled = false
        end
    else
        lockedTarget = nil
        btn.Text = "Aim OFF"
        btn.BackgroundColor3 = Color3.fromRGB(120,0,0)
    end
end)

-----------------------------------------------------
--== ESP + TRACERS BUTTON ==--
-----------------------------------------------------
local espBtn = Instance.new("TextButton", gui)
espBtn.Size = UDim2.new(0, 150, 0, 50)
espBtn.Position = UDim2.new(0.5, -75, 0.7, 0)
espBtn.Text = "ESP OFF"
espBtn.BackgroundColor3 = Color3.fromRGB(120,0,0)
espBtn.TextColor3 = Color3.fromRGB(255,255,255)
espBtn.TextScaled = true
espBtn.Active = true
espBtn.Draggable = true

local espEnabled = false
local espObjects = {}
local tracerLines = {}

local function addESP(character)
    if not character:FindFirstChild("Head") then return end

    -- Highlight
    local h = Instance.new("Highlight")
    h.FillColor = Color3.fromRGB(0,255,0)
    h.FillTransparency = 0.5
    h.OutlineColor = Color3.fromRGB(0,255,0)
    h.Parent = character
    espObjects[character] = h

    -- Tracer
    local cam = workspace.CurrentCamera
    local line = Drawing.new("Line")
    line.Visible = true
    line.Color = Color3.fromRGB(0,255,0)
    line.Thickness = 2
    tracerLines[character] = line
end

local function removeESP(character)
    if espObjects[character] then
        espObjects[character]:Destroy()
        espObjects[character] = nil
    end
    if tracerLines[character] then
        tracerLines[character]:Remove()
        tracerLines[character] = nil
    end
end

local function toggleESP(state)
    espEnabled = state
    for _, p in pairs(game.Players:GetPlayers()) do
        if p ~= game.Players.LocalPlayer and p.Character then
            if espEnabled then
                addESP(p.Character)
            else
                removeESP(p.Character)
            end
        end
    end
end

-- تحديث خطوط التتبع كل فريم
game:GetService("RunService").RenderStepped:Connect(function()
    if espEnabled then
        local cam = workspace.CurrentCamera
        local screenPos = cam.CFrame.Position
        for char, line in pairs(tracerLines) do
            if char and char:FindFirstChild("Head") then
                local headPos, onScreen = cam:WorldToViewportPoint(char.Head.Position)
                line.From = Vector2.new(cam.ViewportSize.X/2, cam.ViewportSize.Y)
                line.To = Vector2.new(headPos.X, headPos.Y)
                line.Visible = onScreen
            end
        end
    end
end)

game.Players.PlayerAdded:Connect(function(plr)
    plr.CharacterAdded:Connect(function(char)
        task.wait(1)
        if espEnabled then
            addESP(char)
        end
    end)
end)

espBtn.MouseButton1Click:Connect(function()
    espEnabled = not espEnabled

    if espEnabled then
        espBtn.BackgroundColor3 = Color3.fromRGB(0,120,0)
        espBtn.Text = "ESP ON"
        toggleESP(true)
    else
        espBtn.BackgroundColor3 = Color3.fromRGB(120,0,0)
        espBtn.Text = "ESP OFF"
        toggleESP(false)
    end
end)
