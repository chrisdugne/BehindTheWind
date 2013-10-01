-----------------------------------------------------------------------------------------

module(..., package.seeall)

-----------------------------------------------------------------------------------------

local HUD_TOP = display.contentHeight*0.04

-----------------------------------------------------------------------------------------

ENERGY_ICON_LEFT 			= display.contentWidth*0.04
ENERGY_ICON_TOP 			= HUD_TOP
ENERGY_TEXT_LEFT 			= display.contentWidth*0.07
ENERGY_TEXT_TOP 			= HUD_TOP

PIECE_ICON_LEFT 			= display.contentWidth*0.10
PIECE_ICON_TOP 			= HUD_TOP
PIECE_TEXT_LEFT 			= display.contentWidth*0.13
PIECE_TEXT_TOP 			= HUD_TOP

SIMPLE_PIECE_ICON_LEFT 	= display.contentWidth*0.15
SIMPLE_PIECE_ICON_TOP 	= HUD_TOP
SIMPLE_PIECE_TEXT_LEFT 	= display.contentWidth*0.18
SIMPLE_PIECE_TEXT_TOP 	= HUD_TOP

FIRE_BUTTON_X 				= display.contentWidth*0.93
FIRE_BUTTON_Y 				= display.contentHeight*0.88

GRAB_BUTTON_X 				= display.contentWidth*0.93
GRAB_BUTTON_Y 				= display.contentHeight*0.67


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

	buildButtons()

	-----------------------------------------------------------------

	Runtime:addEventListener( "enterFrame", refreshHUD )

	-----------------------------------------------------------------

	if(game.chapter == 1 and (game.level == 2 or game.level == 3 or game.level == 4 )) then
		tutorials.start()
	end

	timer.performWithDelay(2000, function()

		if(game.chapter == 1 and game.level == 1) then
   		tutorials.start()
		end

		viewManager.buildSimpleButton(
		"assets/images/hud/back.png",
		51, 
		0.18*aspectRatio,
		display.contentWidth*0.95, 
		display.contentHeight*0.05, 
		function() 
			if(game.state == game.STOPPED) then return end
			game.state=game.STOPPED
			hud.destroy()
			transition.to(game.camera, {time = 1500, alpha = 0 })
			timer.performWithDelay(1600, backToSelection)
		end
		)
	end)

end

-----------------------------------------------------------------------------------------

