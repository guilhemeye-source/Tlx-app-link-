--!strict
-- MEU HUB
-- Para uso no seu próprio jogo Roblox
-- Sem KEY

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")

-- =========================
-- CONFIGURAÇÕES
-- =========================

local Config = {
    Speed = 16,
    JumpPower = 50,
    ESP = false,
    AimAssist = false,
    FOV = 120,
    AutoKillNPC = false
}

-- =========================
-- LIMPAR HUB ANTIGO
-- =========================

local Old = PlayerGui:FindFirstChild("MeuHub")

if Old then
    Old:Destroy()
end

-- =========================
-- GUI
-- =========================

local Gui = Instance.new("ScreenGui")
Gui.Name = "MeuHub"
Gui.ResetOnSpawn = false
Gui.Parent = PlayerGui

local Main = Instance.new("Frame")
Main.Size = UDim2.fromOffset(290, 410)
Main.Position = UDim2.fromScale(0.5, 0.5)
Main.AnchorPoint = Vector2.new(0.5, 0.5)
Main.BackgroundTransparency = 0.08
Main.Parent = Gui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 16)
MainCorner.Parent = Main

local Stroke = Instance.new("UIStroke")
Stroke.Thickness = 2
Stroke.Parent = Main

-- =========================
-- TÍTULO
-- =========================

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -20, 0, 45)
Title.Position = UDim2.fromOffset(10, 5)
Title.BackgroundTransparency = 1
Title.Text = "⚡ MEU HUB"
Title.TextScaled = true
Title.Font = Enum.Font.GothamBold
Title.Parent = Main

-- =========================
-- FUNÇÃO DOS BOTÕES
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
-- AIM ASSIST
-- =========================

AimButton.MouseButton1Click:Connect(function()

    Config.AimAssist = not Config.AimAssist

    AimButton.Text =
        Config.AimAssist
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

            if Config.ESP then

                if not Highlight then

                    Highlight = Instance.new("Highlight")

                    Highlight.Name =
                        "MeuHubESP"

                    Highlight.Adornee =
                        Character

                    Highlight.DepthMode =
                        Enum.HighlightDepthMode.AlwaysOnTop

                    Highlight.FillTransparency = 0.7
                    Highlight.OutlineTransparency = 0

                    Highlight.Parent =
                        Character
                end

            elseif Highlight then

                Highlight:Destroy()

            end
        end
    end
end

ESPButton.MouseButton1Click:Connect(function()

    Config.ESP = not Config.ESP

    ESPButton.Text =
        Config.ESP
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

    Config.Speed += 4

    if Config.Speed > 40 then
        Config.Speed = 16
    end

    SpeedButton.Text =
        "🏃 VELOCIDADE: " .. Config.Speed

    local Character =
        Player.Character

    if Character then

        local Humanoid =
            Character:FindFirstChildOfClass("Humanoid")

        if Humanoid then
            Humanoid.WalkSpeed =
                Config.Speed
        end
    end
end)

-- =========================
-- PULO
-- =========================

JumpButton.MouseButton1Click:Connect(function()

    Config.JumpPower += 10

    if Config.JumpPower > 100 then
        Config.JumpPower = 50
    end

    JumpButton.Text =
        "🦘 PULO: " .. Config.JumpPower

    local Character =
        Player.Character

    if Character then

        local Humanoid =
            Character:FindFirstChildOfClass("Humanoid")

        if Humanoid then

            Humanoid.UseJumpPower = true
            Humanoid.JumpPower =
                Config.JumpPower

        end
    end
end)

-- =========================
-- FOV
-- =========================

local FOVCircle = Instance.new("Frame")

FOVCircle.Size =
    UDim2.fromOffset(
        Config.FOV * 2,
        Config.FOV * 2
    )

FOVCircle.Position =
    UDim2.fromScale(0.5, 0.5)

FOVCircle.AnchorPoint =
    Vector2.new(0.5, 0.5)

FOVCircle.BackgroundTransparency = 1
FOVCircle.Visible = false
FOVCircle.Parent = Gui

local FOVCorner = Instance.new("UICorner")

FOVCorner.CornerRadius =
    UDim.new(1, 0)

FOVCorner.Parent =
    FOVCircle

local FOVStroke = Instance.new("UIStroke")

FOVStroke.Thickness = 2
FOVStroke.Parent = FOVCircle

FOVButton.MouseButton1Click:Connect(function()

    Config.FOV += 30

    if Config.FOV > 240 then
        Config.FOV = 60
    end

    FOVButton.Text =
        "⭕ FOV: " .. Config.FOV

    FOVCircle.Size =
        UDim2.fromOffset(
            Config.FOV * 2,
            Config.FOV * 2
        )
end)

-- =========================
-- AUTO KILL NPC
-- =========================

AutoKillButton.MouseButton1Click:Connect(function()

    Config.AutoKillNPC =
        not Config.AutoKillNPC

    AutoKillButton.Text =
        Config.AutoKillNPC
        and "☠️ AUTO KILL NPC: ON"
        or "☠️ AUTO KILL NPC: OFF"

end)

task.spawn(function()

    while task.wait(0.5) do

        if Config.AutoKillNPC then

            local NPCFolder =
                workspace:FindFirstChild("NPCs")

            if NPCFolder then

                for _, NPC in ipairs(
                    NPCFolder:GetChildren()
                ) do

                    local Humanoid =
                        NPC:FindFirstChildOfClass(
                            "Humanoid"
                        )

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
-- APLICAR CONFIGURAÇÕES
-- =========================

local function ApplySettings()

    local Character =
        Player.Character

    if not Character then
        return
    end

    local Humanoid =
        Character:FindFirstChildOfClass(
            "Humanoid"
        )

    if not Humanoid then
        return
    end

    Humanoid.WalkSpeed =
        Config.Speed

    Humanoid.UseJumpPower = true

    Humanoid.JumpPower =
        Config.JumpPower

end

Player.CharacterAdded:Connect(function()

    task.wait(1)

    ApplySettings()

end)

ApplySettings()

-- =========================
-- FOV NO CENTRO
-- =========================

RunService.RenderStepped:Connect(function()

    if Gui.Parent then

        FOVCircle.Position =
            UDim2.fromScale(0.5, 0.5)

        FOVCircle.AnchorPoint =
            Vector2.new(0.5, 0.5)

    end
end)
