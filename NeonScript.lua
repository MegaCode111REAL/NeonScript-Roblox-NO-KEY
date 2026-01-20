-- neon_admin_no_matrix.lua
-- Client-side admin panel (Neon hacker theme, smooth glass aesthetic)
-- Intended to be executed on the client via:    
-- loadstring(game:HttpGet("https://github.com/MegaCode111REAL/NeonScript-Roblox-NO-KEY/blob/main/NeonScript.lua"))()

local Players = game:GetService("Players")
local RunService = game: GetService("RunService")
local UIS = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local lp = Players. LocalPlayer
if not lp then return end

-- Prevent multiple instances
if lp: FindFirstChild("NeonAdminLoaded") then return end
local marker = Instance.new("BoolValue")
marker.Name = "NeonAdminLoaded"
marker.Parent = lp

-- Smooth tween helper
local function smoothTween(obj, props, duration)
    duration = duration or 0.3
    local tweenInfo = TweenInfo. new(
        duration,
        Enum. EasingStyle.Quad,
        Enum.EasingDirection.InOut
    )
    local tween = TweenService: Create(obj, tweenInfo, props)
    tween:Play()
    return tween
end

-- Popup factory with smooth animations
local function makePopup(parent)
    local gui = Instance.new("ScreenGui")
    gui.Name = "NeonAdminPopups"
    gui.ResetOnSpawn = false
    gui.Parent = parent

    local function show(text, success)
        local frame = Instance.new("Frame", gui)
        frame.Size = UDim2.new(0, 320, 0, 60)
        frame.Position = UDim2.new(1, -330, 1, -80)
        frame.BackgroundColor3 = success and Color3.fromRGB(0, 255, 120) or Color3.fromRGB(255, 80, 80)
        frame.BackgroundTransparency = 0.15
        frame.BorderSizePixel = 0
        frame.ZIndex = 100

        local corner = Instance.new("UICorner", frame)
        corner.CornerRadius = UDim.new(0, 12)

        local stroke = Instance.new("UIStroke", frame)
        stroke.Color = success and Color3.fromRGB(0, 255, 120) or Color3.fromRGB(255, 80, 80)
        stroke. Thickness = 1. 5

        local label = Instance.new("TextLabel", frame)
        label.Size = UDim2.new(1, -20, 1, -20)
        label.Position = UDim2.new(0, 10, 0, 10)
        label.BackgroundTransparency = 1
        label. Text = text
        label.TextColor3 = Color3.new(1, 1, 1)
        label.Font = Enum.Font.GothamBold
        label. TextScaled = true
        label.ZIndex = 101

        -- Smooth entrance animation
        frame.Size = UDim2.new(0, 0, 0, 60)
        smoothTween(frame, {Size = UDim2.new(0, 320, 0, 60)}, 0.4)

        task.spawn(function()
            task.wait(3. 5)
            if frame and frame.Parent then
                smoothTween(frame, {BackgroundTransparency = 1, TextTransparency = 1}, 0.3)
                task.wait(0.3)
                frame: Destroy()
            end
        end)
    end

    return show, gui
end

local popup, popupGui = makePopup(lp: WaitForChild("PlayerGui"))

-- Draggable helper with smooth movement
local function makeDraggable(frame, handle)
    handle = handle or frame
    local dragging, dragStart, startPos = false, nil, nil

    local function onInputBegan(input)
        if input.UserInputType == Enum.UserInputType. MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = frame.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState. End then dragging = false end
            end)
        end
    end

    handle.InputBegan:Connect(onInputBegan)

    UIS.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType. MouseMovement then
            local delta = input.Position - dragStart
            frame.Position = UDim2.new(
                startPos.X. Scale,
                startPos.X. Offset + delta.X,
                startPos.Y.Scale,
                startPos.Y.Offset + delta.Y
            )
        end
    end)
end