function buildButtons()

	-----------------------------------------------------------------
	-- Move buttons
	-- 

	game.hud.leftButton = display.newImage( game.hud, "assets/images/hud/button.left.png" )
	game.hud.leftButton.x = display.contentWidth*0.07
	game.hud.leftButton.y = display.contentHeight*0.90
	game.hud.leftButton.alpha = 0.6
	game.hud.leftButton:scale(0.5,0.5)

	game.hud.leftButton:addEventListener( "touch", function(event)

		if(event.id == touchController.throwTouchFingerId) then return false end

		if(event.phase == "began" or event.phase == "moved") then
			touchController.rightTouch	 			= false 
			touchController.leftTouch 				= true
			touchController.moveTouchFingerId	= event.id 
			game.hud.leftButton.alpha = 1
			game.hud.rightButton.alpha = 0.6
			character.move()
		elseif(event.phase == "ended") then
			game.hud.leftButton.alpha = 0.6
			touchController.leftTouch 				= false
			touchController.moveTouchFingerId	= nil  
			character.stop()
		end
		return true 
	end)

	game.hud.rightButton = display.newImage( game.hud, "assets/images/hud/button.right.png" )
	game.hud.rightButton.x = display.contentWidth*0.17
	game.hud.rightButton.y = display.contentHeight*0.90
	game.hud.rightButton.alpha = 0.6
	game.hud.rightButton:scale(0.5,0.5)

	game.hud.rightButton:addEventListener( "touch", function(event)

		if(event.id == touchController.throwTouchFingerId) then return false end

		if(event.phase == "began" or event.phase == "moved") then
			touchController.leftTouch 				= false 
			touchController.rightTouch 			= true 
			touchController.moveTouchFingerId	= event.id 
			game.hud.rightButton.alpha = 1
			game.hud.leftButton.alpha = 0.6
			character.move()
		elseif(event.phase == "ended") then
			touchController.rightTouch 			= false 
			touchController.moveTouchFingerId	= nil
			game.hud.rightButton.alpha = 0.6
			character.stop()
		end
		return true 
	end)


	-----------------------------------------------------------------
	-- Throw buttons
	-- 

		game.hud.fireBigButton = display.newImage( game.hud, "assets/images/hud/button.png" )
		game.hud.fireBigButton.x = FIRE_BUTTON_X
		game.hud.fireBigButton.y = FIRE_BUTTON_Y
		game.hud.fireBigButton.alpha = 0.6
		game.hud.fireBigButton:scale(0.7,0.7)

		game.hud.throwSwipeMax = game.hud.fireBigButton.contentHeight*0.5 - 10

		game.hud.fireBigButton:addEventListener( "touch", function(event)

			if(character.throwGrab) then return false end
			if(event.id == touchController.moveTouchFingerId) then return false end

			if(event.phase == "began") then
				game.hud.fireBigButton.alpha = 1
				touchController.throwTouchFingerId= event.id 

				if(GLOBALS.savedData.fireEnable) then
					character.throwFire = true
					character.setThrowing()
				end 

			end 

			if(event.phase == "began" or event.phase == "moved") then
				placeFireSmallButton(event)

			elseif(event.phase == "ended") then
				character.mayThrow()	
				game.hud.fireBigButton.alpha = 0.6
				game.hud.fireSmallButton.x = FIRE_BUTTON_X
				game.hud.fireSmallButton.y = FIRE_BUTTON_Y
				touchController.throwTouchFingerId = nil
			end

			return true 
		end)

		game.hud.fireSmallButton = display.newImage( game.hud, "assets/images/hud/red.center.png" )
		game.hud.fireSmallButton.x = FIRE_BUTTON_X
		game.hud.fireSmallButton.y = FIRE_BUTTON_Y
		game.hud.fireSmallButton.alpha = 0.6
		game.hud.fireSmallButton:scale(0.7,0.7)

		if(not GLOBALS.savedData.fireEnable) then	
   		game.hud.fireBigButton.alpha = 0
   		game.hud.fireSmallButton.alpha = 0
   	end

		-----------------------------------------------------------
		
		game.hud.grabBigButton = display.newImage( game.hud, "assets/images/hud/button.png" )
		game.hud.grabBigButton.x = GRAB_BUTTON_X
		game.hud.grabBigButton.y = GRAB_BUTTON_Y
		game.hud.grabBigButton.alpha = 0.6
		game.hud.grabBigButton:scale(0.7,0.7)

		game.hud.grabBigButton:addEventListener( "touch", function(event)

			if(character.throwFire) then return false end
			if(event.id == touchController.moveTouchFingerId) then return false end

			if(event.phase == "began") then
				game.hud.grabBigButton.alpha = 1
				touchController.throwTouchFingerId= event.id 

				if(GLOBALS.savedData.grabEnable) then
					character.throwGrab = true
					character.setGrabbing()
				end 

			end 

			if(event.phase == "began" or event.phase == "moved") then
				placeGrabSmallButton(event)

			elseif(event.phase == "ended") then
				character.mayThrow()	
				game.hud.grabBigButton.alpha = 0.6
				game.hud.grabSmallButton.x = GRAB_BUTTON_X
				game.hud.grabSmallButton.y = GRAB_BUTTON_Y
				touchController.throwTouchFingerId = nil
			end

			return true 
		end)

		game.hud.grabSmallButton = display.newImage( game.hud, "assets/images/hud/blue.center.png" )
		game.hud.grabSmallButton.x = GRAB_BUTTON_X
		game.hud.grabSmallButton.y = GRAB_BUTTON_Y
		game.hud.grabSmallButton.alpha = 0.6
		game.hud.grabSmallButton:scale(0.7,0.7)

		if(not GLOBALS.savedData.grabEnable) then	
   		game.hud.grabBigButton.alpha = 0
   		game.hud.grabSmallButton.alpha = 0
   	end
end

-----------------------------------------------------------------------------------------

function placeFireSmallButton(event)
	local direction = vector2D:new(hud.FIRE_BUTTON_X - event.x, hud.FIRE_BUTTON_Y - event.y )
	if(direction:magnitude() > game.hud.throwSwipeMax) then
		direction:normalize()
		direction:mult(game.hud.throwSwipeMax)
	end

	game.hud.fireSmallButton.x = hud.FIRE_BUTTON_X - direction.x
	game.hud.fireSmallButton.y = hud.FIRE_BUTTON_Y - direction.y

	physicsManager.refreshTrajectory( game.hud.fireSmallButton.x - game.camera.x, game.hud.fireSmallButton.y - game.camera.y, FIRE_BUTTON_X - game.camera.x, FIRE_BUTTON_Y - game.camera.y)
	if(game.hud.fireSmallButton.x > FIRE_BUTTON_X) then character.lookLeft() else character.lookRight() end
