-------------------------------------

module(..., package.seeall)

-------------------------------------

local tiles = require("src.game.graphics.Tiles")
local tilesSheet = graphics.newImageSheet( "assets/images/game/tiles.png", tiles.sheet )

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

	

	for i = 1, #group do
		group[i].bodyType = "kinematic"
		group[i]:setLinearVelocity( -55, 0 )
	end
end