--Started creating this goblin on 8/10/23, Lots of hours and definitely several walls later and you've got an avatar that might satisfy. 
--Anyways look at this mess! I love hate it with a certain level of insanity. ^v^ -Irri

vanilla_model.PLAYER:setVisible(false)
vanilla_model.HELD_ITEMS:setVisible(true)
vanilla_model.ARMOR:setVisible(false)
renderer:offsetCameraPivot(0,-.45,0)
renderer:setRenderCrosshair(false)
models.Faputa:setScale(0.95)

local E      = models.Faputa.E
local Eye    = E.Torso.Neck.Noggin.Saucers
local Tail   = E.Torso.Tailbase.Tails
local Fan    = animations.Faputa

local squapi = require("lib.SquAPI")
local anims  = require("lib.JimmyAnims")
local GS     = require("lib.GSAnimBlend")


 
-- Animation blending
 anims.blendTime = 5
anims(Fan)
Fan.sleep:blendTime(0)
Fan.vehicle:blendTime(0)
Fan.blockingL:blendTime(2)

--SquishyLib
     squapi.smoothHeadNeck(E.Torso.Neck.Noggin, E.Torso.Neck, false)
    squapi.blink(animations.Faputa.Blink, 3)
   squapi.eye(Eye.RightEye,.65,.25,.45,.45)
  squapi.eye(Eye.RightEye.RLight,0,.45,.15,.8)
 squapi.eye(Eye.LeftEye,.25,.65,.45,.45)
squapi.eye(Eye.LeftEye.LLight,0,.45,.15,.8)

    local pb1 = Tail.Paintbrush1
   local pb2 = Tail.Paintbrush2
  local pb3 = Tail.Paintbrush3
 local pb4 = Tail.Paintbrush4
local pb5 = Tail.Paintbrush5
    local tailseg1 = {pb1,pb1.B1,pb1.B1.B2,pb1.B1.B2.B3,pb1.B1.B2.B3.B4,pb1.B1.B2.B3.B4.B5}
   local tailseg2 = {pb2,pb2.B1,pb2.B1.B2,pb2.B1.B2.B3,pb2.B1.B2.B3.B4,pb2.B1.B2.B3.B4.B5}
  local tailseg3 = {pb3,pb3.B1,pb3.B1.B2,pb3.B1.B2.B3,pb3.B1.B2.B3.B4,pb3.B1.B2.B3.B4.B5}
 local tailseg4 = {pb4,pb4.B1,pb4.B1.B2,pb4.B1.B2.B3,pb4.B1.B2.B3.B4,pb4.B1.B2.B3.B4.B5}
local tailseg5 = {pb5,pb5.B1,pb5.B1.B2,pb5.B1.B2.B3,pb5.B1.B2.B3.B4,pb5.B1.B2.B3.B4.B5}
    squapi.tails(tailseg1, 1.5, 10, 10, .5, 1, 0.5, 0, .01, .0001, .025, 40, 25, 5)
   squapi.tails(tailseg2, 1.5, 10, 10, .5, 1, 0.5, .6, .01, .0001, .025, 40, 25, 5)
  squapi.tails(tailseg3, 1.5, 10, 10, .5, 1, 0.5, 1.2, .01, .0001, .025, 40, 25, 5)
 squapi.tails(tailseg4, 1.5, 10, 10, .5, 1, 0.5, 1.8, .01, .0001, .025, 40, 25, 5)
squapi.tails(tailseg5, 1.5, 10, 10, .5, 1, 0.5, 2.4, .01, .0001, .025, 40, 25, 5)

--Action Wheel Shiddery
 local aPage = action_wheel:newPage()
action_wheel:setPage(aPage)

--Silly Camera Ping
function pings.HeadCam()
	function events.render()
		renderer:setCameraPivot(models.Faputa.E.Torso.Neck.Noggin.Saucers.camera:partToWorldMatrix():apply())
		renderer:offsetCameraPivot(0,0,0)
	end
end
function pings.NoHead()
	function events.render()
		renderer:setCameraPivot()
		renderer:offsetCameraPivot(0,-0.45,0)
	end
end

local action1 = aPage:newAction()
    :title("§9§4Affixed Camera Pivot\n\n§fThere's an off switch! YIPEE!\n(This ate all my time because I never ask for help on stuff like this- ;^;)")
    :item("minecraft:target")
    :hoverColor(1,0,1)
    :onToggle(pings.HeadCam)
	:onUntoggle(pings.NoHead)

