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
end

-----------------------------------------------------------------------------------------

function scene:refreshScene()

	game.level = 0
	game.scene = self.view

	---------------------------------------------------------------
	
	viewManager.buildEffectButton(
		game.hud,
		"assets/images/hud/back.png",
		51, 
		0.18*aspectRatio,
		display.contentWidth*0.1, 
		display.contentHeight*0.1, 
		function() 
			router.openAppHome()
		end
	)
	
	---------------------------------------------------------------
	
	game.hud.title = display.newImage( game.hud, "assets/images/hud/title.png" )
	game.hud.title.x = display.contentWidth*0.7
	game.hud.title.y = display.contentHeight*0.1
	game.hud.title:scale(0.38,0.38)
	
	effectsManager.atmosphere(display.contentWidth*0.7 - game.hud.title.contentWidth/2 + 20, 115, 0.76)
	effectsManager.atmosphere(display.contentWidth*0.8, 120, 0.9)

	game.hud.subtitle = display.newText( game.hud, "...there is Magic" , 0, 0, FONT, 25 )
	game.hud.subtitle:setTextColor( 255 )	
	game.hud.subtitle.x = display.contentWidth*0.86
	game.hud.subtitle.y = display.contentHeight*0.16
	game.hud.subtitle:setReferencePoint( display.CenterReferencePoint )
	
	-----------------------------------------------------
	
	self:createChapterContent(1, display.contentWidth*0.37, display.contentHeight*0.25, false)
	self:createChapterContent(2, display.contentWidth*0.1, display.contentHeight*0.55, not GLOBALS.savedData.chapters[1].complete or not GLOBALS.savedData.fullGame)
	self:createChapterContent(3, display.contentWidth*0.54, display.contentHeight*0.63, not GLOBALS.savedData.chapters[2].complete or not GLOBALS.savedData.fullGame)
	
end

-----------------------------------------------------------------------------------------

function scene:createChapterContent(chapter, x, y, locked)

	------------------
	
	local widget = display.newGroup()
	game.hud:insert(widget)
	widget.x = x
	widget.y = y
	widget.alpha = 0
	
	if(not locked) then
   	utils.onTouch(widget, function() 
   		openChapter(chapter) 
   	end)
   end
   	
	------------------

   local box = display.newRoundedRect(widget, 0, 0, display.contentWidth*0.33, 200, 10)
   box.alpha = 0.3
   box:setFillColor(0)
   
   if(not locked) then
      box.alpha = 0.4
   end
   

	------------------
	
	viewManager.buildEffectButton(
		game.hud,
		chapter,
		51, 
		0.67,
		x+display.contentWidth*0.2, 
		y+display.contentHeight*0.12, 
		function() 
			openChapter(chapter) 
		end, 
		locked
	)
	
	------------------

   local chapterTitle = display.newText( {
		parent = widget,
		text = CHAPTERS[chapter].title,     
		x = display.contentWidth*0.16,
		y = 20,
		width = display.contentWidth*0.3,    
		font = FONT,   
		fontSize = 27,
		align = "right"
	} )
	
	------------------

	local energies = display.newImage( widget, "assets/images/hud/energy.png")
	energies.x = 25
	energies.y = display.contentHeight*0.07
	energies:scale(0.5,0.5)
	
	local energiesCaught  = 0
	local energiesToCatch = 0
	
	for i=1,CHAPTERS[chapter].nbLevels do
		energiesCaught	 = energiesCaught + GLOBALS.savedData.chapters[chapter].levels[i].score.energiesCaught 
		energiesToCatch = energiesToCatch + #CHAPTERS[chapter].levels[i].energies 
	end
	
   local energiesText = display.newText( {
		parent = widget,
		text = energiesCaught .. "/" .. energiesToCatch,     
		x = 110,
		y = display.contentHeight*0.068,
		width = 100,    
		font = FONT,   
		fontSize = 28,
		align = "left"
	} )

	------------------
	
	local piecesCaught  = 0
	local piecesToCatch = CHAPTERS[chapter].nbLevels
	
	for i=1,CHAPTERS[chapter].nbLevels do
		piecesCaught	 = piecesCaught + GLOBALS.savedData.chapters[chapter].levels[i].score.piecesCaught 
	end
	
	local piece = display.newSprite( widget, levelDrawer.pieceImageSheet, levelDrawer.pieceSheetConfig:newSequence() )
	piece.x 			= 25
	piece.y 			= display.contentHeight*0.11
	if(piecesCaught > 0) then
		piece:play()
	else
   	piece.alpha = 0.2
	end
	
   local piecesText = display.newText( {
		parent = widget,
		text = piecesCaught .. "/" .. piecesToCatch,     
		x = 110,
		y = display.contentHeight*0.108,
		width = 100, 
		font = FONT,   
		fontSize = 28,
		align = "left"
	} )
	
	------------------

	local ringsCaught  = 0
	local ringsToCatch = CHAPTERS[chapter].nbLevels
	
	for i=1,CHAPTERS[chapter].nbLevels do
		ringsCaught	 = ringsCaught + GLOBALS.savedData.chapters[chapter].levels[i].score.ringsCaught 
	end
	
	local ring = display.newSprite( widget, levelDrawer.simplePieceImageSheet, levelDrawer.pieceSheetConfig:newSequence() )
	ring.x 		= 25
	ring.y 		= display.contentHeight*0.15
	if(ringsCaught > 0) then
		ring:play()
	else
   	ring.alpha = 0.2
	end
	
   local ringsText = display.newText( {
		parent = widget,
		text = ringsCaught .. "/" .. ringsToCatch,     
		x = 110,
		y = display.contentHeight*0.148,
		width = 100, 
		font = FONT,   
		fontSize = 28,
		align = "left"
	} )
	

	------------------
	
	local points = 0
	
	for i=1,CHAPTERS[chapter].nbLevels do
		points	 = points + GLOBALS.savedData.chapters[chapter].levels[i].score.points 
	end
	
	
	if(points > 0) then

      local pointsText = display.newText( {
			parent = widget,
			text = points .. " pts",     
			x = display.contentWidth*0.23,
			y = 175,
			width = 200,            --required for multiline and alignment
			height = 40,           --required for multiline and alignment
			font = FONT,   
			fontSize = 24,
			align = "right"
		} )
   
   end

	------------------
	
	local percent = math.floor(100* ((0.5)*(energiesCaught/energiesToCatch) + (0.25)*(ringsCaught/ringsToCatch) + (0.25)*(piecesCaught/piecesToCatch)))

   local percentText = display.newText( {
		parent = widget,
		text = percent .. " %",     
		x = display.contentWidth*0.105,
		y = 165,
		width = 200,            --required for multiline and alignment
		height = 40,           --required for multiline and alignment
		font = FONT,   
		fontSize = 35,
		align = "right"
	} )
	
	------------------
	
	if(locked) then
   	transition.to( widget, { time=500, alpha=0.4 })
   else
   	transition.to( widget, { time=500, alpha=1 })
	end
	
	widget:toFront()
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