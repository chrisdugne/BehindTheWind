-----------------------------------------------------------------------------

module(..., package.seeall)

-----------------------------------------------------------------------------

effects         = {}
nbDestroyed     = 0
nbRunning       = 0

-------------------------------------

function start()
    effects         = {}
    nbDestroyed     = 0
    nbRunning       = 0
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
    nbRunning     = nbRunning + 1
end

-----------------------------------------------------------------------------

function stopEffect( effect )
    effect:stopMaster()
    effect.started = false

    --- debug
    nbRunning     = nbRunning - 1
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
        --    table.remove(effects, effect.num) 
        --
        --    for i=effect.num, #effects do
        --        effects[i].num = effects[i].num - 1
        --    end 
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
--     -> wake up if onScreen only
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
            color={{65/255,5/255,2/255},{55/255,55/255,20/255},{15/255,15/255,120/255}},
            x = x,
            y = y,
            perEmit=math.random(2,5),
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
            color={{45/255,35/255,23/255},{55/255,55/255,20/255},{15/255,15/255,30/255}},
            x = x,
            y = y+110*scale,
            perEmit=2,
            emissionNum=0,
            emitDelay=520,
            fadeInTime=2200,
            scale=2.3*scale,
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
            color={{65/255,65/255,262/255},{55/255,55/255,220/255},{55/255,55/255,220/255}},
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

    timer.performWithDelay(100, function() character.spawn() end)
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
            color={{65/255,65/255,262/255},{55/255,55/255,220/255}},
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
    
    musicManager:playExit()
    
    character.exit(function()
        game:stop()
    end)
end

-----------------------------------------------------------------------------
--- Level Exit
-----------------------------------------------------------------------------

function drawExit(x, y)

    if(not type) then type = 1 end

    local light=CBE.VentGroup{
        {
            title="light",
            preset="wisps",
            color={{65/255,5/255,2/255},{55/255,55/255,20/255},{15/255,15/255,120/255}},
            x = x,
            y = y,
            perEmit=3,
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

--    local light=CBE.VentGroup{
--        {
--            title="light",
--            preset="wisps",
--            color={{65/255,65/255,62/255},{55/255,55/255,20/255}},
--            x = x,
--            y = y,
--            perEmit=1,
--            emissionNum=0,
--            inTime = 450,
--            outTime = 550,
--            scale=0.07,
--            physics={
--                gravityY=0.05,
--            }
--        }
--    }

    local energy = display.newImage( game.hud, "assets/images/hud/energy.png")
    energy.x = x 
    energy.y = y 
    energy.type = type 
    energy.isSensor = true
    energy:scale(0.1,0.1)
    energy.light = {} -- remplace le ventgroup

    physics.addBody( energy, "kinematic", { 
        density = 0, 
        friction = 0, 
        bounce = 0,
        radius = 8
    })

    game.camera:insert(energy)
    energy:addEventListener( "preCollision", function(event) touchEnergy(energy, event) end )


--    light.body = energy
--    light.static = true
--    registerNewEffect(light)    
--    game.camera:insert(light:get("light").content)
end

function touchEnergy( energy, event )
    if(event.contact) then
        event.contact.isEnabled = false

        if(event.other == character.sprite) then

            if(not energy.light.beingDestroyed) then

                ---------------------------------------------------------

                game.energiesCaught     = game.energiesCaught + 1

                ---------------------------------------------------------

                local tmpEnergy = display.newImage( game.hud, "assets/images/hud/energy.png")
                tmpEnergy.x = energy.x*game.zoom + game.camera.x
                tmpEnergy.y = energy.y*game.zoom + game.camera.y
                tmpEnergy.alpha=0.7
                tmpEnergy:scale(0.5,0.5)

                ---------------------------------------------------------

                local xTo, yTo = hud.ENERGY_TEXT_LEFT, hud.ENERGY_TEXT_TOP

                ---------------------------------------------------------

                transition.to(tmpEnergy, {
                    time = 1000, 
                    x = xTo, y = yTo, 
                    xScale=0.2, yScale=0.2, 
                    alpha=0.3, 
                    easing.outExpo,
                    onComplete=function() utils.destroyFromDisplay(tmpEnergy) end
                })

                ---------------------------------------------------------

--                destroyEffect(energy.light)
                display.remove(energy)

                ---------------------------------------------------------

                musicManager:playEnergy()
                
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
            preset="smallwisps",
            title="light",
            color={{105/255,135/255,182/255}},
            perEmit=1,
            emissionNum=1,
            emitDelay=210,
            fadeInTime=520,
            scale=0.3,
            physics={
                xDamping = 1.09,
                gravityX=0,
                gravityY=0.04,
            },
            x = character.sprite.x,
            y = character.sprite.y,
        }
    }

    follow.static = true

    registerNewEffect(follow)
    game.camera:insert(follow:get("light").content)
