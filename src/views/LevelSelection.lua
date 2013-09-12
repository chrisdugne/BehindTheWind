-----------------------------------------------------------------------------------------
--
-- LevelSelection
--
-----------------------------------------------------------------------------------------

local scene = storyboard.newScene()
local levels

-----------------------------------------------------------------------------------------
-- BEGINNING OF YOUR IMPLEMENTATION
-- 
-- NOTE: Code outside of listener functions (below) will only be executed once,
--		 unless storyboard.removeScene() is called.
-- 
-----------------------------------------------------------------------------------------

-- Called when the scene's view does not exist:
function scene:createScene( event )
	levels = display.newGroup()
end

-----------------------------------------------------------------------------------------

function scene:refreshScene()
	utils.emptyGroup(levels)

	game.level = 0
	game.scene = self.view
	hud.setBackToHome()
	
	local margin = display.contentWidth/2 -5*38 

   for level = 1, 40 do
   	local i = (level-1)%10 
   	local j = math.floor((level-1)/10) + 1
   	local levelLocked
   	
   	if(level > 1) then
   		print("--> " .. level)
			levelLocked = not GLOBALS.savedData.levels[level - 1] or not GLOBALS.savedData.levels[level - 1].complete
		end
	
	
   	viewManager.buildButton(
   		level,
   		"white",
   		21, 
   		0.13,
			margin + 42 * i, 
			65 * j, 
			function() 
				openLevel(level) 
			end, 
			levelLocked
   	)

   end
	
	self.view:insert(levels)
end

------------------------------------------

function openLevel( level )
	if(game.level == 0) then
   	if(not GLOBALS.savedData.fullGame and level > 10) then
   		router.openBuy()
   	else
      	game.level = level
      	router.openPlayground()
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