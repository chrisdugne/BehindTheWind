-----------------------------------------------------------------------------------------

module(..., package.seeall)

-----------------------------------------------------------------------------------------

ENERGY_ICON_LEFT 			= display.contentWidth*0.04
ENERGY_ICON_TOP 			= display.contentHeight*0.06
ENERGY_TEXT_LEFT 			= display.contentWidth*0.08
ENERGY_TEXT_TOP 			= display.contentHeight*0.06

PIECE_ICON_LEFT 			= display.contentWidth*0.15
PIECE_ICON_TOP 			= display.contentHeight*0.06
PIECE_TEXT_LEFT 			= display.contentWidth*0.18
PIECE_TEXT_TOP 			= display.contentHeight*0.06

SIMPLE_PIECE_ICON_LEFT 	= display.contentWidth*0.20
SIMPLE_PIECE_ICON_TOP 	= display.contentHeight*0.06
SIMPLE_PIECE_TEXT_LEFT 	= display.contentWidth*0.23
SIMPLE_PIECE_TEXT_TOP 	= display.contentHeight*0.06

-----------------------------------------------------------------------------------------

function start()
	game.hud.energy = display.newImage( game.hud, "assets/images/hud/energy.png")
	game.hud.energy.x = ENERGY_ICON_LEFT
	game.hud.energy.y = ENERGY_ICON_TOP
	game.hud.energy:scale(0.5,0.5)
	
   game.hud.energiesRemaining = display.newText( game.hud, "0", 0, 0, FONT, 25 )
   game.hud.energiesRemaining:setTextColor( 255 )	
	game.hud.energiesRemaining.x = ENERGY_TEXT_LEFT
	game.hud.energiesRemaining.y = ENERGY_TEXT_TOP
   
   Runtime:addEventListener( "enterFrame", refreshHUD )
end
    
-----------------------------------------------------------------------------------------

function destroy()
	utils.emptyGroup(game.hud)
   Runtime:removeEventListener( "enterFrame", refreshHUD )
end

-----------------------------------------------------------------------------------------

function refreshHUD()
	if(game.hud.energiesRemaining.contentWidth) then
		game.hud.energiesRemaining.text = game.energiesRemaining
		game.hud.energiesRemaining.size = 25
		game.hud.energiesRemaining.x 	= ENERGY_TEXT_LEFT
	end
end

-----------------------------------------------------------------------------------------

function setExit(toApply)
	game.hud.exitButton = display.newImage( game.hud, "assets/images/hud/exit.png")
	game.hud.exitButton.x = display.contentWidth - 20
	game.hud.exitButton.y = 45
	game.hud.exitButton.alpha = 0.5
	game.hud.exitButton:scale(0.75,0.75)

	utils.onTouch(game.hud.exitButton, function() 
		if(toApply) then 
			toApply()
			router.openAppHome()
		end 
	end)
end

function setBackToHome()
	game.hud.exitButton = display.newImage( game.hud, "assets/images/hud/exit.png")
	game.hud.exitButton.x = display.contentWidth - 20
	game.hud.exitButton.y = 45
	game.hud.exitButton.alpha = 0.5
	game.hud.exitButton:scale(0.75,0.75)
	utils.onTouch(game.hud.exitButton, router.openAppHome)
end

-----------------------------------------------------------------------------------------

local panel
function openPanel(level, num)
	display.remove(panel)
   panel = display.newImageRect( "assets/images/tutorial/tuto" .. level .. "." .. num .. ".png", 840, 480)
   panel.x = display.contentWidth*0.5
   panel.y = display.contentHeight*0.5
   
   utils.onTouch(panel, function() display.remove(panel) end)
end

-----------------------------------------------------------------------------------------

function initFollowRockButton()
   game.hud.followButton = display.newCircle( game.hud, 20, display.contentHeight - 20, 10 )
   hideFollowRockButton()
end

function touchFollowRock(event)
	if(event.phase == "began") then
		game.focus = ROCK 
	elseif(event.phase == "ended") then
		game.focus = CHARACTER 
	end

	return true
end

function showFollowRockButton()
	game.hud.followButton.alpha = 1
   game.hud.followButton:addEventListener ( "touch", touchFollowRock )
end

function hideFollowRockButton()
	if(game.state == game.RUNNING) then
   	game.hud.followButton.alpha = 0
      game.hud.followButton:removeEventListener ( "touch", touchFollowRock )
   	game.focus = CHARACTER 
   -- else : destroyed earlier
	end
end
