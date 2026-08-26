--!strict
-- MEU HUB - SEU PRÓPRIO JOGO
-- AIM + ESP + SPEED + JUMP + FOV + AUTO KILL NPC
-- Botão bolinha para minimizar

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")

-- CONFIG
local Speed = 16
local JumpPower = 50
local ESPEnabled = false
local AimEnabled = false
local AutoKillNPC = false
local FOVSize = 120

-- LIMPAR HUB ANTIGO
local Old = PlayerGui:FindFirstChild("MeuHub")
if Old then
    Old:Destroy()
end

-- GUI
local Gui = Instance.new("ScreenGui")
Gui.Name = "MeuHub"
Gui.ResetOnSpawn = false
Gui.Parent = PlayerGui

-- =========================
-- PAINEL PRINCIPAL
-- =========================

local Main = Instance.new("Frame")
Main.Name = "Main"
Main.Size = UDim2.fromOffset(290, 410)
Main.Position = UDim2.fromScale(0.5, 0.5)
Main.AnchorPoint = Vector2.new(0.5, 0.5)
Main.BackgroundTransparency = 0.08
Main.Parent = Gui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 16)
MainCorner.Parent = Main

local MainStroke = Instance.new("UIStroke")
MainStroke.Thickness = 2
MainStroke.Parent = Main

-- TÍTULO
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -80, 0, 45)
Title.Position = UDim2.fromOffset(40, 5)
Title.BackgroundTransparency = 1
Title.Text = "⚡ MEU HUB"
Title.TextScaled = true
Title.Font = Enum.Font.GothamBold
Title.Parent = Main

-- =========================
-- BOTÃO DE MINIMIZAR
-- =========================

local MinimizeButton = Instance.new("TextButton")
MinimizeButton.Size = UDim2.fromOffset(35, 35)
MinimizeButton.Position = UDim2.new(1, -40, 0, 8)
MinimizeButton.Text = "—"
MinimizeButton.TextScaled = true
MinimizeButton.Font = Enum.Font.GothamBold
MinimizeButton.Parent = Main

local MinCorner = Instance.new("UICorner")
MinCorner.CornerRadius = UDim.new(1, 0)
MinCorner.Parent = MinimizeButton

-- =========================
-- BOLINHA
-- =========================

local MiniButton = Instance.new("TextButton")
MiniButton.Name = "MiniButton"
MiniButton.Size = UDim2.fromOffset(58, 58)
MiniButton.Position = UDim2.new(0, 20, 0.5, 0)
MiniButton.AnchorPoint = Vector2.new(0, 0.5)
MiniButton.Text = "⚡"
MiniButton.TextScaled = true
MiniButton.Font = Enum.Font.GothamBold
MiniButton.Visible = false
MiniButton.Parent = Gui

local MiniCorner = Instance.new("UICorner")
MiniCorner.CornerRadius = UDim.new(1, 0)
MiniCorner.Parent = MiniButton

local MiniStroke = Instance.new("UIStroke")
MiniStroke.Thickness = 2
MiniStroke.Parent = MiniButton

-- =========================
-- CRIAR BOTÃO
-- =========================

local function CreateButton(Text, Y)

    local Button = Instance.new("TextButton")

    Button.Size = UDim2.new(1, -30, 0, 40)
    Button.Position = UDim2.fromOffset(15, Y)
    Button.BackgroundTransparency = 0.05
    Button.Text = Text
    Button.TextScaled = true
    Button.Font = Enum.Font.GothamBold
    Button.Parent = Main

    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 10)
    Corner.Parent = Button

    return Button
end

-- =========================
-- BOTÕES
-- =========================

local AimButton =
    CreateButton("🎯 AIM ASSIST: OFF", 55)

local ESPButton =
    CreateButton("👁️ ESP: OFF", 105)

local SpeedButton =
    CreateButton("🏃 VELOCIDADE: 16", 155)

local JumpButton =
    CreateButton("🦘 PULO: 50", 205)

local FOVButton =
    CreateButton("⭕ FOV: 120", 255)

local AutoKillButton =
    CreateButton("☠️ AUTO KILL NPC: OFF", 305)

local CloseButton =
    CreateButton("✖ FECHAR", 355)

-- =========================
-- MINIMIZAR
-- =========================

MinimizeButton.MouseButton1Click:Connect(function()

    Main.Visible = false
    MiniButton.Visible = true

end)

MiniButton.MouseButton1Click:Connect(function()

    Main.Visible = true
    MiniButton.Visible = false

end)

-- =========================
-- AIM
-- =========================

AimButton.MouseButton1Click:Connect(function()

    AimEnabled = not AimEnabled

    AimButton.Text =
        AimEnabled
        and "🎯 AIM ASSIST: ON"
        or "🎯 AIM ASSIST: OFF"

end)

-- =========================
-- ESP
-- =========================

