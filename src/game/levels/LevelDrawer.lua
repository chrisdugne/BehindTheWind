-------------------------------------

module(..., package.seeall)

-------------------------------------

TILES 			= 1
TREES 			= 2
TILES_GREY 		= 3
TILES_DARK 		= 4
LEVEL_MISC 		= 5

PIECE 			= 6 -- SAME NUM FOR MISC
SIMPLE_PIECE 	= 7 -- SAME NUM FOR MISC

TILES_CLASSIC 	= 8
TILES_GREEN 	= 9

---------------
--MISC

BAD 				= 1 
CHECKPOINT 		= 2 
SPAWNPOINT 		= 3 
EXIT 				= 4
PANEL				= 5 

-------------------------------------

tilesSheetConfig 			= require("src.game.graphics.Tiles")
treesSheetConfig 			= require("src.game.graphics.Trees")
levelMiscSheetConfig 	= require("src.game.graphics.LevelMisc")
pieceSheetConfig 			= require("src.game.graphics.Piece")

tilesImageSheet 			= graphics.newImageSheet( "assets/images/game/tiles.png", tilesSheetConfig.sheet )
tilesGreyImageSheet 		= graphics.newImageSheet( "assets/images/game/tiles.grey.png", tilesSheetConfig.sheet )
tilesDarkImageSheet 		= graphics.newImageSheet( "assets/images/game/tiles.dark.png", tilesSheetConfig.sheet )
tilesClassicImageSheet 		= graphics.newImageSheet( "assets/images/game/tiles.classic.png", tilesSheetConfig.sheet )
tilesGreenImageSheet 			= graphics.newImageSheet( "assets/images/game/tiles.greenish.png", tilesSheetConfig.sheet )
treesImageSheet 			= graphics.newImageSheet( "assets/images/game/Trees.png", treesSheetConfig.sheet )
levelMiscImageSheet 		= graphics.newImageSheet( "assets/images/game/LevelMisc.png", levelMiscSheetConfig.sheet )
pieceImageSheet 			= graphics.newImageSheet( "assets/images/game/Piece.png", pieceSheetConfig.sheet )
simplePieceImageSheet	= graphics.newImageSheet( "assets/images/game/SimplePiece.png", pieceSheetConfig.sheet )

-------------------------------------

sheetConfigs = {}
sheetConfigs[TILES] 			= tilesSheetConfig
sheetConfigs[TREES] 			= treesSheetConfig
sheetConfigs[TILES_GREY] 	= tilesSheetConfig
sheetConfigs[TILES_DARK] 	= tilesSheetConfig
sheetConfigs[LEVEL_MISC] 	= levelMiscSheetConfig
sheetConfigs[PIECE] 			= pieceSheetConfig
sheetConfigs[SIMPLE_PIECE] = pieceSheetConfig
sheetConfigs[TILES_CLASSIC] = tilesSheetConfig
sheetConfigs[TILES_GREEN] 	= tilesSheetConfig

imageSheets = {}
imageSheets[TILES] 			= tilesImageSheet
imageSheets[TREES] 			= treesImageSheet
imageSheets[TILES_GREY] 	= tilesGreyImageSheet
imageSheets[TILES_DARK] 	= tilesDarkImageSheet
imageSheets[LEVEL_MISC] 	= levelMiscImageSheet
imageSheets[PIECE] 			= pieceImageSheet
imageSheets[SIMPLE_PIECE]  = simplePieceImageSheet
imageSheets[TILES_CLASSIC] = tilesClassicImageSheet
imageSheets[TILES_GREEN] 	= tilesGreenImageSheet

level = {}

-------------------------------------

local MOTION_SPEED = 60

-------------------------------------

