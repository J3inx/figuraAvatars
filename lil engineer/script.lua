-- Assets Browser: Squishy Api - mrsirsquishy
local squapi = require("SquAPI")
-- Previous Projects: swingPirate - piratesee
local swingPirate = require("swingpirate")
-- Previous Projects: bowAnim - piratesee
local itemAnim = require("bowAnim")

local debugOn = false
--hide vanilla cape model
vanilla_model.CAPE:setVisible(false)

--hide vanilla elytra model
vanilla_model.ELYTRA:setVisible(false)
--i tried
models.model.root.Body.estrogen.medal.text:newText("youtried"):setText("you\ntried"):setScale(0.1):setAlignment("CENTER")
--models.model.Skull.medal2.text:newText("youtried3"):setText("you\ntried"):setScale(0.1):setAlignment("CENTER")
models.model.World.SentryTurret.YawBearing.Mount.PitchBearing.Gun.LeftSide.LeftBarrel.medal3.text:newText("youtried3"):setText("you\ntried"):setScale(0.1):setAlignment("CENTER")
models.model.World.Drone.DroneBody.medal4.text:newText("youtried4"):setText("you\ntried"):setScale(0.1):setAlignment("CENTER")

--hide and show stuff
models.model.root:setVisible(true)
models.model.root.Body._HeadMount.Head.HoloMenu:setVisible(false)

vanilla_model.PLAYER:setVisible(false)
vanilla_model.ARMOR:setVisible(false)
vanilla_model.CAPE:setVisible(false)	

--character vars	

local bodyPitch = 0
local bodyRoll = 0

local armSpread = 0

local bodyPitchOld = 0
local bodyRollOld = 0

local armSpreadOld = 0

local syncedMenuState = false

local afk = false
local syncedAfk = false

local save_prefix = ""

--rangefinder vars

local rangefinder = false

local rangefinderMode = 0

local dartPosA = nil
local dartDimA = nil
local dartPosB = nil
local dartDimB = nil
local dartPosC = nil
local dartDimC = nil

local markAPos = vec(0,0,0)
local markARot = vec(0,0,0)

local markAPosOld = vec(0,0,0)
local markARotOld = vec(0,0,0)

local markBPos = vec(0,0,0)
local markBRot = vec(0,0,0)

local markBPosOld = vec(0,0,0)
local markBRotOld = vec(0,0,0)

local markCPos = vec(0,0,0)
local markCRot = vec(0,0,0)

local markCPosOld = vec(0,0,0)
local markCRotOld = vec(0,0,0)

local static = false

--sentry vars

local sentryActive = false
local sentryEnabled = true
local sentryReturn = false

local hostLookButton = false
local buttonTargeted = nil
local syncedButtonTargeted = nil

local leftSide = false

local shockSoundHandle

local tracerLength = 0
local tracerScale = 0

local sentryPos = vec(0,0,0)
local sentryPosOld = vec(0,0,0)
local sentryYaw = 0
local sentryPitch = 0

local sentryYawOld = 0
local sentryPitchOld = 0

local sentryspeed = 0
local sentryPathTicks = 0

local turretPredicate
local predicateId

local hostPingPathing = false
local syncedPingPathing = false

--tone sequences

local sequenceTime = 0
local sequenceNo = 0

local targetEntity = nil
local sentryTarget = nil

--sentry hologram

local holoShow = false

local holoRot = 0
local holoRotOld = 0

--drone

local dronePos = vec(0,0,0)
local oldDronePos = vec(0,0,0)

local droneRot = 0
local oldDroneRot = 0

local thrusterRot = 0
local oldThrusterRot = 0

local droneTarget
local droneTimer = 0

local droneSpeed = vec(0,0,0)

local droneWarpEffect = 0

--all the pressable buttons

local buttonIds = {
	models.model.World.SentryTurret.Hologram.button_1,
	models.model.World.SentryTurret.Hologram.button_2,
	models.model.World.SentryTurret.Hologram.button_3,
	models.model.World.SentryTurret.Hologram.button_4,
	models.model.World.SentryTurret.Hologram.button_5,
	models.model.World.SentryTurret.YawBearing.Mount.RearMount.ButtonPanel.Button
}

--translation tags

local TT_sentryDeploy
local TT_sentryReturn
local TT_sentryCant
local TT_targetNothing
local TT_targetNoPlayer
local TT_targetNoOwner
local TT_targetAll
local TT_rangefinderActive
local TT_rangefinderDeactive
local TT_rangefinderCant
local TT_rangefinderCycle
local TT_rangefinderMode0
local TT_rangefinderMode1
local TT_rangefinderMode2
local TT_rangefinderMode3
local TT_rangefinderFireDart
local TT_rangefinderReturnDart
local TT_rangefinderLocation
local TT_rangefinderDimension
local TT_rangefinderUnits
local TT_rangefinderNoSignal

local TT_droneName
local TT_sentryName

--STATIC variables

--feel free to modify
local RANGEFINDER_MAX = 128 --rangefinder max seeing distance

local SENTRY_ROT_SPEED = 1.5 --sentry idle sweep speed
local SENTRY_RANGE = 32 --sentry max seeing distance

local SENTRY_YAW_CHECK_DEG = 5 --sentry spacing left/right in degrees between raycasts
local SENTRY_YAW_CHECK_COUNT = 1 --sentry amount of left/right raycasts
local SENTRY_PITCH_CHECK_DEG = 3 --sentry spacing up/down in degrees between raycasts
local SENTRY_PITCH_CHECK_COUNT = 11 --sentry amount of up/down raycasts

local SENTRY_PATHFINDING_MAX_ITERATIONS = 128 --how many iterations to try and find a path before giving up and just doing ecluidian noclip fly

local DRONE_INTER_TIME = 30*20 --time drone waits before trying phase change
local DRONE_RAYCAST_COUNT = 10 --raycasts done by drone in a single tick
local DRONE_RAYCAST_DEG = 5 --degree seperation of raycasts

local DRONE_ACCEL = 0.02 --speed increase/decrease per tick
local DRONE_MAX_SPEED = 0.4 --max speed

--text stuff, probably don't touch this

local RANGE_TEXT = models.model.root.RightArmFirstPerson.RangefinderFirst.Screen2.text:newText("rangeText")
RANGE_TEXT:setText("??m\nNO SIGNAL"):setScale(0.05):setLight(15,15):setAlignment("CENTER"):setWidth(4/0.05)

local RANGE_TEXT_LEFT = models.model.root.LeftArmFirstPerson.RangefinderFirstLeft.Screen4.text:newText("rangeText")
RANGE_TEXT_LEFT:setText("??m\nNO SIGNAL"):setScale(0.05):setLight(15,15):setAlignment("CENTER"):setWidth(4/0.05)

local RANGE_TEXT_THIRDPERSON = models.model.root.Body.RightArm.RangefinderArm.Screen.text:newText("rangeTextThirdPerson")
RANGE_TEXT_THIRDPERSON:setText("??m\nNO SIGNAL"):setScale(0.05):setLight(15,15):setAlignment("CENTER"):setWidth(4/0.05)

local RANGE_TEXT_THIRDPERSON_LEFT = models.model.root.Body.LeftArm.RangefinderArmLeft.Screen3.text:newText("rangeTextThirdPersonLeft")
RANGE_TEXT_THIRDPERSON_LEFT:setText("??m\nNO SIGNAL"):setScale(0.05):setLight(15,15):setAlignment("CENTER"):setWidth(4/0.05)

local BUTTON_TEXT = models.model.World.SentryTurret.YawBearing.Mount.RearMount.ButtonPanel.text:newText("buttonText")

BUTTON_TEXT:setText("Disable"):setScale(0.1):setAlignment("RIGHT"):setLight(15,15)

local BUTTON_TEXT1 = models.model.World.SentryTurret.Hologram.text_1:newText("buttonText1")
BUTTON_TEXT1:setText("Target nothing"):setScale(0.05):setLight(0,0)

local BUTTON_TEXT2 = models.model.World.SentryTurret.Hologram.text_2:newText("buttonText2")
BUTTON_TEXT2:setText("Target non-player"):setScale(0.05):setLight(0,0)

local BUTTON_TEXT3 = models.model.World.SentryTurret.Hologram.text_3:newText("buttonText3")
BUTTON_TEXT3:setText("Target non-owner"):setScale(0.05):setLight(0,0)

local BUTTON_TEXT4 = models.model.World.SentryTurret.Hologram.text_4:newText("buttonText4")
BUTTON_TEXT4:setText("Target everyone"):setScale(0.05):setLight(0,0)

local BUTTON_TEXT5 = models.model.World.SentryTurret.Hologram.text_5:newText("buttonText5")
BUTTON_TEXT5:setText("Shutdown"):setScale(0.05):setAlignment("CENTER"):setLight(0,0):setWidth(5/0.05)

local LEG_TEXT = models.model.root.RightLeg.Monitor.text:newText("legText")
LEG_TEXT:setText("Leg monitor"):setScale(0.05):setAlignment("CENTER"):setLight(15,15):setWidth(3/0.05)

--keybind
local DRONE_SCAN_KEY = keybinds:newKeybind("Force Drone Scan", "key.keyboard.i")
DRONE_SCAN_KEY:setOnPress(function()
    drone_scan()
end)

--set up things
animations.model.Sentry_Idle:setPlaying(true)	
animations.model.HoloMenu_Idle:setPlaying(true)	

--squapi calls
local tails = {
	models.model.root.Body.Tail,
	models.model.root.Body.Tail.Tail1,
	models.model.root.Body.Tail.Tail1.Tail2,
	models.model.root.Body.Tail.Tail1.Tail2.Tail3,
	models.model.root.Body.Tail.Tail1.Tail2.Tail3.Tail4
}

squapi.tails(tails,
	1.5, --intensity
	10, --tailintensityY
	15, --tailintensityX
	0.5, --tailYSpeed
	0.8, --tailXSpeed
	-0.2, --tailVelBend
	nil, --initialTailOffset
	0.8, --segOffsetMultiplier
	0.007, --tailStiff
	0.05, --tailBounce
	80, --tailFlyOffset
	20, --downlimit
	20  --uplimit
)

local rareIdle = squapi.randimation.new(animations.model.Sentry_RareIdle, 150)
rareIdle:setEnabled(false)

squapi.eye(
	models.model.root.Body._HeadMount.Head.Eyes.LeftEye, --element
	nil, --(.25)leftdistance
	nil, --(1.25)rightdistance
	nil, --(.5)updistance
	nil, --(.5)downdistance
	nil  --(false)switchvalues
)

squapi.eye(
	models.model.root.Body._HeadMount.Head.Eyes.RightEye, --element
	1.25, --(.25)leftdistance
	0.25, --(1.25)rightdistance
	nil, --(.5)updistance
	nil, --(.5)downdistance
	nil  --(false)switchvalues
)

squapi.blink(
	animations.model.Blink, --animation
	1  --(1)chancemultiplier
)


squapi.bouncewalk(
	models.model.root, --model
	0.75  --(1)bounceMultiplier
)

--my crappy swinging physics libary
swingThing = swingPirate.SwingPhysics(models.model.root.Body._HeadMount.Head.RightHorn.RightUpperHorn.HangingThing, "default_head", {15, -90, 90, -90, 90, -90}, {
			resistance = 0.7,
			weight = 1,
			bounce = 0
		})

tie = swingPirate.SwingPhysics(models.model.root.Body.estrogen.tie, "default_body", {90, -1, 90, -90, 90, -90}, {
			resistance = 0.5,
			weight = 1.3,
			bounce = 0
		})


--bow anim
crossbowHandle = itemAnim.crossbow(nil, nil, animations.model.LoadCrossbow, animations.model.LoadedCrossbow, animations.model.CrossbowShoot)

