function pings.animation(state)
if state then
function events.tick()
if    player:getPose() == "STANDING" then
    animations.model["dragon.idle"]:play()
end
end
end

-- Get movement direction relative to the look vector
-- Determine movement direction relative to where the player is looking
function getMoveDirection()
    local velocity = player:getVelocity()
    local look = player:getLookDir()
  
    -- Flatten vectors to horizontal plane
    local flatVelocity = vec(velocity.x, 0, velocity.z)
    if flatVelocity:length() < 0.05 then
        return "none"
    end
  
    local forward = vec(look.x, 0, look.z):normalize()
    local right = vec(look.z, 0, -look.x):normalize()
  
    local dotForward = flatVelocity:dot(forward)
    local dotRight = flatVelocity:dot(right)
  
    if math.abs(dotForward) > math.abs(dotRight) then
        if dotForward > 0.1 then
            return "forward"
        elseif dotForward < -0.1 then
            return "backward"
        end
    else
        if dotRight > 0.1 then
            return "right"
        elseif dotRight < -0.1 then
            return "left"
        end
    end
  
    return "none"
  end

events.TICK:register(function()
    local dir = getMoveDirection()
    if dir == "forward" then
        animations.model["dragon.move.forward"]:play()
    elseif dir == "backward" then
        animations.model["dragon.move.backward"]:play()
    end
end)
end