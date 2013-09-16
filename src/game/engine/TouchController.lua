---------------------------------------------------------------------

module(..., package.seeall)

---------------------------------------------------------------------

NONE 					= 0

READY_TO_THROW 	= 11
READY_TO_GRAB 		= 12
THROWING 			= 13
GRABBING 			= 14

DRAGGING_TILE 		= 101

---------------------------------------------------------------------

SWIPE_MAX 			= 140 

---------------------------------------------------------------------

currentState 				= NONE
swipping						= false
rightTouch					= false
leftTouch					= false
centerTouch					= false

local previousState 		= NONE
local xStart				= 0
local yStart				= 0
local lastX					= 0
local lastY					= 0
local startTouchTime		= 0
local previousTapTime	= 0

local lastTouchCharacterTime = 0


local centerTapping		= 0
local sideTapping			= 0

---------------------------------------------------------------------

local TAP_TIME_LIMIT		= 250

---------------------------------------------------------------------

function start()
	display.getCurrentStage():addEventListener( "touch", touchScreen )
end

function stop()
	display.getCurrentStage():removeEventListener( "touch", touchScreen )
	Runtime:removeEventListener( "enterFrame", onTouch )
	display.getCurrentStage():setFocus( nil )
end

---------------------------------------------------------------------

function touchScreen( event )
	
	lastX, lastY = event.x, event.y
	
	if(currentState == DRAGGING_TILE) then return end
   	
	---------------------------------------------

	if event.phase == "began" then

   	startTouchTime 	= system.getTimer()
		xStart, yStart 	= event.xStart, event.yStart
		swipping 	= false
		rightTouch 	= false
		leftTouch 	= false
		centerTouch = false

		if(xStart > display.contentWidth*0.5) then
			rightTouch = true
		end

		if(xStart < display.contentWidth*0.5) then
			leftTouch = true
		end
		
		if(startTouchTime - previousTapTime > TAP_TIME_LIMIT) then 
			centerTapping = 0
			sideTapping = 0
			currentState = NONE
		end
   	
   	character.move()

   	display.getCurrentStage():setFocus( game.camera )
   	Runtime:addEventListener( "enterFrame", onTouch )
   	
	---------------------------------------------
		
	elseif event.phase == "ended" then

   	display.getCurrentStage():setFocus( nil )
   	Runtime:removeEventListener( "enterFrame", onTouch )

		-----------------------------
		--	OUT  : dont listen action
		if(character.state == character.OUT) then return end
		
		-----------------------------
		
		local now = system.getTimer()
		local touchDuration = now - startTouchTime

		if(touchDuration < TAP_TIME_LIMIT) then 
			previousTapTime = now
			sideTapping = sideTapping + 1
		end
   	
		-----------------------------
   	
		swipping 	= false
		rightTouch 	= false
		leftTouch 	= false
		
		-----------------------------
		
		character.stop()
		setState(NONE)
		
		---------------------------------------------
	end

	return true
end


---------------------------------------------------------------------

function onTouch( event )
	local now = system.getTimer()
	local touchDuration = now - startTouchTime

	if(currentState == THROWING or currentState == GRABBING) then
		local launch = getLaunchVector()
		physicsManager.refreshTrajectory( launch.x - game.camera.x,launch.y - game.camera.y, xStart - game.camera.x,yStart - game.camera.y)
		if(lastX > xStart) then character.lookLeft() else character.lookRight() end
	end
end
	
---------------------------------------------------------------------

function characterTouch( event )
	
	lastX, lastY = event.x, event.y
	
	if event.phase == "began" then

		if(character.grabs > 1) then return true end -- on attend qu'il n'y ait qu'une seule rope pour permettre d'en lancer une 2e
				
		xStart, yStart = event.xStart, event.yStart
		
   	lastTouchCharacterTime = system.getTimer()
		centerTouch = true
		
   	if(centerTouch) then
      	if(centerTapping == 0) then 
      		setState(READY_TO_THROW)
      	elseif(centerTapping == 1) then 
      		setState(READY_TO_GRAB)
      	end
   	end

   	Runtime:addEventListener( "enterFrame", onTouch )
   	display.getCurrentStage():setFocus( character.sprite )

	elseif event.phase == "moved" then
	
   	if(currentState ~= THROWING and currentState ~= GRABBING) then
   		xStart, yStart = lastX, lastY
   	end
   	
		if(currentState == READY_TO_THROW) then
			if(character.throwFire) then
   			setState(THROWING, function() character.setThrowing() end)
			elseif(character.throwGrab) then
   			setState(GRABBING, function() character.setGrabbing() end)
			end
		end 
		
	elseif event.phase == "ended" then
	
		-----------------------------
		
		if(currentState == READY_TO_THROW) then
			character.changeThrowStuff()
			
			if(character.throwFire) then
   			character.setThrowing()
			elseif(character.throwGrab) then
   			character.setGrabbing()
			end
		end
		
		-----------------------------
   	
   	if(currentState == THROWING) then
   		local launch = getLaunchVector()
			character.throw( launch.x - game.camera.x,launch.y - game.camera.y, xStart - game.camera.x,yStart - game.camera.y)
   	elseif(currentState == GRABBING) then
   		local launch = getLaunchVector()
			character.grab( launch.x - game.camera.x,launch.y - game.camera.y, xStart - game.camera.x,yStart - game.camera.y)
   	end

		-----------------------------

   	display.getCurrentStage():setFocus( nil )
   	Runtime:removeEventListener( "enterFrame", onTouch )
   	
   	
	end
	
	return true -- cancel the touchScreen
