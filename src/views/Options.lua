-----------------------------------------------------------------------------------------
--
-----------------------------------------------------------------------------------------

widget = require "widget"

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

    game.hud.top = display.newRect(game.hud, display.contentWidth*0.5, -display.contentHeight * 0.22, display.contentWidth, display.contentHeight * 0.22)
    game.hud.top:setFillColor(0)

    local bottom = display.newRect(game.hud, display.contentWidth*0.5, display.contentHeight, display.contentWidth, display.contentHeight * 0.22)
    bottom:setFillColor(0)

    local board = display.newRoundedRect(game.hud, 0, 0, display.contentWidth*0.75, display.contentHeight/2, 20)
    board.x = display.contentWidth/2
    board.y = display.contentHeight/2
    board.alpha = 0
    board:setFillColor(0)
    game.hud.board = board

    transition.to( game.hud.top, { time=500, y = game.hud.top.contentHeight/2 })
    transition.to( bottom, { time=500, y = display.contentHeight - game.hud.top.contentHeight/2, onComplete = function() self:displayContent() end })  

    ---------------------------------------------------------------

    viewManager.buildEffectButton(
        game.hud,
        "assets/images/hud/back.png",
        51, 
        0.18*aspectRatio,
        display.contentWidth*0.1, 
        display.contentHeight*0.1, 
        function() 
            if(viewManager.closeWebView) then
                viewManager.closeWebView()
                viewManager.closeWebView = nil
            else 
                router.openAppHome()
            end
        end
    )

    viewManager.buildEffectButton(game.hud, "Reset",  38, 0.52, display.contentWidth*0.87,     display.contentHeight*0.1, function()    self:reset() end)
    
end

------------------------------------------------------

function scene:scroll()
    local xScroller, yScroller = game.hud.board:getContentPosition()
    local time = ( yScroller+ display.contentHeight * 3.7) * 7.5
    game.hud.board.scroller = game.hud.board:scrollToPosition({y = -display.contentHeight * 3.7, transition=easing.linear, time = time })
end

------------------------------------------------------

