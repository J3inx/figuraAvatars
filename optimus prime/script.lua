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

local mainPage = action_wheel:newPage("mainPage")
local animationPage = action_wheel:newPage("animations")
action_wheel:setPage(mainPage)

function events.entity_init()
  --player functions goes here
  renderer:setCameraPos(0, 4, 3)
end

mainPage:newAction()
    :title("animations §7(leftclick)§r")
    :item("minecart")
    :onLeftClick(function() action_wheel:setPage(animationPage) end)

animationPage:newAction()
  :title("go back §7(leftclick)§r")
  :item("barrier")
  :onLeftClick(function() action_wheel:setPage(mainPage) end) 
local toggleTransform = animationPage:newAction()
  :title("transform §7(leftclick)§r")
  :toggleTitle("untransform")
  :item("minecart")
  :setOnToggle(function(state)
    print("Toggled transformation:", state)
    
    pings.Transform(state)
  end)
function pings.Transform(state) -- Pings are how other players can see your actions
  --if not player:isLoaded() then return end -- This stops players erroring from you trying to use something they haven't loaded in
  --models.DVanDrag.bodies.cabs:setVisible(state)
  if state then
    animations.optimus.transform:setOverride(true)
    animations.optimus.transform:setPlaying(true)
    animations.optimus.untransform:setPlaying(false)
    renderer:setCameraPos(0, 1,1)
  else
    animations.optimus.transform:setPlaying(false)
    animations.optimus.untransform:setPlaying(true)
    renderer:setCameraPos(0, 4, 3)
  end
  end

-- Get movement direction relative to the look vector
-- Determine movement direction relative to where the player is looking
function getMoveDirection()
  local velocity = player:getVelocity()
  local look = player:getLookDir()

  -- Flatten vectors to horizontal plane
  local flatVelocity = vec(velocity.x, 0, velocity.z)
  if flatVelocity:length() < 0.05 then
      return "none"
  end

  local forward = vec(look.x, 0, look.z):normalize()
  local right = vec(look.z, 0, -look.x):normalize()

  local dotForward = flatVelocity:dot(forward)
  local dotRight = flatVelocity:dot(right)

  if math.abs(dotForward) > math.abs(dotRight) then
      if dotForward > 0.1 then
          return "forward"
      elseif dotForward < -0.1 then
          return "backward"
      end
  else
      if dotRight > 0.1 then
          return "right"
      elseif dotRight < -0.1 then
          return "left"
      end
  end

  return "none"
end

-- Example usage
events.TICK:register(function()
  local dir = getMoveDirection()
  if dir == "forward" then
      --print("Moving Forward")
  elseif dir == "backward" then
      --print("Moving Backward")
  elseif dir == "left" then
      --print("Strafing right")
  elseif dir == "right" then
      --print("Strafing left")
  end
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
  models.optimus:setPos(0,45,0)
  
end
