-----------------------------------------------------------------------------------------
--
-- chapterselection
--
-----------------------------------------------------------------------------------------

local scene = storyboard.newScene()
local chapters

-----------------------------------------------------------------------------------------
-- BEGINNING OF YOUR IMPLEMENTATION
-- 
-- NOTE: Code outside of listener functions (below) will only be executed once,
--		 unless storyboard.removeScene() is called.
-- 
-----------------------------------------------------------------------------------------

-- Called when the scene's view does not exist:
function scene:createScene( event )
	chapters = display.newGroup()
end

-----------------------------------------------------------------------------------------

function scene:refreshScene()
	utils.emptyGroup(chapters)

	game.level = 0
	game.scene = self.view
	hud.setBackToHome()
	
	local margin = display.contentWidth*0.1 

   for chapter = 1, #CHAPTERS do
   	local i = (chapter-1)%10 
   	local j = math.floor((chapter-1)/10) + 1
   	local chapterLocked
   	
   	if(chapter > 1) then
			chapterLocked = not GLOBALS.savedData.chapters[chapter-1].complete or not GLOBALS.savedData.fullGame
		end
	
   	viewManager.buildButton(
   		chapter,
   		"white",
   		51, 
   		0.28*aspectRatio,
			margin + display.contentWidth*0.085 * i, 
			display.contentHeight*0.2 * j, 
			function() 
				openChapter(chapter) 
			end, 
			chapterLocked
   	)

   end
	
	self.view:insert(chapters)
end

------------------------------------------

function openChapter( chapter )
	game.chapter = chapter
	router.openLevelSelection()
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