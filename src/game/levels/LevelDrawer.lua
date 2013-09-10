-------------------------------------

module(..., package.seeall)

-------------------------------------

TILES 			= 1
TREES 			= 2
TILES_GREY 		= 3
TILES_DARK 		= 4
LEVEL_MISC 		= 5

CHECKPOINT 		= 1 
SPAWNPOINT 		= 2 
EXIT 				= 3
PANEL				= 4 

-------------------------------------

local tilesSheetConfig 		= require("src.game.graphics.Tiles")
local treesSheetConfig 		= require("src.game.graphics.Trees")
local levelMiscSheetConfig 	= require("src.game.graphics.LevelMisc")

local tilesImageSheet 		= graphics.newImageSheet( "assets/images/game/tiles.png", tilesSheetConfig.sheet )
local tilesGreyImageSheet 	= graphics.newImageSheet( "assets/images/game/tiles.grey.png", tilesSheetConfig.sheet )
local tilesDarkImageSheet 	= graphics.newImageSheet( "assets/images/game/tiles.dark.png", tilesSheetConfig.sheet )
local treesImageSheet 		= graphics.newImageSheet( "assets/images/game/Trees.png", treesSheetConfig.sheet )
local levelMiscImageSheet 	= graphics.newImageSheet( "assets/images/game/LevelMisc.png", levelMiscSheetConfig.sheet )

-------------------------------------

sheetConfigs = {}
sheetConfigs[TILES] 			= tilesSheetConfig
sheetConfigs[TREES] 			= treesSheetConfig
sheetConfigs[TILES_GREY] 	= tilesSheetConfig
sheetConfigs[TILES_DARK] 	= tilesSheetConfig
sheetConfigs[LEVEL_MISC] 	= levelMiscSheetConfig

imageSheets = {}
imageSheets[TILES] 			= tilesImageSheet
imageSheets[TREES] 			= treesImageSheet
imageSheets[TILES_GREY] 	= tilesGreyImageSheet
imageSheets[TILES_DARK] 	= tilesDarkImageSheet
imageSheets[LEVEL_MISC] 	= levelMiscImageSheet

level = {}

-------------------------------------

local MOTION_SPEED = 60

-------------------------------------

function designLevel()

	---------------------

	level 					= {}
	level.checkPoints 	= {}
	level.num 				= 1
	level.bottomY 			= -100000
			
	---------------------

	local tiles 			= GLOBALS.level1.tiles
	local energies 		= GLOBALS.level1.energies
	local groupMotions 	= GLOBALS.level1.groupMotions
	local groupDragLines = GLOBALS.level1.groupDragLines
	
	---------------------
	
	local groups = {}
	local panelNum = 0
	
	for i=1, #tiles do

		--------------------

   	local tile 			= drawTile( game.camera, tiles[i].sheet, tiles[i].num, tiles[i].x, tiles[i].y )
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
		
		--------------------

		if(tile.destructible) then	
			type = "dynamic" 	
		end
		
		if(requireBody) then
   		physics.addBody( tile, type, { density="450", friction=0.3, bounce=0 } )
      	tile.isFixedRotation = true
      end

		--------------------

		if(tile.startY + 400 > level.bottomY) then
			level.bottomY = tile.startY + 400
		end
		
		--------------------
   
   	if(tile.group) then
      	if(not groups[tile.group]) then
      		groups[tile.group] = {}
      	end
   
--   		table.insert(groups[tile.group], tile)
			groups[tile.group][#groups[tile.group] + 1] = tile
   	end

		--------------------
		-- Level Misc 
		-- 
		
		if(tile.sheet == LEVEL_MISC) then
		
			if(tile.num == PANEL) then
   			panelNum = panelNum + 1
   			tile:addEventListener( "touch", function(event)
            	if(event.phase == "began") then
      				hud.openPanel(level.num, panelNum)
               end
      			return true
   			end)

			elseif(tile.num == SPAWNPOINT) then
   			level.spawnX = tile.x
   			level.spawnY = tile.y
   			display.remove(tile)
   		end
		end
		
		--------------------
		
	end 
	
	------------------------------

	for i=1, #energies do
		effectsManager.drawEnergy(energies[i].x, energies[i].y, energies[i].type)
	end 
	
	------------------------------
	
	for k,groupMotion in pairs(groupMotions) do
		-- k est parfois le num en string dans le json groupMotions (gd num de groupe a priori)
		if(type(k) == "string") then k = tonumber(k) end
		
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

function putBackgroundToBack()
	for i=1,game.camera.numChildren do
		if(game.camera[i].background) then
			game.camera[i]:toBack()
		end
	end
end

-------------------------------------

function drawTile(view, sheet, num, x, y)
	
	if(not sheet) then
		sheet = 1
	end
	
	local tile = display.newImage( view, imageSheets[sheet], num )
	tile.x 			= x
	tile.y 			= y
	tile.num	 		= num
	tile.sheet 		= sheet
	
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
