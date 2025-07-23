local active = false
local tickCounter = 0
local intervalTicks = 60 -- default to 3 seconds (20 ticks = 1 sec)

local M = {}

function M.plays(sounded)
    if sounded == 1 then
        sounds:playSound("gurgle", player:getPos(), 1, 1, false)
        print("played once")
       host:sendChatCommand("vogurgle")
    end
end

function M.setLoop(state)
    active = state
    if not state then
        tickCounter = 0
        sounds:stopSound()
    end
end

-- ✅ Add this function to set interval
function M.setInterval(ticks)
    intervalTicks = ticks
end

function M.tick()
    if active then
        tickCounter = tickCounter + 1
        if tickCounter >= intervalTicks then
            sounds:playSound("gurgle", player:getPos(), 1, 1, false)
            --print("looped")
            
            tickCounter = 0
        end
    end
end

return M
