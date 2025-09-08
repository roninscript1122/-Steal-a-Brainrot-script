-- Services
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")
local player = Players.LocalPlayer

-- Flags
local isActive = true
local hookedEvents = {}

-- ScreenGui
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "FullEventLogger"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = player:WaitForChild("PlayerGui")

-- Main Frame
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 520, 0, 420)
MainFrame.Position = UDim2.new(0, 60, 0, 60)
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
MainFrame.BorderSizePixel = 0
MainFrame.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 12)
MainCorner.Parent = MainFrame

local MainStroke = Instance.new("UIStroke")
MainStroke.Color = Color3.fromRGB(60,60,60)
MainStroke.Thickness = 1
MainStroke.Parent = MainFrame

-- Title Bar (with gradient)
local TitleBar = Instance.new("Frame")
TitleBar.Size = UDim2.new(1,0,0,38)
TitleBar.BorderSizePixel = 0
TitleBar.Parent = MainFrame

local TitleBarCorner = Instance.new("UICorner")
TitleBarCorner.CornerRadius = UDim.new(0, 12)
TitleBarCorner.Parent = TitleBar

local gradient = Instance.new("UIGradient")
gradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(45,45,45)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(30,30,30))
}
gradient.Parent = TitleBar

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1,-70,1,0)
Title.Position = UDim2.new(0,12,0,0)
Title.BackgroundTransparency = 1
Title.Text = "RemoteEvent Logger"
Title.TextColor3 = Color3.fromRGB(235,235,235)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 18
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = TitleBar

-- Close Button (ImageButton)
local CloseBtn = Instance.new("ImageButton")
CloseBtn.Size = UDim2.new(0,28,0,28)
CloseBtn.Position = UDim2.new(1,-36,0,5)
CloseBtn.BackgroundTransparency = 1
CloseBtn.Image = "rbxassetid://3926305904"
CloseBtn.ImageRectOffset = Vector2.new(284,4)
CloseBtn.ImageRectSize = Vector2.new(24,24)
CloseBtn.Parent = TitleBar

-- Hover Effect
CloseBtn.MouseEnter:Connect(function()
    CloseBtn.ImageColor3 = Color3.fromRGB(255,80,80)
end)
CloseBtn.MouseLeave:Connect(function()
    CloseBtn.ImageColor3 = Color3.fromRGB(255,255,255)
end)

-- Close Action
CloseBtn.MouseButton1Click:Connect(function()
    isActive = false
    ScreenGui:Destroy()
end)


-- ScrollFrame for logs
local ScrollFrame = Instance.new("ScrollingFrame")
ScrollFrame.Size = UDim2.new(1,-12,1,-78)
ScrollFrame.Position = UDim2.new(0,6,0,44)
ScrollFrame.BackgroundTransparency = 1
ScrollFrame.BorderSizePixel = 0
ScrollFrame.CanvasSize = UDim2.new(0,0,0,0)
ScrollFrame.ScrollBarThickness = 6
ScrollFrame.ScrollBarImageColor3 = Color3.fromRGB(120,120,120)
ScrollFrame.Parent = MainFrame

local UIListLayout = Instance.new("UIListLayout")
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.Padding = UDim.new(0,3)
UIListLayout.Parent = ScrollFrame

-- Copy All Button
local CopyBtn = Instance.new("TextButton")
CopyBtn.Size = UDim2.new(0.25,0,0,28)
CopyBtn.Position = UDim2.new(0.375,0,1,-36)
CopyBtn.BackgroundColor3 = Color3.fromRGB(55,55,55)
CopyBtn.TextColor3 = Color3.fromRGB(230,230,230)
CopyBtn.Font = Enum.Font.Gotham
CopyBtn.TextSize = 14
CopyBtn.Text = "Copy Logs"
CopyBtn.Parent = MainFrame
local CopyCorner = Instance.new("UICorner")
CopyCorner.CornerRadius = UDim.new(0,6)
CopyCorner.Parent = CopyBtn

