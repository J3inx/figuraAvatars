config = require("config")

-- Change scale to X
local defaultScale = config.defaultScale
-- A saved secondary size to be used in action wheel
local savedScale = config.savedScale

-- To use this module, put this code in a script:
local chat_bubble = require("modules/chat_bubble")

-- To configure the chat bubbles, use this code (should be after the previous code!) and adjust the values as you need:
chat_bubble.bubbleLifetime = 100
chat_bubble.fadeTime = 20
chat_bubble.maxMessageLength = 64
chat_bubble.localIndicator = "\\"
--local jetText = textures["image09353600_093535B0"]

-- bubbleLifetime is the total duration of a chat bubble before it disappears (including fadeout)
-- fadeTime is how many ticks the bubble fading out lasts
-- maxMessageLength is the maximum number of characters that a message can be before it gets cut off in the bubble
-- localIndicator is the indicator you put at the beginning of a message to tell it not to send to global chat
local ResizePage = action_wheel:newPage("ResizePage")
local quickSet = action_wheel:newPage("quickSettings")
local sizeChose = false
local quickSetChose = false
local mainPage = action_wheel:newPage("mainPage")
local blinkPage = action_wheel:newPage("blinky")
local emotionPage = action_wheel:newPage("emotions")
local blinkcheck = 80
local capeOn = false
local blinkOn = true
local eyeMoveOn = true
local jetOnElytra = true
local voiceToggle = true
local textBoxOn = true
-- KorboSpeech v2.1.3 by @korbosoft
-- With edits by @manuel_2867, @customable, @skunkmommy179
local voiceSounds = {
    -- Put at least 1 or 2 sound names here
    -- for example: "sound1", "sound2"
    "talka", "talkado", "talktre"
    -- Also use only mono channel sounds, otherwise will be heard globally!
}

local voiceSpeechRate = 1 -- Rate of speech, how many ticks to wait per character
local voiceVolume = 1 -- Voice volume
local voicePitchRange = 0.25 -- Range of pitch randomization, set to zero to disable
local voiceMinLength = 1 -- Minimum amount of sounds to play even if message is shorter
local voiceMaxLength = 999 -- Maximum amount of characters to speak if you want to limit it
local cancelPreviousSound = false -- Set to true if you want to avoid overlapping sounds
local distressedEyes = false
-- DO NOT CHANGE ANYTHING UNDER HERE!
local shakeIntensity = 5
local queue = 0
local basePitch = 1 - voicePitchRange / 2
local currentSound = nil
local returntbl = {
    scale = defaultScale,
    camera_adjust = config.camera_adjust,
    resize = function(size) pings.updateScale(size) end,
    page = ResizePage,
    pagename = "ResizePage"
}
local returntbl2 = {
    scale = defaultScale,
    camera_adjust = config.camera_adjust,
    resize = function(size) pings.updateScale(size) end,
    page = ResizePage,
    pagename = "blinkPage"
}

function changeModel()
    if player:getModelType() == "DEFAULT" then
        --models.model:setVisible(false)
    end
end

if not config.custom_model then
    --models.model:setPrimaryTexture("SKIN")
	
    --print("Jets exist?", models.model.root.jets ~= nil)
    --print("Pack exist?", models.model.root.jets.pack ~= nil)
   -- print("Texture exists?", textures["jet_text"] ~= nil)

    --models.model.root.jets.pack:setTexture("jet_text")
    events.ENTITY_INIT:register(changeModel)
end

-- Action wheel starts here
local scaletable = {0.01, 0.05, .1, .25, .5, 1}
local scaleindex = 3
local blinkRate = 100.0

if config.action_wheel then
    action_wheel:setPage(mainPage)
end
--models.model.root.ItemHelm:setVisible(true)
mainPage:newAction()
    :title("quick settings §7(leftclick)§r")
    :item("iron_pickaxe")
    :onLeftClick(function() action_wheel:setPage(quickSet) end)

mainPage:newAction()
    :title("blink settings §7(leftclick)§r")
    :item("ender_pearl")
    :onLeftClick(function() action_wheel:setPage(blinkPage) end)
mainPage:newAction()
    :title("emotions §7(leftclick)§r")
    :item("player_head")
    :onLeftClick(function() action_wheel:setPage(emotionPage) end)
