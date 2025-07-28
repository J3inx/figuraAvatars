-- Auto generated script file --

--hide vanilla model
vanilla_model.PLAYER:setVisible(false)

--hide vanilla armor model
vanilla_model.ARMOR:setVisible(false)

--hide vanilla cape model
vanilla_model.CAPE:setVisible(false)

--hide vanilla elytra model
vanilla_model.ELYTRA:setVisible(false)

local mainPage = action_wheel:newPage()
action_wheel:setPage(mainPage)

function pings.pow()
    sounds:stopSound("dispenser")
    sounds:stopSound("pow")
    sounds:playSound("pow", player:getPos(), 1, 1, false)
end

local action = mainPage:newAction()
    :title("Pow-haha!")
    :item("minecraft:stick")
    :hoverColor(1, 0, 1)
    :onLeftClick(pings.pow)

function pings.dispenser()
    sounds:stopSound("dispenser")
    sounds:stopSound("pow")
    sounds:playSound("dispenser", player:getPos(), 1, 1, false)
end

local action = mainPage:newAction()
    :title("Put dispenser here.")
    :item("minecraft:stick")
    :hoverColor(1, 0, 1)
    :onLeftClick(pings.dispenser)

function pings.thank()
    sounds:stopSound("dispenser")
    sounds:stopSound("pow")
    sounds:playSound("thank", player:getPos(), 1, 1, false)
end

local action = mainPage:newAction()
    :title("Thank you!")
    :item("minecraft:stick")
    :hoverColor(1, 0, 1)
    :onLeftClick(pings.thank)

function pings.spy()
    sounds:stopSound("dispenser")
    sounds:stopSound("pow")
    sounds:playSound("spy", player:getPos(), 1, 1, false)
end

local action = mainPage:newAction()
    :title("Spy!")
    :item("minecraft:stick")
    :hoverColor(1, 0, 1)
    :onLeftClick(pings.spy)