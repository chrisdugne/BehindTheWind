-----------------------------------------------------------------------------------------

module(..., package.seeall)

-----------------------------------------------------------------------------------------


function listenHelp()

   if(game.level == 1) then
      refreshHUDTutoLevel1()
   end

   if(game.level == 2) then
      refreshHUDTutoLevel2()
   end
end
   

function destroy()
	destroyTutoLevel2()
end

-----------------------------------------------------------------------------------------
-- TUTO LEVEL 1
-----------------------------------------------------------------------------------------
 

local helpVisible1 = false
local tween11

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
	game.hud.help1.alpha = 0
	tweenLevel1On()
end

function hideHelpLevel1()
	helpVisible1 = false
	transition.cancel(tween11)
	display.remove(game.hud.help1)
end

function tweenLevel1On()
	tween11 = transition.to( game.hud.help1, { time=600, alpha=0.7, onComplete=tweenLevel1Off})
end

function tweenLevel1Off()
	tween11 = transition.to( game.hud.help1, { time=600, alpha=0.4, onComplete=tweenLevel1On})
end


-----------------------------------------------------------------------------------------
-- TUTO LEVEL 2
-----------------------------------------------------------------------------------------
 
local helpVisibleTouchCenter = false
local helpVisible21 = false
local helpVisible22 = false
local tweenTouchCenter1
local tweenTouchCenter2
local tween21
local tween22

function refreshHUDTutoLevel2()

	if(helpVisibleTouchCenter) then
		game.hud.help1.x = character.sprite.x
		game.hud.help1.y = character.sprite.y + 10
	end
	
	if(character.sprite.x > 180 
	and character.sprite.x < 230 
	and character.sprite.y < 310 
	and character.sprite.y > 250
	and levelDrawer.level.triggers[1].remaining > 0) then
	
		display.remove(game.hud.helpImage)
		game.hud.helpImage = display.newImage(game.camera, "assets/images/tutorial/tuto2.1.png", 220, 130)
	
		if(not helpVisible21) then
   		character.grabLocked = true
      	character.movesLocked = true
   		showHelpLevel21()
		end 
	
	else
		character.grabLocked = false
		character.movesLocked = false
		destroyTutoLevel2()
	end 	
end

function destroyTutoLevel2()

	display.remove(game.hud.helpImage)
	
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
	game.hud.help1 = display.newImage(game.camera, "assets/images/hud/touch.png")
	game.hud.help2 = display.newImage(game.hud, "assets/images/tutorial/arrow.top.png")
	game.hud.help1:scale(0.3,0.3)
	game.hud.help1.alpha = 0
	game.hud.help2.x = 50
	game.hud.help2.y = 170
	tweenTouchCenterOn()
end

function hideHelpTouchCenter()
	helpVisibleTouchCenter = false
	transition.cancel(tweenTouchCenter1)
	transition.cancel(tweenTouchCenter2)
	display.remove(game.hud.help1)
	display.remove(game.hud.help2)
end

function tweenTouchCenterOn()
	if(not helpVisibleTouchCenter) then return end
	tweenTouchCenter1 = transition.to( game.hud.help1, { time=600, alpha=0.7})
	tweenTouchCenter2 = transition.to( game.hud.help2, { time=600, alpha=0.7, onComplete=tweenTouchCenterOff})
end

function tweenTouchCenterOff()
	tweenTouchCenter1 = transition.to( game.hud.help1, { time=600, alpha=0.4})
	tweenTouchCenter2 = transition.to( game.hud.help2, { time=600, alpha=0.4, onComplete=tweenTouchCenterOn})
end

-------------------------------

