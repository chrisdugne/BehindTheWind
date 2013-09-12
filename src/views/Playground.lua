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
	-- init playground

	viewManager.initView(self.view);
	viewManager.initBack()
	
	------------------------------
	-- camera
		
	game:init()
	hud.initFollowRockButton()
	
	---------------------
	-- engines

	physicsManager.init()
	effectsManager.init()
	touchController.init()
	
	------------------------------
	-- level content
	
	levelDrawer.designLevel(function() self:displayScore() end)
	
	-----------------------------
	-- camera

	character.init()
   effectsManager.spawnEffect()

	------------------------------
	-- level foregrounds

	levelDrawer.bringForegroundToFront()
	levelDrawer.putBackgroundToBack()
end

------------------------------------------

function scene:displayScore()
	local top = display.newRect(self.view, 0, -display.contentHeight/5, display.contentWidth, display.contentHeight/5)
   top.alpha = 0
   top:setFillColor(0)
   
   local bottom = display.newRect(self.view, 0, display.contentHeight, display.contentWidth, display.contentHeight/5)
   bottom.alpha = 0
   bottom:setFillColor(0)

   local board = display.newRoundedRect(self.view, 0, 0, display.contentWidth/2, display.contentHeight/2, 20)
   board.x = display.contentWidth/2
   board.y = display.contentHeight/2
   board.alpha = 0
   board:setFillColor(0)
   
   game.camera:toBack()
   viewManager.putBackgroundToBack()
   
	transition.to( top, { time=800, alpha=1, y = top.contentHeight/2 })
	transition.to( bottom, { time=800, alpha=1, y = display.contentHeight - top.contentHeight/2 })  
	transition.to( board, { time=800, alpha=0.7, onComplete= function()  end})  
end

------------------------------------------

-- Called immediately after scene has moved onscreen:
function scene:enterScene( event )
	self:refreshScene();
end


-- Called when scene is about to move offscreen:
function scene:exitScene( event )
	Runtime:removeEventListener( "enterFrame", self.refreshCamera )
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