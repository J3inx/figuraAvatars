---------------------------------------------------------------------------------------------------------------
---ANIMATION SETUP--- FIX CROUCH & LIMBS
local anims = require("lib.EZAnims")
local bunny = anims:addBBModel(animations.model)
bunny:setBlendTimes(0)

animations.model.smile:setBlendTime(5)
animations.model.sit:setBlendTime(5)
animations.model.hide_items:setBlendTime(5)
animations.model.jumpingup:setBlendTime(5)
animations.model.jumpingdown:setBlendTime(5)
---------------------------------------------------------------------------------------------------------------
---PLAYER MODEL ADJUSTMENTS---
vanilla_model.PLAYER:setVisible(false)
vanilla_model.ARMOR:setVisible(false)
vanilla_model.ELYTRA:setVisible(false)
models.model.whole.body.torsorot.LeftArm.LeftItemPivot:setScale(0.8, 0.8, 0.8)
models.model.whole.body.torsorot.RightArm.RightItemPivot:setScale(0.8, 0.8, 0.8)
models.model.whole.body.torsorot.Body.ELYTRA_PIVOT:setScale(0.8, 0.8, 0.8)

models.model.whole:setScale(0.95, 0.95, 0.95)

---------------------------------------------------------------------------------------------------------------
---CONFIG SAVES---
local mainPage = action_wheel:newPage()
local selected = 0



local heads = {}
local skull_model = models.model.Skull

--123yeah_boi321's SQUASHSCRIPT
local DURATION = 10

function events.world_tick()
    local count = 0
    for i,v in pairs(heads) do 
        count = count + 1
        v.stretch = v.stretch + 1
        if v.stretch >= DURATION then heads[i] = nil end
    end
    
end

function events.SKULL_RENDER(delta,block,item,entity,type)
    if type == "BLOCK" then
        
        for name,player in pairs(world.getPlayers()) do
            local target_block,hit_pos,side = player:getTargetedBlock()
            if player:getSwingTime() == 2 and target_block:getPos() == block:getPos() then
                sounds:playSound("audiomass-outputperf",block:getPos(),0.1)
                heads[tostring(block:getPos())] = {stretch = 0}
            end
        end
        local head = heads[tostring(block:getPos())]
        if head then
            local stretch = outElastic(head.stretch+delta, 0.1, -0.1, DURATION, 1, 6)
            if block.id:find("wall") then
                stretch = stretch/2
                skull_model:setScale(1+stretch,1+stretch,1-stretch)
                skull_model:setPos(0,-stretch*4,stretch*4)
            else
                skull_model:setScale(1+stretch,1-stretch,1+stretch)
            end
        else
            skull_model:setScale(1)
            skull_model:setPos(0,0,0)
        end
    else
        skull_model:setScale(1)
        skull_model:setPos(0,0,0)    
    end
end

function outElastic(t, b, c, d, a, p)
    if t == 0 then return b end
  
    t = t / d
  
    if t == 1 then return b + c end
  
    if not p then p = d * 0.3 end
  
    local s
  
    if not a or a < math.abs(c) then
      a = c
      s = p / 4
    else
      s = p / (2 * math.pi) * math.asin(c/a)
    end
  
    return a * math.pow(2, -10 * t) * math.sin((t * d - s) * (2 * math.pi) / p) + c + b
  end

function outElastic(t, b, c, d, a, p)
    if t == 0 then return b end
  
    t = t / d
  
    if t == 1 then return b + c end
  
    if not p then p = d * 0.3 end
  
    local s
  
    if not a or a < math.abs(c) then
      a = c
      s = p / 4
    else
      s = p / (2 * math.pi) * math.asin(c/a)
    end
  
    return a * math.pow(2, -10 * t) * math.sin((t * d - s) * (2 * math.pi) / p) + c + b
  end

