local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local player = Players.LocalPlayer

-- GUI Setup (เหมือนเดิม)
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "SimpleGUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = player:WaitForChild("PlayerGui")

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

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 200, 0, 150)
MainFrame.Position = UDim2.new(0, 80, 0.5, -75)
MainFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
MainFrame.Visible = false
MainFrame.Parent = ScreenGui

local MainUICorner = Instance.new("UICorner")
MainUICorner.CornerRadius = UDim.new(0, 8)
MainUICorner.Parent = MainFrame

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
            local character = player.Character
            if character then
                for _, part in pairs(character:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = false -- แค่เดินทะลุ Object
                    end
                end
            end
        end)
    end
end)

-- Boost Speed
local boostActive = false
local boostSpeed = 50

local function applyBoost(character)
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    if humanoid and boostActive then
        humanoid.WalkSpeed = boostSpeed
    end
end

BoostSpeedBtn.MouseButton1Click:Connect(function()
    boostActive = not boostActive
    BoostSpeedBtn.Text = "Boost Speed: "..(boostActive and "ON" or "OFF")
    BoostSpeedBtn.BackgroundColor3 = boostActive and Color3.fromRGB(50,120,50) or Color3.fromRGB(70,70,70)

    if player.Character then
        applyBoost(player.Character)
    end
end)

player.CharacterAdded:Connect(function(character)
    task.wait(0.5) -- รอ Humanoid สร้าง
    applyBoost(character)
end)