function designLevel(displayScore)

	---------------------

	level 					= {}
	level.triggers 		= {}
	level.num 				= game.level
	level.bottomY 			= -100000
	
	---------------------

	level.content 			= GLOBALS.levels[game.level]

	---------------------

	local tiles 			= level.content.tiles
	local energies 		= level.content.energies
	local groupMotions 	= level.content.groupMotions
	local groupDragLines = level.content.groupDragLines
	
	---------------------
	
	local groups = {}
	
	for i=1, #tiles do

		--------------------

   	local tile 			= drawTile( game.camera, tiles[i].sheet, tiles[i].num, tiles[i].x, tiles[i].y )
		tile.group 			= tiles[i].group
		tile.movable 		= tiles[i].movable
		tile.draggable 	= tiles[i].draggable
		tile.destructible = tiles[i].destructible
		tile.background	= tiles[i].background
		tile.foreground 	= tiles[i].foreground
		tile.trigger 		= tiles[i].trigger
		tile.pack			= tiles[i].pack
		
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
   
			groups[tile.group][#groups[tile.group] + 1] = tile
   	end

		--------------------
		-- Triggers
		
		if(tile.trigger) then
			
      	if(not level.triggers[tile.trigger]) then
      		level.triggers[tile.trigger] = {
      			remaining = 0
      		}
      	end
   
			level.triggers[tile.trigger].remaining = level.triggers[tile.trigger].remaining + 1
			effectsManager.drawTrigger(tile.x, tile.y, tile.trigger)
			display.remove(tile)
		end
		
		--------------------
		-- Level Misc 
		-- 
		
		if(tile.sheet == LEVEL_MISC) then
		
			if(tile.num == PANEL) then
				tile.panelNum = tiles[i].panelNum
   			tile:addEventListener( "touch", openPanel)

			elseif(tile.num == SPAWNPOINT) then
   			level.spawnX = tile.x
   			level.spawnY = tile.y
   			display.remove(tile)

			elseif(tile.num == CHECKPOINT) then
				local checkPoint = {}
				checkPoint.x = tile.x
				checkPoint.y = tile.y
   			display.remove(tile)
				physicsManager.drawCheckpoint(checkPoint)

			elseif(tile.num == EXIT) then
				effectsManager.drawExit(tile.x, tile.y, displayScore)
   			display.remove(tile)

			elseif(tile.num == PIECE) then
   			display.remove(tile)
				local piece = display.newSprite( game.camera, pieceImageSheet, pieceSheetConfig:newSequence() )
         	piece.x 			= tiles[i].x
         	piece.y 			= tiles[i].y
         	piece.type 		= tile.num
				piece:play()
				effectsManager.lightPiece(piece)

			elseif(tile.num == SIMPLE_PIECE) then
   			display.remove(tile)
				local piece = display.newSprite( game.camera, simplePieceImageSheet, pieceSheetConfig:newSequence() )
         	piece.x 			= tiles[i].x
         	piece.y 			= tiles[i].y
         	piece.type 		= tile.num
				piece:play()
				effectsManager.lightPiece(piece)
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
			-- corona crash sans le performWithDelay ?
			local startMotion = function() timer.performWithDelay(1, function () addGroupMotion(groups[k], groupMotion) end) end
			
			if(groupMotion.trigger) then
				level.triggers[groupMotion.trigger].start = startMotion 
			else
   			 startMotion()
			end
			
		end
	end

	------------------------------
	
	for k,groupDragLine in pairs(groupDragLines) do
		if(groupDragLine) then
			local enableDrag = function() addGroupDraggable(groups[k], groupDragLine) end
			
			if(groupDragLine.trigger) then
				level.triggers[groupDragLine.trigger].start = enableDrag 
			else
   			 enableDrag()
			end
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

function openPanel(event)
	if(event.phase == "began") then
		hud.openPanel(level.num, event.target.panelNum)
   end
	return true
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
		group[i].xStart = group[i].x
		group[i].yStart = group[i].y
		startMoveTile(group[i], motionVector, duration)
	end
end

---------------------------------------------------------------------

function startMoveTile(tile, motionVector, duration)
	
	if(game.state == game.STOPPED) then return end

	-- replace force au cas ou lag pendant le timer
	tile.x = tile.xStart
	tile.y = tile.yStart
		
	tile:setLinearVelocity( motionVector.x , motionVector.y )

	timer.performWithDelay(duration, function()
   	tile:setLinearVelocity( - motionVector.x , - motionVector.y )
   	timer.performWithDelay(duration, function()
			startMoveTile(tile, motionVector, duration)
   	end)
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

---------------------------------------------------------------------

function hitTrigger(trigger)

	level.triggers[trigger].remaining = level.triggers[trigger].remaining - 1
	
	if(level.triggers[trigger].remaining == 0) then
		level.triggers[trigger].start()
	end
end
