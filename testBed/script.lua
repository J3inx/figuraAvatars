-- Hide vanilla model
vanilla_model.PLAYER:setVisible(false)
vanilla_model.ARMOR:setVisible(false)
vanilla_model.CAPE:setVisible(false)
vanilla_model.ELYTRA:setVisible(false)
vanilla_model.HELMET_ITEM:setVisible(true)
local vis = 1
local cloaked = false
local FunPage = action_wheel:newPage()
FunPage:newAction()
:title("Toggle Cloaking")
:item("white_concrete")
:toggleItem("white_stained_glass")
:onToggle(pings.Cloak)

vis = 1

Cloaked = false
function pings.Cloak(state)
Cloaked = state
end

function events.tick()
if Cloaked then
if player:getPose() ~= "CROUCHING" then
if vis > 0.26 then
vis = vis - 0.05
elseif vis < 0.24 then
vis = vis + 0.05
end

elseif vis > 0.05 then
vis = vis - 0.05
end

else

if vis < 1 then
vis = vis + 0.05
end
end

models.model:setOpacity(vis)
renderer:setShadowRadius(0.75 * 0.5 * vis)

end

function events.tick()
  
end
