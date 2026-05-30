-- LocalScript con Menú Interactivo - 50+ Comandos
-- Coloca esto en StarterPlayer > StarterCharacterScripts

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local Mouse = LocalPlayer:GetMouse()
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Humanoid = Character:WaitForChild("Humanoid")
local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")

-- ========== INTERFAZ GUI ==========
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "ExecutorMenu"
screenGui.ResetOnSpawn = false
screenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 400, 0, 600)
mainFrame.Position = UDim2.new(0, 20, 0, 20)
mainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
mainFrame.BorderSizePixel = 0
mainFrame.Parent = screenGui

-- Esquina redondeada
local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 10)
corner.Parent = mainFrame

-- ========== BARRA DE TÍTULO ==========
local titleBar = Instance.new("Frame")
titleBar.Name = "TitleBar"
titleBar.Size = UDim2.new(1, 0, 0, 50)
titleBar.BackgroundColor3 = Color3.fromRGB(15, 15, 25)
titleBar.BorderSizePixel = 0
titleBar.Parent = mainFrame

local titleCorner = Instance.new("UICorner")
titleCorner.CornerRadius = UDim.new(0, 10)
titleCorner.Parent = titleBar

local titleLabel = Instance.new("TextLabel")
titleLabel.Text = "⚡ EXECUTOR MENU v2.0"
titleLabel.Size = UDim2.new(1, -80, 1, 0)
titleLabel.Position = UDim2.new(0, 10, 0, 0)
titleLabel.BackgroundTransparency = 1
titleLabel.TextColor3 = Color3.fromRGB(0, 255, 136)
titleLabel.TextSize = 18
titleLabel.Font = Enum.Font.GothamBold
titleLabel.TextXAlignment = Enum.TextXAlignment.Left
titleLabel.Parent = titleBar

-- Botón cerrar
local closeBtn = Instance.new("TextButton")
closeBtn.Name = "CloseBtn"
closeBtn.Text = "✕"
closeBtn.Size = UDim2.new(0, 40, 0, 40)
closeBtn.Position = UDim2.new(1, -50, 0, 5)
closeBtn.BackgroundColor3 = Color3.fromRGB(255, 80, 80)
closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
closeBtn.TextSize = 16
closeBtn.Font = Enum.Font.GothamBold
closeBtn.BorderSizePixel = 0
closeBtn.Parent = titleBar

local closeBtnCorner = Instance.new("UICorner")
closeBtnCorner.CornerRadius = UDim.new(0, 5)
closeBtnCorner.Parent = closeBtn

-- ========== LISTA DE BOTONES SCROLLABLE ==========
local scrollFrame = Instance.new("ScrollingFrame")
scrollFrame.Name = "ScrollFrame"
scrollFrame.Size = UDim2.new(1, 0, 1, -60)
scrollFrame.Position = UDim2.new(0, 0, 0, 50)
scrollFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
scrollFrame.BorderSizePixel = 0
scrollFrame.ScrollBarThickness = 6
scrollFrame.ScrollBarImageColor3 = Color3.fromRGB(0, 255, 136)
scrollFrame.Parent = mainFrame

local uiListLayout = Instance.new("UIListLayout")
uiListLayout.Padding = UDim.new(0, 5)
uiListLayout.Parent = scrollFrame

local uiPadding = Instance.new("UIPadding")
uiPadding.PaddingLeft = UDim.new(0, 5)
uiPadding.PaddingRight = UDim.new(0, 5)
uiPadding.PaddingTop = UDim.new(0, 5)
uiPadding.PaddingBottom = UDim.new(0, 5)
uiPadding.Parent = scrollFrame

-- ========== ESTADOS ==========
local states = {
    godMode = false,
    noclip = false,
    flyMode = false,
    spin = false,
    invisible = false,
    speedBoost = false,
}

