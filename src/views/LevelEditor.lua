-----------------------------------------------------------------------------------------
--
-- AppHome.lua
--
-----------------------------------------------------------------------------------------

local scene = storyboard.newScene()

-----------------------------------------------------------------------------------------

local tileSelection 			= display.newGroup()
local editor 					= display.newGroup()
local selectedTile
local selectedGroup
local selectedEnergyType

local groups 					= {}
local groupMotions  			= {} -- contient la liste des lines pour chaque group movable. pour les tiles uniques : tile.motion
local groupDragLines  		= {}

-----------------------------------------------------------------------------------------

local DRAWING 				= 1
local ERASING 				= 2
local GROUPING 			= 20
local ENABLING_MOVE 		= 65
local ENABLING_DRAG 		= 83
local SET_DESTRUCTIBLE 	= 8
local SET_BACKGROUND 	= 5
local SET_FOREGROUND 	= 4

local DRAWING_ENERGY 	= 60

-----------------------------------------------------------------------------------------

local state = DRAWING
local erase, grouping, enableMove, enableDrag
local smallEnergyButton, mediumEnergyButton, bigEnergyButton
local currentGroup = 0

local currentSheet 	= 1

-----------------------------------------------------------------------------------------

local smallEnergyButtonScale 		= 0.04
local mediumEnergyButtonScale 	= 0.08
local bigEnergyButtonScale 		= 0.01

-----------------------------------------------------------------------------------------

-- note virer ca et return true partout
local dontListenThisTouchScreen = false

-----------------------------------------------------------------------------------------
-- BEGINNING OF YOUR IMPLEMENTATION
-- 
-- NOTE: Code outside of listener functions (below) will only be executed once,
--		 unless storyboard.removeScene() is called.
-- 
-----------------------------------------------------------------------------------------

-- Called when the scene's view does not exist:
function scene:createScene( event )
	display.setDefault( "background", 110, 110, 110 )
end

-----------------------------------------------------------------------------------------