emotionPage:newAction()
    :title("go back §7(leftclick)§r")
    :item("barrier")
    :onLeftClick(function() action_wheel:setPage(mainPage) end) 
emotionPage:newAction()
	:title("set emotion to neutral  §7(leftclick)§r")
	:item("white_concrete")
	:onLeftClick(function()
		if textures["neutral"] then
	models.model.root.Head:primaryTexture("CUSTOM", textures["neutral"])

	animations.model.shockedEyes:setPlaying(false)
		else
			log("neutral texture missing")
		end
	end)
emotionPage:newAction()
	:title("set emotion to sad  §7(leftclick)§r")
	:item("blue_concrete")
	:onLeftClick(function()
		if textures["sad"] then
	models.model.root.Head:primaryTexture("CUSTOM", textures["sad"])
	animations.model.shockedEyes:setPlaying(false)
		else
			log("sad texture missing")
		end
	end)

emotionPage:newAction()
	:title("set emotion to happy  §7(leftclick)§r")
	:item("yellow_concrete")
	:onLeftClick(function()
		if textures["norm"] then
	models.model.root.Head:primaryTexture("CUSTOM", textures["norm"])

	animations.model.shockedEyes:setPlaying(false)
		else
			log("norm texture missing")
		end
	end)
emotionPage:newAction()
	:title("set emotion to heavily distressed  §7(leftclick)§r")
	:item("purple_concrete")
	:onLeftClick(function()
		if textures["heavyDistressed"] then
	models.model.root.Head:primaryTexture("CUSTOM", textures["heavyDistressed"])

	animations.model.shockedEyes:setPlaying(true)

		else
			log("distressed texture missing")
		end
	end)
-- Define the shake intensity variable
local shakeIntensity = 0  -- Initial value for shake intensity

-- Define the custom shake value variable (this will be modified when the intensity changes)
local currentShakeValue = shakeIntensity


-- Action to update shake intensity based on scroll input
-- Correctly initialize the action
--local action = quickSet:newAction()
   -- :title("Shaking Intensity §7(Scroll)§b\n\nCurrent Shake Intensity: " .. currentShakeValue .. "%")
   -- :item("slime_ball")
   -- :onScroll(function(dir)
       --        if dir > 0 then
       --     pings.changeShakeIntensity(1)
       -- elseif dir < 0 then
		
           -- pings.changeShakeIntensity(-1)
      --  end
   -- end)


--function pings.changeShakeIntensity(amount)
 --   -- Adjust the intensity and ensure it stays within bounds (0-100)
  --  shakeIntensity = math.clamp(shakeIntensity + amount, 0, 100)
    
    -- Update the custom shake value based on the shake intensity
   -- currentShakeValue = shakeIntensity
    
    -- Update the action title with the current shake intensity
   -- action:title("Shaking Intensity §7(Scroll)§b\n\nCurrent Shake Intensity: " .. currentShakeValue .. "%")
--end


blinkPage:newAction()
    :title("go back §7(leftclick)§r")
    :item("red_wool")
    :onLeftClick(function() action_wheel:setPage(mainPage) end) 

blinkPage:newAction()
    :title("eye movement toggle §7(leftclick)§r")
    :item("ender_pearl")
    :onLeftClick(function()
        if eyeMoveOn then
            log("eye movement is now off")
            eyeMoveOn = false
        else
            log("eye movement is now on")
            eyeMoveOn = true
        end
    end)

local blinkAmount = 100 -- Starting rate (example)
local action = blinkPage:newAction()
action:title("Change the Rate of blinking §7(Scroll)§b\n\nblink rate: " .. blinkAmount .. "%")
    :item("sugar")
    :onScroll(function(dir)
        if dir > 0 then
            pings.changeBlinkRate(1)
        elseif dir < 0 then
            pings.changeBlinkRate(-1)
        end
    end)

function pings.changeBlinkRate(amount)
    blinkAmount = math.clamp(blinkAmount + amount, 1, 100)
    action:title("Change the Rate of blinking §7(Scroll)§b\n\nblink rate: " .. blinkAmount .. "%")
end

function pings.adder(args)
    blinkRate = blinkRate + args
end

function pings.subtractor(amount)
    blinkRate = blinkRate - amount
end

