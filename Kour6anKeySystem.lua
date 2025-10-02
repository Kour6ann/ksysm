-- Services
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")
local MarketplaceService = game:GetService("MarketplaceService")
local UserInputService = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService")

-- Local player & GUI parent
local player = Players.LocalPlayer
local playerGui = player and player:FindFirstChild("PlayerGui") or game:GetService("CoreGui")

-- Helper: copy to clipboard (works in exploit envs that provide setclipboard/syn)
local function copyToClipboard(text)
    if type(setclipboard) == "function" then
        pcall(setclipboard, text)
        pcall(function()
            if pcall(function() return game:GetService("StarterGui"):GetCore("SendNotification") end) then
                game:GetService("StarterGui"):SetCore("SendNotification", {
                    Title = "Copied!",
                    Text = "Link copied to clipboard.",
                    Duration = 3,
                })
            end
        end)
        return true
    end

    if syn and type(syn.set_clipboard) == "function" then
        pcall(syn.set_clipboard, text)
        pcall(function()
            if pcall(function() return game:GetService("StarterGui"):GetCore("SendNotification") end) then
                game:GetService("StarterGui"):SetCore("SendNotification", {
                    Title = "Copied!",
                    Text = "Link copied to clipboard.",
                    Duration = 3,
                })
            end
        end)
        return true
    end

    -- Fallback notify with URL (if SetCore available)
    pcall(function()
        if pcall(function() return game:GetService("StarterGui"):GetCore("SendNotification") end) then
            game:GetService("StarterGui"):SetCore("SendNotification", {
                Title = "Copy failed",
                Text = "Copy not supported here. URL: "..text,
                Duration = 6,
            })
        end
    end)
    return false
end

--// Current Game Name
local currentGameName = "Unknown Game"
pcall(function()
    currentGameName = MarketplaceService:GetProductInfo(game.PlaceId).Name
end)

--// GUI Holder
local gui = Instance.new("ScreenGui")
gui.Name = "UniversalLoader"
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
gui.DisplayOrder = 9999
gui.Parent = playerGui

--// Blur Background
local blur = Instance.new("BlurEffect")
blur.Size = 24
blur.Parent = Lighting

--// Main Loading Frame
local loadingFrame = Instance.new('Frame')
loadingFrame.Name = 'LoadingScreen'
loadingFrame.Size = UDim2.new(0, 450, 0, 280)
loadingFrame.AnchorPoint = Vector2.new(0.5, 0.5)
loadingFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
loadingFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
loadingFrame.BackgroundTransparency = 0.05
loadingFrame.BorderSizePixel = 0
loadingFrame.ClipsDescendants = true
loadingFrame.Parent = gui

-- Rounded corners
local frameCorner = Instance.new("UICorner")
frameCorner.CornerRadius = UDim.new(0, 20)
frameCorner.Parent = loadingFrame

-- White outline with glow
local frameStroke = Instance.new("UIStroke")
frameStroke.Thickness = 2
frameStroke.Color = Color3.fromRGB(255, 255, 255)
frameStroke.Transparency = 0.15
frameStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
frameStroke.Parent = loadingFrame

local strokeCorner = Instance.new("UICorner")
strokeCorner.CornerRadius = UDim.new(0, 20)
strokeCorner.Parent = frameStroke

local strokeGlow = Instance.new("UIGradient")
strokeGlow.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(200, 200, 200))
}
strokeGlow.Rotation = 45
strokeGlow.Parent = frameStroke

-- Background gradient
local gradient = Instance.new('UIGradient')
gradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(25, 25, 35)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(15, 15, 20)),
})
gradient.Rotation = 45
gradient.Parent = loadingFrame

local mainLayout = Instance.new("UIListLayout")
mainLayout.Parent = loadingFrame
mainLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
mainLayout.VerticalAlignment = Enum.VerticalAlignment.Center
mainLayout.SortOrder = Enum.SortOrder.LayoutOrder
mainLayout.Padding = UDim.new(0, 10)