local function UpdateESP()

    for _, OtherPlayer in ipairs(Players:GetPlayers()) do

        if OtherPlayer ~= Player
            and OtherPlayer.Character then

            local Character = OtherPlayer.Character
            local Highlight =
                Character:FindFirstChild("MeuHubESP")

            if ESPEnabled then

                if not Highlight then

                    Highlight = Instance.new("Highlight")
                    Highlight.Name = "MeuHubESP"
                    Highlight.Adornee = Character
                    Highlight.DepthMode =
                        Enum.HighlightDepthMode.AlwaysOnTop
                    Highlight.FillTransparency = 0.7
                    Highlight.OutlineTransparency = 0
                    Highlight.Parent = Character

                end

            elseif Highlight then

                Highlight:Destroy()

            end
        end
    end
end

ESPButton.MouseButton1Click:Connect(function()

    ESPEnabled = not ESPEnabled

    ESPButton.Text =
        ESPEnabled
        and "👁️ ESP: ON"
        or "👁️ ESP: OFF"

    UpdateESP()

end)

Players.PlayerAdded:Connect(function(NewPlayer)

    NewPlayer.CharacterAdded:Connect(function()

        task.wait(0.5)
        UpdateESP()

    end)

end)

-- =========================
-- VELOCIDADE
-- =========================

SpeedButton.MouseButton1Click:Connect(function()

    Speed += 4

    if Speed > 40 then
        Speed = 16
    end

    SpeedButton.Text =
        "🏃 VELOCIDADE: " .. Speed

    local Character = Player.Character

    if Character then

        local Humanoid =
            Character:FindFirstChildOfClass("Humanoid")

        if Humanoid then
            Humanoid.WalkSpeed = Speed
        end
    end
end)

-- =========================
-- PULO
-- =========================

JumpButton.MouseButton1Click:Connect(function()

    JumpPower += 10

    if JumpPower > 100 then
        JumpPower = 50
    end

    JumpButton.Text =
        "🦘 PULO: " .. JumpPower

    local Character = Player.Character

    if Character then

        local Humanoid =
            Character:FindFirstChildOfClass("Humanoid")

        if Humanoid then
            Humanoid.UseJumpPower = true
            Humanoid.JumpPower = JumpPower
        end
    end
end)

-- =========================
-- FOV
-- =========================

local FOVCircle = Instance.new("Frame")

FOVCircle.Size =
    UDim2.fromOffset(
        FOVSize * 2,
        FOVSize * 2
    )

FOVCircle.Position =
    UDim2.fromScale(0.5, 0.5)

FOVCircle.AnchorPoint =
    Vector2.new(0.5, 0.5)

FOVCircle.BackgroundTransparency = 1
FOVCircle.Parent = Gui

local FOVCorner = Instance.new("UICorner")
FOVCorner.CornerRadius = UDim.new(1, 0)
FOVCorner.Parent = FOVCircle

local FOVStroke = Instance.new("UIStroke")
FOVStroke.Thickness = 2
FOVStroke.Parent = FOVCircle

FOVButton.MouseButton1Click:Connect(function()

    FOVSize += 30

    if FOVSize > 240 then
        FOVSize = 60
    end

    FOVButton.Text =
        "⭕ FOV: " .. FOVSize

    FOVCircle.Size =
        UDim2.fromOffset(
            FOVSize * 2,
            FOVSize * 2
        )

end)

-- =========================
-- AUTO KILL NPC
-- =========================

AutoKillButton.MouseButton1Click:Connect(function()

    AutoKillNPC = not AutoKillNPC

    AutoKillButton.Text =
        AutoKillNPC
        and "☠️ AUTO KILL NPC: ON"
        or "☠️ AUTO KILL NPC: OFF"

end)

task.spawn(function()

    while task.wait(0.5) do

        if AutoKillNPC then

            local Folder =
                workspace:FindFirstChild("TestNPCs")

            if Folder then

                for _, NPC in ipairs(Folder:GetChildren()) do

                    local Humanoid =
                        NPC:FindFirstChildOfClass("Humanoid")

                    if Humanoid
                        and Humanoid.Health > 0 then

                        Humanoid.Health = 0

                    end
                end
            end
        end
    end
end)

-- =========================
-- FECHAR
-- =========================

CloseButton.MouseButton1Click:Connect(function()
    Gui:Destroy()
end)

-- =========================
-- CONFIGURAÇÕES
-- =========================

local function ApplySettings()

    local Character = Player.Character

    if not Character then
        return
    end

    local Humanoid =
        Character:FindFirstChildOfClass("Humanoid")

    if not Humanoid then
        return
    end

    Humanoid.WalkSpeed = Speed
    Humanoid.UseJumpPower = true
    Humanoid.JumpPower = JumpPower

end

Player.CharacterAdded:Connect(function()

    task.wait(1)
    ApplySettings()

end)

ApplySettings()

-- =========================
-- FOV FIXO NO CENTRO
-- =========================

RunService.RenderStepped:Connect(function()

    if Gui.Parent then

        FOVCircle.Position =
            UDim2.fromScale(0.5, 0.5)

        FOVCircle.AnchorPoint =
            Vector2.new(0.5, 0.5)

    end

end)