config:setName("Cotton")
function events.entity_init()
    if config:load("pov") == nil then
        config:save("pov", false)
    end
    if config:load("equip") == nil then
        config:save("equip", true)
    end
    
    if config:load("pov") then
    renderer:setEyeOffset(0, -0.3, 0)
    renderer:setOffsetCameraPivot(0, -0.3, 0)
    end
end

---------------------------------------------------------------------------------------------------------------
---RENDER FIRST PERSON ARM---
function events.render(delta, context)
    local firstPerson = context == "FIRST_PERSON"
    models.model.RightArm:setVisible(firstPerson)
    models.model.whole.body.torsorot.RightArm:setVisible(not firstPerson)
end

nameplate.Entity:setText(avatar:getEntityName() .. " :bunny:")
---------------------------------------------------------------------------------------------------------------
---IDLE BODY MOVEMENTS---
animations.model.idle_2:setSpeed(0.15)
animations.model.idle_2:play()
animations.model.idle_1:setSpeed(0.3)
animations.model.idle_1:play()
animations.model.idle_3:setSpeed(0.3)
animations.model.idle_3:play()
animations.model.idle_4:setSpeed(0.2)
animations.model.idle_4:play()

---------------------------------------------------------------------------------------------------------------
---HAIR PHYSICS---
local SwingingPhysics = require("lib.swinging_physics")

SwingingPhysics.swingOnHead(models.model.whole.body.torsorot.head.hair.front_hair, 90, { -2, 5, -0, 0, -5, 5 },
    nil, 0)


SwingingPhysics.swingOnHead(models.model.whole.body.torsorot.head.hair.front_hair.lf_hair, 90, { -30, 40, -0, 0, -35, 5 },
    nil, 1)
SwingingPhysics.swingOnHead(models.model.whole.body.torsorot.head.hair.front_hair.rf_hair, 90, { -30, 40, -0, 0, -5, 35 },
    nil, 1)
SwingingPhysics.swingOnHead(models.model.whole.body.torsorot.head.hair.l_h, 90, { -10, 0, -0, 0, -15, 5 },
    nil, 2)
SwingingPhysics.swingOnHead(models.model.whole.body.torsorot.head.hair.r_h, 90, { -10, 0, -0, 0, -5, 15 },
    nil, 2)
SwingingPhysics.swingOnHead(models.model.whole.body.torsorot.head.hair.back_hair, 90, { -10, 2, -0, 0, -10, 10 },
    nil, 0)

SwingingPhysics.swingOnHead(models.model.whole.body.torsorot.head.hair.r_h.r_tail, 90, { -20, 20, -0, 0, -10, 10 },
    nil, 3)
SwingingPhysics.swingOnHead(models.model.whole.body.torsorot.head.hair.l_h.l_tail, 90, { -20, 20, -0, 0, -10, 10 },
    nil, 3)

---------------------------------------------------------------------------------------------------------------
---SQUAPI APPLICATIONS---
local squapi = require("lib.SquAPI")

---HEAD---
squapi.smoothHead:new(
    {
        models.model.whole.body,
        models.model.whole.body.torsorot.head,
        models.model.whole.body.torsorot.head.rabbit.head --element(you can have multiple elements in a table)
    },
    nil,                                                  --(1) strength(you can make this a table too)
    nil,                                                  --(0.1) tilt
    0.8,                                                  --(1) speed
    false                                                 --(true) keepOriginalHeadPos
)

---EYES---
squapi.eye:new(
    models.model.whole.body.torsorot.head.eyes.iris2, --the eye element
    0.5,                                              --(0.2) left distance
    0.5,                                              --(0.3) right distance
    0.7,                                              --(0.5) up distance
    0.7                                               --(0.5) down distance
)

squapi.eye:new(
    models.model.whole.body.torsorot.head.eyes.iris, --the eye element
    0.5,                                             --(0.2) left distance
    0.5,                                             --(0.3) right distance
    0.7,                                             --(0.5) up distance
    0.7                                              --(0.5) down distance
)



