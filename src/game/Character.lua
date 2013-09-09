-------------------------------------

module(..., package.seeall)

-------------------------------------

local CHARACTER_SPEED = 135
local NOT_MOVING 	= 0
local GOING_LEFT 	= 1
local GOING_RIGHT = 2

local JUMPING 	= false 

-------------------------------------

state = NOT_MOVING

-------------------------------------

floor 	= nil
sprite 	= nil
ropes		= nil

-------------------------------------

local playerWalk = require("src.game.graphics.CharacterJump")
local playerSheet = graphics.newImageSheet( "assets/images/game/CharacterJump.png", playerWalk.sheet )

function init()
	ropes = {}
	
   sprite = display.newSprite( game.camera, playerSheet, playerWalk.sequence )
   sprite.x = 120
   sprite.y = 209
   
   physics.addBody( sprite, { 
   	density = 5, 
   	friction = 1, 
   	bounce = 0.12,
   	radius = 31
   })
   
   sprite.isFixedRotation = true
	sprite:addEventListener( "collision", collide )
	sprite:addEventListener( "preCollision", preCollide )

	Runtime:addEventListener( "enterFrame", refreshCharacterSprite )
end	

-------------------------------------
local previousVy = 0
local nbFramesToKeep = 0

function refreshCharacterSprite(event)
	
	if(nbFramesToKeep > 0 ) then
		nbFramesToKeep = nbFramesToKeep - 1
	else
   	
   	local vx, vy = sprite:getLinearVelocity()
   	
   	if(floor ~= nil) then
   		sprite:setFrame(1)
   	else
      	if(previousVy - vy > 0) then
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
   end
end

-------------------------------------

function preCollide(event)
	if(event.contact and event.other.isSensor) then
		event.contact.isEnabled = false
   end
end

-------------------------------------
-- vy = -280 is is the start vy when jumping. 
-- so vy = -200 is around the jump start
 
function collide( event )
	local vx, vy = event.target:getLinearVelocity()

	if(event.other.y > event.target.y + event.target.height/2 and event.other.isFloor and vy > -200) then
		floor = event.other
	-- else : collision from sides or top : not the floor !
	end
	
	if(state == JUMPING and vy > -200) then 
		state = NOT_MOVING
		nbFramesToKeep = 2
		sprite:setFrame(6) 
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

-------------------------------------

function stop()
	if(state ~= JUMPING) then 
   	state = NOT_MOVING
 	end
 	
	local vx, vy = sprite:getLinearVelocity()
	sprite:setLinearVelocity( 0 , vy )
	
	effectsManager.stopCharacterLight()
end


function goLeft()
	if(state == JUMPING or not floor) then return end
	local vx, vy = sprite:getLinearVelocity()
	local floorVx, floorVy = floor:getLinearVelocity()
	
	state = GOING_LEFT	
	lookLeft()
	sprite:setLinearVelocity( -CHARACTER_SPEED+floorVx, vy )
end

function goRight()
	if(state == JUMPING or not floor) then return end
	local vx, vy = sprite:getLinearVelocity()
	local floorVx, floorVy = floor:getLinearVelocity()

	state = GOING_RIGHT
	lookRight()
	sprite:setLinearVelocity( CHARACTER_SPEED+floorVx, vy )
end

function jump()
	if(state == JUMPING or not floor) then return end
	
	floor = nil
	state = JUMPING
	
	local vx, vy = sprite:getLinearVelocity()
	sprite:setLinearVelocity( vx, -280 )
end

-------------------------------------

function throw( x1,y1, x2,y2 )
	physicsManager.throw(x1,y1, x2,y2)
end

-------------------------------------

function grab( x1,y1, x2,y2 )
	physicsManager.grab(x1,y1, x2,y2)
end
