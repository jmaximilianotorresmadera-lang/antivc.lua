-- RIVAS EXECUTOR PRO - Script Completo con Aimbot, ESP y Fly
-- LocalScript para StarterPlayer > StarterCharacterScripts
-- Versión: 1.0 Rivas Edition

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local Mouse = LocalPlayer:GetMouse()
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local Humanoid = Character:WaitForChild("Humanoid")
local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")

-- ========== ANTI-DETECCIÓN ==========
pcall(function()
    local mt = getrawmetatable(game)
    local oldIndex = mt.__index
    setreadonly(mt, false)
    mt.__index = function(self, key)
        if self == script or tostring(self):find("LocalScript") then
            return nil
        end
        return oldIndex(self, key)
    end
    setreadonly(mt, true)
end)

-- ========== VARIABLES GLOBALES ==========
local settings = {
    aimbot = {
        enabled = false,
        smoothness = 0.1,
        range = 100,
        targetPart = "Head",
        showFOV = false,
    },
    esp = {
        enabled = false,
        showDistance = true,
        showHealth = true,
        showTeam = true,
        boxType = "2D", -- "2D" o "3D"
    },
    fly = {
        enabled = false,
        speed = 50,
    },
    combat = {
        godMode = false,
        speedBoost = false,
        noclip = false,
        invisible = false,
    }
}

local espDrawings = {}
local targetPlayer = nil

-- ========== COLORES ==========
local colors = {
    primary = Color3.fromRGB(100, 200, 255),
    secondary = Color3.fromRGB(150, 100, 255),
    dark = Color3.fromRGB(20, 20, 35),
    darker = Color3.fromRGB(15, 15, 25),
    danger = Color3.fromRGB(255, 100, 120),
    success = Color3.fromRGB(100, 255, 150),
    accent = Color3.fromRGB(255, 150, 100),
}

-- ========== FUNCIONES ==========

local function notify(msg)
    print("[RIVAS EXECUTOR] " .. msg)
end

local function getNearestPlayer()
    local nearest = nil
    local minDist = math.huge
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local dist = (player.Character.HumanoidRootPart.Position - HumanoidRootPart.Position).Magnitude
            if dist < minDist and dist < settings.aimbot.range then
                minDist = dist
                nearest = player
            end
        end
    end
    return nearest
end

-- ========== AIMBOT SYSTEM ==========

local function enableAimbot()
    settings.aimbot.enabled = true
    notify("✓ AIMBOT ACTIVADO")
    
    local connection
    connection = RunService.RenderStepped:Connect(function()
        if not settings.aimbot.enabled then
            connection:Disconnect()
            return
        end
        
        targetPlayer = getNearestPlayer()
        
        if targetPlayer and targetPlayer.Character then
            local targetPart = targetPlayer.Character:FindFirstChild(settings.aimbot.targetPart)
            if targetPart then
                local camera = workspace.CurrentCamera
                local direction = (targetPart.Position - camera.CFrame.Position).Unit
                local newCFrame = CFrame.new(camera.CFrame.Position, camera.CFrame.Position + direction)
                
                camera.CFrame = camera.CFrame:Lerp(newCFrame, settings.aimbot.smoothness)
            end
        end
    end)
end

local function disableAimbot()
    settings.aimbot.enabled = false
    notify("✗ AIMBOT DESACTIVADO")
end

-- ========== ESP SYSTEM ==========

local function clearESP()
    for _, drawing in ipairs(espDrawings) do
        pcall(function() drawing:Remove() end)
    end
    espDrawings = {}
end

