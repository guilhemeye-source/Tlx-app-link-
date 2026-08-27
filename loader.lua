-- Loader.lua - Cybersecurity-Focused Loader
-- Features: Aimbot, Auto-Kill, FOV Control

local loader = {
    version = "1.0",
    features = {"aimbot", "auto_kil", "fov_control"},
    active = false,
    config = {
        aimbot_enabled = false,
        auto_kill_target = nil,
        fov_value = 75
    }
}

function loader:initialize()
    print("Loader initialized. Features: ", table.concat(self.features, ", "))
    self.active = true
end

function loader:toggle_aimbot(state)
    self.config.aimbot_enabled = state
    if state then
        print("Aimbot activated")
    else
        print("Aimbot deactivated")
    end
end

function loader:auto_kill(target)
    self.config.auto_kill_target = target
    print("Auto-Kill activated on target:", target)
end

function loader:set_fov(value)
    self.config.fov_value = value
    print("FOV set to:", value)
end

function loader:get_status()
    return {
        active = self.active,
        config = self.config
    }
end

return loader