function adjust_translation()
	
	local lang = client:getActiveLang()
	--print(lang)
	--set translation tags
	
	--en_pt, lol_us, fallback (english)
	TT_sentryDeploy = lang == "en_pt" and "Build self-act'n cannon" or lang == "lol_us" and "Mak pew pew tuurt" or "Place Sentry"
	TT_sentryReturn = lang == "en_pt" and "Plunder self-act'n cannon" or lang == "lol_us" and "Steel bak pew pew tuurt" or "Return Sentry"
	TT_sentryCant = lang == "en_pt" and "Can't put ye self-act'n cannon 'ere!" or lang == "lol_us" and "I cants put teh tuurt here" or "Can't place sentry here!"
	TT_targetNothing = lang == "en_pt" and "Hold ye fire" or lang == "lol_us" and "peaseful" or  "Target nothing"
	TT_targetNoPlayer = lang == "en_pt" and "Don't fire at pirates" or lang == "lol_us" and "kill no catz" or "Target non-player"
	TT_targetNoOwner = lang == "en_pt" and "Don't fire at yeself" or lang == "lol_us" and "kill no ownr" or "Target non-owner"
	TT_targetAll = lang == "en_pt" and "Fire at will" or lang == "lol_us" and "kill dem all" or "Target Everyone"
	TT_rangefinderActive = lang == "en_pt" and "Grab ye scrying spyglass" or lang == "lol_us" and "Get lazer poitur" or "Enable Rangefinder"
	TT_rangefinderDeactive = lang == "en_pt" and "Drop ye scrying spyglass" or lang == "lol_us" and "lose lazer poitur" or "Disable Rangefinder"
	TT_rangefinderCant = lang == "en_pt" and "Drop whats in ye main hook!" or lang == "lol_us" and "clear what u haz in main paw" or "Empty your main hand!"
	TT_rangefinderCycle = lang == "en_pt" and "Change yer scrying spyglass modus" or lang == "lol_us" and "change lazer pointur behavurr" or "Cycle Rangefinder Mode"
	TT_rangefinderMode0 = lang == "en_pt" and "Current Modus: Distance spy'n" or lang == "lol_us" and "beahvurr now be distince git" or  "Current Mode: Rangefinding"
	TT_rangefinderMode1 = lang == "en_pt" and "Current Modus: Cannon Alpha look'n" or lang == "lol_us" and "beahvurr now be searhc alpha" or "Current Mode: Locate Alpha"
	TT_rangefinderMode2 = lang == "en_pt" and "Current Modus: Cannon Beta look'n" or lang == "lol_us" and "beahvurr now be searhc beta" or "Current Mode: Locate Beta"
	TT_rangefinderMode3 = lang == "en_pt" and "Current Modus: Cannon Gamma look'n" or lang == "lol_us" and "beahvurr now be searhc gamma" or "Current Mode: Locate Gamma"
	TT_rangefinderFireDart = lang == "en_pt" and "Fire cannon" or lang == "lol_us" and "shot teh dart" or "Fire Dart"
	TT_rangefinderReturnDart = lang == "en_pt" and "Plunder Dart" or lang == "lol_us" and "get teh dart" or "Return Dart"
	TT_rangefinderLocation = lang == "en_pt" and "Cordinates" or lang == "lol_us" and "iss at" or "Location"
	TT_rangefinderDimension = lang == "en_pt" and "World" or lang == "lol_us" and "wurld" or "Dimension"
	TT_rangefinderUnits = lang == "en_pt" and " fathoms" or  lang == "lol_us" and " catz" or "m"
	TT_rangefinderNoSignal = lang == "en_pt" and "NAY LAND HO" or lang == "lol_us" and "NAW FOND THINGIES :c" or "NO SIGNAL"
	
	TT_droneName = lang == "en_pt" and "Rank Two Look'r Magic Fly" or lang == "lol_us" and "lvl 2 cat spowtr drun" or "Mk II Examination Hover Drone"	
	TT_sentryName = lang == "en_pt" and "Two Cannon'd Self-actin Cannonmaster" or lang == "lol_us" and "pew pew turrt wit 2 gunz" or "Twin-barrel Automated Sentry Gun"
	
	--use tags to set things
	deployAction:setTitle("§6§l" .. TT_sentryDeploy):setToggleTitle("§C§l" .. TT_sentryReturn)
	rangeFinderAction:setTitle("§6§l" .. TT_rangefinderActive):setToggleTitle("§C§l" .. TT_rangefinderDeactive)
	
	rangefinderCycleAction:setTitle("§6§l" .. TT_rangefinderCycle .. "§r§7\n" .. TT_rangefinderMode0)
	
	dartAlphaAction:setTitle("§6§l" .. TT_rangefinderFireDart .." §r§4α"):setToggleTitle("§C§l" .. TT_rangefinderReturnDart .. "§r§4α")
	dartBetaAction:setTitle("§6§l" .. TT_rangefinderFireDart .." §r§1β"):setToggleTitle("§C§l" .. TT_rangefinderReturnDart .. "§r§1β")
	dartGammaAction:setTitle("§6§l" .. TT_rangefinderFireDart .." §r§2γ"):setToggleTitle("§C§l" .. TT_rangefinderReturnDart .. "§r§2γ")
	
	BUTTON_TEXT1:setText("§0" .. TT_targetNothing)
	BUTTON_TEXT2:setText("§0" .. TT_targetNoPlayer)
	BUTTON_TEXT3:setText("§0" .. TT_targetNoOwner)
	BUTTON_TEXT4:setText("§0" .. TT_targetAll)
	BUTTON_TEXT5:setText("§0" .. TT_sentryReturn)
end

--random eyes
local uuid = avatar:getUUID()
local a,b,c,d = client.uuidToIntArray(uuid)
--local a,b,c,d = client:generateUUID() --random uuid for testing (will cause desync)

local eyeTexture = textures:newTexture("eyes", 1, 2)

--base values (top pixel)
local hue = a%360 --0-360
local saturation = b%61+40 --40-100
local value = c%51+25 --25-75

--contrast value to calcualte bottom pixel
local contrast = d%20+10

--set textures and apply
local eyeRGB = vectors.hsvToRGB(hue/360,saturation/100,value/100)
eyeTexture:setPixel(0, 0, eyeRGB)

--calculate bottom pixel colour based on contrast value
local saturation_bottom = math.clamp(saturation-contrast*0.85, 30, 100)
local value_bottom = math.clamp(value+contrast*1.3, 0, 100)
local hue_bottom
if a%2 == 1 then
	hue_bottom = hue-contrast*1.5
else
	hue_bottom = hue+contrast*1.5
end

eyeTexture:setPixel(0, 1, vectors.hsvToRGB(hue_bottom/360,saturation_bottom/100,value_bottom/100))

--apply texture to all instances of eyes
models.model.root.Body._HeadMount.Head.Eyes.LeftEye.LEye:setPrimaryTexture("Custom", eyeTexture)
models.model.Portrait.Eyes2.LeftEye2.LEye:setPrimaryTexture("Custom", eyeTexture)
models.model.Skull.SkHead.Eyes3.LeftEye3.LEye:setPrimaryTexture("Custom", eyeTexture)
models.model.root.Body._HeadMount.Head.Eyes.RightEye.REye:setPrimaryTexture("Custom", eyeTexture)
models.model.Portrait.Eyes2.RightEye2.REye:setPrimaryTexture("Custom", eyeTexture)
models.model.Skull.SkHead.Eyes3.RightEye3.REye:setPrimaryTexture("Custom", eyeTexture)
--set avatar colour too
avatar:setColor(eyeRGB)

function events.entity_init()
	--finish setup, this stuff can be assigned now that the whole regular init phase is over
	turretPredicate = noPlayer
	predicateId = 2
	dronePos = player:getPos()+vec(0,2,0)
	sentryReturn = false
	
	--animations.model.Sentry_Fire:newCode(0.01, "sentryshot(false)"):newCode(0.54, "sentryshot(true)")
	animations.model.Sentry_RareIdle:newCode(0.25, "rareIdleSound()")
	
	--load dart waypoints
	if client:getServerData().ip then
		save_prefix = client:getServerData().ip
	else
		save_prefix = client:getServerData().name
	end
	
	dartPosA = config:load(save_prefix .. "_alphaPos")
	dartDimA = config:load(save_prefix .. "_alphaDim")
	dartPosB = config:load(save_prefix .. "_betaPos")
	dartDimB = config:load(save_prefix .. "_betaDim")
	dartPosC = config:load(save_prefix .. "_gammaPos")
	dartDimC = config:load(save_prefix .. "_gammaDim")
	
	adjust_translation()
	
	if dartPosA then
		dartAlphaAction:setToggled(true)
		dartAlphaAction:setToggleTitle("§C§l" .. TT_rangefinderReturnDart .. " §r§4α§r§7\n" .. TT_rangefinderLocation .. ": ".. math.round(dartPosA.x) .. " " .. math.round(dartPosA.y) .. " " .. math.round(dartPosA.z) .. "\n" .. TT_rangefinderDimension .. ": " .. dartDimA)
		models.model.World.DartAlpha:setPos(dartPosA*16)
	end
	if dartPosB then
		dartBetaAction:setToggled(true)
		dartBetaAction:setToggleTitle("§C§l" .. TT_rangefinderReturnDart .. " §r§4α§r§7\n" .. TT_rangefinderLocation .. ": ".. math.round(dartPosB.x) .. " " .. math.round(dartPosB.y) .. " " .. math.round(dartPosB.z) .. "\n" .. TT_rangefinderDimension .. ": " .. dartDimB)
		models.model.World.DartBeta:setPos(dartPosB*16)
	end
	if dartPosC then
		dartGammaAction:setToggled(true)
		dartGammaAction:setToggleTitle("§C§l" .. TT_rangefinderReturnDart .. " §r§4α§r§7\n" .. TT_rangefinderLocation .. ": ".. math.round(dartPosC.x) .. " " .. math.round(dartPosC.y) .. " " .. math.round(dartPosC.z) .. "\n" .. TT_rangefinderDimension .. ": " .. dartDimC)
		models.model.World.DartGamma:setPos(dartPosC*16)
	end
	
	--holographic menu fix
	pings.setPredicate(0, sentryPredicateID)
end

function events.resource_reload()
	adjust_translation()
end

--action wheel
local mainPage = action_wheel:newPage() --regular page
local rangefinderPage = action_wheel:newPage() --page with all rangefinder controls
action_wheel:setPage(mainPage)

function sentryWheel(state)

	if state then
		--check for valid pos
		local eyePos = player:getPos() + vec(0, player:getEyeHeight(), 0)
		local eyeEnd = eyePos + (player:getLookDir() * 10)
		local block, hitPos, side = raycast:block(eyePos, eyeEnd)
		
		if block:hasCollision() and side == "up" then
			pings.sentry(state)
		else
			host:setActionbar(TT_sentryCant)
			deployAction:setToggled(false)
		end
	else
		pings.sentry(state)
	end
end

function pings.sentry(state)
	models.model.World.SentryTurret:setVisible(true)
	
	sentryActive = state
	
	rareIdle:setEnabled(state)
	
	if state then
		animations.model.Sentry_Compact:stop()
		
		if player:isLoaded() then
			local eyePos = player:getPos() + vec(0, player:getEyeHeight(), 0)
			local eyeEnd = eyePos + (player:getLookDir() * 10)
			local block, hitPos, side = raycast:block(eyePos, eyeEnd)
			--re-enable
			sentryEnabled = true			
			animations.model.Sentry_Idle:setPlaying(true)
			animations.model.Sentry_Disable:stop()
		
			--dir			
			sentryYaw = math.deg(math.atan2(player:getLookDir().x, player:getLookDir().z))
			sentryYawOld = sentryYaw
			models.model.World.SentryTurret.YawBearing:setRot(0,sentryYaw,0)
		
			--deploy
			animations.model.Sentry_Deploy:setPlaying(true)			
			sentryPos = block:getPos()+vec(0.5,1,0.5)
			models.model.World.SentryTurret:setPos(sentryPos*16)
			
			sentryReturn = false
			sounds:playSound("minecraft:block.piston.extend", sentryPos, 1, 0.6)
			sequenceNo = 1
			sequenceTime = 26
		end
	else
		--re-enable anim
		if not sentryEnabled then
			animations.model.Sentry_Enable:play()
			animations.model.Sentry_Disable:stop()
		end
	
		sentryReturn = true
		sentryPosOld = sentryPos
		animations.model.Sentry_Compact:play()
		sentryspeed = 0
		targetEntity = nil
		sentryTarget = nil
		
		BUTTON_TEXT:setVisible(false)
		
		sounds:playSound("minecraft:block.piston.contract", sentryPos, 1, 0.6)		
		sequenceNo = 2
		sequenceTime = 8
		
		if host:isHost() then
			local dest = player:getPos() + vec(0,1,0)
		
			local block, hitpos = raycast:block(sentryPos, dest)
			
			if hitpos == dest then
				--perfect LOS, just do euclidian fly
				path = nil
			else
				--pathfind
				--print("pathfinding")
				a_star(vec(math.floor(sentryPos.x), math.floor(sentryPos.y), math.floor(sentryPos.z)), vec(math.floor(dest.x), math.floor(dest.y), math.floor(dest.z)))
			end
		end
		
		if holoShow and not animations.model.Sentry_HoloDisappear:isPlaying() then
			animations.model.Sentry_HoloDisappear:play()
			holoShow = false
			sounds:playSound("minecraft:ui.toast.out", sentryPos)
		end
	end
end
	
deployAction = mainPage:newAction()
    :item("minecraft:spectral_arrow")
    :toggleItem("minecraft:arrow")
    :setOnToggle(sentryWheel)
	:setToggleColor(0.5,0.5,0.5)
	
rangefinderPage:setAction(-1, deployAction) --also add to rangefinder page
	
function pings.rangefinder(state)
	rangefinder = state
	if player:isLoaded() then
		if state then
			if player:getItem(1).id ~= "minecraft:air" then
				--invalid, cancel
				rangeFinderAction:setToggled(false)
				host:setActionbar(TT_rangefinderCant)
				rangefinder = false			
			else
				action_wheel:setPage(rangefinderPage)
			end
		else
			action_wheel:setPage(mainPage)
		end
	end
end
	
rangeFinderAction = mainPage:newAction()
    :item("minecraft:blaze_rod")
    :toggleItem("minecraft:bamboo")
    :setOnToggle(pings.rangefinder)
	:setToggleColor(0.5,0.5,0.5)

rangefinderPage:setAction(-1, rangeFinderAction) --also add to rangefinder page

