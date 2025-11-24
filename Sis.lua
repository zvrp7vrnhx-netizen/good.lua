------------------------------
--  زر ESP الإضافي
------------------------------
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

-- وظيفة لإنشاء ESP
local function addESP(character)
    if not character:FindFirstChild("Head") then return end

    local highlight = Instance.new("Highlight")
    highlight.FillColor = Color3.fromRGB(0,255,0)
    highlight.FillTransparency = 0.5
    highlight.OutlineColor = Color3.fromRGB(0,255,0)
    highlight.Parent = character

    espObjects[character] = highlight
end

-- إزالة ESP
local function removeESP(character)
    if espObjects[character] then
        espObjects[character]:Destroy()
        espObjects[character] = nil
    end
end

-- تشغيل/إيقاف ESP
local function toggleESP(state)
    espEnabled = state

    for _, player in pairs(game.Players:GetPlayers()) do
        if player ~= game.Players.LocalPlayer and player.Character then
            if espEnabled then
                addESP(player.Character)
            else
                removeESP(player.Character)
            end
        end
    end
end

-- ESP التحديث عند ظهور لاعبين جدد
game.Players.PlayerAdded:Connect(function(p)
    p.CharacterAdded:Connect(function(char)
        task.wait(1)
        if espEnabled then
            addESP(char)
        end
    end)
end)

-- زر التحكم
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
