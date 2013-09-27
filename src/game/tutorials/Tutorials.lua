-----------------------------------------------------------------------------------------

module(..., package.seeall)

-----------------------------------------------------------------------------------------


function listenHelp()

   if(game.level == 1) then
      refreshHUDTutoLevel1()

   elseif(game.level == 2) then
      refreshHUDTutoLevel2()

   elseif(game.level == 3) then
      refreshHUDTutoLevel3()

  	elseif(game.level == 4) then
      refreshHUDTutoLevel4()
   
   end
end
   

function destroy()

   if(game.level == 2) then
   	destroyTutoLevel2()
   end

   if(game.level == 3) then
   	destroyTutoLevel3()
   end
   
   if(game.level == 4) then
   	destroyTutoLevel41()
   	destroyTutoLevel42()
   end
   
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
	game.hud.finger = display.newImage(game.hud, "assets/images/hud/touch.png", display.contentWidth*0.8, display.contentHeight*0.36)
	game.hud.finger.alpha = 0
	tweenLevel1On()
end

function hideHelpLevel1()
	helpVisible1 = false
	transition.cancel(tween11)
	display.remove(game.hud.finger)
end

function tweenLevel1On()
	tween11 = transition.to( game.hud.finger, { time=600, alpha=0.7, onComplete=tweenLevel1Off})
end

function tweenLevel1Off()
	tween11 = transition.to( game.hud.finger, { time=600, alpha=0.4, onComplete=tweenLevel1On})
end


-----------------------------------------------------------------------------------------
-- TUTO LEVEL 2
-----------------------------------------------------------------------------------------
 
local helpVisibleLevel2 = false

function refreshHUDTutoLevel2()

	if(character.sprite.x > 180 
	and character.sprite.x < 230 
	and character.sprite.y < 310 
	and character.sprite.y > 250
	and levelDrawer.level.triggers[1].remaining > 0) then
	
		if(not helpVisibleLevel2) then
   		character.grabLocked = true
      	character.movesLocked = true
 			character.lookLeft()
   		showHelpLevel2()
		end 

	elseif(helpVisibleLevel2) then
		character.grabLocked = false
		character.movesLocked = false
		destroyTutoLevel2()
	end 	
end

function destroyTutoLevel2()

	display.remove(game.hud.helpImage)
	
	helpVisibleLevel2 = false
	transition.cancel(game.hud.finger)
	display.remove(game.hud.finger)
	
	display.remove(game.hud.rightArrow)
	display.remove(game.hud.leftArrow)
	display.remove(game.hud.topArrow)
	display.remove(game.hud.bottomArrow)
end


-------------------------------

function showHelpLevel2()
	helpVisibleLevel2 = true
	game.hud.helpImage = display.newImage(game.camera, "assets/images/tutorial/tuto2.1.png", 220, 130)
		
	game.hud.finger = display.newImage(game.camera, "assets/images/hud/touch.png")
	game.hud.finger:scale(0.3,0.3)
	game.hud.finger.x = character.sprite.x
	game.hud.finger.y = character.sprite.y
	game.hud.finger.alpha = 0
	
	-- trigger
	--"y":130,
	--"x":110,
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
	
	tweenLevel2On()
end

function tweenLevel2On()
	if(not helpVisibleLevel2) then return end
	game.hud.finger.x = character.sprite.x
	game.hud.finger.y = character.sprite.y
	transition.to( game.hud.finger, { time=700, alpha=0.9, x=character.sprite.x+25 , y=character.sprite.y+90 ,onComplete=tweenLevel2Off})
end

function tweenLevel2Off()
	transition.to( game.hud.finger, { time=700, alpha=0, onComplete=function() timer.performWithDelay(800, tweenLevel2On) end})
end



-----------------------------------------------------------------------------------------
-- TUTO LEVEL 3
-----------------------------------------------------------------------------------------
 
local helpVisibleLevel3 = false
local tileToDrag

function refreshHUDTutoLevel3()

	if(character.sprite.x > 180 
	and character.sprite.x < 200 
	and character.sprite.y < 350 
	and character.sprite.y > 290) then
	
		if(not helpVisibleLevel3) then

			for k,group in pairs(levelDrawer.level.groups) do
				if(k == 5) then
					tileToDrag = group[1]
				end
			end

   		character.grabLocked = true
      	character.movesLocked = true
   		showHelpLevel3()
			
		else
			if(tileToDrag.x < 280) then
      		character.grabLocked = false
      		character.movesLocked = false
      		destroyTutoLevel3()
				Runtime:removeEventListener( "enterFrame", tutorials.listenHelp )
			end
		end 

	end 	
end

function destroyTutoLevel3()

	helpVisibleLevel3 = false
	transition.cancel(game.hud.finger)
	display.remove(game.hud.finger)
end


-------------------------------

function showHelpLevel3()
	helpVisibleLevel3 = true
		
	game.hud.finger = display.newImage(game.camera, "assets/images/hud/touch.png")
	game.hud.finger:scale(0.3,0.3)
	game.hud.finger.alpha = 0.9
	
	--------------
	
	tweenLevel3On()
end

