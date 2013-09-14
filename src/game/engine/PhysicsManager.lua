-------------------------------------

module(..., package.seeall)

-------------------------------------

local physics = require("physics")
physics.start()

-------------------------------------

local trajectory = nil

-------------------------------------

function start( )
	
	physics.setGravity( 0, 20 )
--	physics.setDrawMode( "hybrid" )
--	physics.setDrawMode( "debug" )
	
	trajectory = display.newGroup()
	game.camera:insert (trajectory)
end

-------------------------------------

function stop( )
	utils.emptyGroup(trajectory)
end

-------------------------------------

function dragBody( event, params )
	local body = event.target
	local phase = event.phase
	local stage = display.getCurrentStage()
	
	local params = {
		maxForce = 600, 
		dampingRatio = 0.6, 
	}
		
	if "began" == phase then
		stage:setFocus( body, event.id )
		body.isFocus = true
		body.tempJoint = physics.newJoint( "touch", body, event.x - game.camera.x, event.y-game.camera.y )

		-- Apply optional joint parameters
		if params then
			local maxForce, frequency, dampingRatio

			if params.maxForce then
				-- Internal default is (1000 * mass), so set this fairly high if setting manually
				body.tempJoint.maxForce = params.maxForce
			end
			
			if params.frequency then
				-- This is the response speed of the elastic joint: higher numbers = less lag/bounce
				body.tempJoint.frequency = params.frequency
			end
			
			if params.dampingRatio then
				-- Possible values: 0 (no damping) to 1.0 (critical damping)
				body.tempJoint.dampingRatio = params.dampingRatio
			end
		end
	
	elseif body.isFocus then
		if "moved" == phase then
		
			-- Update the joint to track the touch
			body.tempJoint:setTarget( event.x - game.camera.x, event.y - game.camera.y )

		elseif "ended" == phase or "cancelled" == phase then
			stage:setFocus( body, nil )
			body.isFocus = false
			
			-- Remove the joint when the touch ends			
			body.tempJoint:removeSelf()
			
		end
	end

	-- Stop further propagation of touch event
	return true
end

-----------------------------------------------------------------------------------------------

function throw( x1,y1, x2,y2 )

	utils.emptyGroup(trajectory)
	local force = getVelocity(x1,y1,x2,y2)

	local rock = display.newImage(game.camera, "assets/images/game/rock.png");
	rock.x = character.sprite.x
	rock.y = character.sprite.y
	rock:scale(0.2,0.2)
	physics.addBody( rock, { density=10000, friction=1, bounce=0.12, radius=7 } )
	rock:setLinearVelocity(force.vx, force.vy)
	
	rock:addEventListener( "preCollision", thrownFromCharacterPreCollision )
	rock:addEventListener( "collision", rockCollision )
	rock.isRock = true
	
	effectsManager.setItemFire(rock)
	character.rock = rock

	timer.performWithDelay(7000, function()
		deleteRock(rock)
	end)

	hud.showFollowRockButton()
end

-----------------------------------------------------------------------------------------------

function grab( x1,y1, x2,y2 )
	
	utils.emptyGroup(trajectory)
	local force = getVelocity(x1,y1,x2,y2)
	
	local rock = display.newImage(game.camera, "assets/images/game/rock.png");
	rock.x = character.sprite.x
	rock.y = character.sprite.y
	rock:scale(0.1,0.1)
	physics.addBody( rock, { density=1.0, friction=1, bounce=0.12, radius=3.5 } )
	rock:setLinearVelocity(force.vx, force.vy)
	
	rock:addEventListener( "preCollision", thrownFromCharacterPreCollision )
	rock:addEventListener( "collision", grabCollision )
	rock.isGrab = true
	
	effectsManager.simpleBeam(rock)

	character.rock = rock
	
	timer.performWithDelay(7000, function()
		deleteRock(rock)
	end)

	hud.showFollowRockButton()
end

-------------------------------------

function thrownFromCharacterPreCollision( event )

	if(event.other == character.sprite
	and not event.other.isSensor
	and not event.other.isAttach) then
		event.contact.isEnabled = false
	end
end

function rockCollision( event )
	if(event.other ~= character.sprite and not event.other.isSensor) then
		deleteRock(event.target)
   end
end


