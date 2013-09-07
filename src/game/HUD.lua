-----------------------------------------------------------------------------------------

module(..., package.seeall)

-----------------------------------------------------------------------------------------

elements = display.newGroup()

-----------------------------------------------------------------------------------------

function initHUD()
	utils.emptyGroup(elements)
end

-----------------------------------------------------------------------------------------

function setExit(toApply)
	exitButton = display.newImage( game.scene, "assets/images/hud/exit.png")
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
	elements:insert(exitButton)
end

function setBackToHome()
	exitButton = display.newImage( game.scene, "assets/images/hud/exit.png")
	exitButton.x = display.contentWidth - 20
	exitButton.y = 45
	exitButton.alpha = 0.5
	exitButton:scale(0.75,0.75)
	exitButton:addEventListener("touch", function(event)
		router.openAppHome()
	end)
	elements:insert(exitButton)
end

-----------------------------------------------------------------------------------------

function explodeHUD()
   for i=elements.numChildren,1,-1 do
		explode(elements[i], 4, 2400, elements[i].color)
	end
	
	if(powerBarFire) then powerBarFire:stop("fire") end
end
			
-----------------------------------------------------------------------------------------

function explode(element, emissionNum, fadeInTime, color)

	if(not color) then color = "white" end

	local colors
	if(color == 1 ) then
		colors={{0, 111, 255}, {0, 70, 255}}
	elseif(color == 2 ) then
		colors={{181, 255, 111}, {120, 255, 70}}
	elseif(color == 3 ) then
		colors={{255, 255, 111}, {255, 255, 70}}
	elseif(color == 4 ) then
		colors={{255, 111, 0}, {255, 70, 0}}
	else
		colors={{181, 255, 111}, {120, 255, 70}}
	end
	
	if(not emissionNum) then
		emissionNum = 3
	end

	if(not fadeInTime) then
		fadeInTime = 3500
	end
	
   local explosion=CBE.VentGroup{
   	{
   		title="fire",
   		preset="wisps",
   		color=colors,
   		x = element.x,
   		y = element.y,
   		emissionNum = emissionNum,
   		fadeInTime = fadeInTime,
   		physics={
   			gravityX=1.2,
   			gravityY=13.2,
   		}
   	}
   }
   
   explosion:start("fire")
   display.remove(element)
   element = nil
   
	timer.performWithDelay(fadeInTime + 2000, function()
		explosion:destroy("fire")
		explosion = nil
	end)
end
-----------------------------------------------------------------------------------------

function initTopRightText()
	display.remove(topRightText)
	topRightText = display.newText( game.scene, "0", 0, 0, FONT, 21 )
	topRightText:setTextColor( 255 )	
	topRightText:setReferencePoint( display.CenterReferencePoint )
	topRightText.x = display.contentWidth - topRightText.contentWidth/2 - 10
	topRightText.y = display.contentHeight - 20
	elements:insert(topRightText)
end

function refreshTopRightText(text)
	if(topRightText.contentWidth) then
		topRightText.text = text
		topRightText.x 	= display.contentWidth - topRightText.contentWidth/2 - 10
	end
end
