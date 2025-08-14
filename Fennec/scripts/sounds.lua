local ezsounds = require("scripts.EZSounds")
function events.tick()
   local health, pos = player:getHealth(), player:getPos()
if health >= 6 then
sounds:replaceSound("entity.player.hurt","entity.fox.hurt")
sounds:replaceSound("entity.player.death","entity.fox.death")
elseif health <= 6 then
   sounds:replaceSound("entity.player.hurt",{"entity.panda.hurt","entity.wolf.hurt"})
--   particles:newParticle("soul_fire_flame", player:getPos())
end    
end

function pings.sleep(state)
if state then
   function events.entity_init()
      -- dog sounds
      local health, pos = player:getHealth(), player:getPos()
      if health >= 4 then
         local abovehealth = math.random(1500, 2500)
         local idlesounds = {"entity.fox.ambient"}
         function events.tick()
            -- randomly yawn and pant
            if abovehealth > 0 then
               abovehealth = abovehealth - 1
            else
               -- choose random sound
               sounds:playSound(idlesounds[math.random(#idlesounds)], player:getPos(), 1, 1, false)
               abovehealth = math.random(1500, 2500)
            end
         end
         elseif health <= 4
            or health == 4 then
            local lowhealth = math.random(500, 1500)
         local idlesounds = {"entity.wolf.whine"}
         function events.tick()
            -- randomly yawn and pant
            if lowhealth > 0 then
               lowhealth = lowhealth - 1
            else
               -- choose random sound
               sounds:playSound(idlesounds[math.random(#idlesounds)], player:getPos(), 1, 1, false)
               lowhealth = math.random(500, 1500)
            end
         end
      local health, pos = player:getHealth(), player:getPos()
else
local health, pos = player:getHealth(), player:getPos()
if health >=4 then
   local sleeping = math.random(1500, 2500)
   local idlesounds = {"entity.fox.sleep"}
   function events.tick()
      -- randomly yawn and pant
      if sleeping > 0 then
         sleeping = sleeping - 1
      else
         -- choose random sound
         sounds:playSound(idlesounds[math.random(#idlesounds)], player:getPos(), 1, 1, false)
         sleeping = math.random(1500, 2500)
      end
   end
end
end
end
end
end

function events.entity_init()
   if client:isWindowFocused() == false then
      pings.sleep()
   end
end