-- Called when the scene's view does not exist:
function scene:refreshScene()
	
	viewManager.initView(self.view);
	self:initLevel()
	
	------------------------------

	display.getCurrentStage():addEventListener( "touch", function(event)
		self:touchScreen(event)
	end)

	------------------------------
	
	self:refreshTileSelection()

	------------------------------------------------------------------------------------------------------------
	-- Editor moves
	------------------------------------------------------------------------------------------------------------

	local down = display.newImage( "assets/images/tutorial/arrow.down.png" )
	down.x = 20
	down.y = 80
	down:scale(0.12,0.12)
   down:addEventListener( "touch", function(event) 
   	if(event.phase == "began") then editor.y = editor.y + 100 end
		return true
	end )

	local up = display.newImage( "assets/images/tutorial/arrow.top.png" )
	up.x = 20
	up.y = 55
	up:scale(0.12,0.12)
   up:addEventListener( "touch", function(event)
   	if(event.phase == "began") then editor.y = editor.y - 100 end
		return true
   end )

	local left = display.newImage( "assets/images/tutorial/arrow.left.png" )
	left.x = 8
	left.y = 67
	left:scale(0.12,0.12)
   left:addEventListener( "touch", function(event) 
   	if(event.phase == "began") then editor.x = editor.x - 190 end 
		return true
  	end )

	local right = display.newImage( "assets/images/tutorial/arrow.right.png" )
	right.x = 32
	right.y = 67
	right:scale(0.12,0.12)
   right:addEventListener( "touch", function(event) 
   	if(event.phase == "began") then editor.x = editor.x + 190 end
		return true
   end )


	------------------------------------------------------------------------------------------------------------
	-- Tile selector
	------------------------------------------------------------------------------------------------------------

	local selectionLeft = display.newImage( "assets/images/tutorial/arrow.left.png" )
	selectionLeft.x = 60
	selectionLeft.y = 62
	selectionLeft:scale(0.1,0.1)
   selectionLeft:addEventListener( "touch", function(event) 
   	if(event.phase == "began") then tileSelection.x = tileSelection.x + 300 end
		return true
   end )

	local selectionRight = display.newImage( "assets/images/tutorial/arrow.right.png" )
	selectionRight.x = 75
	selectionRight.y = 62
	selectionRight:scale(0.1,0.1)
   selectionRight:addEventListener( "touch", function(event) 
   	if(event.phase == "began") then tileSelection.x = tileSelection.x - 300 end	 
		return true
   end )
   
	local selectionDown = display.newImage( "assets/images/tutorial/arrow.down.png" )
	selectionDown.x = 67.5
	selectionDown.y = 80
	selectionDown:scale(0.12,0.12)
   selectionDown:addEventListener( "touch", function(event) 
   	if(event.phase == "began") then
   		currentSheet = currentSheet + 1
   		if(currentSheet > #levelDrawer.imageSheets) then currentSheet = 1 end
   		self:refreshTileSelection()
   	end
		return true
	end )


	------------------------------------------------------------------------------------------------------------
	-- States
	------------------------------------------------------------------------------------------------------------
	
	erase = levelDrawer.drawTile( self.view, levelDrawer.TILES, ERASING, 100, 62 )
	erase:scale(0.5,0.5)
   erase:addEventListener( "touch", function(event) 
   	if(event.phase == "began") then
   		stateErasing()
   	end
   	return true 
  	end )

	-------------------------------------
	
	grouping = levelDrawer.drawTile( self.view, levelDrawer.TILES, GROUPING, 125, 62 )
	grouping:scale(0.5,0.5)
   grouping:addEventListener( "touch", function(event) 
   	if(event.phase == "began") then
   		stateGrouping()	 
			return true
   	end 
  	end )

	-------------------------------------
	
	enableMove = levelDrawer.drawTile( self.view, levelDrawer.TILES, ENABLING_MOVE, 150, 62 )
	enableMove:scale(0.5,0.5)
   enableMove:addEventListener( "touch", function(event) 
   	if(event.phase == "began") then
   		setState(ENABLING_MOVE, enableMove)
			return true
   	end 
  	end )

	-------------------------------------
	
	enableDrag = levelDrawer.drawTile( self.view, levelDrawer.TILES, ENABLING_DRAG, 175, 62 )
	enableDrag:scale(0.5,0.5)
   enableDrag:addEventListener( "touch", function(event) 
   	if(event.phase == "began") then
   		setState(ENABLING_DRAG, enableDrag)
			return true
   	end 
  	end )

	-------------------------------------
	
	setDestructible = levelDrawer.drawTile( self.view, levelDrawer.TILES, SET_DESTRUCTIBLE, 200, 62 )
	setDestructible:scale(0.5,0.5)
   setDestructible:addEventListener( "touch", function(event) 
   	if(event.phase == "began") then
   		setState(SET_DESTRUCTIBLE, setDestructible)
			return true
   	end 
  	end )

	-------------------------------------
	
	setBackground = levelDrawer.drawTile( self.view, levelDrawer.TILES, SET_BACKGROUND, 225, 62 )
	setBackground:scale(0.5,0.5)
   setBackground:addEventListener( "touch", function(event) 
   	if(event.phase == "began") then
   		setState(SET_BACKGROUND, setBackground)
			return true
   	end 
  	end )

	-------------------------------------
	
	setForeground = levelDrawer.drawTile( self.view, levelDrawer.TILES, SET_FOREGROUND, 250, 62 )
	setForeground:scale(0.5,0.5)
   setForeground:addEventListener( "touch", function(event) 
   	if(event.phase == "began") then
   		setState(SET_FOREGROUND, setForeground)
			return true
   	end 
  	end )

	------------------------------------------------------------------------------------------------------------
	-- Spawn point / Checkpoint / Energies
	------------------------------------------------------------------------------------------------------------
	
	smallEnergyButton = display.newImage( "assets/images/game/planet.white.png" )
	smallEnergyButton.x = 300
	smallEnergyButton.y = 60
	smallEnergyButton.alpha = 0.7
	smallEnergyButton:scale(0.04,0.04)
   smallEnergyButton:addEventListener( "touch", function(event) 
   	if(event.phase == "began") then
   		selectedEnergyType = SMALL_ENERGY
   		stateDrawEnergy(smallEnergyButton)
			return true
   	end 
  	end )

	mediumEnergyButton = display.newImage( "assets/images/game/planet.white.png" )
	mediumEnergyButton.x = 320
	mediumEnergyButton.y = 60
	mediumEnergyButton.alpha = 0.7
	mediumEnergyButton:scale(0.08,0.08)
   mediumEnergyButton:addEventListener( "touch", function(event) 
   	if(event.phase == "began") then
   		selectedEnergyType = MEDIUM_ENERGY
   		stateDrawEnergy(mediumEnergyButton)
			return true
   	end 
  	end )

	bigEnergyButton = display.newImage( "assets/images/game/planet.white.png" )
	bigEnergyButton.x = 350
	bigEnergyButton.y = 60
	bigEnergyButton.alpha = 0.7
	bigEnergyButton:scale(0.12,0.12)
   bigEnergyButton:addEventListener( "touch", function(event) 
   	if(event.phase == "began") then
   		selectedEnergyType = BIG_ENERGY
   		stateDrawEnergy(bigEnergyButton)
			return true
   	end 
  	end )
	
	------------------------------------------------------------------------------------------------------------
	-- Import / Export
	------------------------------------------------------------------------------------------------------------

	local import = levelDrawer.drawTile( self.view, levelDrawer.TILES, 9, display.contentWidth - 35, 62 )
	import:scale(0.5,0.5)
	import:addEventListener( "touch", function(event) 
		if(event.phase == "began") then
			self:import()
			return true
		end 
	end )

	-------------------------------------

	local export = levelDrawer.drawTile( self.view, levelDrawer.TILES, 4, display.contentWidth - 15, 62 )
	export:scale(0.5,0.5)
	export:addEventListener( "touch", function(event) 
		if(event.phase == "began") then
			self:export()
			return true
		end 
	end )
	
end

------------------------------------------

function resetStates()
	if(state == ERASING) then
		erase:scale(0.5,0.5)
	elseif(state == GROUPING) then
		grouping:scale(0.5,0.5)
	elseif(state == SET_DESTRUCTIBLE) then
		setDestructible:scale(0.5,0.5)
	elseif(state == SET_BACKGROUND) then
		setBackground:scale(0.5,0.5)
	elseif(state == SET_FOREGROUND) then
		setForeground:scale(0.5,0.5)
	elseif(state == ENABLING_MOVE) then
		enableMove:scale(0.5,0.5)
	elseif(state == ENABLING_DRAG) then
		enableDrag:scale(0.5,0.5)
	elseif(state == DRAWING_ENERGY) then
		smallEnergyButton.alpha = 0.7
		mediumEnergyButton.alpha = 0.7
		bigEnergyButton.alpha = 0.7
	end
end

------------------------------------------

function stateDrawing()
	resetStates()
	state = DRAWING
end

------------------------------------------
--
function stateGrouping()
	if(state ~= GROUPING) then
   	resetStates()
   	state = GROUPING
   	grouping:scale(2,2)
   	currentGroup = currentGroup + 1
   else
   	stateDrawing()
   end
end

------------------------------------------
--
function stateErasing()
	if(state ~= ERASING) then
   	resetStates()
   	state = ERASING
   	erase:scale(2,2)
   else
   	stateDrawing()
   end
end

------------------------------------------

function setState(newState, stateButton)
	if(state ~= newState) then
   	resetStates()
   	state = newState
   	stateButton:scale(2,2)
   	selectedTile = nil
   	selectedGroup = nil
		dontListenThisTouchScreen = true
   else
   	stateDrawing()
   end
end

------------------------------------------

function stateDrawEnergy(button)
	if(button.alpha < 1) then
   	resetStates()
   	state = DRAWING_ENERGY
   	button.alpha = 1
   	selectedTile = nil
   	selectedGroup = nil
		dontListenThisTouchScreen = true
   else
   	button.alpha = 0.7
   	stateDrawing()
   end
end

------------------------------------------

function scene:refreshTileSelection()
	
	--------------------------

	local currentImageSheet 	= levelDrawer.imageSheets[currentSheet]
	local currentSheetConfig 	= levelDrawer.sheetConfigs[currentSheet]
	
	utils.emptyGroup(tileSelection)
	tileSelection.x = 0
	
	--------------------------

	local x = 40
   for num = 1, #currentSheetConfig.sheet.frames do
   
   	if(num > 1) then
   		x = x + currentSheetConfig.sheet.frames[num - 1].width + 10	
   	end
	
		local tile = levelDrawer.drawTile( tileSelection, currentSheet, num, x, 40 - currentSheetConfig.sheet.frames[num].height/2)
      tile:addEventListener( "touch", function(event) if(event.phase == "began") then self:addTile(currentSheet, num) end end )
	end
end

------------------------------------------

function scene:initLevel()
	groups 				= {}
	groupMotions 		= {}
	groupDragLines 	= {}
	editor.dragLines 	= {}
	editor.energies 	= {}
end

------------------------------------------

function scene:import()

	-----------------------------
	
	utils.emptyGroup(editor)
	self:initLevel()
	
	-----------------------------

	local tiles = GLOBALS.levelEditor.tiles

	for i=1, #tiles do
		
		local tile = self:addTile(tiles[i].sheet, tiles[i].num, tiles[i].x, tiles[i].y)
		
		if(tiles[i].group) then
			--- add to group
			currentGroup = tiles[i].group
			self:addToGroup(tile)
			
			--- just set the boolean movable to be check by group after groups is formed
			tile.movable 			= tiles[i].movable
			tile.draggable 		= tiles[i].draggable
			tile.destructible 	= tiles[i].destructible
			tile.background 		= tiles[i].background
			tile.foreground 		= tiles[i].foreground
		
		else
			--- unique tile : check movable now
			if(tiles[i].movable) then
   			self:setMovable(tile)
			end

			if(tiles[i].draggable) then
   			self:setDraggable(tile)
			end

			if(tiles[i].destructible) then
   			self:setProperty(tile, "destructible")
			end
		
			if(tiles[i].background) then
   			self:setProperty(tile, "background")
			end
		
			if(tiles[i].foreground) then
   			self:setProperty(tile, "foreground")
			end
		
		end
	end 
	
	-----------------------------

	local energies = GLOBALS.levelEditor.energies

	for i=1, #energies do
		self:drawEnergy(energies[i].x, energies[i].y, energies[i].type)
	end 

	-----------------------------

	--- now the groups are ready : check movable for each group now
	for k,v in pairs(groups) do
		if(groups[k][1].movable) then
			self:setMovable(groups[k][1])
   	end 
		if(groups[k][1].draggable) then
			self:setDraggable(groups[k][1])
   	end 
		if(groups[k][1].destructible) then
			self:setProperty(groups[k][1], "destructible")
   	end 
		if(groups[k][1].background) then
			self:setProperty(groups[k][1], "background")
   	end 
		if(groups[k][1].foreground) then
			self:setProperty(groups[k][1], "foreground")
   	end 
	end 

	-----------------------------

	for k,groupMotion in pairs(GLOBALS.levelEditor.groupMotions) do
	
		-- k est parfois le num en string dans le json groupMotions (gd num de groupe a priori)
		if(type(k) == "string") then k = tonumber(k) end

		if(groupMotion) then
			self:drawGroupMotion(k, groupMotion.x1, groupMotion.y1, groupMotion.x2, groupMotion.y2)
   	end 
	end 
	
	-----------------------------

	for k,groupDraggable in pairs(GLOBALS.levelEditor.groupDragLines) do
		if(groupDraggable) then
			self:drawGroupDragLine(k, groupDraggable)
   	end 
	end 
	
	-----------------------------

	currentGroup 	= GLOBALS.levelEditor.lastGroup
	selectedTile 	= nil
	selectedGroup 	= nil

	-----------------------------
	
	for i=1,editor.numChildren do
		if(editor[i].background) then
			editor[i]:toBack()
		end
	end
	
	editor:toBack()	
end

------------------------------------------

function scene:export()

	--------------------------------------

	local groupDragLines = (GLOBALS.levelEditor and GLOBALS.levelEditor.groupDragLines) or {}
	
	GLOBALS.levelEditor 						= {}
	GLOBALS.levelEditor.tiles 				= {}
	GLOBALS.levelEditor.energies 			= {}
	GLOBALS.levelEditor.groupDragLines 	= groupDragLines

	--------------------------------------

	local numTile 		= 1
	local numEnergy 	= 1
	
	for i=1, editor.numChildren,1 do

		if(editor[i].isTile) then
			local tile = {}
			tile.sheet				= editor[i].sheet
			tile.num 				= editor[i].num
			tile.group 				= editor[i].group
			tile.movable 			= editor[i].movable
			tile.draggable 		= editor[i].draggable
			tile.destructible 	= editor[i].destructible
			tile.background 		= editor[i].background
			tile.foreground 		= editor[i].foreground
			tile.x 					= editor[i].x
			tile.y 					= editor[i].y
			
			if(editor[i].motion) then
				local line = editor[i].motion
				tile.motion = {
					x1 = line.x1,
					y1 = line.y1,
					x2 = line.x2,
					y2 = line.y2
				}
			end

			if(editor[i].dragLine) then
				local line = editor[i].dragLine
				tile.motion = {
					x1 = line.x1,
					y1 = line.y1,
					x2 = line.x2,
					y2 = line.y2
				}
			end

			GLOBALS.levelEditor.tiles[numTile] = tile
			numTile = numTile + 1
		end
		
		if(editor[i].isEnergy) then
			local energy = {}
			energy.type 	= editor[i].type
			energy.x 		= editor[i].x
			energy.y 		= editor[i].y

			GLOBALS.levelEditor.energies[numEnergy] = energy
			numEnergy = numEnergy + 1
		end

	end

	--------------------------------------
	
	GLOBALS.levelEditor.groupMotions = {}
	
	for k,groupMotion in pairs(groupMotions) do

		local line = groupMotion

		GLOBALS.levelEditor.groupMotions[k]  = {
			x1 = line.x1,
			y1 = line.y1,
			x2 = line.x2,
			y2 = line.y2
		}

	end

	--------------------------------------

	if(not GLOBALS.levelEditor.groupDragLines) then
		GLOBALS.levelEditor.groupDragLines = {}
	end
	
	--------------------------------------
	
	GLOBALS.levelEditor.lastGroup = currentGroup
	
	--------------------------------------

	utils.saveTable(GLOBALS.levelEditor, "levelEditor/levelEditor.json", system.ResourceDirectory)

end

------------------------------------------

function scene:addTile(sheet, num, x, y)
	
	stateDrawing()
	
	if(not x) then
   	if(not selectedTile) then
   	   selectedTile = {}
      	selectedTile.x = display.contentWidth/2 - editor.x
      	selectedTile.y = display.contentHeight/2 - editor.y
      	selectedTile.width = 0
   	end
   	
   	x = selectedTile.x + selectedTile.width - 0.7 
   	y = selectedTile.y
	end
	
	local tile = levelDrawer.drawTile(editor, sheet, num, x, y)
	tile.isTile = true
	tile.icons = {}
	
   tile:addEventListener( "touch", function(event)
   	self:touchTile(tile, event)
	end )

	selectedTile = tile

	return tile
end

------------------------------------------

function scene:deleteTile(tile)
	selectedTile = {}
	selectedTile.x = tile.x - tile.width
	selectedTile.y = tile.y
	selectedTile.width = tile.width
	
	self:unsetMovable(tile)

	if(tile.group) then
		self:removeFromGroup(tile)
	end

	display.remove(tile)
	
	tile = nil
	
end

------------------------------------------

function scene:changeGroup(tile)

	self:unsetMovable(tile) -- unset le group
	
	if(tile.group) then
		self:removeFromGroup(tile)
	else
		self:addToGroup(tile)
	end

end

------------------------------------------

function scene:addToGroup(tile)
	
	tile.group = currentGroup
	tile.iconGroup = levelDrawer.drawTile( editor, levelDrawer.TILES, tile.group, tile.x, tile.y )
	tile.iconGroup:scale(0.3,0.3)

	tile.isInGroup = true
	
	if(not groups[tile.group]) then
		groups[tile.group] = {}
	end
	
	table.insert(groups[tile.group], tile)
end

------------------------------------------

function scene:removeFromGroup(tile)
	utils.removeFromTable(groups[tile.group], tile)
	display.remove(tile.iconGroup)

	tile.group 		= nil
	tile.iconGroup = nil
	tile.isInGroup = false
end


-------------------------------------------------------------------------------------
-- 				MOVABLE PART
-------------------------------------------------------------------------------------


function scene:changeMoveAbility(tile)

	if(tile.movable) then
		self:unsetMovable(tile)
	else
		self:setMovable(tile)
	end

	dontListenThisTouchScreen = true
end

function scene:setMovable(tile)

	if(tile.group) then
		for k,v in pairs(groups[tile.group]) do
			groups[tile.group][k].movable = true
		end 
		
		self:drawIcon(groups[tile.group][1], "movable")
		selectedGroup = tile.group
	else
		tile.movable = true
		self:drawIcon(tile, "movable")
		selectedGroup = nil
		selectedTile = tile
	end
	
end

function scene:unsetMovable(tile)
	
	if(tile.group) then
		for k,v in pairs(groups[tile.group]) do
			groups[tile.group][k].movable = false
		end 
		
		display.remove(groups[tile.group][1].iconMovable)
		self:deleteGroupMotion(tile.group)
	else
		tile.movable = false
		self:deleteTileMotion(tile)

		display.remove(tile.iconMovable)
		tile.iconMovable = nil
	end
	
	selectedGroup 	= nil
	selectedTile 	= nil
end

--- delete the motion line
function scene:deleteGroupMotion(group)
	if(groupMotions[group]) then
		display.remove(groupMotions[group])
		groupMotions[group] = nil
	end
end

function scene:deleteTileMotion(tile)
	if(tile.motion) then
		display.remove(tile.motion)
		tile.motion = nil
	end
end

------------------------------------------

function scene:drawGroupMotion(group, x1,y1, x2,y2)
	self:deleteGroupMotion(group)
	local line = self:drawMotionLine(x1,y1, x2,y2)
	groupMotions[group] = line
end

function scene:drawMotionLine(x1,y1, x2,y2)

	local line = display.newLine( editor, x1,y1, x2,y2)
	line.x1 = x1
	line.y1 = y1
	line.x2 = x2
	line.y2 = y2
	
	return line
end

------------------------------------------

function scene:drawMovableIcon(tile)
	tile.iconMovable = levelDrawer.drawTile( editor, levelDrawer.TILES, 65, tile.x - 20 , tile.y - 20 )
	tile.iconMovable:scale(0.4,0.4)
end



-------------------------------------------------------------------------------------
-- 	DRAGGABLE PART : TODO : factoriser movable + draggable
-------------------------------------------------------------------------------------



function scene:changeDragAbility(tile)

	if(tile.draggable) then
		self:unsetDraggable(tile)
	else
		self:setDraggable(tile)
	end

	dontListenThisTouchScreen = true
end

function scene:setDraggable(tile)

	if(tile.group) then
		for k,v in pairs(groups[tile.group]) do
			groups[tile.group][k].draggable = true
		end 
		
		if(not GLOBALS.levelEditor.groupDragLines[tile.group]) then
			GLOBALS.levelEditor.groupDragLines[tile.group] = {}
		end
		
		self:drawIcon(groups[tile.group][1], "draggable")
		selectedGroup = tile.group
	else
		tile.draggable = true
		self:drawIcon(tile, "draggable")
		selectedGroup = nil
		selectedTile = tile
	end
	
end

function scene:unsetDraggable(tile)
	
	if(tile.group) then
		for k,v in pairs(groups[tile.group]) do
			groups[tile.group][k].draggable = false
		end 
		
		display.remove(groups[tile.group][1].iconDraggable)
		self:deleteGroupDragLine(tile.group)
	else
		tile.movable = false
		self:deleteTileDragLine(tile)

		display.remove(tile.iconDraggable)
		tile.iconDraggable = nil
	end
	
	selectedGroup 	= nil
	selectedTile 	= nil
end

--- delete the motion line
function scene:deleteGroupDragLine(group)
	if(editor.dragLines[group]) then
		display.remove(editor.dragLines[group])
		editor.dragLines[group] = nil
		GLOBALS.levelEditor.groupDragLines[group] = nil
	end
end

function scene:deleteTileDragLine(tile)
	if(tile.dragLine) then
		display.remove(tile.dragLine)
		tile.dragLine = nil
	end
end

------------------------------------------

function scene:drawGroupDragLine(group, groupDraggable)
	self:deleteGroupDragLine(group)
	local line = self:drawDragLine(groupDraggable.x1, groupDraggable.y1, groupDraggable.x2, groupDraggable.y2)
	editor.dragLines[group] = line
end

function scene:drawDragLine(x1,y1, x2,y2)

	local line = display.newLine( editor, x1,y1, x2,y2)
	line.x1 = x1
	line.y1 = y1
	line.x2 = x2
	line.y2 = y2
	
	return line
end


-------------------------------------------------------------------------------------
-- 		COMMON ? PART
-------------------------------------------------------------------------------------


function scene:changeState(tile, property)
	print("changeState " .. property)
	if(tile[property]) then
		self:unsetProperty(tile, property)
	else
		self:setProperty(tile, property)
	end

	dontListenThisTouchScreen = true
end

function scene:setProperty(tile, property)

	if(tile.group) then
		for k,v in pairs(groups[tile.group]) do
			groups[tile.group][k][property] = true
		end 
		
		self:drawIcon(groups[tile.group][1], property)
		selectedGroup = tile.group
	else
		print(tile.num, tile.group, property)
		tile[property] = true
		self:drawIcon(tile, property)
		selectedGroup = nil
		selectedTile = tile
	end
	
end

function scene:unsetProperty(tile, property)
	
	if(tile.group) then
		for k,v in pairs(groups[tile.group]) do
			groups[tile.group][k][property] = false
		end 
		
		display.remove(groups[tile.group][1].icons[property])
		groups[tile.group][1].icons[property] = nil
	else
		tile[property] = false
		display.remove(tile.icons[property])
		tile.icons[property] = nil
	end
	
	selectedGroup 	= nil
	selectedTile 	= nil
end

------------------------------------------

function scene:getImage(property)
	if(property == "movable") then
		return ENABLING_MOVE
	end
	if(property == "draggable") then
		return ENABLING_DRAG
	end
	if(property == "destructible") then
		return SET_DESTRUCTIBLE
	end
	if(property == "background") then
		return SET_BACKGROUND
	end
	if(property == "foreground") then
		return SET_FOREGROUND
	end
end

------------------------------------------

function scene:drawIcon(tile, property)
	
	local image = scene:getImage(property)
	print("draw icon " .. property .. " image " .. image)

	local num = 1
	for k,v in pairs(tile.icons) do
		num = num + 1
	end 

	tile.icons[property]= levelDrawer.drawTile( editor, levelDrawer.TILES, image, tile.x - 15*num , tile.y - 20 )
	tile.icons[property]:scale(0.4,0.4)
end



--------------------------------------------------------------------------------------------------
-- Energies
--------------------------------------------------------------------------------------------------

function scene:drawEnergy(x, y, type)

	local energy = display.newImage( editor, "assets/images/game/planet.white.png" )
	energy.x = x 
	energy.y = y
	energy.isEnergy 	= true
	energy.type 		= type 

	local scaleAmount = 0.04
	if(type == MEDIUM_ENERGY) then scaleAmount = 0.08 end
	if(type == BIG_ENERGY) then scaleAmount = 0.12 end

	energy:scale(scaleAmount, scaleAmount)

	energy:addEventListener( "touch", function(event)
		self:touchTile(energy, event)
	end )
end

--------------------------------------------------------------------------------------------------
-- TOUCHES - ACTIONS
--------------------------------------------------------------------------------------------------

function scene:touchScreen( event )

	if(event.phase == "began") then
		
		if(dontListenThisTouchScreen) then
			dontListenThisTouchScreen = false
			return
		end
		
		if(state == ENABLING_MOVE) then

   		if(selectedGroup) then
				local x1 = (groups[selectedGroup][1].x + groups[selectedGroup][#groups[selectedGroup]].x  )/2
				local y1 = (groups[selectedGroup][1].y + groups[selectedGroup][#groups[selectedGroup]].y  )/2
				local x2 = event.x - editor.x
				local y2 = event.y - editor.y
				self:drawGroupMotion(selectedGroup, x1,y1, x2,y2)
			
			elseif(selectedTile) then
				self:deleteTileMotion(selectedTile)

   			local line = display.newLine( editor, selectedTile.x,selectedTile.y, event.x, event.y )
   			line.x1 = selectedTile.x
   			line.y1 = selectedTile.y
   			line.x2 = event.x - editor.x
   			line.y2 = event.y - editor.y

				selectedTile.motion = line
      	end

		
		elseif(state == ENABLING_DRAG) then

   		if(selectedGroup) then
				local groupDraggable = GLOBALS.levelEditor.groupDragLines[selectedGroup]
				groupDraggable.x1 = (groups[selectedGroup][1].x + groups[selectedGroup][#groups[selectedGroup]].x  )/2
				groupDraggable.y1 = (groups[selectedGroup][1].y + groups[selectedGroup][#groups[selectedGroup]].y  )/2
				groupDraggable.x2 = event.x - editor.x
				groupDraggable.y2 = event.y - editor.y
				
				self:drawGroupDragLine(selectedGroup, groupDraggable)
			
			elseif(selectedTile) then
				self:deleteTileDragLine(selectedTile)

   			local line = display.newLine( editor, selectedTile.x,selectedTile.y, event.x, event.y )
   			line.x1 = selectedTile.x
   			line.y1 = selectedTile.y
   			line.x2 = event.x - editor.x
   			line.y2 = event.y - editor.y

				selectedTile.dragLine = line
      	end
   	
		
		elseif(state == DRAWING_ENERGY) then
   		local x = event.x - editor.x
   		local y = event.y - editor.y
   		self:drawEnergy(x, y, selectedEnergyType)

   	end
	end
	
end	

------------------------------------------

function scene:touchTile(tile, event)

	if(event.phase == "began") then

		if(state == ERASING) then
			self:deleteTile(tile)
			return

		elseif(state == GROUPING) then
			self:changeGroup(tile)
			return

		elseif(state == ENABLING_MOVE) then
			self:changeMoveAbility(tile)
			return

		elseif(state == ENABLING_DRAG) then
			self:changeDragAbility(tile)
			return

		elseif(state == SET_DESTRUCTIBLE) then
			self:changeState(tile, "destructible")
			return

		elseif(state == SET_BACKGROUND) then
			self:changeState(tile, "background")
			return

		elseif(state == SET_FOREGROUND) then
			self:changeState(tile, "foreground")
			return

		end

		if(isDragging) then return end
	end

	if(state == DRAWING) then
   	isDragging = true
   	display.getCurrentStage():setFocus( event.target )
   	self:dragTile(tile, event) 
	end

	if(event.phase == "ended") then
   	display.getCurrentStage():setFocus( nil )
		isDragging = false
	end
	
end

------------------------------------------

function scene:dragTile(tile, event)

	if(tile.group) then
		for i=1, #groups[tile.group] do

			touchController.drag(groups[tile.group][i], event)

			if(groups[tile.group][i].isInGroup) then 
				touchController.drag(groups[tile.group][i].iconGroup, event)
			end 

   		for k,icon in pairs(groups[tile.group][i].icons) do
   			if(icon) then
      			touchController.drag(icon, event)
      		end
   		end
		end

	
		
--		if(groups[tile.group][1].movable) then 
--			touchController.drag(groups[tile.group][1].icons["movable"], event)
--		end 
--
--		if(groups[tile.group][1].draggable) then 
--			touchController.drag(groups[tile.group][1].icons["draggable"], event)
--		end 
--
--		if(groups[tile.group][1].destructible) then 
--			touchController.drag(groups[tile.group][1].icons["destructible"], event)
--		end 
--
--		if(groups[tile.group][1].background) then 
--			touchController.drag(groups[tile.group][1].icons["background"], event)
--		end 
--
--		if(groups[tile.group][1].foreground) then 
--			touchController.drag(groups[tile.group][1].icons["foreground"], event)
--		end 
		
		if(groupMotions[tile.group]) then
			local line = groupMotions[tile.group]
			local previousX = line.x
			local previousY = line.y
			touchController.drag(line, event)
			line.x1 = line.x
			line.y1 = line.y
			line.x2 = line.x2 + line.x - previousX
			line.y2 = line.y2 + line.y - previousY
		end
		
		if(editor.dragLines[tile.group]) then
			local line = editor.dragLines[tile.group]
			local previousX = line.x
			local previousY = line.y
			touchController.drag(line, event)
			line.x1 = line.x
			line.y1 = line.y
			line.x2 = line.x2 + line.x - previousX
			line.y2 = line.y2 + line.y - previousY
			
			GLOBALS.levelEditor.groupDragLines[tile.group].x1 = line.x1
			GLOBALS.levelEditor.groupDragLines[tile.group].x2 = line.x2
			GLOBALS.levelEditor.groupDragLines[tile.group].y1 = line.y1
			GLOBALS.levelEditor.groupDragLines[tile.group].y2 = line.y2
		end
	else
		touchController.drag(tile, event)

		if(tile.movable) then 
			touchController.drag(tile.iconMovable, event)
		end 

		if(tile.draggable) then 
			touchController.drag(tile.iconDraggable, event)
		end 

		if(tile.draggable) then 
			touchController.drag(tile.iconDestructible, event)
		end 
		
		if(tile.motion) then
			touchController.drag(tile.motion, event)
		end
	end

end

------------------------------------------
--	local options =
--	{
--		to = "chris.dugne@gmail.com",
--		subject = "My High Score",
--		body = "I scored over 9000!!! Can you do better?"
--	}
--	native.showPopup("mail", options)

------------------------------------------

-- Called immediately after scene has moved onscreen:
function scene:enterScene( event )
	self:refreshScene();
end


-- Called when scene is about to move offscreen:
function scene:exitScene( event )
end

-- If scene's view is removed, scene:destroyScene() will be called just prior to:
function scene:destroyScene( event )
end

-----------------------------------------------------------------------------------------
-- END OF YOUR IMPLEMENTATION
-----------------------------------------------------------------------------------------

-- "createScene" event is dispatched if scene's view does not exist
scene:addEventListener( "createScene", scene )

-- "enterScene" event is dispatched whenever scene transition has finished
scene:addEventListener( "enterScene", scene )

-- "exitScene" event is dispatched whenever before next scene's transition begins
scene:addEventListener( "exitScene", scene )

-- "destroyScene" event is dispatched before view is unloaded, which can be
-- automatically unloaded in low memory situations, or explicitly via a call to
-- storyboard.purgeScene() or storyboard.removeScene().
scene:addEventListener( "destroyScene", scene )

-----------------------------------------------------------------------------------------

return scene