function tweenLevel3On()
	if(not helpVisibleLevel3) then return end
	game.hud.finger.x = tileToDrag.x
	game.hud.finger.y = tileToDrag.y
	transition.to( game.hud.finger, { time=300, alpha=0.9 })
	transition.to( game.hud.finger, { time=2500, x=250, transition=easing.inSine, onComplete=tweenLevel3Off })
end

function tweenLevel3Off()
	transition.to( game.hud.finger, { time=700, alpha=0, onComplete=function() timer.performWithDelay(800, tweenLevel3On) end})
end

----------------------------------------------------------------


-----------------------------------------------------------------------------------------
-- TUTO LEVEL 4
-----------------------------------------------------------------------------------------
 
local helpVisibleLevel41 = false
local helpVisibleLevel42 = false

function refreshHUDTutoLevel4()

	if(character.sprite.x > 110 
	and character.sprite.x < 260 
	and character.sprite.y < 330 
	and character.sprite.y > 270) then
	
		if(not helpVisibleLevel41 and character.throwFire) then
			if(helpVisibleLevel42) then
				destroyTutoLevel42()
			end
      	character.movesLocked = true
   		showHelpLevel41()
		elseif(helpVisibleLevel41 and character.throwGrab) then
   		destroyTutoLevel41()
		elseif(not helpVisibleLevel42 and character.throwGrab) then
      	character.movesLocked = true
   		showHelpLevel42()
		end 
	elseif(helpVisibleLevel42) then
		-- grab ok
		character.movesLocked = false
		destroyTutoLevel42()
	end 	
end

function destroyTutoLevel41()
	helpVisibleLevel41 = false
	transition.cancel(game.hud.finger)
	display.remove(game.hud.finger)
	display.remove(game.hud.helpImage41)
end

function destroyTutoLevel42()
	helpVisibleLevel42 = false
	transition.cancel(game.hud.finger)
	display.remove(game.hud.finger)
	display.remove(game.hud.helpImage42)
end


-------------------------------

function showHelpLevel41()
	helpVisibleLevel41 = true
	
	game.hud.helpImage41 = display.newImage(game.camera, "assets/images/tutorial/tuto4.1.png", character.sprite.x - 300, character.sprite.y - 140)
		
	game.hud.finger = display.newImage(game.camera, "assets/images/hud/touch.png")
	game.hud.finger:scale(0.3,0.3)
	game.hud.finger.alpha = 0.5
	game.hud.finger.x = character.sprite.x
	game.hud.finger.y = character.sprite.y + 10
	
	--------------
	
	tweenLevel41On()
end

function tweenLevel41On()
	if(not helpVisibleLevel41) then return end
	transition.to( game.hud.finger, { time=900, alpha=0.9, onComplete=tweenLevel41Off })
end

function tweenLevel41Off()
	transition.to( game.hud.finger, { time=900, alpha=0.2, onComplete=tweenLevel41On})
end

-------------------------------

function showHelpLevel42()
	helpVisibleLevel42 = true
	
	game.hud.helpImage42 = display.newImage(game.camera, "assets/images/tutorial/tuto4.2.png", character.sprite.x - 280, character.sprite.y - 280)
		
	game.hud.finger = display.newImage(game.camera, "assets/images/hud/touch.png")
	game.hud.finger:scale(0.3,0.3)
	game.hud.finger.alpha = 0.9
	
	--------------
	
	tweenLevel42On()
end

function tweenLevel42On()
	if(not helpVisibleLevel42) then return end
	game.hud.finger.x = character.sprite.x
	game.hud.finger.y = character.sprite.y
	transition.to( game.hud.finger, { time=700, alpha=0.9, x=character.sprite.x-25 , y=character.sprite.y+90 ,onComplete=tweenLevel42Off})
end

function tweenLevel42Off()
	transition.to( game.hud.finger, { time=700, alpha=0, onComplete=function() timer.performWithDelay(800, tweenLevel42On) end})
end

----------------------------------------------------------------



----------------------------------------------------------------
--
--
--
--function showHelpTouchCenter()
--
--	helpVisibleTouchCenter = true
--	game.hud.finger = display.newImage(game.camera, "assets/images/hud/touch.png")
--	game.hud.help2 = display.newImage(game.hud, "assets/images/tutorial/arrow.top.png")
--	game.hud.finger:scale(0.3,0.3)
--	game.hud.finger.alpha = 0
--	game.hud.help2.x = 50
--	game.hud.help2.y = 170
--	tweenTouchCenterOn()
--end
--
--function hideHelpTouchCenter()
--	helpVisibleTouchCenter = false
--	transition.cancel(tweenTouchCenter1)
--	transition.cancel(tweenTouchCenter2)
--	display.remove(game.hud.finger)
--	display.remove(game.hud.help2)
--end
--
--function tweenTouchCenterOn()
--	if(not helpVisibleTouchCenter) then return end
--	tweenTouchCenter1 = transition.to( game.hud.finger, { time=600, alpha=0.7})
--	tweenTouchCenter2 = transition.to( game.hud.help2, { time=600, alpha=0.7, onComplete=tweenTouchCenterOff})
--end
--
--function tweenTouchCenterOff()
--	tweenTouchCenter1 = transition.to( game.hud.finger, { time=600, alpha=0.4})
--	tweenTouchCenter2 = transition.to( game.hud.help2, { time=600, alpha=0.4, onComplete=tweenTouchCenterOn})
--end