local function createESPBox(player)
    if not player or not player.Character then return end
    
    local character = player.Character
    local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
    local humanoid = character:FindFirstChild("Humanoid")
    
    if not humanoidRootPart or not humanoid then return end
    
    local camera = workspace.CurrentCamera
    
    -- Convertir posición 3D a 2D
    local screenPos, onScreen = camera:WorldToScreenPoint(humanoidRootPart.Position)
    
    if not onScreen then return end
    
    -- Crear caja 2D
    local box = Drawing.new("Rectangle")
    box.Size = Vector2.new(100, 120)
    box.Position = Vector2.new(screenPos.X - 50, screenPos.Y - 60)
    box.Color = player.Team == LocalPlayer.Team and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0)
    box.Thickness = 2
    box.Transparency = 0.7
    box.Filled = false
    
    -- Nombre del jugador
    local nameLabel = Drawing.new("Text")
    nameLabel.Text = player.Name
    nameLabel.Size = 18
    nameLabel.Color = Color3.fromRGB(255, 255, 255)
    nameLabel.Position = Vector2.new(screenPos.X - 30, screenPos.Y - 80)
    
    -- Distancia
    local distance = (humanoidRootPart.Position - HumanoidRootPart.Position).Magnitude
    local distLabel = Drawing.new("Text")
    distLabel.Text = math.floor(distance) .. "m"
    distLabel.Size = 14
    distLabel.Color = Color3.fromRGB(150, 255, 150)
    distLabel.Position = Vector2.new(screenPos.X - 20, screenPos.Y + 65)
    
    -- Salud
    local healthLabel = Drawing.new("Text")
    healthLabel.Text = "HP: " .. math.floor(humanoid.Health) .. "/" .. math.floor(humanoid.MaxHealth)
    healthLabel.Size = 14
    healthLabel.Color = Color3.fromRGB(100, 255, 100)
    healthLabel.Position = Vector2.new(screenPos.X - 40, screenPos.Y + 45)
    
    table.insert(espDrawings, box)
    table.insert(espDrawings, nameLabel)
    table.insert(espDrawings, distLabel)
    table.insert(espDrawings, healthLabel)
end

local function updateESP()
    if not settings.esp.enabled then return end
    
    clearESP()
    
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            createESPBox(player)
        end
    end
end

local function enableESP()
    settings.esp.enabled = true
    notify("✓ ESP ACTIVADO")
    
    local connection
    connection = RunService.RenderStepped:Connect(function()
        if not settings.esp.enabled then
            connection:Disconnect()
            clearESP()
            return
        end
        updateESP()
    end)
end

local function disableESP()
    settings.esp.enabled = false
    clearESP()
    notify("✗ ESP DESACTIVADO")
end

-- ========== FLY SYSTEM ==========

local function enableFly()
    settings.fly.enabled = true
    notify("✓ FLY ACTIVADO - Velocidad: " .. settings.fly.speed)
    
    local bodyVel = Instance.new("BodyVelocity")
    bodyVel.MaxForce = Vector3.new(9e9, 9e9, 9e9)
    bodyVel.Parent = HumanoidRootPart
    
    local connection
    connection = RunService.RenderStepped:Connect(function()
        if not settings.fly.enabled then
            connection:Disconnect()
            bodyVel:Destroy()
            return
        end
        
        local camera = workspace.CurrentCamera
        bodyVel.Velocity = camera.CFrame.LookVector * settings.fly.speed
    end)
end

local function disableFly()
    settings.fly.enabled = false
    notify("✗ FLY DESACTIVADO")
end

local function increaseFlySpeed()
    settings.fly.speed = settings.fly.speed + 10
    notify("Velocidad: " .. settings.fly.speed)
end

local function decreaseFlySpeed()
    settings.fly.speed = math.max(10, settings.fly.speed - 10)
    notify("Velocidad: " .. settings.fly.speed)
end

-- ========== COMBAT FEATURES ==========

local function enableGodMode()
    settings.combat.godMode = true
    Humanoid.MaxHealth = math.huge
    notify("✓ GOD MODE ACTIVADO")
    
    local connection
    connection = RunService.Heartbeat:Connect(function()
        if not settings.combat.godMode or not Humanoid then
            connection:Disconnect()
            return
        end
        Humanoid.Health = math.huge
    end)
end

local function disableGodMode()
    settings.combat.godMode = false
    notify("✗ GOD MODE DESACTIVADO")
end