end


function placeGrabSmallButton(event)
	local direction = vector2D:new(hud.GRAB_BUTTON_X - event.x, hud.GRAB_BUTTON_Y - event.y )
	if(direction:magnitude() > game.hud.throwSwipeMax) then
		direction:normalize()
		direction:mult(game.hud.throwSwipeMax)
	end

	game.hud.grabSmallButton.x = hud.GRAB_BUTTON_X - direction.x
	game.hud.grabSmallButton.y = hud.GRAB_BUTTON_Y - direction.y

	physicsManager.refreshTrajectory( game.hud.grabSmallButton.x - game.camera.x, game.hud.grabSmallButton.y - game.camera.y, GRAB_BUTTON_X - game.camera.x, GRAB_BUTTON_Y - game.camera.y)
	if(game.hud.fireSmallButton.x > GRAB_BUTTON_X) then character.lookLeft() else character.lookRight() end
end

function releaseAllButtons(fingerId)

	if(fingerId == touchController.moveTouchFingerId) then
		game.hud.leftButton.alpha = 0.6
		game.hud.rightButton.alpha = 0.6
		touchController.moveTouchFingerId = nil
	end

	if(fingerId == touchController.throwTouchFingerId) then

		if(character.throwFire) then
   		game.hud.fireBigButton.alpha 		= 0.6
   		game.hud.fireSmallButton.alpha 	= 0.6
   	elseif(character.throwGrab) then
   		game.hud.grabBigButton.alpha 		= 0.6
   		game.hud.grabSmallButton.alpha 	= 0.6
		end
		
		character.mayThrow()
		touchController.throwTouchFingerId = nil
		
		game.hud.fireSmallButton.x = FIRE_BUTTON_X
		game.hud.fireSmallButton.y = FIRE_BUTTON_Y

		game.hud.grabSmallButton.x = GRAB_BUTTON_X
		game.hud.grabSmallButton.y = GRAB_BUTTON_Y
	end


end

-----------------------------------------------------------------------------------------

function backToSelection()
	game:destroyBeforeExit()
	timer.performWithDelay(1000, function()
		router.openLevelSelection()
	end)
end

-----------------------------------------------------------------------------------------

function destroy()
	Runtime:removeEventListener( "enterFrame", refreshHUD )
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
--
--function initFollowRockButton()
--	game.hud.followButton = display.newCircle( game.hud, display.contentWidth - 40, display.contentHeight - 40, 25 )
--	hideFollowRockButton()
--end
--
--function touchFollowRock(event)
--	if(event.phase == "began") then
--		game.focus = ROCK 
--	elseif(event.phase == "ended") then
--		game.focus = CHARACTER 
--	end
--
--	return true
--end
--
--function showFollowRockButton()
--	game.hud.followButton.alpha = 1
--	game.hud.followButton:addEventListener ( "touch", touchFollowRock )
--end
--
--function hideFollowRockButton()
--	if(game.state == game.RUNNING) then
--		game.hud.followButton.alpha = 0
--		game.hud.followButton:removeEventListener ( "touch", touchFollowRock )
--		game.focus = CHARACTER 
--		-- else : destroyed earlier
--	end
--end

-----------------------------------------------------------------------------------------

function showDropButton()
	display.remove(game.hud.dropButton)
	game.hud.dropButton = display.newImage( game.hud, "assets/images/hud/button.drop.png" )
	game.hud.dropButton.x = GRAB_BUTTON_X - display.contentWidth*0.1
	game.hud.dropButton.y = GRAB_BUTTON_Y
	game.hud.dropButton.alpha = 0.8

	game.hud.dropButton:addEventListener( "touch", function(event)

		if(character.throwFire) then return false end
		if(character.throwGrab) then return false end
		if(event.id == touchController.moveTouchFingerId) then return false end

		if(event.phase == "began") then
			physicsManager.detachAllRopes() 
			hideDropButton()
		end 

		return true 
	end)
end

function hideDropButton()
	if(game.state == game.RUNNING) then
		utils.destroyFromDisplay(game.hud.dropButton)
	end
end
