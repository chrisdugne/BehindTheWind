-------------------------------------

module(..., package.seeall)

-------------------------------------

local physics = require("physics")
physics.start()

-------------------------------------

local THROW_FORCE       = 11
local GRAVITY           = 16

local ROPE_LENGTH       = 100
local ROPE_FREQUENCY    = 1.9
local ROPE_DAMPING      = 2.4

-------------------------------------

local trajectory = nil

-------------------------------------

function start( )
    
    physics.setGravity( 0, GRAVITY )
    physics.setScale( 40 )
--    physics.setDrawMode( "hybrid" )
--    physics.setDrawMode( "debug" )
    
    trajectory = display.newGroup()
    game.camera:insert (trajectory)
end

-------------------------------------

function stop( )
    utils.emptyGroup(trajectory)
end

-------------------------------------
--        CORONA DRAG_BODY : not used
-------------------------------------
-- 
--function dragBody( event, params )
--    local body = event.target
--    local phase = event.phase
--    local stage = display.getCurrentStage()
--    
--    local params = {
--        maxForce = 600, 
--        dampingRatio = 0.6, 
--    }
--        
--    if "began" == phase then
--        stage:setFocus( body, event.id )
--        body.isFocus = true
--        body.tempJoint = physics.newJoint( "touch", body, event.x - game.camera.x, event.y-game.camera.y )
--
--        -- Apply optional joint parameters
--        if params then
--            local maxForce, frequency, dampingRatio
--
--            if params.maxForce then
--                -- Internal default is (1000 * mass), so set this fairly high if setting manually
--                body.tempJoint.maxForce = params.maxForce
--            end
--            
--            if params.frequency then
--                -- This is the response speed of the elastic joint: higher numbers = less lag/bounce
--                body.tempJoint.frequency = params.frequency
--            end
--            
--            if params.dampingRatio then
--                -- Possible values: 0 (no damping) to 1.0 (critical damping)
--                body.tempJoint.dampingRatio = params.dampingRatio
--            end
--        end
--    
--    elseif body.isFocus then
--        if "moved" == phase then
--        
--            -- Update the joint to track the touch
--            body.tempJoint:setTarget( event.x - game.camera.x, event.y - game.camera.y )
--
--        elseif "ended" == phase or "cancelled" == phase then
--            stage:setFocus( body, nil )
--            body.isFocus = false
--            
--            -- Remove the joint when the touch ends            
--            body.tempJoint:removeSelf()
--            
--        end
--    end
--
--    -- Stop further propagation of touch event
--    return true
--end

-----------------------------------------------------------------------------------------------

function abortThrow()
    utils.emptyGroup(trajectory)
end

-----------------------------------------------------------------------------------------------

function throw( x1,y1, x2,y2 )

    ----------------------------------------

    utils.emptyGroup(trajectory)
    local force = getThrowVelocity(x1,y1,x2,y2)

    ----------------------------------------

    local rock = display.newImage(game.camera, "assets/images/game/rock.png");
    rock.x = character.sprite.x
    rock.y = character.sprite.y
    rock:scale(0.1,0.1)
    physics.addBody( rock, { density=10000, friction=1, bounce=0.12, radius=7 } )
    rock:setLinearVelocity(force.vx, force.vy)
    
    rock:addEventListener( "preCollision", thrownFromCharacterPreCollision )
    rock:addEventListener( "collision", rockCollision )
    rock.isRock = true
    
    ----------------------------------------
    
    local color = {{255/255,5/255,5/255},{215/255,35/255,35/255},{155/255,175/255,35/255}}
    effectsManager.setFire(rock, color)

    ----------------------------------------
    
    character.rock = rock

    timer.performWithDelay(3500, function()
        deleteRock(rock)
    end)

    ----------------------------------------
    
    effectsManager.consumeEnergy()

    ---------------------------------------------------------

end

-----------------------------------------------------------------------------------------------

function grab( x1,y1, x2,y2 )
    
    utils.emptyGroup(trajectory)
    local force = getThrowVelocity(x1,y1,x2,y2)
    
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
    
    timer.performWithDelay(3000, function()
        deleteRock(rock)
    end)

end

-----------------------------------------------------------------------------------------------