--// Floating Particles
local particleFolder = Instance.new("Folder")
particleFolder.Name = "Particles"
particleFolder.Parent = loadingFrame

local function createParticle(parentFolder)
    local p = Instance.new("Frame")
    p.Size = UDim2.new(0, math.random(3,6), 0, math.random(3,6))
    p.Position = UDim2.new(math.random(), 0, math.random(), 0)
    p.AnchorPoint = Vector2.new(0.5,0.5)
    p.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    p.BackgroundTransparency = 0.5
    p.BorderSizePixel = 0
    p.ZIndex = 0
    p.Parent = parentFolder

    local pc = Instance.new("UICorner")
    pc.CornerRadius = UDim.new(1,0)
    pc.Parent = p

    -- Tween movement
    local function float()
        if not p or not p.Parent then return end
        local newPos = UDim2.new(math.random(), 0, math.random(), 0)
        local newSize = UDim2.new(0, math.random(2,7), 0, math.random(2,7))
        local tween = TweenService:Create(p, TweenInfo.new(math.random(6,12), Enum.EasingStyle.Linear, Enum.EasingDirection.InOut), {
            Position = newPos,
            Size = newSize,
            BackgroundTransparency = math.random() > 0.5 and 0.7 or 0.4
        })
        tween:Play()
        tween.Completed:Connect(float)
    end
    float()
end

for i = 1, 50 do
    createParticle(particleFolder)
end

--// TEXTS
local textGroup = Instance.new("Frame")
textGroup.Size = UDim2.new(1, 0, 0, 80)
textGroup.BackgroundTransparency = 1
textGroup.LayoutOrder = 1
textGroup.Parent = loadingFrame

local textLayout = Instance.new("UIListLayout")
textLayout.Parent = textGroup
textLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
textLayout.VerticalAlignment = Enum.VerticalAlignment.Top
textLayout.SortOrder = Enum.SortOrder.LayoutOrder
textLayout.Padding = UDim.new(0, 5)

local creditsText = Instance.new('TextLabel')
creditsText.Size = UDim2.new(0, 400, 0, 30)
creditsText.BackgroundTransparency = 1
creditsText.Text = 'Kour6an Hub'
creditsText.TextColor3 = Color3.fromRGB(255, 255, 255)
creditsText.TextSize = 28
creditsText.Font = Enum.Font.GothamBold
creditsText.TextTransparency = 1
creditsText.Parent = textGroup

local madeByText = Instance.new('TextLabel')
madeByText.Size = UDim2.new(0, 400, 0, 20)
madeByText.BackgroundTransparency = 1
madeByText.Text = 'Made By Kour6an'
madeByText.TextColor3 = Color3.fromRGB(180, 180, 190)
madeByText.TextSize = 16
madeByText.Font = Enum.Font.Gotham
madeByText.TextTransparency = 1
madeByText.Parent = textGroup

local gameNameText = Instance.new('TextLabel')
gameNameText.Size = UDim2.new(0, 400, 0, 18)
gameNameText.BackgroundTransparency = 1
gameNameText.Text = '🎮 ' .. currentGameName
gameNameText.TextColor3 = Color3.fromRGB(100, 200, 255)
gameNameText.TextSize = 14
gameNameText.Font = Enum.Font.GothamBold
gameNameText.TextTransparency = 1
gameNameText.Parent = textGroup

--// BOTTOM GROUP
local bottomGroup = Instance.new("Frame")
bottomGroup.Size = UDim2.new(1, 0, 0, 60)
bottomGroup.BackgroundTransparency = 1
bottomGroup.LayoutOrder = 2
bottomGroup.Parent = loadingFrame

local bottomLayout = Instance.new("UIListLayout")
bottomLayout.Parent = bottomGroup
bottomLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
bottomLayout.VerticalAlignment = Enum.VerticalAlignment.Top
bottomLayout.SortOrder = Enum.SortOrder.LayoutOrder
bottomLayout.Padding = UDim.new(0, 6)

