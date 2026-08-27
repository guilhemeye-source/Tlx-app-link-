-- lord_aimbot.lua - Auto-Aim & Kill Script
-- Author: DeepHat

-- Configuration
local AIMBOT_ENABLED = true
local FOV_ANGLE = 30  -- Field of view in degrees
local TARGET_DISTANCE = 50  -- Max distance to target
local KILL_THRESHOLD = 20  -- Health percentage below which we kill
local TARGET_PRIORITY = "highest"  -- Options: highest, lowest, nearest

-- Internal state
local last_target_time = 0
local current_target = nil
local last_killed = nil

function Update()
    if not AIMBOT_ENABLED then return end
    
    local now = GetTime()
    
    -- Find new target if needed
    if not current_target or IsTargetDead(current_target) or 
       GetDistance(GetPlayer(), current_target) > TARGET_DISTANCE then
        current_target = FindTarget()
    end
    
    if current_target then
        -- Check if we should kill this target
        if GetHealthPercentage(current_target) <= KILL_THRESHOLD then
            KillTarget(current_target)
        else
            -- Otherwise just follow the target
            MoveToTarget(current_target)
        end
        
        -- Keep track of what we're targeting
        last_target_time = now
    end
end

function FindTarget()
    local targets = {}
    
    -- Scan all entities in FOV
    for entity in GetEntitiesInRange(GetPlayer(), TARGET_DISTANCE) do
        if IsHostile(entity) then
            table.insert(targets, entity)
        end
    end
    
    -- Sort by priority
    if TARGET_PRIORITY == "nearest" then
        table.sort(targets, function(a, b)
            return GetDistance(GetPlayer(), a) < GetDistance(GetPlayer(), b)
        end)
    elseif TARGET_PRIORITY == "lowest" then
        table.sort(targets, function(a, b)
            return GetHealthPercentage(a) < GetHealthPercentage(b)
        end)
    end
    
    return #targets > 0 and targets[1] or nil
end

function KillTarget(target)
    if not target then return end
    
    -- Check if already killed recently
    if last_killed and GetTime() - last_killed < 1 then return end
    
    -- Attack the target
    Attack(target)
    last_killed = GetTime()
end

function MoveToTarget(target)
    local player_pos = GetPosition(GetPlayer())
    local target_pos = GetPosition(target)
    
    -- Calculate direction vector
    local dx = target_pos.x - player_pos.x
    local dy = target_pos.y - player_pos.y
    local dz = target_pos.z - player_pos.z
    
    -- Normalize and apply movement
    local length = math.sqrt(dx*dx + dy*dy + dz*dz)
    if length > 0 then
        dx = dx / length * 0.5
        dy = dy / length * 0.5
        dz = dz / length * 0.5
        
        SetMovement(dx, dy, dz)
    end
end

-- Main loop
while true do
    Update()
    Sleep(100)
end