function cycleRangefinderButton()
	pings.rangefinerAnim()
	cycleRangefinder()
end

function cycleRangefinder()
	rangefinderMode = rangefinderMode+1
	
	--cycle to next valid mode
	if rangefinderMode == 0 then
		rangefinderCycleAction:setTitle("§6§l" .. TT_rangefinderCycle .. "§r§7\n" .. TT_rangefinderMode0):setItem("minecraft:white_concrete")
		pings.cycleRangefinder(rangefinderMode)
	elseif rangefinderMode == 1 and dartPosA then
		rangefinderCycleAction:setTitle("§6§l" .. TT_rangefinderCycle .. "§r§7\n" .. TT_rangefinderMode1):setItem("minecraft:red_concrete")
		pings.cycleRangefinder(rangefinderMode)
	elseif rangefinderMode == 2 and dartPosB then
		rangefinderCycleAction:setTitle("§6§l" .. TT_rangefinderCycle .. "§r§7\n" .. TT_rangefinderMode2):setItem("minecraft:blue_concrete")
		pings.cycleRangefinder(rangefinderMode)
	elseif rangefinderMode == 3 and dartPosC then
		rangefinderCycleAction:setTitle("§6§l" .. TT_rangefinderCycle .. "§r§7\n" .. TT_rangefinderMode3):setItem("minecraft:green_concrete")
		pings.cycleRangefinder(rangefinderMode)
	elseif rangefinderMode == 4 then
		rangefinderMode = -1
		cycleRangefinder() --looping back
	else
		cycleRangefinder() --invalid, increment and try again
	end
end

function pings.cycleRangefinder(mode, anim)
	--syncing
	rangefinderMode = mode
end

function pings.rangefinerAnim()
	animations.model.Rangefinder_Switch:stop()
	animations.model.Rangefinder_Switch:play()
	sounds:playSound("minecraft:ui.button.click", player:getPos(), 0.5, 1.1)
end

rangefinderCycleAction = rangefinderPage:newAction()
    :item("minecraft:white_concrete")
    :setOnLeftClick(cycleRangefinderButton)

function dartAlpha(state)
	if state then
		pings.fireDart(0)
	else
		pings.retrieveDart(0)
	end
end

dartAlphaAction = rangefinderPage:newAction()
    :item("minecraft:red_candle")
    :toggleItem("minecraft:black_candle")
    :setOnToggle(dartAlpha)
	:setToggleColor(0.6,0.5,0.5)
	
function dartBeta(state)
	if state then
		pings.fireDart(1)
	else
		pings.retrieveDart(1)
	end
end

dartBetaAction = rangefinderPage:newAction()
    :item("minecraft:blue_candle")
    :toggleItem("minecraft:black_candle")
    :setOnToggle(dartBeta)
	:setToggleColor(0.5,0.5,0.6)
	
function dartGamma(state)
	if state then
		pings.fireDart(2)
	else
		pings.retrieveDart(2)
	end
end

dartGammaAction = rangefinderPage:newAction()
    :item("minecraft:green_candle")
    :toggleItem("minecraft:black_candle")
    :setOnToggle(dartGamma)
	:setToggleColor(0.5,0.6,0.5)

function pings.fireDart(number)
	--find pos to put this thing
	if player:isLoaded() then
		local eyepos = player:getPos() + vec(0,player:getEyeHeight(),0)
		local block, hitpos = raycast:block(eyepos, eyepos+player:getLookDir()*RANGEFINDER_MAX*2)
		
		if block:hasCollision() then
			--anim
			animations.model.Rangefinder_Fire:stop()
			animations.model.Rangefinder_Fire:play()
		
			local lookDeg = math.deg(math.atan2(player:getLookDir().x, player:getLookDir().z))		
			local lookPitch = player:getLookDir().y*-90
			
			sounds:playSound("minecraft:item.trident.throw", eyepos)
			
			--depending on the dart firing...
			if number == 0 then
				--save pos and dimension
				dartPosA = hitpos
				dartDimA = world.getDimension()
				config:save("alphaPos", dartPosA)
				config:save("alphaDim", dartDimA)
				--hide dart on rangefinder model
				models.model.root.Body.RightArm.RangefinderArm.DartAlpha2:setVisible(false)
				models.model.root.Body.LeftArm.RangefinderArmLeft.DartAlpha4:setVisible(false)
				models.model.root.RightArmFirstPerson.RangefinderFirst.DartAlpha3:setVisible(false)
				--show and position world-anchored dart
				models.model.World.DartAlpha:setVisible(true):setPos(dartPosA*16):setRot(-lookPitch, lookDeg+180)
				animations.model.DartAlpha_Land:play()
				--action wheel
				dartAlphaAction:setToggleTitle("§C§l" .. TT_rangefinderReturnDart .. " §r§4α§r§7\n" .. TT_rangefinderLocation .. ": ".. math.round(dartPosA.x) .. " " .. math.round(dartPosA.y) .. " " .. math.round(dartPosA.z) .. "\n" .. TT_rangefinderDimension .. ": " .. dartDimA)			
				--land effects
				sounds:playSound("minecraft:entity.arrow.hit", hitpos, 0.8, 1.5)
				if client:getVersion() ~= "1.21" then
					particles:newParticle("minecraft:block " .. block:getID(), hitpos)
					particles:newParticle("minecraft:block " .. block:getID(), hitpos)
					particles:newParticle("minecraft:block " .. block:getID(), hitpos)
				end
			elseif number == 1 then
				--save pos and dimension
				dartPosB = hitpos
				dartDimB = world.getDimension()
				config:save("betaPos", dartPosB)
				config:save("betaDim", dartDimB)
				--hide dart on rangefinder model
				models.model.root.Body.RightArm.RangefinderArm.DartBeta2:setVisible(false)
				models.model.root.Body.LeftArm.RangefinderArmLeft.DartBeta4:setVisible(false)
				models.model.root.RightArmFirstPerson.RangefinderFirst.DartBeta3:setVisible(false)
				--show and position world-anchored dart
				models.model.World.DartBeta:setVisible(true):setPos(dartPosB*16):setRot(-lookPitch, lookDeg+180)
				animations.model.DartBeta_Land:play()
				--action wheel
				dartBetaAction:setToggleTitle("§C§l" .. TT_rangefinderReturnDart .. " §r§1β§r§7\n" .. TT_rangefinderLocation .. ": ".. math.round(dartPosB.x) .. " " .. math.round(dartPosB.y) .. " " .. math.round(dartPosB.z) .. "\n" .. TT_rangefinderDimension .. ": " .. dartDimB)
				--land effects
				sounds:playSound("minecraft:entity.arrow.hit", hitpos, 0.8, 1.5)
				if client:getVersion() ~= "1.21" then
					particles:newParticle("minecraft:block " .. block:getID(), hitpos)
					particles:newParticle("minecraft:block " .. block:getID(), hitpos)
					particles:newParticle("minecraft:block " .. block:getID(), hitpos)
				end
			elseif number == 2 then
				--save pos and dimension
				dartPosC = hitpos
				dartDimC = world.getDimension()
				config:save("gammaPos", dartPosC)
				config:save("gammaDim", dartDimC)
				--hide dart on rangefinder model
				models.model.root.Body.RightArm.RangefinderArm.DartGamma2:setVisible(false)
				models.model.root.Body.LeftArm.RangefinderArmLeft.DartGamma4:setVisible(false)
				models.model.root.RightArmFirstPerson.RangefinderFirst.DartGamma3:setVisible(false)
				--show and position world-anchored dart
				models.model.World.DartGamma:setVisible(true):setPos(dartPosC*16):setRot(-lookPitch, lookDeg+180)
				animations.model.DartGamma_Land:play()
				--action wheel
				dartGammaAction:setToggleTitle("§C§l" .. TT_rangefinderReturnDart .. " §r§2γ§r§7\n" .. TT_rangefinderLocation .. ": ".. math.round(dartPosC.x) .. " " .. math.round(dartPosC.y) .. " " .. math.round(dartPosC.z) .. "\n" .. TT_rangefinderDimension .. ": " .. dartDimC)
				--land effects
				sounds:playSound("minecraft:entity.arrow.hit", hitpos, 0.8, 1.5)
				if client:getVersion() ~= "1.21" then
					particles:newParticle("minecraft:block " .. block:getID(), hitpos)
					particles:newParticle("minecraft:block " .. block:getID(), hitpos)
					particles:newParticle("minecraft:block " .. block:getID(), hitpos)
				end
			end		
			
			--change mode to fired dart
			rangefinderMode = number
			cycleRangefinder()
		else
			host:setActionbar("Found no valid place to put dart")
			--reset toggle
			if number == 0 then
				dartAlphaAction:setToggled(false)
			elseif number == 1 then
				dartBetaAction:setToggled(false)
			elseif nubmer == 2 then
				dartGammaAction:setToggled(false)
			end		
		end
	end
end

function pings.retrieveDart(number)
	sounds:playSound("minecraft:item.trident.return", player:getPos(), 1, 1.5)
	
	--depending on the dart returning...
	if number == 0 then
		--effects
		particles:newParticle("minecraft:smoke", dartPosA):setColor(1,1,1)
		particles:newParticle("minecraft:smoke", dartPosA):setColor(1,1,1)
		--clear dart data
		dartPosA = nil
		dartDimA = nil
		config:save("alphaPos", nil)
		config:save("alphaDim", nil)
		--hide world dart and show rangefinder clip dart
		models.model.root.Body.RightArm.RangefinderArm.DartAlpha2:setVisible(true)
		models.model.root.Body.LeftArm.RangefinderArmLeft.DartAlpha4:setVisible(true)
		models.model.root.RightArmFirstPerson.RangefinderFirst.DartAlpha3:setVisible(true)
		models.model.World.DartAlpha:setVisible(false)
		animations.model.DartAlpha_Land:stop()
	elseif number == 1 then
		--effects
		particles:newParticle("minecraft:smoke", dartPosB):setColor(1,1,1)
		particles:newParticle("minecraft:smoke", dartPosB):setColor(1,1,1)
		--clear dart data
		dartPosB = nil
		dartDimB = nil
		config:save("betaPos", nil)
		config:save("betaDim", nil)
		--hide world dart and show rangefinder clip dart
		models.model.root.Body.RightArm.RangefinderArm.DartBeta2:setVisible(true)
		models.model.root.Body.LeftArm.RangefinderArmLeft.DartBeta4:setVisible(true)
		models.model.root.RightArmFirstPerson.RangefinderFirst.DartBeta3:setVisible(true)
		models.model.World.DartBeta:setVisible(false)
		animations.model.DartBeta_Land:stop()
	elseif number == 2 then
		--effects
		particles:newParticle("minecraft:smoke", dartPosC):setColor(1,1,1)
		particles:newParticle("minecraft:smoke", dartPosC):setColor(1,1,1)
		--clear dart data
		dartPosC = nil
		dartDimC = nil
		config:save("gammaPos", nil)
		config:save("gammaDim", nil)
		--hide world dart and show rangefinder clip dart
		models.model.root.Body.RightArm.RangefinderArm.DartGamma2:setVisible(true)
		models.model.root.Body.LeftArm.RangefinderArmLeft.DartGamma4:setVisible(true)
		models.model.root.RightArmFirstPerson.RangefinderFirst.DartGamma3:setVisible(true)
		models.model.World.DartGamma:setVisible(false)
		animations.model.DartGamma_Land:stop()
	end
end

function pings.holoMenu(state)
	--save value so we know not to sync again
	syncedMenuState = state
	if player:isLoaded() then
		--hide/show holomenu
		if state then
			animations.model.HoloMenu_Disapear:stop()
			animations.model.HoloMenu_Appear:play()
			sounds:playSound("minecraft:ui.toast.in", player:getPos(), 0.2, 1.1)
		else
			animations.model.HoloMenu_Disapear:play()
			animations.model.HoloMenu_Appear:stop()
			sounds:playSound("minecraft:ui.toast.out", player:getPos(), 0.2, 1.1)
		end
	end
end

function pings.aquire(a,b,c,d)
	local uuid = client:intUUIDToString(a,b,c,d)

	--sync aquired entity, if nil then clear
	if uuid then
		targetEntity = world.getEntity(uuid)
		sequenceNo = 3
		sequenceTime = 3
	else
		targetEntity = nil
	end
end

function pings.setPredicate(id, predicateId, sound)
	--sync the button being looked at by host
	buttonTargeted = id
	syncedButtonTargeted = id
	
	for i = 1, 6, 1 do
		--adjust button size if selected or looked at
		buttonIds[i]:setScale((id == i or predicateId == i) and vec(1.2,1.2,1.2) or vec(1,1,1))
		
		--also adjust colors
		if predicateId == i then
			buttonIds[i]:setUVPixels(-7,0)
		elseif id == i then
			buttonIds[i]:setUVPixels(2,0)
		else
			buttonIds[i]:setUVPixels(0,0)
		end		
	end
	
	if sound then
		--also play the press sound
		sounds:playSound("minecraft:block.nether_wood_button.click_on", sentryPos)
	end
end

