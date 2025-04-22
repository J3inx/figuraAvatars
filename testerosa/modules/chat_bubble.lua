--[[
    
--To use this module, put this code in a script:
    

    
--bubbleLifetime is the total duration of a chat bubble before it disappears (including fadeout), in ticks
--fadeTime is how many ticks the bubble fading out lasts
--maxMessageLength is the maximum number of characters that a message can be before it gets cut off in the bubble
--localIndicator is the indicator you put at the beginning of a message to tell it not to send to global chat

]]
local ages = {0, 0, 0}
local chatBubbles = {0, 0, 0}
local lastId = -1

local config = {}
config.bubbleLifetime = 100
config.fadeTime = 20
config.maxMessageLength = 64
config.localIndicator = "\\"

local local_models = models
local local_textures
for path in (...):gmatch("[^/]+") do
    local_models = local_models[path]
end
local local_textures = {...}
local_textures, _ = local_textures[1]:gsub("/", ".")


function newBubble(text, id)
    local bubble = {}
    bubble["text"] = text
    local textDims
    local textOffset = 0
    textDims = client.getTextDimensions(text, 200, true)
    if textDims[2] < 12 then
        textDims[2] = 12
        textOffset = 1
    end

    local topLeft = local_models.chatBubble.Camera_speech:newSprite("topLeft" .. id)
        :setTexture(textures[local_textures .. '.textures.corner'], 2, 2)
        :setPos((textDims[1]/4)+3, 1+(textDims[2]/2), 0)
        :setLight(15, 15)
    bubble["topLeft"] = topLeft
  
    local topRight = local_models.chatBubble.Camera_speech:newSprite("topRight" .. id)
        :setTexture(textures[local_textures  .. '.textures.corner'], 2, 2)
        :setRegion(-2, 2)
        :setPos((-textDims[1]/4)-1, 1+(textDims[2]/2), 0)
        :setLight(15, 15)    
    bubble["topRight"] = topRight
   
    local bottomLeft = local_models.chatBubble.Camera_speech:newSprite("bottomLeft" .. id)
        :setTexture(textures[local_textures  .. '.textures.corner'], 2, 2)
        :setRegion(2, -2)
        :setPos((textDims[1]/4)+3, 1, 0)
        :setLight(15, 15)
    bubble["bottomLeft"] = bottomLeft  
    
    local bottomRight = local_models.chatBubble.Camera_speech:newSprite("bottomRight" .. id)
        :setTexture(textures[local_textures  .. '.textures.corner'], 2, 2)
        :setRegion(-2, -2)
        :setPos((-textDims[1]/4)-1, 1, 0)
        :setLight(15, 15)
    bubble["bottomRight"] = bottomRight

    local topEdge = local_models.chatBubble.Camera_speech:newSprite("topEdge" .. id)
        :setTexture(textures[local_textures  .. '.textures.edge'], 1, 1)
        :setPos(((textDims[1]+4)/4), 1+(textDims[2]/2), 0)
        :setScale((textDims[1]+4)/2, 1, 1)
        :setLight(15, 15)
    bubble["topEdge"] = topEdge

    local bottomEdge = local_models.chatBubble.Camera_speech:newSprite("bottomEdge" .. id)
        :setTexture(textures[local_textures  .. '.textures.edge'], 1, 1)
        :setPos(((textDims[1]+4)/4), 0, 0)
        :setScale((textDims[1]+4)/2, 1, 1)
        :setLight(15, 15)    
    bubble["bottomEdge"] = bottomEdge

    local leftEdge = local_models.chatBubble.Camera_speech:newSprite("leftEdge" .. id)
        :setTexture(textures[local_textures  .. '.textures.edge'], 1, 1)
        :setPos((textDims[1]/4)+3, 1+((textDims[2]-4)/2), 0)
        :setScale(1, ((textDims[2]-4)/2), 1)
        :setLight(15, 15)
    bubble["leftEdge"] = leftEdge 

    local rightEdge = local_models.chatBubble.Camera_speech:newSprite("rightEdge" .. id)
        :setTexture(textures[local_textures  .. '.textures.edge'], 1, 1)
        :setPos((-textDims[1]/4)-2, 1+((textDims[2]-4)/2), 0)
        :setScale(1, ((textDims[2]-4)/2), 1)
        :setLight(15, 15)
    bubble["rightEdge"] = rightEdge 

    local middle = local_models.chatBubble.Camera_speech:newSprite("middle" .. id)
        :setTexture(textures[local_textures  .. '.textures.middle'], 1, 1)
        :setPos((textDims[1]/4)+2, (textDims[2]/2), 0.001)
        :setScale((textDims[1]/2)+4, ((textDims[2])/2), 1)
        :setLight(15, 15)
        --:setColor(1,1,1,0)
    bubble["middle"] = middle
  
    local tip = local_models.chatBubble.Camera_speech:newSprite("tip" .. id)
        :setTexture(textures[local_textures  .. '.textures.tip'], 3, 2)
        :setPos(1.5, -1, 0)
        :setLight(15, 15)
    bubble["tip"] = tip
    
    local textDisplay = local_models.chatBubble.Camera_speech:newText("textDisplay" .. id)
        :setText(text)
        :alignment("CENTER")
        :setWidth(200)
        :setWrap(true)
        :setShadow(true)
        :setPos(0, (textDims[2]-1-textOffset)/2, -0.001)
        :setScale(0.5,0.5,1)
        :setLight(15,15)
        :opacity(1)
    bubble["textDisplay"] = textDisplay
    -- Shake effect for loud messages (ALL CAPS or ending with !)
