-- Auto generated script file --
config = require("config")
local soundsy = require("sounds")
local tailPhysics = require('tail')
local intervalTicks = 60
local tail = tailPhysics.new(models.example.Body.tail)--.tail2)
-- Change scale to X
local defaultScale = config.defaultScale
-- A saved secondary size to be used in action wheel
local savedScale = config.savedScale
--hide vanilla model
vanilla_model.PLAYER:setVisible(false)

--hide vanilla armor model
vanilla_model.ARMOR:setVisible(false)
--re-enable the helmet item
--vanilla_model.HELMET_ITEM:setVisible(true)

--hide vanilla cape model
vanilla_model.CAPE:setVisible(false)

--hide vanilla elytra model
vanilla_model.ELYTRA:setVisible(false)

--entity init event, used for when the avatar entity is loaded for the first time
function events.entity_init()
  --player functions goes here
end
local returntbl = {
  scale = defaultScale,
  camera_adjust = config.camera_adjust,
  resize = function(size) pings.updateScale(size) end,
  page = ResizePage,
  pagename = "ResizePage"
}
tail:setConfig {
  idleSpeed = vec(0.025, 0.1, 0), -- how fast should tail move when nothing is happening
  idleStrength = vec(1, 20, 0), -- how much should tail move
  rotVelocityStrength = 0.2,
  walkSpeed = vec(0, 0.7, 0),
  walkStrength = vec(0, 8, 0),
  

}
--action pages:
local ResizePage = action_wheel:newPage("ResizePage")
local mainPage = action_wheel:newPage()
local soundPage = action_wheel:newPage()
local toggles = action_wheel:newPage()
local actorsAction = action_wheel:newPage()
action_wheel:setPage(mainPage)

--variables
camera = require("camera")
local animating = false
local cocShown = false
local Erect = false
local fullB = false
local ballPshown = true
local fullB2 = false
local fullSit = false
local sit = false
local temp = 1
local nuts = false
local jorkin = false
local scaletable = {0.01, 0.05, .1, .25, .5, 1}
local scaleindex = 3

keybinds:newKeybind("tail - wag", "key.keyboard.v")
   :onPress(function() pings.tailWag(true) end)
   :onRelease(function() pings.tailWag(false) end)

function pings.tailWag(x)
   tail.config.enableWag.keybind = x
end
local earsPhysics = require('ears')

local ears = earsPhysics.new(models.example.Head.leftEar, models.example.Head.rightEar)
local boobs = earsPhysics.new(models.example.Body.LTIT, models.example.Body.RTIT)
local ass = earsPhysics.new(models.example.LeftLeg.ButtL.Bc2, models.example.RightLeg.ButtR.Bc)
local wings = earsPhysics.new(models.example.Body.Lwing, models.example.Body.Rwing)--models.example.Body.bone)--models.example.Body.Rwing)
local prevAnimF2 = false
local prevAnimF = false
local wingsDos = earsPhysics.new(models.example.Body.Lwing2, models.example.Body.Rwing2)

boobs:setConfig{
  lockXYRot = true, -- if true, X and Y rotation will always be set to 0
  --rotMin = vec(-12, -8, -4), -- rotation limit
  rotMax = vec(12, 8, 6), -- rotation limit
  rotationAxis = "-ZYX",
  headRotStrength = 0,
  extraAngle = 0,
  stiff = 0.05,
  disableHeadPitch = true,
  disableHeadYaw = true,
  earsFlick = false,
  --headRotMin = 0, -- minimum rotation for head rotation
  --headRotMax = 0 -- maximum rotation for head rotation
}
wings:setConfig{
  
  lockXYRot = true, -- if true, X and Y rotation will always be set to 0
  rotMin = vec(-12, -10, -10), -- rotation limit
  rotMax = vec(12, 10, 10), -- rotation limit
  rotationAxis = "-XYZ",
  headRotStrength = 0,
  extraAngle = 0,
  
  --mirrorW = true,
  disableHeadPitch = true,
  disableHeadYaw = true,
  earsFlick = false,
  headRotMin = 0, -- minimum rotation for head rotation
  headRotMax = 0 -- maximum rotation for head rotation
}

