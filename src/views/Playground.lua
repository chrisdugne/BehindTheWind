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

	local level = require "src.game.levels.level1"
	
	---------------------

	viewManager.initView(self.view);
	viewManager.initBack()
	
	---------------------
	-- require camera
	---------------------
	
	local playerWalk = require("src.game.graphics.playerWalk")
	local camera = require("camera")
	local physics = require("physics")
	physics.start()
	physics.setGravity( 0, 9.8 )
	print(physics.getGravity())
	
	-----------------------------
	-- objects
	------------------------------

	local playerSheet = graphics.newImageSheet( "assets/images/game/player.walk.png", playerWalk.sheet )

	local character = display.newSprite( playerSheet, playerWalk.sequence )
	character.x = 100
	character.y = 19
	physics.addBody( character, { density = 1.0, friction = 1, bounce = 0.17} )
	character.isFixedRotation = true
--	animation:play()
	
	------------------------------

	display.getCurrentStage():addEventListener( "touch", function(event)
		print("touch screen !")
	end)
	
	------------------------------
	
	for i=1, #level do
   	local tile = levelDrawer.drawTile( self.view, level[i].num, level[i].x, level[i].y )
		physics.addBody( tile, "static", { friction=0.5, bounce=0 } )
		
		tile:addEventListener( "touch", function(event)
			touchController.translateUpDown(tile, event)
			character.y = character.y + 0.1
		end)
	end 
	
	-------------------------------------
	-- Here is the important part
	-- for moving the camera
	----------------------------------------
	-- you must insert all objects you created in camera like so:
--	camera:insert(ball)
--	camera:insert(object1)
--	camera:insert(ground)

--	--now to move the camera:
--	local function moveCamera(event)
--		camera.x = camera.x +2
--	end
--	
--	Runtime:addEventListener("enterFrame", moveCamera)

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