local statusText = Instance.new('TextLabel')
statusText.Size = UDim2.new(0, 400, 0, 20)
statusText.BackgroundTransparency = 1
statusText.Text = 'Initializing'
statusText.TextColor3 = Color3.fromRGB(150, 150, 160)
statusText.TextSize = 14
statusText.Font = Enum.Font.Gotham
statusText.TextTransparency = 1
statusText.Parent = bottomGroup

local loadingBarContainer = Instance.new('Frame')
loadingBarContainer.Size = UDim2.new(0, 400, 0, 8)
loadingBarContainer.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
loadingBarContainer.BorderSizePixel = 0
loadingBarContainer.BackgroundTransparency = 1
loadingBarContainer.Parent = bottomGroup

local loadingBarCorner = Instance.new('UICorner')
loadingBarCorner.CornerRadius = UDim.new(0, 4)
loadingBarCorner.Parent = loadingBarContainer

local loadingBar = Instance.new('Frame')
loadingBar.Size = UDim2.new(0, 0, 1, 0)
loadingBar.BackgroundColor3 = Color3.fromRGB(100, 150, 255)
loadingBar.BorderSizePixel = 0
loadingBar.Parent = loadingBarContainer

local loadingBarFillCorner = Instance.new('UICorner')
loadingBarFillCorner.CornerRadius = UDim.new(0, 4)
loadingBarFillCorner.Parent = loadingBar

local loadingPercent = Instance.new('TextLabel')
loadingPercent.Size = UDim2.new(0, 100, 0, 20)
loadingPercent.BackgroundTransparency = 1
loadingPercent.Text = '0%'
loadingPercent.TextColor3 = Color3.fromRGB(255, 255, 255)
loadingPercent.TextSize = 14
loadingPercent.Font = Enum.Font.GothamBold
loadingPercent.TextTransparency = 1
loadingPercent.Parent = bottomGroup

--// FADE IN ANIMATION
task.delay(0.2, function()
    for _, label in pairs({creditsText, madeByText, gameNameText, statusText, loadingPercent}) do
        TweenService:Create(label, TweenInfo.new(0.8), {TextTransparency = 0}):Play()
    end
    TweenService:Create(loadingBarContainer, TweenInfo.new(0.8), {BackgroundTransparency = 0}):Play()
end)

--// DOTS ANIMATION
task.spawn(function()
    local dots = 0
    while statusText and statusText.Parent do
        dots = (dots % 3) + 1
        local baseText = statusText.Text:match("^[^.]+") or statusText.Text
        statusText.Text = baseText .. string.rep(".", dots)
        task.wait(0.5)
    end
end)

--// LOADING STEPS (used by playLoadingAnimations)
local steps = {
    {"Initializing", 5, 0.7},
    {"Loading core modules", 20, 0.8},
    {"Connecting to servers", 40, 0.9},
    {"Verifying game compatibility", 60, 0.9},
    {"Loading features", 80, 0.8},
    {"Finalizing", 100, 0.7}
}

-- Play loading animations and then create the key system
local function playLoadingAnimations()
    task.spawn(function()
        for _,step in ipairs(steps) do
            local targetPercent = step[2] / 100
            local tween = TweenService:Create(loadingBar, TweenInfo.new(step[3], Enum.EasingStyle.Quad), {Size = UDim2.new(targetPercent, 0, 1, 0)})
            tween:Play()

            statusText.Text = step[1]
            loadingPercent.Text = step[2].."%" 

            tween.Completed:Wait()
        end

        -- Fade out everything
        task.wait(0.5)
        for _,obj in pairs(loadingFrame:GetDescendants()) do
            if obj:IsA("GuiObject") then
                pcall(function()
                    TweenService:Create(obj, TweenInfo.new(0.5), {
                        BackgroundTransparency = 1, 
                        TextTransparency = 1, 
                        ImageTransparency = 1
                    }):Play()
                end)
            end
        end
        pcall(function() TweenService:Create(blur, TweenInfo.new(0.6), {Size = 0}):Play() end)

        -- After fade, destroy and launch key system
        task.wait(0.7)
        pcall(function() loadingFrame:Destroy() end)
        pcall(function() blur:Destroy() end)
        pcall(function() createKeySystem() end)
    end)
