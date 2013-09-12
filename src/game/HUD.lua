-----------------------------------------------------------------------------------------

module(..., package.seeall)

-----------------------------------------------------------------------------------------

function setExit(toApply)
	exitButton = display.newImage( game.hud, "assets/images/hud/exit.png")
	exitButton.x = display.contentWidth - 20
	exitButton.y = 45
	exitButton.alpha = 0.5
	exitButton:scale(0.75,0.75)
	exitButton:addEventListener("touch", function(event)
		if(toApply) then 
			toApply()
			router.openAppHome()
		end 
	end)
end

function setBackToHome()
	exitButton = display.newImage( game.hud, "assets/images/hud/exit.png")
	exitButton.x = display.contentWidth - 20
	exitButton.y = 45
	exitButton.alpha = 0.5
	exitButton:scale(0.75,0.75)
	utils.onTouch(exitButton, router.openAppHome)
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
   followButton = display.newCircle( game.hud, 20, display.contentHeight - 20, 10 )
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
	followButton.alpha = 1
   followButton:addEventListener ( "touch", touchFollowRock )
end

function hideFollowRockButton()
	followButton.alpha = 0
   followButton:removeEventListener ( "touch", touchFollowRock )
	game.focus = CHARACTER 
end
