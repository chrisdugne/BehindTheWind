-----------------------------------------------------------------------------------------

module(..., package.seeall)

-----------------------------------------------------------------------------------------

-- level 1 background
local mist1, mist2, moon, back

-----------------------------------------------------------------------------------------

function initBack(level)

	-- try to remove level 1 background

	if(mist1 and mist1.tween) then transition.cancel(mist1.tween) end
	if(mist2 and mist2.tween) then transition.cancel(mist2.tween) end
	if(moon and moon.tween) then transition.cancel(moon.tween) end
	display.remove(mist1)
	display.remove(mist2)
	display.remove(moon)

	-- try to remove global background
	display.remove(back)

	-- level 0 : App global background
	if(level == 0) then
		initBackMenu()
	end

	if(level >= 1) then
		initBackLevel1()
	end
end


function initBackLevel1()
	
	mist1 = display.newImageRect( "assets/images/mist1.png", display.contentWidth, display.contentHeight)  
	mist1.x = display.viewableContentWidth/2  
	mist1.y = display.viewableContentHeight/2
	mist1.alpha = 0.37

	mist2 = display.newImageRect( "assets/images/mist1.png", display.contentWidth, display.contentHeight)  
	mist2.x = display.viewableContentWidth/2  - display.contentWidth
	mist2.y = display.viewableContentHeight/2
	mist2.alpha = 0.37 
	
	moveMists()
	
	moon = display.newImageRect( "assets/images/moon.png", 640, 640)  
	moon.x = 200
	moon.y = display.contentHeight-200
	
	moveMoon()
	
	back = display.newImageRect( "assets/images/blur.jpg", display.contentWidth, display.contentHeight)  
	back.x = display.viewableContentWidth/2  
	back.y = display.viewableContentHeight/2
	
	putBackgroundToBack()  
end


function initBackMenu()
	
	mist1 = display.newImageRect( "assets/images/mist1.png", display.contentWidth, display.contentHeight)  
	mist1.x = display.viewableContentWidth/2  
	mist1.y = display.viewableContentHeight/2
	mist1.alpha = 0.37

	mist2 = display.newImageRect( "assets/images/mist1.png", display.contentWidth, display.contentHeight)  
	mist2.x = display.viewableContentWidth/2  - display.contentWidth
	mist2.y = display.viewableContentHeight/2
	mist2.alpha = 0.37 
	
	moveMists()
	
	moon = display.newImageRect( "assets/images/moon.png", 640, 640)  
	moon.x = display.contentWidth-300  
	moon.y = display.contentHeight/2-260 
	
	moveMoonBack()
	
	back = display.newImageRect( "assets/images/blur.jpg", display.contentWidth, display.contentHeight)  
	back.x = display.viewableContentWidth/2  
	back.y = display.viewableContentHeight/2
	
	putBackgroundToBack()  
end

function putBackgroundToBack()
	mist1:toBack();
	mist2:toBack();
	moon:toBack();
	back:toBack();
end
	
function moveMists()
	mist1.tween = transition.to( mist1, { time=30000, x=mist1.x+display.contentWidth })
	mist2.tween = transition.to( mist2, { time=30000, x=mist2.x+display.contentWidth, onComplete = function() replaceMists() end })
end

function replaceMists()
	mist1.x = display.viewableContentWidth/2  
	mist2.x = display.viewableContentWidth/2 - display.contentWidth
	moveMists()
end

function moveMoonBack()
	moon.tween = transition.to( moon, { time=170000, x=0, y =display.contentHeight,onComplete = function() moveMoon() end })
end

function moveMoon()
	transition.to( moon, { time=150000, x=display.contentWidth-150 , y=display.contentHeight/2, onComplete = function() moveMoonBack() end })
end

------------------------------------------------------------------------------------------
-- INTRO TOOLS
------------------------------------------------------------------------------------------

function displayIntroText(text, x, y, fade)

	if(not text) then
		return
	end

	local introText = display.newText( screen, text, 0, 0, FONT, 45 )
	introText:setTextColor( 255 )	
	introText.x = x
	introText.y = y
	introText.alpha = 0
	introText:setReferencePoint( display.CenterReferencePoint )
	
	transition.to( introText, { time=1200, alpha=1, onComplete=function()
		if(fade) then
      	timer.performWithDelay(500, function()
      			transition.to( introText, { time=1000, alpha=0 })
			end)
		end
	end})
end

------------------------------------------------------------------------------------------
-- MENU TOOLS
-----------------------------------------------------------------------------------------


function buildButton(titleOrIcon, color, titleSize, scale, x, y, action, isLocked )
	
	--------------------------------------

	local slash = string.find(titleOrIcon,"/")
	local colors={{255, 255, 255}, {255, 70, 70}}

	--------------------------------------

	local planet = display.newImage( "assets/images/game/planet.".. color ..".png")
	planet:scale(scale,scale)
	planet.x = x
	planet.y = y
	planet.alpha = 0
	planet.color = color
	game.hud:insert(planet)
	transition.to( planet, { time=2000, alpha=1 })
	planet:toFront()

	--------------------------------------
	
	if(slash) then
   	local icon = display.newImage(titleOrIcon)
   	icon:scale(scale*2,scale*2)
   	icon.x = planet.x
   	icon.y = planet.y
   	icon.alpha = 0
   	game.hud:insert(icon)
   	
   	transition.to( icon, { time=2000, alpha=1 }) 
   	icon:toFront()
	else
   	local text = display.newText( titleOrIcon, 0, 0, FONT, titleSize )
   	text:setTextColor( 0 )	
   	text.x = x
   	text.y = y
   	text.alpha = 0
   	game.hud:insert(text)
   	
   	transition.to( text, { time=2000, alpha=1 })
   	text:toFront()
	end

	--------------------------------------
	
	if(isLocked) then
   	local lock = display.newImage("assets/images/hud/lock.png")
   	lock:scale(scale*1.3,scale*1.3)
   	lock.x = x
   	lock.y = y
   	lock.alpha = 0
   	game.hud:insert(lock)
   	transition.to( lock, { time=2000, alpha=0.6 })
   	planet:setFillColor(30,30,30)
   	lock:toFront()
   else
   	utils.onTouch(planet, action)
		effectsManager.buttonEffect(x,y,scale)
	end
	
end