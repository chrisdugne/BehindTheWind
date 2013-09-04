-------------------------------------

module(..., package.seeall)

-------------------------------------

local tiles = require("src.game.graphics.Tiles")
local tilesSheet = graphics.newImageSheet( "assets/images/game/tiles.png", tiles.sheet )

local MOTION_SPEED = 60

-------------------------------------

function drawTile(view, num, x, y)
	
	local tile = display.newImage( view, tilesSheet, num )

	tile.x = x
	tile.y = y
	tile.num = num
	
	return tile
end

function drawEnergy(view, x, y, type)

	local light=CBE.VentGroup{
		{
			title="light",
			preset="wisps",
			color={{65,65,62},{55,55,20}},
			x = x,
			y = y,
			perEmit=1,
			emissionNum=0,
			emitDelay=250,
			lifeSpan=600,
			fadeInTime=700,
			physics={
				velocity=0.8,
				xDamping=1,
				gravityY=0.2,
				gravityX=0
			}
		}
	}
	
	local energy = display.newImage("assets/images/game/energy.body.png")
	energy.type = type 
	energy.light = light
	energy.x = x
	energy.y = y
	
   physics.addBody( energy, "kinematic", { 
   	density = 0, 
   	friction = 0, 
   	bounce = 0
   })
   
   view:insert(energy)
	energy:addEventListener( "preCollision", function(event) touchEnergy(energy, view, event) end )
	return energy
end

-------------------------------------

function touchEnergy( energy, view, event )
	if(event.other == character.sprite) then
		event.contact.isEnabled = false
   	energy.light:stopMaster()
   	display.remove(energy)
   	
   	timer.performWithDelay(3000, function() energy.light:destroyMaster() end)
   	timer.performWithDelay(200, function() drawFollow(view) end)
   	timer.performWithDelay(600, function() drawFollow(view) end)
   	timer.performWithDelay(1000, function() drawFollow(view) end)
   end
end

function drawFollow( view )
	local vx,vy = character.sprite:getLinearVelocity()
	local follow = CBE.VentGroup{
		{
			preset="wisps",
			title="followLight", -- The pop that appears when a mortar shot explodes
			color={{105,135,182}},
			perEmit=1,
			emissionNum=1,
			emitDelay=310,
			lifeSpan=520,
			fadeInTime=500,
			physics={
				gravityX=vx/5,
				gravityY=vy/5,
			},
			x = character.sprite.x,
			y = character.sprite.y,
		}
	}
	
	follow:start("followLight")
	view:insert(follow:get("followLight").content)
	
	timer.performWithDelay(3000, function() follow:destroyMaster() end)
end

---------------------------------------------------------------------

function addGroupMotion(group, motion)

	local motionStart 	= vector2D:new(motion.x1, motion.y1)
	local motionEnd		= vector2D:new(motion.x2, motion.y2)
	local direction 		= vector2D:Sub(motionEnd, motionStart)
	local distance			= direction:magnitude()
	local duration			= distance/MOTION_SPEED * 1000

	local motionVector 	= vector2D:Normalize(direction)
	motionVector:mult(MOTION_SPEED)
	
	for i = 1, #group do
		group[i].bodyType = "kinematic"
		moveTile(group[i], motionVector, 1, duration)
	end
end

function moveTile(tile, motionVector, way, duration)
	tile:setLinearVelocity( motionVector.x * way, motionVector.y * way)

	timer.performWithDelay(duration, function()
		moveTile(tile, motionVector, -way, duration)
	end)
end

---------------------------------------------------------------------

function addGroupDraggable(group, dragLine)

	local motionLimit = {}
	motionLimit.horizontal 	= dragLine.x2 - dragLine.x1
	motionLimit.vertical 	= dragLine.y2 - dragLine.y1

	for i = 1, #group do
		group[i]:addEventListener( "touch", function(event)
			touchController.dragGroup(group, motionLimit, event)
		end)
	end
end
