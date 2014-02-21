-----------------------------------------------------------------------------------------
--
-- KamikazeSelection
--
-----------------------------------------------------------------------------------------

local scene = storyboard.newScene()
local buyMenu

-----------------------------------------------------------------------------------------
-- BEGINNING OF YOUR IMPLEMENTATION
-- 
-- NOTE: Code outside of listener functions (below) will only be executed once,
--         unless storyboard.removeScene() is called.
-- 
-----------------------------------------------------------------------------------------

-- Called when the scene's view does not exist:
function scene:createScene( event )

    if ( store.availableStores.apple ) then
        store.init( "apple", storeTransaction )
    elseif ( store.availableStores.google ) then
        store.init( "google", storeTransaction )
    end

    buyMenu = display.newGroup()
    game.scene = buyMenu
end


-----------------------------------------------------------------------------------------
--- STORE

function storeTransaction( event )
    print( "storeTransaction" )
    utils.tprint(event)

    local transaction = event.transaction

    if ( transaction.state == "purchased" ) then
        gameBought()

    elseif ( transaction.state == "restored" ) then
        gameBought()

    elseif ( transaction.state == "cancelled" ) then
        print( "cancelled")
        refreshStatus("Maybe next time...")

    elseif ( transaction.state == "failed" ) then
        print( "failed")
        refreshStatus("Transaction cancelled...")
    end

    --tell the store that the transaction is complete!
    --if you're providing downloadable content, do not call this until the download has completed
    store.finishTransaction( event.transaction )

end

-----------------------------------------------------------------------------------------

function scene:refreshScene()

    utils.emptyGroup(buyMenu)

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

    ---------------------------------------------------------------

    local top = display.newRect(buyMenu, 0, -display.contentHeight/5, display.contentWidth, display.contentHeight/5)
    top:setFillColor(0)

    local bottom = display.newRect(buyMenu, 0, display.contentHeight, display.contentWidth, display.contentHeight/5)
    bottom:setFillColor(0)

    local board = display.newRoundedRect(buyMenu, 0, 0, 3*display.contentWidth/4, display.contentHeight/2, 20)
    board.x = display.contentWidth/2
    board.y = display.contentHeight/2
    board.alpha = 0
    board:setFillColor(0)
    buyMenu.board = board

    transition.to( top, { time=500, y = top.contentHeight/2 })
    transition.to( bottom, { time=500, y = display.contentHeight - top.contentHeight/2 })  
    transition.to( board, { time=800, alpha=0.9, onComplete= function() self:displayContent() end})  

    self.view:insert(buyMenu)

end

function scene:displayContent()

    -----------------------------------------------------------------------------------------------
    -- Texts

    buyMenu.indieText = display.newMultiLineText  
    {
        text = T "I'm an Indie Game Developer.\n Give me the chance to build the sequel : \n \n Unlock the game with only 1 coin !",
        width = display.contentWidth*0.85,  
        left = display.contentWidth*0.5,
        font = FONT, 
        fontSize = 38,
        color = {200,200,200},
        align = "center"
    }

    buyMenu.indieText:setReferencePoint(display.TopCenterReferencePoint)
    buyMenu.indieText.x = display.contentWidth*0.5
    buyMenu.indieText.y = display.contentHeight*0.27
    buyMenu:insert(buyMenu.indieText)       

    buyMenu.lockImage = display.newImage(buyMenu, "assets/images/hud/lock.png")
    buyMenu.lockImage.x = display.contentWidth*0.18
    buyMenu.lockImage.y = display.contentHeight*0.35
    utils.onTouch(buyMenu.lockImage, buy)

    statusText = display.newText( buyMenu, "", 0, 0, FONT, 42 )
    statusText:setTextColor( 255 )    

    buyMenu.buyButton = viewManager.buildEffectButton(    
        game.hud, 
        T "Buy", 
        46, 
        0.72,  
        display.contentWidth*0.4, 
        display.contentHeight*0.62, 
        function() buy() end
    )

    buyMenu.restoreButton     = viewManager.buildEffectButton(
        game.hud,
        T "Restore",
        40, 
        0.72,
        display.contentWidth*0.6, 
        display.contentHeight*0.62,
        function() restore() end
    )

end

------------------------------------------

function buy()
    display.remove(buyMenu.lockImage)
    display.remove(buyMenu.indieText)
    display.remove(buyMenu.restoreButton)
    display.remove(buyMenu.restoreButton.text)
    display.remove(buyMenu.buyButton)
    display.remove(buyMenu.buyButton.text)

    store.purchase( { "com.uralys.behindthewind.1.0" } )

    refreshStatus("Waiting for store...")

    -----------------------------
    -- DEV only : simulator

    if(SIMULATOR) then
        gameBought()
    end
end

------------------------------------------

function restore()
    display.remove(buyMenu.lockImage)
    display.remove(buyMenu.indieText)
    display.remove(buyMenu.restoreButton)
    display.remove(buyMenu.restoreButton.text)
    display.remove(buyMenu.buyButton)
    display.remove(buyMenu.buyButton.text)

    store.restore(  )

    refreshStatus("Trying to restore...")

    -----------------------------
    -- DEV only : simulator

    if(system.getInfo("environment") == "simulator") then
        gameBought()
    end
end

------------------------------------------

function gameBought()
    GLOBALS.savedData.fullGame = true
    utils.saveTable(GLOBALS.savedData, "savedData.json")
    refreshStatus("Thank you !")
    timer.performWithDelay(1500, router.openAppHome)
end

------------------------------------------

function refreshStatus(message)
    if(statusText) then
        statusText.text = message
        statusText.x = buyMenu.board.x
        statusText.y = buyMenu.board.y
    end
end

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