wingsDos:setConfig{
  
  lockXYRot = true, -- if true, X and Y rotation will always be set to 0
  rotMin = vec(-12, -8, -4), -- rotation limit
  rotMax = vec(12, 8, 6), -- rotation limit
  rotationAxis = "ZYX",
  headRotStrength = 0,
  extraAngle = 0,
  --mirrorW = true,
  disableHeadPitch = true,
  disableHeadYaw = true,
  earsFlick = false,
  headRotMin = 0, -- minimum rotation for head rotation
  headRotMax = 0 -- maximum rotation for head rotation
}
ass:setConfig{
  --lockXYRot = true, -- if true, X and Y rotation will always be set to 0
  rotMin = vec(-12, -8, -4), -- rotation limit
  rotMax = vec(12, 8, 6), -- rotation limit
  rotationAxis = "ZXY",
  headRotStrength = 0,
  extraAngle = 0,
  disableHeadPitch = true,
  disableHeadYaw = true,
  earsFlick = false,
  headRotMin = 0, -- minimum rotation for head rotation
  headRotMax = 0 -- maximum rotation for head rotation
  
}
ears:setConfig {
  -- you can check ears.lua to see default config
  
  
}
mainPage:newAction()
:title("go to toggles page")
:item("oak_button")
:onLeftClick(function ()
  action_wheel:setPage(toggles)
end)

events.TICK:register(function ()
  soundsy.tick()
end)

mainPage:newAction()
:title("sounds")
:item("note_block")
:onLeftClick(function ()
  --soundsy.plays(1)
  action_wheel:setPage(soundPage)
end)

local toggleLooping = soundPage:newAction()
  :title("sound looping off")
  :toggleTitle("sound looping on")
  :item("arrow")
  :setOnToggle(function(state)
    print("Toggled sound looping:", state)
    soundsy.setLoop(state)
    if state == false then
      sounds:stopSound()
    end
    
  end)

  soundPage:newAction()
:title("play gurgle")
:item("water_bucket")
:onLeftClick(function ()
  soundsy.plays(1)

end)


local RateControl = soundPage:newAction()
  :title("Change Loop Interval §7(Left Click) or §7(Right Click)")
  :item("clock")
  :onLeftClick(function()
    intervalTicks = math.min(intervalTicks + 10, 600)  -- max 30 seconds, adjust if needed
    soundsy.setInterval(intervalTicks)
    print("loop interval is now: ", intervalTicks/20, "s")
    --updateIntervalTitle()
  end)
  :onRightClick(function()
    intervalTicks = math.max(intervalTicks - 10, 10) -- min 0.5 seconds (10 ticks)
    soundsy.setInterval(intervalTicks)
    print("loop interval is now: ", intervalTicks/20, "s")
    --updateIntervalTitle()
  end)



soundPage:newAction()
:title("go back to main")
:item("red_wool")
:onLeftClick(function ()
  action_wheel:setPage(mainPage)
end)


local togglename = mainPage:newAction()
  :title("turn on NSFW")
  :toggleTitle("turn off NSFW")
  :item("cooked_beef")
  :setOnToggle(function(state)
    print("Toggled NSFW:", state)
    
    pings.NSFW(state)
  end)
function pings.NSFW(state) -- Pings are how other players can see your actions
  --if not player:isLoaded() then return end -- This stops players erroring from you trying to use something they haven't loaded in
  --models.DVanDrag.bodies.cabs:setVisible(state)
  cocShown = state
  end
  local togglename = toggles:newAction()
  :title("turn on erect cock")
  :toggleTitle("turn off erect cock")
  :item("cooked_porkchop")
  :setOnToggle(function(state)
    print("Toggled erection:", state)
    
    pings.Erecter(state)
  end)
