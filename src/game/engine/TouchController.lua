-------------------------------------

module(..., package.seeall)

-------------------------------------

NONE 					= 0

READY_TO_THROW 	= 11
READY_TO_GRAB 		= 12
THROWING 			= 13
GRABBING 			= 14

DRAGGING_TILE 		= 101

-------------------------------------

SWIPE_MAX 			= 140 

-------------------------------------

local previousState 		= NONE
local currentState 		= NONE
local xStart				= 0
local yStart				= 0
local lastX					= 0
local lastY					= 0
local startTouchTime		= 0
local previousTapTime	= 0

local tapping				= 0
local swipping				= false

-------------------------------------

local TAP_TIME_LIMIT		= 150

-------------------------------------

function init()
	display.getCurrentStage():addEventListener( "touch", function(event)
		touchScreen(event)
	end)
end

-------------------------------------

function touchScreen( event )
	
	lastX, lastY = event.x, event.y

	if(currentState ~= THROWING and currentState ~= GRABBING) then
		xStart, yStart = lastX, lastY
	end
	
	if(currentState == DRAGGING_TILE) then return end
   	
   	
	if event.phase == "began" then

   	startTouchTime 	= system.getTimer()
		xStart, yStart 	= event.xStart, event.yStart
		swipping = false
   	
		if(startTouchTime - previousTapTime > TAP_TIME_LIMIT) then 
			tapping = 0
		end

   	display.getCurrentStage():setFocus( game.camera )
   	Runtime:addEventListener( "enterFrame", onTouch )
   	
		
	elseif event.phase == "moved" then
		
		if(currentState == READY_TO_THROW) then
			setState(THROWING, function() character.setThrowing() end)
		end 

		if(currentState == READY_TO_GRAB) then
			setState(GRABBING, function() character.setGrabbing() end)
		end 
--		
--		if(currentState == THROWING 
--		or currentState == GRABBING
--		or #character.ropes > 0) then
--			return
--			
--		elseif(event.x - 10 > xStart) then
--			swipping = true
--			setState(SWIPE_RIGHT)
--
--		elseif(event.x + 10 < xStart) then
--			swipping = true
--			setState(SWIPE_LEFT)
--		end


	elseif event.phase == "ended" then
   	
   	if(currentState == THROWING) then
   		local launch = getLaunchVector()
			character.throw( launch.x - game.camera.x,launch.y - game.camera.y, xStart - game.camera.x,yStart - game.camera.y)
   	elseif(currentState == GRABBING) then
   		local launch = getLaunchVector()
			character.grab( launch.x - game.camera.x,launch.y - game.camera.y, xStart - game.camera.x,yStart - game.camera.y)
   	end
		---------------------------------------------
		
		local now = system.getTimer()
		local touchDuration = now - startTouchTime

		if(touchDuration < TAP_TIME_LIMIT) then 
			previousTapTime = now
			tapping = tapping + 1
		end
   	
		---------------------------------------------
		
		character.stop(tapping)
		setState(NONE)
   	display.getCurrentStage():setFocus( nil )
   	Runtime:removeEventListener( "enterFrame", onTouch )
		
		---------------------------------------------
	end

	return true
end


-------------------------------------

function getLaunchVector()

	local direction = vector2D:new(xStart - lastX, yStart - lastY )
	if(direction:magnitude() > SWIPE_MAX) then
		direction:normalize()
		direction:mult(SWIPE_MAX)
	end

	return vector2D:new(xStart - direction.x, yStart - direction.y)
end

-------------------------------------

function onTouch( event )
	
	local now = system.getTimer()
	local touchDuration = now - startTouchTime

	if(currentState ~= THROWING and currentState ~= GRABBING) then
   	if(tapping == 1) then 
   		setState(READY_TO_THROW)
   	elseif(tapping == 2) then 
   		setState(READY_TO_GRAB)
   	end
	end

	if(touchDuration > TAP_TIME_LIMIT) then
	
		if(tapping == 0) then
			if(xStart-(character.sprite.x + game.camera.x) > 15) then
				character.goRight()
			elseif(xStart-(character.sprite.x + game.camera.x) < - 15) then
				character.goLeft()
			end
			
			character.jump()
		else
   		if(currentState == THROWING or currentState == GRABBING) then
   			local launch = getLaunchVector()
				physicsManager.refreshTrajectory( launch.x - game.camera.x,launch.y - game.camera.y, xStart - game.camera.x,yStart - game.camera.y)
   			if(lastX > xStart) then character.lookLeft() else character.lookRight() end
			end
		end
	end
end
	
	
-------------------------------------

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

-------------------------------------

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
	
-------------------------------------

function drag( tile, event, motionLimit )
	
	if event.phase == "began" then
		tile.moving = true
		tile.markX = tile.x    -- store x location of object
		tile.markY = tile.y    -- store y location of object
	
	elseif event.phase == "moved" and tile.moving then
		local x = (event.x - event.xStart) + tile.markX
		local y = (event.y - event.yStart) + tile.markY
		
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