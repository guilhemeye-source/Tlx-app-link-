--// Free Kailruis - Versão Melhorada
--// Aviso: Para uso apenas em jogos próprios e ambientes de teste!
--// O uso em servidores públicos viola os Termos de Serviço da Roblox

-- Serviços
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local StarterGui = game:GetService("StarterGui")
local TweenService = game:GetService("TweenService")

-- Constantes
local GUI_NAME = "FreeKailruisHub"
local COLORS = {
    Primary = Color3.fromRGB(14, 14, 20),
    Secondary = Color3.fromRGB(28, 28, 38),
    Accent = Color3.fromRGB(255, 70, 180),
    AccentLight = Color3.fromRGB(255, 120, 200),
    Danger = Color3.fromRGB(255, 70, 70),
    Success = Color3.fromRGB(70, 255, 120),
    Warning = Color3.fromRGB(255, 190, 40),
    White = Color3.new(1, 1, 1),
    Gray = Color3.fromRGB(160, 160, 180)
}
local FOV_SIZE = 180

-- Estado
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
local Camera = workspace.CurrentCamera

local Features = {
    Aimbot = false,
    FOV = false,
    ESP = false,
    Noclip = false,
    Wallshot = false,
    BotTarget = false
}

-- Limpar GUI antiga
local function CleanupOldGui()
    local oldGui = PlayerGui:FindFirstChild(GUI_NAME)
    if oldGui then oldGui:Destroy() end
end

-- Notificação simples
local function Notify(title, msg)
    pcall(function()
        StarterGui:SetCore("SendNotification", {
            Title = title,
            Text = msg,
            Duration = 3
        })
    end)
end

-- Criar elemento com cantos arredondados + opcional sombra
local function CreateRoundedInstance(className, properties, cornerRadius, hasShadow)
    cornerRadius = cornerRadius or UDim.new(0, 10)
    local instance = Instance.new(className)
    for prop, value in pairs(properties) do
        instance[prop] = value
    end
    local corner = Instance.new("UICorner")
    corner.CornerRadius = cornerRadius
    corner.Parent = instance

    if hasShadow then
        local shadow = Instance.new("UIStroke")
        shadow.Thickness = 1
        shadow.Transparency = 0.85
        shadow.Color = COLORS.Accent
        shadow.Parent = instance
    end

    return instance
end

-- Tween suave de cor
local function TweenColor(obj, prop, color, duration)
    local tween = TweenService:Create(obj, TweenInfo.new(duration or 0.15), {[prop] = color})
    tween:Play()
end

