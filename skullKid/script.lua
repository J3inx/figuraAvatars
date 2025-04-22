-- Auto generated script file --

--hide vanilla armor model
vanilla_model.ARMOR:setVisible(false)

--hide vanilla cape model
vanilla_model.CAPE:setVisible(false)

--hide vanilla elytra model
vanilla_model.ELYTRA:setVisible(false)

vanilla_model.PLAYER:setVisible(false)

--entity init event, used for when the avatar entity is loaded for the first time
function events.entity_init()
  --player functions goes here
 --local walking = player:getVelocity().xz:length() > .01
 --local sprinting = player:isSprinting()
local headRot = player:getRot()


end


--tick event, called 20 times per second
function events.tick()
  local crouching = player:getPose() == "CROUCHING"
  animations.skullkid.crouch:setPlaying(crouching)
 -- print(models.skullkid)

--models.skullkid.head:setRot(vanilla_model.HEAD:getRot())
 local walking = player:getVelocity().xz:length() > .01 
  if player:getVelocity().xz:length() > .01 and player:getVelocity().xz:length()< 1 then
 
     
      animations.skullkid.skullsW:play()



  else
    animations.skullkid.skullsW:stop()
  end
  if player:isSprinting() then
       
    animations.skullkid.skullsR:play()



  else
   animations.skullkid.skullsR:stop()
  end
  end

--render event, called every time your avatar is rendered
--it have two arguments, "delta" and "context"
--"delta" is the percentage between the last and the next tick (as a decimal value, 0.0 to 1.0)
--"context" is a string that tells from where this render event was called (the paperdoll, gui, player render, first person)
local function printParts(part, indent)
  print(indent .. part:getName())  -- Print the part's name
  for _, child in ipairs(part:getChildren()) do
      printParts(child, indent .. "  ")
  end
end

-- Start from the root
--printParts(models.skullkid, "")

events.RENDER:register(function(delta)
  local camRot = player:getRot()[2]     -- Yaw
  local bodyYaw = player:getBodyYaw()

  -- Inverted yaw diff (camera to body)
  local yawDiff = -(camRot - bodyYaw)

  -- Normalize to -180 to 180
  yawDiff = (yawDiff + 180) % 360 - 180

  -- Clamp yaw so head doesn't twist too far
  local clampedYaw = math.max(-50, math.min(50, yawDiff))

  -- Pitch (invert if needed)
  local pitch = -player:getRot()[1]

  -- Apply final head rotation
  models.skullkid.root.neck.head:setRot(pitch, clampedYaw, 0)
end)






