-------------------------------------

module(..., package.seeall)

-------------------------------------

function init( )
	local physics = require("physics")
	physics.start()
	physics.setGravity( 0, 20 )
--	physics.setDrawMode( "hybrid" )
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

	local xForce = 5*(x2-x1)
	local yForce = 5*(y2-y1)

	if(xForce > 300) then xForce = 300 end
	if(xForce < -300) then xForce = -300 end
	if(yForce > 500) then yForce = 500 end
	if(yForce < -500) then yForce = -500 end

	local rock = display.newImage(camera, "assets/images/game/rock.png");
	rock.x = character.sprite.x
	rock.y = character.sprite.y
	rock:scale(0.2,0.2)
	physics.addBody( rock, { density=3.0, friction=1, bounce=0.12, radius=7 } )
	rock:setLinearVelocity(xForce, yForce)
	
	rock:addEventListener( "preCollision", rockHit )
	
end

-------------------------------------

function rockHit( event )
	if(event.other == character.sprite) then
		event.contact.isEnabled = false
	end
end