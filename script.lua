local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local player = Players.LocalPlayer

-- GUI Setup
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "SimpleGUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = player:WaitForChild("PlayerGui")

-- Toggle Button
local ToggleBtn = Instance.new("TextButton")
ToggleBtn.Size = UDim2.new(0, 60, 0, 60)
ToggleBtn.Position = UDim2.new(0, 10, 0.5, -30)
ToggleBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
ToggleBtn.TextColor3 = Color3.new(1, 1, 1)
ToggleBtn.Text = "Menu"
ToggleBtn.Font = Enum.Font.GothamBlack
ToggleBtn.TextSize = 20
ToggleBtn.Parent = ScreenGui

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 12)
UICorner.Parent = ToggleBtn

-- Main Frame
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 200, 0, 150)
MainFrame.Position = UDim2.new(0, 80, 0.5, -75)
MainFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
MainFrame.Visible = false
MainFrame.Parent = ScreenGui

local MainUICorner = Instance.new("UICorner")
MainUICorner.CornerRadius = UDim.new(0, 8)
MainUICorner.Parent = MainFrame

-- Toggle functions
local function createButton(name, posY)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.9, 0, 0, 30)
    btn.Position = UDim2.new(0.05, 0, 0.05 + posY*0.2, 0)
    btn.Text = name
    btn.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 14
    btn.Parent = MainFrame
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = btn
    return btn
end

local NoclipBtn = createButton("Noclip: OFF", 0)
local ESPBtn = createButton("ESP: OFF", 1)
local BoostSpeedBtn = createButton("Boost Speed: OFF", 2)

-- Toggle UI
ToggleBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = not MainFrame.Visible
end)

-- Noclip
local noclipActive = false
local noclipConnection = nil
NoclipBtn.MouseButton1Click:Connect(function()
    noclipActive = not noclipActive
    NoclipBtn.Text = "Noclip: "..(noclipActive and "ON" or "OFF")
    NoclipBtn.BackgroundColor3 = noclipActive and Color3.fromRGB(50,120,50) or Color3.fromRGB(70,70,70)

    if noclipConnection then
        noclipConnection:Disconnect()
        noclipConnection = nil
    end

    if noclipActive then
        noclipConnection = RunService.Stepped:Connect(function()
            if player.Character then
                for _, part in pairs(player.Character:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = false
                    end
                end
            end
        end)
    end
end)

-- ESP
local espActive = false
local espHandles = {}
local espConnection = nil

local function createESP(targetPlayer)
    if not targetPlayer or not targetPlayer.Character then return end
    local character = targetPlayer.Character

    if character:FindFirstChild("ESP_Highlight") then
        character.ESP_Highlight:Destroy()
    end
    if character:FindFirstChild("ESP_Billboard") then
        character.ESP_Billboard:Destroy()
    end

    local highlight = Instance.new("Highlight")
    highlight.Name = "ESP_Highlight"
    highlight.Adornee = character
    highlight.FillColor = Color3.fromRGB(255,0,0)
    highlight.FillTransparency = 0.5
    highlight.OutlineColor = Color3.fromRGB(255,255,255)
    highlight.OutlineTransparency = 0
    highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    highlight.Parent = character

    local hrp = character:FindFirstChild("HumanoidRootPart")
    if hrp then
        local billboard = Instance.new("BillboardGui")
        billboard.Name = "ESP_Billboard"
        billboard.AlwaysOnTop = true
        billboard.Size = UDim2.new(4,0,1,0)
        billboard.StudsOffset = Vector3.new(0,3,0)
        billboard.Adornee = hrp
        billboard.Parent = hrp

        local nameLabel = Instance.new("TextLabel")
        nameLabel.Text = targetPlayer.Name
        nameLabel.TextColor3 = Color3.new(1,1,1)
        nameLabel.TextStrokeColor3 = Color3.new(0,0,0)
        nameLabel.TextStrokeTransparency = 0
        nameLabel.BackgroundTransparency = 1
        nameLabel.Size = UDim2.new(1,0,1,0)
        nameLabel.Font = Enum.Font.GothamBold
        nameLabel.TextSize = 14
        nameLabel.Parent = billboard
    end

    return {highlight = highlight, billboard = hrp:FindFirstChild("ESP_Billboard")}
end

ESPBtn.MouseButton1Click:Connect(function()
    espActive = not espActive
    ESPBtn.Text = "ESP: "..(espActive and "ON" or "OFF")
    ESPBtn.BackgroundColor3 = espActive and Color3.fromRGB(50,120,50) or Color3.fromRGB(70,70,70)

    for _, data in pairs(espHandles) do
        if data.highlight then data.highlight:Destroy() end
        if data.billboard then data.billboard:Destroy() end
    end
    espHandles = {}

    if espConnection then
        espConnection:Disconnect()
        espConnection = nil
    end

    if espActive then
        local function setupESP(targetPlayer)
            if targetPlayer ~= player then
                local data = createESP(targetPlayer)
                if data then espHandles[targetPlayer] = data end
                targetPlayer.CharacterAdded:Connect(function()
                    task.wait(1)
                    local data = createESP(targetPlayer)
                    if data then espHandles[targetPlayer] = data end
                end)
            end
        end

        for _, p in ipairs(Players:GetPlayers()) do
            setupESP(p)
        end
        Players.PlayerAdded:Connect(setupESP)

        espConnection = RunService.Heartbeat:Connect(function()
            if not espActive then return end
            for target, data in pairs(espHandles) do
                if target and target.Character then
                    if data.highlight then data.highlight.Adornee = target.Character end
                    if data.billboard and target.Character:FindFirstChild("HumanoidRootPart") then
                        data.billboard.Adornee = target.Character.HumanoidRootPart
                    end
                end
            end
        end)
    end
end)

-- Boost Speed
local boostActive = false
local boostConnection = nil
local boostSpeed = 50

BoostSpeedBtn.MouseButton1Click:Connect(function()
    boostActive = not boostActive
    BoostSpeedBtn.Text = "Boost Speed: "..(boostActive and "ON" or "OFF")
    BoostSpeedBtn.BackgroundColor3 = boostActive and Color3.fromRGB(50,120,50) or Color3.fromRGB(70,70,70)

    if boostConnection then
        boostConnection:Disconnect()
        boostConnection = nil
    end

    if boostActive then
        boostConnection = RunService.Heartbeat:Connect(function()
            if not boostActive or not player.Character then return end
            local hrp = player.Character:FindFirstChild("HumanoidRootPart")
            if hrp then
                local cam = workspace.CurrentCamera
                local look = Vector3.new(cam.CFrame.LookVector.X, 0, cam.CFrame.LookVector.Z).Unit
                hrp.Velocity = look * boostSpeed
            end
        end)
    else
        if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            player.Character.HumanoidRootPart.Velocity = Vector3.new(0,0,0)
        end
    end
end)
