-------------------------------------

module(..., package.seeall)

-------------------------------------

NONE 			= 0
SWIPE_RIGHT = 1
SWIPE_LEFT 	= 2
SWIPE_UP 	= 3

DRAGGING_TILE 	= 4

-------------------------------------

local hold 					= false
local previousState 		= NONE
local currentState 		= NONE
local xStart				= 0
local yStart				= 0
local lastX					= 0
local lastY					= 0

-------------------------------------

function repeatCurrentAction( event )

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

	end
end
	
-------------------------------------

function touchScreen( event )
	
	lastX, lastY = event.x, event.y
	
	if(not character.floor) then
		xStart, yStart = lastX, lastY
	end
	
	if(currentState == DRAGGING_TILE) then return end
   	
	if event.phase == "began" then
		hold = true	
		xStart, yStart = event.xStart, event.yStart
   	display.getCurrentStage():setFocus( character.sprite )
   	Runtime:addEventListener( "enterFrame", repeatCurrentAction )

	elseif event.phase == "ended" then
		hold = false
		setState(NONE, event)
		character.stop()
   	display.getCurrentStage():setFocus( nil )
   	Runtime:removeEventListener( "enterFrame", repeatCurrentAction )
		
	elseif event.phase == "moved" then
	
		if(event.y + 40 < yStart) then
			setState(SWIPE_UP)
			swipeUp()

		elseif(event.x - 40 > xStart) then
			setState(SWIPE_RIGHT)

		elseif(event.x + 40 < xStart) then
			setState(SWIPE_LEFT)
		end
		
	end

	return true
end

-------------------------------------

function setState(state)
	
	if(currentState ~= state) then
		xStart, yStart = lastX, lastY
		previousState = currentState
		currentState = state
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