function pings.Erecter(state) -- Pings are how other players can see your actions
  --if not player:isLoaded() then return end -- This stops players erroring from you trying to use something they haven't loaded in
  --models.DVanDrag.bodies.cabs:setVisible(state)
  Erect = state
  end
  local togglename = toggles:newAction()
  :title("fold wings in")
  :toggleTitle("unfold wings")
  :item("elytra")
  :setOnToggle(function(state)
    print("wings in?: ", state)
    
    pings.wingsOut(state)
  end)
function pings.wingsOut(state) -- Pings are how other players can see your actions
  --if not player:isLoaded() then return end -- This stops players erroring from you trying to use something they haven't loaded in
  --models.DVanDrag.bodies.cabs:setVisible(state)
  if state then
    models.example.Body.Rwing:setVisible(false)
    models.example.Body.Lwing:setVisible(false)
    models.example.Body.Rwing2:setVisible(true)
    models.example.Body.Lwing2:setVisible(true)
  else
    models.example.Body.Rwing:setVisible(true)
    models.example.Body.Lwing:setVisible(true)
    models.example.Body.Rwing2:setVisible(false)
    models.example.Body.Lwing2:setVisible(false)
  end
end
toggles:newAction()
:title("go back")
:item("red_wool")
:onLeftClick(function()
  action_wheel:setPage(mainPage)
end)
mainPage:newAction()
:title("go to actions page")
:item("stone_button")
:onLeftClick(function ()
  action_wheel:setPage(actorsAction)
end)
actorsAction:newAction()
:title("go back")
:item("red_wool")
:onLeftClick(function()
  action_wheel:setPage(mainPage)
end)
toggles:newAction()
:title("toggle ball prey")
:item("ender_pearl")
:onLeftClick(function()
  if ballPshown then
    print("hid the ball prey")
   else
     print("showed the ball prey")
   end
  pings.ballP()
 
end)
function pings.ballP()
  if ballPshown then
   ballPshown = false
   models["DVanDrag"]["bodies"]["Body"]["cabs"]["ball prey 1"]:setVisible(false)
   models["DVanDrag"]["bodies"]["Body"]["cabs"]["ball prey 2"]:setVisible(false)
   models["DVanDrag"]["bodies"]["Body"]["cabs"]["ball prey 3"]:setVisible(false)
   models["DVanDrag"]["bodies"]["Body"]["cabs"]["ball prey 4"]:setVisible(false)
   models["DVanDrag"]["bodies"]["Body"]["cabs"]["ball prey 5"]:setVisible(false)
   models["DVanDrag"]["bodies"]["Body"]["cabs"]["ball prey 6"]:setVisible(false)
   else
     ballPshown = true
     models["DVanDrag"]["bodies"]["Body"]["cabs"]["ball prey 1"]:setVisible(true)
   models["DVanDrag"]["bodies"]["Body"]["cabs"]["ball prey 2"]:setVisible(true)
   models["DVanDrag"]["bodies"]["Body"]["cabs"]["ball prey 3"]:setVisible(true)
   models["DVanDrag"]["bodies"]["Body"]["cabs"]["ball prey 4"]:setVisible(true)
   models["DVanDrag"]["bodies"]["Body"]["cabs"]["ball prey 5"]:setVisible(true)
   models["DVanDrag"]["bodies"]["Body"]["cabs"]["ball prey 6"]:setVisible(true)
   end
  end

toggles:newAction()
:title("full balls")
:item("snowball")
:onLeftClick(function()
  if cocShown then
    print("balls filled")
   else
     print("balls emptied")
   end
  pings.fballs()
 
end)
function pings.fballs()
  --animating = true
  if fullB then
    fullB = false
   
   else
     fullB = true
     fullB2 = false
     
   end
  end
toggles:newAction()
:title("full balls 2")
:item("snow_block")
:onLeftClick(function()
  if cocShown then
    print("balls overflowing")
   else
     print("balls emptied")
   end
  pings.fballs2()
 
end)
function pings.fballs2()
  --animating = true
  if fullB2 then
    fullB2 = false
    
   
   else
     fullB2 = true
     fullB = false
     
   end
  end
