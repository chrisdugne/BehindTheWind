-----------------------------------------------------------------------------------------

module(..., package.seeall)

-----------------------------------------------------------------------------------------

ENERGY_ICON_LEFT 			= display.contentWidth*0.09
ENERGY_ICON_TOP 			= display.contentHeight*0.94
ENERGY_TEXT_LEFT 			= display.contentWidth*0.11
ENERGY_TEXT_TOP 			= display.contentHeight*0.94

PIECE_ICON_LEFT 			= display.contentWidth*0.15
PIECE_ICON_TOP 			= display.contentHeight*0.94
PIECE_TEXT_LEFT 			= display.contentWidth*0.18
PIECE_TEXT_TOP 			= display.contentHeight*0.94

SIMPLE_PIECE_ICON_LEFT 	= display.contentWidth*0.20
SIMPLE_PIECE_ICON_TOP 	= display.contentHeight*0.94
SIMPLE_PIECE_TEXT_LEFT 	= display.contentWidth*0.23
SIMPLE_PIECE_TEXT_TOP 	= display.contentHeight*0.94

THROW_ICON_LEFT 	= display.contentWidth*0.04
THROW_ICON_TOP 	= display.contentHeight*0.94

-----------------------------------------------------------------------------------------

local characterIconsConfig = require("src.game.graphics.CharacterThrowIcons")
local characterIconsSheet = graphics.newImageSheet( "assets/images/hud/CharacterThrowIcons.png", characterIconsConfig.sheet )

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
   
   game.hud.throwIcon = display.newSprite( game.hud, characterIconsSheet, characterIconsConfig.sequence )
	game.hud.throwIcon.x = THROW_ICON_LEFT
	game.hud.throwIcon.y = THROW_ICON_TOP
	game.hud.throwIcon:scale(0.5,0.5)
   
   Runtime:addEventListener( "enterFrame", refreshHUD )
   
   if(game.level == 1) then
   	timer.performWithDelay(4000, function()
         Runtime:addEventListener( "enterFrame", refreshHUDTutoLevel1 )
   	end)
   end

   if(game.level == 2) then
      Runtime:addEventListener( "enterFrame", refreshHUDTutoLevel2 )
   end
end
    
-----------------------------------------------------------------------------------------

function destroy()
	utils.emptyGroup(game.hud)
   Runtime:removeEventListener( "enterFrame", refreshHUD )
   Runtime:removeEventListener( "enterFrame", refreshHUDTutoLevel1 )
	Runtime:removeEventListener( "enterFrame", refreshHUDTutoLevel2 )
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
-- TUTO LEVEL 1
-----------------------------------------------------------------------------------------
 

local helpVisible1 = false
local tween11
local tween12

function refreshHUDTutoLevel1()
	if(character.sprite.x < 150 and not helpVisible1) then
		showHelpLevel1()
	end 	

	if(character.sprite.x > 150 and helpVisible1) then
		hideHelpLevel1()
	end 	
end

function showHelpLevel1()
	helpVisible1 = true
	game.hud.help1 = display.newImage(game.hud, "assets/images/hud/touch.png", display.contentWidth*0.8, display.contentHeight*0.36)
	game.hud.help2 = display.newImage(game.hud, "assets/images/hud/touch.png", display.contentWidth*0.15, display.contentHeight*0.36)
	game.hud.help1.alpha = 0
	game.hud.help1.alpha = 0
	tweenLevel1On()
end

function hideHelpLevel1()
	helpVisible1 = false
	transition.cancel(tween11)
	transition.cancel(tween12)
	display.remove(game.hud.help1)
	display.remove(game.hud.help2)
end

function tweenLevel1On()
	tween11 = transition.to( game.hud.help1, { time=600, alpha=0.7})
	tween12 = transition.to( game.hud.help2, { time=600, alpha=0.7, onComplete=tweenLevel1Off})
end

function tweenLevel1Off()
	tween11 = transition.to( game.hud.help1, { time=600, alpha=0.4})
	tween12 = transition.to( game.hud.help2, { time=600, alpha=0.4, onComplete=tweenLevel1On})
end