local function enableNoclip()
    settings.combat.noclip = true
    notify("✓ NOCLIP ACTIVADO")
    
    local connection
    connection = RunService.Stepped:Connect(function()
        if not settings.combat.noclip or not Character then
            connection:Disconnect()
            return
        end
        
        for _, part in ipairs(Character:FindDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
    end)
end

local function disableNoclip()
    settings.combat.noclip = false
    for _, part in ipairs(Character:FindDescendants()) do
        if part:IsA("BasePart") then
            part.CanCollide = true
        end
    end
    notify("✗ NOCLIP DESACTIVADO")
end

local function enableInvisible()
    settings.combat.invisible = true
    for _, part in ipairs(Character:FindDescendants()) do
        if part:IsA("BasePart") then
            part.Transparency = 1
        end
    end
    notify("✓ INVISIBLE ACTIVADO")
end

local function disableInvisible()
    settings.combat.invisible = false
    for _, part in ipairs(Character:FindDescendants()) do
        if part:IsA("BasePart") then
            part.Transparency = 0
        end
    end
    notify("✗ INVISIBLE DESACTIVADO")
end

local function enableSpeedBoost()
    settings.combat.speedBoost = true
    Humanoid.WalkSpeed = 100
    notify("✓ SPEED BOOST ACTIVADO")
end

local function disableSpeedBoost()
    settings.combat.speedBoost = false
    Humanoid.WalkSpeed = 16
    notify("✗ SPEED BOOST DESACTIVADO")
end

-- ========== GUI PRINCIPAL ==========

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "RivasExecutor"
screenGui.ResetOnSpawn = false
screenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 450, 0, 600)
mainFrame.Position = UDim2.new(0, 20, 0.5, -300)
mainFrame.BackgroundColor3 = colors.dark
mainFrame.BorderSizePixel = 0
mainFrame.Visible = true
mainFrame.Parent = screenGui

local bgGradient = Instance.new("UIGradient")
bgGradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, colors.dark),
    ColorSequenceKeypoint.new(1, colors.darker)
}
bgGradient.Parent = mainFrame

local bgCorner = Instance.new("UICorner")
bgCorner.CornerRadius = UDim.new(0, 15)
bgCorner.Parent = mainFrame

-- HEADER
local header = Instance.new("Frame")
header.Size = UDim2.new(1, 0, 0, 100)
header.BackgroundColor3 = colors.darker
header.BorderSizePixel = 0
header.Parent = mainFrame

local headerCorner = Instance.new("UICorner")
headerCorner.CornerRadius = UDim.new(0, 15)
headerCorner.Parent = header

local headerGradient = Instance.new("UIGradient")
headerGradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, colors.primary),
    ColorSequenceKeypoint.new(1, colors.secondary)
}
headerGradient.Rotation = 90
headerGradient.Parent = header

local titleLabel = Instance.new("TextLabel")
titleLabel.Text = "⚡ RIVAS EXECUTOR PRO"
titleLabel.Size = UDim2.new(1, -20, 0, 50)
titleLabel.Position = UDim2.new(0, 10, 0, 10)
titleLabel.BackgroundTransparency = 1
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLabel.TextSize = 24
titleLabel.Font = Enum.Font.GothamBold
titleLabel.TextXAlignment = Enum.TextXAlignment.Left
titleLabel.Parent = header

local statusLabel = Instance.new("TextLabel")
statusLabel.Text = "Aimbot: OFF | ESP: OFF | Fly: OFF"
statusLabel.Size = UDim2.new(1, -20, 0, 30)
statusLabel.Position = UDim2.new(0, 10, 0, 55)
statusLabel.BackgroundTransparency = 1
statusLabel.TextColor3 = Color3.fromRGB(100, 255, 150)
statusLabel.TextSize = 12
statusLabel.Font = Enum.Font.Gotham
statusLabel.TextXAlignment = Enum.TextXAlignment.Left
statusLabel.Parent = header

-- CONTENIDO SCROLLABLE
local scrollFrame = Instance.new("ScrollingFrame")
scrollFrame.Size = UDim2.new(1, 0, 1, -100)
scrollFrame.Position = UDim2.new(0, 0, 0, 100)
scrollFrame.BackgroundTransparency = 1
scrollFrame.ScrollBarThickness = 6
scrollFrame.ScrollBarImageColor3 = colors.primary
scrollFrame.Parent = mainFrame

local listLayout = Instance.new("UIListLayout")
listLayout.Padding = UDim.new(0, 6)
listLayout.Parent = scrollFrame

local padding = Instance.new("UIPadding")
padding.PaddingLeft = UDim.new(0, 8)
padding.PaddingRight = UDim.new(0, 8)
padding.PaddingTop = UDim.new(0, 8)
padding.PaddingBottom = UDim.new(0, 8)
padding.Parent = scrollFrame

