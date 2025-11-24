--== Block Spin PS Server Finder ==--

local Players = game:GetService("Players")
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")

local gui = Instance.new("ScreenGui", game.CoreGui)
gui.ResetOnSpawn = false

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 420, 0, 520)
frame.Position = UDim2.new(0.5, -210, 0.5, -260)
frame.BackgroundColor3 = Color3.fromRGB(20,20,20)
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true

local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1, 0, 0, 45)
title.BackgroundColor3 = Color3.fromRGB(0,0,0)
title.TextColor3 = Color3.fromRGB(255,255,255)
title.Text = "PS Server Finder - Block Spin"
title.TextScaled = true

local scroll = Instance.new("ScrollingFrame", frame)
scroll.Size = UDim2.new(1, -20, 1, -55)
scroll.Position = UDim2.new(0, 10, 0, 50)
scroll.CanvasSize = UDim2.new(0,0,0,0)
scroll.ScrollBarThickness = 8
scroll.BackgroundTransparency = 1

local layout = Instance.new("UIListLayout", scroll)
layout.Padding = UDim.new(0,7)
layout.SortOrder = Enum.SortOrder.LayoutOrder

local refresh = Instance.new("TextButton", frame)
refresh.Size = UDim2.new(0, 120, 0, 40)
refresh.Position = UDim2.new(1, -130, 0, 5)
refresh.Text = "Refresh"
refresh.BackgroundColor3 = Color3.fromRGB(0,120,0)
refresh.TextColor3 = Color3.fromRGB(255,255,255)
refresh.TextScaled = true

local function loadServers()
    scroll:ClearAllChildren()

    local ok, data = pcall(function()
        local url = "https://games.roblox.com/v1/games/"..game.PlaceId.."/servers/Public?sortOrder=Asc&limit=100"
        return HttpService:JSONDecode(game:HttpGet(url))
    end)

    if not ok then return end

    for i, server in ipairs(data.data) do
        local psCount = 0

        -- Detect PS/Xbox players
        if server.platforms then
            for _, plat in pairs(server.platforms) do
                if plat == "Xbox" or plat == "PS4" or plat == "PS5" then
                    psCount += 1
                end
            end
        end

        -- Button
        local btn = Instance.new("TextButton", scroll)
        btn.Size = UDim2.new(1, -10, 0, 55)
        btn.BackgroundColor3 = psCount > 0 and Color3.fromRGB(200,50,50) or Color3.fromRGB(50,200,50)
        btn.TextColor3 = Color3.fromRGB(255,255,255)
        btn.TextScaled = true

        local text = "Server "..i.." | Players: "..server.playing.."/"..server.maxPlayers
        if psCount > 0 then
            text = text.." | PS: "..psCount
        end
        btn.Text = text

        btn.MouseButton1Click:Connect(function()
            TeleportService:TeleportToPlaceInstance(game.PlaceId, server.id, Players.LocalPlayer)
        end)
    end
end

refresh.MouseButton1Click:Connect(loadServers)
loadServers()