-----------------------------------------------------------------------------------------
-- TUTO LEVEL 2
-----------------------------------------------------------------------------------------
 
local helpVisibleTouchCenter = false
local helpVisible21 = false
local helpVisible22 = false
local tween21
local tween22

function refreshHUDTutoLevel2()

	if(character.sprite.x > 500 
	and character.sprite.x < 630 
	and character.sprite.y < -135 
	and character.sprite.y > -210
	and levelDrawer.level.triggers[2].remaining > 0) then
	
		if(not character.throwFire) then
			if(not helpVisibleTouchCenter) then
   			if(helpVisible21) then
      			hideHelpLevel21()
      		end
				
				showHelpTouchCenter()
			end
		elseif(not helpVisible21) then
   		
   		if(helpVisibleTouchCenter) then
      		hideHelpTouchCenter()
      	end
      	
   		showHelpLevel21()
		end 
		
	elseif(character.sprite.x > 850 
	and character.sprite.x < 1000 
	and character.sprite.y > -360 
	and character.sprite.y < -280) then
	
		if(not character.throwGrab) then
			if(not helpVisibleTouchCenter) then
   			if(helpVisible22) then
      			hideHelpLevel22()
      		end
				
				showHelpTouchCenter()
			end
		elseif(not helpVisible22) then
   		
   		if(helpVisibleTouchCenter) then
      		hideHelpTouchCenter()
      	end
      	
   		showHelpLevel22()
		end 
		
	
	else
		destroyTutoLevel2()
	end 	
end

function destroyTutoLevel2()
	if(helpVisibleTouchCenter) then
		hideHelpTouchCenter()
	elseif(helpVisible21) then
		hideHelpLevel21()
	elseif(helpVisible22) then
		hideHelpLevel22()
	end
end

-------------------------------

function showHelpTouchCenter()
	helpVisibleTouchCenter = true
	game.hud.help1 = display.newImage(game.hud, "assets/images/hud/touch.png", display.contentWidth*0.5, display.contentHeight*0.5)
	game.hud.help2 = display.newImage(game.hud, "assets/images/tutorial/arrow.down.png")
	game.hud.help1.alpha = 0
	game.hud.help2.x = 60
	game.hud.help2.y = display.contentHeight - 150
	tweenTouchCenterOn()
end

function hideHelpTouchCenter()
	helpVisibleTouchCenter = false
	transition.cancel(tween21)
	transition.cancel(tween22)
	display.remove(game.hud.help1)
	display.remove(game.hud.help2)
end

function tweenTouchCenterOn()
	tween21 = transition.to( game.hud.help1, { time=600, alpha=0.7})
	tween22 = transition.to( game.hud.help2, { time=600, alpha=0.7, onComplete=tweenTouchCenterOff})
end

function tweenTouchCenterOff()
	tween21 = transition.to( game.hud.help1, { time=600, alpha=0.4})
	tween22 = transition.to( game.hud.help2, { time=600, alpha=0.4, onComplete=tweenTouchCenterOn})
end

-------------------------------

function showHelpLevel21()
	helpVisible21 = true
	game.hud.help1 = display.newImage(game.hud, "assets/images/hud/touch.png", display.contentWidth*0.5, display.contentHeight*0.5)
	game.hud.help1.alpha = 0
	
	game.hud.line1 = display.newImage(game.hud, "assets/images/hud/line.png", display.contentWidth*0.35, display.contentHeight*0.27)
	game.hud.line2 = display.newImage(game.hud, "assets/images/hud/line.png", display.contentWidth*0.65, display.contentHeight*0.27)
	game.hud.line1:scale(1,2)
	game.hud.line2:scale(1,2)
	game.hud.line1.alpha = 0.3
	game.hud.line2.alpha = 0.3
	
	-- trigger
	--"y":-245,
	--"x":493.29998779297,
	game.hud.rightArrow = display.newImage(game.camera, "assets/images/tutorial/arrow.right.png")
	game.hud.rightArrow.alpha = 0.5
	game.hud.rightArrow.x = 493 - 30
	game.hud.rightArrow.y = -250
	game.hud.rightArrow:scale(0.15,0.15)

	game.hud.leftArrow = display.newImage(game.camera, "assets/images/tutorial/arrow.left.png")
	game.hud.leftArrow.alpha = 0.5
	game.hud.leftArrow.x = 493 + 30
	game.hud.leftArrow.y = -250
	game.hud.leftArrow:scale(0.15,0.15)

	game.hud.topArrow = display.newImage(game.camera, "assets/images/tutorial/arrow.top.png")
	game.hud.topArrow.alpha = 0.5
	game.hud.topArrow.x = 493
	game.hud.topArrow.y = -250 + 30
	game.hud.topArrow:scale(0.15,0.15)

	game.hud.bottomArrow = display.newImage(game.camera, "assets/images/tutorial/arrow.down.png")
	game.hud.bottomArrow.alpha = 0.5
	game.hud.bottomArrow.x = 493
	game.hud.bottomArrow.y = -250 - 30
	game.hud.bottomArrow:scale(0.15,0.15)
	
	--------------
	
	tweenLevel21On()
