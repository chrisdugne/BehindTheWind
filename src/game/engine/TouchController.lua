---------------------------------------------------------------------

module(..., package.seeall)

---------------------------------------------------------------------

NONE 					= 0

--READY_TO_THROW 	= 11
--THROWING 			= 13
--GRABBING 			= 14

DRAGGING_SCREEN 	= 100
DRAGGING_TILE 		= 101
TOUCHING_TILE 		= 102
--PINCHING 			= 103

---------------------------------------------------------------------

--SWIPE_MAX 			= 140 

---------------------------------------------------------------------

currentState 				= NONE
rightTouch					= false
leftTouch					= false
moveTouchFingerId			= nil
throwTouchFingerId		= nil


--swipping						= false
--centerTouch					= false

--local previousState 		= NONE
local xStart				= 0
local yStart				= 0
local lastX					= 0
local lastY					= 0
--local startTouchTime		= 0
--local previousTapTime	= 0

--local lastTouchCharacterTime = 0

--local centerTapping		= 0
--local sideTapping			= 0

--local touches = {}



---------------------------------------------------------------------

--local TAP_TIME_LIMIT		= 250

---------------------------------------------------------------------

function start()
	display.getCurrentStage():addEventListener( "touch", touchScreen )
	
--   currentState 				= NONE
--   swipping						= false
   rightTouch					= false
   leftTouch					= false
--   centerTouch					= false
   
--	touches = {}
end

function stop()
	display.getCurrentStage():removeEventListener( "touch", touchScreen )
--	Runtime:removeEventListener( "enterFrame", onTouch )
	display.getCurrentStage():setFocus( nil )
end

---------------------------------------------------------------------
--function getNbTouches()
--	local nb = 0
--	for k,v in pairs(touches) do
--		if(v) then nb = nb + 1 end
--	end
--	return nb
--end
---------------------------------------------------------------------

function touchScreen( event )

	-----------------------------
	--	OUT  : dont listen action

	if(character.state == character.OUT) then
   	cancelAllTouches(event.id)
		return 
	end

	-----------------------------
	
	if(currentState == DRAGGING_TILE) then return end
	if(currentState == TOUCHING_TILE) then return end

	-----------------------------
	
	dragScreen(event)

--	-----------------------------
--	
--	lastX, lastY = event.x, event.y
--   	
--	---------------------------------------------

	if event.phase == "began" then
   	
      display.getCurrentStage():setFocus( game.camera )
--		
--   	
--	---------------------------------------------
--	
--	elseif "moved" == event.phase then
--		
--		if(event.id == throwTouchFingerId and character.throwFire) then
--			hud.placeFireSmallButton(event)
--		
--		elseif(event.id == throwTouchFingerId and character.throwGrab) then
--			hud.placeGrabSmallButton(event)
--		
--		end
--
--	----------------------------------------------------------------------
--	
	elseif event.phase == "ended" or event.phase == "cancelled" then
      
      display.getCurrentStage():setFocus( nil )
   	cancelAllTouches(event.id)
		character.stop()
		setState(NONE)
		
	end

	return false
end

---------------------------------------------------------------------

function cancelAllTouches(fingerId)

	display.getCurrentStage():setFocus( nil )

	-----------------------------

	rightTouch 	= false
	leftTouch 	= false

	-----------------------------
	
	hud.releaseAllButtons(fingerId)
end

---------------------------------------------------------------------

function setState(state, toApply)
	
	if(currentState ~= state) then
		xStart, yStart = lastX, lastY
--		previousState = currentState
		currentState = state
		
		if(toApply ~= nil) then
			toApply()
		end
	end
	
end

---------------------------------------------------------------------

function touchTile( tile, event )
	
	--------------
	
	if(character.grabLocked) then return end
	if(character.state == character.OUT) then return end

	--------------
	
	if(event.phase == "began") then

		tile.touchX = tile.x
		tile.touchY = tile.y
	
		if(not tile.draggable) then
      	display.getCurrentStage():setFocus( event.target )
   		setState(TOUCHING_TILE)
		end

	--------------

	elseif(event.phase == "ended" or event.phase == "cancelled" ) then

		tile.releaseX = tile.x
		tile.releaseY = tile.y
			
		if(not tile.draggable) then
			display.getCurrentStage():setFocus( nil )
   		setState(NONE)
		end
	
		if(tile.grabbable and (tile.touchX == tile.releaseX and tile.touchY == tile.releaseY)) then
--			character.sprite.angularVelocity = 0		
--			character.sprite.rotation = 0
			physicsManager.buildRopeTo(tile.touchX, tile.touchY, tile)
			
			timer.performWithDelay(20, function()
				if(#character.ropes > 1) then
					physicsManager.detachPreviousRope()	
				end
			end)
		end

	--------------

	end

	return false 
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
		
		if(tile.icons) then
   		for k,icon in pairs(tile.icons) do
   			if(icon) then
         		icon.x, icon.y = x, y
      		end
   		end
		end

	elseif event.phase == "ended" or event.phase == "cancelled" then
		tile.moving = false
		
	end

	return true
end
	
---------------------------------------------------------------------
--- ici on prend en compte le game.zoom
-- car les x,y des events sont ceux du screen
-- or on bouge les x,y dans le monde, la camera => il faut compter le zoom

function dragScreen( event )
	
	if event.phase == "began" then
		game.camera.markX = game.camera.offsetX    -- store x location of object
		game.camera.markY = game.camera.offsetY    -- store y location of object
		setState(DRAGGING_SCREEN)
	
	elseif event.phase == "moved" and currentState == DRAGGING_SCREEN then
		
		local x = ((event.x - event.xStart) + game.camera.markX)
		local y = ((event.y - event.yStart) + game.camera.markY)
		
		game.camera.offsetX = x
		game.camera.offsetY = y
		
		if(game.camera.offsetX > display.contentWidth*0.4 ) then
			game.camera.offsetX = display.contentWidth*0.4
		end

		if(game.camera.offsetX < -display.contentWidth*0.4 ) then
			game.camera.offsetX = -display.contentWidth*0.4
		end

		if(game.camera.offsetY > display.contentHeight*0.4 ) then
			game.camera.offsetY = display.contentHeight*0.4
		end

		if(game.camera.offsetY < -display.contentHeight*0.4 ) then
			game.camera.offsetY = -display.contentHeight*0.4
		end

	elseif event.phase == "ended" or event.phase == "cancelled" then
		setState(NONE)
		
	end

	return true
end

---------------------------------------------------------------------

--function calculateDelta( previousTouches, event )
--	local id,touch = next( previousTouches )
--	if event.id == id then
--		id,touch = next( previousTouches, id )
--		assert( id ~= event.id )
--	end
--
--	local dx = touch.x - event.x
--	local dy = touch.y - event.y
--	return dx, dy
--end
--
-----------------------------------------------------------------------
--
--function getLaunchVector()
--
--	local direction = vector2D:new(xStart - lastX, yStart - lastY )
--	if(direction:magnitude() > SWIPE_MAX) then
--		direction:normalize()
--		direction:mult(SWIPE_MAX)
--	end
--
--	return vector2D:new(xStart - direction.x, yStart - direction.y)
--end