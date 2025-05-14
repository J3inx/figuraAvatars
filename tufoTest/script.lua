-- Auto generated script file --
local physBone = require('physBoneAPI')
local chat_bubble = require("modules/chat_bubble")

--hide vanilla model
vanilla_model.PLAYER:setVisible(false)
vanilla_model.ARMOR:setVisible(false)
vanilla_model.HELMET_ITEM:setVisible(true)
vanilla_model.CAPE:setVisible(false)
vanilla_model.ELYTRA:setVisible(false)

-- Create ears physics instance
-- KorboSpeech v2.1.3 by @korbosoft
-- With edits by @manuel_2867, @customable, @skunkmommy179
local voiceSounds = {
  -- put at least 1 or 2 sound names here
  -- for example: "sound1", "sound2"
  "chirp-01","chirp-02","chirp-03","chirp-04","chirp-05","chirp-06","chirp-07","chirp-08"
  -- also use only mono channel sounds, otherwise will be heard globally!
}
local voiceSpeechRate = 1 -- rate of speech, how many ticks to wait per character
local voiceVolume = 1 -- voice volume
local voicePitchRange = 0.25 -- range of pitch randomization, set to zero to disable
local voiceMinLength = 1 -- minimum amount of sounds to play even if message is shorter
local voiceMaxLength = 999 -- maximum amount of characters to speak if you want to limit it
local cancelPreviousSound = false -- set to true if you want to avoid overlapping sounds

-- DO NOT CHANGE ANYTHING UNDER HERE!

local queue = 0
local basePitch = 1 - voicePitchRange / 2
local currentSound = nil


chat_bubble.bubbleLifetime = 100
chat_bubble.fadeTime = 20
chat_bubble.maxMessageLength = 64
chat_bubble.localIndicator = "\\"
local mainPage = action_wheel:newPage("mainPage")
local emotionPage = action_wheel:newPage("emotes")



-- Apply mirror setting after config


-- Enable the physics updating


-- Entity init event
function events.entity_init()
 
  -- Optional init logic
  physBone.physBoneLeftEar:setNodeDensity(0)
  physBone.physBoneRightEar:setNodeDensity(0)
  physBone.physBoneLeftEar:setAirResistance(0.5)
  physBone.physBoneRightEar:setAirResistance(0.5)
  physBone.physBoneTail:setNodeDensity(0)
  physBone.physBoneTail:setAirResistance(0.5)
  
end
action_wheel:setPage(mainPage)
mainPage:newAction()
  :title("go to emotion page")
  :item("player_head")
  :onLeftClick(function()
    action_wheel:setPage(emotionPage)
  end)
  emotionPage:newAction()
  :title("go back")
  :item("barrier")
  :onLeftClick(function()
    action_wheel:setPage(mainPage)
  end)
  emotionPage:newAction()
  :title("play sit animation")
  :item("oak_stairs")
  :onLeftClick(function()
    animations.BonBon.sit:setPlaying(true)
  end)
  emotionPage:newAction()
  :title("play loaf animation")
  :item("bread")
  :onLeftClick(function()
    models.BonBon.root.RightArm.shoulderConnector2:setVisible(true)
    models.BonBon.root.LeftArm.shoulderConnector:setVisible(true)
    animations.BonBon.loaf:setPlaying(true)
  end)
-- Tick event (20 times per second)
function events.tick()
  local walking = player:getVelocity().xz:length() > 0.01
  if walking and player:getVelocity().xz:length() < 1 then
    stopAnim()
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

function stopAnim()
  animations.BonBon.sit:setPlaying(false)
  animations.BonBon.loaf:setPlaying(false)
  if models.BonBon.root.RightArm.shoulderConnector2:getVisible()then
    models.BonBon.root.RightArm.shoulderConnector2:setVisible(false)
    models.BonBon.root.LeftArm.shoulderConnector:setVisible(false)
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
function pings.KorboSpeak(amount)
  if player:isLoaded() then
      queue = queue + amount
  end
end



function events.chat_send_message(msg)
  if not msg then return end
  if string.sub(msg, 1, 1) ~= "/" then
      local nospaces = msg:gsub("%s+", "")
      pings.KorboSpeak(math.max(voiceMinLength, math.min(#nospaces, voiceMaxLength)))
  end
  return msg
end
-- Render event (every frame)
function events.render(delta, context)
  models.BonBon:setPrimaryRenderType("cutout_cull")
end
