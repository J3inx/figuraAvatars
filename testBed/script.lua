-- Hide vanilla model
vanilla_model.PLAYER:setVisible(false)
vanilla_model.ARMOR:setVisible(false)
vanilla_model.CAPE:setVisible(false)
vanilla_model.ELYTRA:setVisible(false)
vanilla_model.HELMET_ITEM:setVisible(true)

-- === Walking and Eating Sound System === --

-- Walking sound setup
local stepTimer = 0
local stepInterval = 6

-- Eating sound setup
local eatingVolume = 1
local eatingPitchRange = 0.7
local eatingBasePitch = 1 - eatingPitchRange / 2
local currentEatingSound = nil
local eatingTimer = 0

function events.tick()
  -- Walking sound system
  local walking = player:getVelocity().xz:length() > 0.01
  stepTimer = stepTimer + 1
  if walking and stepTimer >= stepInterval then
    stepTimer = 0
    sounds:playSound("entity.iron_golem.step", player:getPos(), 1, 1.5)
  end

  -- Eating sound system
  local isEating = player:isUsingItem() and player:getActiveItem():getUseAction() == "EAT"
  if isEating then
    eatingTimer = eatingTimer - 1
    if eatingTimer <= 0 then
      if currentEatingSound then currentEatingSound:stop() end
      currentEatingSound = sounds:playSound("entity.iron_golem.hurt", player:getPos(), eatingVolume, eatingBasePitch + math.random() * eatingPitchRange)
      eatingTimer = 10
    end
  else
    eatingTimer = 0
    if currentEatingSound then
      currentEatingSound:stop()
      currentEatingSound = nil
    end
  end
end