end
	
---------------------------------------------------------------------

function setState(state, toApply)
	
	if(currentState ~= state) then
		xStart, yStart = lastX, lastY
		previousState = currentState
		currentState = state
		
		if(toApply ~= nil) then
			toApply()
		end
	end
	
end

---------------------------------------------------------------------

function dragGroup( group, motionLimit, event )
	
	if event.phase == "began" then
   	display.getCurrentStage():setFocus( event.target )
		setState(DRAGGING_TILE)
	elseif event.phase == "ended" or event.phase == "cancelled" then
		setState(NONE)
		display.getCurrentStage():setFocus( nil )
	end

	for i = 1, #group do

   	local characterIsOnThisGroup = false
   	local xFloorOffset = 0
   	local yFloorOffset = 0
   	
   	if(group[i] == character.floor) then
   		characterIsOnThisGroup = true
   		xFloorOffset = character.floor.x
   		yFloorOffset = character.floor.y
   	end

		drag(group[i], event, motionLimit)
   	
   	if(characterIsOnThisGroup) then
   		xFloorOffset = character.floor.x - xFloorOffset
   		yFloorOffset = character.floor.y - yFloorOffset
   		character.sprite.x = character.sprite.x + xFloorOffset 
   		character.sprite.y = character.sprite.y + yFloorOffset
   	end
	end
	
end
	
---------------------------------------------------------------------
--- ici on prend en compte le game.zoom
-- car les x,y des events sont ceux du screen
-- or on bouge les x,y dans le monde, la camera => il faut compter le zoom

function drag( tile, event, motionLimit )
	
	if event.phase == "began" then
		tile.moving = true
		tile.markX = tile.x*game.zoom    -- store x location of object
		tile.markY = tile.y*game.zoom    -- store y location of object
	
	elseif event.phase == "moved" and tile.moving then
		local x = ((event.x - event.xStart) + tile.markX)/game.zoom
		local y = ((event.y - event.yStart) + tile.markY)/game.zoom
		
		if(motionLimit) then
			if(motionLimit.horizontal > 0) then
      		if	(x - tile.startX > motionLimit.horizontal) 	then x = tile.startX + motionLimit.horizontal 	end
      		if	(x < tile.startX) then x = tile.startX end
			elseif(motionLimit.horizontal < 0) then
      		if	(x - tile.startX < motionLimit.horizontal) 	then x = tile.startX + motionLimit.horizontal 	end
      		if	(x > tile.startX) then x = tile.startX end
      	else
      		x = tile.startX
   		end

			if(motionLimit.vertical > 0) then
      		if	(y - tile.startY > motionLimit.vertical) 	then y = tile.startY + motionLimit.vertical 	end
      		if	(y < tile.startY) then y = tile.startY end
			elseif(motionLimit.vertical < 0) then
      		if	(y - tile.startY < motionLimit.vertical) 	then y = tile.startY + motionLimit.vertical 	end
      		if	(y > tile.startY) then y = tile.startY end
      	else
      		y = tile.startY
   		end

		end
		
		tile.x, tile.y = x, y    -- move object based on calculations above

	elseif event.phase == "ended" or event.phase == "cancelled" then
		tile.moving = false
		
	end

	return true
end

---------------------------------------------------------------------

function getLaunchVector()

	local direction = vector2D:new(xStart - lastX, yStart - lastY )
	if(direction:magnitude() > SWIPE_MAX) then
		direction:normalize()
		direction:mult(SWIPE_MAX)
	end

	return vector2D:new(xStart - direction.x, yStart - direction.y)
end