-- FUNCIÓN CREAR BOTÓN
local function createButton(parent, text, callback, color)
    color = color or colors.primary
    
    local btn = Instance.new("TextButton")
    btn.Text = "▶ " .. text
    btn.Size = UDim2.new(1, 0, 0, 45)
    btn.BackgroundColor3 = Color3.fromRGB(40, 40, 65)
    btn.TextColor3 = Color3.fromRGB(200, 200, 255)
    btn.TextSize = 12
    btn.Font = Enum.Font.GothamBold
    btn.BorderSizePixel = 0
    btn.Parent = parent
    btn.TextXAlignment = Enum.TextXAlignment.Left
    
    local btnPadding = Instance.new("UIPadding")
    btnPadding.PaddingLeft = UDim.new(0, 12)
    btnPadding.Parent = btn
    
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 8)
    btnCorner.Parent = btn
    
    btn.MouseButton1Click:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.1), {BackgroundColor3 = color}):Play()
        btn.TextColor3 = Color3.fromRGB(0, 0, 0)
        pcall(callback)
        wait(0.15)
        TweenService:Create(btn, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(40, 40, 65)}):Play()
        btn.TextColor3 = Color3.fromRGB(200, 200, 255)
    end)
    
    btn.MouseEnter:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(55, 55, 80)}):Play()
    end)
    
    btn.MouseLeave:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(40, 40, 65)}):Play()
    end)
    
    return btn
end

-- ========== BOTONES AIMBOT ==========

createButton(scrollFrame, "Enable Aimbot", function()
    if settings.aimbot.enabled then
        disableAimbot()
    else
        enableAimbot()
    end
end, colors.danger)

createButton(scrollFrame, "Aimbot Smoothness +", function()
    settings.aimbot.smoothness = math.min(1, settings.aimbot.smoothness + 0.1)
    notify("Smoothness: " .. math.floor(settings.aimbot.smoothness * 100) .. "%")
end, colors.accent)

createButton(scrollFrame, "Aimbot Smoothness -", function()
    settings.aimbot.smoothness = math.max(0, settings.aimbot.smoothness - 0.1)
    notify("Smoothness: " .. math.floor(settings.aimbot.smoothness * 100) .. "%")
end, colors.accent)

createButton(scrollFrame, "Aimbot Range +50", function()
    settings.aimbot.range = settings.aimbot.range + 50
    notify("Rango: " .. settings.aimbot.range)
end, colors.accent)

createButton(scrollFrame, "Change Target Part", function()
    local parts = {"Head", "Torso", "HumanoidRootPart"}
    local idx = table.find(parts, settings.aimbot.targetPart) or 1
    idx = idx % #parts + 1
    settings.aimbot.targetPart = parts[idx]
    notify("Target: " .. settings.aimbot.targetPart)
end, colors.accent)

-- ========== BOTONES ESP ==========

createButton(scrollFrame, "Enable ESP", function()
    if settings.esp.enabled then
        disableESP()
    else
        enableESP()
    end
end, colors.success)

createButton(scrollFrame, "ESP Box Type", function()
    settings.esp.boxType = settings.esp.boxType == "2D" and "3D" or "2D"
    notify("Box Type: " .. settings.esp.boxType)
end, colors.accent)

-- ========== BOTONES FLY ==========

createButton(scrollFrame, "Enable Fly", function()
    if settings.fly.enabled then
        disableFly()
    else
        enableFly()
    end
end, colors.primary)

createButton(scrollFrame, "Fly Speed +", function()
    increaseFlySpeed()
end, colors.accent)

createButton(scrollFrame, "Fly Speed -", function()
    decreaseFlySpeed()
end, colors.accent)

-- ========== BOTONES COMBAT ==========

createButton(scrollFrame, "God Mode", function()
    if settings.combat.godMode then
        disableGodMode()
    else
        enableGodMode()
    end
end, colors.danger)

createButton(scrollFrame, "Speed Boost", function()
    if settings.combat.speedBoost then
        disableSpeedBoost()
    else
        enableSpeedBoost()
    end
end, colors.primary)

createButton(scrollFrame, "Noclip", function()
    if settings.combat.noclip then
        disableNoclip()
    else
        enableNoclip()
    end
end, colors.accent)

createButton(scrollFrame, "Invisible", function()
    if settings.combat.invisible then
        disableInvisible()
    else
        enableInvisible()
    end
end, colors.secondary)

createButton(scrollFrame, "Kill Target", function()
    if targetPlayer and targetPlayer.Character then
        targetPlayer.Character.Humanoid.Health = 0
        notify("✓ " .. targetPlayer.Name .. " eliminado")
    end
end, colors.danger)