-- Main GUI with smooth glass effect
local gui = Instance.new("ScreenGui")
gui.Name = "NeonAdminGui"
gui. ResetOnSpawn = false
gui.Parent = lp:WaitForChild("PlayerGui")

-- Panel with glassy effect
local panel = Instance. new("Frame")
panel.Name = "Panel"
panel.Size = UDim2.new(0, 450, 0, 500)
panel.Position = UDim2.new(0, 80, 0, 80)
panel.BackgroundColor3 = Color3.fromRGB(10, 10, 20)
panel.BackgroundTransparency = 0.1
panel.BorderSizePixel = 0
panel.ClipsDescendants = true
panel.ZIndex = 10
panel.Parent = gui

local stroke = Instance.new("UIStroke", panel)
stroke.Color = Color3.fromRGB(0, 255, 120)
stroke.Thickness = 2

local corner = Instance.new("UICorner", panel)
corner.CornerRadius = UDim.new(0, 16)

-- Glow effect for panel
local glow = Instance.new("UIStroke", panel)
glow.Color = Color3.fromRGB(0, 255, 120)
glow.Thickness = 0.5
glow. Transparency = 0.5

makeDraggable(panel)

-- Title bar with gradient feel
local titleBar = Instance.new("Frame", panel)
titleBar.Size = UDim2.new(1, 0, 0, 50)
titleBar.Position = UDim2.new(0, 0, 0, 0)
titleBar.BackgroundColor3 = Color3.fromRGB(0, 20, 40)
titleBar.BackgroundTransparency = 0.3
titleBar.BorderSizePixel = 0
titleBar. ZIndex = 11

local titleCorner = Instance.new("UICorner", titleBar)
titleCorner.CornerRadius = UDim.new(0, 16)

local title = Instance.new("TextLabel", titleBar)
title.Size = UDim2.new(1, -120, 1, 0)
title.Position = UDim2.new(0, 12, 0, 0)
title.BackgroundTransparency = 1
title.Text = "◇ NEON ADMIN ◇"
title.TextColor3 = Color3.fromRGB(0, 255, 120)
title.Font = Enum.Font.GothamBold
title.TextScaled = true
title.TextXAlignment = Enum.TextXAlignment.Left
title.ZIndex = 12

-- Min/Close buttons with smooth hover effects
local function createTopButton(text, posX, color)
    local btn = Instance.new("TextButton", titleBar)
    btn.Size = UDim2.new(0, 40, 0, 30)
    btn.Position = UDim2.new(1, posX, 0, 10)
    btn.BackgroundColor3 = Color3.fromRGB(20, 20, 35)
    btn.BackgroundTransparency = 0.3
    btn.Text = text
    btn.TextColor3 = color
    btn. Font = Enum.Font.GothamBold
    btn. TextScaled = true
    btn.ZIndex = 12
    
    local c = Instance.new("UICorner", btn)
    c.CornerRadius = UDim.new(0, 8)
    
    local s = Instance.new("UIStroke", btn)
    s.Color = color
    s.Thickness = 1

    -- Smooth hover effect
    btn.MouseEnter:Connect(function()
        smoothTween(btn, {BackgroundTransparency = 0.1}, 0.2)
    end)

    btn.MouseLeave:Connect(function()
        smoothTween(btn, {BackgroundTransparency = 0.3}, 0.2)
    end)

    return btn
end

local btnMin = createTopButton("-", -95, Color3.fromRGB(0, 200, 255))
local btnClose = createTopButton("X", -45, Color3.fromRGB(255, 100, 100))

-- Minimized orb with smooth animations
local orb = Instance.new("Frame", gui)
orb.Name = "MiniOrb"
orb. Size = UDim2.new(0, 50, 0, 50)
orb.Position = UDim2.new(0, 80, 0, 80)
orb.BackgroundColor3 = Color3.fromRGB(0, 255, 120)
orb.BackgroundTransparency = 0.1
orb.BorderSizePixel = 0
orb. Visible = false
orb.ZIndex = 50

