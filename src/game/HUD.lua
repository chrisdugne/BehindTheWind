-----------------------------------------------------------------------------------------

module(..., package.seeall)

-----------------------------------------------------------------------------------------

local HUD_TOP = display.contentHeight*0.04

-----------------------------------------------------------------------------------------

ENERGY_ICON_LEFT 			= display.contentWidth*0.09
ENERGY_ICON_TOP 			= HUD_TOP
ENERGY_TEXT_LEFT 			= display.contentWidth*0.12
ENERGY_TEXT_TOP 			= HUD_TOP

PIECE_ICON_LEFT 			= display.contentWidth*0.15
PIECE_ICON_TOP 			= HUD_TOP
PIECE_TEXT_LEFT 			= display.contentWidth*0.18
PIECE_TEXT_TOP 			= HUD_TOP

SIMPLE_PIECE_ICON_LEFT 	= display.contentWidth*0.20
SIMPLE_PIECE_ICON_TOP 	= HUD_TOP
SIMPLE_PIECE_TEXT_LEFT 	= display.contentWidth*0.23
SIMPLE_PIECE_TEXT_TOP 	= HUD_TOP

THROW_ICON_LEFT 	= display.contentWidth*0.04
THROW_ICON_TOP 	= HUD_TOP

-----------------------------------------------------------------------------------------

local characterIconsConfig = require("src.game.graphics.CharacterThrowIcons")
local characterIconsSheet = graphics.newImageSheet( "assets/images/hud/CharacterThrowIcons.png", characterIconsConfig.sheet )

-----------------------------------------------------------------------------------------

function start()
	
	game.hud.energy = display.newImage( game.hud, "assets/images/hud/energy.png")
	game.hud.energy.x = ENERGY_ICON_LEFT
	game.hud.energy.y = ENERGY_ICON_TOP
	game.hud.energy:scale(0.5,0.5)
	
   game.hud.energiesCaught = display.newText( game.hud, "0", 0, 0, FONT, 25 )
   game.hud.energiesCaught:setTextColor( 255 )	
	game.hud.energiesCaught.x = ENERGY_TEXT_LEFT
	game.hud.energiesCaught.y = ENERGY_TEXT_TOP
   
   game.hud.throwIcon = display.newSprite( game.hud, characterIconsSheet, characterIconsConfig.sequence )
	game.hud.throwIcon.x = THROW_ICON_LEFT
	game.hud.throwIcon.y = THROW_ICON_TOP
	game.hud.throwIcon:scale(0.5,0.5)
	
	if(not GLOBALS.savedData.fireEnable) then game.hud.throwIcon.alpha = 0 end
   
   Runtime:addEventListener( "enterFrame", refreshHUD )
	
	-----------------------------------------------------------------

 	if(game.chapter == 1 and (game.level == 2 or game.level == 3 )) then
 		if(game.level == 2) then
 			character.lookLeft()
 		end
		Runtime:addEventListener( "enterFrame", tutorials.listenHelp )
	end
   
   timer.performWithDelay(2000, function()

    	if(game.chapter == 1 and game.level == 1) then
   		Runtime:addEventListener( "enterFrame", tutorials.listenHelp )
   	end
   	
   	viewManager.buildSimpleButton(
   		"assets/images/hud/back.png",
   		51, 
   		0.18*aspectRatio,
   		display.contentWidth*0.05, 
   		display.contentHeight*0.95, 
   		function() 
				if(game.state == game.STOPPED) then return end
   			game.state=game.STOPPED
   			hud.destroy()
   			transition.to(game.camera, {time = 1500, alpha = 0, onComplete = function()
      			game:destroyBeforeExit()
      			timer.performWithDelay(1000, function()
         			router.openLevelSelection()
      			end)
   			end})
   			
   		end
   	)
   end)

end
    
-----------------------------------------------------------------------------------------

function destroy()
   Runtime:removeEventListener( "enterFrame", refreshHUD )
   Runtime:removeEventListener( "enterFrame", tutorials.listenHelp )
   tutorials.destroy()
	utils.emptyGroup(game.hud)
end

-----------------------------------------------------------------------------------------

function refreshHUD()
	if(game.hud.energiesCaught.contentWidth) then
		game.hud.energiesCaught.text = game.energiesCaught
		game.hud.energiesCaught.size = 25
		game.hud.energiesCaught.x 	= ENERGY_TEXT_LEFT
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
   game.hud.followButton = display.newCircle( game.hud, display.contentWidth - 40, display.contentHeight - 40, 25 )
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

-----------------------------------------------------------------------------------------

function showDropButton()
	display.remove(game.hud.dropButton)
   game.hud.dropButton = display.newImage( game.hud, "assets/images/hud/character.drop.png" ,display.contentWidth - 180, HUD_TOP + 60 )
   game.hud.dropButton:scale(2,2)
   game.hud.dropButton.alpha = 0.6
	utils.onTouch(game.hud.dropButton, function()
		physicsManager.detachAllRopes() 
   	hideDropButton()
	end)
end

function hideDropButton()
	if(game.state == game.RUNNING) then
		utils.destroyFromDisplay(game.hud.dropButton)
	end
end
