local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
local character = player.Character or player.CharacterAdded:Wait()
local humanoidRootPart = character:WaitForChild("HumanoidRootPart")
local humanoid = character:WaitForChild("Humanoid")

-- Wait for remotes
local fishRemote = ReplicatedStorage:WaitForChild("Fish")
local shopRemote = ReplicatedStorage:WaitForChild("Shop")
local teleportRemote = ReplicatedStorage:WaitForChild("Teleport")

-- Settings variables
local walkSpeed = 16
local infinityJumpEnabled = false
local canJump = true
local isInfinityJumping = false

-- Create main screen GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "FishingGui"
screenGui.ResetOnSpawn = false
screenGui.Parent = playerGui

-- Create notification container
local notificationContainer = Instance.new("Frame")
notificationContainer.Name = "NotificationContainer"
notificationContainer.Size = UDim2.new(0, 350, 0, 0)
notificationContainer.Position = UDim2.new(1, -370, 0, 20)
notificationContainer.BackgroundTransparency = 1
notificationContainer.Parent = screenGui

-- Notification function
local function createNotification(title, message, color, duration)
  duration = duration or 4
  color = color or Color3.fromRGB(100, 200, 255)
  
  local notification = Instance.new("Frame")
  notification.Name = "Notification"
  notification.Size = UDim2.new(1, 0, 0, 0)
  notification.Position = UDim2.new(0, 0, 0, 0)
  notification.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
  notification.BorderColor3 = color
  notification.BorderSizePixel = 2
  notification.Parent = notificationContainer
  
  local corner = Instance.new("UICorner")
  corner.CornerRadius = UDim.new(0, 8)
  corner.Parent = notification
  
  local titleLabel = Instance.new("TextLabel")
  titleLabel.Name = "Title"
  titleLabel.Size = UDim2.new(1, -20, 0, 25)
  titleLabel.Position = UDim2.new(0, 10, 0, 5)
  titleLabel.BackgroundTransparency = 1
  titleLabel.TextColor3 = color
  titleLabel.TextSize = 16
  titleLabel.Font = Enum.Font.GothamBold
  titleLabel.Text = title
  titleLabel.TextXAlignment = Enum.TextXAlignment.Left
  titleLabel.Parent = notification
  
  local messageLabel = Instance.new("TextLabel")
  messageLabel.Name = "Message"
  messageLabel.Size = UDim2.new(1, -20, 0, 40)
  messageLabel.Position = UDim2.new(0, 10, 0, 30)
  messageLabel.BackgroundTransparency = 1
  messageLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
  messageLabel.TextSize = 14
  messageLabel.Font = Enum.Font.Gotham
  messageLabel.Text = message
  messageLabel.TextXAlignment = Enum.TextXAlignment.Left
  messageLabel.TextWrapped = true
  messageLabel.Parent = notification
  
  local expandTween = TweenService:Create(notification, TweenInfo.new(0.3), {Size = UDim2.new(1, 0, 0, 80)})
  expandTween:Play()
  
  wait(duration)
  
  local collapseTween = TweenService:Create(notification, TweenInfo.new(0.3), {Size = UDim2.new(1, 0, 0, 0)})
  collapseTween:Play()
  collapseTween.Completed:Connect(function()
    notification:Destroy()
  end)
end

-- Main menu panel
local mainPanel = Instance.new("Frame")
mainPanel.Name = "MainPanel"
mainPanel.Size = UDim2.new(0, 350, 0, 500)
mainPanel.Position = UDim2.new(0, 20, 0, 20)
mainPanel.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
mainPanel.BorderColor3 = Color3.fromRGB(100, 200, 255)
mainPanel.BorderSizePixel = 2
mainPanel.Parent = screenGui

local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 10)
mainCorner.Parent = mainPanel

-- Title
local title = Instance.new("TextLabel")
title.Name = "Title"
title.Size = UDim2.new(1, 0, 0, 50)
title.BackgroundColor3 = Color3.fromRGB(15, 15, 25)
title.TextColor3 = Color3.fromRGB(100, 200, 255)
title.TextSize = 28
title.Font = Enum.Font.GothamBold
title.Text = "🎣 FISHING MENU"
title.BorderSizePixel = 0
title.Parent = mainPanel

local titleCorner = Instance.new("UICorner")
titleCorner.CornerRadius = UDim.new(0, 10)
titleCorner.Parent = title

-- Button layout
local buttonsContainer = Instance.new("Frame")
buttonsContainer.Name = "ButtonsContainer"
buttonsContainer.Size = UDim2.new(1, -20, 1, -70)
buttonsContainer.Position = UDim2.new(0, 10, 0, 60)
buttonsContainer.BackgroundTransparency = 1
buttonsContainer.Parent = mainPanel

local listLayout = Instance.new("UIListLayout")
listLayout.Padding = UDim.new(0, 10)
listLayout.Parent = buttonsContainer

-- Button function
local function createButton(text, icon, parent, callback)
  local button = Instance.new("TextButton")
  button.Name = text
  button.Size = UDim2.new(1, 0, 0, 50)
  button.BackgroundColor3 = Color3.fromRGB(40, 40, 55)
  button.TextColor3 = Color3.fromRGB(150, 200, 255)
  button.TextSize = 16
  button.Font = Enum.Font.GothamBold
  button.Text = icon .. " " .. text
  button.BorderSizePixel = 1
  button.BorderColor3 = Color3.fromRGB(80, 150, 200)
  button.Parent = parent
  
  local buttonCorner = Instance.new("UICorner")
  buttonCorner.CornerRadius = UDim.new(0, 8)
  buttonCorner.Parent = button
  
  button.MouseEnter:Connect(function()
    local hoverTween = TweenService:Create(button, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(60, 60, 80)})
    hoverTween:Play()
  end)
  
  button.MouseLeave:Connect(function()
    local leaveTween = TweenService:Create(button, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(40, 40, 55)})
    leaveTween:Play()
  end)
  
  button.MouseButton1Click:Connect(callback)
  
  return button
end

-- Create buttons
createButton("Start Fishing", "🎣", buttonsContainer, function()
  print("Starting fishing...")
end)

createButton("View Catches", "📊", buttonsContainer, function()
  print("Viewing catches...")
end)

createButton("Settings", "⚙️", buttonsContainer, function()
  print("Opening settings...")
end)

createButton("Exit Menu", "❌", buttonsContainer, function()
  screenGui:Destroy()
end)
```

This is Roblox Lua code for a fishing game UI menu. Here's what this code does:

**Main Features:**
- Creates a modern-looking fishing menu panel with a dark blue theme
- Title bar with a fishing emoji and custom styling
- Four interactive buttons with hover effects and smooth animations
- Rounded corners on all UI elements
- Button hover effects that brighten the background color
- Icon emojis for visual appeal

**UI Components:**
- Main panel: 350x500 pixels positioned at top-left
- Title: "🎣 FISHING MENU" with bold Gotham font
- Buttons container with automatic list layout and 10-pixel padding
- Four buttons: Start Fishing, View Catches, Settings, and Exit Menu

**Styling:**
- Dark color scheme (RGB 25, 25, 35 for main background)
- Blue accents (RGB 100, 200, 255 for borders and text)
- Smooth 0.2-second hover transitions using TweenService
- 2-pixel blue borders on main panel, 1-pixel on buttons
