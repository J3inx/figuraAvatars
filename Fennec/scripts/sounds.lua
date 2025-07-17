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