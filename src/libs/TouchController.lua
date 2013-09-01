-------------------------------------

module(..., package.seeall)

-------------------------------------

NONE 			= 0
SWIPE_RIGHT = 1
SWIPE_LEFT 	= 2
SWIPE_UP 	= 3

DRAGGING_TILE 	= 4

-------------------------------------

local hold = false
local touchState
local lastX
local lastY

-------------------------------------

function repeatCurrentAction( event )
	if(touchState == SWIPE_LEFT) then
		swipeLeft()
	elseif(touchState == SWIPE_RIGHT) then
		swipeRight()
	end
end
	
-------------------------------------

function touchScreen( event )
	
	if(state == DRAGGING_TILE) then return end
	
	if event.phase == "began" then
		hold = true	
   	Runtime:addEventListener( "enterFrame", repeatCurrentAction )

	elseif event.phase == "ended" then
		hold = false
   	Runtime:removeEventListener( "enterFrame", repeatCurrentAction )
		character.stop()
		
	elseif event.phase == "moved" then
	
		if(event.y + 40 < event.yStart) then
			touchState = SWIPE_UP
			swipeUp()

		elseif(event.x - 10 > event.xStart) then
			touchState = SWIPE_RIGHT

		elseif(event.x + 10 < event.xStart) then
			touchState = SWIPE_LEFT
		end
	end

	return true
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

function dragTile( tile, groups, event )
	
	if event.phase == "began" then
		state = DRAGGING_TILE
	elseif event.phase == "ended" then
		state = NONE
	end
	
	if(tile.group) then
		for i=1, #groups[tile.group] do
			translateUpDown(groups[tile.group][i], event)
			
			if(groups[tile.group][i].icon) then 
				translateUpDown(groups[tile.group][i].icon, event)
			end 
		end
	else
		translateUpDown(tile, event)
	end
	
	character.checkIfLift()
	
end

-------------------------------------

function drag( tile, event )
	
	if event.phase == "began" then
		tile.moving = true
		tile.markX = tile.x    -- store x location of object
		tile.markY = tile.y    -- store y location of object

	elseif event.phase == "ended" then
		tile.moving = false
	
	elseif event.phase == "moved" and tile.moving then

		local x = (event.x - event.xStart) + tile.markX
		local y = (event.y - event.yStart) + tile.markY
			
		tile.x, tile.y = x, y    -- move object based on calculations above
	end

	return true
end

---------------------------------------------------------------------

function translateUpDown( object, event )
	
	if event.phase == "began" then
		object.moving = true
		object.markY = object.y    -- store y location of object

	elseif event.phase == "ended" then
		object.moving = false
	
	elseif event.phase == "moved" and object.moving then

		local y = (event.y - event.yStart) + object.markY

		object.y = y    -- move object based on calculations above
	end

	return true
end

---------------------------------------------------------------------

function translateLeftRight( object, event )
	
	if event.phase == "began" then
		object.moving = true
		object.markX = object.x

	elseif event.phase == "ended" then
		object.moving = false
	
	elseif event.phase == "moved" and object.moving then

		local x = (event.x - event.xStart) + object.markX

		object.x = x
	end

	return true
end

---------------------------------------------------------------------