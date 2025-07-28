-- Dragon Wings animation scripting

local wasGliding = false -- for landing/takeoff animations

-- when avatar is loaded for the first time
function events.entity_init()

    vanilla_model.CAPE:setVisible(false) --hide vanilla cape model
    vanilla_model.ELYTRA:setVisible(false) --hide vanilla elytra model
    if icarus then
        icarus:setWingsVisible(false) -- hide icarus wings
    end

    -- set blend times
    animations.model.wingsclosed:setBlendTime(5)
    animations.model.elytra_down:setBlendTime(5)
    animations.model.elytra_up:setBlendTime(5)
end

-- tick event, called 20 times per second
function events.tick()
    local gliding = player:isGliding() and not host:isFlying() -- unsure if this works for other players

    -- insert fly logic here?
    local yvel = player:getVelocity().y
    local glidingUp =  yvel > 0.1
    local glidingDown =  yvel < -0.4
    animations.model.elytra_up:setPlaying(glidingUp and gliding)
    animations.model.elytra:setPlaying(not glidingUp and gliding)
    animations.model.elytra_down:setPlaying(glidingDown and gliding)

    animations.model.wingsopen:setPlaying(gliding or playerIsFlying)
    animations.model.wingsclosed:setPlaying(not gliding and not playerIsFlying)
end