end

-----------------------------------------------------------------------------

function notEnoughEnergy()

    transition.to(game.hud.energy, {
        time = 70, 
        xScale=0.8, yScale=0.8, 
        onComplete=function() 
            transition.to(game.hud.energy, {
                time = 70, 
                xScale=0.5, yScale=0.5
            }) 
        end
    })

end

function consumeEnergy()

    ----------------------------------------

    local tmpEnergy = display.newImage( game.hud, "assets/images/hud/energy.png")
    tmpEnergy.x = hud.ENERGY_ICON_LEFT
    tmpEnergy.y = hud.ENERGY_ICON_TOP
    tmpEnergy.alpha=1
    tmpEnergy:scale(0.6,0.6)

    ----------------------------------------

    local xTo = hud.ENERGY_TEXT_LEFT

    ----------------------------------------

    transition.to(tmpEnergy, {
        time = 1000, 
        x = xTo, 
        xScale=0.2, yScale=0.2, 
        alpha=0, 
        easing.outExpo,
        onComplete=function() utils.destroyFromDisplay(tmpEnergy) end
    })

end


-----------------------------------------------------------------------------
--- Level pieces
-----------------------------------------------------------------------------

function lightPiece(piece)

    local light=CBE.VentGroup{
        {
            title="light",
            preset="wisps",
            color={{65/255,65/255,62/255},{55/255,55/255,20/255}},
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
                
                musicManager:playRing()
                
                ---------------------------------------------------------

                piece.caught = true

                -- detach piece body (body only useful to find out if piece is onScreen, now it's on HUD)
                piece.light.body = nil
                destroyEffect(piece.light)

                ---------------------------------------------------------

                --- delay : to avoid error : Cannot translate an object before collision is resolved.
                timer.performWithDelay(20, function()

                    game.hud:insert(piece)    
                    piece.x = character.screenX() + game.camera.x
                    piece.y = character.screenY() + game.camera.y

                    ---------------------------------------------------------

                    local xTo, yTo

                    if(piece.type == levelDrawer.SIMPLE_PIECE) then 
                        xTo, yTo = hud.SIMPLE_PIECE_ICON_LEFT, hud.SIMPLE_PIECE_ICON_TOP
                        game.ringsCaught     = game.ringsCaught + 1
                    else     
                        xTo, yTo = hud.PIECE_ICON_LEFT, hud.PIECE_ICON_TOP
                        game.piecesCaught = game.piecesCaught + 1
                    end
                    transition.to(piece, {time = 1000, x = xTo, y = yTo})
                end)

            end
        end
    end
end

-----------------------------------------------------------------------------
--- Eyes
-----------------------------------------------------------------------------

function lightEye(sprite)

    local light=CBE.VentGroup{
        {
            title="light",
            preset="wisps",
            color = {{5/255,255/255,5/255},{35/255,215/255,35/255},{175/255,155/255,35/255}},
            x = sprite.x,
            y = sprite.y,
            perEmit=1,
            emissionNum=0,
            emitDelay=50,
            lifeSpan=1260,
            fadeInTime=1700,
            scale=0.58,
            physics={
                gravityY=0.034,
            }
        }
    }

    sprite.light = light
    light.body = sprite
    light.static = true
    registerNewEffect(light)    
    game.camera:insert(light:get("light").content)
end

------------------------------------------------------------------------------------------
-- TRIGGERS
------------------------------------------------------------------------------------------

function drawTrigger(x, y, trigger)

    local light=CBE.VentGroup{
        {
            title="light",
            preset="wisps",
            color={{12/255,122/255,211/255},{55/255,255/255,20/255},{255/255,255/255,20/255}},
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
    body.isSensor = true
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

    light.body = body
    light.static = true
    registerNewEffect(light)    
    game.camera:insert(light:get("light").content)
end

function preCollideTrigger( event )
    if(event.contact) then
        event.contact.isEnabled = false

        if(event.other == character.sprite) then

            if(not event.target.light.beingDestroyed) then
                destroyEffect(event.target.light)
            end
            
            musicManager:playTrigger()
            levelDrawer.hitTrigger(event.target.trigger)
        end
    end
end


function drawTriggerTouched(x,y)
    local follow = CBE.VentGroup{
        {
            preset="wisps",
            title="light",
            color={{12/255,122/255,211/255},{55/255,255/255,20/255},{255/255,255/255,20/255}},
            perEmit=3,
            emissionNum=1,
            emitDelay=110,
            fadeInTime=520,
            scale=0.4,
            physics={
                gravityX=0.33,
                gravityY=0.04,
            },
            x = x,
            y = y,
        }
    }

    follow.static = true

    registerNewEffect(follow)
    game.camera:insert(follow:get("light").content)
end

function unlockTrigger(x, y)
    local unlock = CBE.VentGroup{
        {
            preset="wisps",
            title="light",
            color={{12/255,122/255,211/255},{55/255,255/255,20/255},{255/255,255/255,20/255}},
            perEmit=3,
            emissionNum=1,
            emitDelay=110,
            fadeInTime=1520,
            scale=0.38,
            physics={
                gravityX=0.03,
                gravityY=0.04,
            },
            x = x,
            y = y,
        }
    }

    unlock.static = true

    registerNewEffect(unlock)
    game.camera:insert(unlock:get("light").content)
end

------------------------------------------------------------------------------------------
-- Items
------------------------------------------------------------------------------------------

function setFire(body, color)

    local fire = CBE.VentGroup{
        {
            preset="burn",
            title="light", -- The pop that appears when a mortar shot explodes
            color=color,
            perEmit=1,
            emissionNum=0,
            emitDelay=20,
            fadeInTime=120,
            startAlpha=0.8,
            startAlpha=0.1,
            scale=0.42,
            physics={
                divisionDamping=true,
                xDamping = 0,
                yDamping = 0,
                gravityY=0.06,
            }
        }
    }

    fire.body = body
    fire.color = color
    body.effect = fire

    game.camera:insert(fire:get("light").content)

    registerNewEffect(fire)
end


function greenFire(body)

    local fire = CBE.VentGroup{
        {
            preset="burn",
            title="light", -- The pop that appears when a mortar shot explodes
            color={{5/255,105/255,5/255},{65/255,205/255,45/255},{45/255,195/255,45/255}},
            perEmit=1,
            emissionNum=0,
            emitDelay=10,
            fadeInTime=200,
            startAlpha=0.3,
            scale=0.32,
            physics={
                divisionDamping=true,
                xDamping = 10,
                yDamping = 10,
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
-- Explosions
-----------------------------------------------------------------------------

function explode(explosion)

    local light=CBE.VentGroup{
        {
            title="light",
            preset="wisps",
            color=explosion.color,
            x = explosion.x,
            y = explosion.y,
            perEmit=4,
            emissionNum=3,
            emitDelay=20,
            lifeSpan=500,
            fadeInTime=explosion.fadeInTime or 550,
            scale=explosion.scale or 0.79,
            physics={
                gravityY=.03,
            }
        }
    }

    light.static = true
    registerNewEffect(light)    
    game.camera:insert(light:get("light").content)

end

-----------------------------------------------------------------------------
--- Ropes
-----------------------------------------------------------------------------

function drawBeam(attach)
    
    local x1,y1 = attach.x, attach.y
    local x2,y2 = character.sprite.x, character.sprite.y

    -- bug tell Caleb : scale doesnt work with alongline
    local beam=CBE.VentGroup{
        {
            title="light",
            preset="linewisps",
            positionType="alongLine",
            color={{255/255,155/255,115/255}},
            point1={x1,y1},
            point2={x2,y2},
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
            color={{55/255,55/255,115/255}},
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
            color={{255/255,155/255,115/255}},
            fadeInTime=80,
            startAlpha=0.2,
            scale=0.12,
            physics={
                xDamping = 1,
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

------------------------------------------------------------------------------------------
-- CHARACTER
------------------------------------------------------------------------------------------
-- DEPRECATED : plus de switch de throw => pas besoin de lights => gain en perfs
------------------------------------------------------------------------------------------
-- 
--function setCharacterThrowing()
--
--    character.lightReadyToThrow = CBE.VentGroup{
--        {
--            preset="wisps",
--            title="characterLight", -- The pop that appears when a mortar shot explodes
--            color={{105,15,12}},
--            perEmit=1,
--            emissionNum=0,
--            emitDelay=150,
--            fadeInTime=225,
--            scale=0.15,
--            startAlpha=1,
--            physics={
--                divisionDamping = true,
--                xDamping = 1.17,
--                yDamping = 1,
--                gravityY=0.06,
--            }
--        }
--    }
--    
--    character.lightReadyToThrow.static = true
--    game.camera:insert(character.lightReadyToThrow:get("characterLight").content)
--    
--    Runtime:addEventListener( "enterFrame", refreshCharacterLightCoordinates )
--
--    registerNewEffect(character.lightReadyToThrow)
--end
--
--------------------------------------------
--
--function setCharacterGrabbing()
--    
--    character.lightReadyToGrab = CBE.VentGroup{
--        {
--            preset="wisps",
--            title="characterLight", -- The pop that appears when a mortar shot explodes
--            color={{105,135,182}},
--            perEmit=1,
--            emissionNum=0,
--            emitDelay=150,
--            fadeInTime=225,
--            scale=0.17,
--            startAlpha=1,
--            physics={
--                divisionDamping = true,
--                xDamping = 1.17,
--                yDamping = 1,
--                gravityY=0.06,
--            }
--        }
--    }
--    
--    character.lightReadyToGrab.static = true
--    game.camera:insert(character.lightReadyToGrab:get("characterLight").content)
--
--    Runtime:addEventListener( "enterFrame", refreshCharacterLightCoordinates )
--    
--    registerNewEffect(character.lightReadyToGrab)
--end
--
--------------------------------------------
--
--function refreshCharacterLightCoordinates()
--    
--    if(character.lightReadyToGrab) then
--        effect = character.lightReadyToGrab
--    elseif(character.lightReadyToThrow) then
--        effect = character.lightReadyToThrow
--   end
--   
--    if(effect.num) then -- else detruit depuis le dernier enterFrame ?
--        effect:get("characterLight").x = character.sprite.x + 6*character.sprite.xScale 
--        effect:get("characterLight").y = character.sprite.y + 5
--   end
--end
--
--------------------------------------------
--
--function stopCharacterLight()
--
--    Runtime:removeEventListener( "enterFrame", refreshCharacterLightCoordinates )    
--
--    if(character.lightReadyToThrow) then
--        destroyEffect(character.lightReadyToThrow, true)
--    end
--    
--    if(character.lightReadyToGrab) then
--        destroyEffect(character.lightReadyToGrab, true)
--    end
--    
--    character.lightReadyToGrab = nil
--    character.lightReadyToThrow = nil
--    
--end