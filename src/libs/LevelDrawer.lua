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

	local lifeSpan = 400
	if(type == MEDIUM_ENERGY) then lifeSpan = 800 end
	if(type == BIG_ENERGY) then lifeSpan = 1200 end

	local light=CBE.VentGroup{
		{
			title="light",
			preset="wisps",
			color={{65,65,62},{55,55,20}},
			x = x,
			y = y,
			perEmit=1,
			emissionNum=0,
			emitDelay=300,
			lifeSpan=1200,
			physics={
				velocity=0.5,
				xDamping=1,
				gravityY=0.6,
				gravityX=0
			}
		}
	}
	light:start("light")
	view:insert(light:get("light").content)
	
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
end

-------------------------------------

function touchEnergy( energy, view, event )
	if(event.other == character.sprite) then
		event.contact.isEnabled = false
   	energy.light:stopMaster()
   	display.remove(energy)
   	
   	timer.performWithDelay(3000, function() energy.light:destroyMaster() end)
   	
   	drawFollow(view)
   end
end

function drawFollow( view )
	local vx,vy = character.sprite:getLinearVelocity()
	print(vx,vy)
	local follow = CBE.VentGroup{
		{
			preset="wisps",
			title="followLight", -- The pop that appears when a mortar shot explodes
			color={{0, 255, 0}},
			emitDelay=300,
			perEmit=1,
			emissionNum=5,
			lifeSpan=300,
			alpha=0.6,
			startAlpha=0,
			endAlpha=0,
   		fadeInTime = 1400,
			physics={
   			maxX=5,maxY=5,
   			relativeToSize=true,
				velocity=0,
				gravityY=0
			},
			x = character.sprite.x,
			y = character.sprite.y,
		}
	}
	follow:start("followLight")
	view:insert(follow:get("followLight").content)
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
