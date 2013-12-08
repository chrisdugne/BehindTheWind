-----------------------------------------------------------------------------------------

Game = {}	

-----------------------------------------------------------------------------------------

function Game:new()  
	local startZoom = 0.75*aspectRatio*aspectRatio
	local camera = display.newGroup()
	camera.topDistanceCoeff = 0.28
	camera:scale(startZoom,startZoom)
	  
	local object = {
	
		RUNNING  = 1, 
		STOPPED  = 2, 
	
		zoom  	= startZoom, 
		chapter  = 0, 
		level  	= 0, 
		camera 	= camera,
		hud 		= display.newGroup(),
		focus 	= CHARACTER,
		state		= STOPPED,
	}

	setmetatable(object, { __index = Game })
	return object
end

-----------------------------------------------------------------------------------------

function Game:start()

	---------------------

   self.state 					= game.RUNNING
   self.creationTime 		= system.getTimer()
   self.energiesSpent 		= 0
   self.energiesCaught 		= 0
   self.piecesCaught 		= 0
   self.ringsCaught 			= 0
	
	scoreManager.score 		= {}

	---------------------
	
	self.camera.offsetX 	= 0
	self.camera.offsetY 	= 0
	self.camera.markX 	= 0
	self.camera.markY 	= 0

	---------------------

	utils.emptyGroup(self.camera)

	---------------------
	-- engines

	physicsManager.start()
	
	------------------------------
	-- level content
	
	viewManager.initBack(game.chapter)
	levelDrawer.designLevel()
	
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

	if(self.chapter == 1 and self.level == 1) then
		self.camera.alpha = 0
   	self:startIntro()
   else
		self.camera.alpha = 1
   	self:spawn()
   	viewManager.displayIntroTitle(CHAPTERS[game.chapter].name .. ", " .. (T "Level") .. game.level, display.contentWidth*0.26, display.contentHeight*0.27, true)
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

function Game:destroyBeforeExit()
	self:reset()
   self.state = game.STOPPED
   self.creationTime = nil
	Runtime:removeEventListener( "enterFrame", self.refreshCamera )
	Runtime:removeEventListener( "enterFrame", self.refreshEnemies )
end

------------------------------------------

function Game:stop()

	if(self.state == game.STOPPED) then return end
	
	------------------------------------------

	Runtime:removeEventListener( "enterFrame", self.refreshCamera )
	Runtime:removeEventListener( "enterFrame", self.refreshEnemies )

   self.state = game.STOPPED
   self.creationTime = nil
   self.elapsedTime = system.getTimer() - game.startTime

	touchController.stop()
	
	------------------------------------------
	
	if(game.level == 1 and game.chapter == 1) then
		GLOBALS.savedData.requireTutorial = false
		GLOBALS.savedData.fireEnable = true
	end

	if(game.level == 3 and game.chapter == 1) then
		GLOBALS.savedData.grabEnable = true
	end

	GLOBALS.savedData.chapters[game.chapter].levels[game.level].complete = true

	if(game.level == CHAPTERS[game.chapter].nbLevels) then
   	GLOBALS.savedData.chapters[game.chapter].complete = true
	end

	------------------------------------------
	-- score 

	local score = {
   	energiesCaught 		= self.energiesCaught,
   	piecesCaught 			= self.piecesCaught,
   	ringsCaught 			= self.ringsCaught,
	}
	
	
	local min,sec,ms = utils.getMinSecMillis(math.floor(game.elapsedTime))
	score.time = min .. "'" .. sec .. "''" .. ms  

	if(score.ringsCaught > 0) 		then score.ringsBonus 	= 2*score.ringsCaught 		else score.ringsBonus 	= 1 	end 
	if(score.piecesCaught > 0) 	then score.piecesBonus 	= 3*score.piecesCaught		else score.piecesBonus 	= 1 	end 
	
	-- 100 ms 		= 1pts
	-- timeMax 		= sec
	-- elapsedTime = millis
	score.timePoints = CHAPTERS[game.chapter].levels[game.level].properties.timeMax*10 - math.floor(game.elapsedTime/100)
	score.points = (score.timePoints + score.energiesCaught * score.energiesCaught) * score.piecesBonus * score.ringsBonus
	
	scoreManager.score = score
	
	------------------------------------------
	
	local previousScore = GLOBALS.savedData.chapters[game.chapter].levels[game.level].score
	
	if(previousScore.energiesCaught < score.energiesCaught) then
		GLOBALS.savedData.chapters[game.chapter].levels[game.level].score.energiesCaught = score.energiesCaught
	end

	if(previousScore.ringsCaught < score.ringsCaught) then
		GLOBALS.savedData.chapters[game.chapter].levels[game.level].score.ringsCaught = score.ringsCaught
	end

	if(previousScore.piecesCaught < score.piecesCaught) then
		GLOBALS.savedData.chapters[game.chapter].levels[game.level].score.piecesCaught = score.piecesCaught
	end
	
	if(previousScore.points < score.points) then
		GLOBALS.savedData.chapters[game.chapter].levels[game.level].score.points	= score.points
		GLOBALS.savedData.chapters[game.chapter].levels[game.level].score.time 		= score.time
	end
		
	------------------------------------------
	
	utils.saveTable(GLOBALS.savedData, "savedData.json")

	------------------------------------------
	
	timer.performWithDelay(700, function()
		self:reset()
		scoreManager:displayScore()
	end)
	