CopyBtn.MouseEnter:Connect(function()
    CopyBtn.BackgroundColor3 = Color3.fromRGB(75,75,75)
end)
CopyBtn.MouseLeave:Connect(function()
    CopyBtn.BackgroundColor3 = Color3.fromRGB(55,55,55)
end)

-- Resize Handle
local ResizeHandle = Instance.new("Frame")
ResizeHandle.Size = UDim2.new(0,16,0,16)
ResizeHandle.Position = UDim2.new(1,-18,1,-18)
ResizeHandle.BackgroundColor3 = Color3.fromRGB(80,80,80)
ResizeHandle.BorderSizePixel = 0
ResizeHandle.Parent = MainFrame
local ResizeCorner = Instance.new("UICorner")
ResizeCorner.CornerRadius = UDim.new(0,4)
ResizeCorner.Parent = ResizeHandle

-- Logs utilities
local logs = {}
local function tableToString(tbl)
    local success, json = pcall(function()
        return HttpService:JSONEncode(tbl)
    end)
    return success and json or tostring(tbl)
end

local function logToGUI(msg)
    if not isActive then return end
    local time = os.date("%H:%M:%S")
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1,0,0,20)
    label.BackgroundTransparency = 1
    label.TextColor3 = Color3.fromRGB(220,220,220)
    label.Font = Enum.Font.Gotham
    label.TextSize = 14
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Text = "["..time.."] "..msg
    label.Parent = ScrollFrame
    table.insert(logs,label)

    local underline = Instance.new("Frame")
    underline.Size = UDim2.new(1,0,0,1)
    underline.BackgroundColor3 = Color3.fromRGB(40,40,40)
    underline.BorderSizePixel = 0
    underline.Parent = label

    task.wait(0.01)
    ScrollFrame.CanvasSize = UDim2.new(0,0,0,UIListLayout.AbsoluteContentSize.Y)
    ScrollFrame.CanvasPosition = Vector2.new(0, UIListLayout.AbsoluteContentSize.Y)
end

-- Copy logs
CopyBtn.MouseButton1Click:Connect(function()
    local allText = ""
    for _, label in ipairs(logs) do
        allText = allText .. label.Text .. "\n"
    end
    if syn and syn.set_clipboard then
        syn.set_clipboard(allText)
    elseif setclipboard then
        setclipboard(allText)
    end
end)

-- Close
CloseBtn.MouseButton1Click:Connect(function()
    isActive = false
    ScreenGui:Destroy()
end)

-- Drag
local dragging, dragInput, dragStart, startPos
TitleBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = MainFrame.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)
TitleBar.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement then
        dragInput = input
    end
end)
RunService.RenderStepped:Connect(function()
    if dragging and dragInput then
        local delta = dragInput.Position - dragStart
        MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X,
                                       startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

-- Resize
local resizing, resizeStart, startSize
ResizeHandle.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        resizing = true
        resizeStart = input.Position
        startSize = MainFrame.Size
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                resizing = false
            end
        end)
    end
end)
ResizeHandle.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement then
        dragInput = input
    end
end)
RunService.RenderStepped:Connect(function()
    if resizing and dragInput then
        local delta = dragInput.Position - resizeStart
        MainFrame.Size = UDim2.new(startSize.X.Scale, math.max(320, startSize.X.Offset + delta.X),
                                   startSize.Y.Scale, math.max(220, startSize.Y.Offset + delta.Y))
    end
end)

-- Hook RemoteEvent
local function hookEvent(event)
    if not event:IsA("RemoteEvent") then return end
    if hookedEvents[event] then return end
    hookedEvents[event] = true

    event.OnClientEvent:Connect(function(...)
        if not isActive then return end
        local args = {...}
        local strArgs = {}
        for i,v in ipairs(args) do
            if typeof(v) == "table" then
                table.insert(strArgs, tableToString(v))
            else
                table.insert(strArgs, tostring(v))
            end
        end
        local msg = "[Triggered] "..event:GetFullName().." Args: "..table.concat(strArgs,", ")
        print(msg)
        logToGUI(msg)
    end)
end

for _, obj in pairs(game:GetDescendants()) do
    hookEvent(obj)
end
game.DescendantAdded:Connect(hookEvent)
