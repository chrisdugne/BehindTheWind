-------------------------------------

module(..., package.seeall)

-------------------------------------

local tiles = require("src.game.graphics.Tiles")
local tilesSheet = graphics.newImageSheet( "assets/images/game/tiles.png", tiles.sheet )

local MOTION_SPEED = 60

-------------------------------------

function designLevel()

	---------------------

	local tiles 			= GLOBALS.level1.tiles
	local energies 		= GLOBALS.level1.energies
	local groupMotions 	= GLOBALS.level1.groupMotions
	local groupDragLines = GLOBALS.level1.groupDragLines
	
	---------------------
	
	local groups = {}
	
	for i=1, #tiles do

		--------------------

   	local tile 			= drawTile( game.camera, tiles[i].num, tiles[i].x, tiles[i].y )
		tile.group 			= tiles[i].group
		tile.movable 		= tiles[i].movable
		tile.draggable 	= tiles[i].draggable
		tile.destructible = tiles[i].destructible
		tile.background	= tiles[i].background
		tile.foreground 	= tiles[i].foreground
		
		tile.startX 		= tiles[i].x
		tile.startY 		= tiles[i].y
		tile.isFloor 		= true
		
		local type 			= "static"
		local requireBody = not tile.background and not tile.foreground


		if(tile.foreground) then
			print("foreground", tile.startX, tile.startY)	
		end

		if(tile.destructible) then	
			type = "dynamic" 	
		end
		
		if(requireBody) then
   		physics.addBody( tile, type, { density="450", friction=0.3, bounce=0 } )
      	tile.isFixedRotation = true
      end
		
		--------------------
   
   	if(tile.group) then
      	if(not groups[tile.group]) then
      		groups[tile.group] = {}
      	end
   
   		table.insert(groups[tile.group], tile)
   	end

		--------------------
		
	end 
	
	------------------------------

	for i=1, #energies do
		effectsManager.drawEnergy(energies[i].x, energies[i].y, energies[i].type)
	end 
	
	------------------------------
	
	for k,groupMotion in pairs(groupMotions) do
		if(groupMotion) then
			addGroupMotion(groups[k], groupMotion)
		end
	end

	------------------------------
	
	for k,groupDragLine in pairs(groupDragLines) do
		if(groupDragLine) then
			addGroupDraggable(groups[k], groupDragLine)
		end
	end
	
	-----------------------------
	
end

-------------------------------------

function bringForegroundToFront()
	for i=game.camera.numChildren,1,-1 do
		if(game.camera[i].foreground) then
			game.camera[i]:toFront()
		end
	end
end

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
	local distance			= direction:magnitude()
	local duration			= distance/MOTION_SPEED * 1000

	local motionVector 	= vector2D:Normalize(direction)
	motionVector:mult(MOTION_SPEED)
	
	for i = 1, #group do
		group[i].bodyType = "kinematic"
		moveTile(group[i], motionVector, 1, duration)
	end
end

function moveTile(tile, motionVector, way, duration)
	
	tile:setLinearVelocity( motionVector.x * way, motionVector.y * way)

	timer.performWithDelay(duration, function()
		moveTile(tile, motionVector, -way, duration)
	end)
end

---------------------------------------------------------------------

function addGroupDraggable(group, dragLine)

	local motionLimit = {}
	motionLimit.horizontal 	= dragLine.x2 - dragLine.x1
	motionLimit.vertical 	= dragLine.y2 - dragLine.y1

	for i = 1, #group do
		group[i]:addEventListener( "touch", function(event)
			touchController.dragGroup(group, motionLimit, event)
		end)
	end
end