local isAllCaps = text:upper() == text and text:lower() ~= text
local endsWithExclamation = text:sub(-1) == "!"

if isAllCaps or endsWithExclamation then
    local frame = 0
    events.TICK:register(function()
        if not bubble["textDisplay"] or frame >= config.bubbleLifetime then return end

        local pos = bubble["textDisplay"]:getPos()
        local shakeX = math.sin(frame * 0.5) * 0.3
        local shakeY = math.cos(frame * 0.7) * 0.3
        -- Apply the shake effect to all parts of the bubble
        bubble["topLeft"]:setPos(bubble["topLeft"]:getPos():add(shakeX, shakeY, 0))
        bubble["topRight"]:setPos(bubble["topRight"]:getPos():add(shakeX, shakeY, 0))
        bubble["bottomLeft"]:setPos(bubble["bottomLeft"]:getPos():add(shakeX, shakeY, 0))
        bubble["bottomRight"]:setPos(bubble["bottomRight"]:getPos():add(shakeX, shakeY, 0))
        bubble["topEdge"]:setPos(bubble["topEdge"]:getPos():add(shakeX, shakeY, 0))
        bubble["bottomEdge"]:setPos(bubble["bottomEdge"]:getPos():add(shakeX, shakeY, 0))
        bubble["leftEdge"]:setPos(bubble["leftEdge"]:getPos():add(shakeX, shakeY, 0))
        bubble["rightEdge"]:setPos(bubble["rightEdge"]:getPos():add(shakeX, shakeY, 0))
        bubble["middle"]:setPos(bubble["middle"]:getPos():add(shakeX, shakeY, 0))
        bubble["tip"]:setPos(bubble["tip"]:getPos():add(shakeX, shakeY, 0))
        bubble["textDisplay"]:setPos(pos:add(shakeX, shakeY, 0))
        
        frame = frame + 1
    end)
end

    return bubble
end


function updateBubble(bubble, offset)
    local text = bubble["text"]
    local textDims = client.getTextDimensions(text, 200, true)
    local textOffset = 0
    if textDims[2] < 12 then
        textDims[2] = 12
        textOffset = 1
    end
    
    if offset ~= 0 then
        bubble["tip"]:setVisible(false)
    end
    
    bubble["topLeft"]:setPos((textDims[1]/4)+3, offset+1+(textDims[2]/2), 0)
    bubble["topRight"]:setPos((-textDims[1]/4)-1, offset+1+(textDims[2]/2), 0)
    bubble["bottomLeft"]:setPos((textDims[1]/4)+3, offset+1, 0)
    bubble["bottomRight"]:setPos((-textDims[1]/4)-1, offset+1, 0)
    bubble["topEdge"]:setPos(((textDims[1]+4)/4), offset+1+(textDims[2]/2), 0)
        :setScale((textDims[1]+4)/2, 1, 1)
    bubble["bottomEdge"]:setPos(((textDims[1]+4)/4), offset+0, 0)
        :setScale((textDims[1]+4)/2, 1, 1)
    bubble["leftEdge"]:setPos((textDims[1]/4)+3, offset+ 1+((textDims[2]-4)/2), 0)
        :setScale(1, ((textDims[2]-4)/2), 1)
    bubble["rightEdge"]:setPos((-textDims[1]/4)-2, offset+ 1+((textDims[2]-4)/2), 0)
        :setScale(1, ((textDims[2]-4)/2), 1)
    bubble["middle"]:setPos((textDims[1]/4)+2, offset+ (textDims[2]/2), 0.001)
        :setScale((textDims[1]/2)+4, ((textDims[2])/2), 1)
    bubble["textDisplay"]:setPos(0, offset+ (textDims[2]-1-textOffset)/2, -0.001)
        :setScale(0.5,0.5,1)
    
    return bubble