end

function hideHelpLevel21()
	helpVisible21 = false
	transition.cancel(tween21)
	display.remove(game.hud.help1)
	
	display.remove(game.hud.rightArrow)
	display.remove(game.hud.leftArrow)
	display.remove(game.hud.topArrow)
	display.remove(game.hud.bottomArrow)
	
	display.remove(game.hud.line1)
	display.remove(game.hud.line2)
end

function tweenLevel21On()
	game.hud.help1.x = display.contentWidth*0.5
	game.hud.help1.y = display.contentHeight*0.5
	tween21 = transition.to( game.hud.help1, { time=600, alpha=0.7, x=display.contentWidth*0.62 , y=display.contentHeight*0.65 ,onComplete=tweenLevel21Off})
end

function tweenLevel21Off()
	tween21 = transition.to( game.hud.help1, { time=600, alpha=0.4, x=display.contentWidth*0.57 , y=display.contentHeight*0.68, onComplete=tweenLevel21On})
end

----------------------------------------------------------------


function showHelpLevel22()
	helpVisible22 = true
	game.hud.help1 = display.newImage(game.hud, "assets/images/hud/touch.png", display.contentWidth*0.5, display.contentHeight*0.5)
	game.hud.help1.alpha = 0
	
	game.hud.line1 = display.newImage(game.hud, "assets/images/hud/line.png", display.contentWidth*0.35, display.contentHeight*0.27)
	game.hud.line2 = display.newImage(game.hud, "assets/images/hud/line.png", display.contentWidth*0.65, display.contentHeight*0.27)
	game.hud.line1:scale(1,2)
	game.hud.line2:scale(1,2)
	game.hud.line1.alpha = 0.3
	game.hud.line2.alpha = 0.3
	
	game.hud.leftArrow = display.newImage(game.camera, "assets/images/tutorial/arrow.left.png")
	game.hud.leftArrow.alpha = 0.7
	game.hud.leftArrow.x = 980
	game.hud.leftArrow.y = -290
	game.hud.leftArrow.rotation = 150
	game.hud.leftArrow:scale(0.5,0.5)

	--------------
	
	tweenLevel22On()
end

function hideHelpLevel22()
	helpVisible22 = false
	transition.cancel(tween22)
	display.remove(game.hud.help1)
	
	display.remove(game.hud.rightArrow)
	display.remove(game.hud.leftArrow)
	display.remove(game.hud.topArrow)
	display.remove(game.hud.bottomArrow)
	
	display.remove(game.hud.line1)
	display.remove(game.hud.line2)
end

function tweenLevel22On()
	game.hud.help1.x = display.contentWidth*0.5
	game.hud.help1.y = display.contentHeight*0.5
	tween22 = transition.to( game.hud.help1, { time=600, alpha=0.7, x=display.contentWidth*0.38 , y=display.contentHeight*0.65 ,onComplete=tweenLevel22Off})
end

function tweenLevel22Off()
	tween22 = transition.to( game.hud.help1, { time=600, alpha=0.4, x=display.contentWidth*0.45 , y=display.contentHeight*0.68, onComplete=tweenLevel22On})
end

