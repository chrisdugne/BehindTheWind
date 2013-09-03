-----------------------------------------------------------------------------------------
--
-- AppHome.lua
--
-----------------------------------------------------------------------------------------

local scene = storyboard.newScene()

-----------------------------------------------------------------------------------------
-- BEGINNING OF YOUR IMPLEMENTATION
-- 
-- NOTE: Code outside of listener functions (below) will only be executed once,
--		 unless storyboard.removeScene() is called.
-- 

-----------------------------------------------------------------------------------------

local camera = display.newGroup()

-----------------------------------------------------------------------------------------

-- Called when the scene's view does not exist:
function scene:createScene( event )
end

-----------------------------------------------------------------------------------------

-- Called when the scene's view does not exist:
function scene:refreshScene()
	
	---------------------

	local tiles 			= GLOBALS.level1.tiles
	local energies 		= GLOBALS.level1.energies
	local groupMotions 	= GLOBALS.level1.groupMotions
	local groupDragLines = GLOBALS.level1.groupDragLines
	
	---------------------

	viewManager.initView(self.view);
	viewManager.initBack()
	
	utils.emptyGroup(camera)
	
	---------------------

	local physics = require("physics")
	physics.start()
	physics.setGravity( 0, 20 )
	
	------------------------------

	display.getCurrentStage():addEventListener( "touch", function(event)
		touchController.touchScreen(event)
	end)
	
	------------------------------

	local groups = {}
	
	for i=1, #tiles do

		--------------------

   	local tile 			= levelDrawer.drawTile( camera, tiles[i].num, tiles[i].x, tiles[i].y )
		tile.group 			= tiles[i].group
		tile.movable 		= tiles[i].movable
		tile.draggable 	= tiles[i].draggable
		
		tile.startX 		= tiles[i].x
		tile.startY 		= tiles[i].y
		tile.isFloor 		= true
		
		physics.addBody( tile, "static", { friction=0.3, bounce=0 } )
   	tile.isFixedRotation = true
		
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
		levelDrawer.drawEnergy(camera, energies[i].x, energies[i].y, energies[i].type)
	end 
	
	------------------------------
	
	for k,groupMotion in pairs(groupMotions) do
		if(groupMotion) then
			levelDrawer.addGroupMotion(groups[k], groupMotion)
		end
	end

	------------------------------
	
	for k,groupDragLine in pairs(groupDragLines) do
		if(groupDragLine) then
			levelDrawer.addGroupDraggable(groups[k], groupDragLine)
		end
	end

	------------------------------

	character.init(camera)
	
	-----------------------------
	
	Runtime:addEventListener( "enterFrame", self.refreshCamera )
	
	--camera:scale(0.3,0.3)
end

------------------------------------------

function scene:refreshCamera( )

	local leftDistance 		= character.sprite.x + camera.x
	local rightDistance 		= display.contentWidth - leftDistance

	local topDistance 		= character.sprite.y + camera.y
	local bottomDistance 	= display.contentHeight - topDistance
	
	if(rightDistance < display.contentWidth*0.38) then
		camera.x = - character.sprite.x + display.contentWidth*0.62
	elseif(leftDistance < display.contentWidth*0.38) then
		camera.x = - character.sprite.x + display.contentWidth*0.38
	end

	if(bottomDistance < display.contentHeight*0.28) then
		camera.y = - character.sprite.y + display.contentHeight*0.72
	elseif(topDistance < display.contentHeight*0.28) then
		camera.y = - character.sprite.y + display.contentHeight*0.28
	end
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