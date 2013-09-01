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

-- Called when the scene's view does not exist:
function scene:createScene( event )
end

-----------------------------------------------------------------------------------------

-- Called when the scene's view does not exist:
function scene:refreshScene()
	
	---------------------

	local tiles 			= GLOBALS.level1.tiles
	local groupMotions 	= GLOBALS.level1.groupMotions
	
	---------------------

	viewManager.initView(self.view);
	viewManager.initBack()
	
	---------------------

	local physics = require("physics")
	physics.start()
	physics.setGravity( 0, 20 )
	
	-----------------------------

	character.init()
	
	------------------------------

	display.getCurrentStage():addEventListener( "touch", function(event)
		touchController.touchScreen(event)
	end)
	
	------------------------------

	local groups = {}
	
	for i=1, #tiles do

		--------------------

   	local tile = levelDrawer.drawTile( self.view, tiles[i].num, tiles[i].x, tiles[i].y )
		tile.group = tiles[i].group
		tile.movable = tiles[i].movable

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
		
		tile:addEventListener( "touch", function(event)
			touchController.dragTile(tile, groups, event)
		end)
	end 
	
	------------------------------
	
	for k,groupMotion in pairs(groupMotions) do
		if(groupMotion) then
			levelDrawer.addGroupMotion(groups[k], groupMotion)
		end
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