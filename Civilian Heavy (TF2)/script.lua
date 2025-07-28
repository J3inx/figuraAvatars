--hide vanilla model
vanilla_model.PLAYER:setVisible(false)

--hide vanilla armor model
vanilla_model.ARMOR:setVisible(false)

--hide vanilla cape model
vanilla_model.CAPE:setVisible(false)

--hide vanilla elytra model
vanilla_model.ELYTRA:setVisible(false)
models.model.root:setParentType("Camera")

function events.tick()
    local death = player:getDeathTime()
    if death == 1 then
    sounds:playSound("deathCustom", player:getPos(), 1, 1, false)
end
end

local mainPage = action_wheel:newPage()
action_wheel:setPage(mainPage)

function pings.pow()
    sounds:stopSound("dispenser")
    sounds:stopSound("pow")
    sounds:playSound("pow", player:getPos(), 1, 1, false)
end

local action = mainPage:newAction()
    :title("Pow-haha!")
    :item("minecraft:diamond")
    :hoverColor(1, 0, 1)
    :onLeftClick(pings.pow)

function pings.dispenser()
    sounds:stopSound("dispenser")
    sounds:stopSound("pow")
    sounds:playSound("dispenser", player:getPos(), 1, 1, false)
end

local action = mainPage:newAction()
    :title("Put dispenser here.")
    :item("minecraft:diamond")
    :hoverColor(1, 0, 1)
    :onLeftClick(pings.dispenser)