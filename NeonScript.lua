-- X neon-admin.lua X
-- Client-side "admin panel" (Neon Matrix theme)
-- Intended to be executed on the client (LocalPlayer) via loadstring(game:HttpGet("RAW_URL"))()

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local lp = Players.LocalPlayer

if not lp then return end

-- Prevent multiple instances
if lp:FindFirstChild("NeonAdminLoaded") then
    return
end
local marker = Instance.new("BoolValue")
marker.Name = "NeonAdminLoaded"
marker.Parent = lp

-- Utility: popup
local function makePopup(parent)
    local gui = Instance.new("ScreenGui")
    gui.Name = "NeonAdminPopups"
    gui.ResetOnSpawn = false
    gui.Parent = parent

    local function show(text, success)
        local frame = Instance.new("Frame", gui)
        frame.Size = UDim2.new(0, 300, 0, 50)
        frame.Position = UDim2.new(1, -310, 1, -70)
        frame.BackgroundColor3 = success and Color3.fromRGB(0,200,0) or Color3.fromRGB(200,0,0)
        frame.BackgroundTransparency = 0.12
        frame.BorderSizePixel = 0
        frame.ZIndex = 100

        local label = Instance.new("TextLabel", frame)
        label.Size = UDim2.new(1, -10, 1, -10)
        label.Position = UDim2.new(0, 5, 0, 5)
        label.BackgroundTransparency = 1
        label.Text = text
        label.TextColor3 = Color3.new(0,0,0)
        label.Font = Enum.Font.Code
        label.TextScaled = true
        label.ZIndex = 101

        task.spawn(function()
            task.wait(3)
            if frame and frame.Parent then
                frame:Destroy()
            end
        end)
    end

    return show
end

local popup = makePopup(lp:WaitForChild("PlayerGui"))

-- Draggable helper
local function makeDraggable(frame, handle)
    handle = handle or frame
    local dragging, dragStart, startPos = false, nil, nil

    handle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = frame.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)

    UIS.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - dragStart
            frame.Position = UDim2.new(
                startPos.X.Scale,
                startPos.X.Offset + delta.X,
                startPos.Y.Scale,
                startPos.Y.Offset + delta.Y
            )
        end
    end)
end

-- Main GUI
local gui = Instance.new("ScreenGui")
gui.Name = "NeonAdminGui"
gui.ResetOnSpawn = false
gui.Parent = lp:WaitForChild("PlayerGui")

-- Panel
local panel = Instance.new("Frame")
panel.Name = "Panel"
panel.Size = UDim2.new(0, 420, 0, 320)
panel.Position = UDim2.new(0, 80, 0, 80)
panel.BackgroundColor3 = Color3.fromRGB(6,6,6)
panel.BorderSizePixel = 0
panel.ClipsDescendants = true
panel.ZIndex = 10
panel.Parent = gui

local stroke = Instance.new("UIStroke", panel)
stroke.Color = Color3.fromRGB(0,255,120)
stroke.Thickness = 2

local corner = Instance.new("UICorner", panel)
corner.CornerRadius = UDim.new(0, 8)

makeDraggable(panel)

-- Title bar
local titleBar = Instance.new("Frame", panel)
titleBar.Size = UDim2.new(1, 0, 0, 34)
titleBar.Position = UDim2.new(0, 0, 0, 0)
titleBar.BackgroundColor3 = Color3.fromRGB(10,10,10)
titleBar.BorderSizePixel = 0
titleBar.ZIndex = 11

local title = Instance.new("TextLabel", titleBar)
title.Size = UDim2.new(1, -80, 1, 0)
title.Position = UDim2.new(0, 12, 0, 0)
title.BackgroundTransparency = 1
title.Text = "NEON MATRIX ADMIN"
title.TextColor3 = Color3.fromRGB(0,255,120)
title.Font = Enum.Font.Code
title.TextScaled = true
title.TextXAlignment = Enum.TextXAlignment.Left
title.ZIndex = 12

