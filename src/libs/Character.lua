-------------------------------------

module(..., package.seeall)

-------------------------------------

NOT_MOVING 	= 0
GOING_LEFT 	= 1
GOING_RIGHT = 2

JUMPING 	= false 

-------------------------------------

local state = NOT_MOVING
local speed = 6

-------------------------------------

local playerWalk = require("src.game.graphics.PlayerWalk")
local playerSheet = graphics.newImageSheet( "assets/images/game/player.walk.png", playerWalk.sheet )
local character

function init()
   character = display.newSprite( playerSheet, playerWalk.sequence )
   character.x = 120
   character.y = 19
   physics.addBody( character, { 
   	density = 0.1, 
   	friction = 0, 
   	bounce = 0.12,
   	shape = { -7,-22,  7,-22,  7,17,  3,22,  -3,22,  -7,17 }
   })
   character.isFixedRotation = true
	character.collision = touchTile
	character:addEventListener( "collision", character )
end

-------------------------------------

function touchTile( character, event )

	local vx, vy = character:getLinearVelocity()
	if(state == JUMPING and vy > 0) then
		state = NOT_MOVING 
	end
end

-------------------------------------

function stop()
	if(state ~= JUMPING) then 
   	state = NOT_MOVING
 	end
 	
	character:pause()
	character:setFrame(1)
	local vx, vy = character:getLinearVelocity()
	character:setLinearVelocity( 0 , vy )
end


function startMoveLeft()
	if(state == JUMPING) then return end
	state = GOING_LEFT	
	local vx, vy = character:getLinearVelocity()
	character:setLinearVelocity( -175, vy )
	character.xScale = -1
	character:play()
end

function startMoveRight()
	if(state == JUMPING) then return end
	state = GOING_RIGHT
	local vx, vy = character:getLinearVelocity()
	character:setLinearVelocity( 175, vy )
	character.xScale = 1
	character:play()
end

function jump()
	if(state == JUMPING) then return end
	
	state = JUMPING
	character:pause()
	character:setFrame(5)
	
	local vx, vy = character:getLinearVelocity()
	character:setLinearVelocity( vx, -280 )
end

-------------------------------------

function checkIfLift()
	character.y = character.y - 0.4
end