function showHelpLevel21()
	helpVisible21 = true
	game.hud.help1 = display.newImage(game.camera, "assets/images/hud/touch.png")
	game.hud.help1:scale(0.3,0.3)
	game.hud.help1.x = character.sprite.x
	game.hud.help1.y = character.sprite.y
	game.hud.help1.alpha = 0
	
	-- trigger
	--"y":-245,
	--"x":493.29998779297,
	game.hud.rightArrow = display.newImage(game.camera, "assets/images/tutorial/arrow.right.png")
	game.hud.rightArrow.alpha = 0.5
	game.hud.rightArrow:scale(0.15,0.15)
	game.hud.rightArrow.x = 110 - 20
	game.hud.rightArrow.y = 130

	game.hud.leftArrow = display.newImage(game.camera, "assets/images/tutorial/arrow.left.png")
	game.hud.leftArrow.alpha = 0.5
	game.hud.leftArrow.x = 110 + 20
	game.hud.leftArrow.y = 130
	game.hud.leftArrow:scale(0.15,0.15)

	game.hud.topArrow = display.newImage(game.camera, "assets/images/tutorial/arrow.top.png")
	game.hud.topArrow.alpha = 0.5
	game.hud.topArrow.x = 110
	game.hud.topArrow.y = 130 + 20
	game.hud.topArrow:scale(0.15,0.15)

	game.hud.bottomArrow = display.newImage(game.camera, "assets/images/tutorial/arrow.down.png")
	game.hud.bottomArrow.alpha = 0.5
	game.hud.bottomArrow.x = 110
	game.hud.bottomArrow.y = 130 - 20
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
end

function tweenLevel21On()
	if(not helpVisible21) then return end
	game.hud.help1.x = character.sprite.x
	game.hud.help1.y = character.sprite.y
	tween21 = transition.to( game.hud.help1, { time=700, alpha=0.9, x=character.sprite.x+25 , y=character.sprite.y+90 ,onComplete=tweenLevel21Off})
end

function tweenLevel21Off()
	tween21 = transition.to( game.hud.help1, { time=700, alpha=0, onComplete=function() timer.performWithDelay(800, tweenLevel21On) end})
end

----------------------------------------------------------------

--	elseif(character.sprite.x > 850 
--	and character.sprite.x < 1000 
--	and character.sprite.y > -360 
--	and character.sprite.y < -280) then
--		
--		
--		display.remove(game.hud.helpImage)
--		game.hud.helpImage = display.newImage(game.camera, "assets/images/hud/help.grab.png", 930, -270)
--		game.hud.helpImage.alpha = 0.4
--	
--		if(not character.throwGrab) then
--			if(not helpVisibleTouchCenter) then
--   			if(helpVisible22) then
--      			hideHelpLevel22()
--      		end
--				
--				showHelpTouchCenter()
--			end
--		elseif(not helpVisible22) then
--   		
--   		if(helpVisibleTouchCenter) then
--      		hideHelpTouchCenter()
--      	end
--      	
--   		showHelpLevel22()
--		end 
--		

----------------------------------------------------------------

function showHelpLevel22()
	helpVisible22 = true
	game.hud.help1 = display.newImage(game.camera, "assets/images/hud/touch.png")
	game.hud.help1.alpha = 0
	game.hud.help1:scale(0.3,0.3)
	
	game.hud.leftArrow = display.newImage(game.camera, "assets/images/tutorial/arrow.left.png")
	game.hud.leftArrow.alpha = 0.5
	game.hud.leftArrow.x = 1030
	game.hud.leftArrow.y = -360
	game.hud.leftArrow.rotation = 150
	game.hud.leftArrow:scale(0.4,0.4)

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
end


function tweenLevel22On()
	if(not helpVisible22) then return end
	game.hud.help1.x = character.sprite.x
	game.hud.help1.y = character.sprite.y
	if(tween22) then transition.cancel(tween22) end
	tween22 = transition.to( game.hud.help1, { time=1000, alpha=0.9, x=character.sprite.x-40 , y=character.sprite.y+35 ,onComplete=tweenLevel22Off})
end

function tweenLevel22Off()
	tween22 = transition.to( game.hud.help1, { time=1200, alpha=0, x=character.sprite.x-10 , y=character.sprite.y+50, onComplete=function() timer.performWithDelay(500, tweenLevel22On) end})
end