local btnMin = Instance.new("TextButton", titleBar)
btnMin.Size = UDim2.new(0, 36, 0, 26)
btnMin.Position = UDim2.new(1, -44, 0, 4)
btnMin.BackgroundColor3 = Color3.fromRGB(12,12,12)
btnMin.Text = "-"
btnMin.TextColor3 = Color3.fromRGB(0,255,120)
btnMin.Font = Enum.Font.Code
btnMin.TextScaled = true
btnMin.ZIndex = 12
local btnMinCorner = Instance.new("UICorner", btnMin)
btnMinCorner.CornerRadius = UDim.new(0,4)

-- Minimized orb
local orb = Instance.new("Frame", gui)
orb.Name = "MiniOrb"
orb.Size = UDim2.new(0, 44, 0, 44)
orb.Position = UDim2.new(0, 80, 0, 80)
orb.BackgroundColor3 = Color3.fromRGB(0,255,120)
orb.BorderSizePixel = 0
orb.Visible = false
orb.ZIndex = 50
local orbCorner = Instance.new("UICorner", orb)
orbCorner.CornerRadius = UDim.new(1,0)
local orbLabel = Instance.new("TextLabel", orb)
orbLabel.Size = UDim2.new(1,1,1,1)
orbLabel.BackgroundTransparency = 1
orbLabel.Text = "A"
orbLabel.Font = Enum.Font.Code
orbLabel.TextColor3 = Color3.fromRGB(0,0,0)
orbLabel.TextScaled = true
orbLabel.ZIndex = 51

makeDraggable(orb)

btnMin.MouseButton1Click:Connect(function()
    panel.Visible = false
    orb.Visible = true
end)

orb.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        panel.Visible = true
        orb.Visible = false
    end
end)

-- Matrix background frame (inside panel)
local matrixFrame = Instance.new("Frame", panel)
matrixFrame.Name = "MatrixFrame"
matrixFrame.Size = UDim2.new(1, -16, 1, -64)
matrixFrame.Position = UDim2.new(0, 8, 0, 44)
matrixFrame.BackgroundTransparency = 1
matrixFrame.ClipsDescendants = true
matrixFrame.ZIndex = 5

-- Foreground content container
local content = Instance.new("Frame", panel)
content.Size = UDim2.new(1, -16, 1, -64)
content.Position = UDim2.new(0, 8, 0, 44)
content.BackgroundTransparency = 1
content.ZIndex = 20

-- Matrix rain implementation (smooth, fast)
local columns = 28
local rows = 20
local glyphs = {}
do
    -- mix of katakana-like and ascii for neon effect
    local sample = "ｱｲｳｴｵｶｷｸｹｺｻｼｽｾｿﾀﾁﾂﾃﾄﾅﾆﾇﾈﾉ0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ@#$%&*"
    for c in sample:gmatch(".") do
        table.insert(glyphs, c)
    end
end

