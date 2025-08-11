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
local voiceSounds = { "a_sound", "i_sound", "o_sound", "u_sound" }
local voiceSpeechRate = 2
local voiceVolume = 1
local voicePitchRange = 0.7
local voiceMinLength = 1
local voiceMaxLength = 999
local cancelPreviousSound = false
local voiceOn = true

-- Internal variables
local queue = 0
local basePitch = 1 - voicePitchRange / 2
local currentSound = nil
local mouthTimer = 0

-- Skull States
local skullC = true
local skullO = false
local eyeBlack = false

-- Action Pages
local mainPage = action_wheel:newPage()
local skullSettings = action_wheel:newPage()
local rendererModes = action_wheel:newPage()
local funPage = action_wheel:newPage()
local colorsPage = action_wheel:newPage()
local cosmic = false
local visibility = true
local norm = true
local none = false
local lines = false
--misc
local red = true
local green = false
local blue = false

Sred = 0.5325
    Sgreen = 0.0736
    Sblue = 0.0766  
-- keep this as a toggle :models.RepoTest:setPrimaryRenderType("END_PORTAL")
models.RepoTest:setPrimaryRenderType("cutout_cull")
-- === Action Wheel Setup === --
mainPage:newAction()
:title("go to fun page §7(leftclick)§r")
:item("cake")
:onLeftClick(function()
  action_wheel:setPage(funPage)
end)
mainPage:newAction()
--half of these are broken:
  :title("skull settings §7(leftclick)§r")
  :item("skeleton_skull")
  :onLeftClick(function() action_wheel:setPage(skullSettings) end)
  mainPage:newAction()
  --half of these are broken:
    :title("render settings §7(leftclick)§r")
    :item("player_head")
    :onLeftClick(function() action_wheel:setPage(rendererModes) end)
  
skullSettings:newAction()
  :title("go back §7(leftclick)§r")
  :item("barrier")
  :onLeftClick(function() action_wheel:setPage(mainPage) end)


  local togglename = funPage:newAction()
  :title("Hide Name")
  :toggleTitle("Show Name")
  :item("air")
  :setOnToggle(function(state)
    print("Toggled nameplate visibility to:", state)
    visibility = state
    pings.togglename2(state)
  end)

local voiceToggle = funPage:newAction()
  :title("character colors §7(leftclick)§r")
  :item("blue_concrete")
  :onLeftClick(function() action_wheel:setPage(colorsPage) end)
  funPage:newAction()
  :title("turn off voice §7(leftclick)§r")
  :item("sculk")
  :onLeftClick(function() 
    if voiceOn  then
      voiceOn = false
      print("is voice on?:" )
      print(voiceOn)
    else
    voiceOn = true
    print("is voice on?:" )
    print(voiceOn)
    end
   end)
  colorsPage:newAction()
  :title("go back §7(leftclick)§r")
  :item("barrier")
  :onLeftClick(function() action_wheel:setPage(funPage) end)
  
colorsPage:newAction()
  :title("set color to red §7(leftclick)§r")
  :item("red_wool")
  :onLeftClick(function()
    Sred = 0.5325
    Sgreen = 0.0736
    Sblue = 0.0766    
  end)
  colorsPage:newAction()
  :title("set color to purple §7(leftclick)§r")
  :item("purple_wool")
  :onLeftClick(function()
    Sred = 0.3667
    Sgreen = 0.0033
    Sblue = 0.3834  
  end)
 
  


  colorsPage:newAction()
  :title("set color to blue §7(leftclick)§r")
  :item("blue_wool")
  :onLeftClick(function() 
    Sred = 0.1900
    Sgreen = 0.1900
    Sblue = 0.4777
    
  end)
  colorsPage:newAction()
  :title("set color to green §7(leftclick)§r")
  :item("green_wool")
  :onLeftClick(function()
    Sred = 0.361
    Sgreen = 0.553
    Sblue = 0.004
    
  end)
  colorsPage:newAction()
  :title("set color to black §7(leftclick)§r")
  :item("black_wool")
  :onLeftClick(function()
    Sred = 0
    Sgreen = 0
    Sblue = 0
    
  end)
  colorsPage:newAction()
  :title("set color to grey §7(leftclick)§r")
  :item("gray_wool")
  :onLeftClick(function()
    Sred = 0.453
    Sgreen = 0.470
    Sblue =  0.480
    
  end)
