-- Auto generated script file --

-- Hide vanilla models
vanilla_model.ARMOR:setVisible(false)
vanilla_model.CAPE:setVisible(false)
vanilla_model.ELYTRA:setVisible(false)
vanilla_model.PLAYER:setVisible(false)

-- === REQUIRE CAMERA MODULE === --
camera = require("camera")
camera.setCamera(1, -0.30) -- slight downward offset for first-person camera
camera.keybindEnable = true
camera.cameraEnable = true

-- Voice Sound Settings
local voiceSounds = { "a_sound", "e_sound", "i_sound", "o_sound", "u_sound" }
local voiceSpeechRate = 2
local voiceVolume = 1
local voicePitchRange = 0.7
local voiceMinLength = 1
local voiceMaxLength = 999
local cancelPreviousSound = false

-- Internal variables
local queue = 0
local basePitch = 1 - voicePitchRange / 2
local currentSound = nil
local mouthTimer = 0
local test = true
local mainPage = action_wheel:newPage()
local skullC = false
local skullSettings = action_wheel:newPage()
local skullO = false
mainPage:newAction()
  :title("skull settings §7(leftclick)§r")
  :item("skeleton_skull")
  :onLeftClick(function() action_wheel:setPage(skullSettings)
  end)
action_wheel:setPage(mainPage)
skullSettings:newAction()
    :title("go back §7(leftclick)§r")
    :item("barrier")
    :onLeftClick(function() action_wheel:setPage(mainPage) end) 
skullSettings:newAction()
    :title("set skull to be crouched §7(leftclick)§r")
    :item("chest")
    :onLeftClick(function()
    
    if skullC then
      animations.Skull.crouching:play()
      skullC = false
      else
        animations.Skull.crouching:stop()
        skullC = true
      end 
    end)
skullSettings:newAction()
  :title("set skull to have black eyes §7(leftclick)§r")
  :item("ender_pearl")
  :onLeftClick(function() 
    if test then
      models.Skull.root.spine.butt.abdomen.neck.head.eyes.eyeL:primaryTexture("CUSTOM", textures["blackedEyes"])
      models.Skull.root.spine.butt.abdomen.neck.head.eyes.eyeR:primaryTexture("CUSTOM", textures["blackedEyes"])
      test = false
    else
      models.Skull.root.spine.butt.abdomen.neck.head.eyes.eyeL:primaryTexture("CUSTOM", textures["texture"])
      models.Skull.root.spine.butt.abdomen.neck.head.eyes.eyeR:primaryTexture("CUSTOM", textures["texture"])
      print(test)
      test = false
    end
  end)
  -- Eating Sound
function events.ON_PLAY_SOUND(id, pos, vol, pitch, loop, cat, path)
  if not path then return end              --dont trigger if the sound was played by figura (prevent potential infinite loop)
  if not player:isLoaded() then return end -- dont do anything if the player isn't loaded

  local distance = (player:getPos() - pos):length()

  if distance > 0.9 then return end                                        -- make sure the sound is (most likely) played by *you*. Smaller radius captures common sounds with very precise placement
if id:find(".step") then                                                  -- if sound contains ".step"
      sounds:playSound("entity.iron_golem.step", player:getPos(), 1, 1.5) -- play a custom sound
  end

  if distance > 0.9 then return end                                 -- make sure the sound is (most likely) played by *you*. Larger radius captures uncommon sounds with random placement
  if id:find(".eat") then                                           -- if sound contains ".eat"
      sounds:playSound("entity.iron_golem.hurt", player:getPos(), 0.5, 2) -- play a custom sound
      return true                                                   -- stop the actual eat sound
  end
  if id:find(".burp") then                                          -- if sound contains ".burp" then
      return true                                                   -- stops the actual burp sound
  end