local colData = {}
local function initMatrix()
    matrixFrame:ClearAllChildren()
    colData = {}
    local width = matrixFrame.AbsoluteSize.X
    local height = matrixFrame.AbsoluteSize.Y
    if width <= 0 or height <= 0 then
        -- wait until size is valid
        task.delay(0.05, initMatrix)
        return
    end
    for c = 1, columns do
        colData[c] = {
            x = (c - 0.5) * (width / columns),
            speed = 120 + math.random(0, 160), -- pixels per second (fast)
            offset = math.random(0, rows),
            labels = {}
        }
        for r = 1, rows do
            local lbl = Instance.new("TextLabel")
            lbl.Size = UDim2.new(0, 14, 0, 14)
            lbl.BackgroundTransparency = 1
            lbl.Text = glyphs[math.random(1, #glyphs)]
            lbl.TextColor3 = Color3.fromRGB(0,255,120)
            lbl.Font = Enum.Font.Code
            lbl.TextScaled = true
            lbl.ZIndex = 5
            lbl.Parent = matrixFrame
            colData[c].labels[r] = lbl
        end
    end
end

matrixFrame:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
    initMatrix()
end)

initMatrix()

-- Render loop for matrix (fast)
local accum = 0
RunService.RenderStepped:Connect(function(dt)
    if not matrixFrame.Parent then return end
    accum = accum + dt
    -- update columns
    for c = 1, #colData do
        local col = colData[c]
        if col then
            col.offset = col.offset + col.speed * dt / (matrixFrame.AbsoluteSize.Y / rows)
            -- wrap offset
            if col.offset > rows then
                col.offset = col.offset - rows
            end
            for r = 1, rows do
                local lbl = col.labels[r]
                if lbl then
                    local idx = math.floor((r + math.floor(col.offset)) % #glyphs) + 1
                    lbl.Text = glyphs[math.random(1, #glyphs)]
                    local xPos = col.x - 7
                    local yPos = ((r - col.offset) % rows) * (matrixFrame.AbsoluteSize.Y / rows)
                    lbl.Position = UDim2.fromOffset(xPos, yPos)
                    -- brightness gradient
                    local dist = math.abs((r - col.offset) % rows)
                    local alpha = math.clamp(1 - (dist / 6), 0.15, 1)
                    lbl.TextColor3 = Color3.fromRGB(0, 255 * alpha, 120 * alpha)
                end
            end
        end
    end
end)

-- Target parsing (me, all, others, partial name)
local function getTargets(str)
    str = (str or ""):lower():gsub("^%s+", ""):gsub("%s+$", "")
    local list = {}
    if str == "" or str == "me" then
        table.insert(list, lp)
        return list
    end
    if str == "all" then
        for _,p in ipairs(Players:GetPlayers()) do table.insert(list, p) end
        return list
    end
    if str == "others" then
        for _,p in ipairs(Players:GetPlayers()) do
            if p ~= lp then table.insert(list, p) end
        end
        return list
    end
    -- partial name match
    for _,p in ipairs(Players:GetPlayers()) do
        if p.Name:lower():sub(1, #str) == str then
            table.insert(list, p)
            break
        end
    end
    return list
end

-- UI controls: target box and buttons
local lblTarget = Instance.new("TextLabel", content)
lblTarget.Size = UDim2.new(0, 70, 0, 28)
lblTarget.Position = UDim2.new(0, 6, 0, 6)
lblTarget.BackgroundTransparency = 1
lblTarget.Text = "Target:"
lblTarget.TextColor3 = Color3.fromRGB(0,255,120)
lblTarget.Font = Enum.Font.Code
lblTarget.TextScaled = true
lblTarget.ZIndex = 21

local txtTarget = Instance.new("TextBox", content)
txtTarget.Size = UDim2.new(0, 220, 0, 28)
txtTarget.Position = UDim2.new(0, 82, 0, 6)
txtTarget.BackgroundColor3 = Color3.fromRGB(8,8,8)
txtTarget.Text = "me / all / others / name"
txtTarget.TextColor3 = Color3.fromRGB(0,255,120)
txtTarget.Font = Enum.Font.Code
txtTarget.TextScaled = true
txtTarget.ClearTextOnFocus = true
txtTarget.ZIndex = 21
local txtCorner = Instance.new("UICorner", txtTarget)
txtCorner.CornerRadius = UDim.new(0,4)

local function makeButton(text, posX, posY, parent, callback)
    local btn = Instance.new("TextButton", parent)
    btn.Size = UDim2.new(0, 120, 0, 34)
    btn.Position = UDim2.new(0, posX, 0, posY)
    btn.BackgroundColor3 = Color3.fromRGB(12,12,12)
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(0,255,120)
    btn.Font = Enum.Font.Code
    btn.TextScaled = true
    btn.ZIndex = 21
    local c = Instance.new("UICorner", btn)
    c.CornerRadius = UDim.new(0,6)
    local s = Instance.new("UIStroke", btn)
    s.Color = Color3.fromRGB(0,255,120)
    s.Thickness = 1
    btn.MouseButton1Click:Connect(function()
        pcall(callback)
    end)
    return btn
end

-- Command implementations

-- Kill
local function cmdKill(targetStr)
    local targets = getTargets(targetStr)
    if #targets == 0 then popup("No valid targets", false) return end
    for _,p in ipairs(targets) do
        local char = p.Character
        if char then
            local hum = char:FindFirstChildOfClass("Humanoid")
            if hum then
                hum.Health = 0
            end
        end
    end
    popup("Killed "..#targets.." target(s)", true)
end

-- Invincible
local invincibleTrack = {}
local function cmdInvincible(targetStr)
    local targets = getTargets(targetStr)
    if #targets == 0 then popup("No valid targets", false) return end
    for _,p in ipairs(targets) do
        local char = p.Character
        if char then
            local hum = char:FindFirstChildOfClass("Humanoid")
            if hum then
                invincibleTrack[p] = true
                hum.MaxHealth = math.huge
                hum.Health = hum.MaxHealth
                task.spawn(function()
                    local thisHum = hum
                    while thisHum and thisHum.Parent and invincibleTrack[p] do
                        thisHum.Health = thisHum.MaxHealth
                        task.wait(0.12)
                    end
                end)
            end
        end
    end
    popup("Invincible applied to "..#targets.." target(s)", true)
end

-- TP Tool
local function giveTpTool()
    local existing = lp.Backpack:FindFirstChild("TP Tool") or lp.Character and lp.Character:FindFirstChild("TP Tool")
    if existing then
        popup("TP Tool already present", false)
        return
    end
    local tool = Instance.new("Tool")
    tool.Name = "TP Tool"
    tool.RequiresHandle = false
    tool.Parent = lp.Backpack

    tool.Activated:Connect(function()
        local mouse = lp:GetMouse()
        if mouse and mouse.Hit then
            local hrp = lp.Character and lp.Character:FindFirstChild("HumanoidRootPart")
            if hrp then
                hrp.CFrame = mouse.Hit + Vector3.new(0, 3, 0)
            end
        end
    end)
    popup("Teleport tool added", true)
end

-- Bring (D): bring target(s) slightly in front of you
local function cmdBring(targetStr)
    local targets = getTargets(targetStr)
    if #targets == 0 then popup("No valid targets", false) return end
    local myHRP = lp.Character and lp.Character:FindFirstChild("HumanoidRootPart")
    if not myHRP then popup("No HRP found for you", false) return end
    for _,p in ipairs(targets) do
        if p ~= lp and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
            local thrp = p.Character.HumanoidRootPart
            -- place them slightly in front of you
            local forward = myHRP.CFrame.LookVector
            local targetPos = myHRP.Position + forward * 4 + Vector3.new(0, 1, 0)
            thrp.CFrame = CFrame.new(targetPos, myHRP.Position)
        end
    end
    popup("Brought "..#targets.." target(s) in front of you", true)
end

-- TPTo (D): teleport YOU slightly behind the target
local function cmdTpTo(targetStr)
    local targets = getTargets(targetStr)
    if #targets == 0 then popup("No valid targets", false) return end
    local first = targets[1]
    if not first.Character or not first.Character:FindFirstChild("HumanoidRootPart") then
        popup("Target has no HRP", false)
        return
    end
    local thrp = first.Character.HumanoidRootPart
    local back = -thrp.CFrame.LookVector
    local myHRP = lp.Character and lp.Character:FindFirstChild("HumanoidRootPart")
    if not myHRP then popup("No HRP for you", false) return end
    myHRP.CFrame = thrp.CFrame + back * 4 + Vector3.new(0, 1, 0)
    popup("Teleported to "..first.Name, true)
end

-- Freeze (C): set WalkSpeed = 0 and JumpPower = 0 (toggle)
local freezeTrack = {}
local savedStats = {}
local function cmdFreeze(targetStr)
    local targets = getTargets(targetStr)
    if #targets == 0 then popup("No valid targets", false) return end
    for _,p in ipairs(targets) do
        local char = p.Character
        if char then
            local hum = char:FindFirstChildOfClass("Humanoid")
            if hum then
                if not freezeTrack[p] then
                    -- save
                    savedStats[p] = {walk = hum.WalkSpeed, jump = hum.JumpPower}
                    hum.WalkSpeed = 0
                    hum.JumpPower = 0
                    freezeTrack[p] = true
                else
                    -- unfreeze
                    local s = savedStats[p]
                    if s then
                        hum.WalkSpeed = s.walk or 16
                        hum.JumpPower = s.jump or 50
                    else
                        hum.WalkSpeed = 16
                        hum.JumpPower = 50
                    end
                    freezeTrack[p] = nil
                    savedStats[p] = nil
                end
            end
        end
    end
    popup("Toggled freeze for "..#targets.." target(s)", true)
end

-- Buttons
makeButton("KILL", 6, 48, content, function() cmdKill(txtTarget.Text) end)
makeButton("INVINCIBLE", 146, 48, content, function() cmdInvincible(txtTarget.Text) end)
makeButton("TP TOOL", 286, 48, content, function() giveTpTool() end)

makeButton("BRING", 6, 96, content, function() cmdBring(txtTarget.Text) end)
makeButton("TPTO", 146, 96, content, function() cmdTpTo(txtTarget.Text) end)
makeButton("FREEZE", 286, 96, content, function() cmdFreeze(txtTarget.Text) end)

-- Extra: quick player list dropdown (partial)
local listFrame = Instance.new("ScrollingFrame", content)
listFrame.Size = UDim2.new(0, 200, 0, 92)
listFrame.Position = UDim2.new(0, 6, 0, 150)
listFrame.BackgroundColor3 = Color3.fromRGB(6,6,6)
listFrame.BorderSizePixel = 0
listFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
listFrame.ZIndex = 21
local listCorner = Instance.new("UICorner", listFrame)
listCorner.CornerRadius = UDim.new(0,6)
local uiList = Instance.new("UIListLayout", listFrame)
uiList.Padding = UDim.new(0,4)

local function refreshPlayerList()
    listFrame:ClearAllChildren()
    uiList.Parent = listFrame
    for i,p in ipairs(Players:GetPlayers()) do
        local btn = Instance.new("TextButton", listFrame)
        btn.Size = UDim2.new(1, -8, 0, 28)
        btn.Position = UDim2.new(0, 4, 0, 0)
        btn.BackgroundColor3 = Color3.fromRGB(10,10,10)
        btn.Text = p.Name
        btn.TextColor3 = Color3.fromRGB(0,255,120)
        btn.Font = Enum.Font.Code
        btn.TextScaled = true
        btn.ZIndex = 21
        local c = Instance.new("UICorner", btn)
        c.CornerRadius = UDim.new(0,4)
        btn.MouseButton1Click:Connect(function()
            txtTarget.Text = p.Name
        end)
    end
    -- update canvas size
    local count = #Players:GetPlayers()
    listFrame.CanvasSize = UDim2.new(0,0,0, count * 32)
end

Players.PlayerAdded:Connect(refreshPlayerList)
Players.PlayerRemoving:Connect(refreshPlayerList)
refreshPlayerList()

-- Chat commands
local function runChatCommand(msg)
    local args = {}
    for w in msg:gmatch("%S+") do table.insert(args, w) end
    local cmd = args[1] and args[1]:lower()
    if cmd == "/kill" then
        cmdKill(args[2] or "me")
    elseif cmd == "/invincible" then
        cmdInvincible(args[2] or "me")
    elseif cmd == "/tptool" then
        giveTpTool()
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
popup("Neon Matrix Admin loaded", true)

-- Cleanup on character respawn: reapply invincibility if needed
Players.PlayerAdded:Connect(function() end) -- placeholder to keep script active