createButton(scrollFrame, "TP to Target", function()
    if targetPlayer and targetPlayer.Character then
        HumanoidRootPart.CFrame = targetPlayer.Character.HumanoidRootPart.CFrame + Vector3.new(5, 0, 0)
        notify("✓ Teletransportado a " .. targetPlayer.Name)
    end
end, colors.accent)

-- ========== BOTONES MUNDO ==========

createButton(scrollFrame, "Heal 100%", function()
    Humanoid.Health = Humanoid.MaxHealth
    notify("✓ Salud restaurada")
end, colors.success)

createButton(scrollFrame, "Create Explosion", function()
    local exp = Instance.new("Explosion")
    exp.Position = HumanoidRootPart.Position
    exp.Parent = workspace
    notify("✓ Explosión creada")
end, colors.danger)

createButton(scrollFrame, "List All Players", function()
    print("\n╔════════════════════════════════╗")
    print("║   JUGADORES EN LÍNEA           ║")
    print("╠════════════════════════════════╣")
    for i, player in ipairs(Players:GetPlayers()) do
        print("║ " .. i .. ". " .. player.Name)
    end
    print("╚════════════════════════════════╝\n")
end, colors.accent)

createButton(scrollFrame, "Reset All", function()
    disableAimbot()
    disableESP()
    disableFly()
    disableGodMode()
    disableNoclip()
    disableInvisible()
    disableSpeedBoost()
    notify("✓ TODO RESETEADO")
end, colors.danger)

-- ========== CONTROLES DE TECLADO ==========

UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    
    -- M para toggle menú
    if input.KeyCode == Enum.KeyCode.M then
        mainFrame.Visible = not mainFrame.Visible
    end
    
    -- Z para toggle aimbot
    if input.KeyCode == Enum.KeyCode.Z then
        if settings.aimbot.enabled then
            disableAimbot()
        else
            enableAimbot()
        end
    end
    
    -- X para toggle ESP
    if input.KeyCode == Enum.KeyCode.X then
        if settings.esp.enabled then
            disableESP()
        else
            enableESP()
        end
    end
    
    -- C para toggle Fly
    if input.KeyCode == Enum.KeyCode.C then
        if settings.fly.enabled then
            disableFly()
        else
            enableFly()
        end
    end
    
    -- V para toggle Godmode
    if input.KeyCode == Enum.KeyCode.V then
        if settings.combat.godMode then
            disableGodMode()
        else
            enableGodMode()
        end
    end
    
    -- F para matar target
    if input.KeyCode == Enum.KeyCode.F then
        if targetPlayer and targetPlayer.Character then
            targetPlayer.Character.Humanoid.Health = 0
        end
    end
end)

-- ========== ACTUALIZAR STATUS ==========

local function updateStatus()
    local aimbotStatus = settings.aimbot.enabled and "ON" or "OFF"
    local espStatus = settings.esp.enabled and "ON" or "OFF"
    local flyStatus = settings.fly.enabled and "ON" or "OFF"
    
    statusLabel.Text = "Aimbot: " .. aimbotStatus .. " | ESP: " .. espStatus .. " | Fly: " .. flyStatus
end

RunService.Heartbeat:Connect(function()
    updateStatus()
end)

-- ========== INICIO ==========
print("\n╔════════════════════════════════════════╗")
print("║  ⚡ RIVAS EXECUTOR PRO CARGADO ⚡   ║")
print("║  ✓ Aimbot habilitado                 ║")
print("║  ✓ ESP habilitado                    ║")
print("║  ✓ Fly habilitado                    ║")
print("║                                        ║")
print("║  CONTROLES:                          ║")
print("║  M - Toggle Menú                     ║")
print("║  Z - Toggle Aimbot                   ║")
print("║  X - Toggle ESP                      ║")
print("║  C - Toggle Fly                      ║")
print("║  V - Toggle Godmode                  ║")
print("║  F - Kill Target                     ║")
print("║                                        ║")
print("╚════════════════════════════════════════╝\n")

notify("✓ RIVAS EXECUTOR PRO ACTIVADO")
notify("✓ Presiona M para abrir menú")
notify("✓ Z=Aimbot | X=ESP | C=Fly | V=Godmode | F=Kill")