end

------------------------------------------

function Game:reset()
	hud.destroy()
	character.destroy()
	touchController.stop()
	physicsManager.stop()
end

--------------------------------------------------------------------------------------------------------------------------

function Game:openLevel( level )
	print("openLevel", level)
	if(self.level == 0) then
		self.level = level

--		local top = display.newRect(game.hud, 0, -display.contentHeight/2, display.contentWidth, display.contentHeight/2)
--		top.alpha = 1
--		top:setFillColor(0)
--
--		local bottom = display.newRect(game.hud, 0, display.contentHeight, display.contentWidth, display.contentHeight/2)
--		bottom.alpha = 1
--		bottom:setFillColor(0)
--
--		transition.to( top, 		{ time=600, alpha=0, y = top.contentHeight/2 })
--		transition.to( bottom, 	{ time=600, alpha=0, y = display.contentHeight - top.contentHeight/2 })  

		transition.to( self.hud, { time=600, alpha=0 })  
		timer.performWithDelay(620, router.openPlayground)
	end
end

--------------------------------------------------------------------------------------------------------------------------
--- CAMERA
--------------------------------------------------------------------------------------------------------------------------
	
--- ici on prend en compte le game.zoom
-- car les x,y de position du character sont ceux du screen

function Game:refreshCamera(event)

	game.camera.xScale = game.zoom
	game.camera.yScale = game.zoom
	
	if(character.sprite and character.sprite.y < levelDrawer.level.bottomY and character.state ~= character.OUT) then
		game.camera.x = -character.sprite.x*game.zoom + display.contentWidth*0.5 + game.camera.offsetX
	 	game.camera.y = -character.sprite.y*game.zoom + display.contentHeight*0.5 + game.camera.offsetY
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

--------------------------------------------------------------------------------------------------------------------------
--- Intro
-------------------------------------------------------------------------------------------------------------------------
	
function Game:startIntro()
	
	self.intro = display.newGroup()
	self.intro.board = display.newRoundedRect(self.hud, 0, 0, display.contentWidth, display.contentHeight, 0)
   self.intro.board.x = display.contentWidth/2
   self.intro.board.y = display.contentHeight/2
   self.intro.board.alpha = 0.6
   self.intro.board:setFillColor(0)
   
	transition.to( self.intro.board, { time=10000, alpha=0, onComplete= function() self:spawn() end})  

	self.introTimer1 = timer.performWithDelay(500, function()
   	viewManager.displayIntroText("Uralys presents", display.contentWidth*0.2, display.contentHeight*0.2, true)
	end)

	self.introTimer2 = timer.performWithDelay(5500, function()
   	viewManager.displayIntroText("Music by Velvet Coffee", display.contentWidth*0.7, display.contentHeight*0.43, true)
	end)

	self.introTimer3 = timer.performWithDelay(10000, function()
   	transition.to( self.camera, { time=1000, alpha=1 })
	end)

	self.introTimer4 = timer.performWithDelay(11000, function()
		utils.destroyFromDisplay(self.intro)
   	viewManager.displayIntroTitle(APP_NAME, display.contentWidth*0.26, display.contentHeight*0.27, true)
	end)
	
	
	viewManager.buildSimpleButton(
		self.intro,
		"assets/images/hud/play.png", 
		12, 
		0.12*aspectRatio,
		display.contentWidth*0.95, 	
		display.contentHeight*0.95, 	
		function()
			transition.cancel(self.intro.board)
			self.intro.board.alpha = 0
			timer.cancel(self.introTimer1)
			timer.cancel(self.introTimer2)
			timer.cancel(self.introTimer3)
			timer.cancel(self.introTimer4)
			transition.to( self.camera, { time=1000, alpha=1 })
			self:spawn()
			viewManager.displayIntroTitle(APP_NAME, display.contentWidth*0.26, display.contentHeight*0.27, true)
			utils.destroyFromDisplay(self.intro)
		end
	)
end

------------------------------------------

return Game