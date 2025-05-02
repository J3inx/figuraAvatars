local earsPhysics = {} -- made by Auriafoxgirl
---@class auria.earsPhysics
---@field config table
---@field leftEar ModelPart
---@field rightEar ModelPart
local ears = {}
local updatingEars = {}
ears.__index = ears
local oldPlayerRot

-- Utility: Clamp a vector between min and max vectors
local function clampVec3(vecToClamp, minVec, maxVec)
   return vec(
      math.clamp(vecToClamp.x, minVec.x, maxVec.x),
      math.clamp(vecToClamp.y, minVec.y, maxVec.y),
      math.clamp(vecToClamp.z, minVec.z, maxVec.z),
      math.clamp(vecToClamp.w, minVec.z, maxVec.z) -- use Z min/max for W
   )
end

---creates new ears physics
---@param leftEar ModelPart
---@param rightEar ModelPart
function earsPhysics.new(leftEar, rightEar)
   local obj = setmetatable({}, ears)
   obj.config = { -- default config, please use ears:setConfig to set config, dont edit this table
      velocityStrength = 1,
      headRotStrength = 0.4,
      lockXYRot = false,
      bounce = 0.2,
      stiff = 0.3,
      extraAngle = 15,
      useExtraAngle = {},
      addAngle = {},
      earsFlick = true,
      flickChance = 400,
      flickDelay = 40,
      flickStrength = 30,
      rotMin = vec(-12, -8, -4),
      rotMax = vec(12, 8, 6),
      headRotMin = -90,
      headRotMax = 90,
      disableHeadPitch = false,
      disableHeadYaw = false,
      rotationAxis = "XYZ",
      reverseRotation = false -- NEW CONFIG FIELD
   }
   obj.leftEar = leftEar
   obj.rightEar = rightEar
   obj.rot = vec(0, 0, 0, 0)
   obj.oldRot = obj.rot
   obj.vel = vec(0, 0, 0, 0)
   obj.flickTime = 0
   updatingEars[obj] = obj
   return obj
end

function ears:setConfig(tbl)
   for i, v in pairs(tbl) do
      self.config[i] = v
   end
   return self
end

function ears:setUpdate(x)
   updatingEars[self] = x and self or nil
   return self
end

function ears:remove(keepRot)
   if not keepRot then
      self.leftEar:setOffsetRot()
      self.rightEar:setOffsetRot()
   end
   updatingEars[self] = nil
end

local function tickEars(obj, playerVel, playerRotVel, isCrouching, playerRot)
   obj.oldRot = obj.rot
   local targetRotZW = 0
   if isCrouching then
      targetRotZW = obj.config.extraAngle
   else
      for _, v in pairs(obj.config.useExtraAngle) do
         if v then
            targetRotZW = obj.config.extraAngle
            break
         end
      end
   end
   for _, v in pairs(obj.config.addAngle) do
      targetRotZW = targetRotZW + v
   end
   local pitch = obj.config.disableHeadPitch and 0 or math.clamp(
      obj.config.headRotStrength * -playerRot.x,
      obj.config.headRotMin,
      obj.config.headRotMax
   )
   local targetRot = vec(pitch, 0, targetRotZW, -targetRotZW)

   playerVel = playerVel * obj.config.velocityStrength * 60
   playerRotVel = playerRotVel * obj.config.velocityStrength
   local finalVel = vec(
      math.clamp(playerVel.z + playerRotVel.x, obj.config.rotMin.x, obj.config.rotMax.x),
      math.clamp(playerVel.x, obj.config.rotMin.y, obj.config.rotMax.y),
      math.clamp(playerVel.y * 0.25, obj.config.rotMin.z, obj.config.rotMax.z)
   )
   obj.vel = obj.vel * (1 - obj.config.stiff) + (targetRot - obj.rot) * obj.config.bounce
   obj.rot = obj.rot + obj.vel
   obj.rot.x = obj.rot.x + finalVel.x
   obj.rot.z = obj.rot.z - finalVel.y + finalVel.z
   obj.rot.w = obj.rot.w - finalVel.y - finalVel.z

   obj.rot = clampVec3(obj.rot, obj.config.rotMin, obj.config.rotMax)

   obj.flickTime = math.max(obj.flickTime - 1, 0)
   if obj.config.earsFlick and obj.flickTime == 0 and math.random(math.max(obj.config.flickChance, 1)) == 1 then
      obj.flickTime = obj.config.flickDelay
      if math.random() > 0.5 then
         obj.vel.z = obj.vel.z + obj.config.flickStrength
      else
         obj.vel.w = obj.vel.w - obj.config.flickStrength
      end
   end

   if obj.config.lockXYRot then
      obj.rot.x = 0
      obj.rot.y = 0
   end
end

function events.tick()
   if not next(updatingEars) then return end
   local playerRot = player:getRot()
   if not oldPlayerRot then
      oldPlayerRot = playerRot
   end
   local playerRotVel = (playerRot - oldPlayerRot) * 0.75
   oldPlayerRot = playerRot
   local playerVel = player:getVelocity()
   for _, obj in pairs(updatingEars) do
      local vel = playerVel
      if not obj.config.disableHeadYaw then
         vel = vectors.rotateAroundAxis(playerRot.y, vel, vec(0, 1, 0))
      end
      if not obj.config.disableHeadPitch then
         vel = vectors.rotateAroundAxis(-playerRot.x, vel, vec(1, 0, 0))
      end
      tickEars(obj, vel, playerRotVel, isCrouching, playerRot)
   end
end

function events.render(delta)
   for _, obj in pairs(updatingEars) do
      local rot = math.lerp(obj.oldRot, obj.rot, delta)

      if obj.config.reverseRotation then
         rot = -rot
      end

      local axis = obj.config.rotationAxis
      local x, y, z = rot.x, rot.y, rot.z
      local w = rot.w

      if axis == "YXZ" then
         obj.leftEar:setOffsetRot(y, x, z)
         obj.rightEar:setOffsetRot(-y, -x, -z)
      elseif axis == "ZXY" then
         obj.leftEar:setOffsetRot(z, x, y)
         obj.rightEar:setOffsetRot(-z, -x, -y)
      elseif axis == "-YXZ" then
         obj.leftEar:setOffsetRot(-z, x, y)
         obj.rightEar:setOffsetRot(z, -x, -y)
      elseif axis == "XZY" then
         obj.leftEar:setOffsetRot(x, z, y)
         obj.rightEar:setOffsetRot(-x, -z, -y)
      elseif axis == "-XZY" then
         obj.leftEar:setOffsetRot(-x, z, y)
         obj.rightEar:setOffsetRot(-x, -z, -y)
      elseif axis == "YZX" then
         obj.leftEar:setOffsetRot(y, z, x)
         obj.rightEar:setOffsetRot(-y, -z, -x)
      elseif axis == "ZYX" then
         obj.leftEar:setOffsetRot(z, y, x)
         obj.rightEar:setOffsetRot(-z, -y, -x)
      elseif axis == "-ZXY" then
         obj.leftEar:setOffsetRot(-z, x, y)
         obj.rightEar:setOffsetRot(z, -x, -y)
      elseif axis == "-XYZ" then
         obj.leftEar:setOffsetRot(vec(x, y, z))
         obj.rightEar:setOffsetRot(vec(-x, -y, -z))
      else
         obj.leftEar:setOffsetRot(vec(-x, -y, -z))
         obj.rightEar:setOffsetRot(vec(x, y, z))
      end
   end
end

return earsPhysics