actorsAction:newAction()
:title("cum")
:item("white_stained_glass")
:onLeftClick(function()
  
  pings.nutter()
 
end)
function pings.nutter()
  animating = true
  fullB2 = false
     fullB = false
  nuts = true
  jorkin = false
  fullSit = false
  end
actorsAction:newAction()
:title("jerk it")
:item("stick")
:onLeftClick(function()
  
  pings.jorker()
 
end)
actorsAction:newAction()
:title("sit with full balls ;)")
:item("heart_of_the_sea")
:onLeftClick(function()
  
  pings.fullSit()
 
end)
actorsAction:newAction()

    :title("sit §7(leftclick)§r")
  :toggleTitle("standup §7(leftclick)§r")
  :item("nether_brick_stairs")
  :setOnToggle(function(state)
    
    pings.sit()

  
 
end)
function pings.sit()
  if sit then
    sit = false
    animations.DVanDrag.sit:setPlaying(false)
    animations.example.sit:setPlaying(false)
  else
    sit = true
  end
  animating = false
 
  nuts = false
  
  jorkin = false
  fullSit = false
end

function pings.sitFull()

end
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
function pings.jorker()
  
  if fullB2 then
    prevAnimF2 = true
    fullB2 = false
  end
  if fullB then
    prevAnimF = true
    fullB = false
  end
  nuts = false
  jorkin = true
  sit = false
  fullSit = false
  end
  function pings.fullSit()
    animating = true
    --fullB2 = false
      -- fullB = false
    nuts = false
    sit = false
    jorkin = false
    fullSit = true
    end
--tick event, called 20 times per second
function events.tick()
  if Erect and fullB or Erect and fullB2 then
    animations.DVanDrag.erectCock:setPlaying(false)
  else
    animations.DVanDrag.erectCock:setPlaying(true)
  end
  if not animating and Erect or animating and Erect then
    if not fullB and not fullB2 then
    animations.DVanDrag.erectCock:setPlaying(true)
    end
else
  animations.DVanDrag.erectCock:setPlaying(false)
end
  if sit then
    models.example.Body:setPos(0,0,0)
    models.example.Body:setRot(30)
    --models.example.LeftLeg:setPos(0,0,0)
    --models.example.LeftLeg:setRot(30)
    --models.example.RightLeg:setPos(0,0,0)
    --models.example.RightLeg:setRot(30)
    models.example.Head:setPos(0, 0,0)
    models.example.Head:setRot(30)
  end
  --code goes here
end
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
        renderer:setShadowRadius(scale)
    else
        local tinyscale = math.max(scale, .2) * 2
        nameplate.ENTITY:setScale(tinyscale, tinyscale, tinyscale)
        renderer:setShadowRadius(tinyscale-0.25)
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
  if sit then
    renderer:setOffsetCameraPivot(0, -0.25, 0)
    animations.DVanDrag.sit:setOverride(true)
    animations.DVanDrag.sit:setPlaying(true)
    
    animations.example.sit:setPlaying(true)
    animations.example.sit:setOverride(true)
    models.DVanDrag.bodies.LeftLeg:setRot(0,0,0)
    models.DVanDrag.bodies.RightLeg:setRot(0,0,0)
  else
    renderer:setOffsetCameraPivot(0, 0, 0)
  end
  models.example.Body.Lwing:setPrimaryRenderType("translucent_cull")
  models.example.Body.Rwing:setPrimaryRenderType("translucent_cull")
  models.DVanDrag.bodies.Body.Lwing:setPrimaryRenderType("translucent_cull")
  models.DVanDrag.bodies.Body.Rwing:setPrimaryRenderType("translucent_cull")
  if context == "PAPERDOLL" or context == "GUI" then
    models:setScale(1, 1, 1)
end
 if fullSit then
 
   models.DVanDrag.bodies.Body.Rwing:setRot(0,2,0)
   models.DVanDrag.bodies.Body.Lwing:setRot(0,178,0)
 end
end

