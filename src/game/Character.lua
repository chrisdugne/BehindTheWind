-------------------------------------

module(..., package.seeall)

-------------------------------------

local CHARACTER_SPEED = 138
local JUMP_SPEED = -267

local DENSITY 			= 20
local FRICTION 		= 1
local BOUNCE 			= 0.15
local RADIUS 			= 16

local HANGING_FORCE = 100

NOT_MOVING 	= 0
GOING_LEFT 	= 1
GOING_RIGHT = 2
OUT		 	= 100

-------------------------------------

state = NOT_MOVING

-------------------------------------

floor 			= nil
collideOnLeft 	= nil
collideOnRight = nil

sprite 			= nil
ropes				= nil

timeLeavingFloor	= 0
leavingFloor 	= nil

timeLastThrow	= 0

jumping 	= false 
hanging 	= false 

throwFire = false 
throwGrab = false

grabs 	 = 0 -- nb de grappins lancés -- deprecated

-------------------------------------

local previousVy = 0
local nbFramesToKeep = 0

-------------------------------------

local playerWalk = require("src.game.graphics.Character")
local playerSheet = graphics.newImageSheet( "assets/images/game/character.png", playerWalk.sheet )

-------------------------------------
-- sprite.x, sprite.y : coordonnees dans le monde, dans la camera
-- screenX, screenY : coordonnees a lecran, pour les touches

function screenX()
	return sprite.x*game.zoom
end

function screenY()
	return sprite.y*game.zoom
end

-------------------------------------