squapi.ear:new(
    models.model.whole.body.torsorot.head.ears.e1, --leftEar
    models.model.whole.body.torsorot.head.ears.e2, --(nil) rightEar
    nil,                                           --(1) rangeMultiplier
    false,                                         --(false) horizontalEars
    nil,                                           --(2) bendStrength
    nil,                                           --(true) doEarFlick
    nil,                                           --(400) earFlickChance
    nil,                                           --(0.1) earStiffness
    nil                                            --(0.8) earBounce
)

squapi.bewb:new(
    models.model.whole.body.torsorot.head.rabbit, --element
    1,                                            --(2) bendability
    nil,                                          --(0.05) stiff
    nil,                                          --(0.9) bounce
    false,                                        --(true) doIdle
    nil,                                          --(4) idleStrength
    nil,                                          --(1) idleSpeed
    nil,                                          --(-10) downLimit
    nil                                           --(25) upLimit
)
local blink = squapi.randimation:new(
    animations.model.blink, --animation
    nil,                    --(200) chanceRange
    true                    --(false) isBlink
)

---------------------------------------------------------------------------------------------------------------

---ELYTRA RENDER---

local wings = models.model.whole.body.torsorot.Body.wings
local rabbit = models.model.whole.body.torsorot.head.rabbit


---
---ACTION WHEEL---
local actionwheel = action_wheel:newPage()
action_wheel:setPage(actionwheel)

local smile = false
local ely = config:load("equip")
local sit = false
local tpov = config:load("pov")




function pings.smileSwitch()
    smile = not smile
    blink.enabled = not smile
    animations.model.smile:setPlaying(smile)
end

function pings.sit()
    sit = not sit
    animations.model.sit:setPlaying(sit)
    animations.model.hide_items:setPlaying(sit)

end

function events.tick()
    local crouching = player:getPose() == "CROUCHING"
    local sprinting = player:isSprinting()
    local walking = player:getVelocity().xz:length() > 0.01 or animations.model.walking:isPlaying()
    local jumping = animations.model.jumpingup:isPlaying()

    if sit
    then
        if not (walking or crouching or idlesOff or jumping or sprinting) then
            animations.model.sit:setPlaying(sit)
            animations.model.hide_items:setPlaying(sit)
        else
            sit = false
            animations.model.hide_items:stop()
            animations.model.sit:stop()
        end
    end
    if not ely then
        if player:getItem(6).id == "minecraft:air" then
            rabbit:setVisible(false)
        else
            rabbit:setVisible(true)
        end

        if player:getItem(5).id == "minecraft:elytra" then
            wings:setVisible(true)
        else
            wings:setVisible(false)
        end
    end
end

vanilla_model.ELYTRA:setVisible(ely)
rabbit:setVisible(not ely)
wings:setVisible(not ely)

function pings.elytoggle()
    ely = not ely

    vanilla_model.ELYTRA:setVisible(ely)
    rabbit:setVisible(not ely)
    wings:setVisible(not ely)
    config:save("equip", ely)
end

function pings.actiontpovclicked()
    if tpov == true then
        renderer:setEyeOffset(0, 0, 0)
        renderer:setOffsetCameraPivot(0, 0, 0)
        tpov = false
    else
        renderer:setEyeOffset(0, -0.3, 0)
        renderer:setOffsetCameraPivot(0, -0.3, 0)
        tpov = true
    end
    config:save("pov", tpov)
end

