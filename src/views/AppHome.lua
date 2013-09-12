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

function scene:refreshScene()

	---------------------------------------------------------------
	
	title = display.newText( game.hud, APP_NAME, 0, 0, FONT, 30 )
	title:setTextColor( 255 )	
	title.x = display.contentWidth/2
	title.y = 45
	title:setReferencePoint( display.CenterReferencePoint )
	
	effectsManager.buttonEffect(title.x - title.width/3, title.y, 0.4)
	effectsManager.buttonEffect(title.x + title.width/2, title.y - title.height*0.4, 0.3)
	effectsManager.buttonEffect(display.contentWidth - 100, display.contentHeight -20, 0.45)

	---------------------------------------------------------------

	viewManager.buildButton(
		"assets/images/hud/play.png", 
		"white", 
		21, 
		0.36,
		display.contentWidth*0.5, 	
		display.contentHeight*0.5, 	
		function()
			if(GLOBALS.savedData.requireTutorial) then
				game.level = 1
				router.openPlayground()
			else
				router.openLevelSelection()
   		end
		end
	)

	---------------------------------------------------------------
	
	viewManager.buildButton(
		"assets/images/hud/settings.png", 
		"white",
		20,
		0.13,
		30, 
		display.contentHeight - 30, 
		function() 
			self:openOptions() 
		end
	)

	---------------------------------------------------------------
	
   if(IOS) then
   	timer.performWithDelay(600, gameCenter.init)
   end
   
end

------------------------------------------

function scene:openOptions()
	router.openOptions()	
end

function scene:openPodiums()
	router.openPodiums()	
end

------------------------------------------

-- Called immediately after scene has moved onscreen:
function scene:enterScene( event )
	self:refreshScene()
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