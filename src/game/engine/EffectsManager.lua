-------------------------------------

module(..., package.seeall)

-------------------------------------

effects = nil

-------------------------------------

function init()
	effects = {}
	Runtime:addEventListener( "enterFrame", checkEffectsInScreen )
end

-------------------------------------

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

------------------------------------------

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
