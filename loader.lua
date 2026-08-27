--// Free Kailruis - Loader.lua
--// Key: keltlx

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
local camera = workspace.CurrentCamera

local KEY_CORRETA = "keltlx"
local IMAGEM_BOLINHA = "rbxassetid://SEU_ID_DA_IMAGEM"

local gui = Instance.new("ScreenGui")
gui.Name = "FreeKailruisHub"
gui.ResetOnSpawn = false
gui.Parent = playerGui

--==================================================
-- TELA DE KEY
--==================================================

local keyFrame = Instance.new("Frame")
keyFrame.Size = UDim2.fromOffset(300, 190)
keyFrame.Position = UDim2.new(0.5, -150, 0.5, -95)
keyFrame.BackgroundColor3 = Color3.fromRGB(18,18,24)
keyFrame.BorderSizePixel = 0
keyFrame.Parent = gui

local keyCorner = Instance.new("UICorner")
keyCorner.CornerRadius = UDim.new(0,16)
keyCorner.Parent = keyFrame

local keyTitle = Instance.new("TextLabel")
keyTitle.Size = UDim2.new(1,0,0,50)
keyTitle.BackgroundTransparency = 1
keyTitle.Text = "🔐 FREE KAILRUIS"
keyTitle.TextColor3 = Color3.new(1,1,1)
keyTitle.TextSize = 20
keyTitle.Font = Enum.Font.GothamBold
keyTitle.Parent = keyFrame

local box = Instance.new("TextBox")
box.Size = UDim2.new(1,-40,0,45)
box.Position = UDim2.fromOffset(20,60)
box.BackgroundColor3 = Color3.fromRGB(35,35,45)
box.PlaceholderText = "Digite a Key"
box.Text = ""
box.TextColor3 = Color3.new(1,1,1)
box.PlaceholderColor3 = Color3.fromRGB(150,150,150)
box.TextSize = 16
box.Font = Enum.Font.Gotham
box.Parent = keyFrame

local boxCorner = Instance.new("UICorner")
boxCorner.CornerRadius = UDim.new(0,10)
boxCorner.Parent = box

local verify = Instance.new("TextButton")
verify.Size = UDim2.new(1,-40,0,40)
verify.Position = UDim2.fromOffset(20,115)
verify.BackgroundColor3 = Color3.fromRGB(190,50,140)
verify.Text = "VERIFICAR KEY"
verify.TextColor3 = Color3.new(1,1,1)
verify.TextSize = 15
verify.Font = Enum.Font.GothamBold
verify.Parent = keyFrame

local verifyCorner = Instance.new("UICorner")
verifyCorner.CornerRadius = UDim.new(0,10)
verifyCorner.Parent = verify

local status = Instance.new("TextLabel")
status.Size = UDim2.new(1,-20,0,25)
status.Position = UDim2.fromOffset(10,158)
status.BackgroundTransparency = 1
status.Text = ""
status.TextColor3 = Color3.fromRGB(255,80,80)
status.TextSize = 13
status.Font = Enum.Font.Gotham
status.Parent = keyFrame

--==================================================
-- PAINEL
--==================================================

local panel = Instance.new("Frame")
panel.Size = UDim2.fromOffset(240,220)
panel.Position = UDim2.new(0.5,-120,0.5,-110)
panel.BackgroundColor3 = Color3.fromRGB(18,18,24)
panel.BorderSizePixel = 0
panel.Visible = false
panel.Parent = gui

local panelCorner = Instance.new("UICorner")
panelCorner.CornerRadius = UDim.new(0,14)
panelCorner.Parent = panel

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1,-45,0,45)
title.Position = UDim2.fromOffset(15,0)
title.BackgroundTransparency = 1
title.Text = "TLX 🎀"
title.TextColor3 = Color3.new(1,1,1)
title.TextSize = 20
title.Font = Enum.Font.GothamBold
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = panel

local minimize = Instance.new("TextButton")
minimize.Size = UDim2.fromOffset(35,35)
minimize.Position = UDim2.new(1,-40,0,5)
minimize.BackgroundTransparency = 1
minimize.Text = "−"
minimize.TextColor3 = Color3.new(1,1,1)
minimize.TextSize = 25
minimize.Parent = panel

local function makeButton(text,y)
    local b = Instance.new("TextButton")
    b.Size = UDim2.new(1,-30,0,42)
    b.Position = UDim2.fromOffset(15,y)
    b.BackgroundColor3 = Color3.fromRGB(35,35,45)
    b.Text = text.."  OFF"
    b.TextColor3 = Color3.new(1,1,1)
    b.TextSize = 16
    b.Font = Enum.Font.GothamBold
    b.Parent = panel

    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0,9)
    c.Parent = b

    return b
end

