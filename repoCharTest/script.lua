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
--misc
local selectedCR = 146
local selectedCG = 17
local selectedCB = 18
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
  --:toggle(true)
  :setOnToggle(function(state)
    print("Toggled nameplate visibility to:", state)
    visibility = state
    pings.togglename2(state)
  end)

funPage:newAction()
  :title("character colors §7(leftclick)§r")
  :item("blue_concrete")
  :onLeftClick(function() action_wheel:setPage(colorsPage) end)
  colorsPage:newAction()
  :title("go back §7(leftclick)§r")
  :item("barrier")
  :onLeftClick(function() action_wheel:setPage(funPage) end)
  colorsPage:newAction()
  :title("change red color §7(leftclick)§r")
  :item("red_wool")
  :setOnScroll(RedScrollFunction())
  function pings.RedScrollFunction(dir)
    if dir > 0 then
        selectedCR = selectedCR + 1
    else
      selectedCR = selectedCR - 1
    end
end
colorsPage:newAction()
:title("change green color §7(leftclick)§r")
:item("green_wool")
:setOnScroll(GreenScrollFunction())
function pings.GreenScrollFunction(dir)
  if dir > 0 then
      selectedCG = selectedCG + 1
  else
    selectedCG = selectedCG - 1
  end
end
colorsPage:newAction()
:title("change blue color §7(leftclick)§r")
:item("blue_wool")
:setOnScroll(BlueScrollFunction())
function pings.BlueScrollFunction(dir)
  if dir > 0 then
      selectedCB = selectedCB + 1
  else
    selectedCB = selectedCB - 1
  end
end
colorsPage:newAction()
:title("reset color values §7(leftclick)§r")
:item("arrow")
:onLeftClick(function()
  selectedCR = 146
  selectedCG = 17
  selectedCB = 18
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
      host.sendChatMessage("bingo i got action")
      host.sendChatMessage("cloak and run!")
    else
      host.sendChatMessage("cloak deactivated")
    end
    pings.toggleBoffum(state)
  end)
pings.toggleBoffum = function(state)
if state then
  print("Toggle called. Visibility set to:", state)
  visibility = false
  pings.Rnone ()
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
  :title("set render mode to ender portal §7(leftclick)§r")
  :item("ender_pearl")
  :onLeftClick(function()
    pings.Rend()

    end)
rendererModes:newAction()
  :title("set render mode to cell shader §7(leftclick)§r")
  :item("black_wool")
  :onLeftClick(function()
     pings.Rcut()

    end)
rendererModes:newAction()
  :title("set render mode to none §7(leftclick)§r")
  :item("red_wool")
  :onLeftClick(function() 
    pings.Rnone ()

  end)
  
action_wheel:setPage(mainPage)

pings.Rend = function()
  if cosmic == false then
    cosmic = true
    if none then
      none = false
    end
    if norm then
      norm = false
    end
  end
end
pings.togglename2 = function(state)
  print("Toggle called. Visibility set to:", state)
  visibility = state
end

pings.Rcut = function()
  if norm == false then
    norm = true
      if none then
        none = false
      end
      if cosmic then
        cosmic= false
      end
    
  end

end
pings.Rnone = function()
  if none == false then
    none = true
      if norm then
        norm = false
      end
      if cosmic then
        cosmic= false
      end
    
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
  --broken to my knowledge, texture exists and is recognized by head2 but doesnt seem to be accepted for the eyes in skull
  --used to work but recently stopped, so maybe look through old commits
  local tex = blacked and textures["blackedEyes"] or textures["texture"]
  --quick debugs to check for next time
  ptint(tex:getName())
  models.Skull.root.spine.butt.abdomen.neck.head.eyes:primaryTexture("CUSTOM", textures[tex])
  print(tex:getPath())
end

function setHeadOnlyMode(enabled)
  models.Skull.root:setVisible(not enabled)
  models.Skull.skullHead:setVisible(enabled)
end

-- === Multiplayer Sync Pings === --
pings.setSkullCrouch = function(state)
  playSkullCrouchAnimation(state)
end

pings.setEyeTexture = function(blacked)
  setEyeTexture(blacked)
end

pings.setHeadOnly = function(enabled)
  setHeadOnlyMode(enabled)
end

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
    pings.KorboSpeak(math.max(voiceMinLength, math.min(#nospaces, voiceMaxLength)))
  end
  return msg
end

-- === Tick Event === --
function events.tick()
  -- Voice sound system
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

  -- Walk animation
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

  -- Crouch animation
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
local temp =
-- === Render Handler === --
events.RENDER:register(function(delta)

  if not selectedCR == 146 and not selectedCG == 17 and not selectedCB == 18 then
    for x = 0, 512 do  
    for i = 0, 512 do
      setPixel(i, x, selectedCR, selectedCG, selectedCB)
    end
    end
  end

  if visibility then
    nameplate.ENTITY:setVisible(true)
  else
    nameplate.ENTITY:setVisible(false)
  end
  --print("Entity Nameplate:", nameplate.ENTITY) -- should not be nil

  if cosmic then
    models.RepoTest:setPrimaryRenderType("END_PORTAL") 
  end
  if norm then
    models.RepoTest:setPrimaryRenderType("cutout_cull")
  end
  if none then
    models.RepoTest:setPrimaryRenderType("none")
  end
  local camRot = player:getRot()
  local bodyYaw = player:getBodyYaw()
  local pitch = -camRot[1]
  local yawDiff = -(camRot[2] - bodyYaw)
  local yaw = (yawDiff + 180) % 360 - 180

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