-- ========== FUNCIONES AUXILIARES ==========
local function createButton(name, callback)
    local button = Instance.new("TextButton")
    button.Name = name
    button.Text = "▶ " .. name
    button.Size = UDim2.new(1, 0, 0, 35)
    button.BackgroundColor3 = Color3.fromRGB(45, 45, 60)
    button.TextColor3 = Color3.fromRGB(200, 200, 255)
    button.TextSize = 13
    button.Font = Enum.Font.Gotham
    button.BorderSizePixel = 0
    button.Parent = scrollFrame
    
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 5)
    btnCorner.Parent = button
    
    button.MouseButton1Click:Connect(function()
        button.BackgroundColor3 = Color3.fromRGB(0, 255, 136)
        button.TextColor3 = Color3.fromRGB(0, 0, 0)
        callback()
        wait(0.1)
        button.BackgroundColor3 = Color3.fromRGB(45, 45, 60)
        button.TextColor3 = Color3.fromRGB(200, 200, 255)
    end)
    
    button.MouseEnter:Connect(function()
        button.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
    end)
    
    button.MouseLeave:Connect(function()
        button.BackgroundColor3 = Color3.fromRGB(45, 45, 60)
    end)
    
    return button
end

local function notify(msg)
    print("[EXECUTOR] " .. msg)
end

local function getPlayer(name)
    for _, player in ipairs(Players:GetPlayers()) do
        if string.lower(player.Name):find(string.lower(name), 1, true) then
            return player
        end
    end
    return nil
end

-- ========== COMANDOS (50+) ==========

-- 1. GOD MODE
createButton("God Mode", function()
    states.godMode = not states.godMode
    if states.godMode then
        Humanoid.MaxHealth = math.huge
        Humanoid.Health = math.huge
        RunService.Heartbeat:Connect(function()
            if states.godMode and Humanoid then
                Humanoid.Health = math.huge
            end
        end)
        notify("✓ God Mode ON")
    else
        notify("✗ God Mode OFF")
    end
end)