function events.post_render(delta, type)
    if type == "FIRST_PERSON" or type == "RENDER" then return end
    models:setScale(scale, scale, scale)
end

--render event, called every time your avatar is rendered
--it have two arguments, "delta" and "context"
--"delta" is the percentage between the last and the next tick (as a decimal value, 0.0 to 1.0)
--"context" is a string that tells from where this render event was called (the paperdoll, gui, player render, first person)
function events.render(delta, context)
 models.DVanDrag.bodies.Body.cabs:setPos(0,0,0)
 models.example.Head:setPos(0,0,0)
 models.DVanDrag:setPos(0,0,0)
  if fullSit then
    if fullB then
      models["DVanDrag"]["bodies"]["Body"]["cabs"]["ball prey 1"]:setVisible(false)
      models["DVanDrag"]["bodies"]["Body"]["cabs"]["ball prey 2"]:setVisible(false)
      models["DVanDrag"]["bodies"]["Body"]["cabs"]["ball prey 3"]:setVisible(false)
      models["DVanDrag"]["bodies"]["Body"]["cabs"]["ball prey 4"]:setVisible(false)
      models["DVanDrag"]["bodies"]["Body"]["cabs"]["ball prey 5"]:setVisible(false)
      models["DVanDrag"]["bodies"]["Body"]["cabs"]["ball prey 6"]:setVisible(false)
    else
      models["DVanDrag"]["bodies"]["Body"]["cabs"]["ball prey 1"]:setVisible(true)
      models["DVanDrag"]["bodies"]["Body"]["cabs"]["ball prey 2"]:setVisible(true)
      models["DVanDrag"]["bodies"]["Body"]["cabs"]["ball prey 3"]:setVisible(true)
      models["DVanDrag"]["bodies"]["Body"]["cabs"]["ball prey 4"]:setVisible(true)
      models["DVanDrag"]["bodies"]["Body"]["cabs"]["ball prey 5"]:setVisible(true)
      models["DVanDrag"]["bodies"]["Body"]["cabs"]["ball prey 6"]:setVisible(true)
    end

end
  if animating then
    models.example:setVisible(false)
    models.DVanDrag.head2.Head.leftEar:setVisible(true)
    models.DVanDrag.head2.Head.rightEar:setVisible(true)
    models.DVanDrag.bodies.Body.Rwing:setVisible(true)
    models.DVanDrag.bodies.Body.Lwing:setVisible(true)
    models.DVanDrag.bodies.Body.RTIT:setVisible(true)
    models.DVanDrag.bodies.Body.LTIT:setVisible(true)
    models.DVanDrag.bodies.Body.tail:setVisible(true)
    models.DVanDrag.bodies.LeftLeg.LL.Thigh.ButtL:setVisible(true)
    models.DVanDrag.bodies.RightLeg.RL.Thigh1.ButtR:setVisible(true)
  else
    models.example:setVisible(true)
    models.DVanDrag.head2.Head.leftEar:setVisible(false)
    models.DVanDrag.head2.Head.rightEar:setVisible(false)
    models.DVanDrag.bodies.Body.Rwing:setVisible(false)
    models.DVanDrag.bodies.Body.Lwing:setVisible(false)
    models.DVanDrag.bodies.Body.RTIT:setVisible(false)
    models.DVanDrag.bodies.Body.LTIT:setVisible(false)
    models.DVanDrag.bodies.Body.tail:setVisible(false)
    models.DVanDrag.bodies.LeftLeg.LL.Thigh.ButtL:setVisible(false)
    models.DVanDrag.bodies.RightLeg.RL.Thigh1.ButtR:setVisible(false)
  end
  if sit then
    models.DVanDrag.head2:setRot(-20.5,0,0)
    models.DVanDrag.head2:setPos(0,-2,0)
    models.example.Body.RTIT:setPos(0,0.5,-1)
    models.example.Body.LTIT:setPos(0,0.5,-1)
    models.example.Head:setPos(0, 0, 0)
  else
    models.DVanDrag.head2:setRot(0,0,0)
    models.DVanDrag.head2:setPos(0,0,0)
    models.example.Body.RTIT:setPos(0,0,0)
    models.example.Body.LTIT:setPos(0,0,0)
  end
  if player:getPose() == "CROUCHING" then
    
    models.DVanDrag.head2:setPos(0, 0, 0)
    models.example.Head:setPos(0, 0, -2)
    --models.DVanDrag.bodies.Body.cabs:setPos(0,1.5,10)
    models.DVanDrag.bodies.Body.cabs:setPos(0,2.5,-0.8)
    models.example.Head:setPos(0,0,-2)
    models.example:setRot(5,0,0)
    --models.example.Body.RTIT:setRot(0,0,0)
    --models.example.Body.LTIT:setRot(0,0,0)
    if sit then
      models.DVanDrag.head2.Head:setPos(0, -8, 0)
      --models.example.Head:setPos(0, -10, -2)
      
    else
      models.DVanDrag.head2.Head:setPos(0,4,0)
    end
    