local orbCorner = Instance.new("UICorner", orb)
orbCorner.CornerRadius = UDim.new(1, 0)

local orbStroke = Instance.new("UIStroke", orb)
orbStroke.Color = Color3.fromRGB(0, 255, 120)
orbStroke.Thickness = 2

local orbLabel = Instance.new("TextLabel", orb)
orbLabel.Size = UDim2.new(1, 0, 1, 0)
orbLabel.BackgroundTransparency = 1
orbLabel.Text = "◆"
orbLabel.Font = Enum.Font.GothamBold
orbLabel.TextColor3 = Color3.fromRGB(0, 0, 0)
orbLabel.TextScaled = true
orbLabel.ZIndex = 51

makeDraggable(orb)

-- Smooth minimize/restore with hover effects
btnMin.MouseButton1Click:Connect(function()
    smoothTween(panel, {Size = UDim2.new(0, 0, 0, 500)}, 0.3)
    task.wait(0.15)
    panel. Visible = false
    orb.Visible = true
    smoothTween(orb, {Size = UDim2.new(0, 60, 0, 60)}, 0.3)
end)

orb.MouseEnter:Connect(function()
    if orb.Visible then
        smoothTween(orb, {Size = UDim2.new(0, 70, 0, 70)}, 0.2)
    end
end)

orb.MouseLeave:Connect(function()
    if orb.Visible then
        smoothTween(orb, {Size = UDim2.new(0, 60, 0, 60)}, 0.2)
    end
end)

orb.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        smoothTween(orb, {Size = UDim2.new(0, 0, 0, 60)}, 0.3)
        task.wait(0.15)
        orb.Visible = false
        panel.Visible = true
        smoothTween(panel, {Size = UDim2.new(0, 450, 0, 500)}, 0.3)
    end
end)

-- Close behavior:  cleanup everything created by this script
local function cleanup()
    -- restore frozen players
    for p, stats in pairs(_G._neon_savedStats or {}) do
        if p and p.Character then
            local hum = p.Character:FindFirstChildOfClass("Humanoid")
            if hum then
                hum. WalkSpeed = stats.walk or 16
                hum.JumpPower = stats.jump or 50
            end
        end
    end
    -- stop invincibility loops
    _G._neon_invincible = nil
    _G._neon_freeze = nil
    -- destroy GUIs and marker
    if gui and gui.Parent then gui: Destroy() end
    if popupGui and popupGui.Parent then popupGui:Destroy() end
    if marker and marker.Parent then marker:Destroy() end
    -- clear globals
    _G._neon_savedStats = nil
    _G._neon_invincible = nil
    _G._neon_freeze = nil
end

btnClose.MouseButton1Click:Connect(function()
    cleanup()
end)

-- Foreground content container
local content = Instance.new("Frame", panel)
content.Size = UDim2.new(1, -20, 1, -90)
content.Position = UDim2.new(0, 10, 0, 60)
content.BackgroundTransparency = 1
content.ZIndex = 20

-- Target label and input with smooth styling
local lblTarget = Instance.new("TextLabel", content)
lblTarget.Size = UDim2.new(0, 80, 0, 32)
lblTarget.Position = UDim2.new(0, 0, 0, 8)
lblTarget.BackgroundTransparency = 1
lblTarget.Text = "TARGET:"
lblTarget.TextColor3 = Color3.fromRGB(0, 255, 120)
lblTarget.Font = Enum.Font.GothamBold
lblTarget.TextScaled = true
lblTarget.ZIndex = 21

