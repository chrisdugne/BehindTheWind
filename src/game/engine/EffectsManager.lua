-----------------------------------------------------------------------------

module(..., package.seeall)

-----------------------------------------------------------------------------

effects 	= nil
items 	= nil

-------------------------------------

function init()
	effects = {}
	items = {}
	Runtime:addEventListener( "enterFrame", checkEffectsInScreen )
	Runtime:addEventListener( "enterFrame", refreshItemsLightCoordinates )
end

-----------------------------------------------------------------------------
--- CHECK level effects in screen
-----------------------------------------------------------------------------

function checkEffectsInScreen()
	if(effects) then
		for i=1,#effects do
			local effect = effects[i]
			local isOnscreen = false
			if( effect.x
			and effect.x > -camera.x - 50
			and effect.x < display.contentWidth - camera.x + 50 
			and effect.y > -camera.y - 50
			and effect.y < display.contentHeight - camera.y + 50) then
				isOnscreen = true
			end
			
			if(isOnscreen) then
				if(not effect.started) then
					effect.light:startMaster()
					camera:insert(effect.light:get("light").content)
   				effect.started = true
   			end
			elseif(effect.started) then
				effect.light:stopMaster()
				effect.started = false
			end
		end


   end
end

-----------------------------------------------------------------------------
--- Level energies
-----------------------------------------------------------------------------

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
				gravityY=0.04
			}
		}
	}
	
	local energy = display.newImage("assets/images/game/energy.body.png")
	energy.type = type 
	energy.light = light
	energy.x = x
	energy.y = y
	energy.isTrigger = true
	
   physics.addBody( energy, "kinematic", { 
   	density = 0, 
   	friction = 0, 
   	bounce = 0
   })
   
   view:insert(energy)
	energy:addEventListener( "preCollision", function(event) touchEnergy(energy, view, event) end )
	
	table.insert(effects, energy)
end


function touchEnergy( energy, view, event )
	if(event.contact) then
		event.contact.isEnabled = false
   	
   	if(event.other == character.sprite) then
      	energy.light:stopMaster()
      	display.remove(energy)
      	
      	timer.performWithDelay(3000, function() energy.light:destroyMaster() end)
      	timer.performWithDelay(200, function() drawFollow(view) end)
      	timer.performWithDelay(600, function() drawFollow(view) end)
      	timer.performWithDelay(1000, function() drawFollow(view) end)
      end
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
			emitDelay=210,
			lifeSpan=920,
			physics={
				gravityX=0.83*math.abs(vx)/vx,
				gravityY=0.04*math.abs(vy)/vy,
			},
			x = character.sprite.x,
			y = character.sprite.y,
		}
	}
	
	follow:start("followLight")
	view:insert(follow:get("followLight").content)
	
	timer.performWithDelay(3000, function() follow:destroyMaster() end)
end

------------------------------------------------------------------------------------------
-- CHARACTER
------------------------------------------------------------------------------------------

function setCharacterThrowing()

	character.light = CBE.VentGroup{
		{
			preset="wisps",
			title="characterLight", -- The pop that appears when a mortar shot explodes
			color={{205,15,12}},
			perEmit=3,
			emissionNum=0,
			emitDelay=10,
			lifeSpan=20,
			scale=0.16,
			linearDamping=0,
			physics={
				divisionDamping = true,
				xDamping = 1.17,
				yDamping = 1,
				gravityY=0.06,
			}
		}
	}
	
	character.light:startMaster()
	camera:insert(character.light:get("characterLight").content)
	
	Runtime:addEventListener( "enterFrame", refreshCharacterLightCoordinates )
end

------------------------------------------

function setCharacterGrabbing()
	
	if(character.light) then character.light.stopMaster() end
	
	character.light = CBE.VentGroup{
		{
			preset="wisps",
			title="characterLight", -- The pop that appears when a mortar shot explodes
			color={{105,135,182}},
			perEmit=1,
			emissionNum=0,
			emitDelay=30,
			lifeSpan=25,
			scale=0.2,
			physics={
				divisionDamping = true,
				xDamping = 1.17,
				yDamping = 1,
				gravityY=0.06,
			}
		}
	}
	
	character.light:startMaster()
	camera:insert(character.light:get("characterLight").content)
end

------------------------------------------

function refreshCharacterLightCoordinates()
	character.light:get("characterLight").x = character.sprite.x + 16*character.sprite.xScale 
	character.light:get("characterLight").y = character.sprite.y + 15
end

------------------------------------------

function stopCharacterLight()
	if(character.light) then
		Runtime:removeEventListener( "enterFrame", refreshCharacterLightCoordinates )	
		character.light.destroyMaster()
		character.light = nil
	end
end

------------------------------------------------------------------------------------------
-- Items
------------------------------------------------------------------------------------------

function setItemFire(item)

	item.light = CBE.VentGroup{
		{
			preset="burn",
			title="light", -- The pop that appears when a mortar shot explodes
			color={{255,5,5}},
			perEmit=1,
			emissionNum=0,
			emitDelay=1,
			startAlpha=0.5,
			scale=0.46,
			physics={
				xDamping = 4,
				yDamping = 1,
				gravityY=0.06,
			}
		}
	}
	
	item.light:startMaster()
	camera:insert(item.light:get("light").content)
	
	item.num = #items+1
	table.insert(items, item)
end

function setItemLight(item)

	item.light = CBE.VentGroup{
		{
			preset="wisps",
			title="light", -- The pop that appears when a mortar shot explodes
			color={{255,155,115}},
			perEmit=2,
			emissionNum=0,
			emitDelay=3,
			fadeInTime=1400,
			startAlpha=0.5,
			scale=0.26,
			physics={
				xDamping = 7,
				yDamping = 1,
				gravityY=0.06,
			}
		}
	}
	
	item.light:startMaster()
	camera:insert(item.light:get("light").content)
	
	item.num = #items+1
	table.insert(items, item)
end

function off(item)

	item.light.stopMaster()
	table.remove(items, item.num)
	
	timer.performWithDelay(2000, function()
   	item.light.destroyMaster()
   	item.light = nil
   	item = nil
	end)
end

function refreshItemsLightCoordinates()
	for i=1,#items do
		local item = items[i]
   	item.light:get("light").x = item.x 
   	item.light:get("light").y = item.y
   end
end