-----------------------------------------------------------------------------

module(..., package.seeall)

-----------------------------------------------------------------------------

effects 	 		= {}
nbDestroyed   	= 0
nbRunning   	= 0

-------------------------------------

function start()
   effects 	 		= {}
   nbDestroyed   	= 0
   nbRunning   	= 0
	Runtime:addEventListener( "enterFrame", refreshEffects )
end

function stop(now)
	Runtime:removeEventListener( "enterFrame", refreshEffects )
	
	if(effects) then
		for i=1,#effects do
			destroyEffect(effects[i], now)
		end
	end
end

function restart()
	stop(true)
	start()
end

-----------------------------------------------------------------------------

function registerNewEffect( effect )
	effect.num = #effects+1
	effects[effect.num] = effect
end

-----------------------------------------------------------------------------

function startEffect( effect )
	effect:startMaster()
	effect.started = true

	--- debug
	nbRunning 	= nbRunning + 1
end

-----------------------------------------------------------------------------

function stopEffect( effect )
	effect:stopMaster()
	effect.started = false

	--- debug
	nbRunning 	= nbRunning - 1
end

-----------------------------------------------------------------------------

function destroyEffect( effect, now )
	if(not effect.beingDestroyed and effect.num) then -- else deja detruit (pb de lien pour le GC dans un performWithDelay ? exmple deleteRock + timeout 4sec force)
      effect.beingDestroyed = true
   	
   	if(not now and effect.body) then
   		utils.destroyFromDisplay(effect.body)
   	end
   
      if(effect.started) then
      	stopEffect(effect)
      end
      
      if(now) then
      	effect:destroyMaster() 
      	effect = nil
      else
         timer.performWithDelay(3000, function()
         	if(effect.num) then -- else detruit entre temps
         		effect:destroyMaster()
         	end 
         end)
      end

   -- Probleme : supprimer les nums decale en meme temps les nouveaux cest pourri
   --	table.remove(effects, effect.num) 
   --
   --	for i=effect.num, #effects do
   --		effects[i].num = effects[i].num - 1
   --	end 
   -- TODO vider la liste des effects nil !

		--- debug
      nbDestroyed = nbDestroyed + 1
      
		return true
	else
		return false
	end

end

-----------------------------------------------------------------------------

function destroyObjectWithEffect(body)
	if(body.effect) then
		return destroyEffect(body.effect)
	else
		return false
   end
end

-----------------------------------------------------------------------------
--- CHECK level effects in screen
-----------------------------------------------------------------------------
--
-- An effect on hud has no body => onScreen
-- 
-- An effect on camera must have a body (sensor (energy or trigger)) 
-- 	-> wake up if onScreen only
-- 	
-- An effect not static has its coordinates refreshed
-- 
-----------------------------------------------------------------------------

function refreshEffects()
	
	if(effects) then
		for i=1,#effects do
			local effect = effects[i]
			
			if(not effect.beingDestroyed and effect.num) then -- else passed throug destroyMaster
   			local isOnscreen = not effect.body -- si il n y a pas de body cest un simple effet visuel : onScreen (exemple drawFollow)
   			
   			if(game.state == game.RUNNING) then
      			if(not effect.static) then
      				refreshEffectsCoordinates(effect)
      			end
   
      			if(effect.isRope) then
      				refreshRopeCoordinates(effect)
      			end
   			
      			if( effect.body
      			and effect.body.x
      			and effect.body.x > (-game.camera.x - 50)/game.zoom
      			and effect.body.x < (display.contentWidth - game.camera.x + 50)/game.zoom 
      			and effect.body.y > (-game.camera.y - 50)/game.zoom
      			and effect.body.y < (display.contentHeight - game.camera.y + 50)/game.zoom) then
      				isOnscreen = true
      			end
   			end
   			
   			if(isOnscreen) then
   				if(not effect.started) then
   					startEffect(effect)
      			end
   			elseif(effect.started) then
      			stopEffect(effect)
   			end
   		end
		end
   end
end

function refreshEffectsCoordinates(effect)
	if(effect.body and effect.body.x and effect.body.y) then
   	effect:get("light").x = effect.body.x 
   	effect:get("light").y = effect.body.y
   end
end

