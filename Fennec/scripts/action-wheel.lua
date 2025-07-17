local toggles = action_wheel:newPage()
local mainPage = action_wheel:newPage()
action_wheel:setPage(mainPage)

local togglename = toggles:newAction()
:title("Show Belly")
:toggleTitle("Hide Belly")
:item("crimson_button")
:setOnToggle(function(state)
    pings.Belly(state)
end)
function pings.Belly(state)
    if state then
        models.model.root.Body.belly:setVisible(true)
    else
        models.model.root.Body.belly:setVisible(false)
    end
end

local togglename = toggles:newAction()
:title("Show Sheath")
:toggleTitle("Turn Off NSFW")
:item("warped_button")
:setOnToggle(function(state)
    pings.Cock(state)
end)
function pings.Cock(state)
    if state then
        models.model.penissheathed:setVisible(true)
    else
        models.model.penissheathed:setVisible(false)
    end
end


local togglename = toggles:newAction()
:title("Show Penis")
:toggleTitle("Disable Penis")
:item("polished_blackstone_button")
:setOnToggle(function(state)
    pings.penislow(state)
        pings.penislow(state)
end)


function pings.penislow(state)
    if state then
    models.model.penislow:setVisible(true)
  else
    models.model.penislow:setVisible(false)
  end
end

local togglename = toggles:newAction()
:title("Aroused")
:toggleTitle("Cool Off")
:item("polished_blackstone_button")
:setOnToggle(function(state)
    pings.penishigh(state)
        pings.penishigh(state)
end)


function pings.penishigh(state)
    if state then
    models.model.penishigh:setVisible(true)
  else
    models.model.penishigh:setVisible(false)
  end
end

mainPage:newAction()
:title("Enter toggles")
:item("note_block")
:onLeftClick(function ()
  action_wheel:setPage(toggles)
end)
local togglename = toggles:newAction()
:title("return")
:item("glass")
:onLeftClick(function ()
  action_wheel:setPage(mainPage)
end)