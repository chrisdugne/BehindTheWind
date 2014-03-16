-----------------------------------------------------------------------------------------

module(..., package.seeall)

-----------------------------------------------------------------------------------------
-- var TUTO LEVEL 1
-----------------------------------------------------------------------------------------

--local helpVisible1 = false
--local tween11

-----------------------------------------------------------------------------------------
-- var TUTO LEVEL 2
-----------------------------------------------------------------------------------------

local helpVisibleLevel2 = false
local requireHelpLevel2 = true

-----------------------------------------------------------------------------------------
-- var TUTO LEVEL 3
-----------------------------------------------------------------------------------------

local helpVisibleLevel3 = false
local requireHelpLevel3 = true
local tileToDrag

-----------------------------------------------------------------------------------------
-- var TUTO LEVEL 4
-----------------------------------------------------------------------------------------

local helpVisibleLevel4 = false
local requireHelpLevel4 = true

-----------------------------------------------------------------------------------------

function start()

    if(game.level == 2) then
        requireHelpLevel2 = true
        Runtime:addEventListener( "enterFrame", refreshHUDTutoLevel2 )

    elseif(game.level == 3) then
        requireHelpLevel3 = true
        Runtime:addEventListener( "enterFrame", refreshHUDTutoLevel3 )
        --
        --      elseif(game.level == 4) then
        --       requireHelpLevel4 = true
        --       Runtime:addEventListener( "enterFrame", refreshHUDTutoLevel4 )
        --   
    end

end

-----------------------------------------------------------------------------------------

function destroy()

    if(game.level == 2) then
        Runtime:removeEventListener( "enterFrame", refreshHUDTutoLevel2 )
        destroyTutoLevel2()
    end

    if(game.level == 3) then
        Runtime:removeEventListener( "enterFrame", refreshHUDTutoLevel3 )
        destroyTutoLevel3()
    end

    if(game.level == 4) then
        Runtime:removeEventListener( "enterFrame", refreshHUDTutoLevel4 )

        if(helpVisibleLevel41) then
            destroyTutoLevel41()
        elseif(helpVisibleLevel42) then
            destroyTutoLevel42()
        end
    end

    character.movesLocked = false
    character.grabLocked = false
end

-----------------------------------------------------------------------------------------
-- TUTO LEVEL 2
-----------------------------------------------------------------------------------------

function refreshHUDTutoLevel2()

    if(character.sprite.x > 170 
    and character.sprite.x < 230 
    and character.sprite.y < 310 
    and character.sprite.y > 250) then

        if(requireHelpLevel2 and not helpVisibleLevel2) then

            character.movesLocked = true
            game.hud.leftButton.alpha = 0
            game.hud.rightButton.alpha = 0

            showHelpLevel2()

        else
            if(character.hanging) then
                character.movesLocked = false
                destroyTutoLevel2()
            end
        end 

    end     
end

function destroyTutoLevel2()
    helpVisibleLevel2 = false
    requireHelpLevel2 = false
    transition.cancel(game.hud.finger)
    display.remove(game.hud.finger)
end


-------------------------------

function showHelpLevel2()
    helpVisibleLevel2 = true

    game.hud.finger = display.newImage(game.camera, "assets/images/hud/touch.png")
    game.hud.finger:scale(0.3,0.3)
    game.hud.finger.alpha = 0.9

    --------------

    tweenLevel2On()
end

function tweenLevel2On()
    if(not helpVisibleLevel2) then return end
    game.hud.finger.x       = 350
    game.hud.finger.y       = 160
    game.hud.finger.alpha   = 0.1
    transition.to( game.hud.finger, { time=800, alpha=0.9, transition=easing.inSine, onComplete=tweenLevel2Off })
end

function tweenLevel2Off()
    transition.to( game.hud.finger, { time=800, alpha=0.1, onComplete=tweenLevel2On})
end


-----------------------------------------------------------------------------------------
-- TUTO LEVEL 3
-----------------------------------------------------------------------------------------

function refreshHUDTutoLevel3()

    if(character.sprite.x > 110 
    and character.sprite.x < 200 
    and character.sprite.y < 350 
    and character.sprite.y > 290) then

        if(requireHelpLevel3 and not helpVisibleLevel3) then

            for k,group in pairs(levelDrawer.level.groups) do
                if(k == 5) then
                    tileToDrag = group[1]
                end
            end

            character.grabLocked = true
            character.movesLocked = true

            game.hud.leftButton.alpha = 0
            game.hud.rightButton.alpha = 0

            showHelpLevel3()

        else
            if(tileToDrag.x < 290) then
                character.grabLocked = false
                character.movesLocked = false


                game.hud.leftButton.alpha = 1
                game.hud.rightButton.alpha = 1

                destroyTutoLevel3()
            end
        end 

    end     
end

function destroyTutoLevel3()
    helpVisibleLevel3 = false
    requireHelpLevel3 = false
    transition.cancel(game.hud.finger)
    display.remove(game.hud.finger)
end


-------------------------------

function showHelpLevel3()
    helpVisibleLevel3 = true

    game.hud.finger = display.newImage(game.camera, "assets/images/hud/touch.png")
    game.hud.finger:scale(0.3,0.3)
    game.hud.finger.alpha = 0.9

    --------------

    tweenLevel3On()
end

function tweenLevel3On()
    if(not helpVisibleLevel3) then return end
    game.hud.finger.x = tileToDrag.x
    game.hud.finger.y = tileToDrag.y + tileToDrag.contentHeight*0.5
    transition.to( game.hud.finger, { time=300, alpha=0.9 })
    transition.to( game.hud.finger, { time=2500, x=250, transition=easing.inSine, onComplete=tweenLevel3Off })
end

function tweenLevel3Off()
    transition.to( game.hud.finger, { time=700, alpha=0, onComplete=function() timer.performWithDelay(800, tweenLevel3On) end})
end

----------------------------------------------------------------


-----------------------------------------------------------------------------------------
-- TUTO LEVEL 4
-----------------------------------------------------------------------------------------

function refreshHUDTutoLevel4()

    if(character.sprite.x > 90 
    and character.sprite.x < 250 
    and character.sprite.y < 350 
    and character.sprite.y > 250) then

        if(requireHelpLevel4 and not helpVisibleLevel4) then
            character.movesLocked = true
            showHelpLevel4()
        end 

    elseif(helpVisibleLevel4) then
        -- grab ok
        character.movesLocked = false
        destroyTutoLevel4()
    end     
end

function destroyTutoLevel4()
    helpVisibleLevel4 = false
    requireHelpLevel4 = false
    display.remove(game.hud.helpImage4)
end


-------------------------------

function showHelpLevel4()
    helpVisibleLevel4 = true
    game.hud.helpImage4 = display.newImage(game.camera, "assets/images/tutorial/tuto4.2.png", character.sprite.x - 280, character.sprite.y - 280)
end

----------------------------------------------------------------