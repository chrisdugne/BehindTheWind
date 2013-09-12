-----------------------------------------------------------------------------------------

module(..., package.seeall)

-----------------------------------------------------------------------------------------

local fires = {}
local elements = {}

local mist1, mist2, moon, back
-----------------------------------------------------------------------------------------

function initView(view)
	cleanupFires()
end

------------------------------------------------------------------------------------------

function initBack()
	if(mist1 and mist1.tween) then transition.cancel(mist1.tween) end
	if(mist2 and mist2.tween) then transition.cancel(mist2.tween) end
	if(moon and moon.tween) then transition.cancel(moon.tween) end
	display.remove(mist1)
	display.remove(mist2)
	display.remove(back)
	display.remove(moon)
	
	mist1 = display.newImageRect( "assets/images/mist1.png", display.contentWidth, display.contentHeight)  
	mist1.x = display.viewableContentWidth/2  
	mist1.y = display.viewableContentHeight/2
	mist1.alpha = 0.37

	mist2 = display.newImageRect( "assets/images/mist1.png", display.contentWidth, display.contentHeight)  
	mist2.x = display.viewableContentWidth/2  - display.contentWidth
	mist2.y = display.viewableContentHeight/2
	mist2.alpha = 0.37 
	
	moveMists()
	
	moon = display.newImageRect( "assets/images/moon.png", 320, 320)  
	moon.x = display.contentWidth-150  
	moon.y = display.contentHeight/2-130 
	
	moveMoon()
	
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

function moveMoon()
	moon.tween = transition.to( moon, { time=170000, x=0, y =display.contentHeight,onComplete = function() moveMoonBack() end })
end

function replaceMists()
	mist1.x = display.viewableContentWidth/2  
	mist2.x = display.viewableContentWidth/2 - display.contentWidth
	moveMists()
end

function moveMoonBack()
	transition.to( moon, { time=150000, x=display.contentWidth-150 , y=display.contentHeight/2, onComplete = function() moveMoon() end })
end

------------------------------------------------------------------------------------------

function buildButton(view, title, color, titleSize, x, y, action, lock, condition )

	local colors={{255, 255, 255}, {255, 70, 70}}

	local planet = display.newImage( "assets/images/game/planet.".. color ..".png")
	planet:scale(display.contentHeight/1000,display.contentHeight/1000)
	planet.x = x
	planet.y = y
	planet.alpha = 0
	planet.color = color
	view:insert(planet)
	
	
	local text = display.newText( title, 0, 0, FONT, titleSize )
	text:setTextColor( 0 )	
	text.x = x
	text.y = y
	text.alpha = 0
	view:insert(text)
	
	transition.to( planet, { time=2000, alpha=1 })
	transition.to( text, { time=2000, alpha=1 })
	
	if(lock and condition) then
   	local lock = display.newImage("assets/images/hud/lock.png")
   	lock:scale(0.50,0.50)
   	lock.x = x
   	lock.y = y
   	lock.alpha = 0
   	view:insert(lock)
   	transition.to( lock, { time=2000, alpha=0.6 })
   	planet:setFillColor(30,30,30)
   	
   	return planet, text, lock
   else
		planet:addEventListener	("touch", function(event) action() end)

   	local fire=CBE.VentGroup{
   		{
   			title="fire",
   			preset="burn",
   			color=colors,
   			build=function()
   				local size=math.random(24, 38)
   				return display.newImageRect("CBEffects/textures/generic_particle.png", size, size)
   			end,
   			onCreation=function()end,
   			perEmit=2,
   			emissionNum=0,
   			x=x,
   			y=y,
   			positionType="inRadius",
   			posRadius=38,
   			emitDelay=50,
   			fadeInTime=1500,
   			lifeSpan=250,
   			lifeStart=250,
   			endAlpha=0,
   			physics={
   				velocity=0.5,
   				xDamping=1,
   				gravityY=0.6,
   				gravityX=0
   			}
   		}
   	}
   	
   	table.insert(fires, fire)
		fire:start("fire")
		
   	return planet, text
	end

end

------------------------------------------------------------------------------------------

function buildSmallButton(view, title, titleSize, x, y, action, lock )

	local colors={{181, 255, 111}, {120, 255, 70}}

	local planet = display.newImage( "assets/images/game/planet.white.png")
	planet:scale(0.13,0.13)
	planet.x = x
	planet.y = y
	planet.alpha = 0
	planet.color = color
	view:insert(planet)
	
	local text = display.newText( title, 0, 0, FONT, titleSize )
	text:setTextColor( 0 )	
	text.x = x
	text.y = y-2
	text.alpha = 0
	view:insert(text)
	
	transition.to( planet, 	{ time=2000, alpha=1 })
	transition.to( text, 	{ time=2000, alpha=1 })
	
	if(lock) then
   	local lock = display.newImage("assets/images/hud/lock.png")
   	lock:scale(0.15,0.15)
   	lock.x = x
   	lock.y = y
   	lock.alpha = 0
   	view:insert(lock)
   	transition.to( lock, { time=2000, alpha=0.6 })
   	planet:setFillColor(30,30,30)
   	
   else
		planet:addEventListener	("touch", function(event) action() end)

   	local fire=CBE.VentGroup{
   		{
   			title="fire",
   			preset="burn",
   			color=colors,
   			build=function()
   				local size=math.random(31, 38) -- Particles are a bit bigger than ice comet particles
   				return display.newImageRect("CBEffects/textures/generic_particle.png", size, size)
   			end,
   			onCreation=function()end,
   			perEmit=1,
   			emissionNum=0,
   			x=x,
   			y=y,
   			positionType="inRadius",
   			posRadius=12,
   			emitDelay=500,
   			fadeInTime=1500,
   			lifeSpan=1000, -- Particles are removed sooner than the ice comet
   			lifeStart=250,
   			endAlpha=0,
   			physics={
   				velocity=0.4,
   				gravityY=0.3,
   				gravityX=0
   			}
   		}
   	}
   	
   	table.insert(fires, fire)
		fire:start("fire")
	end
end

------------------------------------------

function cleanupFires()	

	for fire = 1, #fires do 
		fires[fire]:destroy("fire")
	end
	
	while #fires > 0 do
   	table.remove(fires, 1)
	end
	
	collectgarbage("collect")
end