function eyeThrow( enemy )
    
    if(character.state == OUT) then return end
    local viewDirection = vector2D:new(enemy.direction.x,enemy.direction.y)

    local strength 
    local alpha

    if(enemy.sprite.y < character.sprite.y) then
        alpha = -math.pi*0.4
        strength = math.min(viewDirection:magnitude(), 100)
    else
        alpha = -math.pi*2.26
        strength = math.min(viewDirection:magnitude(), 300)
    end
    
    local direction = vector2D:new(enemy.direction.x*(0.48 + 0.0004*strength),enemy.direction.y*(0.11 - 0.0003*strength))
    

    direction:rotate(alpha * abs(enemy.sprite.x - character.sprite.x)/(enemy.sprite.x - character.sprite.x) )
    local force = getThrowVelocity(enemy.sprite.x,enemy.sprite.y, enemy.sprite.x + direction.x, enemy.sprite.y + direction.y)

    local rock = display.newImage(game.camera, "assets/images/game/rock.png");
    rock.x = enemy.sprite.x
    rock.y = enemy.sprite.y
    rock.alpha = 0.6
    rock:scale(0.2,0.2)
    physics.addBody( rock, { density=10000, friction=1, bounce=0.12, radius=14 } )
    rock:setLinearVelocity(force.vx, force.vy)
    
    rock:addEventListener( "preCollision", thrownFromEnemyPreCollision )
    rock:addEventListener( "collision", enemyRockCollision )
    rock.isBadRock = true
    
    local color = {{5/255,255/255,5/255},{35/255,215/255,35/255},{175/255,155/255,35/255}}
    effectsManager.setFire(rock, color)

    timer.performWithDelay(4500, function()
        deleteRock(rock)
    end)
    
end

-----------------------------------------------------------------------------------------------

function enemyThrow( enemy )
    local force = getThrowVelocity(enemy.sprite.x,enemy.sprite.y, enemy.sprite.x - enemy.direction.x/2, enemy.sprite.y - enemy.direction.y/2)

    local rock = display.newImage(game.camera, "assets/images/game/rock.png");
    rock.x = sprite.x
    rock.y = sprite.y
    rock:scale(0.1,0.1)
    physics.addBody( rock, { density=10000, friction=1, bounce=0.12, radius=7 } )
    rock:setLinearVelocity(force.vx, force.vy)
    
    rock:addEventListener( "preCollision", thrownFromEnemyPreCollision )
    rock:addEventListener( "collision", enemyRockCollision )
    rock.isBadRock = true
    
    local color = {{5/255,255/255,5/255},{35/255,215/255,35/255},{175/255,155/255,35/255}}
    effectsManager.setFire(rock, color)

    timer.performWithDelay(4500, function()
        deleteRock(rock)
    end)
    
end

-------------------------------------

function thrownFromEnemyPreCollision( event )
    if(event.contact) then
       if(event.other.isEnemy
       or event.other.isSensor
       or event.other.isEnemy
       or event.other.trigger
       or event.other.isAttach) then
           event.contact.isEnabled = false
       end
    end
end

function enemyRockCollision( event )
    if(not event.other.isEnemy 
    and not event.other.isSensor
    and not event.other.isEnemy
    and not event.other.trigger
    and not event.other.isGrab) then
        deleteRock(event.target)
   end
end

-------------------------------------

function thrownFromCharacterPreCollision( event )

    if(event.other == character.sprite
    or event.other.isSensor
    or event.other.isBadRock
    or event.other.isEnemy
    or event.other.isAttach) then
        event.contact.isEnabled = false
    end
end

function rockCollision( event )
    if(event.other ~= character.sprite 
    and not event.other.isSensor
    and not event.other.isAttach
    and not event.other.isGrab) then
        deleteRock(event.target)
   end
end

