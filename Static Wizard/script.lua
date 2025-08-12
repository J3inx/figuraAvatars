vanilla_model.PLAYER:setVisible(false)
vanilla_model.HELMET:setVisible(false)

require("GSAnimBlend")

animations.wizard.idleStaff:blendTime(6)
animations.wizard.walkStaff:blendTime(6)
animations.wizard.crouchStaff:blendTime(6)
animations.wizard.turnStart:blendTime(6)
animations.wizard.attackStaff:priority(1)

local head = models.wizard.root.Head

local static = {}
static["staticValue"] = 0
static["sound"] = sounds["block.conduit.attack.target"]:subtitle("zap"):pitch(9)

head.Hat:setPrimaryRenderType("Translucent_Cull")
models.wizard.root.RightArm.LowerRightArm.Staff.spark:setPrimaryRenderType("Translucent_Cull")
models.wizard.root.RightArm.LowerRightArm.Staff.spark:setSecondaryTexture("Primary")
models.wizard.ItemTrident.spark7:setPrimaryRenderType("Translucent_Cull")
models.wizard.ItemTrident.spark7:setSecondaryTexture("Primary")
models.wizard.ItemWand.zap:setPrimaryRenderType("Translucent_Cull")
models.wizard.ItemWand.zap:setSecondaryTexture("Primary")
head:setParentType("None")

local keybindState = false
function pings.scratch(state)
    keybindState = state
end
local exampleKey = keybinds:newKeybind("Scratch Beard", "key.keyboard.h")
exampleKey.press = function()
    pings.scratch(true)
end

exampleKey.release = function()
    pings.scratch(false)
end

local skulls = models.wizard.Skull
local wearHat = head.Hat:copy("NewHat"):setPos(0,-24,0):setPrimaryRenderType("Translucent_Cull")
local skullHat = skulls:newPart("Hat"):addChild(wearHat)
function events.skull_render(_,block,item,entity,mode)
    if not player:isLoaded() then return end
    if block then
        head:setPos(0,24,0)
        if block:getProperties().facing then
            skulls.Orb.Base:setVisible(false)
            skulls:setPos(0,-1,1)
        elseif block:getProperties().rotation then
            skulls.Orb.Base:setVisible(true)
            skulls:setPos(0,0,0)
        end
        skulls.Orb:setVisible(true)
        skullHat:setVisible(false)
    elseif mode == "HEAD" then
        skullHat:setVisible(true)
        skulls.Orb:setVisible(false)
    else
        skulls.Orb.Base:setVisible(true)
        skullHat:setVisible(false)
        skulls:setPos(0,0,0)
    end
end

animations.wizard.headX:play()
animations.wizard.headX:pause()

models.wizard.HUD:setPos((-client.getScaledWindowSize().x/2)-1,0,0):setScale(0)

function events.render(_,context)
    models.wizard.HUD:setScale(static.staticValue,1,1)
    local headRot = (vanilla_model.HEAD:getOriginRot()+180)%360-180
    local headX = math.map(headRot.x,-90,90,0,2)
    head:setPos(-vanilla_model.HEAD:getOriginPos())
    head:setRot(0,headRot.y,0)
    animations.wizard.headX:setTime(headX)
    animations.wizard.ponder:setPlaying(player:getTargetedBlock(true,1):toStateString():find(avatar:getEntityName()))

    local lefty  = player:isLeftHanded()
    local rightItem = player:getHeldItem(lefty)
    local leftItem = player:getHeldItem(not lefty)
    local orb = (rightItem.id == "minecraft:player_head" and rightItem:toStackString():find(avatar:getEntityName())) or (leftItem.id == "minecraft:player_head" and leftItem:toStackString():find(avatar:getEntityName()))
    if context ~= "FIRST_PERSON" then
        vanilla_model.RIGHT_ITEM:setVisible((leftItem.id ~= "minecraft:trident" and rightItem.id ~= "minecraft:trident") and not orb)
        vanilla_model.LEFT_ITEM:setVisible(leftItem.id ~= "minecraft:trident" and not orb)
        models.wizard.root.RightArm.LowerRightArm.Staff:setVisible(rightItem.id == "minecraft:trident" or leftItem.id == "minecraft:trident")
    else
        vanilla_model.RIGHT_ITEM:setVisible(true)
        vanilla_model.LEFT_ITEM:setVisible(true)
        models.wizard.root.RightArm.LowerRightArm.Staff:setVisible(false)
    end