end

-- Key System with shadow + draggable
function createKeySystem()
    -- Shadow
    local shadow = Instance.new('ImageLabel')
    shadow.Name = 'Shadow'
    shadow.Image = 'rbxassetid://1316045217'
    shadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
    shadow.ImageTransparency = 0.85
    shadow.ScaleType = Enum.ScaleType.Slice
    shadow.SliceCenter = Rect.new(10, 10, 118, 118)
    shadow.Size = UDim2.new(0, 400, 0, 300)
    shadow.Position = UDim2.new(0.5, -205, 0.5, -155)
    shadow.BackgroundTransparency = 1
    shadow.ZIndex = 0
    shadow.Parent = gui

    -- Main Frame
    local frame = Instance.new('Frame')
    frame.Size = UDim2.new(0, 400, 0, 300)
    frame.Position = UDim2.new(0.5, -200, 0.5, -150)
    frame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
    frame.BackgroundTransparency = 0.1
    frame.BorderSizePixel = 0
    frame.ClipsDescendants = true
    frame.Parent = gui

    local corner = Instance.new('UICorner')
    corner.CornerRadius = UDim.new(0, 15)
    corner.Parent = frame

    local stroke = Instance.new("UIStroke")
    stroke.Thickness = 2
    stroke.Color = Color3.fromRGB(255, 255, 255)
    stroke.Transparency = 0.2
    stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    stroke.Parent = frame

    local particleFolderInner = Instance.new("Folder")
    particleFolderInner.Name = "Particles"
    particleFolderInner.Parent = frame

    local function createParticleInner(parentFolder)
        local p = Instance.new("Frame")
        p.Size = UDim2.new(0, math.random(3,6), 0, math.random(3,6))
        p.Position = UDim2.new(math.random(), 0, math.random(), 0)
        p.AnchorPoint = Vector2.new(0.5,0.5)
        p.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        p.BackgroundTransparency = 0.6
        p.BorderSizePixel = 0
        p.ZIndex = 0
        p.Parent = parentFolder

        local pc = Instance.new("UICorner")
        pc.CornerRadius = UDim.new(1,0)
        pc.Parent = p

        local function float()
            if not p or not p.Parent then return end
            local newPos = UDim2.new(math.random(), 0, math.random(), 0)
            local newSize = UDim2.new(0, math.random(2,7), 0, math.random(2,7))
            local tween = TweenService:Create(p, TweenInfo.new(math.random(6,12), Enum.EasingStyle.Linear, Enum.EasingDirection.InOut), {
                Position = newPos,
                Size = newSize,
                BackgroundTransparency = math.random() > 0.5 and 0.75 or 0.45
            })
            tween:Play()
            tween.Completed:Connect(float)
        end
        float()
    end

    for i = 1, 15 do
        createParticleInner(particleFolderInner)
    end

    local closeBtn = Instance.new('TextButton')
    closeBtn.Size = UDim2.new(0, 30, 0, 30)
    closeBtn.Position = UDim2.new(1, -35, 0, 5)
    closeBtn.Text = '×'
    closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    closeBtn.BackgroundTransparency = 1
    closeBtn.Font = Enum.Font.GothamBold
    closeBtn.TextSize = 24
    closeBtn.Parent = frame
    closeBtn.MouseButton1Click:Connect(function() pcall(function() gui:Destroy() end) end)

    local title = Instance.new('TextLabel')
    title.Size = UDim2.new(1, -40, 0, 40)
    title.Position = UDim2.new(0, 20, 0, 0)
    title.Text = 'Kour6an Hub Key System'
    title.TextColor3 = Color3.fromRGB(255, 255, 255)
    title.BackgroundTransparency = 1
    title.Font = Enum.Font.GothamBold
    title.TextSize = 18
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.Parent = frame

    local divider = Instance.new('Frame')
    divider.Size = UDim2.new(1, -40, 0, 1)
    divider.Position = UDim2.new(0, 20, 0, 40)
    divider.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
    divider.BorderSizePixel = 0
    divider.Parent = frame

    local keyBox = Instance.new('TextBox')
    keyBox.Size = UDim2.new(1, -40, 0, 40)
    keyBox.Position = UDim2.new(0, 20, 0, 60)
    keyBox.PlaceholderText = 'Paste your key here...'
    keyBox.Font = Enum.Font.Gotham
    keyBox.TextSize = 14
    keyBox.TextColor3 = Color3.fromRGB(255, 255, 255)
    keyBox.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
    keyBox.BackgroundTransparency = 0.2
    keyBox.ClearTextOnFocus = false
    keyBox.Parent = frame

    local boxCorner = Instance.new('UICorner')
    boxCorner.CornerRadius = UDim.new(0, 8)
    boxCorner.Parent = keyBox

    local boxPadding = Instance.new('UIPadding')
    boxPadding.PaddingLeft = UDim.new(0, 10)
    boxPadding.PaddingRight = UDim.new(0, 10)
    boxPadding.Parent = keyBox

    local checkBtn = Instance.new('TextButton')
    checkBtn.Size = UDim2.new(1, -40, 0, 40)
    checkBtn.Position = UDim2.new(0, 20, 0, 110)
    checkBtn.Text = 'CHECK KEY'
    checkBtn.Font = Enum.Font.GothamBold
    checkBtn.TextSize = 14
    checkBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    checkBtn.BackgroundColor3 = Color3.fromRGB(0, 120, 215)
    checkBtn.Parent = frame

    local btnCorner = Instance.new('UICorner')
    btnCorner.CornerRadius = UDim.new(0, 8)
    btnCorner.Parent = checkBtn

    checkBtn.MouseEnter:Connect(function()
        pcall(function() TweenService:Create(checkBtn, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(0, 140, 255)}):Play() end)
    end)
    checkBtn.MouseLeave:Connect(function()
        pcall(function() TweenService:Create(checkBtn, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(0, 120, 215)}):Play() end)
    end)

    local statusLabel = Instance.new('TextLabel')
    statusLabel.Size = UDim2.new(1, -40, 0, 50)
    statusLabel.Position = UDim2.new(0, 20, 0, 160)
    statusLabel.BackgroundTransparency = 1
    statusLabel.Text = 'Status: Waiting for key...'
    statusLabel.Font = Enum.Font.Gotham
    statusLabel.TextSize = 14
    statusLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
    statusLabel.TextWrapped = true
    statusLabel.TextXAlignment = Enum.TextXAlignment.Left
    statusLabel.Parent = frame

    local buttonContainer = Instance.new('Frame')
    buttonContainer.Size = UDim2.new(1, -40, 0, 40)
    buttonContainer.Position = UDim2.new(0, 20, 1, -50)
    buttonContainer.BackgroundTransparency = 1
    buttonContainer.Parent = frame

    local getKeyBtn = Instance.new('TextButton')
    getKeyBtn.Size = UDim2.new(0.48, 0, 1, 0)
    getKeyBtn.Text = '🔑 GET KEY'
    getKeyBtn.Font = Enum.Font.GothamBold
    getKeyBtn.TextSize = 14
    getKeyBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    getKeyBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 100)
    getKeyBtn.Parent = buttonContainer

    local getKeyCorner = Instance.new('UICorner')
    getKeyCorner.CornerRadius = UDim.new(0, 8)
    getKeyCorner.Parent = getKeyBtn

    local discordBtn = Instance.new('TextButton')
    discordBtn.Size = UDim2.new(0.48, 0, 1, 0)
    discordBtn.Position = UDim2.new(0.52, 0, 0, 0)
    discordBtn.Text = '💬 DISCORD'
    discordBtn.Font = Enum.Font.GothamBold
    discordBtn.TextSize = 14
    discordBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    discordBtn.BackgroundColor3 = Color3.fromRGB(88, 101, 161)
    discordBtn.Parent = buttonContainer

    local discordCorner = Instance.new('UICorner')
    discordCorner.CornerRadius = UDim.new(0, 8)
    discordCorner.Parent = discordBtn

    getKeyBtn.MouseEnter:Connect(function()
        pcall(function() TweenService:Create(getKeyBtn, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(0, 170, 120)}):Play() end)
    end)
    getKeyBtn.MouseLeave:Connect(function()
        pcall(function() TweenService:Create(getKeyBtn, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(0, 150, 100)}):Play() end)
    end)
    discordBtn.MouseEnter:Connect(function()
        pcall(function() TweenService:Create(discordBtn, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(114, 137, 218)}):Play() end)
    end)
    discordBtn.MouseLeave:Connect(function()
        pcall(function() TweenService:Create(discordBtn, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(88, 101, 161)}):Play() end)
    end)

    getKeyBtn.MouseButton1Click:Connect(function()
        getKeyBtn.Text = 'GENERATING KEY...'
        task.wait(0.5)
        local link = 'https://work.ink/258d/kour6ancheckpoint1'
        local ok = copyToClipboard(link)
        if ok then
            statusLabel.Text = '✅ Key link copied to clipboard! Paste it in your browser.'
        else
            statusLabel.Text = '🔗 Copy not supported here. URL: '..link
        end
        task.wait(1.5)
        getKeyBtn.Text = '🔑 GET KEY'
    end)

    discordBtn.MouseButton1Click:Connect(function()
        local link = 'https://discord.gg/zjN89ZzkxV'
        local ok = copyToClipboard(link)
        if ok then
            statusLabel.Text = '✅ Discord invite link copied to clipboard!'
        else
            statusLabel.Text = '🔗 Copy not supported here. URL: '..link
        end
    end)

    checkBtn.MouseButton1Click:Connect(function()
        local userKey = keyBox.Text and keyBox.Text:match("%S+") or ""
        if not userKey or #userKey < 10 then
            statusLabel.Text = "❌ Please enter a valid key."
            return
        end
        statusLabel.Text = "🔍 Checking key validity..."
        task.spawn(function()
            local success, response = pcall(function()
                return game:HttpGet("https://work.ink/_api/v2/token/isValid/" .. userKey .. "?forbiddenOnFail=1")
            end)
            if not success or not response or response == "" then
                statusLabel.Text = "⚠️ Error checking key. Please try again."
                return
            end
            local ok, data = pcall(function() return HttpService:JSONDecode(response) end)
            if not ok or not data then
                statusLabel.Text = "❗ Invalid response from server."
                return
            end
            if data.valid then
                local expiresAt = data.info and data.info.expiresAfter and data.info.expiresAfter / 1000 or nil
                if expiresAt then
                    local timeLeft = expiresAt - os.time()
                    if timeLeft < 0 then
                        statusLabel.Text = "❌ Key already expired."
                        return
                    end
                    local hoursLeft = math.floor(timeLeft / 3600)
                    local minutesLeft = math.floor((timeLeft % 3600) / 60)
                    statusLabel.Text = string.format("✅ Valid key! Time remaining: %dh %dm", hoursLeft, minutesLeft)
                else
                    statusLabel.Text = "✅ Valid key!"
                end

                task.wait(1)
                pcall(function()
                    loadstring(game:HttpGet("https://gist.githubusercontent.com/Kour6ann/5cb71a9164a7673b542a52bbfa94e91d/raw/9d19992fe2142dfa49edbb6c3c71d0dc99e5208b/loader.lua"))()
                end)
                pcall(function() gui:Destroy() end)
            else
                statusLabel.Text = "❌ Invalid or expired key. Please generate a new one."
            end
        end)
    end)

    -- Dragging
    local dragging, dragInput, dragStart, startPos
    local function update(input)
        local delta = input.Position - dragStart
        if startPos then
            frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
            shadow.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X - 5, startPos.Y.Scale, startPos.Y.Offset + delta.Y - 5)
        end
    end
    frame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = frame.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then dragging = false end
            end)
        end
    end)
    frame.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then dragInput = input end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then update(input) end
    end)
end

-- Start loading
playLoadingAnimations()