local txtTarget = Instance.new("TextBox", content)
txtTarget.Size = UDim2.new(0, 320, 0, 32)
txtTarget.Position = UDim2.new(0, 90, 0, 8)
txtTarget.BackgroundColor3 = Color3.fromRGB(10, 10, 25)
txtTarget.BackgroundTransparency = 0.2
txtTarget.Text = "me / all / others / name"
txtTarget.TextColor3 = Color3.fromRGB(0, 255, 120)
txtTarget.PlaceholderColor3 = Color3.fromRGB(0, 200, 100)
txtTarget.Font = Enum.Font.GothamBold
txtTarget.TextScaled = true
txtTarget. ClearTextOnFocus = true
txtTarget.ZIndex = 21

local txtCorner = Instance.new("UICorner", txtTarget)
txtCorner.CornerRadius = UDim. new(0, 8)

local txtStroke = Instance.new("UIStroke", txtTarget)
txtStroke.Color = Color3.fromRGB(0, 255, 120)
txtStroke.Thickness = 1
txtStroke. Transparency = 0.5

-- Smooth textbox focus effects
txtTarget. Focused:Connect(function()
    smoothTween(txtStroke, {Transparency = 0}, 0.2)
    smoothTween(txtTarget, {BackgroundTransparency = 0.05}, 0.2)
end)

txtTarget.FocusLost:Connect(function()
    smoothTween(txtStroke, {Transparency = 0.5}, 0.2)
    smoothTween(txtTarget, {BackgroundTransparency = 0.2}, 0.2)
end)

-- Enhanced button factory with smooth animations
local function makeButton(text, posX, posY, parent, callback)
    local btn = Instance. new("TextButton", parent)
    btn.Size = UDim2.new(0, 130, 0, 40)
    btn.Position = UDim2.new(0, posX, 0, posY)
    btn.BackgroundColor3 = Color3.fromRGB(10, 30, 50)
    btn.BackgroundTransparency = 0.2
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(0, 255, 120)
    btn.Font = Enum.Font.GothamBold
    btn.TextScaled = true
    btn. ZIndex = 21

    local c = Instance.new("UICorner", btn)
    c.CornerRadius = UDim.new(0, 10)

    local s = Instance. new("UIStroke", btn)
    s.Color = Color3.fromRGB(0, 255, 120)
    s.Thickness = 1.5
    s.Transparency = 0.3

    -- Smooth hover and press effects
    btn.MouseEnter:Connect(function()
        smoothTween(btn, {BackgroundTransparency = 0.05}, 0.2)
        smoothTween(s, {Transparency = 0}, 0.2)
    end)

    btn.MouseLeave:Connect(function()
        smoothTween(btn, {BackgroundTransparency = 0.2}, 0.2)
        smoothTween(s, {Transparency = 0.3}, 0.2)
    end)

    btn.MouseButton1Down:Connect(function()
        smoothTween(btn, {Size = UDim2.new(0, 124, 0, 36)}, 0.1)
    end)

    btn.MouseButton1Up:Connect(function()
        smoothTween(btn, {Size = UDim2.new(0, 130, 0, 40)}, 0.1)
    end)

    btn.MouseButton1Click:Connect(function()
        pcall(callback)
    end)

    return btn
end

-- Command implementations