funPage:newAction()
  :title("go back §7(leftclick)§r")
  :item("barrier")
  :onLeftClick(function() action_wheel:setPage(mainPage) end)
  funPage:newAction()
  :title("turn off name and disappear §7(leftclick)§r")
  :item("white_wool")
  :setOnToggle(function(state)
    if state then
      host:sendChatMessage("bingo i got action")
      host:sendChatMessage("cloak and run!")
    else
      host:sendChatMessage("cloak deactivated")
    end
    pings.toggleBoffum(state)
  end)
pings.toggleBoffum = function(state)
if state then
  print("Toggle called. Visibility set to:", state)
  visibility = false
  pings.Rnone()
else
  visibility = true
  norm = true
  none = false
end
end
rendererModes:newAction()
  :title("go back §7(leftclick)§r")
  :item("barrier")
  :onLeftClick(function() 
    action_wheel:setPage(mainPage)
     end)
rendererModes:newAction()
  :title("set render mode to ender gateway §7(leftclick)§r")
  :item("ender_pearl")
  :onLeftClick(function()
    pings.Rend()
    end)
rendererModes:newAction()
  :title("set render mode to hitbox §7(leftclick)§r")
  :item("string")
  :onLeftClick(function()
    pings.Rline()
    end)
rendererModes:newAction()
  :title("set render mode to cell shader §7(leftclick)§r")
  :item("red_wool")
  :onLeftClick(function()
     pings.Rcut()
    end)
rendererModes:newAction()
  :title("set render mode to none §7(leftclick)§r")
  :item("black_wool")
  :onLeftClick(function() 
    pings.Rnone()
  end)
action_wheel:setPage(mainPage)

pings.Rend = function()
  if not cosmic then
    cosmic = true
    none = false
    norm = false
    lines = false
  end
end

pings.togglename2 = function(state)
  print("Toggle called. Visibility set to:", state)
  visibility = state
end

pings.Rline = function()
  if not lines then
    lines = true
    none = false
    cosmic = false
    norm = false
  end
end

pings.Rcut = function()
  if not norm then
    norm = true
    none = false
    lines = false
    cosmic = false
  end
end

pings.Rnone = function()
  if not none then
    none = true
    norm = false
    cosmic = false
    lines = false
  end
end

-- === Animation Functions === --
function events.item_render(item)
  if item.id == "minecraft.crossbow" then
    animations.RepoTest.holdItemOut:plaY()
  else
    animations.RepoTest.holdItemOut:stop()
  end
end

function playSkullCrouchAnimation(state)
  if state then
    animations.Skull.crouching:stop()
  else
    animations.Skull.crouching:play()
  end
end

function setEyeTexture(blacked)
  local tex = blacked and textures["blackedEyes"] or textures["texture"]
  ptint(tex:getName())
  models.Skull.root.spine.butt.abdomen.neck.head.eyes:primaryTexture("CUSTOM", tex)
  print(tex:getPath())
end

function setHeadOnlyMode(enabled)
  models.Skull.root:setVisible(not enabled)
  models.Skull.skullHead:setVisible(enabled)
end

-- === Multiplayer Sync Pings === --
pings.setSkullCrouch = playSkullCrouchAnimation
pings.setEyeTexture = setEyeTexture
pings.setHeadOnly = setHeadOnlyMode