function exit(completeExit)
	
	state = OUT 
	
	if(#ropes > 0) then
		timer.performWithDelay(500, function()
      	physicsManager.detachAllRopes()
		end) 
	end
	 
	sprite:setLinearVelocity(0,0)
	transition.to( sprite, { time=100, alpha=0, onComplete=completeExit})
end

-------------------------------------

function init()

   ---------------------------
	
	state = NOT_MOVING
	ropes = {}
   grabs	= 0  --> pas dans le resetState, puisquil peut y avoir un grab raté en cours de chute lors d'un respawn qui va resetState

   ---------------------------
   
   sprite = display.newSprite( game.camera, playerSheet, playerWalk.sequence )
   
   physics.addBody( sprite, { 
   	density 		= DENSITY, 
   	friction 	= FRICTION, 
   	bounce 		= BOUNCE,
   	radius 		= RADIUS
   })

   ---------------------------
   
--   sprite.isFixedRotation = false
   sprite.isFixedRotation = true
--	sprite:addEventListener( "touch", touchController.characterTouch )
	sprite:addEventListener( "collision", collide )
	sprite:addEventListener( "preCollision", preCollide )

	-- set coordinates to center on spawnpoint
   sprite.x = levelDrawer.level.spawnX
   sprite.y = levelDrawer.level.spawnY
   sprite.alpha = 0
   
   ---------------------------
   
   sprite:addEventListener( "touch", function(event)
   
		if(#ropes == 0) then return false end 

		if(event.phase == "began") then
			physicsManager.detachAllRopes() 
		end 

		return true 
	end)
	
   ---------------------------
   -- reset
      
   resetState()

   ---------------------------
   
	Runtime:addEventListener( "enterFrame", checkCharacter )
end	

function destroy()
	utils.destroyFromDisplay(sprite)
	Runtime:removeEventListener( "enterFrame", checkCharacter )
end

function resetState()
	floor 			= nil
   collideOnLeft 	= nil
   collideOnRight = nil
   
   timeLeavingFloor	= 0
   leavingFloor 	= nil
   
   timeLastThrow	= 0
   
   jumping 	= false 
   hanging 	= false 
   
   previousVy = 0
   nbFramesToKeep = 0
end

-------------------------------------

function die()

	exit()
	stop()
	state = OUT 
		
	local explosion = {
		x = sprite.x,
		y = sprite.y,
		color = {{12,12,212},{111,111,251}},
		scale = 1.5,
		fadeInTime = 1900
	}
	
	effectsManager.explode(explosion)
	
	timer.performWithDelay(2000, function()
   	physicsManager.detachAllRopes()
		effectsManager.spawnEffect()
	end)	

end

-------------------------------------

function mayThrow()
	if(throwFire) then
		throw(  game.hud.fireSmallButton.x - game.camera.x, game.hud.fireSmallButton.y - game.camera.y, hud.FIRE_BUTTON_X - game.camera.x, hud.FIRE_BUTTON_Y - game.camera.y)
	elseif(throwGrab) then
		grab(  game.hud.grabSmallButton.x - game.camera.x, game.hud.grabSmallButton.y - game.camera.y, hud.GRAB_BUTTON_X - game.camera.x, hud.GRAB_BUTTON_Y - game.camera.y)
	end
	
	throwFire = false
	throwGrab = false
end

-------------------------------------

function spawn()

	if(game.state == game.STOPPED) then print("krak !") return end
	
	resetState()
	stop()
   setThrowing()
   
   throwFire = false
	throwGrab = false
	
	-- replace the character on the spawn point
   sprite.x = levelDrawer.level.spawnX
   sprite.y = levelDrawer.level.spawnY
   sprite.alpha = 1
--   sprite.angularVelocity = 0
--   sprite.rotation = 0
   
	sprite:setFrame(1)
   sprite:setLinearVelocity(0,6)
   
	nbFramesToKeep = 0
end

-------------------------------------

function checkCharacter(event)

	local vx, vy = sprite:getLinearVelocity()

--	print(sprite.x,sprite.y)

--	local s = ""
--	if(hanging) then s = s .. "hanging, " end
--	if(jumping) then s = s .. "jumping, " end
--	if(floor) then s = s .. "on floor, " end
--	if(collideOnRight) then s = s .. "on right tile, " end
--	if(collideOnLeft) then s = s .. "on left tile, " end
--   print(s, vx, vy, previousVy)
   
   ------------------------------------------------------

	if(throwFire) then
		physicsManager.refreshTrajectory( game.hud.fireSmallButton.x - game.camera.x, game.hud.fireSmallButton.y - game.camera.y, hud.FIRE_BUTTON_X - game.camera.x, hud.FIRE_BUTTON_Y - game.camera.y)
		if(game.hud.fireSmallButton.x > hud.FIRE_BUTTON_X) then lookLeft() else lookRight() end

	elseif(event.id == throwTouchFingerId and character.throwGrab) then
		physicsManager.refreshTrajectory( game.hud.grabSmallButton.x - game.camera.x, game.hud.grabSmallButton.y - game.camera.y, hud.GRAB_BUTTON_X - game.camera.x, hud.GRAB_BUTTON_Y - game.camera.y)
		if(game.hud.fireSmallButton.x > hud.GRAB_BUTTON_X) then lookLeft() else lookRight() end

	end

	------------------------------------------------------
   
   
	if(nbFramesToKeep > 0 ) then
		nbFramesToKeep = nbFramesToKeep - 1
	else
   	
   	if(floor ~= nil) then
   		sprite:setFrame(1)
   	else
      	if(previousVy - vy > 0 and not hanging) then
      		sprite:setFrame(6)
      	
      	elseif(vy > 230) then
      		sprite:setFrame(5)
      	elseif(vy > 5) then
      		sprite:setFrame(4)
      	elseif(vy < -220) then
      		sprite:setFrame(2)
      	elseif(vy < -5) then
      		sprite:setFrame(3)
      	else
      		sprite:setFrame(1)
      	end
   	end
   	
   	previousVy = vy
	   
	   -------------------------------------------------------
	   -- checking out of limit
	   
	   if(sprite.y > levelDrawer.level.bottomY) then
			nbFramesToKeep = 10000
			state = OUT
			
			local now = system.getTimer()
			local time = 400
			if(now - timeLastThrow < 2000) then	time = 3000	end
			
   		timer.performWithDelay(time, function()
   			effectsManager.spawnEffect()
   		end)
   	end
   end
   
end

-------------------------------------

function preCollide(event)
	if(event.contact) then
	 	if(event.other.isSensor) then
			event.contact.isEnabled = false
		end
   end
end

-------------------------------------
-- vy = -260 is is the start vy when jumping. 
-- so vy = -200 is around the jump start
 
function collide( event )
	
	-------------------------------------------

	if(state == OUT) then return end
	if(event.other.isRock) then return end
	if(event.other.isGrab) then return end
	if(event.other.isSensor) then return end
	if(event.other.isAttach) then print("collide with attach") return end

	-------------------------------------------

	if(event.other.isBadRock or event.other.isEnemy) then
		die()
		return
	end

	-------------------------------------------

	local now = system.getTimer()
	if(leavingFloor and event.other.y == leavingFloor.y) then
		if(now - timeLeavingFloor < 70) then
   		return
		end
	end

	-------------------------------------------
	
	local tileTop 					= event.other.y 	- event.other.height/2 
	local characterBottom 		= event.target.y 	+ RADIUS
	
	-------------------------------------------

	local characterTop 			= event.target.y 	- RADIUS
	local characterLeft 			= event.target.x 	- RADIUS
	local characterRight 		= event.target.x 	+ RADIUS
	local tileBottom 				= event.other.y 	+ event.other.height/2
	local tileLeft 				= event.other.x 	- event.other.width/2
	local tileRight 				= event.other.x 	+ event.other.width/2
--
--	display.remove(line1)
--	display.remove(line2)
--	display.remove(line3)
--	display.remove(line4)
--
--	line1 = display.newLine(game.camera, tileLeft,tileTop, tileRight, tileTop)
--	line2 = display.newLine(game.camera, tileRight,tileTop, tileRight, tileBottom)
--	line3 = display.newLine(game.camera, tileRight,tileBottom, tileLeft, tileBottom)
--	line4 = display.newLine(game.camera, tileLeft,tileBottom, tileLeft, tileTop)
--
--	display.remove(line5)
--	display.remove(line6)
--	display.remove(line7)
--	display.remove(line8)
--
--	line5 = display.newLine(game.camera, characterLeft,characterTop, characterRight, characterTop)
--	line6 = display.newLine(game.camera, characterRight,characterTop, characterRight, characterBottom)
--	line7 = display.newLine(game.camera, characterRight,characterBottom, characterLeft, characterBottom)
--	line8 = display.newLine(game.camera, characterLeft,characterBottom, characterLeft, characterTop)

	-------------------------------------------
	
	local vx, vy = event.target:getLinearVelocity()
	
	if(tileTop > characterBottom and event.other.isFloor and vy > -200) then
--		print("touch floor")
		floor = event.other
		collideOnLeft, collideOnRight = nil, nil
		jumping = false
		move()
	elseif(tileBottom < characterTop and event.other.isFloor) then
--		print("touch top")
	else
		-- vx on move is 135
		-- less is a "bounce" due to collision : to ignore !
--		print("touch side ? ", characterLeft, characterRight, tileLeft, tileRight, " right :  " .. tostring(characterLeft < tileLeft and tileLeft < characterRight) .. " |  left : " .. tostring(characterLeft < tileRight and tileRight < characterRight) .. " | vx = " .. vx)
		if(characterLeft < tileLeft and tileLeft < characterRight ) then
--			print("collideOnRight")
			collideOnRight = event.other
		elseif(characterLeft < tileRight and tileRight < characterRight) then
--			print("collideOnLeft")
			collideOnLeft = event.other
		else
			collideOnLeft = nil
			collideOnRight = nil
		end

	end
	
	if((jumping or hanging) and vy > -200) then
		state = NOT_MOVING
		
		if(floor) then
   		nbFramesToKeep = 2
			sprite:setFrame(6) 
   	end
	end
end

-------------------------------------

function lookLeft()
	sprite.xScale = -1
end

function lookRight()
	sprite.xScale = 1
end

-------------------------------------

function setThrowing()
--	if(not GLOBALS.savedData.fireEnable) then return end
----	
----	effectsManager.stopCharacterLight()
----	effectsManager.setCharacterThrowing()
end

function setGrabbing()
--	if(not GLOBALS.savedData.grabEnable) then return end
----	
----	effectsManager.stopCharacterLight()
----	effectsManager.setCharacterGrabbing()
end

function setHanging(value)
	hanging = value
	if(hanging) then
		timeLeavingFloor  = system.getTimer()
		nbFramesToKeep = 20 -- could be locked while checking OUT and waiting for grab : reset ok here : 20 frames : time to climb up while still OUT
		
		timer.performWithDelay(100, function()
         if(hanging) then
				local vx, vy = sprite:getLinearVelocity()
         	if(math.abs(vy) > 1) then 
         		floor = nil 
         		collideOnRight	= nil
         		collideOnLeft 	= nil
         	end
         end
		end)
	end
end

-------------------------------------

function move()
	
	if(state == OUT or movesLocked) then return end
	 
	if(not hanging) then
		if(touchController.rightTouch) then
			goRight()
		elseif(touchController.leftTouch) then
			goLeft()
		end
	else
		if(touchController.rightTouch) then
			sprite:applyForce( HANGING_FORCE, 0, sprite.x, sprite.y )
		elseif(touchController.leftTouch) then
			sprite:applyForce( -HANGING_FORCE, 0, sprite.x, sprite.y )
		end
	end

	if(touchController.rightTouch or touchController.leftTouch) then
   	if(floor) then
   		jump()
   	end
	end
	
end

-------------------------------------
--
--function changeThrowStuff()
--
--	if(grabLocked) then return end
--	
--	throwFire = not throwFire
--	throwGrab = not throwGrab
--	
--	if(throwFire) then
--		setThrowing()
--	else	
--		setGrabbing()
--	end
--end

-------------------------------------

function stop()
	
	if(not jumping and not hanging) then 
   	state = NOT_MOVING
 	end
 
	local vx, vy = sprite:getLinearVelocity()
	if(vy < 0) then vy = vy*0.5 end
	sprite:setLinearVelocity( vx*0.67 , vy)
	
end


function goLeft()
	local vx, vy = sprite:getLinearVelocity()
	
	local floorVx, floorVy = 0,0
	if(floor) then floorVx, floorVy = floor:getLinearVelocity() end
	
	state = GOING_LEFT	
	lookLeft()
	sprite:setLinearVelocity( -CHARACTER_SPEED+floorVx, vy )
end

function goRight()
	local vx, vy = sprite:getLinearVelocity()
	
	local floorVx, floorVy = 0,0
	if(floor) then floorVx, floorVy = floor:getLinearVelocity() end

	state = GOING_RIGHT
	lookRight()
	sprite:setLinearVelocity( CHARACTER_SPEED+floorVx, vy )
end

function jump()
	if(jumping or (not hanging and not floor)) then return end
	timeLeavingFloor = system.getTimer()
	leavingFloor 	= floor
	jumping 			= true
	
	local vx, vy = sprite:getLinearVelocity()
	print(math.rad(floor.rotation))
	vx = vx * math.cos(math.rad(floor.rotation))
	vy = JUMP_SPEED * math.cos(math.rad(floor.rotation))

	floor = nil
	collideOnLeft = nil
	collideOnRight = nil
	
	sprite:setLinearVelocity( vx, vy )
end

-------------------------------------

function throw( x1,y1, x2,y2 )
	timeLastThrow = system.getTimer()
	game.energiesSpent = game.energiesSpent + 1
	physicsManager.throw(x1,y1, x2,y2)
end

-------------------------------------

function grab( x1,y1, x2,y2 )
	character.grabs = character.grabs + 1 -- deprecated
	game.energiesSpent = game.energiesSpent + 1
	timeLastThrow = system.getTimer()
	physicsManager.grab(x1,y1, x2,y2)
end
