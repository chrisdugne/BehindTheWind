-----------------------------------------------------------------------------------------
--
-- AppHome.lua
--
-----------------------------------------------------------------------------------------

local scene = storyboard.newScene()

-----------------------------------------------------------------------------------------

local tileSelection = display.newGroup()
local editor = display.newGroup()
local selectedTile
local groups = {}

local DRAWING 	= 1
local ERASING 	= 2
local GROUPING = 3

local state = DRAWING
local erase, grouping
local currentGroup = 0

-----------------------------------------------------------------------------------------
-- BEGINNING OF YOUR IMPLEMENTATION
-- 
-- NOTE: Code outside of listener functions (below) will only be executed once,
--		 unless storyboard.removeScene() is called.
-- 
-----------------------------------------------------------------------------------------

-- Called when the scene's view does not exist:
function scene:createScene( event )
end

-----------------------------------------------------------------------------------------

-- Called when the scene's view does not exist:
function scene:refreshScene()
	
	viewManager.initView(self.view);
	
	------------------------------
	
   for num = 1, 110 do
		local tile = levelDrawer.drawTile( tileSelection, num, num*40, 20 )
      tile:addEventListener( "touch", function(event) if(event.phase == "began") then self:addTile(num) end end )
	end
   
	-------------------------------------

	local down = display.newImage( "assets/images/tutorial/arrow.down.png" )
	down.x = 20
	down.y = 70
	down:scale(0.1,0.1)
   down:addEventListener( "touch", function(event) if(event.phase == "began") then editor.y = editor.y + 50 end end )

	local up = display.newImage( "assets/images/tutorial/arrow.top.png" )
	up.x = 20
	up.y = 55
	up:scale(0.1,0.1)
   up:addEventListener( "touch", function(event) if(event.phase == "began") then editor.y = editor.y - 50 end end )

	local left = display.newImage( "assets/images/tutorial/arrow.left.png" )
	left.x = 13
	left.y = 62
	left:scale(0.1,0.1)
   left:addEventListener( "touch", function(event) if(event.phase == "began") then editor.x = editor.x - 50 end end )

	local right = display.newImage( "assets/images/tutorial/arrow.right.png" )
	right.x = 27
	right.y = 62
	right:scale(0.1,0.1)
   right:addEventListener( "touch", function(event) if(event.phase == "began") then editor.x = editor.x + 50 end end )

	-------------------------------------

	local selectionLeft = display.newImage( "assets/images/tutorial/arrow.left.png" )
	selectionLeft.x = 50
	selectionLeft.y = 62
	selectionLeft:scale(0.1,0.1)
   selectionLeft:addEventListener( "touch", function(event) if(event.phase == "began") then tileSelection.x = tileSelection.x + 300 end end )

	local selectionRight = display.newImage( "assets/images/tutorial/arrow.right.png" )
	selectionRight.x = 65
	selectionRight.y = 62
	selectionRight:scale(0.1,0.1)
   selectionRight:addEventListener( "touch", function(event) if(event.phase == "began") then tileSelection.x = tileSelection.x - 300 end end )

	-------------------------------------
	
	erase = levelDrawer.drawTile( self.view, 2, 96, 62 )
	erase:scale(0.5,0.5)
   erase:addEventListener( "touch", function(event) 
   	if(event.phase == "began") then
   		stateErasing()
   	end 
  	end )

	-------------------------------------
	
	grouping = levelDrawer.drawTile( self.view, 20, 125, 62 )
	grouping:scale(0.5,0.5)
   grouping:addEventListener( "touch", function(event) 
   	if(event.phase == "began") then
   		stateGrouping()
   	end 
  	end )

	-------------------------------------

	local export = levelDrawer.drawTile( self.view, 4, display.contentWidth - 15, 62 )
	export:scale(0.5,0.5)
	export:addEventListener( "touch", function(event) 
		if(event.phase == "began") then
			
			GLOBALS.levelEditor = {}
			GLOBALS.levelEditor.tiles = {}
			
			local num = 1
			for i=editor.numChildren,1,-1 do
				
				if(not editor[i].isIcon) then
   				local tile = {}
   				tile.num 		= editor[i].num
   				tile.group 		= editor[i].group
   				tile.x 			= editor[i].x
   				tile.y 			= editor[i].y
   				
   				GLOBALS.levelEditor.tiles[num] = tile
   				num = num + 1
				end
				
			end

			GLOBALS.levelEditor.lastGroup = currentGroup
			
			utils.tprint(GLOBALS.levelEditor)
			utils.saveTable(GLOBALS.levelEditor, "levelEditor/levelEditor.json", system.ResourceDirectory)
			
		end 
	end )

	-------------------------------------

	local import = levelDrawer.drawTile( self.view, 9, display.contentWidth - 35, 62 )
	import:scale(0.5,0.5)
	import:addEventListener( "touch", function(event) 
		if(event.phase == "began") then
			utils.emptyGroup(editor)
			
			local tiles = GLOBALS.levelEditor.tiles
			
			for i=1, #tiles do
				local tile = self:addTile(tiles[i].num, tiles[i].x, tiles[i].y)
				if(tiles[i].group) then
					tile.group = tiles[i].group
   	 			drawIcon(tile)
   	 		end
   		end 
			
			currentGroup = GLOBALS.levelEditor.lastGroup
			selectedTile = nil
		end 
	end )