--
--function grabCollision( event )
--    
--    if(event.other ~= character.sprite 
--    and character.state ~= character.OUT
--    and not event.other.isSensor
--    and not event.other.isGrab
--    and not event.other.isRock
--    and not event.other.isBadRock
--    and not event.other.isEnemy
--    and not event.other.trigger
--    and not event.other.isAttach
--    and event.target == character.rock) then
--
--        if ( event.phase == "ended" ) then
--            local ground = event.other
--            local x,y = event.target.x, event.target.y
--            
--            timer.performWithDelay(30, function()
--                
--                buildRopeTo(x,y,ground)
--            
--                timer.performWithDelay(250, function()
--                    if(#character.ropes == 2) then
--                        detachPreviousRope()    
--                    end
--               end)
--            end)
--
--           deleteRock(event.target)
--        end
--
--    end
--end

---------------------------------------------------------------------------

function deleteRock(rock)
    
    local explosion = {
        x = rock.x,
        y = rock.y,
        color = rock.effect.color
    }
    
    local destroyedRightNow = effectsManager.destroyObjectWithEffect(rock)
    
    if(destroyedRightNow) then
       if(rock.isGrab) then
           character.grabs = character.grabs - 1 -- deprecated
       else
          effectsManager.explode(explosion)
      end
   end

    
end

---------------------------------------------------------------------------

function removeTrigger(trigger)
    utils.destroyFromDisplay(trigger)
end

---------------------------------------------------------------------------

function getThrowVelocity(x1,y1, x2,y2)
    
    local xForce = THROW_FORCE*(x2-x1)
    local yForce = THROW_FORCE*(y2-y1)

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
    
    local velocity = getThrowVelocity(fingerX, fingerY, xStart, yStart)
    local startingVelocity = {
        x = velocity.vx,
        y = velocity.vy
    }

    utils.emptyGroup(trajectory)

    for i = 1,40 do
        local trajectoryPosition = getTrajectoryPoint( startingPosition, startingVelocity, i*1.4 )
        local circ = display.newCircle( trajectory, trajectoryPosition.x, trajectoryPosition.y, 2.7 )
        circ.alpha = 0.5
    end
end

function getTrajectoryPoint( startingPosition, startingVelocity, n )
   --velocity and gravity are given per second but we want time step values here
   local t = 1/display.fps  --seconds per time step at 60fps
   local stepVelocity = { x=t*startingVelocity.x, y=t*startingVelocity.y }
   local stepGravity = { x=t*0, y=t*GRAVITY }
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

    if(not x or not y or not ground) then return end
    
    --------------------------

    musicManager:playGrab()
    
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
    attach.isSensor = true
    attach.alpha = 0

    rope.attach = attach
    
    --------------------------
    -- joint

    local joint = physics.newJoint( "distance", character.sprite, attach, character.sprite.x,character.sprite.y, attach.x,attach.y )
    
    joint.isSensor         = true
    joint.length             = ROPE_LENGTH
    joint.frequency         = ROPE_FREQUENCY
    joint.dampingRatio     = ROPE_DAMPING

    rope.joint = joint
    
    --- anchor point at x,y... dont really understand why but joint doesnt "start" without this physics.addBody at x,y !        
    rope.startAnchor = display.newCircle( game.camera, character.sprite.x, character.sprite.y, 2 )
    rope.startAnchor.alpha = 0
    rope.startAnchor.isGrab = true -- considere comme un grab, pour ne pas entrer en collision !
    physics.addBody( rope.startAnchor, "static", {radius=2, isSensor = true } )

    --------------------------
    
   rope.beam = effectsManager.drawBeam(rope.attach)

    --------------------------

    table.insert(character.ropes, rope)
    Runtime:addEventListener( "enterFrame", refreshRopeCoordinates )
    
    --------------------------

    character.setHanging(true)
    
end

---------------------------------------------------------------------------

function detachAllRopes()
    
    for i = 1,#character.ropes do
        local rope = character.ropes[i]    
       rope.attach.ground.bodyType = rope.attach.ground.lastBodyType
   
       effectsManager.destroyObjectWithEffect(rope.attach)
       effectsManager.destroyEffect(rope.beam)
       
       utils.destroyFromDisplay(rope.startAnchor)
       utils.destroyFromDisplay(rope.joint)
    end

    Runtime:removeEventListener( "enterFrame", refreshRopeCoordinates )
    character.detachAllRopes()
    
end

---------------------------------------------------------------------------

function detachPreviousRope()

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
    
    return true -- not to get a touchScreen !
    
end

---------------------------------------------------------------------------

function drawCheckpoint(checkPoint)
    
    local body = display.newImage("assets/images/game/planet.white.png")
    body.x = checkPoint.x
    body.y = checkPoint.y
    body.checkPoint = checkPoint
    body.alpha = 0
    body.isSensor = true
    
   physics.addBody( body, "kinematic", { 
       density = 0, 
       friction = 0, 
       bounce = 0,
       radius = 35,
   })
   
   game.camera:insert(body)
    body:addEventListener( "preCollision", touchCheckpoint )

end

function touchCheckpoint( event )
    local checkPoint = event.target.checkPoint
    
    if(event.contact) then
        event.contact.isEnabled = false
       
       if(event.other == character.sprite) then
            levelDrawer.level.spawnX = checkPoint.x
            levelDrawer.level.spawnY = checkPoint.y
      end
   end
end