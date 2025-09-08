local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer
local UserInputService = game:GetService("UserInputService")

-- GUI Setup
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "CustomMenu"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = player:WaitForChild("PlayerGui")

-- Main Frame
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 220, 0, 180)
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
Title.Text = "Custom Menu"
Title.Size = UDim2.new(1, 0, 0, 30)
Title.Position = UDim2.new(0, 0, 0, 0)
Title.BackgroundTransparency = 1
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 18
Title.Parent = MainFrame

-- Hide/Show Toggle
local ToggleBtn = Instance.new("TextButton")
ToggleBtn.Size = UDim2.new(0, 60, 0, 30)
ToggleBtn.Position = UDim2.new(1, 10, 0, 0)
ToggleBtn.BackgroundColor3 = Color3.fromRGB(70,70,70)
ToggleBtn.TextColor3 = Color3.new(1,1,1)
ToggleBtn.Text = "Hide"
ToggleBtn.Font = Enum.Font.Gotham
ToggleBtn.TextSize = 14
ToggleBtn.Parent = MainFrame

local ToggleCorner = Instance.new("UICorner")
ToggleCorner.CornerRadius = UDim.new(0, 8)
ToggleCorner.Parent = ToggleBtn

-- Show Button
local ShowBtn = Instance.new("TextButton")
ShowBtn.Size = UDim2.new(0, 60, 0, 30)
ShowBtn.Position = UDim2.new(0, 20, 0, 50)
ShowBtn.BackgroundColor3 = Color3.fromRGB(50,50,50)
ShowBtn.TextColor3 = Color3.new(1,1,1)
ShowBtn.Text = "Menu"
ShowBtn.Font = Enum.Font.Gotham
ShowBtn.TextSize = 14
ShowBtn.Visible = false
ShowBtn.Parent = ScreenGui

local ShowCorner = Instance.new("UICorner")
ShowCorner.CornerRadius = UDim.new(0, 8)
ShowCorner.Parent = ShowBtn

ToggleBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = false
    ShowBtn.Visible = true
end)

ShowBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = true
    ShowBtn.Visible = false
end)

-- ESP Button
local ESPBtn = Instance.new("TextButton")
ESPBtn.Size = UDim2.new(0.9, 0, 0, 35)
ESPBtn.Position = UDim2.new(0.05, 0, 0.2, 0)
ESPBtn.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
ESPBtn.TextColor3 = Color3.new(1,1,1)
ESPBtn.Font = Enum.Font.Gotham
ESPBtn.TextSize = 16
ESPBtn.Text = "ESP: OFF"
ESPBtn.Parent = MainFrame

local ESPCorner = Instance.new("UICorner")
ESPCorner.CornerRadius = UDim.new(0, 8)
ESPCorner.Parent = ESPBtn

-- ESP Logic
local espActive = false
local espObjects = {}

local function createESP(playerTarget)
    if not playerTarget or not playerTarget.Character then return end
    local char = playerTarget.Character
    if not char:FindFirstChild("ESP_Highlight") then
        local highlight = Instance.new("Highlight")
        highlight.Name = "ESP_Highlight"
        highlight.Adornee = char
        highlight.FillColor = Color3.fromRGB(255,0,0)
        highlight.FillTransparency = 0.5
        highlight.OutlineColor = Color3.fromRGB(255,255,255)
        highlight.OutlineTransparency = 0
        highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
        highlight.Parent = char
    end

    local hrp = char:FindFirstChild("HumanoidRootPart")
    if hrp and not hrp:FindFirstChild("ESP_Billboard") then
        local billboard = Instance.new("BillboardGui")
        billboard.Name = "ESP_Billboard"
        billboard.AlwaysOnTop = true
        billboard.Size = UDim2.new(4,0,1,0)
        billboard.StudsOffset = Vector3.new(0,3,0)
        billboard.Adornee = hrp
        billboard.Parent = hrp

        local nameLabel = Instance.new("TextLabel")
        nameLabel.Text = playerTarget.Name
        nameLabel.TextColor3 = Color3.new(1,1,1)
        nameLabel.TextStrokeColor3 = Color3.new(0,0,0)
        nameLabel.TextStrokeTransparency = 0
        nameLabel.BackgroundTransparency = 1
        nameLabel.Size = UDim2.new(1,0,1,0)
        nameLabel.Font = Enum.Font.GothamBold
        nameLabel.TextSize = 14
        nameLabel.Parent = billboard
    end

    espObjects[playerTarget] = char
end

local function removeESP(playerTarget)
    local char = espObjects[playerTarget]
    if char then
        if char:FindFirstChild("ESP_Highlight") then char.ESP_Highlight:Destroy() end
        local hrp = char:FindFirstChild("HumanoidRootPart")
        if hrp and hrp:FindFirstChild("ESP_Billboard") then hrp.ESP_Billboard:Destroy() end
        espObjects[playerTarget] = nil
    end
end

ESPBtn.MouseButton1Click:Connect(function()
    espActive = not espActive
    ESPBtn.Text = "ESP: "..(espActive and "ON" or "OFF")
    ESPBtn.BackgroundColor3 = espActive and Color3.fromRGB(50,120,50) or Color3.fromRGB(70,70,70)

    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= player then
            if espActive then createESP(p) else removeESP(p) end
            p.CharacterAdded:Connect(function()
                task.wait(0.5)
                if espActive then createESP(p) end
            end)
        end
    end

    Players.PlayerAdded:Connect(function(p)
        if p ~= player then
            if espActive then createESP(p) end
            p.CharacterAdded:Connect(function()
                task.wait(0.5)
                if espActive then createESP(p) end
            end)
        end
    end)
end)

-- Logger Button
local LoggerBtn = Instance.new("TextButton")
LoggerBtn.Size = UDim2.new(0.9, 0, 0, 35)
LoggerBtn.Position = UDim2.new(0.05, 0, 0.75, 0)
LoggerBtn.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
LoggerBtn.TextColor3 = Color3.new(1,1,1)
LoggerBtn.Font = Enum.Font.Gotham
LoggerBtn.TextSize = 16
LoggerBtn.Text = "LoggerUI"
LoggerBtn.Parent = MainFrame

local LoggerCorner = Instance.new("UICorner")
LoggerCorner.CornerRadius = UDim.new(0, 8)
LoggerCorner.Parent = LoggerBtn

LoggerBtn.MouseButton1Click:Connect(function()
    local success, err = pcall(function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/roninscript1122/-Steal-a-Brainrot-script/refs/heads/main/LoggerUI.lua"))()
    end)
    if not success then
        warn("Failed to load LoggerUI.lua: " .. tostring(err))
    end
end)