function pings.sentryEnabled(state)
	sentryEnabled = state
	
	--adjusjt animations
	animations.model.Sentry_Idle:setPlaying(sentryEnabled)
	rareIdle:setEnabled(sentryEnabled and sentryActive)
	
	if sentryEnabled then
		BUTTON_TEXT:setText("Disable")
		animations.model.Sentry_Enable:play()
		animations.model.Sentry_Disable:stop()
		
		--play tone
		sequenceNo = 1
		sequenceTime = 7
	else
		BUTTON_TEXT:setText("Enable")
		animations.model.Sentry_Disable:play()
		
		--play tone
		sequenceNo = 2
		sequenceTime = 8
	end
end

function pings.syncSentryPos(x,y,z)
	if not host:isHost() then
		hostPingPathing = true
	end
	syncedPingPathing = true

	sentryPosOld = sentryPos
	sentryPos = vec(x,y,z)+vec(0.5,0.5,0.5)
end

function pings.noMorePingPathing()
	hostPingPathing = false
	syncedPingPathing = false
end

function pings.syncStuff(n_sentryActive, n_sentryEnabled, n_rangefinder, n_sentryYaw, x,y,z, turretPredicateID)
	sentryActive = n_sentryActive
	
	if sentrytEnabled ~= n_sentryEnabled then
		sentryEnabled = n_sentryEnabled
		animations.model.Sentry_Idle:setPlaying(sentryEnabled)
		rareIdle:setEnabled(sentryEnabled and sentryActive)
		if sentryEnabled then
			BUTTON_TEXT:setText("Disable")
			animations.model.Sentry_Enable:play()
			animations.model.Sentry_Disable:stop()
		else
			BUTTON_TEXT:setText("Enable")
			animations.model.Sentry_Disable:play()
		end
	end	
	
	rangefinder = n_rangefinder
	
	models.model.World.SentryTurret:setVisible(sentryActive or sentryReturn)
	
	if sentryActive then
		sentryYaw = n_sentryYaw
		sentryPos = vec(x,y,z)+vec(0.5,0,0.5)
		models.model.World.SentryTurret:setPos(sentryPos*16)
		
		if turretPredicateID == 1 then
			turretPredicate = nothing
		elseif turretPredicateID == 2 then
			turretPredicate = noPlayer
		elseif turretPredicateID == 3 then
			turretPredicate = noOwner
		elseif turretPredicateID == 4 then
			turretPredicate = anyLiving
		end
		
		predicateId = turretPredicateID
	end
end

function pings.dartSync(dimA, posA, rotA, dimB, posB, rotB, dimC, posC, rotC)
	dartDimA = dimA
	dartPosA = posA
	if dartPosA then
		models.model.World.DartAlpha:setPos(dartPosA*16):setRot(rotA)
	end
	
	dartDimB = dimB
	dartPosB = posB
	if dartPosB then
		models.model.World.DartBeta:setPos(dartPosB*16):setRot(rotB)	
	end
	
	dartDimC = dimC
	dartPosC = posC
	if dartPosC then
		models.model.World.DartGamma:setPos(dartPosC*16):setRot(rotC)
	end
end

function pings.syncDrone(a,b,c,d)
	local uuid = client:intUUIDToString(a,b,c,d)
	
	droneTarget = world.getEntity(uuid)
	droneTimer = 0
end

function rareIdleSound()
	--funny clank sound
	sounds:playSound("minecraft:block.anvil.place", sentryPos, 0.1, 1.2)
end

--play anims and actions for the actual sentry shooting
function sentryshot(leftSide)
	--check entity still exists, just in case
	if targetEntity then
		--KILL
		--host:sendChatCommand("damage " .. targetEntity:getUUID() .. " 4 minecraft:arrow by @s")
		
		sounds:playSound("minecraft:item.trident.throw", sentryPos)
		sounds:playSound("minecraft:item.crossbow.shoot", sentryPos, 0.5, 1.3)
		
		models.model.World.SentryTurret.LaserPivot:setRot(sentryPitch, sentryYaw,0)
		
		--tracer effect
		local cameraPos = sentryPos+vec(0,0.8,0)
		local targetPos = targetEntity:getPos()
		local dist = math.sqrt((cameraPos.x-targetPos.x)^2+(cameraPos.y-targetPos.y)^2+(cameraPos.z-targetPos.z)^2)
		tracerScale = 1
		tracerLength = dist*16
		
		if leftSide then
			--line(cameraPos-vec(5/16,0,0), sentryTarget, "purple")
			
			animations.model.Sentry_FireLeft:play()
			
			--tracer effect			
			models.model.World.SentryTurret.LaserPivot.LeftLaser:setScale(1,1,tracerLength)
			
			--particles
			local pos = models.model.World.SentryTurret.YawBearing.Mount.PitchBearing.Gun.LeftSide.LeftVents:partToWorldMatrix():apply()
			local vel = vectors.rotateAroundAxis(sentryYaw, vec(0.02, 0, -0.06), vec(0, 1, 0))			
			particles:newParticle("minecraft:smoke", pos, vec(0,0.05,0)+vel*0.9):setColor(0.8,0.8,1)
			particles:newParticle("minecraft:smoke", pos, vec(0,0.03,0)+vel):setColor(0.8,0.8,1)
		else
			--line(cameraPos+vec(5/16,0,0), sentryTarget, "purple")
			
			animations.model.Sentry_FireRight:play()
			
			--tracer effect			
			models.model.World.SentryTurret.LaserPivot.RightLaser:setScale(1,1,tracerLength)
			
			--particles
			local pos = models.model.World.SentryTurret.YawBearing.Mount.PitchBearing.Gun.RightSide.RightVents:partToWorldMatrix():apply()
			local vel = vectors.rotateAroundAxis(sentryYaw, vec(-0.02, 0, -0.06), vec(0, 1, 0))			
			particles:newParticle("minecraft:smoke", pos, vec(0,0.05,0)+vel*0.9):setColor(0.8,0.8,1)
			particles:newParticle("minecraft:smoke", pos, vec(0,0.03,0)+vel):setColor(0.8,0.8,1)
		end		
	end
end

function drone_scan()
	--force drone to find a target
	--cast in player look dir
	local raystart = player:getPos() + vec(0,player:getEyeHeight(),0)
	local rayend = raystart+player:getLookDir()*16
	
	local block, hitpos = raycast:block(raystart, rayend)
	
	if debugOn then
		line(raystart, hitpos, "cyan")
	end
	
	local entity = raycast:entity(raystart, hitpos, noOwner)
	
	droneTarget = entity
	droneTimer = 0
	
	if entity then
		pings.syncDrone(client:uuidToIntArray(entity:getUUID()))
	else
		pings.syncDrone(nil)
	end
end

