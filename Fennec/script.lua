-- Auto generated script file --

--hide vanilla model
vanilla_model.PLAYER:setVisible(false)
vanilla_model.armor:setVisible(false)
vanilla_model.cape:setVisible(false)


require("scripts.EZSounds")
require("scripts.action-wheel")

local squapi = require("lib.SquAPI")
local gaze = require("lib.Gaze")
local mainGaze = gaze:newGaze()
local Irises = models.model.root.Head.Eyes.Irises
mainGaze:newEye(Irises.LeftIris, 0.25, 1.25, 0.5, 0.5)
mainGaze:newEye(Irises.RightIris, 1.25, 0.25, 0.5, 0.5)
local secondGaze = gaze:newGaze()
local Irises = models.model.root.Head.dragon.Eyes2.Irises2
mainGaze:newEye(Irises.LeftIris2, 0.25, 1.25, 0.5, 0.5)
mainGaze:newEye(Irises.RightIris2, 1.25, 0.25, 0.5, 0.5)


squapi.ear:new(
    models.model.root.Head.ears.LeftEar, --leftEar
    models.model.root.Head.ears.RightEar, --(nil) rightEar
    0.5, --(1) rangeMultiplier
    false, --(false) horizontalEars
    1, --(2) bendStrength
    true, --(true) doEarFlick
    400, --(400) earFlickChance
    0.2, --(0.3) earStiffness
    0.7  --(0.4) earBounce
)

myTail = {
	models.model.tail
}
--in Blockbench, each tail segment would go inside the last. first segment would contain the second, second would contain the third, etc.
--this list can be as long as you want based on how many segments your tail is, just add more.
--replace each nil with the value/parmater you want to use, or leave as nil to use default values :)
--parenthesis are default values for reference
squapi.tail:new(myTail,
    20,    --(15) idleXMovement
    3,    --(5) idleYMovement
    1,    --(1.2) idleXSpeed
    2,    --(2) idleYSpeed
    2,    --(2) bendStrength
    0,    --(0) velocityPush
    0,    --(0) initialMovementOffset
    1,    --(1) offsetBetweenSegments
    .005,    --(.005) stiffness
    .9,    --(.9) bounce
    90,    --(90) flyingOffset
    -90,    --(-90) downLimit
    45     --(45) upLimit
)

--function events.tick()
--if client:isWindowFocused() == true then
--    models.model.root.Head.Head:setVisible(true)
--    
--    models.model.root.Head.Head2:setVisible(false)
--else
--    models.model.root.Head.Head:setVisible(false)
--    
--    models.model.root.Head.Head2:setVisible(true)
--end
--end

function events.tick()

    if not player:isAlive() then
         if not died then
          died = true
          animations.model.death:play()
          sounds:playSound("sounds.Desynchronized", player:getPos(), 1, 1, false)
 
         end
     else 
         died = false
         animations.model.death:stop()
    end
 
 end