else
  models.example:setRot(0,0,0)
  --models.DVanDrag.bodies.Body.cabs:setPos(0,0,0)
  models.example.Body:setPos(0, -13, 2) 
  models.example.Body:setRot(35) 
  models.example.LeftLeg:setPos(0, -10, 0)
  models.example.LeftLeg:setRot(30)
  models.example.RightLeg:setPos(0, -10, 0)
  models.example.RightLeg:setRot(30)
 
 -- models.example.Head:setPos(0, -15, 5)
  models.DVanDrag.head2.Head:setPos(0,0,0)
 -- models.example.Head:setRot(30)
end
  local camRot = player:getRot()
  local bodyRot = vanilla_model.BODY:getOriginRot()

  local pitch = -camRot[1]
  local yaw = camRot[2]   -- rotate 180° left
  if jorkin then
    animations.DVanDrag.yorkinit:setPlaying(true)
    if prevAnimF then
      animations.DVanDrag.fullBallsJork:setPlaying(true)
      animations.DVanDrag.fullBalls:setPlaying(false)
    end
    if prevAnimF2 then
      animations.DVanDrag.fullerBalls:setPlaying(false)
      animations.DVanDrag.fullerBallsJork:setPlaying(true)
    end
  else
    animations.DVanDrag.yorkinit:setPlaying(false)
  end
  if nuts then
    animations.DVanDrag.fNUT:setPlaying(true)
  else
    animations.DVanDrag.fNUT:setPlaying(false)
  end
  if sit then
    animations.DVanDrag.sit:setOverride(true)
    animations.DVanDrag.sit:setPlaying(true)
    
    animations.example.sit:setPlaying(true)
    animations.example.sit:setOverride(true)
    models.DVanDrag.bodies.LeftLeg:setRot(0,0,0)
    models.DVanDrag.bodies.RightLeg:setRot(0,0,0)
    animations.DVanDrag.sit:setPriority(100)
    models.DVanDrag.head2.Head:setPos(0, 0, -2)
    models.example.Body:setPos(0, -13, 2) 
    models.example.Body:setRot(35)
    models.example.LeftLeg:setPos(0, -10, 0)
    models.example.LeftLeg:setRot(30)
    models.example.RightLeg:setPos(0, -10, 0)
    models.example.RightLeg:setRot(30)
  models.DVanDrag:setPos(0,1,0)
    models.example.Head:setPos(0, -14, 3)
   -- models.example.Head:setRot(30)
    
    
  else
    animations.DVanDrag.sit:setPlaying(false)
    animations.example.sit:setPlaying(false)
    models.DVanDrag.head2.Head:setPos(0, 0, 0)
    models.example.Body:setPos(0,0,0)
    models.example.Body:setRot(0)
    models.example.LeftLeg:setPos(0,0,0)
    models.example.LeftLeg:setRot(0)
    models.example.RightLeg:setPos(0,0,0)
    models.example.RightLeg:setRot(0)
   
   --models.example.Head:setRot(0)
    --models.DVanDrag:setPos(0,0,0)
  end
  if fullB and sit or fullB2 and sit then
    models.DVanDrag.bodies.RightLeg:setRot(10,-20,0)
    models.DVanDrag.bodies.LeftLeg:setRot(10,20,0)
    models.DVanDrag.bodies.Body.cabs:setPos(0,2,0)
    models.DVanDrag.bodies.Body.cabs:setRot(5,0,0)
    models["DVanDrag"]["bodies"]["Body"]["cabs"]["ball prey 6"]:setVisible(false)
    models["DVanDrag"]["bodies"]["Body"]["cabs"]["ball prey 5"]:setVisible(false)
    models["DVanDrag"]["bodies"]["Body"]["cabs"]["ball prey 4"]:setVisible(false)
  else
    models.DVanDrag.bodies.RightLeg:setRot(0,0,0)
    models.DVanDrag.bodies.LeftLeg:setRot(0,0,0)
    --models.DVanDrag.bodies.Body.cabs:setPos(0,0,0)
    --models.DVanDrag.bodies.Body.cabs:setRot(0,0,0)
    models["DVanDrag"]["bodies"]["Body"]["cabs"]["ball prey 6"]:setVisible(true)
    models["DVanDrag"]["bodies"]["Body"]["cabs"]["ball prey 5"]:setVisible(true)
    models["DVanDrag"]["bodies"]["Body"]["cabs"]["ball prey 4"]:setVisible(true)
  end
  
  if cocShown then
    models.DVanDrag.bodies.Body.cabs:setVisible(true)
    --models.DVandDrag.bodies.cabs.cock:setVisible(true)
  else
    --models.DVandDrag.bodies.cabs.cock:setVisible(true) 
    models.DVanDrag.bodies.Body.cabs:setVisible(false)
  end
  if fullB then
    animations.DVanDrag.fullBalls:setPlaying(true)
    --models.DVandDrag.bodies.cabs.cock:setVisible(true)
  else
    --models.DVandDrag.bodies.cabs.cock:setVisible(true) 
    animations.DVanDrag.fullBalls:setPlaying(false)
  end
  if fullB2 then
    animations.DVanDrag.fullerBalls:setPlaying(true)
    --models.DVandDrag.bodies.cabs.cock:setVisible(true)
  else
    --models.DVandDrag.bodies.cabs.cock:setVisible(true) 
    animations.DVanDrag.fullerBalls:setPlaying(false)
  end
  if fullSit then
    animations.DVanDrag.sitFull:setPlaying(true)
  else
    animations.DVanDrag.sitFull:setPlaying(false)
  end
  if player:isGliding() then
    animations.DVanDrag.glide:setPlaying(true)
    
      models.example.Body.tail:setRot(70,0,0)
      models.example.Body.tail.tail2:setRot(5,0,0)
      models.example.Body.tail.tail2.tail3:setRot(5,0,0)
      models.example.Body.tail.tail2.tail3.tail4:setRot(5,0,0)
    
  else
    animations.DVanDrag.glide:setPlaying(false)
  end
  local walking = player:getVelocity().xz:length() > 0.01
  
  if walking and player:getVelocity().xz:length() < 1 then
    --animations.DVanDrag.walks:setPlaying(true)
    if prevAnimF2 then
      fullB2 = true
    animations.DVanDrag.fullerBallsJork:setPlaying(false)
      prevAnimF2 = false
    end
    if prevAnimF then
      fullB= true
      animations.DVanDrag.fullBallsJork:setPlaying(false)
      prevAnimF = false
    end
    nuts = false
    jorkin = false
    fullSit = false
    
    animating = false
  else
    --animations.DVanDrag.walks:setPlaying(false)
  end
  -- Set your object's rotation
  --models.DVanDrag.head2.Head.headStuff:setRot((pitch)*0.05)
  --models.DVanDrag.bodies:setRot(bodyRot)
  
  --animations.DVanDrag.wings:setPlaying(true)
  --animations.DVanDrag.toggleCock:setPlaying(true)
end