function events.tick()
	--charater stuff	
	
	--calculate tilting
	local targetBodyPitch = squapi.getForwardVel()*-75 + squapi.yvel()*-10
	local targetBodyRoll = squapi.getSideVelocity()*50
	
	local targetArmSpread = squapi.yvel()*-15
	
	--clamp
	--[[targetBodyPitch = math.max(math.min(targetBodyPitch, 20),-20)	
	targetBodyRoll = math.max(math.min(targetBodyRoll, 15),-15)
	
	targetArmSpread = math.max(math.min(targetArmSpread, 15), -5)
	]]
	--invert in vechiles, so less like leaning and more like air friction
	if player:getVehicle() then
		targetBodyPitch = targetBodyPitch*-0.5
		targetBodyRoll = targetBodyRoll*-0.5
	end
	
	--save values for smoothing
	bodyPitchOld = bodyPitch
	bodyRollOld = bodyRoll	
	
	armSpreadOld = armSpread
	
	--smooth turning, but don't adjust if close enough (fixes some jank)
	if math.abs(bodyPitch-targetBodyPitch) > 0.1 then	
		bodyPitch = math.lerp(bodyPitch, targetBodyPitch, 0.2)
	end
	if math.abs(bodyRoll-targetBodyRoll) > 0.1 then
		bodyRoll = math.lerp(bodyRoll, targetBodyRoll, 0.2)
	end
	if math.abs(armSpread-targetArmSpread) > 0.1 then
		armSpread = math.lerp(armSpread, targetArmSpread, 0.2)
	end
	
	--clamp
	bodyPitch = math.max(math.min(bodyPitch, 20),-20)
	bodyRoll = math.max(math.min(bodyRoll, 15),-15)
	
	armSpread = math.max(math.min(armSpread, 15), -5)
	
	if player:isInWater() and world.getTime()%10 == 0 then
		particles:newParticle("minecraft:bubble", player:getPos()+vec(0,0.5,0))
		particles:newParticle("minecraft:bubble", player:getPos()+vec(0,0.5,0))
	end
	
	--my crappy swining physics thingy
	swingPirate.AnchorHead(swingThing, nil, nil, nil, nil, bodyPitch, 15, nil)
	
	--sync holomenu stuff
	if host:isHost() then
		if (host:isContainerOpen() or not client:isWindowFocused()) ~= syncedMenuState then
			pings.holoMenu(host:isContainerOpen() or not client:isWindowFocused())
		end
	end
	
	models.model.root.Body._HeadMount.Head.HoloMenu:setVisible(syncedMenuState or (animations.model.HoloMenu_Disapear:isPlaying() and animations.model.HoloMenu_Disapear:getTime() < 0.46))
	
	--a sleepy
	models.model.root.Body._HeadMount.Head.Eyelid:setPos(player:getPose() == "SLEEPING" and vec(0,-2,-0.15) or vec(0,0,0))
	
	models.model.root.Body._HeadMount.Head.Antenna.light_:setVisible(world:getTime()%47 == 0 or world:getTime()%64 == 0)
	
	--watch
	local timeticks = 0
	if world.getDimension() == "minecraft:the_nether" or world.getDimension() == "minecraft:the_end" then
		timeticks = (math.sin(world.getTime()/518)*172 + math.cos(world.getTime()/237)*281 + 827)*75
	else
		timeticks = world.getTimeOfDay()%24000+6000
	end
	models.model.root.Body.LeftArm.Watch.hour_hand:setOffsetRot(math.map(-timeticks/1200,0,10,0,360), 0, 0)
	models.model.root.Body.LeftArm.Watch.minute_hand:setOffsetRot(math.map(-timeticks/20,0,60,0,360), 0, 0)
	
	models.model.root.LeftArmFirstPerson.Arm2.Watch2.hour_hand:setOffsetRot(math.map(-timeticks/1200,0,10,0,360), 0, 0)
	models.model.root.LeftArmFirstPerson.Arm2.Watch2.minute_hand:setOffsetRot(math.map(-timeticks/20,0,60,0,360), 0, 0)	
	
	--legText = legText .. string.format("%i♥/%i♥\n%i🍖", player:getHealth(), player:getMaxHealth(), player:getFood()) --+§6%i§r §6+%i§r
	--leg monitor
	local legText = player:getName() .. "\n" .. math.ceil(player:getHealth())
	
	if player:getAbsorptionAmount() > 0 then
		legText = legText .. string.format("§6+%.0f§r", player:getAbsorptionAmount())
	end
	
	legText = legText .. string.format("♥/%i♥\n%.0f", player:getMaxHealth(), player:getFood())
	
	if player:getSaturation() > 0 then
		legText = legText .. string.format("§6+%.0f§r", player:getSaturation())
	end
	
	legText = legText .. "🍖"
	
	--LEG_TEXT:setText(player:getName() .. "\n" .. player:getHealth() .. "§6+" .. player:getAbsorptionAmount() .. "§r♥/" .. player:getMaxHealth() .. "♥\n" .. player:getFood() .. "§6+" .. math.floor(player:getSaturation()) .. "§r🍖" )
	LEG_TEXT:setText(legText)
	
	--electic stuff
	models.model.ItemCrossbow.StaveL.StaveLEnd.StringL.electric:setUVPixels(math.random(0,14), math.random(0,11)):setOffsetRot(math.random(-15,15),math.random(-15,15),math.random(-15,15)):setScale(math.random(0.8,1.2))
	models.model.ItemCrossbow.StaveR.StaveREnd.StringR.electric:setUVPixels(math.random(0,14), math.random(0,11)):setOffsetRot(math.random(-15,15),math.random(-15,15),math.random(-15,15)):setScale(math.random(0.8,1.2))
	
	--electric shocks
	if sentryActive and sentryEnabled then
		local rightShock = math.random(0,100) < 5
		local leftShock
		
		--shock sound plays for 1 tick and cuts off
		if shockSoundHandle then
			shockSoundHandle:stop()
			shockSoundHandle = nil
		end
	
		if rightShock then
			shockSoundHandle = sounds:playSound("minecraft:entity.guardian.attack", sentryPos, 1, 2)
			sounds:playSound("minecraft:block.metal.hit", sentryPos, 0.5, 2)
		else
			leftShock = math.random(0,100) < 5
		end
		
		if leftShock then
			shockSoundHandle = sounds:playSound("minecraft:entity.guardian.attack", sentryPos, 1, 2)
			sounds:playSound("minecraft:block.metal.hit", sentryPos, 0.5, 2)
		end
	
		models.model.World.SentryTurret.YawBearing.Mount.PitchBearing.Gun.RightSide.RightVents.electric:setVisible(rightShock)
		models.model.World.SentryTurret.YawBearing.Mount.PitchBearing.Gun.LeftSide.LeftVents.electric:setVisible(leftShock)
	end
	
	--rangefinder stuff
	animations.model.Rangefinder_Hold:setPlaying(rangefinder and not player:isLeftHanded())
	animations.model.Rangefinder_HoldLeft:setPlaying(rangefinder and player:isLeftHanded())
	if rangefinder then
		--useful vars
		local eyepos = player:getPos() + vec(0,player:getEyeHeight(),0)
		static = false
		
		local lookDeg = math.deg(math.atan2(player:getLookDir().x, player:getLookDir().z))		
		local lookPitch = player:getLookDir().y*-90		
	
		local text = "???"
	
		local distA = 0
		local distB = 0
		local distC = 0
	
		--find distances
		if dartDimA == world.getDimension() then
			distA = math.ceil(math.sqrt((eyepos.x-dartPosA.x)^2+(eyepos.y-dartPosA.y)^2+(eyepos.z-dartPosA.z)^2)*10)/10
		end
		if dartDimB == world.getDimension() then
			distB = math.ceil(math.sqrt((eyepos.x-dartPosB.x)^2+(eyepos.y-dartPosB.y)^2+(eyepos.z-dartPosB.z)^2)*10)/10
		end
		if dartDimC == world.getDimension() then
			distC = math.ceil(math.sqrt((eyepos.x-dartPosC.x)^2+(eyepos.y-dartPosC.y)^2+(eyepos.z-dartPosC.z)^2)*10)/10
		end
	
		--unit conversions
		local unitConversion = client.getActiveLang() == "en_pt" and 1.8288 or client.getActiveLang() == "lol_us" and 0.46 or 1
	
		--display graphics
		if rangefinderMode == 0 then --rangefinding
		
			local block, hitpos = raycast:block(eyepos, eyepos+player:getLookDir()*RANGEFINDER_MAX)
			
			--entity check
			local entity, hitpose = raycast:entity(eyepos, hitpos, (function(entity) return entity ~= player end))
			
			local dist = "??"
			local name = TT_rangefinderNoSignal
			
			if entity then
				dist = math.ceil(math.sqrt((eyepos.x-hitpose.x)^2+(eyepos.y-hitpose.y)^2+(eyepos.z-hitpose.z)^2)*10)/10
				name = client.getTranslatedString(entity:getName())
				
				--convert units
				local showDist = math.ceil(dist/unitConversion*10)/10
				
				if entity:isLiving() then
				
					text = showDist .. TT_rangefinderUnits .. "\n" .. name .. "\n" .. math.round(entity:getHealth()) .. "♥/" .. entity:getMaxHealth() .. "♥"
				else
					text = showDist .. TT_rangefinderUnits .. "\n" .. name
				end
			else
				--drone check
				local blockDist = math.sqrt((eyepos.x-hitpos.x)^2+(eyepos.y-hitpos.y)^2+(eyepos.z-hitpos.z)^2)
				
				local hit, _, droneDist = intersectBox(eyepos, player:getLookDir(), dronePos, vec(-6/16,-1/16,-6/16),  vec(6/16,5/16,6/16), blockDist)
				
				if hit then
					local showDist = math.ceil(droneDist/unitConversion*10)/10
				
					text = showDist .. TT_rangefinderUnits .. "\n" .. TT_droneName
				else
					local hit, sentryDist
				
					if sentryActive or sentryReturn then
						hit, _, sentryDist = intersectBox(eyepos, player:getLookDir(), sentryPos, vec(-0.5,0,-0.5),  vec(0.5,1,0.5), blockDist)
					end
					
					if hit then
						local showDist = math.ceil(sentryDist/unitConversion*10)/10
					
						text = showDist .. TT_rangefinderUnits .. "\n" .. TT_sentryName
					else		
						--block check
						if block:hasCollision() then
							--dist = math.ceil(math.sqrt((eyepos.x-hitpos.x)^2+(eyepos.y-hitpos.y)^2+(eyepos.z-hitpos.z)^2)*10)/10
							dist = math.ceil(blockDist/unitConversion*10)/10
							name = client.getTranslatedString("block." .. string.gsub(block:getID(), ":", "."))
						else
							static = true
						end
						
						text = dist .. TT_rangefinderUnits .. "\n" .. name
					end
				end
			end
		elseif rangefinderMode == 1 then --locate alpha
			if dartPosA then
				if dartDimA == world.getDimension() then
					--convert units
					local showDist = math.ceil(distA/unitConversion*10)/10
				
					text = "Dart Alpha | α\n" .. showDist .. TT_rangefinderUnits
				else
					text = "Dart Alpha | α\n ??m\n" .. name
					static = true
				end
			else
				cycleRangefinder() --whoops, can't find this one anymore, cycle foward
			end		
		elseif rangefinderMode == 2 then --locate beta	
			if dartPosB then
				if dartDimB == world.getDimension() then
					--convert units
					local showDist = math.ceil(distB/unitConversion*10)/10
					
					text = "Dart Beta | β\n" .. showDist .. TT_rangefinderUnits
				else
					text = "Dart Beta | β\n ??m\n" .. name
					static = true
				end
			else
				cycleRangefinder()
			end		
		elseif rangefinderMode == 3 then --locate gamma
			if dartPosC then		
				if dartDimC == world.getDimension() then
					--convert units
					local showDist = math.ceil(distC/unitConversion*10)/10
					
					text = "Dart Gamma | γ\n" .. showDist .. TT_rangefinderUnits
				else
					text = "Dart Gamma | γ\n ??m\n" .. name
					static = true
				end
			else
				cycleRangefinder()
			end
		end
		
		
		--do the text
		local result = client:getTextDimensions(text, 4*1/0.05, true)
		local iterations = 0
		
		local lineCount = (result.y-9%10)/10+1
		local scale = 0.05
		
		--really shoddy way of doing this (trial and error approach)
		if lineCount > 4 then
			repeat
				--rescale
				scale = 0.05-(lineCount-4)*0.01
				RANGE_TEXT:setWidth(4*1/scale):setScale(scale)
				
				iterations = iterations+1	
				
				--recalcualte size
				result = client:getTextDimensions(text, 4*1/scale, true)
				lineCount = (result.y-9%10)/10+1			
			until result.y*scale == 2 or iterations > 4
			
			RANGE_TEXT_LEFT:setWidth(4*1/scale):setScale(scale)
			RANGE_TEXT_THIRDPERSON:setWidth(4*1/scale):setScale(scale)
			RANGE_TEXT_THIRDPERSON_LEFT:setWidth(4*1/scale):setScale(scale)
		else
			RANGE_TEXT:setScale(0.05):setWidth(4*1/0.05)
			RANGE_TEXT_LEFT:setScale(0.05):setWidth(4*1/0.05)
			RANGE_TEXT_THIRDPERSON:setScale(0.05):setWidth(4*1/0.05)
			RANGE_TEXT_THIRDPERSON_LEFT:setScale(0.05):setWidth(4*1/0.05)
		end
		RANGE_TEXT:setText(text)
		RANGE_TEXT_LEFT:setText(text)
		RANGE_TEXT_THIRDPERSON:setText(text)
		RANGE_TEXT_THIRDPERSON_LEFT:setText(text)
		
		--directonal pointers
		if dartPosA then
			--find angle pointing towards dart
			local markerYaw = math.deg(math.atan2(eyepos.x-dartPosA.x, eyepos.z-dartPosA.z))+180
			local markerPitch = math.deg(-math.atan2(math.sqrt((eyepos.x-dartPosA.x)^2+(eyepos.z-dartPosA.z)^2), eyepos.y-dartPosA.y))+90
			
			--save pos for smoothing
			markAPosOld = markAPos
			markARotOld = markARot
			
			markAPos = eyepos*16
			markARot = vec(markerPitch, markerYaw, 0)
			
			local scale
			
			--scale down with distance, and if really close
			if distA > 10 then
				scale = math.max(1-0.0005*distA,0.2)
			else
				scale = 0.1*distA
			end
			
			models.model.World.MarkerAlpha.cube:setScale(rangefinderMode == 1 and scale or scale*0.5)
		end
		if dartPosB then
			--find angle pointing towards dart
			local markerYaw = math.deg(math.atan2(eyepos.x-dartPosB.x, eyepos.z-dartPosB.z))+180
			local markerPitch = math.deg(-math.atan2(math.sqrt((eyepos.x-dartPosB.x)^2+(eyepos.z-dartPosB.z)^2), eyepos.y-dartPosB.y))+90
			
			--save pos for smoothing
			markBPosOld = markBPos
			markBRotOld = markBRot
			
			markBPos = eyepos*16
			markBRot = vec(markerPitch, markerYaw, 0)
			
			local scale
			
			--scale down with distance, and if really close
			if distB > 10 then
				scale = math.max(1-0.0005*distB,0.2)
			else
				scale = 0.1*distB
			end
			
			models.model.World.MarkerBeta.cube:setScale(rangefinderMode == 2 and scale or scale*0.5)
		end
		if dartPosC then
			--find angle pointing towards dart
			local markerYaw = math.deg(math.atan2(eyepos.x-dartPosC.x, eyepos.z-dartPosC.z))+180
			local markerPitch = math.deg(-math.atan2(math.sqrt((eyepos.x-dartPosC.x)^2+(eyepos.z-dartPosC.z)^2), eyepos.y-dartPosC.y))+90
			
			--save pos for smoothing
			markCPosOld = markCPos
			markCRotOld = markCRot
			
			markCPos = eyepos*16
			markCRot = vec(markerPitch, markerYaw, 0)
			
			local scale
			
			--scale down with distance, and if really close
			if distC > 10 then
				scale = math.max(1-0.0005*distC,0.2)
			else
				scale = 0.1*distC
			end
			
			models.model.World.MarkerGamma.cube:setScale(rangefinderMode == 3 and scale or scale*0.5)
		end
		
		--static effect when no signal
		models.model.root.RightArmFirstPerson.RangefinderFirst.Screen2.static:setVisible(static)
		models.model.root.LeftArmFirstPerson.RangefinderFirstLeft.Screen4.static:setVisible(static)
		models.model.root.Body.RightArm.RangefinderArm.Screen.static:setVisible(static)
		models.model.root.Body.LeftArm.RangefinderArmLeft.Screen3.static:setVisible(static)
		if static then
			--random location
			local uvx = math.random(0,12)
			local uvy = math.random(0,14)
			
			--set uv
			models.model.root.RightArmFirstPerson.RangefinderFirst.Screen2.static:setUVPixels(uvx,uvy)
			models.model.root.LeftArmFirstPerson.RangefinderFirstLeft.Screen4.static:setUVPixels(uvx,uvy)
			models.model.root.Body.RightArm.RangefinderArm.Screen.static:setUVPixels(uvx,uvy)
			models.model.root.Body.LeftArm.RangefinderArmLeft.Screen3.static:setUVPixels(uvx,uvy)
		end
		
		--check if should autodisable
		if player:getItem(1).id ~= "minecraft:air" then
			pings.rangefinder(false)
			rangeFinderAction:setToggled(false)
		end
	end
	
	--show/hide markers and tint darker and move forward when not selected
	models.model.World.MarkerAlpha:setVisible(rangefinder and dartDimA == world.getDimension())
	models.model.World.MarkerAlpha.cube:setUVPixels(rangefinderMode == 1 and 0 or 5, 0):setPos(0,0,rangefinderMode == 1 and -0.25 or 0)
	models.model.World.DartAlpha:setVisible(dartDimA == world.getDimension())
	
	models.model.World.MarkerBeta:setVisible(rangefinder and dartDimB == world.getDimension())
	models.model.World.MarkerBeta.cube:setUVPixels(rangefinderMode == 2 and 0 or 5, 0):setPos(0,0,rangefinderMode == 2 and -0.25 or 0)
	models.model.World.DartBeta:setVisible(dartDimB == world.getDimension())
	
	models.model.World.MarkerGamma:setVisible(rangefinder and dartDimC == world.getDimension())
	models.model.World.MarkerGamma.cube:setUVPixels(rangefinderMode == 3 and 0 or 5, 0):setPos(0,0,rangefinderMode == 3 and -0.25 or 0)
	models.model.World.DartGamma:setVisible(dartDimC == world.getDimension())
	
	--sentry stuff

	--play tone sequences
	if sequenceTime > 0 then
		sequenceTime = sequenceTime-1
		
		if sequenceNo == 1 then --boot
			if sequenceTime == 6 then
				sounds:playSound("minecraft:block.note_block.bit", sentryPos, 1, 1)
			elseif sequenceTime == 3 then
				sounds:playSound("minecraft:block.note_block.bit", sentryPos, 1, 1.2)
			elseif sequenceTime == 0 then
				sounds:playSound("minecraft:block.note_block.bit", sentryPos, 1, 1.5)
			end
		elseif sequenceNo == 2 then --deactivate
			if sequenceTime == 7 then
				sounds:playSound("minecraft:block.note_block.bit", sentryPos, 1, 1.2)
			elseif sequenceTime == 5 then
				sounds:playSound("minecraft:block.note_block.bit", sentryPos, 1, 1)
			elseif sequenceTime == 3 then
				sounds:playSound("minecraft:block.note_block.bit", sentryPos, 1, 0.8)
			elseif sequenceTime == 0 then
				sounds:playSound("minecraft:block.note_block.bit", sentryPos, 1, 0.7)
			end
		elseif sequenceNo == 3 then --aquire target
			if sequenceTime == 2 then
				sounds:playSound("minecraft:block.note_block.bit", sentryPos, 1, 1.3)
			elseif sequenceTime == 0 then
				sounds:playSound("minecraft:block.note_block.bit", sentryPos, 1, 1.35)
			end
		elseif sequenceNo == 4 then --lose target
			if sequenceTime == 2 then
				sounds:playSound("minecraft:block.note_block.bit", sentryPos, 1, 1)
			elseif sequenceTime == 1 then
				sounds:playSound("minecraft:block.note_block.bit", sentryPos, 1, 0.7)
			elseif sequenceTime == 0 then
				sounds:playSound("minecraft:block.note_block.bit", sentryPos, 1, 0.5)
			end
		elseif sequenceNo == 5 then --affirm
			if sequenceTime == 2 then
				sounds:playSound("minecraft:block.note_block.bit", sentryPos, 1, 1)
			elseif sequenceTime == 0 then
				sounds:playSound("minecraft:block.note_block.bit", sentryPos, 1, 1.1)
			end
		end
	end

	if sentryActive then
		--if its enabled and done its start anim
		if sentryEnabled and animations.model.Sentry_Deploy:isStopped() then
			--find centry "camera" location
			local cameraPos = sentryPos+vec(0,0.8,0)
		
			sentryTarget =  nil
			
			--save smoothing values
			sentryYawOld = sentryYaw
			sentryPitchOld = sentryPitch
			
			if targetEntity then
				if not targetEntity:isLiving() and targetEntity:getDeathTime() ~= 0 then
					--target dead or gone					
					targetEntity = nil
					
					--play lose target tone
					if sequenceTime == 0 then
						sequenceNo = 4
						sequenceTime = 3
					end
				end
			end
			
			if targetEntity then
				--calculate angle to point at target
				
				--every 10th tick check target LOS
				sentryTarget = nil
				local entity
				
				if world:getTime()%10 == 0 then
					for i = 1, 3, 1 do
					
						if i == 1 then
							--center
							sentryTarget = targetEntity:getPos() + vec(0,targetEntity:getBoundingBox().y/2,0)
						elseif i == 2 then
							--upper quarter
							sentryTarget = targetEntity:getPos() + vec(0,targetEntity:getBoundingBox().y*0.75,0)
						else
							--lower quarter
							sentryTarget = targetEntity:getPos() + vec(0,targetEntity:getBoundingBox().y*0.25,0)
						end
					
						sentryPitch = math.deg(-math.atan2(math.sqrt((cameraPos.x-sentryTarget.x)^2+(cameraPos.z-sentryTarget.z)^2), cameraPos.y-sentryTarget.y))+90
						sentryYaw = math.deg(math.atan2(cameraPos.x-sentryTarget.x, cameraPos.z-sentryTarget.z))+180
					
						local block, hitpos = raycast:block(cameraPos, cameraPos+vectors.angleToDir(sentryPitch, -sentryYaw)*SENTRY_RANGE)
						
						entity = raycast:entity(cameraPos, hitpos, (function(entity) return entity == targetEntity and turretPredicate(entity) end))
						
						if debugOn then
							line(cameraPos, hitpos, "G")
						end
						
						--scrapped laser code
						if ehit then
							local dist = math.sqrt((cameraPos.x-ehit.x)^2+(cameraPos.y-ehit.y)^2+(cameraPos.z-ehit.z)^2)
							
							models.model.World.SentryTurret.YawBearing.Mount.FrontMount.Cam.Laser:setScale(1,1,dist*16)
							models.model.World.SentryTurret.YawBearing.Mount.FrontMount.Cam.Laser:setRot(sentryPitch,0,0)
						end
						
						if entity then break end
					end
					
					if entity then
						--keep firing
						sentryshot(leftSide)
						leftSide = not leftSide
					else					
						--LOS lost, play lose target tone
						if sequenceTime == 0 then
							sequenceNo = 4
							sequenceTime = 3
						end
						
						--unaquire target
						targetEntity = nil
						animations.model.Sentry_Fire:stop()
					end
				end
				
			else
				--idle turn
				sentryYaw = sentryYaw+SENTRY_ROT_SPEED				
				if sentryYaw > 360 then
					sentryYaw = sentryYaw-360
				end
				sentryPitch = 0
				
				--aquire entity
				if host:isHost() and turretPredicate ~= nothing then
					--crap load of raycasts, so only done on host side and if a result hit occurs sync that
					for i = 1, SENTRY_YAW_CHECK_COUNT, 1 do
						for k =1, SENTRY_PITCH_CHECK_COUNT, 1 do
							--check block, then look for entity up to block
							local block, hitpos = raycast:block(cameraPos, cameraPos+vectors.angleToDir(sentryPitch+SENTRY_PITCH_CHECK_DEG*(k-(SENTRY_PITCH_CHECK_COUNT+1)/2), -sentryYaw+SENTRY_YAW_CHECK_DEG*(i-(SENTRY_YAW_CHECK_COUNT+1)/2))*SENTRY_RANGE)							
							local entity = raycast:entity(cameraPos, hitpos, turretPredicate)
							
							if debugOn then
								line(sentryPos+vec(0,0.8,0), hitpos, "R")
							end
							
							if entity then
								--got a hit, check if this should really be aquired
								if entity:isLiving() and entity:getDeathTime() == 0 then
									targetEntity = entity
									--sync it
									pings.aquire(client:uuidToIntArray(entity:getUUID()))
									break
								end
							end
							--get out
							if targetEntity then
								break
							end
						end
					end
				end
			end
		end
		
		--check if host player close enough
		local plrpos = player:getPos()
		local holoNear = math.sqrt((sentryPos.x-plrpos.x)^2+(sentryPos.y-plrpos.y)^2+(sentryPos.z-plrpos.z)^2) < 3

		if holoNear then
			--local buttonPos = models.model.World.SentryTurret.YawBearing.Mount.RearMount.ButtonPanel.Button:partToWorldMatrix():apply()
		
			--ray for pressin stuff, also a crap load of math and only the host can interact anyway
			if host:isHost() then
				buttonTargeted = nil
				
				for i = 1, 5, 1 do
					--save button size (1 pixel)
					local buttonSize = (1/16)
					
					--6th button slightly bigger
					if i == 6 then
						buttonSize = buttonSize*1.3
					end
					
					--find button pos and normal vector (direction vector pointed up from surface)
					local buttonPos = buttonIds[i]:partToWorldMatrix():apply()					
					local normal = vectors.angleToDir(25,-holoRot+180)
					
					--do some fancy math i barely understand
					local looking = rayDiskIntersection(buttonPos, normal, buttonSize, vec(plrpos.x, plrpos.y + player:getEyeHeight(), plrpos.z), player:getLookDir())
					
					--found the button host is looking at
					if looking then buttonTargeted = i; break end
				end
				
				--sync that button
				if buttonTargeted ~= syncedButtonTargeted then
					pings.setPredicate(buttonTargeted, predicateId)
				end
			end
			
			--hologram show
			if not models.model.World.SentryTurret.Hologram:getVisible() and not animations.model.Sentry_HoloAppear:isPlaying() then
				animations.model.Sentry_HoloAppear:play()
				sounds:playSound("minecraft:ui.toast.in", sentryPos)
				holoShow = true
			end	
		elseif holoShow and not animations.model.Sentry_HoloDisappear:isPlaying() then
			--far away, go home
			animations.model.Sentry_HoloDisappear:play()
			sounds:playSound("minecraft:ui.toast.out", sentryPos)
			holoShow = false
		end
		
		--point at host and smooth
		holoYaw = math.deg(math.atan2(sentryPos.x-plrpos.x, sentryPos.z-plrpos.z))+180		
		holoRotOld = holoRot
		
		--lerp, dont do if close enough (fixes some jank)
		if math.abs(holoRot-holoYaw) > 0.1 then
			holoRot = math.lerpAngle(holoRot, holoYaw, 0.2)
		end
		
		--muzzle flash hiding when not firing
		models.model.World.SentryTurret.YawBearing.Mount.PitchBearing.Gun.RightSide.RightBarrel.RightBarrelRing.RightMuzzleFlash:setVisible(animations.model.Sentry_FireRight:isPlaying())
		models.model.World.SentryTurret.YawBearing.Mount.PitchBearing.Gun.LeftSide.LeftBarrel.LeftBarrelRing.LeftMuzzleFlash:setVisible(animations.model.Sentry_FireLeft:isPlaying())
		
		--default values
		BUTTON_TEXT:setVisible(false)
		hostLookButton = false
		
		--find button pos and normal vector (direction vector pointed up from surface)
		local buttonPos = buttonIds[6]:partToWorldMatrix():apply()
		local buttonSize = (1/16)				
		local normal = vectors.angleToDir(90-15,-sentryYaw)
		
		--all other players pressing disable/enable button
		for k,interacter in pairs(world.getPlayers()) do
			
			--get pos, check if in range
			local pos = interacter:getPos()			
			if math.sqrt((sentryPos.x-pos.x)^2+(sentryPos.y-pos.y)^2+(sentryPos.z-pos.z)^2) < 3 then			
				
				--do some fancy math i barely understand
				local looking = rayDiskIntersection(buttonPos, normal, buttonSize, vec(pos.x, pos.y + interacter:getEyeHeight(), pos.z), interacter:getLookDir())
				
				if looking then
					--show interact prompt
					BUTTON_TEXT:setVisible(true)
					--if this is the host then save a value for canceling host inputs
					if interacter == player then
						hostLookButton = true
					elseif interacter:isUsingItem() or interacter:getSwingTime() == 1 then
						--otherwise for other players, check if they are interacting and sync the outcome
						animations.model.Sentry_ButtonPress:play()
						sentryEnabled = not sentryEnabled
						pings.sentryEnabled(sentryEnabled)
						
						--and also just do it locally in an attempt to fix bugs
						--adjusjt animations
						animations.model.Sentry_Idle:setPlaying(sentryEnabled)
						rareIdle:setEnabled(sentryEnabled and sentryActive)
						
						if sentryEnabled then
							BUTTON_TEXT:setText("Disable")
							animations.model.Sentry_Enable:play()
							animations.model.Sentry_Disable:stop()
							
							--play tone
							sequenceNo = 1
							sequenceTime = 7
						else
							BUTTON_TEXT:setText("Enable")
							animations.model.Sentry_Disable:play()
							
							--play tone
							sequenceNo = 2
							sequenceTime = 8
						end						
					end
				end				
			end
		end
		
	elseif sentryReturn and animations.model.Sentry_Compact:getTime() > 0.9 then
		--sentry flying towards host
		
		--get offset player pos
		local plrpos = player:getPos() + vec(0,1,0)
		
		--client only pathfinding where they blindly follow from host's pings
		if hostPingPathing then
		
			if sentryPathTicks == 2 then
				sentryPosOld = sentryPos
				--wait for next ping
			else		
				sentryPathTicks = sentryPathTicks+1
			end
		elseif path and pathLength ~= 0 then
			--manhatten distance pathfinding fly			
			if sentryPathTicks == 2 then
				
				--check LOS
				local dest = player:getPos() + vec(0,1,0)	
				local block, hitpos = raycast:block(sentryPos, dest)
				
				if hitpos == dest then
					--print("no more pathfinding")
					--got LOS, switch to eculidan fly		
					path = nil
					pings.noMorePingPathing()
					--save pos for smoothing
					sentryPosOld = sentryPos
					sentryPos = sentryPos + (sentryPos-plrpos):normalize()*-sentryspeed
				else
					local pos = path[pathLength]
					
					pings.syncSentryPos(pos.x,pos.y,pos.z)
					
					pathLength = pathLength-1
				
					sentryPathTicks = 0
				end
			end
			
			sentryPathTicks = sentryPathTicks+1			
		else
			--noclip euclidian fly			
			sentryPathTicks = 2
			
			if syncedPingPathing then
				--tell clients to simulate this themselves
				pings.noMorePingPathing()
			end
			
			--save pos for smoothing
			sentryPosOld = sentryPos
			sentryPos = sentryPos + (sentryPos-plrpos):normalize()*-sentryspeed
		end
		
		--accelerate
		if sentryspeed < 0.5 then
			sentryspeed = sentryspeed+0.05
		end
		
		--crappy visuals
		sounds:playSound("minecraft:block.metal.step", math.lerp(sentryPos, sentryPosOld, sentryPathTicks/2), 1, 1.2)
		particles:newParticle("minecraft:smoke", math.lerp(sentryPos, sentryPosOld, sentryPathTicks/2), vec(0,-0.1,0)):setColor(0.8,0.8,1)
		
		--reached player, disapear
		if math.sqrt((sentryPos.x-plrpos.x)^2+(sentryPos.y-plrpos.y)^2+(sentryPos.z-plrpos.z)^2) < 0.5 then
			models.model.World.SentryTurret:setVisible(false)
			sentryReturn = false
		end
	end
	
	--show/hide stuff
	models.model.World.SentryTurret.Hologram:setVisible(holoShow and animations.model.Sentry_HoloAppear:getTime() > 0.04 or (animations.model.Sentry_HoloDisappear:isPlaying() and animations.model.Sentry_HoloDisappear:getTime() < 0.29))	
	models.model.World.SentryTurret.ThrusterPlume:setVisible(sentryReturn and animations.model.Sentry_Compact:getTime() > 0.9)
	
	--tracer shrinking
	
	--shrink scale
	if tracerScale > 0 then
		tracerScale = tracerScale-0.2
	else
		models.model.World.SentryTurret.LaserPivot.LeftLaser:setScale(1,1,1)
		models.model.World.SentryTurret.LaserPivot.RightLaser:setScale(1,1,1)
	end
	
	--flipped, since leftSide is opposite of the side that just fired
	if not leftSide then
		models.model.World.SentryTurret.LaserPivot.LeftLaser:setScale(tracerScale, tracerScale, tracerLength)
	else
		models.model.World.SentryTurret.LaserPivot.RightLaser:setScale(tracerScale, tracerScale, tracerLength)
	end
	
	models.model.World.SentryTurret.LaserPivot.LeftLaser:setVisible(not leftSide and tracerScale > 0)
	models.model.World.SentryTurret.LaserPivot.RightLaser:setVisible(leftSide and tracerScale > 0)
	
	--casings
	--[[local casingPos = models.model.World.Casing:partToWorldMatrix():apply()
	
	local block, hitpos = raycast:block(casingPos, casingPos-vec(0,1/16,0))
	
	if hitpos then
		models
	end]]
	
	--drone
	
	droneTimer = droneTimer+1
	
	dronePosOld = dronePos

	--normal behaviour
	local targetPos = vec(0,0,0)
	local targetVel = vec(0,0,0)
	
	local acelleration = vec(0,0,0)
	
	local braking = false
	
	if droneWarpEffect > 0 then
		droneWarpEffect = droneWarpEffect-1
	end
	
	--check if target still alive
	if droneTarget then
		if not droneTarget:isLiving() or droneTarget:getDeathTime() ~= 0 then
			droneTarget = nil
		end
	end
	
	if droneTarget then	
		targetPos = droneTarget:getPos()+vec(0,2,0)
		targetVel = droneTarget:getVelocity()
	else			
		targetPos = player:getPos()+vec(0,2,0)
		targetVel = player:getVelocity()
	end
	
	local punched = false
	
	--drone punching
	for k,interacter in pairs(world.getPlayers()) do
		if interacter:getSwingTime() == 1 then
			local pos = interacter:getPos()
			
			--pointMarker(dronePos)
			
			if intersectBox(vec(pos.x, pos.y + interacter:getEyeHeight(), pos.z), interacter:getLookDir(), dronePos, vec(-6/16,-1/16,-6/16),  vec(6/16,5/16,6/16), 5) then
				--pow
				--print("ouch")
				
				sounds:playSound("minecraft:entity.armor_stand.break", dronePos, 0.5, 1.2)
				
				droneSpeed = droneSpeed + interacter:getLookDir()*0.4				
				acelleration = interacter:getLookDir()*0.4
			end
		end
	end
	
	if not punched then	
		local targetDist = math.sqrt((dronePos.x-targetPos.x)^2+(dronePos.y-targetPos.y)^2+(dronePos.z-targetPos.z)^2)
		
		if targetDist > 16 then
			--warp
			dronePos = targetPos-(dronePos-targetPos):normalize()*-5
			droneSpeed = (dronePos-targetPos):normalize()*-DRONE_MAX_SPEED*2 + targetVel*0.9
			
			sounds:playSound("entity.fox.teleport", dronePos, 0.5, 1.1)
			
			particles:newParticle("minecraft:dragon_breath", dronePos, droneSpeed/3)
			particles:newParticle("minecraft:dragon_breath", dronePos, droneSpeed/3)
			particles:newParticle("minecraft:dragon_breath", dronePos, droneSpeed/2.8)
			particles:newParticle("minecraft:dragon_breath", dronePos, droneSpeed/2.6)
			particles:newParticle("minecraft:dragon_breath", dronePos)
			
			droneWarpEffect = 8
		elseif targetDist > 1.5 or math.abs(targetPos.y-dronePos.y) > 0.5 then
			if droneSpeed:length() < DRONE_MAX_SPEED then
				--accelerate
				acelleration = (dronePos-targetPos):normalize()*-(DRONE_ACCEL* (targetDist < 5 and targetDist/6 or 1))
				
				droneSpeed = droneSpeed+acelleration
			end
		else
			acelleration = droneSpeed*-DRONE_ACCEL*1.2
			
			--brake
			droneSpeed = droneSpeed+acelleration
			braking = true
		end
	end
	
	--air friction
	droneSpeed = droneSpeed*0.95
	
	--max speed
	--[[if droneSpeed:length() > DRONE_MAX_SPEED then
		droneSpeed = droneSpeed:normalize()*DRONE_MAX_SPEED
	end]]
	
	--apply speed
	dronePos = dronePos+droneSpeed
	
	if droneTimer > DRONE_INTER_TIME+20 then
		--tried 20 times to find a target without luck, give up for a bit
		droneTimer = 0
	elseif droneTimer >= DRONE_INTER_TIME then
		--change mode
		if not droneTarget then
			local raystart
			local rayend
		
			local entity
		
			if host:isHost() then
				if droneTimer == DRONE_INTER_TIME then
					--first cast in player look dir
					raystart = player:getPos() + vec(0,player:getEyeHeight(),0)
					rayend = raystart+player:getLookDir()*16
					
					local block, hitpos = raycast:block(raystart, rayend)
					
					if debugOn then
						line(raystart, hitpos, "cyan")
					end
					
					entity = raycast:entity(raystart, hitpos, noOwner)
				else
					--boat load of raycasts, so host only
					--if host:isHost()
					local casts = 0
					repeat
						raystart = dronePos
						rayend = raystart+vectors.angleToDir(sentryPitch+DRONE_RAYCAST_DEG*(casts-(DRONE_RAYCAST_COUNT+1)/2), math.map(droneTimer-DRONE_INTER_TIME, 0, 20, 0, 360))*16
						
						local block, hitpos = raycast:block(raystart, rayend)
						
						if debugOn then
							line(raystart, hitpos, "cyan")
						end
						
						entity = raycast:entity(raystart, hitpos, noOwner)
						
						if entity then
							break
						end
						
						casts = casts+1
					until casts > DRONE_RAYCAST_COUNT
				end
				if entity then
					pings.syncDrone(client:uuidToIntArray(entity:getUUID()))
					droneTarget = entity
					droneTimer = 0
				end
			end
		else
			droneTarget = nil
			droneTimer = 0
		end
	end
	
	local targetDroneRot = droneRot
	
	if droneSpeed:length() > 0.02 then
		targetDroneRot = math.deg(math.atan2(droneSpeed.x, droneSpeed.z)) + 180
	end
	
	--look at thingies
	local yaw
	
	local pitch
	
	if droneTarget then
		local targetPos = droneTarget:getPos()
		yaw = math.deg(math.atan2(dronePos.x-targetPos.x, dronePos.z-targetPos.z))+180
		pitch = math.deg(math.atan2(math.sqrt((dronePos.x-targetPos.x)^2+(dronePos.z-targetPos.z)^2), dronePos.y-targetPos.y))-90
	else
		yaw = math.deg(math.atan2(player:getLookDir().x, player:getLookDir().z))		
		pitch = player:getLookDir().y*90
	end
		
		local yawPoint = yaw+180-droneRot
		
		local yawCheck = math.abs(yawPoint)
		
		if yawCheck > 35 and yawCheck < 360-35 then
			if droneSpeed:length() <= 0.02 then
				targetDroneRot = yaw+180
			end
			
			if debugOn then
				line(dronePos, dronePos+vectors.angleToDir(0, -targetDroneRot+180))
			end
			
			--yaw = math.clamp(yaw, -45, 45)			
		end
		
		--dont turn head much if its too far
		
		if math.abs(yawPoint) > 45 and math.abs(yawPoint) < 360-45 then
			yawPoint = math.clamp(yawPoint, -5, 5)
		end
		
		pitch = math.clamp(pitch, -45, 45)
		
		models.model.World.Drone.DroneBody.DroneHead:setRot(pitch,yawPoint,0)
	
	--visuals
	oldDroneRot = droneRot
	
	if math.abs(targetDroneRot-droneRot) > 0.1 then
		droneRot = math.lerpAngle(droneRot, targetDroneRot, 0.2)
	end
	
	oldThrusterRot = thrusterRot
	
	thrusterRot = droneSpeed:length()*(braking and 80 or -60)
	
	thrusterRot = math.clamp(thrusterRot, -45,45)
	
	models.model.World.Drone.DroneBody.warpeffect:setScale(droneWarpEffect/8)
	
	--periodic sync
	
	if world.getTime()%100 == 0 then
		if sentryActive then
			local sentryPredicateID = turretPredicate == nothing and 1 or turretPredicate == noPlayer and 2 or turretPredicate == noOwner and 3 or turretPredicate == anyLiving and 4
		
			pings.syncStuff(sentryActive, sentryEnabled, rangefinder, sentryYaw, math.floor(sentryPos.x), math.floor(sentryPos.y), math.floor(sentryPos.z),  sentryPredicateID)
		else
			pings.syncStuff(sentryActive, sentryEnabled, rangefinder)
		end
		
		if dartPosA or dartPosB or dartPosC then
			pings.dartSync(dartDimA, dartPosA, models.model.World.DartAlpha:getRot(), dartDimB, dartPosB, models.model.World.DartBeta:getRot(), dartDimC, dartPosC, models.model.World.DartGamma:getRot())
		end
	end
	
