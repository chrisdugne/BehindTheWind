-----------------------------------------------------------------------------------------
--
-- KamikazeSelection
--
-----------------------------------------------------------------------------------------

local scene = storyboard.newScene()

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

function scene:refreshScene()

    local top = display.newRect(game.hud, display.contentWidth*0.5, -display.contentHeight/5, display.contentWidth, display.contentHeight/5)
    top:setFillColor(0)

    local bottom = display.newRect(game.hud, display.contentWidth*0.5, display.contentHeight, display.contentWidth, display.contentHeight/5)
    bottom:setFillColor(0)

    local board = display.newRoundedRect(game.hud, 0, 0, display.contentWidth*0.75, display.contentHeight/2, 20)
    board.x = display.contentWidth/2
    board.y = display.contentHeight/2
    board.alpha = 0
    board:setFillColor(0)
    game.hud.board = board

    transition.to( top, { time=500, y = top.contentHeight/2 })
    transition.to( bottom, { time=500, y = display.contentHeight - top.contentHeight/2 })  
    transition.to( board, { time=800, alpha=0.9, onComplete= function() self:displayContent() end})

    ---------------------------------------------------------------

    viewManager.buildEffectButton(
        game.hud,
        "assets/images/hud/back.png",
        51, 
        0.18*aspectRatio,
        display.contentWidth*0.1, 
        display.contentHeight*0.1, 
        function() 
            router.openAppHome()
        end
    )

end

function scene:displayContent()

    -----------------------------------------------------------------------------------------------
--
--    if(not GLOBALS.savedData.fullGame) then
--        viewManager.buildEffectButton(game.hud, T "Full version", 26, 0.72, display.contentWidth*0.77,     display.contentHeight*0.38,     router.openBuy)
--    else
--        thanksText = display.newText(game.hud, "Thank you for purchasing the full version !", 0, 0, 200, 200, FONT, 30 )
--        thanksText.x = display.contentWidth*0.75
--        thanksText.y = display.contentHeight*0.4
--    end
    
--    viewManager.buildEffectButton(game.hud, "Reset",  38, 0.72, display.contentWidth*0.77,     display.contentHeight*0.61, function()    self:reset() end)
    viewManager.buildEffectButton(game.hud, "Reset",  38, 0.72, display.contentWidth*0.77,     display.contentHeight*0.5, function()    self:reset() end)

    -----------------------------------------------------------------------------------------------

    local uralysText = display.newText(game.hud, "Created by ", 0, 0, FONT, 38 )
    uralysText.x = display.contentWidth*0.25
    uralysText.y = display.contentHeight*0.35

    local uralysImage = display.newImage(game.hud, "assets/images/others/logo.png")
    uralysImage.anchorX = 0
    uralysImage.x = uralysText.x + uralysText.contentWidth/2 + display.contentWidth * 0.02
    uralysImage.y = display.contentHeight*0.35
    uralysImage:scale(0.5,0.5)

    utils.onTouch(uralysImage,  function(event) system.openURL( "http://www.uralys.com" ) end)

    -----------------------------------------------------------------------------------------------

    local thanksText = display.newText(game.hud, "Thanks to", 0, 0, FONT, 38 )
    thanksText.x = display.contentWidth*0.25
    thanksText.y = display.contentHeight*0.5
    
    local coronaImage = display.newImage(game.hud, "assets/images/others/corona.png")
    coronaImage:scale(0.5,0.5)
    coronaImage.x = display.contentWidth*0.37
    coronaImage.y = display.contentHeight*0.5
    utils.onTouch(coronaImage,  function(event) system.openURL( "http://www.coronalabs.com" ) end)
    
    local andText = display.newText(game.hud, "and", 0, 0, FONT, 38 )
    andText.x = display.contentWidth*0.45
    andText.y = display.contentHeight*0.5

    local cbeffectsImage = display.newImage(game.hud, "assets/images/others/cbeffects.png")
    cbeffectsImage:scale(0.4,0.4)
    cbeffectsImage.x = display.contentWidth*0.56
    cbeffectsImage.y = display.contentHeight*0.5
    utils.onTouch(cbeffectsImage,  function(event) system.openURL( "http://gymbyl.com" ) end)

    local velvetText = display.newText(game.hud, "Music by Velvet Coffee", 0, 0, FONT, 46 )
    velvetText.x = display.contentWidth*0.45
    velvetText.y = display.contentHeight*0.65
    utils.onTouch(velvetText,  function(event) system.openURL( "http://soundcloud.com/velvetcoffee" ) end)

    local playImage = display.newImage(game.hud, "assets/images/hud/play.png")
    playImage:scale(0.5,0.5)
    playImage.x = display.contentWidth*0.22
    playImage.y = display.contentHeight*0.655
    utils.onTouch(playImage,  function(event) system.openURL( "http://soundcloud.com/velvetcoffee" ) end)
end

------------------------------------------

function scene:reset()
    native.showAlert( T "Reset the game", T "Confirm now to erase your level progression and start the game again", { "OK", T "Cancel" }, function(event) self:confirmReset(event) end )
end

function scene:confirmReset( event )
    if "clicked" == event.action then
        local i = event.index
        if 1 == i then
            game:initGameData()
            router.openAppHome()
        end
    end
end

-- Show alert with two buttons
------------------------------------------

-- Called immediately after scene has moved onscreen:
function scene:enterScene( event )
    self:refreshScene();
end

-- Called when scene is about to move offscreen:
function scene:exitScene( event )
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