function refreshRopeCoordinates(beam)
	beam:get("light").point1={beam.attach.x,beam.attach.y}
	beam:get("light").point2={character.sprite.x,character.sprite.y}
	beam:get("light").resetPoints()
end

-----------------------------------------------------------------------------
--- Menu Atmospheres
-----------------------------------------------------------------------------

function atmosphere(x,y, scale)
	
	local light=CBE.VentGroup{
		{
			title="light",
			preset="wisps",
			color={{65,5,2},{55,55,20},{15,15,120}},
			x = x,
			y = y,
			perEmit=math.random(1,5),
			emissionNum=0,
			emitDelay=320,
			lifeSpan=1800,
			fadeInTime=1800,
			scale=0.5*scale,
			physics={
				gravityY=0.025,
			}
		}
	}
	
	light.static = true
	registerNewEffect(light)	
	game.hud:insert(light:get("light").content)
	
end

-----------------------------------------------------------------------------
--- Buttons
-----------------------------------------------------------------------------

function buttonEffect(x,y, scale)
	
	local light=CBE.VentGroup{
		{
			title="light",
			preset="wisps",
			color={{45,35,23},{55,55,20},{15,15,30}},
			x = x,
			y = y+110*scale,
			perEmit=math.random(3,7),
			emissionNum=0,
			emitDelay=520,
			fadeInTime=2200,
			scale=3*scale,
			physics={
				gravityY=.021,
			}
		}
	}
	
	light.static = true
	registerNewEffect(light)	
	game.hud:insert(light:get("light").content)
	
end


-----------------------------------------------------------------------------
--- Spawn point
-----------------------------------------------------------------------------