end

function events.render(delta, context)
	
	--arm n rangefinder
	models.model.root.RightArmFirstPerson:setVisible(context == "FIRST_PERSON")
	models.model.root.LeftArmFirstPerson:setVisible(context == "FIRST_PERSON")
	models.model.root.RightArmFirstPerson.Arm:setVisible(not rangefinder)
	models.model.root.LeftArmFirstPerson.Arm2:setVisible(not rangefinder)
	models.model.root.RightArmFirstPerson.RangefinderFirst:setVisible(rangefinder and not player:isLeftHanded())
	models.model.root.LeftArmFirstPerson.RangefinderFirstLeft:setVisible(rangefinder and player:isLeftHanded())
	models.model.root.Body.RightArm.RangefinderArm:setVisible(rangefinder and not player:isLeftHanded())
	models.model.root.Body.LeftArm.RangefinderArmLeft:setVisible(rangefinder and player:isLeftHanded())

	--tilting	
	models.model.root:setRot(math.lerpAngle(bodyPitchOld*0.25, bodyPitch*0.25, delta),0,math.lerpAngle(bodyRollOld*0.25, bodyRoll*0.25, delta))	
	
	models.model.root.Body:setRot(math.lerpAngle(bodyPitchOld*0.75, bodyPitch*0.75, delta),0,math.lerpAngle(bodyRollOld*0.75, bodyRoll*0.75, delta))	
	models.model.root.Body._HeadMount.Head:setRot(math.lerpAngle(-bodyPitchOld, -bodyPitch, delta),0,math.lerpAngle(-bodyRollOld, -bodyRoll, delta))
	
	models.model.root.Body.RightArm:setRot(0,0,math.lerpAngle(armSpreadOld, armSpread, delta))
	models.model.root.Body.LeftArm:setRot(0,0,math.lerpAngle(-armSpreadOld, -armSpread, delta))
	
	--fix crouching pose
	animations.model.crouch:setPlaying(player:getPose() == "CROUCHING")
	
	models.model.root.Body.RightArm:setOffsetRot(player:getPose() == "CROUCHING" and vec(30,0,0) or vec(0,0,0))
	models.model.root.Body.LeftArm:setOffsetRot(player:getPose() == "CROUCHING" and vec(30,0,0) or vec(0,0,0))
	
	--hide crossbow bolt
	models.model.ItemCrossbow.Connector.Bolt:setVisible(crossbowHandle.state ~= 1)
	
	--backpack
	models.model.root.Body.Backpack.Top:setRot((HoloMenu and not animations.model.HoloMenu_Disapear:isPlaying() and not animations.model.HoloMenu_Appear:isPlaying()) and 0,0,0)
	
	if rangefinder then
		--rangefinder dart markers
		models.model.World.MarkerAlpha:setPos(math.lerp(markAPosOld, markAPos, delta)):setRot(math.lerpAngle(markARotOld, markARot, delta))
		models.model.World.MarkerBeta:setPos(math.lerp(markBPosOld, markBPos, delta)):setRot(math.lerpAngle(markBRotOld, markBRot, delta))
		models.model.World.MarkerGamma:setPos(math.lerp(markCPosOld, markCPos, delta)):setRot(math.lerpAngle(markCRotOld, markCRot, delta))
		
		if player:isLeftHanded() then
			models.model.root.Body.LeftArm:setOffsetRot(vanilla_model.HEAD:getOriginRot())
		else
			models.model.root.Body.RightArm:setOffsetRot(vanilla_model.HEAD:getOriginRot())
		end
	end
	
	if sentryActive then
		--sentry smoothing	
		if sentryEnabled and animations.model.Sentry_Deploy:isStopped() then			
			models.model.World.SentryTurret.YawBearing:setRot(0,math.lerpAngle(sentryYawOld, sentryYaw, delta),0)
			models.model.World.SentryTurret.YawBearing.Mount.PitchBearing:setRot(math.lerpAngle(sentryPitchOld, sentryPitch, delta),0,0)
		end
		
		models.model.World.SentryTurret.Hologram:setOffsetRot(0,math.lerpAngle(holoRotOld, holoRot, delta),0)
		
		--electricity
		models.model.World.SentryTurret.YawBearing.Mount.PitchBearing.Gun.RightSide.RightVents.electric:setUVPixels(math.random(0,10), math.random(0,11)):setOffsetRot(math.random(-45,45),math.random(-45,45),math.random(-45,45)):setScale(math.random(0.8,1.2))
		models.model.World.SentryTurret.YawBearing.Mount.PitchBearing.Gun.LeftSide.LeftVents.electric:setUVPixels(math.random(0,10), math.random(0,11)):setOffsetRot(math.random(-45,45),math.random(-45,45),math.random(-45,45)):setScale(math.random(0.8,1.2))
		
	elseif sentryReturn and animations.model.Sentry_Compact:getTime() > 0.9 then
		if pathLength ~= 0 then
			models.model.World.SentryTurret:setPos(math.lerp(sentryPosOld*16, sentryPos*16, (delta+sentryPathTicks)/2))
		else
			models.model.World.SentryTurret:setPos(math.lerp(sentryPosOld*16, sentryPos*16, delta))
		end
	end
	
	--drone
	models.model.World.Drone:setPos(math.lerp(dronePosOld*16, dronePos*16, delta))
	
	models.model.World.Drone.DroneBody:setRot(0,math.lerpAngle(oldDroneRot, droneRot, delta),0)
	
	--thruster pulsing
	models.model.World.Drone.DroneBody.DroneThrusterFR.plume:setScale(sinWave(3, 0.1, delta)+1)
	models.model.World.Drone.DroneBody.DroneThrusterFL.plume:setScale(sinWave(3, 0.1, delta)+1)
	models.model.World.Drone.DroneBody.DroneThrusterBR.plume:setScale(sinWave(3, 0.1, delta)+1)
	models.model.World.Drone.DroneBody.DroneThrusterBL.plume:setScale(sinWave(3, 0.1, delta)+1)
	
	--only lerp if big enough diffrence, fixes some jank	
	if math.abs(oldThrusterRot-thrusterRot) > 0.01 then
		models.model.World.Drone.DroneBody.antenna:setOffsetRot(math.lerpAngle(-oldThrusterRot, -thrusterRot, delta), 0,0)
		models.model.World.Drone.DroneBody.DroneThrusterFR:setRot(math.lerpAngle(oldThrusterRot, thrusterRot, delta), 0, 0)
		models.model.World.Drone.DroneBody.DroneThrusterFL:setRot(math.lerpAngle(oldThrusterRot, thrusterRot, delta), 0, 0)
		models.model.World.Drone.DroneBody.DroneThrusterBR:setRot(math.lerpAngle(oldThrusterRot, thrusterRot, delta), 0, 0)
		models.model.World.Drone.DroneBody.DroneThrusterBL:setRot(math.lerpAngle(oldThrusterRot, thrusterRot, delta), 0, 0)
	end
