-----------------------------------------------------------------------------------------

Game = {}	

-----------------------------------------------------------------------------------------

function Game:new()  

	local startZoom = 1.5*aspectRatio
	local camera = display.newGroup()
	camera.topDistanceCoeff = 0.28
	camera:scale(startZoom,startZoom)
	  
	local object = {
	
		RUNNING  = 1, 
		STOPPED  = 2, 
	
		zoom  	= startZoom, 
		level  	= 0, 
		camera 	= camera,
		hud 		= display.newGroup(),
		focus 	= CHARACTER,
		state		= STOPPED
	}

	setmetatable(object, { __index = Game })
	return object
end

-----------------------------------------------------------------------------------------

function Game:start()

	---------------------

   self.state 					= game.RUNNING
   self.energiesRemaining 	= 0
   self.energiesCaught 		= 0
   self.piecesCaught 		= 0
   self.ringsCaught 			= 0

	---------------------

	utils.emptyGroup(self.camera)

	---------------------

	hud.initFollowRockButton()
	
	---------------------
	-- engines

	physicsManager.start()
	
	------------------------------
	-- level content
	
	levelDrawer.designLevel(function() self:displayScore() end)
	
	-----------------------------
	-- camera

	character.init()

	------------------------------
	-- level foregrounds

				
	levelDrawer.bringForegroundToFront()
	levelDrawer.putBackgroundToBack()
	
	-- viewManager.putForegroundToFront(1)
	
	------------------------------

	Runtime:addEventListener( "enterFrame", self.refreshCamera )
	Runtime:addEventListener( "enterFrame", self.refreshEnemies )

	------------------------------

	if(self.level > 1 or DEV) then
		self.camera.alpha = 1
   	self:spawn()
   else
		self.camera.alpha = 0
   	self:intro()
   end
end

------------------------------------------

function Game:spawn()
	hud.start()
   effectsManager.spawnEffect()
   
   -- laisse le temps du spawn
   timer.performWithDelay(600, function()
   	touchController.start()
   	self.startTime = system.getTimer()
   end)
end

------------------------------------------

function Game:stop()

	if(self.state == game.STOPPED) then return end
	
	------------------------------------------

	Runtime:removeEventListener( "enterFrame", self.refreshCamera )
	Runtime:removeEventListener( "enterFrame", self.refreshEnemies )

   self.state = game.STOPPED
   self.elapsedTime = system.getTimer() - game.startTime

	touchController.stop()
	
	------------------------------------------
	
	if(game.level == 1) then
		GLOBALS.savedData.requireTutorial = false
	end

	GLOBALS.savedData.levels[game.level].complete = true

	utils.saveTable(GLOBALS.savedData, "savedData.json")
	
	------------------------------------------
	
	timer.performWithDelay(700, function()
		self:reset()
		self:displayScore()
	end)
	
end

------------------------------------------

function Game:reset()
	hud.destroy()
	character.destroy()
	touchController.stop()
	physicsManager.stop()
end

------------------------------------------

function Game:displayScore()
	
	local top = display.newRect(self.hud, 0, -display.contentHeight/5, display.contentWidth, display.contentHeight/5)
   top.alpha = 0
   top:setFillColor(0)
   
   local bottom = display.newRect(self.hud, 0, display.contentHeight, display.contentWidth, display.contentHeight/5)
   bottom.alpha = 0
   bottom:setFillColor(0)

   local board = display.newRoundedRect(self.hud, 0, 0, display.contentWidth/2, display.contentHeight/2, 20)
   board.x = display.contentWidth/2
   board.y = display.contentHeight/2
   board.alpha = 0
   board:setFillColor(0)
   
	transition.to( top, { time=800, alpha=1, y = top.contentHeight/2 })
	transition.to( bottom, { time=800, alpha=1, y = display.contentHeight - top.contentHeight/2 })  
	transition.to( board, { time=800, alpha=0.7, onComplete= function() self:fillBoard() end})  
	
end

--------------------------------------------------------------------------------------------------------------------------
--- RESULT BOARD
--------------------------------------------------------------------------------------------------------------------------

