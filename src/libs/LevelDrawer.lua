-------------------------------------

module(..., package.seeall)

-------------------------------------

local tiles = require("src.game.graphics.Tiles")
local tilesSheet = graphics.newImageSheet( "assets/images/game/tiles.png", tiles.sheet )

local MOTION_SPEED = 60

-------------------------------------

function drawTile(view, num, x, y)
	
	local tile = display.newImage( view, tilesSheet, num )

	tile.x = x
	tile.y = y
	tile.num = num
	
	return tile
end

---------------------------------------------------------------------

function addGroupMotion(group, motion)

	local motionStart 	= vector2D:new(motion.x1, motion.y1)
	local motionEnd		= vector2D:new(motion.x2, motion.y2)
	local direction 		= vector2D:Sub(motionEnd, motionStart)

	local motionForward 	= vector2D:Normalize(direction)
	motionForward:mult(MOTION_SPEED)
	
	for i = 1, #group do
		group[i].bodyType = "kinematic"
		moveForward(group[i], motionForward)
	end
end

function moveForward(tile, motionForward)
	tile:setLinearVelocity( motionForward.x, motionForward.y )

	timer.performWithDelay(2000, function()
		moveBackward(tile, motionForward)
	end)
end

function moveBackward(tile, motionForward)
	tile:setLinearVelocity( -motionForward.x, -motionForward.y )

	timer.performWithDelay(2000, function()
		moveForward(tile, motionForward)
	end)
end