end

function events.item_render(item)
	if item.id:find("crossbow") then
		return models.model.ItemCrossbow
	end
end

function events.mouse_press(button, action, modifier)
	if action_wheel:isEnabled() then return end
	
	--if left/right presses
	if (button == 0 or button == 1) and action == 1 then
		--do action based on previously calculated looked at button
		if buttonTargeted then
			if buttonTargeted == 1 then
				turretPredicate = nothing
				predicateId = buttonTargeted
			elseif buttonTargeted == 2 then
				turretPredicate = noPlayer
				predicateId = buttonTargeted
			elseif buttonTargeted == 3 then
				turretPredicate = noOwner
				predicateId = buttonTargeted
			elseif buttonTargeted == 4 then
				turretPredicate = anyLiving
				predicateId = buttonTargeted
			else
				animations.model.Sentry_ButtonPress:play()
				pings.sentry(false)
				deployAction:setToggled(false)
				buttonTargeted = nil
			end
			pings.setPredicate(buttonTargeted, predicateId, true)
			return true
		elseif hostLookButton then
			--this is that one button that anyone could press but special case for host
			animations.model.Sentry_ButtonPress:play()
			sentryEnabled = not sentryEnabled
			pings.sentryEnabled(sentryEnabled)
			return true
		end
	end
