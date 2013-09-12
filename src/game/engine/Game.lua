-----------------------------------------------------------------------------------------

Game = {}	

-----------------------------------------------------------------------------------------

function Game:new()  

	local startZoom = 1.5*aspectRatio
	local camera = display.newGroup()
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

   self.state = game.RUNNING

	---------------------

	utils.emptyGroup(self.camera)
	self.camera.alpha = 0

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

	------------------------------
	
	transition.to( self.camera, { time=1000, alpha=1 })
   effectsManager.spawnEffect()
	touchController.start()
	Runtime:addEventListener( "enterFrame", self.refreshCamera )
	
--	timer.performWithDelay(3000, function()
--      effectsManager.spawnEffect()
--      self.state = game.RUNNING
--   	touchController.start()
--   	Runtime:addEventListener( "enterFrame", self.refreshCamera )
--	end)
end

function Game:stop()

	if(self.state == game.STOPPED) then return end
	
	Runtime:removeEventListener( "enterFrame", self.refreshCamera )
   self.state = game.STOPPED

	touchController.stop()
	
	if(game.level == 1) then
		GLOBALS.savedData.requireTutorial = false
	end

	GLOBALS.savedData.levels[game.level].complete = true
	
	timer.performWithDelay(700, function()
		self:reset()
		self:displayScore()
	end)
	
end

------------------------------------------

function Game:reset()
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
------------------------------------------

function Game:fillBoard()

	viewManager.buildButton(
		"assets/images/hud/play.png", 
		"white", 
		21, 
		0.26*aspectRatio,
		display.contentWidth*0.5, 	
		display.contentHeight*0.5, 	
		function()
			router.openAppHome() 
		end
	)
	
end
	
------------------------------------------
--- ici on prend en compte le game.zoom
-- car les x,y de position du character sont ceux du screen

function Game:refreshCamera(event)

	if(character.sprite and character.sprite.y < levelDrawer.level.bottomY) then
		if(not character.rock or game.focus == CHARACTER) then	
      	
      	local leftDistance 	= character.screenX() + game.camera.x
      	local rightDistance 	= display.contentWidth - leftDistance
      
      	local topDistance 	= character.screenY() + game.camera.y
      	local bottomDistance = display.contentHeight - topDistance

      	if(rightDistance < display.contentWidth*0.43) then
      		game.camera.x = display.contentWidth*0.57 - character.screenX() 
      	elseif(leftDistance < display.contentWidth*0.43) then
      		game.camera.x = display.contentWidth*0.43 - character.screenX()
      	end
      
      	if(bottomDistance < display.contentHeight*0.18) then
      		game.camera.y = display.contentHeight*0.82 - character.screenY()
      	elseif(topDistance < display.contentHeight*0.18) then
      		game.camera.y = display.contentHeight*0.18 - character.screenY() 
      	end
      
      elseif(game.focus == ROCK) then
      	if(character.rock.x) then 
      		game.camera.x = -character.rock.x*game.zoom + display.contentWidth*0.5
      		game.camera.y = -character.rock.y*game.zoom + display.contentHeight*0.5
      	end
      end
	end
end

------------------------------------------

return Game