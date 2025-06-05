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

--entity init event, used for when the avatar entity is loaded for the first time
function events.entity_init()
  --player functions goes here
end
local mainPage = action_wheel:newPage()
local toggles = action_wheel:newPage()
local maskState = true
action_wheel:setPage(mainPage)
mainPage:newAction()
:title("go to toggle page")
:item("lever")
:onLeftClick(function ()
  action_wheel:setPage(toggles)
end)
toggles:newAction()
:title("go to main page")
:item("red_wool")
:onLeftClick(function ()
  action_wheel:setPage(mainPage)
end)
toggles:newAction()
:title("toggle mask")
:item("iron_helmet")
:onLeftClick(function ()
  if maskState then
    animations.swat.visorUp:setPlaying(true)
    animations.swat.visorDown:setPlaying(false)
    maskState = false
  else
    animations.swat.visorUp:setPlaying(false)
    animations.swat.visorDown:setPlaying(true)
    maskState = true
  end
  
end)

events.RENDER:register(function(delta)
  --models.swat:setPrimaryRenderType("cutout_cull")
end)
--tick event, called 20 times per second
function events.tick()
  --code goes here
end

--render event, called every time your avatar is rendered
--it have two arguments, "delta" and "context"
--"delta" is the percentage between the last and the next tick (as a decimal value, 0.0 to 1.0)
--"context" is a string that tells from where this render event was called (the paperdoll, gui, player render, first person)
function events.render(delta, context)
  --code goes here
end
