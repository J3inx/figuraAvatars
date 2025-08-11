-- Auto generated script file --
--variables
local selected = 0
--0 = none
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

--action wheel setup

local sleeping = math.random(1500, 2500)


--entity init event, used for when the avatar entity is loaded for the first time
function events.entity_init()
  log("The player api has loaded!")
  local health, pos = player:getHealth(), player:getPos()
  
end



   
   local idlesounds = {"entity.creeper.ambient"}
   function events.tick()
   
      -- randomly yawn and pant
      if player:isLoaded() == true then
        health= player:getHealth()
        if player:getHealth() >= 4 then
          print(health)
      if sleeping >= 0 then
         sleeping = sleeping - 1
         print(sleeping)
      else
         -- choose random sound
         print("played")
         sounds:playSound(idlesounds[math.random(#idlesounds)], player:getPos(), 1, 1, false)
         sleeping = math.random(1500, 2500)
      end
    end
      if player:getHealth() >=4
and client:isWindowFocused() == true then
   print("In Focus")
   --timer.cancel(sleeping)
   --timer.start(abovehealth)
end
if client:isWindowFocused() == false then
   print("Not in Focus")
   --timer.start(sleeping)
   --timer.cancel(abovehealth)
   end
end
   end
  



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