function grabCollision( event )
	if(event.other ~= character.sprite 
	and not event.other.isSensor
	and not event.other.trigger
	and not event.other.isAttach) then

		if ( event.phase == "ended" ) then
			local ground = event.other
			local x,y = event.target.x, event.target.y
			
			timer.performWithDelay(30, function()
				buildRopeTo(x,y,ground)
				timer.performWithDelay(250, function()
					if(#character.ropes == 2) then
						detachRope(1)	
					end
   			end)
			end)

   		deleteRock(event.target)
		end

	end
end

---------------------------------------------------------------------------

function deleteRock(rock)
	
	if(character.rock == rock) then
   	hud.hideFollowRockButton()
   end
	
	effectsManager.destroyObjectWithEffect(rock)
	rock = nil
	
end

---------------------------------------------------------------------------

function removeTrigger(trigger)
	utils.destroyFromDisplay(trigger)
end

---------------------------------------------------------------------------

function getVelocity(x1,y1, x2,y2)
	
	local xForce = 5.2*(x2-x1)
	local yForce = 5.2*(y2-y1)

	return {
		vx = xForce,	
		vy = yForce	
	}

end

function refreshTrajectory(fingerX, fingerY, xStart, yStart)
	
	local startingPosition = {
		x = character.sprite.x,
		y = character.sprite.y
	}
	
	local velocity = getVelocity(fingerX, fingerY, xStart, yStart)
	local startingVelocity = {
		x = velocity.vx,
		y = velocity.vy
	}

	utils.emptyGroup(trajectory)

	for i = 1,180 do
		local trajectoryPosition = getTrajectoryPoint( startingPosition, startingVelocity, i )
		local circ = display.newCircle( trajectory, trajectoryPosition.x, trajectoryPosition.y, 1 )
	end
end

function getTrajectoryPoint( startingPosition, startingVelocity, n )
   --velocity and gravity are given per second but we want time step values here
   local t = 1/display.fps  --seconds per time step at 60fps
   local stepVelocity = { x=t*startingVelocity.x, y=t*startingVelocity.y }
   local stepGravity = { x=t*0, y=t*20 }
   return {
      x = startingPosition.x + n * stepVelocity.x + 0.5 * (n*n+n) * stepGravity.x,
      y = startingPosition.y + n * stepVelocity.y + 0.5 * (n*n+n) * stepGravity.y
   }
end

-----------------------------------------------------------------------------------------------------------------
--- ROPES
-----------------------------------------------------------------------------------------------------------------

function refreshRopeCoordinates()
	for k,rope in pairs(character.ropes) do
		if(rope.attach.ground and rope.attach.ground.x) then
      	rope.attach.x = rope.attach.ground.x - rope.attach.offsetX 
      	rope.attach.y = rope.attach.ground.y - rope.attach.offsetY
      end
	end
end

function buildRopeTo(x,y,ground)
	
	--------------------------

	local rope = {}
	rope.num = #character.ropes+1

	--------------------------

	ground.lastBodyType = ground.bodyType
	ground.bodyType = "kinematic"
	
	--------------------------
	-- attach point

	local attach = display.newCircle( game.camera, x, y, 9 )
	physics.addBody( attach, "static", {radius=9, density=2.0 } )
	effectsManager.lightAttach(attach)
	
	attach.ground = ground
	attach.offsetX = ground.x - x
	attach.offsetY = ground.y - y
	attach.isAttach = true

	rope.attach = attach
	
	--------------------------
	-- joint

	local joint = physics.newJoint( "distance", character.sprite, attach, character.sprite.x,character.sprite.y, attach.x,attach.y )
	
	joint.length = 75
	joint.frequency = 1.7
	joint.dampingRatio = 0.29

	rope.joint = joint
	
	-- anchor point at x,y... dont really understand why but joint doesnt "start" without this physics.addBody at x,y !		
	rope.startAnchor = display.newCircle( game.camera, character.sprite.x, character.sprite.y, 2 )
	rope.startAnchor.alpha = 0
	physics.addBody( rope.startAnchor, "static", {radius=2, isSensor = true } )

	--------------------------
	
   rope.beam = effectsManager.drawBeam(rope.attach.x, rope.attach.y, character.sprite.x, character.sprite.y)

	--------------------------

	table.insert(character.ropes, rope)
	Runtime:addEventListener( "enterFrame", refreshRopeCoordinates )
	
	--------------------------
	--  remove rope

	attach:addEventListener ( "touch", detachRope)
	character.sprite:addEventListener ( "touch", detachRope) 
	character.setHanging(true)
end

---------------------------------------------------------------------------

function detachRope(event)

	local rope = character.ropes[1]	
	rope.attach.ground.bodyType = rope.attach.ground.lastBodyType

	effectsManager.destroyObjectWithEffect(rope.attach)
	effectsManager.destroyEffect(rope.beam)
	
	utils.destroyFromDisplay(rope.startAnchor)
	utils.destroyFromDisplay(rope.joint)
	
	---------------------
	
	table.remove(character.ropes, rope.num)

	for i=rope.num,#character.ropes do
		character.ropes[i].num = character.ropes[i].num - 1
	end

	---------------------
	
	if(#character.ropes == 0) then	
		character.setHanging(false)
		Runtime:removeEventListener( "enterFrame", refreshRopeCoordinates )
	end
	
	character.sprite:removeEventListener ( "touch", detachRope) 
	
	return true -- not to get a touchScreen !
end