end

function updateOpacity(bubble, opacity)
    bubble["topLeft"]:setColor(1,1,1,opacity)
    bubble["topRight"]:setColor(1,1,1,opacity)
    bubble["bottomLeft"]:setColor(1,1,1,opacity)
    bubble["bottomRight"]:setColor(1,1,1,opacity)
    bubble["topEdge"]:setColor(1,1,1,opacity)
    bubble["bottomEdge"]:setColor(1,1,1,opacity)
    bubble["leftEdge"]:setColor(1,1,1,opacity)
    bubble["rightEdge"]:setColor(1,1,1,opacity)
    bubble["middle"]:setColor(1,1,1,opacity)
    bubble["tip"]:setColor(1,1,1,opacity)
    bubble["textDisplay"]:opacity(opacity)
end

function removeBubble(slot)
    local bubble = chatBubbles[slot]
    bubble["topLeft"]:remove()
    bubble["topRight"]:remove()
    bubble["bottomLeft"]:remove()
    bubble["bottomRight"]:remove()
    bubble["topEdge"]:remove()
    bubble["bottomEdge"]:remove()
    bubble["leftEdge"]:remove()
    bubble["rightEdge"]:remove()
    bubble["middle"]:remove()
    bubble["tip"]:remove()
    bubble["textDisplay"]:remove()
    chatBubbles[slot] = 0
end

function pings.addBubble(text)
    if chatBubbles[3] ~= 0 then --all slots occupied
        removeBubble(3)
    end
    local bubble = newBubble(text, (lastId+1)%3)
    lastId = lastId + 1
    chatBubbles[3] = chatBubbles[2]
    ages[3] = ages[2]
    chatBubbles[2] = chatBubbles[1]
    ages[2] = ages[1]
    chatBubbles[1] = bubble
    ages[1] = 0
    
    if chatBubbles[1] ~= 0 and chatBubbles[2] ~= 0 then
        updateBubble(chatBubbles[2], chatBubbles[1]["textDisplay"]:getPos().y + 3.5)
        if chatBubbles[3] ~= 0 then
            updateBubble(chatBubbles[3], chatBubbles[2]["textDisplay"]:getPos().y + 3.5)
        end
    end
    
end

function events.TICK()
    for key, val in pairs(chatBubbles) do
        if val ~= 0 then
            ages[key] = ages[key] + 1
        end
    end
    if ages[3] >= config.bubbleLifetime then
        removeBubble(3)
        ages[3] = 0
    end
    if ages[2] >= config.bubbleLifetime then
        removeBubble(2)
        ages[2] = 0
    end
    if ages[1] >= config.bubbleLifetime then
        removeBubble(1)
        ages[1] = 0
    end
end
	local function shakeBubble(bubble, frame)
    local shakeX = math.sin(frame * 0.5) * 0.3
    local shakeY = math.cos(frame * 0.7) * 0.3
    for _, part in pairs(bubble) do
        if part.setPos then  -- Only apply to objects that can move
            part:setPos(part:getPos():add(shakeX, shakeY, 0))
        end
    end
end
function events.RENDER(delta)
    for key, bubble in pairs(chatBubbles) do
        if ages[key] > config.bubbleLifetime-config.fadeTime then
            local prevOpacity = math.map(ages[key] - (config.bubbleLifetime-config.fadeTime), 0, config.fadeTime, 1, 0)
            local nextOpacity = math.map(ages[key]+1 - (config.bubbleLifetime-config.fadeTime), 0, config.fadeTime, 1, 0)
            local newOpacity = math.lerp(prevOpacity, nextOpacity, delta)
            if newOpacity < 0.05 then newOpacity = 0 end
            updateOpacity(bubble, newOpacity)
        end
    end
end


function events.CHAT_SEND_MESSAGE(message)
    local skipMessage = false
    local skipBubble = false
    local newMessage = ""
    if message:sub(1, config.localIndicator:len()) == config.localIndicator then
        skipMessage = true
        newMessage = message:sub(config.localIndicator:len()+1)
    else
        newMessage = message
    end
    if newMessage:sub(1, 1) == "/" then
        skipBubble = true
        if skipMessage then
            newMessage = newMessage:sub(2)
        end
    end
    
    if skipBubble and skipMessage then
        return nil
    elseif skipBubble and not skipMessage then
        return message
    end
    
    if newMessage:len() > config.maxMessageLength then
        newMessage = newMessage:sub(0,config.maxMessageLength) .. "..."
    end
    pings.addBubble(toJson(newMessage))
    
    if skipMessage then
        return nil
    else
        return message
    end
end

return config