-- Kill - IMPROVED VERSION
local function cmdKill(targetStr)
    local targets = getTargets(targetStr)
    if #targets == 0 then
        popup("No valid targets", false)
        return
    end
    for _, p in ipairs(targets) do
        local char = p.Character
        if char then
            local hum = char:FindFirstChildOfClass("Humanoid")
            if hum then
                hum.Health = 1
                task.wait(0.5)
                hum.Health = -2
            end
        end
    end
    popup("Killed " .. #targets .. " target(s)", true)
end

-- Invincible - NOW WORKS ON ALL TARGET OPTIONS
_G._neon_invincible = _G._neon_invincible or {}
local function cmdInvincible(targetStr)
    local targets = getTargets(targetStr)
    if #targets == 0 then
        popup("No valid targets", false)
        return
    end
    for _, p in ipairs(targets) do
        local char = p.Character
        if char then
            local hum = char:FindFirstChildOfClass("Humanoid")
            if hum then
                if not _G._neon_invincible[p] then
                    _G._neon_invincible[p] = true
                    hum.MaxHealth = math.huge
                    hum. Health = hum.MaxHealth

                    if char:FindFirstChild("InvincibilityLoop") then
                        char: FindFirstChild("InvincibilityLoop"):Destroy()
                    end

                    local marker = Instance.new("BoolValue")
                    marker.Name = "InvincibilityLoop"
                    marker.Parent = char

                    task.spawn(function()
                        while hum and hum.Parent and _G._neon_invincible[p] and marker and marker.Parent do
                            hum.Health = hum.MaxHealth
                            task.wait(0.12)
                        end
                    end)
                else
                    _G._neon_invincible[p] = nil
                    if char:FindFirstChild("InvincibilityLoop") then
                        char:FindFirstChild("InvincibilityLoop"):Destroy()
                    end
                end
            end
        end
    end
    popup("Toggled invincibility for " .. #targets .. " target(s)", true)
end

-- TP Tool - NOW WORKS ON ALL TARGET OPTIONS
local function giveTpTool(targetStr)
    local targets = getTargets(targetStr)
    if #targets == 0 then
        popup("No valid targets", false)
        return
    end

    for _, p in ipairs(targets) do
        if not p.Backpack then
            p:LoadCharacter()
            task.wait(0.2)
        end

        local existing = p.Backpack:FindFirstChild("TP Tool") or (p.Character and p.Character:FindFirstChild("TP Tool"))
        if not existing then
            local tool = Instance.new("Tool")
            tool.Name = "TP Tool"
            tool.RequiresHandle = false
            tool.Parent = p. Backpack

            tool.Activated:Connect(function()
                local mouse = p: GetMouse()
                if mouse and mouse.Hit then
                    local hrp = p.Character and p.Character:FindFirstChild("HumanoidRootPart")
                    if hrp then
                        hrp.CFrame = mouse.Hit + Vector3.new(0, 3, 0)
                    end
                end
            end)
        end
    end
    popup("TP Tool given to " .. #targets .. " target(s)", true)
end

-- Bring
local function cmdBring(targetStr)
    local targets = getTargets(targetStr)
    if #targets == 0 then
        popup("No valid targets", false)
        return
    end
    local myHRP = lp. Character and lp.Character:FindFirstChild("HumanoidRootPart")
    if not myHRP then
        popup("No HRP found for you", false)
        return
    end

    for _, p in ipairs(targets) do
        if p ~= lp and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
            local thrp = p.Character. HumanoidRootPart
            local hum = p.Character:FindFirstChildOfClass("Humanoid")

            local forward = myHRP.CFrame. LookVector
            local targetPos = myHRP.Position + forward * 4 + Vector3.new(0, 1, 0)

            thrp.CFrame = CFrame.new(targetPos, myHRP.Position)

            if hum then
                task.spawn(function()
                    for i = 1, 10 do
                        if thrp and thrp.Parent then
                            if thrp: FindFirstChild("BodyVelocity") then
                                thrp:FindFirstChild("BodyVelocity"):Destroy()
                            end
                            local bv = Instance.new("BodyVelocity")
                            bv. Velocity = Vector3.new(0, 0, 0)
                            bv.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
                            bv.Parent = thrp
                            task.wait(0.1)
                        end
                    end
                    if thrp and thrp: FindFirstChild("BodyVelocity") then
                        thrp:FindFirstChild("BodyVelocity"):Destroy()
                    end
                end)
            end
        end
    end
    popup("Brought " .. #targets .. " target(s) in front of you", true)
end

-- TPTo
local function cmdTpTo(targetStr)
    local targets = getTargets(targetStr)
    if #targets == 0 then
        popup("No valid targets", false)
        return
    end
    local first = targets[1]
    if not first.Character or not first.Character:FindFirstChild("HumanoidRootPart") then
        popup("Target has no HRP", false)
        return
    end
    local thrp = first.Character.HumanoidRootPart
    local back = -thrp.CFrame.LookVector
    local myHRP = lp.Character and lp.Character:FindFirstChild("HumanoidRootPart")
    if not myHRP then
        popup("No HRP for you", false)
        return
    end
    myHRP.CFrame = thrp.CFrame + back * 4 + Vector3.new(0, 1, 0)
    popup("Teleported to " .. first.Name, true)
end

-- Freeze
_G._neon_freeze = _G._neon_freeze or {}
_G._neon_savedStats = _G._neon_savedStats or {}
local function cmdFreeze(targetStr)
    local targets = getTargets(targetStr)
    if #targets == 0 then
        popup("No valid targets", false)
        return
    end
    for _, p in ipairs(targets) do
        local char = p.Character
        if char then
            local hum = char:FindFirstChildOfClass("Humanoid")
            if hum then
                if not _G._neon_freeze[p] then
                    _G._neon_savedStats[p] = {walk = hum.WalkSpeed, jump = hum.JumpPower}
                    hum. WalkSpeed = 0
                    hum.JumpPower = 0
                    _G._neon_freeze[p] = true

                    if char:FindFirstChild("HumanoidRootPart") then
                        local hrp = char: FindFirstChild("HumanoidRootPart")
                        if hrp: FindFirstChild("FreezeVelocity") then
                            hrp: FindFirstChild("FreezeVelocity"):Destroy()
                        end
                        local bv = Instance.new("BodyVelocity")
                        bv.Name = "FreezeVelocity"
                        bv. Velocity = Vector3.new(0, 0, 0)
                        bv.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
                        bv.Parent = hrp
                    end
                else
                    local s = _G._neon_savedStats[p]
                    hum.WalkSpeed = (s and s.walk) or 16
                    hum.JumpPower = (s and s.jump) or 50
                    _G._neon_freeze[p] = nil
                    _G._neon_savedStats[p] = nil

                    if char:FindFirstChild("HumanoidRootPart") then
                        local hrp = char:FindFirstChild("HumanoidRootPart")
                        if hrp: FindFirstChild("FreezeVelocity") then
                            hrp:FindFirstChild("FreezeVelocity"):Destroy()
                        end
                    end
                end
            end
        end
    end
    popup("Toggled freeze for " .. #targets ..  " target(s)", true)
end

-- Target parsing (me, all, others, partial name)
local function getTargets(str)
    str = (str or ""):lower():gsub("^%s+", ""):gsub("%s+$", "")
    local list = {}
    if str == "" or str == "me" then
        table.insert(list, lp)
        return list
    end
    if str == "all" then
        for _, p in ipairs(Players:GetPlayers()) do
            table.insert(list, p)
        end
        return list
    end
    if str == "others" then
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= lp then
                table. insert(list, p)
            end
        end
        return list
    end
    -- partial name match
    for _, p in ipairs(Players:GetPlayers()) do
        if p.Name:lower():sub(1, #str) == str then
            table. insert(list, p)
            break
        end
    end
    return list
end

-- Create buttons in a grid layout
makeButton("KILL", 0, 50, content, function() cmdKill(txtTarget.Text) end)
makeButton("INVINCIBLE", 140, 50, content, function() cmdInvincible(txtTarget.Text) end)
makeButton("TP TOOL", 280, 50, content, function() giveTpTool(txtTarget. Text) end)

makeButton("BRING", 0, 100, content, function() cmdBring(txtTarget.Text) end)
makeButton("TPTO", 140, 100, content, function() cmdTpTo(txtTarget.Text) end)
makeButton("FREEZE", 280, 100, content, function() cmdFreeze(txtTarget.Text) end)

-- Quick player list with smooth styling
local listFrame = Instance.new("ScrollingFrame", content)
listFrame.Size = UDim2.new(1, 0, 0, 280)
listFrame.Position = UDim2.new(0, 0, 0, 160)
listFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 25)
listFrame.BackgroundTransparency = 0.2
listFrame.BorderSizePixel = 0
listFrame. CanvasSize = UDim2.new(0, 0, 0, 0)
listFrame.ScrollBarThickness = 8
listFrame.ScrollBarImageColor3 = Color3.fromRGB(0, 255, 120)
listFrame.ZIndex = 21

local listCorner = Instance.new("UICorner", listFrame)
listCorner.CornerRadius = UDim.new(0, 12)

local listStroke = Instance.new("UIStroke", listFrame)
listStroke.Color = Color3.fromRGB(0, 255, 120)
listStroke.Thickness = 1
listStroke.Transparency = 0.5

local uiList = Instance.new("UIListLayout", listFrame)
uiList.Padding = UDim. new(0, 6)
uiList.FillDirection = Enum.FillDirection.Vertical
uiList.SortOrder = Enum.SortOrder. LayoutOrder

local function refreshPlayerList()
    listFrame:ClearAllChildren()
    uiList. Parent = listFrame
    for i, p in ipairs(Players:GetPlayers()) do
        local btn = Instance.new("TextButton", listFrame)
        btn.Size = UDim2.new(1, -12, 0, 32)
        btn.Position = UDim2.new(0, 6, 0, 0)
        btn.BackgroundColor3 = Color3.fromRGB(10, 20, 40)
        btn.BackgroundTransparency = 0.3
        btn.Text = "▸ " .. p.Name
        btn.TextColor3 = Color3.fromRGB(0, 255, 120)
        btn.Font = Enum.Font. GothamBold
        btn.TextScaled = true
        btn.ZIndex = 21

        local c = Instance.new("UICorner", btn)
        c.CornerRadius = UDim.new(0, 8)

        local s = Instance.new("UIStroke", btn)
        s.Color = Color3.fromRGB(0, 255, 120)
        s.Thickness = 1
        s.Transparency = 0.5

        -- Smooth hover effect
        btn.MouseEnter:Connect(function()
            smoothTween(btn, {BackgroundTransparency = 0.1}, 0.2)
            smoothTween(s, {Transparency = 0}, 0.2)
        end)

        btn.MouseLeave:Connect(function()
            smoothTween(btn, {BackgroundTransparency = 0.3}, 0.2)
            smoothTween(s, {Transparency = 0.5}, 0.2)
        end)

        btn.MouseButton1Click:Connect(function()
            txtTarget.Text = p.Name
        end)
    end
    local count = #Players:GetPlayers()
    listFrame. CanvasSize = UDim2.new(0, 0, 0, count * 38)
end

Players.PlayerAdded:Connect(refreshPlayerList)
Players.PlayerRemoving:Connect(refreshPlayerList)
refreshPlayerList()

-- Chat commands
local function runChatCommand(msg)
    local args = {}
    for w in msg:gmatch("%S+") do
        table.insert(args, w)
    end
    local cmd = args[1] and args[1]: lower()
    if cmd == "/kill" then
        cmdKill(args[2] or "me")
    elseif cmd == "/invincible" then
        cmdInvincible(args[2] or "me")
    elseif cmd == "/tptool" then
        giveTpTool(args[2] or "me")
    elseif cmd == "/bring" then
        cmdBring(args[2] or "me")
    elseif cmd == "/tpto" then
        cmdTpTo(args[2] or "me")
    elseif cmd == "/freeze" then
        cmdFreeze(args[2] or "me")
    end
end

lp.Chatted:Connect(runChatCommand)

-- Final ready popup
popup("◇ NEON ADMIN INITIALIZED ◇", true)

-- Ensure cleanup if player leaves or script is re-run
lp.AncestryChanged:Connect(function()
    if not lp: IsDescendantOf(game) then
        cleanup()
    end
end)