end

------------------------------------------

function resetStates()
	if(state == ERASING) then
		erase:scale(0.5,0.5)
	end
	if(state == GROUPING) then
		grouping:scale(0.5,0.5)
	end
end
------------------------------------------

function stateDrawing()
	resetStates()
	state = DRAWING
end

------------------------------------------

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
--	local options =
--	{
--		to = "chris.dugne@gmail.com",
--		subject = "My High Score",
--		body = "I scored over 9000!!! Can you do better?"
--	}
--	native.showPopup("mail", options)

------------------------------------------

function scene:addTile(num, x, y)
	
	stateDrawing()
	
	if(not x) then
   	if(not selectedTile) then
   	   selectedTile = {}
      	selectedTile.x = display.contentWidth/2
      	selectedTile.y = display.contentHeight/2
      	selectedTile.width = 0
   	end
   	
   	x = selectedTile.x + selectedTile.width - 0.7 
   	y = selectedTile.y
	end
	
	local tile = levelDrawer.drawTile(editor, num, x, y)
	
   tile:addEventListener( "touch", function(event)
   	 if(event.phase == "began") then
   	 	if(state == ERASING) then
   	 		selectedTile = {}
         	selectedTile.x = tile.x - tile.width
         	selectedTile.y = tile.y
         	selectedTile.width = tile.width
   	 		display.remove(tile.icon)
   	 		display.remove(tile)
   	 		return
   	 	end
   	 	
   	 	if(state == GROUPING) then
   	 		if(tile.group) then
   	 			tile.group = nil
   	 			display.remove(tile.icon)
   	 		else
   	 			tile.group = currentGroup
   	 			drawIcon(tile)
   			end

				return
			end

			if(isDragging) then return end
		end
		isDragging = true
		selectedTile = tile 

		-----

		if(tile.group) then
			for i=1, #groups[tile.group] do
				touchController.drag(groups[tile.group][i], event)
				
				if(groups[tile.group][i].icon) then 
					touchController.drag(groups[tile.group][i].icon, event)
				end 
			end
		else
			touchController.drag(tile, event)
		end

		-----

		if(event.phase == "ended") then
			isDragging = false
		end
	end )

	selectedTile = tile
	
	return tile
end

------------------------------------------

function drawIcon(tile)
	tile.icon = levelDrawer.drawTile( editor, tile.group, tile.x, tile.y )
	tile.icon:scale(0.2,0.2)
	tile.icon.isIcon = true
	
	if(not groups[tile.group]) then
		groups[tile.group] = {}
	end
	
	table.insert(groups[tile.group], tile)
end

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