-- === Chat Trigger === --
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
    if(voiceOn) then
    pings.KorboSpeak(math.max(voiceMinLength, math.min(#nospaces, voiceMaxLength)))
    end
  
  return msg
end
return msg
end

-- === Tick Event === --
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

  if mouthTimer > 0 then
    mouthTimer = mouthTimer - 0.1
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

  if player:getPose() == "CROUCHING" then
    animations.RepoTest.crouching:play()
  else
    animations.RepoTest.crouching:stop()
    animations.RepoTest.uncrouch:play()
  end
end

-- Clamp Utility
function math.clamp(value, min, max)
  return math.max(min, math.min(max, value))
end

-- === Render Handler === --
events.RENDER:register(function(delta)
  --if selectedCR ~= 146 or selectedCG ~= 17 or selectedCB ~= 18 then
 

  nameplate.ENTITY:setVisible(visibility)
  renderer:setShadowRadius(visibility and 0.2 or 0.001)
  models.Skull:setPrimaryRenderType("cutout_cull")
  if cosmic then models.RepoTest:setPrimaryRenderType("END_GATEWAY") end
  if norm then
     models.RepoTest:setPrimaryRenderType("cutout_cull")
     models.RepoTest.root.spine.legs.legR.rightLeg:setColor(Sred, Sgreen, Sblue)
     models.RepoTest.root.spine.legs.legL.leftLeg:setColor(Sred, Sgreen, Sblue)
     models.RepoTest.root.spine.butt.hips:setColor(Sred, Sgreen, Sblue)
     models.RepoTest.root.spine.butt.abdomen.middle:setColor(Sred, Sgreen, Sblue)
     models.RepoTest.root.spine.butt.abdomen.arms.leftArm.left_arm:setColor(Sred, Sgreen, Sblue)
     models.RepoTest.root.spine.butt.abdomen.arms.rightArm.right_arm:setColor(Sred, Sgreen, Sblue)
     models.RepoTest.root.spine.butt.abdomen.neck.crouchHip:setColor(Sred, Sgreen, Sblue)
     models.RepoTest.root.spine.butt.abdomen.neck.head.head:setColor(Sred, Sgreen, Sblue)
     
 
   end
  if none then models.RepoTest:setPrimaryRenderType("none") end
  if lines then models.RepoTest:setPrimaryRenderType("LINES_STRIP") end

  local camRot = player:getRot()
  local bodyYaw = player:getBodyYaw()
  local pitch = -camRot[1]
  local yawDiff = -(camRot[2] - bodyYaw)
  local yaw = (yawDiff + 180) % 360 - 180
  renderer:setRenderCrosshair(true)
  local neckMaxPitch = 30
  local neckMaxYaw = 30
  local neckPitch = math.clamp(pitch, -neckMaxPitch, neckMaxPitch)
  local neckYaw = math.clamp(yaw, -neckMaxYaw, neckMaxYaw)
  local leftoverPitch = pitch - neckPitch
  local leftoverYaw = yaw - neckYaw
  local abdomenPitch = math.clamp(leftoverPitch, -15, 15)
  local buttPitch = math.clamp(leftoverPitch - abdomenPitch, -10, 10)
  local eyePitch = pitch - neckPitch
  local eyeYaw = yaw - neckYaw

  models.RepoTest.root.spine.butt.abdomen.neck.head.eyes.eyeL:setRot(0, eyeYaw, -eyePitch)
  models.RepoTest.root.spine.butt.abdomen.neck.head.eyes.eyeR:setRot(0, eyeYaw, -eyePitch)

  models.RepoTest.root.spine.butt.abdomen.neck:setRot(0, neckYaw, -neckPitch)
  models.RepoTest.root.spine.butt.abdomen:setRot(0, 0, -abdomenPitch)
  models.RepoTest.root.spine.butt:setRot(0, 0, -buttPitch)

  local mouthOpenAmount = math.max(0, math.sin(world.getTime() * 1.5) * 15 * math.min(mouthTimer, 1))
  models.RepoTest.root.spine.butt.abdomen.neck.head:setRot(0, 0, mouthOpenAmount * -2)
end)