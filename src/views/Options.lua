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
--		 unless storyboard.removeScene() is called.
-- 
-----------------------------------------------------------------------------------------

-- Called when the scene's view does not exist:
function scene:createScene( event )
end

-----------------------------------------------------------------------------------------

function scene:refreshScene()

   local top = display.newRect(game.hud, 0, -display.contentHeight/5, display.contentWidth, display.contentHeight/5)
   top:setFillColor(0)
   
   local bottom = display.newRect(game.hud, 0, display.contentHeight, display.contentWidth, display.contentHeight/5)
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

	hud.setBackToHome()
end

function scene:displayContent()

	-----------------------------------------------------------------------------------------------

	if(not GLOBALS.savedData.fullGame) then
		viewManager.buildButton( T "Full version", "white", 12, 0.36, display.contentWidth*0.77, 	display.contentHeight*0.38, 	router.openBuy)
	else
		thanksText = display.newText(game.hud, "Thank you for purchasing the full version !", 0, 0, 70, 100, FONT, 12 )
		thanksText.x = display.contentWidth*0.75
		thanksText.y = display.contentHeight*0.4
	end
	viewManager.buildButton( "Reset", "white", 	21, 0.36, display.contentWidth*0.77, 	display.contentHeight*0.61, function()	self:reset() end)
	
	-----------------------------------------------------------------------------------------------

	uralysText = display.newText(game.hud, "Created by ", 0, 0, FONT, 13 )
	uralysText.x = game.hud.board.x - game.hud.board.contentWidth/2 + uralysText.contentWidth/2 + 30
	uralysText.y = game.hud.board.y/2 + 25

	uralysImage = display.newImage(game.hud, "assets/images/others/logo.png")
	uralysImage.x = game.hud.board.x - game.hud.board.contentWidth/2 + uralysImage.contentWidth/2 + 100
	uralysImage.y = game.hud.board.y/2 + 25
	
	utils.onTouch(uralysImage,  function(event) system.openURL( "http://www.uralys.com" ) end)

	-----------------------------------------------------------------------------------------------

	coronaImage = display.newImage(game.hud, "assets/images/others/corona.png")
	coronaImage:scale(0.3,0.3)
	coronaImage.x = game.hud.board.x - game.hud.board.contentWidth/2 + coronaImage.contentWidth/2 + 20
	coronaImage.y = game.hud.board.y/2 + 110
	utils.onTouch(coronaImage,  function(event) system.openURL( "http://www.coronalabs.com" ) end)

	cbeffectsImage = display.newImage(game.hud, "assets/images/others/cbeffects.png")
	cbeffectsImage:scale(0.2,0.2)
	cbeffectsImage.x = game.hud.board.x - game.hud.board.contentWidth/2 + cbeffectsImage.contentWidth/2 + 130
	cbeffectsImage.y = game.hud.board.y/2 + 100
	utils.onTouch(cbeffectsImage,  function(event) system.openURL( "http://gymbyl.com" ) end)

	velvetText = display.newText(game.hud, "Music by Velvet Coffee", 0, 0, FONT, 13 )
	velvetText.x = game.hud.board.x - game.hud.board.contentWidth/2 + velvetText.contentWidth/2 + 100
	velvetText.y = cbeffectsImage.y + 45
	utils.onTouch(velvetText,  function(event) system.openURL( "http://soundcloud.com/velvetcoffee" ) end)

	playImage = display.newImage(game.hud, "assets/images/hud/play.png")
	playImage:scale(0.2,0.2)
	playImage.x = velvetText.x + 80
	playImage.y = velvetText.y
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
         	game.initGameData()
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