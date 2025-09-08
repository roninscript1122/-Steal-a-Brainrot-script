local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer

-- GUI Setup
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "CustomESPGui"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = player:WaitForChild("PlayerGui")

-- Main Frame
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 220, 0, 120)
MainFrame.Position = UDim2.new(0, 20, 0, 50)
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
MainFrame.BorderSizePixel = 0
MainFrame.Visible = true
MainFrame.Parent = ScreenGui

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 12)
UICorner.Parent = MainFrame

-- Title
local Title = Instance.new("TextLabel")
Title.Text = "ESP Menu"
Title.Size = UDim2.new(1, 0, 0, 30)
Title.Position = UDim2.new(0, 0, 0, 0)
Title.BackgroundTransparency = 1
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 18
Title.Parent = MainFrame

-- ESP Toggle Button
local ESPBtn = Instance.new("TextButton")
ESPBtn.Size = UDim2.new(0.9, 0, 0, 35)
ESPBtn.Position = UDim2.new(0.05, 0, 0.35, 0)
ESPBtn.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
ESPBtn.TextColor3 = Color3.new(1, 1, 1)
ESPBtn.Font = Enum.Font.Gotham
ESPBtn.TextSize = 16
ESPBtn.Text = "ESP: OFF"
ESPBtn.Parent = MainFrame

local ESPCorner = Instance.new("UICorner")
ESPCorner.CornerRadius = UDim.new(0, 8)
ESPCorner.Parent = ESPBtn

-- ESP System
local espActive = false
local espObjects = {}

local function createESP(playerTarget)
    if not playerTarget or not playerTarget.Character then return end
    local character = playerTarget.Character

    -- Remove previous ESP if exists
    if character:FindFirstChild("ESP_Highlight") then
        character.ESP_Highlight:Destroy()
    end
    if character:FindFirstChild("ESP_Billboard") then
        character.ESP_Billboard:Destroy()
    end

    -- Highlight
    local highlight = Instance.new("Highlight")
    highlight.Name = "ESP_Highlight"
    highlight.Adornee = character
    highlight.FillColor = Color3.fromRGB(255, 0, 0)
    highlight.FillTransparency = 0.5
    highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
    highlight.OutlineTransparency = 0
    highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    highlight.Parent = character

    -- Billboard
    local hrp = character:FindFirstChild("HumanoidRootPart")
    if hrp then
        local billboard = Instance.new("BillboardGui")
        billboard.Name = "ESP_Billboard"
        billboard.AlwaysOnTop = true
        billboard.Size = UDim2.new(4, 0, 1, 0)
        billboard.StudsOffset = Vector3.new(0, 3, 0)
        billboard.Adornee = hrp
        billboard.Parent = hrp

        local nameLabel = Instance.new("TextLabel")
        nameLabel.Text = playerTarget.Name
        nameLabel.TextColor3 = Color3.new(1, 1, 1)
        nameLabel.TextStrokeColor3 = Color3.new(0, 0, 0)
        nameLabel.TextStrokeTransparency = 0
        nameLabel.BackgroundTransparency = 1
        nameLabel.Size = UDim2.new(1, 0, 1, 0)
        nameLabel.Font = Enum.Font.GothamBold
        nameLabel.TextSize = 14
        nameLabel.Parent = billboard
    end

    espObjects[playerTarget] = {highlight = highlight, billboard = hrp and hrp:FindFirstChild("ESP_Billboard")}
end

local function removeESP(playerTarget)
    local data = espObjects[playerTarget]
    if data then
        if data.highlight then data.highlight:Destroy() end
        if data.billboard then data.billboard:Destroy() end
        espObjects[playerTarget] = nil
    end
end

-- Toggle ESP
ESPBtn.MouseButton1Click:Connect(function()
    espActive = not espActive
    ESPBtn.Text = "ESP: " .. (espActive and "ON" or "OFF")
    ESPBtn.BackgroundColor3 = espActive and Color3.fromRGB(50, 120, 50) or Color3.fromRGB(70, 70, 70)

    if espActive then
        -- Setup for existing players
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= player then
                createESP(p)
                -- Respawn handler
                p.CharacterAdded:Connect(function()
                    task.wait(0.5)
                    if espActive then
                        createESP(p)
                    end
                end)
            end
        end
        -- Setup for new players
        Players.PlayerAdded:Connect(function(p)
            if p ~= player then
                if espActive then
                    createESP(p)
                end
                p.CharacterAdded:Connect(function()
                    task.wait(0.5)
                    if espActive then
                        createESP(p)
                    end
                end)
            end
        end)
    else
        -- Remove all ESP
        for p, _ in pairs(espObjects) do
            removeESP(p)
        end
    end
end)

-- Heartbeat update (keeps billboard and highlight updated)
RunService.Heartbeat:Connect(function()
    if espActive then
        for target, data in pairs(espObjects) do
            if target and target.Character then
                if data.highlight then
                    data.highlight.Adornee = target.Character
                end
                local hrp = target.Character:FindFirstChild("HumanoidRootPart")
                if data.billboard and hrp then
                    data.billboard.Adornee = hrp
                end
            end
        end
    end
end)
