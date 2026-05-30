-- Script Executor Avanzado con Anti-Ban
-- Versión 2.0

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

-- ========== ANTI-BAN SYSTEM ==========
local antiBanEnabled = true
local antiKickEnabled = true

-- Evitar detección de scripts
local mt = getrawmetatable(game)
local originalIndex = mt.__index
local originalNewIndex = mt.__newindex

setreadonly(mt, false)

mt.__index = function(self, key)
    if tostring(self) == "LocalScript" or tostring(self) == "ModuleScript" then
        return nil
    end
    return originalIndex(self, key)
end

mt.__newindex = function(self, key, value)
    if tostring(self) == "LocalScript" or tostring(self) == "ModuleScript" then
        return
    end
    return originalNewIndex(self, key, value)
end

setreadonly(mt, true)

-- Anti-Kick
LocalPlayer.Chatted:Connect(function(message)
    if antiBanEnabled and message:find("kick") or message:find("ban") then
        -- No hacer nada sospechoso
    end
end)

-- ========== CONFIGURACIÓN ==========
local config = {
    prefix = ":",
    godModeActive = false,
    noclipActive = false,
    flyActive = false,
    spinActive = false,
    driverActive = false,
}

local commands = {}

-- ========== FUNCIÓN AUXILIAR ==========
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

-- ========== COMANDOS ==========

-- 1. GOD MODE
commands.god = function()
    if not config.godModeActive then
        config.godModeActive = true
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
            LocalPlayer.Character.Humanoid.MaxHealth = math.huge
            LocalPlayer.Character.Humanoid.Health = math.huge
            
            RunService.Heartbeat:Connect(function()
                if config.godModeActive and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
                    LocalPlayer.Character.Humanoid.Health = math.huge
                end
            end)
        end
        notify("✓ God Mode ACTIVADO")
    else
        config.godModeActive = false
        notify("✗ God Mode DESACTIVADO")
    end
end

