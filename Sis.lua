--== Server Finder GUI with PS Detection ==--
local Players = game:GetService("Players")
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")
local gui = Instance.new("ScreenGui", game.CoreGui)
gui.ResetOnSpawn = false

-- Main Frame
local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 400, 0, 500)
frame.Position = UDim2.new(0.5, -200, 0.5, -250)
frame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
frame.Active = true
frame.Draggable = true

-- Title
local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1, 0, 0, 50)
title.Position = UDim2.new(0,0,0,0)
title.BackgroundColor3 = Color3.fromRGB(0,0,0)
title.TextColor3 = Color3.fromRGB(255,255,255)
title.Text = "Server Finder - Block Spin"
title.TextScaled = true

-- Scrolling Frame
local scroll = Instance.new("ScrollingFrame", frame)
scroll.Size = UDim2.new(1, -20, 1, -60)
scroll.Position = UDim2.new(0, 10, 0, 50)
scroll.CanvasSize = UDim2.new(0,0,0,0)
scroll.BackgroundTransparency = 1
scroll.ScrollBarThickness = 8

local layout = Instance.new("UIListLayout", scroll)
layout.SortOrder = Enum.SortOrder.LayoutOrder
layout.Padding = UDim.new(0,5)

-- Refresh Button
local refreshBtn = Instance.new("TextButton", frame)
refreshBtn.Size = UDim2.new(0, 100, 0, 40)
refreshBtn.Position = UDim2.new(1, -110, 0, 10)
refreshBtn.Text = "Refresh"
refreshBtn.BackgroundColor3 = Color3.fromRGB(0,120,0)
refreshBtn.TextColor3 = Color3.fromRGB(255,255,255)

-- Get servers
local function getServers()
    scroll:ClearAllChildren()
    local success, servers = pcall(function()
        local url = "https://games.roblox.com/v1/games/"..game.PlaceId.."/servers/Public?sortOrder=Asc&limit=100"
        return HttpService:JSONDecode(game:HttpGet(url))
    end)

    if success and servers and servers.data then
        local yOffset = 0
        for i, server in ipairs(servers.data) do
            local btn = Instance.new("TextButton", scroll)
            btn.Size = UDim2.new(1, -10, 0, 50)
            btn.Position = UDim2.new(0,5,0,yOffset)
            btn.BackgroundColor3 = Color3.fromRGB(50,50,50)
            btn.TextColor3 = Color3.fromRGB(255,255,255)
            btn.TextScaled = true

            -- Detect number of PS players
            local psCount = 0
            if server.playing > 0 and server.platforms then
                for _, platform in pairs(server.platforms) do
                    if platform == "Xbox" or platform == "PS4" or platform == "PS5" then
                        psCount = psCount + 1
                    end
                end
            end

            -- Server label
            local serverLabel = "Server "..i.." - "..server.playing.."/"..server.maxPlayers
            if psCount > 0 then
                serverLabel = serverLabel.." | PS Players: "..psCount
                btn.BackgroundColor3 = Color3.fromRGB(200,50,50) -- أحمر إذا فيه PS
            else
                btn.BackgroundColor3 = Color3.fromRGB(50,200,50) -- أخضر إذا جوال فقط
            end
            btn.Text = serverLabel

            -- Join server
            btn.MouseButton1Click:Connect(function()
                TeleportService:TeleportToPlaceInstance(game.PlaceId, server.id, Players.LocalPlayer)
            end)

            yOffset = yOffset + 55
            scroll.CanvasSize = UDim2.new(0,0,0,yOffset)
        end
    else
        warn("Failed to get server list")
    end
end

refreshBtn.MouseButton1Click:Connect(getServers)
getServers()
