local SimpleShindoUi = loadstring(game:HttpGet("https://raw.githubusercontent.com/naypramx/Ui__Project/Script/SimpleShindoUi"))()
local Main = SimpleShindoUi:new()
local Tab = Main:Tap("CenterHub")

-- หน้าแรก
local page = Tab:page()

-- ESP Toggle
page:Toggle("ESP", false, function(state)
    local Players = game:GetService("Players")
    local RunService = game:GetService("RunService")
    local player = Players.LocalPlayer

    local espActive = state
    local espObjects = {}

    local function createESP(playerTarget)
        if not playerTarget or not playerTarget.Character then return end
        local char = playerTarget.Character
        if char:FindFirstChild("ESP_Highlight") then char.ESP_Highlight:Destroy() end
        if char:FindFirstChild("ESP_Billboard") then char.ESP_Billboard:Destroy() end

        local highlight = Instance.new("Highlight")
        highlight.Name = "ESP_Highlight"
        highlight.Adornee = char
        highlight.FillColor = Color3.fromRGB(255,0,0)
        highlight.FillTransparency = 0.5
        highlight.OutlineColor = Color3.fromRGB(255,255,255)
        highlight.OutlineTransparency = 0
        highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
        highlight.Parent = char

        local hrp = char:FindFirstChild("HumanoidRootPart")
        if hrp then
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

    if espActive then
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= player then
                createESP(p)
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
    else
        for p,_ in pairs(espObjects) do
            removeESP(p)
        end
    end

    RunService.Heartbeat:Connect(function()
        if espActive then
            for target, data in pairs(espObjects) do
                if target and target.Character then
                    if data.highlight then data.highlight.Adornee = target.Character end
                    local hrp = target.Character:FindFirstChild("HumanoidRootPart")
                    if data.billboard and hrp then
                        data.billboard.Adornee = hrp
                    end
                end
            end
        end
    end)
end)

-- Boost Toggle
page:Toggle("Boost", false, function(state)
    local player = game:GetService("Players").LocalPlayer
    local boostActive = state
    local boostSpeed = 30
    local jumpPower = 50

    local function applyBoost()
        local char = player.Character
        if not char then return end
        local humanoid = char:FindFirstChildOfClass("Humanoid")
        if humanoid then
            if boostActive then
                humanoid.WalkSpeed = boostSpeed
                humanoid.JumpPower = jumpPower
            else
                humanoid.WalkSpeed = 16
                humanoid.JumpPower = 50
            end
        end
    end

    applyBoost()
    player.CharacterAdded:Connect(function()
        task.wait(0.5)
        applyBoost()
    end)
    game:GetService("RunService").Heartbeat:Connect(function()
        if boostActive then applyBoost() end
    end)
end)

-- Logger Button
page:Button("LoggerUI", function()
    local success, err = pcall(function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/roninscript1122/-Steal-a-Brainrot-script/refs/heads/main/LoggerUI.lua"))()
    end)
    if not success then
        warn("Failed to load LoggerUI.lua: " .. tostring(err))
    end
end)