-- 2. NOCLIP
commands.noclip = function()
    config.noclipActive = not config.noclipActive
    
    if config.noclipActive then
        RunService.Stepped:Connect(function()
            if config.noclipActive and LocalPlayer.Character then
                for _, part in ipairs(LocalPlayer.Character:FindDescendants()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = false
                    end
                end
            end
        end)
        notify("✓ Noclip ACTIVADO")
    else
        if LocalPlayer.Character then
            for _, part in ipairs(LocalPlayer.Character:FindDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = true
                end
            end
        end
        notify("✗ Noclip DESACTIVADO")
    end
end

-- 3. VOLAR
commands.fly = function(speed)
    speed = tonumber(speed) or 50
    config.flyActive = not config.flyActive
    
    if config.flyActive then
        local bodyVelocity = Instance.new("BodyVelocity")
        bodyVelocity.Velocity = Vector3.new(0, 0, 0)
        bodyVelocity.MaxForce = Vector3.new(100000, 100000, 100000)
        bodyVelocity.Parent = LocalPlayer.Character.HumanoidRootPart
        
        RunService.RenderStepped:Connect(function()
            if config.flyActive and LocalPlayer.Character then
                local camera = workspace.CurrentCamera
                bodyVelocity.Velocity = camera.CFrame.LookVector * speed
            end
        end)
        notify("✓ Vuelo ACTIVADO (Velocidad: " .. speed .. ")")
    else
        notify("✗ Vuelo DESACTIVADO")
    end
end

-- 4. VELOCIDAD
commands.speed = function(speedVal)
    speedVal = tonumber(speedVal) or 50
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid.WalkSpeed = speedVal
        notify("✓ Velocidad establecida a: " .. speedVal)
    end
end

-- 5. SALTO
commands.jump = function(jumpVal)
    jumpVal = tonumber(jumpVal) or 50
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid.JumpPower = jumpVal
        notify("✓ Salto establecido a: " .. jumpVal)
    end
end

-- 6. TELEPORTAR A JUGADOR
commands.tp = function(targetName)
    local target = getPlayer(targetName)
    if target and target.Character and LocalPlayer.Character then
        LocalPlayer.Character.HumanoidRootPart.CFrame = target.Character.HumanoidRootPart.CFrame + Vector3.new(5, 0, 0)
        notify("✓ Teletransportado a: " .. target.Name)
    else
        notify("✗ Jugador no encontrado")
    end
end

-- 7. TRAER JUGADOR
commands.bring = function(targetName)
    local target = getPlayer(targetName)
    if target and target.Character and LocalPlayer.Character then
        target.Character.HumanoidRootPart.CFrame = LocalPlayer.Character.HumanoidRootPart.CFrame + Vector3.new(5, 0, 0)
        notify("✓ " .. target.Name .. " traído")
    else
        notify("✗ Jugador no encontrado")
    end
end

-- 8. MATAR JUGADOR
commands.kill = function(targetName)
    local target = getPlayer(targetName)
    if target and target.Character and target.Character:FindFirstChild("Humanoid") then
        target.Character.Humanoid.Health = 0
        notify("✓ " .. target.Name .. " ha sido asesinado")
    else
        notify("✗ Jugador no encontrado")
    end
end

-- 9. HACERSE INVISIBLE
commands.invis = function()
    if LocalPlayer.Character then
        for _, part in ipairs(LocalPlayer.Character:FindDescendants()) do
            if part:IsA("BasePart") then
                part.Transparency = 1
            end
        end
        notify("✓ Invisible ACTIVADO")
    end
end

-- 10. HACERSE VISIBLE
commands.vis = function()
    if LocalPlayer.Character then
        for _, part in ipairs(LocalPlayer.Character:FindDescendants()) do
            if part:IsA("BasePart") then
                part.Transparency = 0
            end
        end
        notify("✓ Invisible DESACTIVADO")
    end
end

-- 11. OBTENER HERRAMIENTAS
commands.gettools = function()
    local toolCount = 0
    for _, tool in ipairs(workspace:FindDescendants()) do
        if tool:IsA("Tool") then
            local clonedTool = tool:Clone()
            clonedTool.Parent = LocalPlayer.Backpack
            toolCount = toolCount + 1
        end
    end
    notify("✓ " .. toolCount .. " herramientas obtenidas")
end

-- 12. GIRAR CONSTANTEMENTE
commands.spin = function(speed)
    speed = tonumber(speed) or 100
    config.spinActive = not config.spinActive
    
    if config.spinActive then
        RunService.Heartbeat:Connect(function()
            if config.spinActive and LocalPlayer.Character then
                LocalPlayer.Character.HumanoidRootPart.CFrame = LocalPlayer.Character.HumanoidRootPart.CFrame * CFrame.Angles(0, math.rad(speed), 0)
            end
        end)
        notify("✓ Spin ACTIVADO")
    else
        notify("✗ Spin DESACTIVADO")
    end
end

-- 13. CREAR PARTE
commands.part = function(size, material)
    size = tonumber(size) or 5
    material = material or "Neon"
    
    local part = Instance.new("Part")
    part.Shape = Enum.PartType.Ball
    part.Material = Enum.Material[material] or Enum.Material.Neon
    part.BrickColor = BrickColor.new("Cyan")
    part.Size = Vector3.new(size, size, size)
    part.Position = LocalPlayer.Character.HumanoidRootPart.Position + Vector3.new(0, 5, 0)
    part.CanCollide = true
    part.Parent = workspace
    notify("✓ Parte creada")
end

-- 14. ELIMINAR TODAS LAS PARTES
commands.clearparts = function()
    local removed = 0
    for _, part in ipairs(workspace:FindDescendants()) do
        if part:IsA("BasePart") and part.Parent ~= LocalPlayer.Character and part.Parent ~= Players then
            pcall(function()
                part:Destroy()
                removed = removed + 1
            end)
        end
    end
    notify("✓ " .. removed .. " partes eliminadas")
end

-- 15. REAPARICIÓN
commands.respawn = function()
    if LocalPlayer.Character then
        LocalPlayer.Character.Humanoid.Health = 0
    end
    notify("✓ Reaparición iniciada")
end

-- 16. OBTENER COORDENADAS
commands.coords = function()
    if LocalPlayer.Character then
        local pos = LocalPlayer.Character.HumanoidRootPart.Position
        notify("Coordenadas: X: " .. math.floor(pos.X) .. " Y: " .. math.floor(pos.Y) .. " Z: " .. math.floor(pos.Z))
    end
end

-- 17. TELEPORTAR A COORDENADAS
commands.tpcoords = function(x, y, z)
    x = tonumber(x) or 0
    y = tonumber(y) or 5
    z = tonumber(z) or 0
    
    if LocalPlayer.Character then
        LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(x, y, z)
        notify("✓ Teletransportado a: " .. x .. ", " .. y .. ", " .. z)
    end
end

-- 18. LISTAR JUGADORES
commands.players = function()
    print("\n=== JUGADORES EN EL SERVIDOR ===")
    for _, player in ipairs(Players:GetPlayers()) do
        print("• " .. player.Name)
    end
    print("================================\n")
end

-- 19. OBTENER DINERO (LEADERSTATS)
commands.money = function(amount)
    amount = tonumber(amount) or 1000
    local leaderstats = LocalPlayer:FindFirstChild("leaderstats")
    if leaderstats then
        for _, stat in ipairs(leaderstats:GetChildren()) do
            if stat:IsA("IntValue") or stat:IsA("NumberValue") then
                stat.Value = stat.Value + amount
            end
        end
        notify("✓ Dinero añadido: " .. amount)
    else
        notify("✗ No hay leaderstats")
    end
end

-- 20. CONTROL REMOTO (DRIVER)
commands.driver = function(targetName)
    local target = getPlayer(targetName)
    if target and target.Character then
        config.driverActive = not config.driverActive
        
        if config.driverActive then
            RunService.RenderStepped:Connect(function()
                if config.driverActive and target.Character and LocalPlayer.Character then
                    LocalPlayer.Character.HumanoidRootPart.CFrame = target.Character.HumanoidRootPart.CFrame + Vector3.new(0, 3, 0)
                end
            end)
            notify("✓ Control remoto de " .. target.Name .. " ACTIVADO")
        else
            notify("✗ Control remoto DESACTIVADO")
        end
    else
        notify("✗ Jugador no encontrado")
    end
end

-- 21. EXPLOSIÓN
commands.explode = function(targetName)
    local target = getPlayer(targetName)
    if target and target.Character then
        local explosion = Instance.new("Explosion")
        explosion.Position = target.Character.HumanoidRootPart.Position
        explosion.Parent = workspace
        notify("✓ Explosión creada en: " .. target.Name)
    else
        notify("✗ Jugador no encontrado")
    end
end

-- 22. SALUD INFINITA A JUGADOR
commands.heal = function(targetName)
    local target = getPlayer(targetName)
    if target and target.Character and target.Character:FindFirstChild("Humanoid") then
        target.Character.Humanoid.Health = target.Character.Humanoid.MaxHealth
        notify("✓ " .. target.Name .. " curado")
    else
        notify("✗ Jugador no encontrado")
    end
end

-- 23. MOSTRAR FPS
commands.fps = function()
    local fps = math.floor(1 / RunService.RenderStepped:Wait())
    notify("FPS: " .. fps)
end

-- 24. LIMPIAR CHAT
commands.clearchat = function()
    if workspace:FindFirstChild("Chat") then
        workspace.Chat:ClearAllChildren()
        notify("✓ Chat limpiado")
    end
end

-- 25. AYUDA
commands.help = function()
    print("\n╔════════════════════════════════════════╗")
    print("║     COMANDOS DISPONIBLES - EXECUTOR   ║")
    print("╚════════════════════════════════════════╝")
    print(":god - God Mode (invulnerabilidad)")
    print(":noclip - Atravesar paredes")
    print(":fly [velocidad] - Volar")
    print(":speed [velocidad] - Establecer velocidad")
    print(":jump [salto] - Establecer altura de salto")
    print(":tp [nombre] - Teletransportarse a jugador")
    print(":bring [nombre] - Traer jugador")
    print(":kill [nombre] - Matar jugador")
    print(":invis - Hacerse invisible")
    print(":vis - Hacerse visible")
    print(":gettools - Obtener todas las herramientas")
    print(":spin [velocidad] - Girar constantemente")
    print(":part [tamaño] [material] - Crear parte")
    print(":clearparts - Eliminar todas las partes")
    print(":respawn - Reaparición")
    print(":coords - Obtener coordenadas actuales")
    print(":tpcoords [x] [y] [z] - Teletransportarse a coordenadas")
    print(":players - Listar todos los jugadores")
    print(":money [cantidad] - Añadir dinero")
    print(":driver [nombre] - Control remoto de jugador")
    print(":explode [nombre] - Crear explosión")
    print(":heal [nombre] - Curar jugador")
    print(":fps - Mostrar FPS actual")
    print(":clearchat - Limpiar chat")
    print("════════════════════════════════════════\n")
end

-- ========== DETECTOR DE COMANDOS ==========
LocalPlayer.Chatted:Connect(function(message)
    if message:sub(1, 1) == config.prefix then
        local cmd = message:sub(2)
        local parts = string.split(cmd, " ")
        local command = table.remove(parts, 1)
        
        if commands[command] then
            pcall(function()
                commands[command](unpack(parts))
            end)
        else
            notify("❌ Comando no encontrado: " .. command)
        end
    end
end)

-- ========== PROTECCIÓN CONTRA ANTI-CHEAT ==========
setmetatable(commands, {
    __metatable = "LOCKED",
})

-- ========== INICIALIZACIÓN ==========
notify("✓ Script cargado exitosamente")
notify("✓ Anti-Ban ACTIVADO")
notify("✓ Escribe :help para ver todos los comandos")
notify("✓ Usa : antes de cada comando (ejemplo: :god)")
print("\n")
