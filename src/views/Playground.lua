-----------------------------------------------------------------------------------------
--
-- AppHome.lua
--
-----------------------------------------------------------------------------------------

local scene = storyboard.newScene()
local top, bottom

-----------------------------------------------------------------------------------------
-- BEGINNING OF YOUR IMPLEMENTATION
-- 
-- NOTE: Code outside of listener functions (below) will only be executed once,
--         unless storyboard.removeScene() is called.
-- 

-----------------------------------------------------------------------------------------

-- Called when the scene's view does not exist:
function scene:createScene( event )
end

-----------------------------------------------------------------------------------------

-- Called immediately after scene has moved onscreen:
function scene:enterScene( event )

    -- pas compris : enterScene est appele 2 fois quand router.openPlayground
    -- donc pour le game.start je ne le start pas 2 fois -> (pb avec effectsManager sinon)
    -- par contre, pour init le BG, je ne filtre pas, sinon j'ai des pbs de transitions ??
    -- surement un pb corona quils contournent en enterScene 2 fois...

    transition.to( game.hud, { time=600, alpha=1 })  

    if(not game.state or game.state == game.STOPPED) then
       game:start()
   end
   
--   
--    timer.performWithDelay(300, function()
--       transition.to( top,         { time=1400, alpha=0.3, y = -display.contentHeight/2 })
--       transition.to( bottom,     { time=1400, alpha=0.3, y = display.contentHeight *1.5  })  
--    end)
--    
end


-- Called when scene is about to move offscreen:
function scene:exitScene( event )
    Runtime:removeEventListener( "enterFrame", self.refreshCamera )
end

-- If scene's view is removed, scene:destroyScene() will be called just prior to:
function scene:destroyScene( event )
end

-----------------------------------------------------------------------------------------
-- END OF YOUR IMPLEMENTATION
-----------------------------------------------------------------------------------------

-- "createScene" event is dispatched if scene's view does not exist
scene:addEventListener( "createScene", scene )

-- "enterScene" event is dispatched whenever scene transition has finished
scene:addEventListener( "enterScene", scene )

-- "exitScene" event is dispatched whenever before next scene's transition begins
scene:addEventListener( "exitScene", scene )

-- "destroyScene" event is dispatched before view is unloaded, which can be
-- automatically unloaded in low memory situations, or explicitly via a call to
-- storyboard.purgeScene() or storyboard.removeScene().
scene:addEventListener( "destroyScene", scene )

-----------------------------------------------------------------------------------------

return scene