-------------------------------------

module(..., package.seeall)

-------------------------------------

NONE 					= 0
SWIPE_RIGHT 		= 1
SWIPE_LEFT 			= 2
SWIPE_UP 			= 3

READY_TO_THROW 	= 11
THROWING 			= 12
GRABBING 			= 13

DRAGGING_TILE 		= 101

-------------------------------------

local hold 					= false
local previousState 		= NONE
local currentState 		= NONE
local xStart				= 0
local yStart				= 0
local lastX					= 0
local lastY					= 0
local startTouchTime		= 0

-------------------------------------

function init()
	display.getCurrentStage():addEventListener( "touch", function(event)
		touchScreen(event)
	end)
end

-------------------------------------

function touchScreen( event )
	
	lastX, lastY = event.x, event.y
	if(not character.floor) then
		xStart, yStart = lastX, lastY
	end
	
	if(currentState == DRAGGING_TILE) then return end
   	
	if event.phase == "began" then
   	startTouchTime 	= system.getTimer()
		hold 					= true	
		xStart, yStart 	= event.xStart, event.yStart
   	
   	display.getCurrentStage():setFocus( character.sprite )
   	Runtime:addEventListener( "enterFrame", onTouch )
   	
		
	elseif event.phase == "moved" then
		
		if(currentState == READY_TO_THROW) then 
			setState(THROWING)
			return

		elseif(currentState == THROWING or currentState == GRABBING) then 
			if(lastX > xStart) then character.lookLeft() else character.lookRight() end
			return
			
		elseif(event.y + 40 < yStart) then
			setState(SWIPE_UP)
			swipeUp()

		elseif(event.x - 40 > xStart) then
			setState(SWIPE_RIGHT)

		elseif(event.x + 40 < xStart) then
			setState(SWIPE_LEFT)
		end

	elseif event.phase == "ended" then
   	if(currentState == THROWING) then
			character.throw( lastX - camera.x,lastY - camera.y, xStart - camera.x,yStart - camera.y)
   	elseif(currentState == GRABBING) then
			character.grab( lastX - camera.x,lastY - camera.y, xStart - camera.x,yStart - camera.y)
   	end
   	
		hold = false
		setState(NONE)
		character.stop()
   	display.getCurrentStage():setFocus( nil )
   	Runtime:removeEventListener( "enterFrame", onTouch )
		
	end

	return true
end


-------------------------------------

function onTouch( event )
	
	if(currentState == SWIPE_LEFT) then
		swipeLeft()

	elseif(currentState == SWIPE_RIGHT) then
		swipeRight()

	elseif(currentState == SWIPE_UP) then
		if(not character.floor) then return end

   	if(previousState == SWIPE_LEFT) then
   		setState(SWIPE_LEFT)
   		swipeLeft()

   	elseif(previousState == SWIPE_RIGHT) then
   		setState(SWIPE_RIGHT)
   		swipeRight()

   	end

	else
		if(currentState ~= THROWING) then
   		local now = system.getTimer()
   		
   		if(now - startTouchTime > 800) then
   			setState(GRABBING, function() character.setGrabbing() end)
   		elseif(now - startTouchTime > 300) then
   			setState(READY_TO_THROW, function() character.setThrowing() end)
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

function swipeLeft()
	character.startMoveLeft()
end

function swipeRight()
	character.startMoveRight()
end

function swipeUp()
	character.jump()
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