function scene:displayContent()

    game.hud.board = widget.newScrollView
        {
            id                          = "credits",
            top                         = 0,
            left                        = 0,
            friction                    = 0.1,
            width                       = display.contentWidth,
            height                      = display.contentHeight,
            bottomPadding               = display.contentHeight*0.85,
            hideBackground              = true,
            horizontalScrollDisabled    = true,
            verticalScrollDisabled      = false,
            hideScrollBar               = true,
            listener                    = function(event)
                local phase = event.phase
                if "began" == phase then
                    transition.cancel(game.hud.board.scroller)
                elseif "ended" == phase then
                    self:scroll()
                end
                return true
            end
    }
    
    ----------------------------
    
    local uralysText = display.newText(game.hud.board, "Created by ", 0, 0, FONT, 38 )
    uralysText.x = display.contentWidth * 0.5
    uralysText.y = display.contentWidth * 0.23
    game.hud.board:insert(uralysText)

    local uralysImage = display.newImage(game.hud.board, "assets/images/others/logo.png")
    uralysImage.x = display.contentWidth * 0.5
    uralysImage.y = display.contentHeight*0.53
    uralysImage:scale(0.5,0.5)
    game.hud.board:insert(uralysImage)

    utils.onTouch(uralysImage,  function(event) 
        viewManager.closeWebView = viewManager.openWeb( "http://www.uralys.com" ) 
    end)
    
    ----------------------------

    local velvetText = display.newText(game.hud, "Music by Velvet Coffee", 0, 0, FONT, 60 )
    velvetText.x = display.contentWidth*0.5
    velvetText.y = display.contentHeight*1
    game.hud.board:insert(velvetText)
    
    utils.onTouch(velvetText,  function(event) 
        viewManager.closeWebView = viewManager.openWeb( "http://soundcloud.com/velvetcoffee" ) 
    end)

    local playImage = display.newImage(game.hud, "assets/images/hud/play.png")
    playImage.x = display.contentWidth*0.5
    playImage.y = display.contentHeight*1.2
    playImage:scale(0.8,0.8)
    game.hud.board:insert(playImage)
    
    utils.onTouch(playImage,  function(event) 
        viewManager.closeWebView = viewManager.openWeb( "http://soundcloud.com/velvetcoffee" ) 
    end)
    
    -----------------------------------------------------------------------------------------------

    local thanksText = display.newText(game.hud.board, "Tools", 0, 0, FONT, 75 )
    thanksText.x = display.contentWidth*0.5
    thanksText.y = display.contentHeight*1.7
    game.hud.board:insert(thanksText)
    
    local coronaImage = display.newImage(game.hud.board, "assets/images/others/corona.png")
    coronaImage.x = display.contentWidth*0.5
    coronaImage.y = display.contentHeight*2.1
    game.hud.board:insert(coronaImage)
    
    utils.onTouch(coronaImage,  function(event) 
        viewManager.closeWebView = viewManager.openWeb( "http://www.coronalabs.com" ) 
    end)
    
    ----------------------------
    
    local cbeffectsImage = display.newImage(game.hud, "assets/images/others/cbeffects.png")
    cbeffectsImage.x = display.contentWidth*0.5
    cbeffectsImage.y = display.contentHeight*2.55
    cbeffectsImage:scale(0.6,0.6)
    game.hud.board:insert(cbeffectsImage)
    
    utils.onTouch(cbeffectsImage,  function(event) 
        viewManager.closeWebView = viewManager.openWeb( "http://gymbyl.com" ) 
    end)
    
    ----------------------------
    
    local texturepacker = display.newImage(game.hud, "assets/images/others/texturepacker.png")
    texturepacker.x = display.contentWidth*0.5
    texturepacker.y = display.contentHeight*2.95
    game.hud.board:insert(texturepacker)
    
    utils.onTouch(texturepacker,  function(event) 
        viewManager.closeWebView = viewManager.openWeb( "http://www.codeandweb.com/texturepacker" ) 
    end)
    
    -----------------------------------------------------------------------------------------------

    local resources = display.newText(game.hud.board, "Resources", 0, 0, FONT, 60 )
    resources.x = display.contentWidth*0.5
    resources.y = display.contentHeight*3.3
    game.hud.board:insert(resources)
    

    local kenney = display.newText(game.hud.board, "Tiles from Kenney", 0, 0, FONT, 45 )
    kenney.x = display.contentWidth*0.5
    kenney.y = display.contentHeight*3.5
    game.hud.board:insert(kenney)
    
    utils.onTouch(kenney,  function(event) 
        viewManager.closeWebView = viewManager.openWeb( "http://www.kenney.nl/" ) 
    end)
    
    
    local reiner = display.newText(game.hud.board, "Trees from Reiner's tilesets", 0, 0, FONT, 45 )
    reiner.x = display.contentWidth*0.5
    reiner.y = display.contentHeight*3.65
    game.hud.board:insert(reiner)
    
    utils.onTouch(reiner,  function(event) 
        viewManager.closeWebView = viewManager.openWeb( "http://www.reinerstilesets.de/" ) 
    end)
    
    local nounproject = display.newText(game.hud.board, "Icons from The Noun Project", 0, 0, FONT, 45 )
    nounproject.x = display.contentWidth*0.5
    nounproject.y = display.contentHeight*3.8
    game.hud.board:insert(nounproject)
    
    utils.onTouch(nounproject,  function(event) 
        viewManager.closeWebView = viewManager.openWeb( "http://thenounproject.com/" ) 
    end)
    
    
    ----------------------------
    
    local ty = display.newText(game.hud.board, "Thank you for playing !", 0, 0, FONT, 70 )
    ty.x = display.contentWidth*0.5
    ty.y = display.contentHeight*4.2
    game.hud.board:insert(ty)
    
    
    ----------------------------

    game.hud:insert(game.hud.board)
    game.hud.board:toBack()

    ----------------------------
    
    self:scroll()
end


-----------------------------------------------------------------------------------------------

--function scene:displayContent_old()

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

    -----------------------------------------------------------------------------------------------
--end

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