end
skullSettings:newAction()
  :title("set skull to just be the head §7(leftclick)§r")
  :item("ender_pearl")
  :onLeftClick(function()
    if skullO then
      models.Skull.root:setVisible(false)
      models.Skull.skullHead:setVisible(true)
      skullO = false
    else
      models.Skull.root:setVisible(true)
      models.Skull.skullHead:setVisible(false)
      skullO = true
    end
  end)
  :setOnToggle(pings.toggleEyeC) 



-- === Chat Message Capture === --
function pings.KorboSpeak(amount)
  if player:isLoaded() then
    queue = queue + amount
    mouthTimer = 2
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
  
-- === Tick Events === --
function events.tick()
  if queue > 0 and world.getTime() % voiceSpeechRate == 0 then
    queue = queue - 1
    if cancelPreviousSound and currentSound then currentSound:stop() end
    currentSound = sounds[voiceSounds[math.random(#voiceSounds)]]
    currentSound:pos(player:getPos())
      :volume(voiceVolume)
      :pitch(basePitch + math.random() * voicePitchRange)
      :subtitle(player:getName() .. " speaks")
      :play()
    mouthTimer = 2
  end

  -- Mouth decay
  if mouthTimer > 0 then mouthTimer = mouthTimer - 0.1 end

  -- Animation
  if player:getPose() == "CROUCHING" then
    animations.RepoTest.crouching:play()
  else
    animations.RepoTest.crouching:stop()
    animations.RepoTest.uncrouch:play()
  end

  local walking = player:getVelocity().xz:length() > 0.01
  if walking and player:getVelocity().xz:length() < 1 and player:getPose() == "CROUCHING" then
    animations.RepoTest.Cwalk:play()
  elseif walking and player:getVelocity().xz:length() < 1 then
    animations.RepoTest.Wtest:play()
    animations.RepoTest.Cwalk:stop()
  else
    animations.RepoTest.Wtest:stop()
    animations.RepoTest.Cwalk:stop()
  end
end

-- Clamp utility
function math.clamp(value, min, max)
  return math.max(min, math.min(max, value))
end

-- === RENDER HANDLER === --
events.RENDER:register(function(delta)
  local camRot = player:getRot()
  local bodyYaw = player:getBodyYaw()

  -- Head movement calculation
  local pitch = -camRot[1]
  local yawDiff = -(camRot[2] - bodyYaw)
  local yaw = (yawDiff + 180) % 360 - 180

  local neckMaxPitch = 30
  local neckMaxYaw = 30
  local neckPitch = math.clamp(pitch, -neckMaxPitch, neckMaxPitch)
  local neckYaw = math.clamp(yaw, -neckMaxYaw, neckMaxYaw)

  local leftoverPitch = pitch - neckPitch
  local leftoverYaw = yaw - neckYaw

  -- Spine bending
  local abdomenPitch = math.clamp(leftoverPitch, -15, 15)
  local buttPitch = math.clamp(leftoverPitch - abdomenPitch, -10, 10)

  -- Eye tracking
  local eyePitch = pitch - neckPitch
  local eyeYaw = yaw - neckYaw
  models.RepoTest.root.spine.butt.abdomen.neck.head.eyes.eyeL:setRot(0, eyeYaw, -eyePitch)
  models.RepoTest.root.spine.butt.abdomen.neck.head.eyes.eyeR:setRot(0, eyeYaw, -eyePitch)

  -- Apply rotations
  models.RepoTest.root.spine.butt.abdomen.neck:setRot(0, neckYaw, -neckPitch)
  models.RepoTest.root.spine.butt.abdomen:setRot(0, 0, -abdomenPitch)
  models.RepoTest.root.spine.butt:setRot(0, 0, -buttPitch)

  -- Mouth movement
  local mouthOpenAmount = math.max(0, math.sin(world.getTime() * 1.5) * 15 * math.min(mouthTimer, 1))
  models.RepoTest.root.spine.butt.abdomen.neck.head:setRot(0, 0, mouthOpenAmount * -2)
end)