function pings.KorboSpeak(amount)
    if player:isLoaded() then
        queue = queue + amount
    end
end
function events.item_render(item)
    if item.id == "minecraft:crossbow" then
        return models.model.root.ItemBow
    end
end
function events.item_render(item)
    if item.id == "minecraft:bow" then
        return models.model.root.ItemBow
    end
end
function events.tick()


	 local function shakeBubble(bubble, frame)
    local shakeX = math.sin(frame * 0.5) * 0.3
    local shakeY = math.cos(frame * 0.7) * 0.3
    for _, part in pairs(bubble) do
        if part.setPos then  -- Only apply to objects that can move
            part:setPos(part:getPos():add(shakeX, shakeY, 0))
        end
    end
end
   if jetOnElytra then
    if player:isGliding() then
        models["model"]["root"]["jets"]:setVisible(true)
	particles:newParticle("campfire_signal_smoke", player:getPos(), vec(0, 0, 0))
    else
        models["model"]["root"]["jets"]:setVisible(false)
	particles:removeParticles()
    end
	end
    if queue > 0 and world.getTime() % voiceSpeechRate == 0 then
        queue = queue - 1
        if cancelPreviousSound and currentSound then
            currentSound:stop()
        end
        currentSound = sounds[voiceSounds[math.random(#voiceSounds)]]
        currentSound:pos(player:getPos())
            :volume(voiceVolume)
            :pitch(basePitch + math.random() * voicePitchRange)
            :subtitle(player:getName() .. " speaks")
            :play()
    end
end

function events.chat_send_message(msg)
    if not msg then return end
    if string.sub(msg, 1, 1) ~= "/" and voiceToggle then
        local nospaces = msg:gsub("%s+", "")
        pings.KorboSpeak(math.max(voiceMinLength, math.min(#nospaces, voiceMaxLength)))
    end
    return msg
end

mainPage:newAction()
    :title("TODO \n fix blinking \n (DONE)add jetpack for elytra \n add custom armor")
    :item("cobblestone")

mainPage:newAction()
    :title("resizer")
    :item("iron_nugget")
    :onLeftClick(function() action_wheel:setPage(ResizePage) end)
ResizePage:newAction()
:title("Default Size §7(leftclick)§r\nSaved Size §7(rightclick)")
:item("milk_bucket")
:onLeftClick(function() log("size Set "..defaultScale) pings.updateScale(defaultScale) end)
:onRightClick(function() log("size Set "..savedScale) pings.updateScale(savedScale) end)

ResizePage:newAction()
:title("Save Current Scale")
:item("shulker_box")
:onLeftClick(function() savedScale = scale end)

RateControl = ResizePage:newAction()
:title("Change the Rate of Scale Change §7(Scroll)§b\n\nScale Rate: "..scaletable[scaleindex])
:item("sugar")
:onScroll(function(dir)
scaleindex = math.clamp(scaleindex + dir, 1 , #scaletable)
RateControl:title("Change the Rate of Scale Change §7(Scroll)§b\n\nScale Rate: "..scaletable[scaleindex])

end)

ScaleControl = ResizePage:newAction()
:title("Increase and Decrease Player Scale §7(Scroll)§b\n\nCurrent Scale: "..defaultScale)
:item("red_mushroom")
:onScroll(function(dir)
	scale = math.max(scale + (dir * scaletable[scaleindex]),0.05)
	ScaleControl:title("Increase and Decrease Player Scale §7(Scroll)§b\n\nCurrent Scale: "..scale)
	pings.updateScale(scale)
	
end)
ResizePage:newAction()
    :title("go back §7(leftclick)§r")
    :item("red_wool")
    :onLeftClick(function() action_wheel:setPage(mainPage) end) 

function shakeModel()
    local shakeAmount = shakeIntensity * 0.1  -- Modify this based on your shake logic
    -- Apply shake logic here, for example:
    models.model:setPos(math.random() * shakeAmount, math.random() * shakeAmount, math.random() * shakeAmount)
end

quickSet:newAction()
    :title("go back §7(leftclick)§r")
    :item("red_wool")
    :onLeftClick(function() action_wheel:setPage(mainPage) end) 

quickSet:newAction()
    :title("hide/show cape §7(leftclick)§r")
    :item("gold_nugget")
    :onLeftClick(function() 
        if capeOn then
            vanilla_model.CAPE:setVisible(false)
            capeOn = false
        else
            vanilla_model.CAPE:setVisible(true)
            capeOn = true
        end
    end)
quickSet:newAction()
    :title("show jetpack during glide §7(leftclick)§r")
    :item("elytra")
    :onLeftClick(function() 
        if jetOnElytra then
            jetOnElytra = false
        else
            jetOnElytra = true
        end
    end)

quickSet:newAction()
    :title("toggle voice sounds on/off §7(leftclick)§r")
    :item("echo_shard")
    :onLeftClick(function() 
        if voiceToggle then
            voiceToggle = false
            log("voice set to off")
        else
            voiceToggle = true
            log("voice set to on")
        end
    end)

quickSet:newAction()
    :title("toggle text boxes on/off §7(leftclick)§r")
    :item("book")
    :onLeftClick(function() 
        if chat_bubble.maxMessageLength == 64 then
            chat_bubble.maxMessageLength = 0
            chat_bubble.bubbleLifetime = 0.0000001
            chat_bubble.fadeTime = 0.00000001
            textBoxOn = false
            log("text boxes set to off")
        else
            chat_bubble.maxMessageLength = 64
            chat_bubble.bubbleLifetime = 100
            chat_bubble.fadeTime = 20
            textBoxOn = true
            log("text boxes set to on")
        end
    end)

-- Code starts here
camera = require("camera")

vanilla_model.ALL:setVisible(false)
vanilla_model.HELD_ITEMS:setVisible(true)
vanilla_model.HELMET_ITEM:setVisible(true)

scale = defaultScale
models:setScale(scale, scale, scale)
camera.setCamera(scale * returntbl["camera_adjust"])

if scale >= 1 then
    nameplate.ENTITY:setScale(scale, scale, scale)
else
    local tinyscale = math.max(scale, .2) * 2
    nameplate.ENTITY:setScale(tinyscale, tinyscale, tinyscale)
end

nameplate.ENTITY:setPos(0, (scale * returntbl["camera_adjust"] - 1) * 2.2, 0)

function Resize(arg)
    pings.updateScale(arg)
end

function pings.updateScale(arg)
    scale = arg
    returntbl.scale = arg
    models:setScale(scale, scale, scale)
    if scale >= 1 then
        nameplate.ENTITY:setScale(scale, scale, scale)
    else
        local tinyscale = math.max(scale, .2) * 2
        nameplate.ENTITY:setScale(tinyscale, tinyscale, tinyscale)
    end

    nameplate.ENTITY:setPos(0, (scale * returntbl["camera_adjust"] - 1) * 2.2, 0)
    camera.setCamera(scale * returntbl["camera_adjust"])
end

local timer = 200
events.TICK:register(function()
    if player:getPose() == "CROUCHING" then
        models:setPos(0, 2, 0)
        nameplate.ENTITY:setPos(0, (scale * returntbl["camera_adjust"] - 1) * 2.2 + 4 / 16, 0)
    else
        models:setPos(0, 0, 0)
        nameplate.ENTITY:setPos(0, (scale * returntbl["camera_adjust"] - 1) * 2.2, 0)
    end

    if host:isHost() then
        if timer > 0 then
            timer = timer - 1
        else
            pings.updateScale(scale)
            timer = 200
        end
    end
end)

function events.render(delta, type)
    --most of the stuff below is broken
    if player:getItem(6).id == "minecraft:diamond" then
        vanilla_model.HELMET_ITEM:setVisible(false)
        models.model.root.Head.Helmer:setVisible(true)
        models.model.root.Body.creatinator_tank:setVisible(true)

        -- Get the head rotation directly
        local headRot = models.model.root.Head:getRot()

        -- Apply that rotation to the helmet
        models.model.root.Head.Helmer:setRot(headRot)
    else
        models.model.root.Head.Helmer:setVisible(false)
        models.model.root.Body.creatinator_tank:setVisible(false)
    end

    if type == "FIRST_PERSON" or type == "RENDER" then return end
    models:setScale(1, 1, 1)
end


function events.post_render(delta, type)
    if type == "FIRST_PERSON" or type == "RENDER" then return end
    models:setScale(scale, scale, scale)
end

return returntbl
