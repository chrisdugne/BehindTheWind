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

	-----------------------------------------------------

	viewManager.buildEffectButton(
		"assets/images/hud/back.png",
		51, 
		0.18*aspectRatio,
		display.contentWidth*0.1, 
		display.contentHeight*0.1, 
		function() 
			router.openChapterSelection()
		end
	)
		
	-----------------------------------------------------
	
	effectsManager.atmosphere(display.contentWidth*0.7, 110, 1.36)
	effectsManager.atmosphere(display.contentWidth*0.9, 110, 1.12)

   game.hud.chaptertitle = display.newText( {
		parent 	= game.hud,
		text 		= CHAPTERS[game.chapter].title,     
		x 			= display.contentWidth*0.69,
		y 			= display.contentHeight*0.07,
		width 	= display.contentWidth*0.5,            --required for multiline and alignment
		font 		= FONT,   
		fontSize = 55,
		align 	= "right"
	} )
	
	-----------------------------------------------------
	
	local marginLeft = display.contentWidth*0.08 
	local marginTop, heightRatio
	 
	local n = CHAPTERS[game.chapter].nbLevels
	local nbPerLine = 4
	
	if(n < 9) then
		marginTop 	= 50
		heightRatio = 0.3
	else
		marginTop 	= 95
		heightRatio = 0.28
	end

   for level = 1, n do
   	local i = (level-1)%nbPerLine
   	local j = math.floor((level-1)/nbPerLine) + 1
   	
		local x = marginLeft +  i * display.contentWidth  * 0.21
		local y = j * display.contentHeight * heightRatio - marginTop
		
   	local locked
   	
   	if(level > 1) then
			locked = not GLOBALS.savedData.chapters[game.chapter].levels[level - 1].complete
		end
	
		self:createLevelContent(level, x, y, locked)
	
   end
	
	self.view:insert(levels)
end

-----------------------------------------------------------------------------------------

function scene:createLevelContent(level, x, y, locked)
	
	------------------
	
	local widget = display.newGroup()
	widget.x = x
	widget.y = y
	widget.alpha = 0
	game.hud:insert(widget)
	
	utils.onTouch(widget, function() 
		openLevel(level) 
	end)
	
	if(locked) then
   	widget.alpha = 0.4
	end
	
	------------------
	
	local score = GLOBALS.savedData.chapters[game.chapter].levels[level].score
	
	------------------

   local box = display.newRoundedRect(widget, 0, 0, display.contentWidth*0.206, 200, 10)
   box.x = widget.contentWidth/2
   box.y = widget.contentHeight/2
   box.alpha = 0.3
   box:setFillColor(0)

	------------------

	local energies = display.newImage( widget, "assets/images/hud/energy.png")
	energies.x = 25
	energies.y = 40
	energies:scale(0.5,0.5)
	
	local energiesToCatch = #CHAPTERS[game.chapter].levels[level].energies
	
	
   local energiesText = display.newText( {
		parent = widget,
		text = score.energiesCaught .. "/" .. energiesToCatch,     
		x = 100,
		y = 38,
		width = 100,            --required for multiline and alignment
		height = 40,           --required for multiline and alignment
		font = FONT,   
		fontSize = 22,
		align = "left"
	} )

	------------------

	local piece = display.newSprite( widget, levelDrawer.pieceImageSheet, levelDrawer.pieceSheetConfig:newSequence() )
	piece.x 			= 25
	piece.y 			= 80
	if(score.piecesCaught > 0) then
		piece:play()
	else
   	piece.alpha = 0.2
	end
	
	------------------

	local ring = display.newSprite( widget, levelDrawer.simplePieceImageSheet, levelDrawer.pieceSheetConfig:newSequence() )
	ring.x 		= 25
	ring.y 		= 120
	if(score.ringsCaught > 0) then
		ring:play()
	else
   	ring.alpha = 0.2
	end

	------------------

	if(score.points > 0) then

      local pointsText = display.newText( {
			parent = widget,
			text = score.points .. " pts",     
			x = 140,
			y = 165,
			width = 200,            --required for multiline and alignment
			height = 40,           --required for multiline and alignment
			font = FONT,   
			fontSize = 19,
			align = "right"
		} )
   
      local timeText = display.newText({
			parent = widget,
			text = score.time,     
			x = 140,
			y = 195,
			width = 200,            --required for multiline and alignment
			height = 40,           --required for multiline and alignment
			font = FONT,   
			fontSize = 13,
			align = "right"
		})
   end

	------------------
	
	local percent = math.floor(100* ((0.5)*(score.energiesCaught/energiesToCatch) + (0.25)*(score.ringsCaught) + (0.25)*(score.piecesCaught)))

   local percentText = display.newText( {
		parent = widget,
		text = percent .. " %",     
		x = 90,
		y = 185,
		width = 150,            --required for multiline and alignment
		height = 40,           --required for multiline and alignment
		font = FONT,   
		fontSize = 20,
		align = "left"
	} )
	
	------------------
	
	viewManager.buildEffectButton(
		level,
		51, 
		0.32*aspectRatio,
		x+display.contentWidth*0.152, 
		y+70, 
		function() 
			openLevel(level) 
		end, 
		locked
	)
	
	--------------------------
	
	transition.to( widget, { time=500, alpha=1 })
end

------------------------------------------

function openLevel( level )
	if(game.level == 0) then
   	game.level = level
   	router.openPlayground()
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