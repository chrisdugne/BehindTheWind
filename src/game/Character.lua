-------------------------------------

module(..., package.seeall)

-------------------------------------

local CHARACTER_SPEED = 135
local JUMP_SPEED = -267
local NOT_MOVING 	= 0
local GOING_LEFT 	= 1
local GOING_RIGHT = 2

local RADIUS = 16

-------------------------------------

state = NOT_MOVING

-------------------------------------

floor 			= nil
collideOnLeft 	= nil
collideOnRight = nil

sprite 			= nil
ropes				= nil

timeLeavingFloor		= 0
leavingFloor 	= nil

jumping 	= false 
hanging 	= false 

-------------------------------------

local playerWalk = require("src.game.graphics.CharacterJump")
local playerSheet = graphics.newImageSheet( "assets/images/game/CharacterJump.png", playerWalk.sheet )

function init()
	ropes = {}
	
   sprite = display.newSprite( game.camera, playerSheet, playerWalk.sequence )
   
   physics.addBody( sprite, { 
   	density = 5, 
   	friction = 1, 
   	bounce = 0.2,
   	radius = RADIUS
   })
   
   sprite.isFixedRotation = true
	sprite:addEventListener( "collision", collide )
	sprite:addEventListener( "preCollision", preCollide )

	-- set coordinates to center on spawnpoint
   sprite.x = levelDrawer.level.spawnX
   sprite.y = levelDrawer.level.spawnY
   sprite.alpha = 0
   
	Runtime:addEventListener( "enterFrame", checkCharacter )
end	

-------------------------------------

function spawn()
	stop()
	
	-- replace the character on the spawn point
   sprite.x = levelDrawer.level.spawnX
   sprite.y = levelDrawer.level.spawnY
   sprite.alpha = 1
   
	sprite:setFrame(1)
   sprite:setLinearVelocity(0,6)
end

-------------------------------------

local previousVy = 0
local nbFramesToKeep = 0

function checkCharacter(event)

	local vx, vy = sprite:getLinearVelocity()

--	local s = ""
--	if(hanging) then s = s .. "hanging, " end
--	if(jumping) then s = s .. "jumping, " end
--	if(floor) then s = s .. "on floor, " end
--	if(collideOnRight) then s = s .. "on right tile, " end
--	if(collideOnLeft) then s = s .. "on left tile, " end
--   print(s, vx, vy, previousVy)
   
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
	   
	   if(sprite.y > levelDrawer.level.bottomY) then
			nbFramesToKeep = 100
   		timer.performWithDelay(400, function()
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

	if(event.other.isRock) then return end
	if(event.other.isGrab) then return end
	if(event.other.isSensor) then return end
	if(event.other.isAttach) then print("collide with attach") return end

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
			print("scratch")
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

function setGrabbing()
	effectsManager.setCharacterGrabbing()
end

function setThrowing()
	effectsManager.setCharacterThrowing()
end

function setHanging(value)
	hanging = value
	if(hanging) then
		timeLeavingFloor  = system.getTimer()
		
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

function stop(tapping)
	
	print("stop")

	if(not jumping and not hanging) then 
   	state = NOT_MOVING
 	end
 
 	if(tapping == 0) then
		local vx, vy = sprite:getLinearVelocity()
		sprite:setLinearVelocity( 0 , vy )
	end
	
	effectsManager.stopCharacterLight()
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
	print("--> perform jump")
	timeLeavingFloor = system.getTimer()
	leavingFloor 	= floor
	jumping 			= true
	
	floor = nil
	collideOnLeft = nil
	collideOnRight = nil
	
	local vx, vy = sprite:getLinearVelocity()
	sprite:setLinearVelocity( vx, JUMP_SPEED )
end

-------------------------------------

function throw( x1,y1, x2,y2 )
	physicsManager.throw(x1,y1, x2,y2)
end

-------------------------------------

function grab( x1,y1, x2,y2 )
	physicsManager.grab(x1,y1, x2,y2)
end
