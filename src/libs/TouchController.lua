-------------------------------------

module(..., package.seeall)

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