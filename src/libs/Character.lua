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

floor 	= nil
sprite 	= nil
view 	= nil

-------------------------------------

local playerWalk = require("src.game.graphics.PlayerWalk")
local playerSheet = graphics.newImageSheet( "assets/images/game/player.walk.png", playerWalk.sheet )

function init(camera)
	view = camera
   sprite = display.newSprite( camera, playerSheet, playerWalk.sequence )
   sprite.x = 120
   sprite.y = 209
   physics.addBody( sprite, { 
   	density = 0.1, 
   	friction = 1, 
   	bounce = 0.12,
   	shape = { -7,-22,  7,-22,  7,17,  3,22,  -3,22,  -7,17 }
   })
   sprite.isFixedRotation = true
	sprite.collision = touchTile
	sprite:addEventListener( "collision", sprite )
end

-------------------------------------

function touchTile( sprite, event )
	local vx, vy = sprite:getLinearVelocity()
	
	if(event.other.y > sprite.y and vy > 0 and event.other.isFloor) then
		floor = event.other
	-- else : collision from sides or top : not the floor !
	end
	
	if(state == JUMPING and vy > 0) then
		state = NOT_MOVING 
	end
end

-------------------------------------

function stop()
	if(state ~= JUMPING) then 
   	state = NOT_MOVING
 	end
 	
	sprite:pause()
	sprite:setFrame(1)
	local vx, vy = sprite:getLinearVelocity()
	sprite:setLinearVelocity( 0 , vy )
end


function startMoveLeft()
	if(state == JUMPING) then return end
	local vx, vy = sprite:getLinearVelocity()
	local floorVx, floorVy = floor:getLinearVelocity()
	
	state = GOING_LEFT	
	sprite.xScale = -1
	sprite:setLinearVelocity( -CHARACTER_SPEED+floorVx, vy )
	sprite:play()
end

function startMoveRight()
	if(state == JUMPING) then return end
	local vx, vy = sprite:getLinearVelocity()
	local floorVx, floorVy = floor:getLinearVelocity()

	state = GOING_RIGHT
	sprite.xScale = 1
	sprite:setLinearVelocity( CHARACTER_SPEED+floorVx, vy )
	sprite:play()
end

function jump()
	if(state == JUMPING) then return end
	
	floor = nil
	state = JUMPING
	sprite:pause()
	sprite:setFrame(5)
	
	local vx, vy = sprite:getLinearVelocity()
	sprite:setLinearVelocity( vx, -280 )
end

-------------------------------------
