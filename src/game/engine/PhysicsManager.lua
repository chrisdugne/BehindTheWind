-------------------------------------

module(..., package.seeall)

-------------------------------------

function init( )
	local physics = require("physics")
	physics.start()
	physics.setGravity( 0, 20 )
	physics.setDrawMode( "hybrid" )
--	physics.setDrawMode( "debug" )
end

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
		body.tempJoint = physics.newJoint( "touch", body, event.x - camera.x, event.y-camera.y )

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
			body.tempJoint:setTarget( event.x - camera.x, event.y - camera.y )

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

	local xForce = 5.5*(x2-x1)
	local yForce = 5.5*(y2-y1)

	if(xForce > 600) then xForce = 600 end
	if(xForce < -600) then xForce = -600 end
	if(yForce > 500) then yForce = 500 end
	if(yForce < -500) then yForce = -500 end

	local rock = display.newImage(camera, "assets/images/game/rock.png");
	rock.x = character.sprite.x
	rock.y = character.sprite.y
	rock:scale(0.2,0.2)
	physics.addBody( rock, { density=3.0, friction=1, bounce=0.12, radius=7 } )
	rock:setLinearVelocity(xForce, yForce)
	
	rock:addEventListener( "preCollision", thrownFromCharacterPreCollision )
	rock:addEventListener( "collision", rockCollision )
	
	effectsManager.setItemFire(rock)

	timer.performWithDelay(4000, function()
		deleteRock(rock)
	end)
end

function deleteRock(rock)
	print("delete rock") 
	effectsManager.destroyObjectWithEffect(rock)
	rock = nil
end

-----------------------------------------------------------------------------------------------

function grab( x1,y1, x2,y2 )

	local xForce = 7.5*(x2-x1)
	local yForce = 7.5*(y2-y1)

	local rock = display.newImage(camera, "assets/images/game/rock.png");
	rock.x = character.sprite.x
	rock.y = character.sprite.y
	rock:scale(0.1,0.1)
	physics.addBody( rock, { density=1.0, friction=1, bounce=0.12, radius=3.5 } )
	rock:setLinearVelocity(xForce, yForce)
	
	rock:addEventListener( "preCollision", thrownFromCharacterPreCollision )
	rock:addEventListener( "collision", grabCollision )
	
	effectsManager.simpleBeam(rock)
	
	timer.performWithDelay(4000, function()
		deleteRock(rock)
	end)
end

-------------------------------------

function thrownFromCharacterPreCollision( event )
	print("precollision", event.other.isSensor)
	if(event.other == character.sprite or event.other.isSensor) then
		event.contact.isEnabled = false
	end
end

function rockCollision( event )
	print("rock collision", event.other.isSensor)
	if(event.other ~= character.sprite and not event.other.isSensor) then
		deleteRock(event.target)
   end
end


function grabCollision( event )
	if(event.other ~= character.sprite and not event.other.isSensor) then

		if ( event.phase == "ended" ) then
			local x,y = event.target.x, event.target.y
			timer.performWithDelay(30, function() buildRopeTo(x,y) end)

   		deleteRock(event.target)
		end

	end
end

-------------------------------------

function refreshRopeBeamCoordinates()
	
	local from = vector2D:new(character.sprite.x, character.sprite.y)
	
	for k,rope in pairs(character.ropes) do
   	local to = vector2D:new(rope.attachX, rope.attachY)
   	local points = utils.getPointsBetween(from, to, #rope.beamPoints)
   	
   	for i,point in pairs(rope.beamPoints) do
			point.x,point.y = points[i].x,points[i].y      	
   	end
   	
	end
end

-------------------------------------


function buildRopeTo( x,y )

	--------------------------

	local rope = {
		attachX = x,
		attachY = y,
		num = #character.ropes+1,
		beamPoints = {}
	}

	--------------------------
	-- calculate beam points

	local from 		= vector2D:new(character.sprite.x, character.sprite.y)
	local to 		= vector2D:new(rope.attachX, rope.attachY)

	local nbPoints = 18
	local points 	= utils.getPointsBetween(from, to, nbPoints)
	
	--------------------------
	-- draw beam points

	for i=1,nbPoints do
		local point = display.newCircle( camera, points[i].x, points[i].y, 2 )
		point.alpha = 0
		point.isSensor = true
		physics.addBody( point, "static", {radius=2, isSensor=true } )
   	effectsManager.beamPath(point)
   	table.insert(rope.beamPoints, point)
	end

	--------------------------
	-- attach point

	local attach = display.newCircle( camera, x, y, 9 )
	physics.addBody( attach, "static", {radius=9, density=2.0 } )
	effectsManager.lightAttach(attach)
	
	rope.attach = attach

	--------------------------
	-- joint

	local joint = physics.newJoint( "distance", character.sprite, attach, character.sprite.x,character.sprite.y, attach.x,attach.y )
	
	joint.isSensor = true
	joint.length = 50
	joint.frequency = 0.89
	joint.dampingRatio = 0.39
	
	rope.joint = joint
	
	--------------------------

	table.insert(character.ropes, rope)
	Runtime:addEventListener( "enterFrame", refreshRopeBeamCoordinates )
	
	--------------------------
	--  remove rope

	attach:addEventListener ( "touch", function() 
		detachRope(rope.num)	
	end )
end

---------------------------------------------------------------------------

function detachRope(num)
	
	local rope = character.ropes[num]	

	for i=1,#rope.beamPoints do
		effectsManager.destroyObjectWithEffect(rope.beamPoints[i])
	end
	
	effectsManager.destroyObjectWithEffect(rope.attach)
	display.remove(rope.joint)
	
	---------------------
	
	table.remove(character.ropes, rope.num)

	for i=rope.num,#character.ropes do
		character.ropes[i].num = character.ropes[i].num - 1
	end
	
	
end