function Game:fillBoard()

	------------------

	local timeIcon = display.newImage( game.hud, "assets/images/hud/energy.png")
	timeIcon.x = display.contentWidth*0.3
	timeIcon.y = display.contentHeight*0.35
	timeIcon:scale(0.5,0.5)
	
	-- 10 ms 		= 1pts
	-- timeMax 		= sec
	-- elapsedTime = millis
	local timePoints = GLOBALS.levels[game.level].properties.timeMax*100 - math.floor(game.elapsedTime/10)
	local min,sec,ms = utils.getMinSecMillis(math.floor(game.elapsedTime))
	local time = min .. "'" .. sec .. "''" .. ms  
	
	local timeResult = time .. " -> " .. timePoints
   local timeText = display.newText( game.hud, timeResult, 0, 0, FONT, 25 )
   timeText:setTextColor( 255 )	
   timeText:setReferencePoint( display.TopLeftReferencePoint )
	timeText.x = display.contentWidth*0.34
	timeText.y = display.contentHeight*0.32

	------------------
	
	local energiesCaughtIcon = display.newImage( game.hud, "assets/images/hud/energy.png")
	energiesCaughtIcon.x = display.contentWidth*0.3
	energiesCaughtIcon.y = display.contentHeight*0.4
	energiesCaughtIcon:scale(0.5,0.5)
	
	local energiesCaught = game.energiesCaught
   local energiesCaughtText = display.newText( game.hud, energiesCaught, 0, 0, FONT, 25 )
   energiesCaughtText:setReferencePoint( display.TopLeftReferencePoint )
   energiesCaughtText:setTextColor( 255 )	
	energiesCaughtText.x = display.contentWidth*0.35
	energiesCaughtText.y = display.contentHeight*0.37

	------------------

	local energiesRemainingIcon = display.newImage( game.hud, "assets/images/hud/energy.png")
	energiesRemainingIcon.x = display.contentWidth*0.3
	energiesRemainingIcon.y = display.contentHeight*0.45
	energiesRemainingIcon:scale(0.5,0.5)
	
	local energiesRemaining = game.energiesRemaining
   local energiesRemainingText = display.newText( game.hud, energiesRemaining, 0, 0, FONT, 25 )
   energiesRemainingText:setReferencePoint( display.TopLeftReferencePoint )
   energiesRemainingText:setTextColor( 255 )	
	energiesRemainingText.x = display.contentWidth*0.35
	energiesRemainingText.y = display.contentHeight*0.42

	------------------

	local piece = display.newSprite( game.hud, levelDrawer.pieceImageSheet, levelDrawer.pieceSheetConfig:newSequence() )
	piece.x 			= display.contentWidth*0.3
	piece.y 			= display.contentHeight*0.5
	piece:play()

	local piecesCaught = game.piecesCaught
   local piecesCaughtText = display.newText( game.hud, piecesCaught, 0, 0, FONT, 25 )
   piecesCaughtText:setReferencePoint( display.TopLeftReferencePoint )
   piecesCaughtText:setTextColor( 255 )	
	piecesCaughtText.x = display.contentWidth*0.35
	piecesCaughtText.y = display.contentHeight*0.47

	
	------------------

	local ring = display.newSprite( game.hud, levelDrawer.simplePieceImageSheet, levelDrawer.pieceSheetConfig:newSequence() )
	ring.x 		= display.contentWidth*0.3
	ring.y 		= display.contentHeight*0.55
	ring:play()

	local ringsCaught = game.ringsCaught
   local ringsCaughtText = display.newText( game.hud, ringsCaught, 0, 0, FONT, 25 )
   ringsCaughtText:setReferencePoint( display.TopLeftReferencePoint )
   ringsCaughtText:setTextColor( 255 )	
	ringsCaughtText.x = display.contentWidth*0.35
	ringsCaughtText.y = display.contentHeight*0.52

	------------------
	-- score final

	local piecesBonus = 1
	local ringsBonus  = 1
	 
	if(piecesCaught > 0) then piecesBonus = 3*piecesCaught end 
	if(ringsCaught > 0) then ringsBonus = 2*piecesCaught end 

	local score = timePoints + energiesCaught * energiesRemaining * 10 * piecesBonus * ringsBonus
	
   local scoreText = display.newText( game.hud, score .. " pts", 0, 0, FONT, 35 )
   scoreText:setReferencePoint( display.TopLeftReferencePoint )
   scoreText:setTextColor( 255 )	
	scoreText.x = display.contentWidth*0.6
	scoreText.y = display.contentHeight*0.35
	
	------------------
	-- play button
	
	viewManager.buildButton(
		"assets/images/hud/play.png", 
		"white", 
		21, 
		0.26*aspectRatio,
		display.contentWidth*0.65, 	
		display.contentHeight*0.65, 	
		function()
			router.openAppHome() 
		end
	)
	
