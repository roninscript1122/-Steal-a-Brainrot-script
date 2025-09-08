-- Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer
local UserInputService = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService")

-- GUI Setup
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "CustomMenu"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = player:WaitForChild("PlayerGui")

-- Main Frame
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 220, 0, 220) -- เพิ่มความสูงนิดหน่อย
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

-- ปุ่มเล็กไว้กดโชว์เมื่อซ่อนเมนู
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

-- Boost Button
local BoostBtn = Instance.new("TextButton")
BoostBtn.Size = UDim2.new(0.9, 0, 0, 35)
BoostBtn.Position = UDim2.new(0.05, 0, 0.5, 0)
BoostBtn.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
BoostBtn.TextColor3 = Color3.new(1,1,1)
BoostBtn.Font = Enum.Font.Gotham
BoostBtn.TextSize = 16
BoostBtn.Text = "Boost: OFF"
BoostBtn.Parent = MainFrame

local BoostCorner = Instance.new("UICorner")
BoostCorner.CornerRadius = UDim.new(0, 8)
BoostCorner.Parent = BoostBtn

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
    -- โหลด LoggerUI.lua จาก GitHub
    local success, err = pcall(function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/roninscript1122/-Steal-a-Brainrot-script/refs/heads/main/LoggerUI.lua"))()
    end)
    if not success then
        warn("Failed to load LoggerUI.lua: " .. tostring(err))
    end
end)
