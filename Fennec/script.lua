-- Auto generated script file --

--hide vanilla model
vanilla_model.PLAYER:setVisible(false)
vanilla_model.armor:setVisible(false)
vanilla_model.cape:setVisible(false)


require("scripts.EZSounds")
require("scripts.action-wheel")

local squapi = require("lib.SquAPI")



squapi.ear:new(
    models.model.root.Head.ears.LeftEar, --leftEar
    models.model.root.Head.ears.RightEar, --(nil) rightEar
    nil, --(1) rangeMultiplier
    nil, --(false) horizontalEars
    nil, --(2) bendStrength
    nil, --(true) doEarFlick
    nil, --(400) earFlickChance
    nil, --(0.1) earStiffness
    nil  --(0.8) earBounce
)

function events.tick()
if client:isWindowFocused() == true then
    models.model.root.Head.Head:setVisible(true)
    
    models.model.root.Head.Head2:setVisible(false)
else
    models.model.root.Head.Head:setVisible(false)
    
    models.model.root.Head.Head2:setVisible(true)
end
end

