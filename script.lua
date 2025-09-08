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
MainFrame.Size = UDim2.new(0, 240, 0, 280)
MainFrame.Position = UDim2.new(0, 20, 0, 50)
MainFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
MainFrame.BorderSizePixel = 0
MainFrame.Visible = true
MainFrame.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 16)
MainCorner.Parent = MainFrame

local MainStroke = Instance.new("UIStroke")
MainStroke.Color = Color3.fromRGB(80, 80, 80)
MainStroke.Thickness = 2
MainStroke.Parent = MainFrame

-- Gradient Background
local MainGradient = Instance.new("UIGradient")
MainGradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(50,50,50)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(30,30,30))
}
MainGradient.Rotation = 45
MainGradient.Parent = MainFrame

-- Title
local Title = Instance.new("TextLabel")
Title.Text = "Custom Menu"
Title.Size = UDim2.new(1, 0, 0, 40)
Title.Position = UDim2.new(0, 0, 0, 0)
Title.BackgroundTransparency = 1
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 20
Title.Parent = MainFrame

-- Hide/Show Toggle
local ToggleBtn = Instance.new("TextButton")
ToggleBtn.Size = UDim2.new(0, 60, 0, 30)
ToggleBtn.Position = UDim2.new(1, 10, 0, 5)
ToggleBtn.BackgroundColor3 = Color3.fromRGB(80,80,80)
ToggleBtn.TextColor3 = Color3.fromRGB(255,255,255)
ToggleBtn.Text = "Hide"
ToggleBtn.Font = Enum.Font.Gotham
ToggleBtn.TextSize = 14
ToggleBtn.Parent = MainFrame

local ToggleCorner = Instance.new("UICorner")
ToggleCorner.CornerRadius = UDim.new(0, 8)
ToggleCorner.Parent = ToggleBtn

ToggleBtn.MouseEnter:Connect(function()
    ToggleBtn.BackgroundColor3 = Color3.fromRGB(110,110,110)
end)
ToggleBtn.MouseLeave:Connect(function()
    ToggleBtn.BackgroundColor3 = Color3.fromRGB(80,80,80)
end)

-- ปุ่มเล็กไว้กดโชว์เมื่อซ่อนเมนู
local ShowBtn = Instance.new("TextButton")
ShowBtn.Size = UDim2.new(0, 80, 0, 35)
ShowBtn.Position = UDim2.new(0, 20, 0, 50)
ShowBtn.BackgroundColor3 = Color3.fromRGB(60,60,60)
ShowBtn.TextColor3 = Color3.fromRGB(255,255,255)
ShowBtn.Text = "Menu"
ShowBtn.Font = Enum.Font.GothamBold
ShowBtn.TextSize = 16
ShowBtn.Visible = false
ShowBtn.Parent = ScreenGui

local ShowCorner = Instance.new("UICorner")
ShowCorner.CornerRadius = UDim.new(0, 10)
ShowCorner.Parent = ShowBtn

ToggleBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = false
    ShowBtn.Visible = true
end)

ShowBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = true
    ShowBtn.Visible = false
end)

-- Function to create styled buttons
local function createButton(parent, text, position)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.9, 0, 0, 40)
    btn.Position = position
    btn.BackgroundColor3 = Color3.fromRGB(80,80,80)
    btn.TextColor3 = Color3.fromRGB(255,255,255)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 16
    btn.Text = text
    btn.Parent = parent

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 10)
    corner.Parent = btn

    local gradient = Instance.new("UIGradient")
    gradient.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, Color3.fromRGB(100,100,100)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(60,60,60))
    }
    gradient.Rotation = 90
    gradient.Parent = btn

    btn.MouseEnter:Connect(function()
        btn.BackgroundColor3 = Color3.fromRGB(120,120,120)
    end)
    btn.MouseLeave:Connect(function()
        btn.BackgroundColor3 = Color3.fromRGB(80,80,80)
    end)
    return btn
end

-- ESP Button
local ESPBtn = createButton(MainFrame, "ESP: OFF", UDim2.new(0.05, 0, 0.2, 0))

-- Boost Button
local BoostBtn = createButton(MainFrame, "Boost: OFF", UDim2.new(0.05, 0, 0.45, 0))

-- Logger Button
local LoggerBtn = createButton(MainFrame, "LoggerUI", UDim2.new(0.05, 0, 0.7, 0))

LoggerBtn.MouseButton1Click:Connect(function()
    local success, err = pcall(function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/roninscript1122/-Steal-a-Brainrot-script/refs/heads/main/LoggerUI.lua"))()
    end)
    if not success then
        warn("Failed to load LoggerUI.lua: " .. tostring(err))
    end
end)