function spawnEffect()
	
	-- a rope has been attached during the fall : cancel the respawn
	if(character.ropes and #character.ropes > 0) then return end
		
	local x,y = levelDrawer.level.spawnX, levelDrawer.level.spawnY
		
	local light=CBE.VentGroup{
		{
			title="light",
			preset="wisps",
			color={{65,65,262},{55,55,220}},
			x = x,
			y = y,
			perEmit=5,
			emissionNum=3,
			emitDelay=20,
			lifeSpan=400,
			fadeInTime=700,
			scale=0.6,
			physics={
				gravityY=0.07,
			}
		}
	}
	
	light.static = true
	registerNewEffect(light)	
	game.camera:insert(light:get("light").content)
	
	timer.performWithDelay(500, function() character.spawn() end)
	timer.performWithDelay(2000, function() destroyEffect(light) end)
end

-----------------------------------------------------------------------------
--- When character reach the exit
-----------------------------------------------------------------------------

function reachExitEffect(x,y)
	
	local light=CBE.VentGroup{
		{
			title="light",
			preset="wisps",
			color={{65,65,262},{55,55,220}},
			x = x,
			y = y,
			perEmit=2,
			emissionNum=3,
			emitDelay=220,
			lifeSpan=400,
			fadeInTime=500,
			scale=0.4,
			physics={
				gravityY=.07,
			}
		}
	}
	
	light.static = true
	registerNewEffect(light)	
	game.camera:insert(light:get("light").content)
	
	character.exit()
	game:stop()
end

-----------------------------------------------------------------------------
--- Level Exit
-----------------------------------------------------------------------------

function drawExit(x, y, displayScore)
	
	if(not type) then type = 1 end
	
	local light=CBE.VentGroup{
		{
			title="light",
			preset="wisps",
			color={{65,5,2},{55,55,20},{15,15,120}},
			x = x,
			y = y,
			perEmit=math.random(1,5),
			emissionNum=0,
			emitDelay=320,
			lifeSpan=1800,
			fadeInTime=1800,
			scale=0.5,
			physics={
				gravityY=0.025,
			}
		}
	}
	
	local exit = display.newImage("assets/images/game/energy.body.png")
	exit.light = light
	exit.x = x
	exit.y = y
	exit.isSensor = true
	
   physics.addBody( exit, "kinematic", { 
   	density = 0, 
   	friction = 0, 
   	bounce = 0,
   	radius = 20
   })
   
   game.camera:insert(exit)
	exit:addEventListener( "preCollision", preCollideExit )

	light.body = exit
	light.static = true
	registerNewEffect(light)	
	game.camera:insert(light:get("light").content)
end


function preCollideExit( event )
	if(event.contact) then
		event.contact.isEnabled = false
		
		if(event.other == character.sprite) then 
      	event.target:removeEventListener( "preCollision", preCollideExit )
			reachExitEffect(event.target.x, event.target.y)
   	end
         	
   end
end

-----------------------------------------------------------------------------
--- Level energies
-----------------------------------------------------------------------------

function drawEnergy(x, y, type)
	
	if(not type) then type = 1 end
	
	local light=CBE.VentGroup{
		{
			title="light",
			preset="wisps",
			color={{65,65,62},{55,55,20}},
			x = x,
			y = y,
			perEmit=1,
			emissionNum=0,
			emitDelay=150,
			fadeInTime=350,
			scale=0.15,
			physics={
				gravityY=0.03,
			}
		}
	}
	
	local energy = display.newImage("assets/images/game/energy.body.png")
	energy.type = type 
	energy.light = light
	energy.x = x
	energy.y = y
	energy.isSensor = true
	
   physics.addBody( energy, "kinematic", { 
   	density = 0, 
   	friction = 0, 
   	bounce = 0,
   })
   
   game.camera:insert(energy)
	energy:addEventListener( "preCollision", function(event) touchEnergy(energy, event) end )

	
	light.body = energy
	light.static = true
	registerNewEffect(light)	
	game.camera:insert(light:get("light").content)
end

function touchEnergy( energy, event )
	if(event.contact) then
		event.contact.isEnabled = false
   	
   	if(event.other == character.sprite) then
   		
   		if(not energy.light.beingDestroyed) then
   			game.energiesCaught 	= game.energiesCaught + 1
   			game.energiesRemaining = game.energiesRemaining + 1
      		destroyEffect(energy.light)
         	
         	timer.performWithDelay(200, function() drawFollow() end)
         	timer.performWithDelay(600, function() drawFollow() end)
         	timer.performWithDelay(1000, function() drawFollow() end)
         end
      end
   end
end

function drawFollow( )
	local follow = CBE.VentGroup{
		{
			preset="wisps",
			title="followLight", -- The pop that appears when a mortar shot explodes
			color={{105,135,182}},
			perEmit=1,
			emissionNum=1,
			emitDelay=210,
			fadeInTime=920,
			scale=0.3,
			physics={
				gravityX=0.53,
				gravityY=0.04,
			},
			x = character.sprite.x,
			y = character.sprite.y,
		}
	}
	
	follow.static = true
	follow:start("followLight")
	game.camera:insert(follow:get("followLight").content)
	
	registerNewEffect(follow)
	timer.performWithDelay(3000, function() destroyEffect(follow) end)
end

-----------------------------------------------------------------------------
--- Level pieces
-----------------------------------------------------------------------------

function lightPiece(piece)
	
	local light=CBE.VentGroup{
		{
			title="light",
			preset="wisps",
			color={{65,65,62},{55,55,20}},
			x = piece.x,
			y = piece.y,
			perEmit=2,
			emissionNum=0,
			emitDelay=250,
			lifeSpan=400,
			fadeInTime=700,
			scale=0.14,
			physics={
				gravityY=0.03,
			}
		}
	}
	
	piece.light = light
	piece.isSensor = true
	
   physics.addBody( piece, "kinematic", { 
   	density = 0, 
   	friction = 0, 
   	bounce = 0,
   })
   
	piece:addEventListener( "preCollision", touchPiece )

	light.body = piece
	light.static = true
	registerNewEffect(light)	
	game.camera:insert(light:get("light").content)
end



function touchPiece( event )
	local piece = event.target
	
	if(event.contact) then
		event.contact.isEnabled = false
   	
   	if(event.other == character.sprite) then
   		
   		if(not piece.caught) then

   			---------------------------------------------------------

   			piece.caught = true
   			game.hud:insert(piece)	
   			piece.x = piece.x*game.zoom + game.camera.x
   			piece.y = piece.y*game.zoom + game.camera.y
   			
   			---------------------------------------------------------
   			
   			local xTo, yTo
   			
   			if(piece.type == levelDrawer.SIMPLE_PIECE) then 
   				xTo, yTo = hud.SIMPLE_PIECE_ICON_LEFT, hud.SIMPLE_PIECE_ICON_TOP
   				game.ringsCaught 	= game.ringsCaught + 1
   			else	 
   				xTo, yTo = hud.PIECE_ICON_LEFT, hud.PIECE_ICON_TOP
   				game.piecesCaught = game.piecesCaught + 1
   			end

   			---------------------------------------------------------

   			transition.to(piece, {time = 1000, x = xTo, y = yTo})

   			---------------------------------------------------------
   			
   			-- detach piece body (body only useful to find out if piece is onScreen, now it's on HUD)
   			piece.light.body = nil
   			destroyEffect(piece.light)
         end
      end
   end
end

------------------------------------------------------------------------------------------
-- TRIGGERS
------------------------------------------------------------------------------------------

function drawTrigger(x, y, trigger)
	
	local light=CBE.VentGroup{
		{
			title="light",
			preset="wisps",
			color={{12,122,211},{55,255,20},{255,255,20}},
			x = x,
			y = y,
			perEmit=3,
			emissionNum=0,
			emitDelay=250,
			lifeSpan=400,
			fadeInTime=700,
			scale=0.2,
			physics={
				gravityY=0.06,
			}
		}
	}
	
	local body = display.newImage("assets/images/game/energy.body.png")
	body.trigger = trigger
	body.light = light
	body.x = x
	body.y = y
	
   physics.addBody( body, "kinematic", { 
   	density = 0, 
   	friction = 0, 
   	bounce = 0,
   })
   
   game.camera:insert(body)
	body:addEventListener( "preCollision", preCollideTrigger )
	body:addEventListener( "collision", collideTrigger )

	light.body = body
	light.static = true
	registerNewEffect(light)	
	game.camera:insert(light:get("light").content)
end

function preCollideTrigger( event )
	if(event.contact) then
		event.contact.isEnabled = false
   end
end

function collideTrigger( event )
	if(event.other.isRock) then
		if(not event.target.light.beingDestroyed) then
   		destroyEffect(event.target.light)
      end
      
		levelDrawer.hitTrigger(event.target.trigger)
   end
end

------------------------------------------------------------------------------------------
-- CHARACTER
------------------------------------------------------------------------------------------

function setCharacterThrowing()

	character.lightReadyToThrow = CBE.VentGroup{
		{
			preset="wisps",
			title="characterLight", -- The pop that appears when a mortar shot explodes
			color={{205,15,12}},
			perEmit=1,
			emissionNum=0,
			emitDelay=10,
			fadeInTime=15,
			scale=0.07,
			startAlpha=1,
			physics={
				divisionDamping = true,
				xDamping = 1.17,
				yDamping = 1,
				gravityY=0.06,
			}
		}
	}
	
	character.lightReadyToThrow.static = true
	game.camera:insert(character.lightReadyToThrow:get("characterLight").content)
	
	Runtime:addEventListener( "enterFrame", refreshCharacterLightCoordinates )

	registerNewEffect(character.lightReadyToThrow)
end

------------------------------------------

function setCharacterGrabbing()
	
	character.lightReadyToGrab = CBE.VentGroup{
		{
			preset="wisps",
			title="characterLight", -- The pop that appears when a mortar shot explodes
			color={{105,135,182}},
			perEmit=1,
			emissionNum=0,
			emitDelay=10,
			fadeInTime=15,
			scale=0.07,
			startAlpha=1,
			physics={
				divisionDamping = true,
				xDamping = 1.17,
				yDamping = 1,
				gravityY=0.06,
			}
		}
	}
	
	character.lightReadyToGrab.static = true
	game.camera:insert(character.lightReadyToGrab:get("characterLight").content)

	Runtime:addEventListener( "enterFrame", refreshCharacterLightCoordinates )
	
	registerNewEffect(character.lightReadyToGrab)
end

------------------------------------------

function refreshCharacterLightCoordinates()
	
	if(character.lightReadyToGrab) then
		effect = character.lightReadyToGrab
	elseif(character.lightReadyToThrow) then
		effect = character.lightReadyToThrow
   end
   
	if(effect.num) then -- else detruit depuis le dernier enterFrame ?
		effect:get("characterLight").x = character.sprite.x + 6*character.sprite.xScale 
		effect:get("characterLight").y = character.sprite.y + 5
   end
end

------------------------------------------

function stopCharacterLight()

	Runtime:removeEventListener( "enterFrame", refreshCharacterLightCoordinates )	

	if(character.lightReadyToThrow) then
		destroyEffect(character.lightReadyToThrow, true)
	end
	
	if(character.lightReadyToGrab) then
		destroyEffect(character.lightReadyToGrab, true)
	end
	
	character.lightReadyToGrab = nil
	character.lightReadyToThrow = nil
	
end

------------------------------------------------------------------------------------------
-- Items
------------------------------------------------------------------------------------------

function setItemFire(body)

	local fire = CBE.VentGroup{
		{
			preset="burn",
			title="light", -- The pop that appears when a mortar shot explodes
			color={{255,5,5}},
			perEmit=1,
			emissionNum=0,
			emitDelay=10,
			fadeInTime=1020,
			startAlpha=0.5,
			scale=0.32,
			physics={
				xDamping = 4,
				yDamping = 1,
				gravityY=0.06,
			}
		}
	}
	
	fire.body = body
	body.effect = fire
	
	game.camera:insert(fire:get("light").content)
	
	registerNewEffect(fire)
end


function greenFire(body)

	local fire = CBE.VentGroup{
		{
			preset="burn",
			title="light", -- The pop that appears when a mortar shot explodes
			color={{5,155,5},{45,255,45},{15,245,5}},
			perEmit=1,
			emissionNum=0,
			emitDelay=10,
			fadeInTime=200,
			startAlpha=0.3,
			scale=0.32,
			physics={
				xDamping = 4,
				yDamping = 1,
				gravityY=0.06,
			}
		}
	}
	
	fire.body = body
	body.effect = fire
	
	game.camera:insert(fire:get("light").content)
	
	registerNewEffect(fire)
end



-----------------------------------------------------------------------------
--- test
-----------------------------------------------------------------------------

function drawBeam(attach)

	local x1,y1 = attach.x, attach.y
	local x2,y2 = character.sprite.x, character.sprite.y
	
	-- bug tell Caleb : scale doesnt work with alongline
	local beam=CBE.VentGroup{
		{
			title="light",
			preset="wisps",
			color={{255,155,115}},
   		build=function()
   			local size=math.random(16, 25) -- Particles are a bit bigger than ice comet particles
   			return display.newImageRect("CBEffects/textures/generic_particle.png", size, size)
			end,
			onCreation=function()end,
			point1={x1,y1},
			point2={x2,y2},
			positionType="alongLine",
			perEmit=1,
			emissionNum=0,
			emitDelay=10,
   		fadeInTime=20,
   		startAlpha=0.6,
   		endAlpha=0.3,
			physics={
				xDamping = 32,
				yDamping = 15,
				gravityY=0.06,
			}
			
   	}
	}
	
	beam.isRope = true
	beam.static = true
	beam.attach = attach
	registerNewEffect(beam)	
	game.camera:insert(beam:get("light").content)
	
	return beam
end

---------------------------

function simpleBeam(body)

	local beam = CBE.VentGroup{
		{
			preset="wisps",
			title="light", -- The pop that appears when a mortar shot explodes
			color={{255,155,115}},
			perEmit=1,
			emissionNum=0,
			emitDelay=30,
			fadeInTime=50,
			startAlpha=0.9,
			scale=0.26,
			physics={
				xDamping = 7,
				yDamping = 1,
				gravityY=0.06,
			}
		}
	}
	
	beam.body = body
	body.effect = beam
	
	game.camera:insert(beam:get("light").content)
	
	registerNewEffect(beam)
end

function lightAttach(body)

	local beam = CBE.VentGroup{
		{
			preset="wisps",
			title="light", -- The pop that appears when a mortar shot explodes
			color={{255,155,115}},
			perEmit=1,
			emissionNum=0,
			emitDelay=50,
			fadeInTime=80,
			startAlpha=0.2,
			scale=0.12,
			physics={
				xDamping = 7,
				yDamping = 1,
				gravityY=0.06,
			}
		}
	}	
	
	beam.body = body
	body.effect = beam
	
	game.camera:insert(beam:get("light").content)
	
	registerNewEffect(beam)
end