local povtog = actionwheel:newAction()
    :title("Normal sight active")
    :toggleTitle("Height sight active")
    :item("minecraft:cake")
    :toggleItem("minecraft:milk_bucket")
    :hoverColor(1, 0, 1)
    :onToggle(pings.actiontpovclicked)
    function pings.player()
        if selected == 0 then
            log("no sound selected")
            
          elseif selected == 1 then
            sounds:playSound("testSound", player:getPos())
            log("played sound 1")
          elseif selected == 2 then 
            sounds:playSound("testSound", player:getPos())
            log("played sound 2")
          elseif selected == 3 then 
            sounds:playSound("testSound", player:getPos())
            log("played sound 3")
          elseif selected == 4 then 
            sounds:playSound("testSound", player:getPos())
            log("played sound 4")
          elseif selected == 5 then 
            sounds:playSound("testSound", player:getPos())
            log("played sound 5")
    
          
        
      end
        end
    function pings.scrolling(dir)
        --log(dir)
        if dir > 0 then
            if selected == 5 then
              selected = 0
            else
              selected = selected +1
            end
            log(selected)
        else
            
            if selected == 0 then
              selected = 5
            else
              selected = selected -1
            end
            log(selected)
        end
      end
      mainPage:newAction()
          :title("select sound §7(scroll)§r")
          :item("jukebox")
          :setOnScroll(pings.scrolling)
      mainPage:newAction()
          :title("play sound §7(left click)§r")
          :item("arrow")
          :setOnLeftClick(pings.player) 
            
    actionwheel:newAction()
    :title("Smile")
    :item("minecraft:golden_carrot")
    :hoverColor(1, 0, 1)
    :onLeftClick(pings.smileSwitch)

actionwheel:newAction()
    :title("Sit")
    :item("minecraft:oak_slab")
    :hoverColor(1, 0, 1)
    :onLeftClick(pings.sit)
actionwheel:newAction()
    :title("go to sounds page")
    :item("jukebox")
    :hoverColor(1, 0, 1)
    :onLeftClick(function()action_wheel:setPage(mainPage) end)
mainPage:newAction()
    :title("go back")
    :item("barrier")
    :hoverColor(1, 0, 1)
    :onLeftClick(function()action_wheel:setPage(actionwheel) end)

local elytog = actionwheel:newAction()
    :title("Custom equipment active")
    :toggleTitle("Hide equipment active")
    :item("minecraft:feather")
    :toggleItem("minecraft:bone")
    :hoverColor(1, 0, 1)
    :onToggle(pings.elytoggle)

    povtog:setToggled(config:load("pov"))
    elytog:setToggled(config:load("equip"))


---------------------------------------------------------------------------------------------------------------
---CUSTOM LEGS - ARMS - SKIRT MOVEMENT
function events.render()
    local rot_l = vanilla_model.LEFT_LEG:getOriginRot()
    local rot_r = vanilla_model.RIGHT_LEG:getOriginRot()

    --skirt
    models.model.whole.body.torsorot.Body.skirt.c_front:setRot((math.abs(rot_l.x) + math.abs(rot_r.x)) * 0.15, nil, nil)
    models.model.whole.body.torsorot.Body.skirt.c_back:setRot(-(math.abs(rot_l.x) + math.abs(rot_r.x)) * 0.15, nil, nil)
    models.model.whole.body.torsorot.Body.skirt.l_leg:setRot(rot_l.x * 0.2, nil, nil)
    models.model.whole.body.torsorot.Body.skirt.r_leg:setRot(rot_r.x * 0.2, nil, nil)
    models.model.whole:setPos(nil, (math.sin(math.abs(rot_r.x/70)) * 1.5), nil) -- bounce
    models.model.whole.body.torsorot.Body.tail.wiggle:setRot(nil, rot_r.x * 0.4, nil) -- tail wiggle
    models.model.whole.body.torsorot.head.ears.e1:setRot(nil, nil, (-math.cos(math.abs(rot_l.x)/20)*4) + 30)
    models.model.whole.body.torsorot.head.ears.e2:setRot(nil, nil, (math.cos(math.abs(rot_l.x)/20)*4) - 30)

    --arms
    models.model.whole.body.torsorot.RightArm:setRot(-rot_l * 0.3)
    models.model.whole.body.torsorot.LeftArm:setRot(-rot_r * 0.3)
    --legs
    models.model.whole.RightLeg:setRot(-rot_r * 0.2)
    models.model.whole.LeftLeg:setRot(-rot_l * 0.2)


end