end

local newTrident = models.wizard.ItemTrident:copy("Trident"):moveTo(models.wizard):setParentType("Trident"):setRot(270,0,0)
function events.item_render(item,mode)
    if item.id == "minecraft:trident" and mode:find("FIRST") then
        return models.wizard.ItemTrident
    end
    for _,value in pairs(item:getTags()) do
        if value == "minecraft:tools" and item.id ~= "minecraft:trident" then
            return models.wizard.ItemWand
        end
    end
end

local lastYaw
local yawDiff
function events.entity_init()
    lastYaw = player:getBodyYaw()
    yawDiff = lastYaw
end

function events.tick()
    local inWater = player:isInWater()
    local velocity = player:getVelocity()
    yawDiff = player:getBodyYaw() - lastYaw
    local walking = velocity.xz:length() > .01
    local pose = player:getPose()
    local standing = pose == "STANDING"
    local idle = not walking and standing
    local swimming = pose == "SWIMMING"
    local crouching = pose == "CROUCHING"
    local gliding = pose == "FALL_FLYING"
    local throw = player:getActiveItem().id == "minecraft:trident"

    local lefty  = player:isLeftHanded()
    local rightItem = player:getHeldItem(lefty)
    local leftItem = player:getHeldItem(not lefty)
    local staff = rightItem.id == "minecraft:trident" or leftItem.id == "minecraft:trident"
    local orb = (rightItem.id == "minecraft:player_head" and rightItem:toStackString():find(avatar:getEntityName())) or (leftItem.id == "minecraft:player_head" and leftItem:toStackString():find(avatar:getEntityName()))

    local wand = false
    for _,value in pairs(rightItem:getTags()) do
        if value == "minecraft:tools" and rightItem.id ~= "minecraft:trident" then
            wand = true
        end
    end
    for _,value in pairs(leftItem:getTags()) do
        if value == "minecraft:tools" and leftItem.id ~= "minecraft:trident" then
            wand = true
        end
    end

    animations.wizard.idleStaff:setPlaying((idle and staff) or (inWater and not swimming))
    animations.wizard.walkStaff:setPlaying(walking and standing and staff and not inWater)
    animations.wizard.turnStart:setPlaying(idle and staff and math.abs(yawDiff) > 0 and not inWater)
    animations.wizard.swimStaff:setPlaying((swimming or gliding) and staff)
    animations.wizard.crouchStaff:setPlaying(crouching and staff)
    animations.wizard.holdOrb:setPlaying((orb and not staff) and standing)
    animations.wizard.throwStaff:setPlaying(throw)
    animations.wizard.throwStaff:setPriority(1)
    models.wizard.root.RightArm.LowerRightArm.HandOrb:setVisible((orb and not staff) and standing)

    animations.wizard.walkStaff:setSpeed(velocity:length()*4)

    animations.wizard.scratch:setPlaying(keybindState)

    lastYaw = player:getBodyYaw()
    if player:getSwingTime() == 1 then
        if staff then
            animations.wizard.attackStaff:play()
        elseif wand then
            animations.wizard["attackWand"..math.random(2)]:play()
        end
    end
    local wandAttacks = animations.wizard.attackWand2:isPlaying() or animations.wizard.attackWand1:isPlaying()
    models.wizard.root.RightArm.LowerRightArm.Staff.spark:setVisible(animations.wizard.attackStaff:isPlaying() and static.staticValue > 0)
    models.wizard.ItemTrident.spark7:setVisible(animations.wizard.attackStaff:isPlaying() and static.staticValue > 0)
    models.wizard.ItemWand.zap:setVisible(wandAttacks and static.staticValue > 0)
end

function events.on_play_sound(id)
    if id == "minecraft:entity.lightning_bolt.thunder" then
        static.staticValue = static.staticValue + 1
        animations.wizard.hatspark:play()
    end
end

return static