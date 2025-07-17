-- V1

local SoundAPI_index = figuraMetatables.SoundAPI.__index

local SoundAPIMethods = {}
---@param soundID string
---@param replacement string | table
---@param range number
function SoundAPIMethods:replaceSound(soundID,replacement,range)
    if type(soundID) ~= "string" then
        error("Sound id was not provided or is not a string",2)
    end
    if type(replacement) ~= "string" and type(replacement) ~= "table" then
        error("Replacement sound not provided or it is not a string or table",2)
    end
    local new = type(replacement) == "table" and replacement or {replacement}
    events.on_play_sound:remove(soundID)
    local r = range or 0.5
    events.on_play_sound:register(
        function(id,pos,vol,pitch,_,_,path)
            if not path then return end
            if not player:isLoaded() then return end 
            if (player:getPos() - pos):length() > r then return end
            if id:find(soundID) then 
                sounds:playSound(new[math.random(#new)], pos, vol, pitch)
                return true
            end
        end,
    soundID)
    return self
end

function figuraMetatables.SoundAPI:__index(key)
    return SoundAPIMethods[key] or SoundAPI_index(self, key)
end