-- 2. NOCLIP
createButton("Noclip", function()
    states.noclip = not states.noclip
    if states.noclip then
        RunService.Stepped:Connect(function()
            if states.noclip and Character then
                for _, part in ipairs(Character:FindDescendants()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = false
                    end
                end
            end
        end)
        notify("✓ Noclip ON")
    else
        for _, part in ipairs(Character:FindDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = true
            end
        end
        notify("✗ Noclip OFF")
    end
end)

-- 3. VOLAR
createButton("Fly Mode", function()
    states.flyMode = not states.flyMode
    if states.flyMode then
        local bodyVelocity = Instance.new("BodyVelocity")
        bodyVelocity.Velocity = Vector3.new(0, 0, 0)
        bodyVelocity.MaxForce = Vector3.new(100000, 100000, 100000)
        bodyVelocity.Parent = HumanoidRootPart
        
        RunService.RenderStepped:Connect(function()
            if states.flyMode and Character then
                local camera = workspace.CurrentCamera
                bodyVelocity.Velocity = camera.CFrame.LookVector * 50
            end
        end)
        notify("✓ Fly Mode ON")
    else
        notify("✗ Fly Mode OFF")
    end
end)

-- 4. VELOCIDAD
createButton("Speed Boost x5", function()
    if not states.speedBoost then
        states.speedBoost = true
        Humanoid.WalkSpeed = 50
        notify("✓ Speed Boost ON")
    else
        states.speedBoost = false
        Humanoid.WalkSpeed = 16
        notify("✗ Speed Boost OFF")
    end
end)

-- 5. SUPER SALTO
createButton("Super Jump x10", function()
    Humanoid.JumpPower = 100
    notify("✓ Super Jump activado")
end)

-- 6. INVISIBLE
createButton("Invisibility", function()
    states.invisible = not states.invisible
    if states.invisible then
        for _, part in ipairs(Character:FindDescendants()) do
            if part:IsA("BasePart") then
                part.Transparency = 1
            end
        end
        notify("✓ Invisible ON")
    else
        for _, part in ipairs(Character:FindDescendants()) do
            if part:IsA("BasePart") then
                part.Transparency = 0
            end
        end
        notify("✗ Invisible OFF")
    end
end)

-- 7. SPIN
createButton("Spin Mode", function()
    states.spin = not states.spin
    if states.spin then
        RunService.Heartbeat:Connect(function()
            if states.spin and Character then
                HumanoidRootPart.CFrame = HumanoidRootPart.CFrame * CFrame.Angles(0, math.rad(50), 0)
            end
        end)
        notify("✓ Spin Mode ON")
    else
        notify("✗ Spin Mode OFF")
    end
end)

-- 8. TELEPORTAR ABAJO
createButton("Teleport Down", function()
    HumanoidRootPart.CFrame = HumanoidRootPart.CFrame + Vector3.new(0, -50, 0)
    notify("✓ Teleportado abajo")
end)

-- 9. TELEPORTAR ARRIBA
createButton("Teleport Up", function()
    HumanoidRootPart.CFrame = HumanoidRootPart.CFrame + Vector3.new(0, 50, 0)
    notify("✓ Teleportado arriba")
end)

-- 10. OBTENER COORDENADAS
createButton("Show Coordinates", function()
    local pos = HumanoidRootPart.Position
    notify("📍 X: " .. math.floor(pos.X) .. " Y: " .. math.floor(pos.Y) .. " Z: " .. math.floor(pos.Z))
end)

-- 11. OBTENER HERRAMIENTAS
createButton("Get All Tools", function()
    local count = 0
    for _, tool in ipairs(workspace:FindDescendants()) do
        if tool:IsA("Tool") then
            local clone = tool:Clone()
            clone.Parent = LocalPlayer.Backpack
            count = count + 1
        end
    end
    notify("✓ Obtenidas " .. count .. " herramientas")
end)

-- 12. CREAR ESFERA
createButton("Create Sphere", function()
    local sphere = Instance.new("Part")
    sphere.Shape = Enum.PartType.Ball
    sphere.Material = Enum.Material.Neon
    sphere.BrickColor = BrickColor.new("Cyan")
    sphere.Size = Vector3.new(5, 5, 5)
    sphere.Position = HumanoidRootPart.Position + Vector3.new(0, 10, 0)
    sphere.CanCollide = false
    sphere.Parent = workspace
    notify("✓ Esfera creada")
end)

-- 13. CREAR CUBO
createButton("Create Cube", function()
    local cube = Instance.new("Part")
    cube.Shape = Enum.PartType.Block
    cube.Material = Enum.Material.Neon
    cube.BrickColor = BrickColor.new("Magenta")
    cube.Size = Vector3.new(5, 5, 5)
    cube.Position = HumanoidRootPart.Position + Vector3.new(0, 10, 0)
    cube.CanCollide = false
    cube.Parent = workspace
    notify("✓ Cubo creado")
end)

-- 14. LIMPIAR PARTES
createButton("Clear All Parts", function()
    local removed = 0
    for _, part in ipairs(workspace:FindDescendants()) do
        if part:IsA("BasePart") and part.Parent ~= Character and not part:IsDescendantOf(Players) then
            pcall(function()
                part:Destroy()
                removed = removed + 1
            end)
        end
    end
    notify("✓ " .. removed .. " partes eliminadas")
end)

-- 15. FPS COUNTER
createButton("Show FPS", function()
    local fps = math.floor(1 / RunService.RenderStepped:Wait())
    notify("📊 FPS: " .. fps)
end)

-- 16. REAPARICIÓN
createButton("Respawn", function()
    Humanoid.Health = 0
    notify("✓ Reaparición iniciada")
end)

-- 17. SALUD AL MÁXIMO
createButton("Heal Yourself", function()
    Humanoid.Health = Humanoid.MaxHealth
    notify("✓ Salud restaurada")
end)

-- 18. DINERO +1000
createButton("Money +1000", function()
    local leaderstats = LocalPlayer:FindFirstChild("leaderstats")
    if leaderstats then
        for _, stat in ipairs(leaderstats:GetChildren()) do
            if stat:IsA("IntValue") or stat:IsA("NumberValue") then
                stat.Value = stat.Value + 1000
            end
        end
        notify("✓ +1000 dinero")
    end
end)

-- 19. DINERO +10000
createButton("Money +10000", function()
    local leaderstats = LocalPlayer:FindFirstChild("leaderstats")
    if leaderstats then
        for _, stat in ipairs(leaderstats:GetChildren()) do
            if stat:IsA("IntValue") or stat:IsA("NumberValue") then
                stat.Value = stat.Value + 10000
            end
        end
        notify("✓ +10000 dinero")
    end
end)

-- 20. LISTAR JUGADORES
createButton("List Players", function()
    print("\n=== JUGADORES EN LÍNEA ===")
    local count = 0
    for _, player in ipairs(Players:GetPlayers()) do
        print("• " .. player.Name)
        count = count + 1
    end
    print("Total: " .. count)
    print("==========================\n")
end)

-- 21. BUSCAR JUGADOR CERCANO
createButton("Find Nearest Player", function()
    local nearest = nil
    local distance = math.huge
    
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            local dist = (player.Character.HumanoidRootPart.Position - HumanoidRootPart.Position).Magnitude
            if dist < distance then
                distance = dist
                nearest = player
            end
        end
    end
    
    if nearest then
        notify("🎯 Más cercano: " .. nearest.Name .. " (" .. math.floor(distance) .. " studs)")
    end
end)

-- 22. CREAR PLATAFORMA
createButton("Create Platform", function()
    local platform = Instance.new("Part")
    platform.Shape = Enum.PartType.Block
    platform.Material = Enum.Material.Brick
    platform.BrickColor = BrickColor.new("Lime green")
    platform.Size = Vector3.new(20, 1, 20)
    platform.Position = HumanoidRootPart.Position + Vector3.new(0, -5, 0)
    platform.CanCollide = true
    platform.Parent = workspace
    notify("✓ Plataforma creada")
end)

-- 23. MOSTRAR SALUD
createButton("Show Health", function()
    notify("❤️ Salud: " .. math.floor(Humanoid.Health) .. "/" .. math.floor(Humanoid.MaxHealth))
end)

-- 24. CREAR LAZO
createButton("Create Rope", function()
    local rope = Instance.new("Part")
    rope.Name = "Rope"
    rope.Shape = Enum.PartType.Cylinder
    rope.Size = Vector3.new(0.2, 20, 0.2)
    rope.Material = Enum.Material.Rope
    rope.BrickColor = BrickColor.new("Brown")
    rope.Position = HumanoidRootPart.Position + Vector3.new(0, 10, 0)
    rope.CanCollide = false
    rope.Parent = workspace
    notify("✓ Lazo creado")
end)

-- 25. CREAR PARED
createButton("Create Wall", function()
    local wall = Instance.new("Part")
    wall.Shape = Enum.PartType.Block
    wall.Material = Enum.Material.Concrete
    wall.BrickColor = BrickColor.new("Dark stone grey")
    wall.Size = Vector3.new(30, 20, 1)
    wall.Position = HumanoidRootPart.Position + Vector3.new(0, 0, -15)
    wall.CanCollide = true
    wall.Parent = workspace
    notify("✓ Pared creada")
end)

-- 26. CREAR PIRÁMIDE
createButton("Create Pyramid", function()
    for i = 1, 5 do
        local block = Instance.new("Part")
        block.Shape = Enum.PartType.Block
        block.Material = Enum.Material.Neon
        block.BrickColor = BrickColor.new("Bright yellow")
        block.Size = Vector3.new(10 - (i * 2), 2, 10 - (i * 2))
        block.Position = HumanoidRootPart.Position + Vector3.new(0, i * 2, 0)
        block.CanCollide = false
        block.Parent = workspace
    end
    notify("✓ Pirámide creada")
end)

-- 27. CREAR FUENTE COLORIDA
createButton("Create Rainbow Fountain", function()
    local colors = {"Red", "Orange", "Yellow", "Lime green", "Cyan", "Blue", "Magenta"}
    for i, color in ipairs(colors) do
        local block = Instance.new("Part")
        block.Shape = Enum.PartType.Ball
        block.Material = Enum.Material.Neon
        block.BrickColor = BrickColor.new(color)
        block.Size = Vector3.new(2, 2, 2)
        block.Position = HumanoidRootPart.Position + Vector3.new(i * 3, 15, 0)
        block.CanCollide = false
        block.Parent = workspace
    end
    notify("✓ Fuente arcoíris creada")
end)

-- 28. CHAT SPAM (CUIDADO)
createButton("Say Message", function()
    LocalPlayer:Chat("¡Hola a todos!")
    notify("✓ Mensaje enviado")
end)

-- 29. DETECTOR DE BALAS
createButton("Bullet Shield", function()
    for _, part in ipairs(Character:FindDescendants()) do
        if part:IsA("BasePart") then
            part.CanCollide = false
        end
    end
    notify("✓ Escudo de balas activado")
end)

-- 30. TAMAÑO GRANDE
createButton("Become GIANT", function()
    for _, part in ipairs(Character:FindDescendants()) do
        if part:IsA("BasePart") then
            part.Size = part.Size * 2
        end
    end
    notify("✓ ¡Eres gigante!")
end)

-- 31. TAMAÑO PEQUEÑO
createButton("Become TINY", function()
    for _, part in ipairs(Character:FindDescendants()) do
        if part:IsA("BasePart") then
            part.Size = part.Size * 0.5
        end
    end
    notify("✓ ¡Eres pequeño!")
end)

-- 32. CAMBIAR COLOR
createButton("Change Color - RED", function()
    for _, part in ipairs(Character:FindDescendants()) do
        if part:IsA("BasePart") then
            part.Color = Color3.fromRGB(255, 0, 0)
        end
    end
    notify("✓ Color rojo")
end)

-- 33. CAMBIAR COLOR AZUL
createButton("Change Color - BLUE", function()
    for _, part in ipairs(Character:FindDescendants()) do
        if part:IsA("BasePart") then
            part.Color = Color3.fromRGB(0, 0, 255)
        end
    end
    notify("✓ Color azul")
end)

-- 34. CAMBIAR COLOR VERDE
createButton("Change Color - GREEN", function()
    for _, part in ipairs(Character:FindDescendants()) do
        if part:IsA("BasePart") then
            part.Color = Color3.fromRGB(0, 255, 0)
        end
    end
    notify("✓ Color verde")
end)

-- 35. BRILLO MÁXIMO
createButton("Max Brightness", function()
    for _, part in ipairs(Character:FindDescendants()) do
        if part:IsA("BasePart") then
            part.Material = Enum.Material.Neon
        end
    end
    notify("✓ Brillo máximo")
end)

-- 36. OSCURIDAD
createButton("Dark Mode", function()
    for _, part in ipairs(Character:FindDescendants()) do
        if part:IsA("BasePart") then
            part.Material = Enum.Material.SmoothPlastic
            part.Color = Color3.fromRGB(0, 0, 0)
        end
    end
    notify("✓ Modo oscuro")
end)

-- 37. CREAR EXPLOSIÓN
createButton("Create Explosion", function()
    local explosion = Instance.new("Explosion")
    explosion.Position = HumanoidRootPart.Position
    explosion.Parent = workspace
    notify("✓ Explosión creada")
end)

-- 38. LLUVIA DE BLOQUES
createButton("Block Rain", function()
    for i = 1, 10 do
        local block = Instance.new("Part")
        block.Shape = Enum.PartType.Block
        block.Material = Enum.Material.Brick
        block.BrickColor = BrickColor.new("Institutional white")
        block.Size = Vector3.new(5, 5, 5)
        block.Position = HumanoidRootPart.Position + Vector3.new(math.random(-20, 20), 50 + i * 10, math.random(-20, 20))
        block.CanCollide = true
        block.Parent = workspace
    end
    notify("✓ Lluvia de bloques iniciada")
end)

-- 39. CREAR DISCO
createButton("Create Disco Ball", function()
    local disco = Instance.new("Part")
    disco.Shape = Enum.PartType.Ball
    disco.Material = Enum.Material.Neon
    disco.BrickColor = BrickColor.new("Medium stone grey")
    disco.Size = Vector3.new(10, 10, 10)
    disco.Position = HumanoidRootPart.Position + Vector3.new(0, 20, 0)
    disco.CanCollide = false
    disco.Parent = workspace
    notify("✓ Bola de discoteca creada")
end)

-- 40. VISTA EN PRIMERA PERSONA
createButton("First Person View", function()
    local camera = workspace.CurrentCamera
    camera.CFrame = HumanoidRootPart.CFrame + HumanoidRootPart.CFrame.LookVector * 5
    notify("✓ Vista FPS activada")
end)

-- 41. VISTA EN TERCERA PERSONA
createButton("Third Person View", function()
    local camera = workspace.CurrentCamera
    camera.CFrame = HumanoidRootPart.CFrame - HumanoidRootPart.CFrame.LookVector * 10
    notify("✓ Vista de tercera persona")
end)

-- 42. MODO OBSERVADOR
createButton("Observer Mode", function()
    Humanoid.HealthDisplayDistance = 0
    Humanoid.NameDisplayDistance = 0
    notify("✓ Modo observador")
end)

-- 43. SALTO INFINITO
createButton("Infinite Jump", function()
    UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if gameProcessed then return end
        if input.KeyCode == Enum.KeyCode.Space then
            Humanoid:Jump()
        end
    end)
    notify("✓ Salto infinito activado")
end)

-- 44. CREAR TELETRANSPORTADOR
createButton("Create Teleporter Pad", function()
    local pad = Instance.new("Part")
    pad.Shape = Enum.PartType.Block
    pad.Material = Enum.Material.Neon
    pad.BrickColor = BrickColor.new("Cyan")
    pad.Size = Vector3.new(10, 1, 10)
    pad.Position = HumanoidRootPart.Position + Vector3.new(0, -5, 0)
    pad.CanCollide = true
    pad.Parent = workspace
    notify("✓ Plataforma teletransportadora creada")
end)

-- 45. ESPEJO
createButton("Create Mirror", function()
    local mirror = Instance.new("Part")
    mirror.Shape = Enum.PartType.Block
    mirror.Material = Enum.Material.Glass
    mirror.Transparency = 0.3
    mirror.Size = Vector3.new(8, 10, 0.5)
    mirror.Position = HumanoidRootPart.Position + Vector3.new(0, 0, -5)
    mirror.CanCollide = true
    mirror.Parent = workspace
    notify("✓ Espejo creado")
end)

-- 46. MOSTRAR INFO DEL JUEGO
createButton("Game Info", function()
    print("\n=== INFORMACIÓN DEL JUEGO ===")
    print("Juego: " .. game.Name)
    print("Lugar: " .. workspace.Name)
    print("Jugadores: " .. #Players:GetPlayers())
    print("================================\n")
end)

-- 47. RESETEAR COMANDOS
createButton("Reset All Settings", function()
    states.godMode = false
    states.noclip = false
    states.flyMode = false
    states.spin = false
    states.invisible = false
    states.speedBoost = false
    Humanoid.WalkSpeed = 16
    for _, part in ipairs(Character:FindDescendants()) do
        if part:IsA("BasePart") then
            part.CanCollide = true
            part.Transparency = 0
        end
    end
    notify("✓ Todos los comandos reseteados")
end)

-- 48. GUARDAR POSICIÓN
local savedPosition = nil
createButton("Save Position", function()
    savedPosition = HumanoidRootPart.CFrame
    notify("✓ Posición guardada")
end)

-- 49. IR A POSICIÓN GUARDADA
createButton("Load Position", function()
    if savedPosition then
        HumanoidRootPart.CFrame = savedPosition
        notify("✓ Posición cargada")
    else
        notify("✗ No hay posición guardada")
    end
end)

-- 50. INFORMACIÓN DETALLADA
createButton("Detailed Stats", function()
    local pos = HumanoidRootPart.Position
    print("\n=== ESTADÍSTICAS DETALLADAS ===")
    print("Posición: X=" .. math.floor(pos.X) .. " Y=" .. math.floor(pos.Y) .. " Z=" .. math.floor(pos.Z))
    print("Salud: " .. math.floor(Humanoid.Health) .. "/" .. math.floor(Humanoid.MaxHealth))
    print("Velocidad: " .. Humanoid.WalkSpeed)
    print("Poder de Salto: " .. Humanoid.JumpPower)
    print("================================\n")
end)

-- ========== CERRAR MENÚ ==========
closeBtn.MouseButton1Click:Connect(function()
    screenGui:Destroy()
end)

-- ========== TECLA PARA MOSTRAR/OCULTAR ==========
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.M then
        mainFrame.Visible = not mainFrame.Visible
    end
end)

-- ========== MOVER MENÚ ==========
local dragging = false
local dragInput = nil
local dragStart = nil
local startPos = nil

titleBar.InputBegan:Connect(function(input, gameProcessed)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = mainFrame.Position
    end
end)

UserInputService.InputChanged:Connect(function(input, gameProcessed)
    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = input.Position - dragStart
        mainFrame.Position = startPos + UDim2.new(0, delta.X, 0, delta.Y)
    end
end)

UserInputService.InputEnded:Connect(function(input, gameProcessed)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = false
    end
end)

-- ========== INICIALIZACIÓN ==========
print("✓ Script de menú cargado")
print("✓ Presiona M para mostrar/ocultar el menú")
print("✓ Arrastra el menú desde la barra de título")
print("✓ 50+ opciones disponibles")
