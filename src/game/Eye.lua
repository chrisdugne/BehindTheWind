-----------------------------------------------------------------------------------------

Eye = {}	

-----------------------------------------------------------------------------------------

local eyeSheetconfig 	= require("src.game.graphics.EyeBad")
local eyeImageSheet 		= graphics.newImageSheet( "assets/images/game/eyeBad.png", eyeSheetconfig.sheet )

-----------------------------------------------------------------------------------------

function Eye:new()  

	local object = {
		RADIUS = 35,
		
		sprite 			= nil,
		timeLastThrow 	= 0,
	}

	setmetatable(object, { __index = Eye })
	return object
end

-----------------------------------------------------------------------------------------
-- sprite.x, sprite.y : coordonnees dans le monde, dans la camera
-- screenX, screenY : coordonnees a lecran, pour les touches

function Eye:screenX()
	return sprite.x*game.zoom
end

function Eye:screenY()
	return sprite.y*game.zoom
end

-------------------------------------

function Eye:init(x,y)

   ---------------------------

   self.previousVy = 0

   ---------------------------

--   self.sprite = display.newSprite( game.camera, eyeImageSheet, eyeSheetconfig.sequence )
	self.sprite = display.newImage( game.camera, "assets/images/game/enemy.eye.png")
	
   self.sprite:scale(0.3,0.3)
   self.sprite.x = x
   self.sprite.y = y

   self.sprite.isEnemy = true
   
   physics.addBody( self.sprite, "static", { 
   	density = 5, 
   	friction = 1, 
   	bounce = 0.2,
   	radius = self.RADIUS
   })

   ---------------------------
   
   self.sprite.isFixedRotation = true
	self.sprite:addEventListener( "collision", function(event) self:collide(event) end )
	self.sprite:addEventListener( "preCollision", function(event) self:preCollide(event) end )

   ---------------------------
   
end	

function Eye:initBackgroundEye(x,y)
	self.sprite = display.newImage(  "assets/images/game/eye.blur.png" )
   self.sprite.x = x
   self.sprite.y = y
   self.isBackground = true
end	


function Eye:destroy()
	utils.destroyFromDisplay(self.sprite)
end

-------------------------------------

function Eye:refresh()

--   if(self.sprite.x < character.sprite.x) then
--   	self:lookRight()
--   else
--   	self:lookLeft()
--   end

	local a, b, direction
		
	a	= vector2D:new(self.sprite.x,self.sprite.y)
	b 	= vector2D:new(character.sprite.x, character.sprite.y)
	direction = vector2D:Sub(b, a)
	
	self.direction = direction
	
	local c = direction.x/direction:magnitude()
	local s = direction.y/direction:magnitude()
	
	local alpha = math.deg(math.atan2(s,c))

--	if 70 <= alpha and alpha < 110 then
--      self.sprite:setFrame(1)
--	elseif 70 <= alpha and alpha < 90 then
--      self.sprite:setFrame(2)
--	elseif -20 <= alpha and alpha < 20 then
--      self.sprite:setFrame(3)
--	end

	self.sprite.rotation = alpha - 90

	local now = system.getTimer()
   if(now - self.timeLastThrow > 2000) then
		self.timeLastThrow = now
   	self:throw()
   end
end

-------------------------------------

function Eye:preCollide(event)
	if(event.contact) then
	 	if(event.other.isSensor) then
			event.contact.isEnabled = false
		end
   end
end

-------------------------------------
 
function Eye:collide( event )
	
	if(event.other.isRock) then return end
	if(event.other.isGrab) then return end
	if(event.other.isSensor) then return end
	if(event.other.isAttach) then print("collide with attach") return end
	
end

-------------------------------------

function Eye:throw()
	physicsManager.eyeThrow(self)
end

------------------------------------------

return Eye