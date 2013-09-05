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
		
	utils.emptyGroup(camera)
	Runtime:addEventListener( "enterFrame", self.refreshCamera )
	--camera:scale(0.3,0.3)
	
	---------------------
	-- engines

	physicsManager.init()
	effectsManager.init()
	touchController.init()
	
	------------------------------
	-- level content
	
	levelDrawer.designLevel()
	
	-----------------------------
	-- camera

	character.init()

	------------------------------
	-- level foregrounds

end

------------------------------------------

function scene:refreshCamera()

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