end

--turret predicates
function nothing()
	return false
end

function noPlayer(entity)
	return not entity:isPlayer() and entity:isLiving()
end

function noOwner(entity)
	return entity ~= player and entity:isLiving()
end

function anyLiving(entity)
	return entity:isLiving()
end

--basic time based sine wave
function sinWave(period, intensity, delta)
	const = const or 0

	return math.sin(world:getTime(delta)/period)*intensity
end

-- i have no clue how this formula works but it seems to do what i want so thats cool
function rayDiskIntersection(pos, normal, size, origin, dir)
	--getting the uhm uhh the thing
	denom = normal:dot(dir)
	if denom > 0.001 then	
		local t = (pos - origin):dot(normal)/denom
		
		--doing the errr
		if t >= 0 then
			local v = origin+dir*t - pos
			local dsq = v:dot(v)
			
			--checking if they intersect
			return dsq <= size^2
		end
	end
	
	return false
end

local neighbors = {
	vec(1,0,0),
	vec(0,1,0),
	vec(0,0,1),
	vec(-1,0,0),
	vec(0,-1,0),
	vec(0,0,-1),
	
	--[[vec(1,1,0),
	vec(1,-1,0),
	vec(1,0,1),
	vec(1,0,-1),	
	vec(0,1,1),
	vec(0,1,-1),
	vec(0,-1,1),
	vec(0,-1,-1),
	vec(-1,1,0),
	vec(-1,-1,0),
	vec(-1,0,1),
	vec(-1,0,-1),
	
	vec(1,1,1),
	vec(1,1,-1),
	vec(1,-1,1),
	vec(1,-1,-1),
	vec(-1,1,1),
	vec(-1,1,-1),
	vec(-1,-1,1),
	vec(-1,-1,-1)]]
}

function a_star(start, goal)
	function h(pos) --manhatten distance between pos and goal, weighted a bit with euclidian distance
		--return math.sqrt((pos.x-goal.x)^2+(pos.y-goal.y)^2+(pos.z-goal.z)^2)
		return math.abs(pos.x-goal.x) + math.abs(pos.y-goal.y) + math.abs(pos.z-goal.z) 
		--return math.max(math.abs(pos.x-goal.x), math.abs(pos.y-goal.y), math.abs(pos.z-goal.z))
	end
	
	path = nil
	pathLength = 0
	
	local done = false

	local openSetCount = 1

	local openSet = {start}
	local cameFrom = {}
	
	local checked = {}
	checkedCount = 0
	
	local gScores = {}
	gScores[start] = 0
	
	local fScores = {}
	fScores[start] = h(start)
	
	local iterations = 0
	
	while openSetCount ~= 0 do
		--find pos in openSet with the lowest fscore
		local current
		local lowestScore = math.huge
		local lowestIndex
		
		for i,v in pairs(openSet) do
			if fScores[v] < lowestScore then
				lowestScore = fScores[v]
				current = v
				lowestIndex = i
			end
		end
		if current == goal then
			--we did it!
			reconstruct_path(cameFrom, current)
			done = true
			break
		end
		
		if lowestIndex == nil then
			if debugOn then print("pathfinding error") end
			break
		end
		
		--remove from set
		openSet[lowestIndex] = nil
		openSetCount = openSetCount-1
		--table.remove(openSet, current)
		if debugOn then
			pointMarker(current+vec(0.5,0.5,0.5), "purple", 100)
		end
		
		checked[checkedCount+1] = current
		checkedCount = checkedCount+1
		
		--for each neigbor
		for i,v in ipairs(neighbors) do
			local neighbor = current+v
			
			if neighbor ~= cameFrom[current] then
				local wasChecked = false
				for i,v in ipairs(checked) do
					if neighbor == v then
						wasChecked = true
						break
					end
				end
				
				if not wasChecked then
					local block = world.getBlockState(neighbor)
					--block bust be clear to be valid
					if not block:hasCollision() then
						local tentative_gScore = gScores[current] + 1 
						if tentative_gScore < (gScores[neighbor] or math.huge) then
							cameFrom[neighbor] = current
							gScores[neighbor] = tentative_gScore
							fScores[neighbor] = tentative_gScore + h(neighbor)
							
							local inSet = false
							
							for k,v in pairs(openSet) do
								if v == neighbor then
									inSet = true
									break
								end
							end
							
							if not inSet then
								openSet[openSetCount+1] = neighbor
								openSetCount = openSetCount+1
							end
						end
					end
				end
			end
		end
		iterations = iterations+1
		if iterations > SENTRY_PATHFINDING_MAX_ITERATIONS then
			--abort
			if debugOn then
				print("Aborted pathfinding, too many iterations")
			end
			
			--get the best scoring
			lowestScore = math.huge
			
			for i,v in pairs(openSet) do
				if fScores[v] < lowestScore then
					lowestScore = fScores[v]
					current = v
				end
			end
			
			reconstruct_path(cameFrom, current) --just do something idk
			break
		end
		if done then
			break
		end
	end
end

--table indexed with positons that go to the next pos
path = nil
pathLength = 0

function reconstruct_path(cameFrom, goal)	
	local currentpos = goal

	local iterations = 0
	
	local renderoffset = vec(0.5,0.5,0.5)
	
	path = {}
	
	--logTable(cameFrom)
	--[[for i,v in pairs(cameFrom) do
		line(i+renderoffset, v+renderoffset, "purple", 2, 50)
		iterations = iterations+1
		if iterations > 128 then
			print("Aborted tabledrawing, too many iterations")
			break
		end
	end]]
	
	iterations = 0
	
	repeat
		local prevpos = cameFrom[currentpos]
		
		if prevpos then
			path[pathLength+1] = currentpos
			pathLength = pathLength+1
			if debugOn then
				line(prevpos+renderoffset, currentpos+renderoffset, "cyan", 2, 200)
			end
			currentpos = prevpos
		else
			break
		end
		iterations = iterations+1
		if iterations > SENTRY_PATHFINDING_MAX_ITERATIONS then
			print("Aborted pathdrawing, too many iterations")
			break
		end
	until iterations > 64
end

-- Code Snippets: Debug point/line drawing - mrsirsquishy (MODIFED)
function pointMarker(pos, color, lifetime)
    if type(color) == "string" then
        if        color == "R" then color = vec(1, 0, 0) 
        elseif color == "G" then color = vec(0, 1, 0) 
        elseif color == "B" then color = vec(0, 0, 1) 
        elseif color == "yellow" then color = vec(1, 1, 0) 
        elseif color == "purple" then color = vec(1, 0, 1) 
        elseif color == "cyan" then color = vec(0, 1, 1) 
        elseif color == "black" then color = vec(0, 0, 0) 
        else
            color = vec(1,1,1)
        end
    else
        color = color or vec(1,1,1)
    end
    particles:newParticle("minecraft:wax_off", pos):setSize(0.5):setLifetime(lifetime):setColor(color)
end
--draws a line between two points with particles, higher density is more particles
function line(corner1, corner2, color, density, lifetime)
	local l = (corner2 - corner1):length() -- Length of the line
    local direction = (corner2 - corner1):normalize() -- Direction vector
    local density = density or 5

    for i = 0, l, 1/density do
        local pos = corner1 + direction * i -- Interpolate position
        pointMarker(pos, color, lifetime) -- Create a particle at the interpolated position
    end
end

--Hellp-Discussion:	 Ray-box intersection - 4p5 (MODIFIED)
local max, min = math.max, math.min
---@param ray_pos Vector3
---@param ray_dir Vector3
---@param box_pos Vector3
---@param box_min Vector3
---@param box_max Vector3
---@return boolean intersected, Vector3? intersection_point
function intersectBox(ray_pos, ray_dir, box_pos, box_min, box_max, max_dist)
    local x1, y1, z1 = (box_pos:copy():add(box_min):sub(ray_pos)):div(ray_dir):unpack()
    local x2, y2, z2 = (box_pos:copy():add(box_max):sub(ray_pos)):div(ray_dir):unpack()
    local tmin = max(min(x1, x2), min(y1, y2), min(z1, z2))
    local tmax = min(max(x1, x2), max(y1, y2), max(z1, z2))	
	
    if tmax < 0 or tmin > tmax  then return false end	
	if max_dist then
		if tmin > max_dist then return false end
	end	
    return true, ray_pos:copy():add(ray_dir:copy():mul(tmin)), tmin
end


mainPage:newAction()
   :title("toggle drone")
   :toggleTitle("untoggle drone")
   :item("elytra")
   :setOnToggle(function(state)
    if state then
		models.model.World.Drone:setVisible(true)
    else
      models.model.World.Drone:setVisible(false)
    end
    
  end)