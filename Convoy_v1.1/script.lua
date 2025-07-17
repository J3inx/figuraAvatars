-- Auto generated script file --

--hide vanilla model
vanilla_model.PLAYER:setVisible(false)

--hide vanilla armor model
vanilla_model.ARMOR:setVisible(false)
--re-enable the helmet item
vanilla_model.HELMET_ITEM:setVisible(true)

--hide vanilla cape model
vanilla_model.CAPE:setVisible(false)

--hide vanilla elytra model
vanilla_model.ELYTRA:setVisible(false)

local mainPage = action_wheel:newPage()
action_wheel:setPage(mainPage)

function pings.truck(state)
    animations.model.Truck:setPlaying(state)
end

function pings.robot(state)
    animations.model.Truck:stop(state)
    animations.model.Robot:play(state)
end

local toggleaction = mainPage:newAction()
    :title("Roll Out!")
    :toggleTitle("Transform!")
    :item("minecart")
    :toggleItem("armor_stand")
    :setOnToggle(pings.truck)
    :setOnUntoggle(pings.robot)