end
	
--------------------------------------------------------------------------------------------------------------------------
--- CAMERA
--------------------------------------------------------------------------------------------------------------------------
	
--- ici on prend en compte le game.zoom
-- car les x,y de position du character sont ceux du screen

function Game:refreshCamera(event)

	game.camera.xScale = game.zoom
	game.camera.yScale = game.zoom
	
	if(character.sprite and character.sprite.y < levelDrawer.level.bottomY) then
		
		if(not character.rock or game.focus == CHARACTER) then	
      	game.camera.x = -character.sprite.x*game.zoom + display.contentWidth*0.5
			
			local vx,vy = character.sprite:getLinearVelocity()
			      	
      	if(character.hanging 
      	or touchController.currentState == touchController.PINCHING
			or touchController.currentState == touchController.THROWING
			or touchController.currentState == touchController.GRABBING	) then
				
   			if(game.camera.centerReached) then
         		game.camera.y = display.contentHeight*0.5 - character.screenY()
   			
   			elseif(not game.camera.tween) then
   				game.camera.tween = transition.to(game.camera, {
   					time=250, 
   					y = display.contentHeight*0.5 - character.screenY(),
   					onComplete = function() 
   						game.camera.tween = nil 
         				game.camera.centerReached = true
   						end
   				})
   			end
      	
      	else
      	
      		if(game.camera.tween) then
      			transition.cancel(game.camera.tween)
      		end
      		
      		game.camera.tween = nil
      		game.camera.centerReached = false
      		
         	local topDistance 	= character.screenY() + game.camera.y
         	local bottomDistance = display.contentHeight - topDistance
   
         	if(bottomDistance < display.contentHeight*game.camera.topDistanceCoeff) then
         		game.camera.y = display.contentHeight*(1 - game.camera.topDistanceCoeff) - character.screenY()
         	elseif(topDistance < display.contentHeight*game.camera.topDistanceCoeff) then
         		game.camera.y = display.contentHeight*game.camera.topDistanceCoeff - character.screenY() 
         	end
      	
      	end

--      	local leftDistance 	= character.screenX() + game.camera.x
--      	local rightDistance 	= display.contentWidth - leftDistance
--
--      	if(rightDistance < display.contentWidth*0.43) then
--      		game.camera.x = display.contentWidth*0.57 - character.screenX() 
--      	elseif(leftDistance < display.contentWidth*0.43) then
--      		game.camera.x = display.contentWidth*0.43 - character.screenX()
--      	end
--      
      
      elseif(game.focus == ROCK) then
      	if(character.rock.x) then 
      		game.camera.x = -character.rock.x*game.zoom + display.contentWidth*0.5
      		game.camera.y = -character.rock.y*game.zoom + display.contentHeight*0.5
      	end
      end
	end
end

--------------------------------------------------------------------------------------------------------------------------
--- Enemies
-------------------------------------------------------------------------------------------------------------------------
	
--- ici on prend en compte le game.zoom
-- car les x,y de position du character sont ceux du screen

function Game:refreshEnemies(event)
	for i=1,#levelDrawer.level.enemies do
		levelDrawer.level.enemies[i]:refresh()
	end
end

------------------------------------------

function Game:intro()
	
	local board = display.newRoundedRect(self.hud, 0, 0, display.contentWidth, display.contentHeight, 0)
   board.x = display.contentWidth/2
   board.y = display.contentHeight/2
   board.alpha = 0.6
   board:setFillColor(0)
   
	transition.to( board, { time=10000, alpha=0, onComplete= function() self:spawn() end})  

	timer.performWithDelay(500, function()
   	viewManager.displayIntroText("Uralys presents", display.contentWidth*0.2, display.contentHeight*0.2, true)
	end)

	timer.performWithDelay(5500, function()
   	viewManager.displayIntroText("Music by Velvet Coffee", display.contentWidth*0.7, display.contentHeight*0.43, true)
	end)

	timer.performWithDelay(10000, function()
   	transition.to( self.camera, { time=1000, alpha=1 })
	end)

	timer.performWithDelay(11000, function()
   	viewManager.displayIntroTitle(APP_NAME, display.contentWidth*0.26, display.contentHeight*0.27, true)
	end)
end

------------------------------------------

return Game