-- Criar GUI principal
local function CreateGui()
    CleanupOldGui()

    local Gui = Instance.new("ScreenGui")
    Gui.Name = GUI_NAME
    Gui.ResetOnSpawn = false
    Gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    Gui.Parent = PlayerGui

    -- Painel com sombra
    local Panel = CreateRoundedInstance("Frame", {
        Size = UDim2.fromOffset(260, 400),
        Position = UDim2.new(0.5, -130, 0.5, -200),
        BackgroundColor3 = COLORS.Primary,
        BorderSizePixel = 0,
        Parent = Gui
    }, UDim.new(0, 16), true)

    -- Sombra externa
    local Shadow = Instance.new("UIStroke")
    Shadow.Thickness = 2
    Shadow.Transparency = 0.9
    Shadow.Color = COLORS.Accent
    Shadow.Parent = Panel

    -- Barra superior degradê
    local TopBar = CreateRoundedInstance("Frame", {
        Size = UDim2.new(1, 0, 0, 55),
        Position = UDim2.fromOffset(0, 0),
        BackgroundColor3 = COLORS.Secondary,
        Parent = Panel
    }, UDim.new(0, 16))

    local TopBarCorner = Instance.new("UICorner")
    TopBarCorner.CornerRadius = UDim.new(0, 16)
    TopBarCorner.Parent = TopBar

    local TopBarMask = Instance.new("Frame")
    TopBarMask.Size = UDim2.new(1, 0, 1, 0)
    TopBarMask.BackgroundColor3 = COLORS.Secondary
    TopBarMask.ClipsDescendants = true
    TopBarMask.Parent = Panel

    local TopBar2 = CreateRoundedInstance("Frame", {
        Size = UDim2.new(1, 0, 0, 55),
        Position = UDim2.fromOffset(0, 0),
        BackgroundColor3 = COLORS.Secondary,
        Parent = TopBarMask
    }, UDim.new(0, 16))

    -- Título
    local Title = Instance.new("TextLabel")
    Title.Size = UDim2.new(1, -50, 0, 55)
    Title.Position = UDim2.fromOffset(20, 0)
    Title.BackgroundTransparency = 1
    Title.Text = "✨ FREE KAILRUIS"
    Title.TextColor3 = COLORS.Accent
    Title.TextSize = 20
    Title.Font = Enum.Font.GothamBold
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.Parent = Panel

    -- Botão minimizar
    local Minimize = Instance.new("TextButton")
    Minimize.Size = UDim2.fromOffset(35, 35)
    Minimize.Position = UDim2.new(1, -42, 0, 10)
    Minimize.BackgroundTransparency = 1
    Minimize.Text = "−"
    Minimize.TextColor3 = COLORS.White
    Minimize.TextSize = 28
    Minimize.AutoButtonColor = false
    Minimize.Parent = Panel

    -- Botão de restaurar (bolinha flutuante)
    local MiniButton = CreateRoundedInstance("TextButton", {
        Size = UDim2.fromOffset(62, 62),
        Position = UDim2.new(0, 20, 0.5, -31),
        BackgroundColor3 = COLORS.Accent,
        Text = "⚙",
        TextColor3 = COLORS.White,
        TextSize = 26,
        Visible = false,
        Parent = Gui
    }, UDim.new(1, 0))

    -- Criador de botões de feature estilizado
    local function CreateFeatureButton(icon, name, yPos)
        local btn = CreateRoundedInstance("TextButton", {
            Size = UDim2.new(1, -40, 0, 46),
            Position = UDim2.fromOffset(20, yPos),
            BackgroundColor3 = COLORS.Secondary,
            Text = icon .. "  " .. name .. "        ❌ OFF",
            TextColor3 = COLORS.Gray,
            TextSize = 15,
            Font = Enum.Font.GothamBold,
            AutoButtonColor = false,
            Parent = Panel
        }, UDim.new(0, 12))

        -- Efeito hover
        btn.MouseEnter:Connect(function()
            if not Features[name] then
                TweenColor(btn, "BackgroundColor3", Color3.fromRGB(38, 38, 50))
            end
        end)
        btn.MouseLeave:Connect(function()
            if not Features[name] then
                TweenColor(btn, "BackgroundColor3", COLORS.Secondary)
            end
        end)

        return btn
    end

    -- Botões com ícones
    local Buttons = {
        Aimbot = CreateFeatureButton("🎯", "Aimbot", 65),
        FOV = CreateFeatureButton("👁", "FOV", 121),
        ESP = CreateFeatureButton("👥", "ESP", 177),
        Noclip = CreateFeatureButton("👻", "Noclip", 233),
        Wallshot = CreateFeatureButton("🔫", "Wallshot", 289),
        BotTarget = CreateFeatureButton("🤖", "Bot Target", 345)
    }

    -- Círculo de FOV
    local FovCircle = Instance.new("Frame")
    FovCircle.Size = UDim2.fromOffset(FOV_SIZE, FOV_SIZE)
    FovCircle.AnchorPoint = Vector2.new(0.5, 0.5)
    FovCircle.Position = UDim2.fromScale(0.5, 0.5)
    FovCircle.BackgroundTransparency = 1
    FovCircle.Visible = false
    FovCircle.Parent = Gui

    local FovCorner = Instance.new("UICorner")
    FovCorner.CornerRadius = UDim.new(1, 0)
    FovCorner.Parent = FovCircle

    local FovStroke = Instance.new("UIStroke")
    FovStroke.Thickness = 2
    FovStroke.Color = COLORS.Accent
    FovStroke.Parent = FovCircle

    -- Alternar estado do botão
    local function ToggleFeature(name)
        Features[name] = not Features[name]
        local StateIcon = Features[name] and "✅ ON" or "❌ OFF"
        local TextColor = Features[name] and COLORS.White or COLORS.Gray
        local BgColor = Features[name] and COLORS.Accent or COLORS.Secondary

        local BaseName = string.match(Buttons[name].Text, "  (%w+%s?%w*)%s+[✅❌]") or name
        Buttons[name].Text = string.format("%s  %s        %s", string.match(Buttons[name].Text, "^[^ ]+"), BaseName, StateIcon)
        TweenColor(Buttons[name], "BackgroundColor3", BgColor)
        Buttons[name].TextColor3 = TextColor
        return Features[name]
    end

    -- ========== FUNÇÃO NOCLIP APRIMORADA ==========
    local function RefreshNoclip()
        local Character = LocalPlayer.Character
        if not Character then return end
        
        -- Processa todas as partes
        local function UpdateParts()
            for _, Part in ipairs(Character:GetDescendants()) do
                if Part:IsA("BasePart") then
                    Part.CanCollide = not Features.Noclip
                    -- Opcional: deixa invisível a colisão visualmente
                    if Features.Noclip then
                        Part.Transparency = Part.Transparency < 0.5 and 0.5 or Part.Transparency
                    end
                end
            end
        end
        
        UpdateParts()
        
        -- Reaplica ao respawnar
        Character.DescendantAdded:Connect(function(desc)
            if desc:IsA("BasePart") and Features.Noclip then
                desc.CanCollide = false
            end
        end)
    end

    RunService.Stepped:Connect(function()
        if Features.Noclip then RefreshNoclip() end
    end)

    LocalPlayer.CharacterAdded:Connect(function(Char)
        task.wait(0.3)
        if Features.Noclip then RefreshNoclip() end
    end)

    -- ========== RESTO DAS FEATURES ==========

    -- ESP
    local function UpdateESP()
        for _, Player in ipairs(Players:GetPlayers()) do
            if Player == LocalPlayer then continue end
            local Character = Player.Character
            if not Character then continue end

            local Highlight = Character:FindFirstChild("ESP_Highlight")
            if Features.ESP and not Highlight then
                Highlight = Instance.new("Highlight")
                Highlight.Name = "ESP_Highlight"
                Highlight.FillTransparency = 0.7
                Highlight.OutlineTransparency = 0
                Highlight.FillColor = COLORS.Danger
                Highlight.Parent = Character
            elseif not Features.ESP and Highlight then
                Highlight:Destroy()
            end
        end
    end

    Players.PlayerAdded:Connect(function(plr)
        plr.CharacterAdded:Connect(function()
            task.wait(0.3)
            UpdateESP()
        end)
    end)

    -- Aimbot
    local function GetClosestTarget()
        local BestTarget, BestDist = nil, math.huge
        local ScreenCenter = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)

        for _, Player in ipairs(Players:GetPlayers()) do
            if Player == LocalPlayer then continue end
            local Character = Player.Character
            if not Character then continue end
            local Humanoid = Character:FindFirstChildOfClass("Humanoid")
            local Root = Character:FindFirstChild("HumanoidRootPart")
            if not Humanoid or not Root or Humanoid.Health <= 0 then continue end

            local Pos, OnScreen = Camera:WorldToViewportPoint(Root.Position)
            if OnScreen then
                local Dist = (Vector2.new(Pos.X, Pos.Y) - ScreenCenter).Magnitude
                if Dist < BestDist then
                    BestDist, BestTarget = Dist, Root
                end
            end
        end
        return BestTarget
    end

    RunService.RenderStepped:Connect(function()
        if Features.Aimbot then
            local Target = GetClosestTarget()
            if Target then
                Camera.CFrame = CFrame.lookAt(Camera.CFrame.Position, Target.Position)
            end
        end
    end)

    -- Bot Target
    local CurrentBotHighlight = nil

    local function ClearBotTarget()
        if CurrentBotHighlight then
            CurrentBotHighlight:Destroy()
            CurrentBotHighlight = nil
        end
    end

    local function FindNearestBot()
        local Character = LocalPlayer.Character
        if not Character then return end
        local MyRoot = Character:FindFirstChild("HumanoidRootPart")
        if not MyRoot then return end

        local NearestBot, NearestDist = nil, math.huge

        for _, Obj in ipairs(workspace:GetDescendants()) do
            if not Obj:IsA("Model") or Obj == Character then continue end
            local Humanoid = Obj:FindFirstChildOfClass("Humanoid")
            local Root = Obj:FindFirstChild("HumanoidRootPart")
            if not Humanoid or not Root 
                or Humanoid.Health <= 0 
                or Players:GetPlayerFromCharacter(Obj) then continue end

            local Dist = (Root.Position - MyRoot.Position).Magnitude
            if Dist < NearestDist then
                NearestDist, NearestBot = Dist, Obj
            end
        end
        return NearestBot
    end

    local function UpdateBotTarget()
        ClearBotTarget()
        if not Features.BotTarget then return end
        local Bot = FindNearestBot()
        if Bot then
            CurrentBotHighlight = Instance.new("Highlight")
            CurrentBotHighlight.Name = "BotTarget_Highlight"
            CurrentBotHighlight.FillTransparency = 0.65
            CurrentBotHighlight.OutlineTransparency = 0
            CurrentBotHighlight.FillColor = COLORS.Warning
            CurrentBotHighlight.Parent = Bot
        end
    end

    task.spawn(function()
        while Gui:IsDescendantOf(game) do
            if Features.BotTarget then UpdateBotTarget() end
            task.wait(0.5)
        end
    end)

    -- ========== LIGAÇÃO DOS BOTÕES ==========

    Buttons.Aimbot.MouseButton1Click:Connect(function() ToggleFeature("Aimbot") end)

    Buttons.FOV.MouseButton1Click:Connect(function()
        local Enabled = ToggleFeature("FOV")
        FovCircle.Visible = Enabled
    end)

    Buttons.ESP.MouseButton1Click:Connect(function()
        ToggleFeature("ESP")
        UpdateESP()
    end)

    Buttons.Noclip.MouseButton1Click:Connect(function()
        ToggleFeature("Noclip")
        RefreshNoclip()
        Notify("👻 Noclip", Features.Noclip and "Ativado — atravessa paredes!" or "Desativado")
    end)

    Buttons.Wallshot.MouseButton1Click:Connect(function()
        ToggleFeature("Wallshot")
        Notify("Aviso", "Wallshot é apenas visual — sem efeito real")
    end)

    Buttons.BotTarget.MouseButton1Click:Connect(function()
        ToggleFeature("BotTarget")
        if Features.BotTarget then UpdateBotTarget() else ClearBotTarget() end
    end)

    -- Minimizar/Restaurar com animação
    Minimize.MouseButton1Click:Connect(function()
        Panel.Visible = false
        MiniButton.Visible = true
    end)

    MiniButton.MouseButton1Click:Connect(function()
        Panel.Visible = true
        MiniButton.Visible = false
    end)

    Notify(GUI_NAME, "Carregado com sucesso! ✨")
end

-- Iniciar com proteção contra erros
task.spawn(function()
    local Success, Err = pcall(CreateGui)
    if not Success then
        warn("Erro ao carregar GUI:", Err)
    end
end)