local aimButton = makeButton("Aimbot",50)
local fovButton = makeButton("FOV",98)
local espButton = makeButton("ESP",146)

local aimEnabled = false
local fovEnabled = false
local espEnabled = false

--==================================================
-- FOV
--==================================================

local fov = Instance.new("Frame")
fov.Size = UDim2.fromOffset(180,180)
fov.AnchorPoint = Vector2.new(.5,.5)
fov.Position = UDim2.fromScale(.5,.5)
fov.BackgroundTransparency = 1
fov.Visible = false
fov.Parent = gui

local fovCorner = Instance.new("UICorner")
fovCorner.CornerRadius = UDim.new(1,0)
fovCorner.Parent = fov

local fovStroke = Instance.new("UIStroke")
fovStroke.Thickness = 2
fovStroke.Color = Color3.fromRGB(255,70,180)
fovStroke.Parent = fov

--==================================================
-- ESP
--==================================================

local function updateESP()
    for _,plr in ipairs(Players:GetPlayers()) do
        if plr ~= player and plr.Character then

            local old = plr.Character:FindFirstChild("TLX_ESP")

            if espEnabled and not old then
                local highlight = Instance.new("Highlight")
                highlight.Name = "TLX_ESP"
                highlight.FillTransparency = .7
                highlight.OutlineTransparency = 0
                highlight.FillColor = Color3.fromRGB(255,60,60)
                highlight.Parent = plr.Character

            elseif not espEnabled and old then
                old:Destroy()
            end
        end
    end
end

--==================================================
-- AIMBOT
--==================================================

local function getTarget()
    local target = nil
    local shortest = math.huge

    local center = Vector2.new(
        camera.ViewportSize.X/2,
        camera.ViewportSize.Y/2
    )

    for _,plr in ipairs(Players:GetPlayers()) do
        if plr ~= player and plr.Character then

            local humanoid =
                plr.Character:FindFirstChildOfClass("Humanoid")

            local root =
                plr.Character:FindFirstChild("HumanoidRootPart")

            if humanoid and root and humanoid.Health > 0 then

                local pos,visible =
                    camera:WorldToViewportPoint(root.Position)

                if visible then

                    local distance = (
                        Vector2.new(pos.X,pos.Y)-center
                    ).Magnitude

                    if distance < shortest then
                        shortest = distance
                        target = root
                    end
                end
            end
        end
    end

    return target
end

RunService.RenderStepped:Connect(function()

    if aimEnabled then
        local target = getTarget()

        if target then
            camera.CFrame = CFrame.lookAt(
                camera.CFrame.Position,
                target.Position
            )
        end
    end

end)

--==================================================
-- BOTÕES
--==================================================

aimButton.MouseButton1Click:Connect(function()
    aimEnabled = not aimEnabled
    aimButton.Text = "Aimbot  "..(aimEnabled and "ON" or "OFF")
end)

fovButton.MouseButton1Click:Connect(function()
    fovEnabled = not fovEnabled
    fov.Visible = fovEnabled
    fovButton.Text = "FOV  "..(fovEnabled and "ON" or "OFF")
end)

espButton.MouseButton1Click:Connect(function()
    espEnabled = not espEnabled
    espButton.Text = "ESP  "..(espEnabled and "ON" or "OFF")
    updateESP()
end)

--==================================================
-- BOLINHA COM IMAGEM
--==================================================

local mini = Instance.new("ImageButton")
mini.Size = UDim2.fromOffset(60,60)
mini.Position = UDim2.new(0,20,.5,-30)
mini.BackgroundColor3 = Color3.fromRGB(255,255,255)
mini.Image = IMAGEM_BOLINHA
mini.Visible = false
mini.Parent = gui

local miniCorner = Instance.new("UICorner")
miniCorner.CornerRadius = UDim.new(1,0)
miniCorner.Parent = mini

minimize.MouseButton1Click:Connect(function()
    panel.Visible = false
    mini.Visible = true
end)

mini.MouseButton1Click:Connect(function()
    panel.Visible = true
    mini.Visible = false
end)

--==================================================
-- VERIFICAÇÃO DA KEY
--==================================================

verify.MouseButton1Click:Connect(function()

    if box.Text == KEY_CORRETA then

        status.Text = "✓ Key correta!"
        status.TextColor3 = Color3.fromRGB(80,255,130)

        task.wait(.5)

        keyFrame.Visible = false
        panel.Visible = true

    else

        status.Text = "✕ Key incorreta!"
        status.TextColor3 = Color3.fromRGB(255,70,70)

    end
end)

-- ESP para novos personagens
Players.PlayerAdded:Connect(function(plr)

    plr.CharacterAdded:Connect(function()
        task.wait(.5)

        if espEnabled then
            updateESP()
        end
    end)

end)
