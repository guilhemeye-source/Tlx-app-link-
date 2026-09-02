local Players = game:GetService("Players")

local function getRole(player)
    -- 1. Attribute
    local role = player:GetAttribute("Role")
    if typeof(role) == "string" then
        return role
    end

    -- 2. StringValue dentro do Player
    local roleValue = player:FindFirstChild("Role")
    if roleValue and roleValue:IsA("StringValue") then
        return roleValue.Value
    end

    -- 3. StringValue dentro do Character
    if player.Character then
        local charRole = player.Character:FindFirstChild("Role")
        if charRole and charRole:IsA("StringValue") then
            return charRole.Value
        end
    end

    return nil
end

local function createESP(player)
    if player == Players.LocalPlayer then
        return
    end

    local character = player.Character
    if not character then
        return
    end

    local old = character:FindFirstChild("RoleESP")
    if old then
        old:Destroy()
    end

    local highlight = Instance.new("Highlight")
    highlight.Name = "RoleESP"
    highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    highlight.FillTransparency = 0.45
    highlight.OutlineTransparency = 0

    local role = getRole(player)

    if role == "Murderer" or role == "Murderer" then
        highlight.FillColor = Color3.fromRGB(255, 0, 0)
        highlight.OutlineColor = Color3.fromRGB(255, 0, 0)

    elseif role == "Sheriff" or role == "Sherif" then
        highlight.FillColor = Color3.fromRGB(0, 120, 255)
        highlight.OutlineColor = Color3.fromRGB(0, 120, 255)

    else
        highlight.FillColor = Color3.fromRGB(0, 255, 0)
        highlight.OutlineColor = Color3.fromRGB(0, 255, 0)
    end

    highlight.Parent = character
end

local function updateAll()
    for _, player in ipairs(Players:GetPlayers()) do
        createESP(player)
    end
end

while task.wait(0.2) do
    updateAll()
end
