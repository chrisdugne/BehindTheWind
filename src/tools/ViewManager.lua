-----------------------------------------------------------------------------------------

module(..., package.seeall)

-----------------------------------------------------------------------------------------

function initBack(chapter)

    utils.emptyGroup(game.bg)
    game.bg = display.newGroup()

    -- App global background
    if(chapter == 0) then
        initBackMenu()
    end

    if(chapter == 1) then
        initBackChapter1()
    end

    if(chapter == 2) then
        initBackChapter2()
    end

    if(chapter == 3) then
        initBackChapter3()
    end

end

function initBackChapter1()

    if(game.bg.mist1) then 
        transition.cancel(game.bg.mist1)
        transition.cancel(game.bg.mist2)
    end

    game.bg.mist1 = display.newImageRect( game.bg, "assets/images/mist1.png", display.contentWidth, display.contentHeight)  
    game.bg.mist1.x = display.contentWidth/2  
    game.bg.mist1.y = display.contentHeight/2
    game.bg.mist1.alpha = 0.27

    game.bg.mist2 = display.newImageRect( game.bg, "assets/images/mist1.png", display.contentWidth, display.contentHeight)  
    game.bg.mist2.x = display.contentWidth/2  - display.contentWidth
    game.bg.mist2.y = display.contentHeight/2
    game.bg.mist2.alpha = 0.27 


    game.bg.moon = display.newImageRect( game.bg, "assets/images/moon.png", 640, 640)  
    game.bg.moon.x = 200
    game.bg.moon.y = display.contentHeight-200

    game.bg.grass = display.newImageRect( game.bg, "assets/images/grass.blur.png", 1024, 1024)  
    game.bg.grass.x = display.contentWidth/2  
    game.bg.grass.y = display.contentHeight*0.8


    game.bg.back = display.newImageRect( game.bg, "assets/images/blur.jpg", display.contentWidth, display.contentHeight)  
    game.bg.back.x = display.viewableContentWidth/2  
    game.bg.back.y = display.viewableContentHeight/2

    timer.performWithDelay(100, function()
        moveMists()
        moveMoon()
        moveGrass()
    end)

    putBackgroundToBack(1)  
end


function initBackChapter2()

    if(game.bg.mist1) then 
        transition.cancel(game.bg.mist1)
        transition.cancel(game.bg.mist2)
    end

    game.bg.mist1 = display.newImageRect( game.bg, "assets/images/mist1.png", display.contentWidth, display.contentHeight)  
    game.bg.mist1.x = display.contentWidth/2  
    game.bg.mist1.y = display.contentHeight/2
    game.bg.mist1.alpha = 0.27

    game.bg.mist2 = display.newImageRect( game.bg, "assets/images/mist1.png", display.contentWidth, display.contentHeight)  
    game.bg.mist2.x = display.contentWidth/2  - display.contentWidth
    game.bg.mist2.y = display.contentHeight/2
    game.bg.mist2.alpha = 0.27 


    game.bg.moon = display.newImageRect( game.bg, "assets/images/moon.2.png", 640, 640)  
    game.bg.moon.x = display.contentWidth-150
    game.bg.moon.y = display.contentHeight*0.3

    game.bg.grass = display.newImageRect( game.bg, "assets/images/grass.blur.png", 1024, 1024)  
    game.bg.grass.x = display.contentWidth/2  
    game.bg.grass.y = display.contentHeight*0.8

    game.bg.back = display.newImageRect( game.bg, "assets/images/blur.2.jpg", display.contentWidth, display.contentHeight)  
    game.bg.back.x = display.viewableContentWidth/2  
    game.bg.back.y = display.viewableContentHeight/2

    local eye = eye:new()
    eye:initBackgroundEye(display.contentWidth*0.2, display.contentHeight*0.25)

    game.bg.eye = eye.sprite
    game.bg.eye.rotation = -60
    game.bg.eye:toBack()
    game.bg:insert(game.bg.eye)

    timer.performWithDelay(100, function()
        moveEye()
        moveMists()
        moveMoonBack()
        moveGrass()
    end)

    putBackgroundToBack(2)  
end

function initBackChapter3()

    if(game.bg.mist1) then 
        transition.cancel(game.bg.mist1)
        transition.cancel(game.bg.mist2)
    end

    game.bg.mist1 = display.newImageRect( game.bg, "assets/images/mist1.png", display.contentWidth, display.contentHeight)  
    game.bg.mist1.x = display.contentWidth/2  
    game.bg.mist1.y = display.contentHeight/2
    game.bg.mist1.alpha = 0.27

    game.bg.mist2 = display.newImageRect( game.bg, "assets/images/mist1.png", display.contentWidth, display.contentHeight)  
    game.bg.mist2.x = display.contentWidth/2  - display.contentWidth
    game.bg.mist2.y = display.contentHeight/2
    game.bg.mist2.alpha = 0.27 


    game.bg.asteroid = display.newImageRect( game.bg, "assets/images/moon.3.png", 440, 440)  
    game.bg.asteroid.x = display.contentWidth-150
    game.bg.asteroid.y = display.contentHeight*0.3

    game.bg.asteroid2 = display.newImageRect( game.bg, "assets/images/moon.4.png", 310, 310)  
    game.bg.asteroid2.x = 50
    game.bg.asteroid2.y = display.contentHeight*0.6

    game.bg.grass = display.newImageRect( game.bg, "assets/images/grass.blur.png", 1024, 1024)  
    game.bg.grass.x = display.contentWidth/2  
    game.bg.grass.y = display.contentHeight*0.8

    game.bg.back = display.newImageRect( game.bg, "assets/images/blur.3.jpg", display.contentWidth, display.contentHeight)  
    game.bg.back.x = display.viewableContentWidth/2  
    game.bg.back.y = display.viewableContentHeight/2

    timer.performWithDelay(100, function()
        moveMists()
        moveAsteroid()
        moveAsteroid2()
        moveGrass()
    end)

    putBackgroundToBack(3)  
end


function initBackMenu()

    if(game.bg.mist1) then 
        transition.cancel(game.bg.mist1)
        transition.cancel(game.bg.mist2)
    end

    game.bg.mist1 = display.newImageRect( game.bg, "assets/images/mist1.png", display.contentWidth, display.contentHeight)  
    game.bg.mist1.x = display.contentWidth/2  
    game.bg.mist1.y = display.contentHeight/2
    game.bg.mist1.alpha = 0.27

    game.bg.mist2 = display.newImageRect( game.bg, "assets/images/mist1.png", display.contentWidth, display.contentHeight)  
    game.bg.mist2.x = display.contentWidth/2  - display.contentWidth
    game.bg.mist2.y = display.contentHeight/2
    game.bg.mist2.alpha = 0.27 

    game.bg.moon = display.newImageRect( game.bg, "assets/images/moon.png", 640, 640)  
    game.bg.moon.x = display.contentWidth-300  
    game.bg.moon.y = display.contentHeight/2-260 

    game.bg.back = display.newImageRect( game.bg, "assets/images/blur.jpg", display.contentWidth, display.contentHeight)  
    game.bg.back.x = display.viewableContentWidth/2  
    game.bg.back.y = display.viewableContentHeight/2

    timer.performWithDelay(100, function()
        moveMists()
        moveMoon()
    end)

    putBackgroundToBack(0)  
end

--------------------------------------------------------------------

function putBackgroundToBack(chapter)

    if(chapter == 0) then
        game.bg.mist1:toBack()
        game.bg.mist2:toBack()
        game.bg.moon:toBack()
        game.bg.back:toBack()
    end

    if(chapter == 1 or chapter == 2) then
        game.bg.mist1:toBack()
        game.bg.mist2:toBack()
        game.bg.grass:toBack()
        game.bg.moon:toBack()
        game.bg.back:toBack()
    end

    if(chapter == 3) then
        game.bg.mist1:toBack()
        game.bg.mist2:toBack()
        game.bg.grass:toBack()
        game.bg.asteroid:toBack()
        game.bg.asteroid2:toBack()
        game.bg.back:toBack()
    end

    game.bg:toBack()
end

function putForegroundToFront(level)

    if(level >= 1) then
        game.bg.mist1:toFront()
        game.bg.mist2:toFront()
    end
end

---------------------------------------------------------------------------------    

function moveMists()

    if(game.bg.mist1) then 
        transition.cancel(game.bg.mist1)
        transition.cancel(game.bg.mist2)
    end

    transition.to( game.bg.mist2, { time=30000, x=game.bg.mist2.x+display.contentWidth})
    transition.to( game.bg.mist1, { time=30000, x=game.bg.mist1.x+display.contentWidth })
end

function replaceMists()
    game.bg.mist1.x = display.viewableContentWidth/2  
    game.bg.mist2.x = display.viewableContentWidth/2 - display.contentWidth
    moveMists()
end

---------------------------------------------------------------------------------    

function moveMoonBack()
    transition.to( game.bg.moon, { time=170000, x=0, y =display.contentHeight, rotation=0, onComplete = function() moveMoon() end })
end

function moveMoon()
    transition.to( game.bg.moon, { time=150000, x=display.contentWidth-150 , y=display.contentHeight*0.3, rotation=20, onComplete = function() moveMoonBack() end })
end

---------------------------------------------------------------------------------    

function moveAsteroidBack()
    transition.to( game.bg.asteroid, { time=170000, x=display.contentWidth-150, y=display.contentHeight*0.3, rotation=0, onComplete = function() moveAsteroid() end })
end

function moveAsteroid()
    transition.to( game.bg.asteroid, { time=180000, x=0 , y=display.contentHeight, rotation=400, onComplete = function() moveAsteroidBack() end })
end

function moveAsteroid2Back()
    transition.to( game.bg.asteroid2, { time=160000, x=50, y =display.contentHeight*0.6, rotation=0, onComplete = function() moveAsteroid2() end })
end

function moveAsteroid2()
    transition.to( game.bg.asteroid2, { time=150000, x=display.contentWidth*0.7 , y=display.contentHeight*0.1, rotation=400, onComplete = function() moveAsteroid2Back() end })
end

---------------------------------------------------------------------------------    

function moveEyeBack()
    transition.to( game.bg.eye, { time=150000, x=display.contentWidth*0.2, y=display.contentHeight*0.3, rotation = -60, onComplete = function() moveEye() end })
end

function moveEye()
    transition.to( game.bg.eye, { time=150000, x=display.contentWidth*0.25 , y=display.contentHeight, rotation = -140, onComplete = function() moveEyeBack() end })
end

---------------------------------------------------------------------------------    

function moveGrass()
    transition.to( game.bg.grass, { time=9000, rotation=4, transition=easing.inOutSine, onComplete = function() moveGrassBack() end })
end

function moveGrassBack()
    transition.to( game.bg.grass, { time=9000, rotation=-4, transition=easing.inOutSine, onComplete = function() moveGrass() end })
end

------------------------------------------------------------------------------------------
-- INTRO TOOLS
------------------------------------------------------------------------------------------

function displayIntroText(text, x, y)

    if(not text) then
        return
    end

    local introText = display.newText( game.hud, text, 0, 0, FONT, 35 )
    introText:setFillColor( 255 )    
    introText.x = x
    introText.y = y
    introText.alpha = 0

    transition.to( introText, { time=2600, alpha=1, x = x +40, onComplete=function()
            transition.to( introText, { time=2600, alpha=0,  x = x + 80 })
        end})
end

function displayIntroTitle(text, x, y)

    if(not text) then
        return
    end

    local introText = display.newText( game.hud, text, 0, 0, FONT, 75 )
    introText:setFillColor( 255 )    
    introText.x = x
    introText.y = y
    introText.alpha = 0

    transition.to( introText, { time=1600, alpha=1, onComplete=function()
            transition.to( introText, { time=3200, alpha=0 })
        end})
end

------------------------------------------------------------------------------------------
-- MENU TOOLS
-----------------------------------------------------------------------------------------

function buildEffectButton(parent, titleOrIcon, titleSize, scale, x, y, action, isLocked )
    return buildButton(parent, titleOrIcon, titleSize, scale, x, y, action, isLocked, true )
end

function buildSimpleButton(parent, titleOrIcon, titleSize, scale, x, y, action, isLocked )
    return buildButton(parent, titleOrIcon, titleSize, scale, x, y, action, isLocked, false )
end

-----------------------------------------------------------------------------------------


function buildButton(parent, titleOrIcon, titleSize, scale, x, y, action, isLocked, effect )

    --------------------------------------

    local slash = string.find(titleOrIcon,"/")
    local colors={{255, 255, 255}, {255, 70, 70}}

    --------------------------------------

    local planet = display.newImage( "assets/images/game/moon.png")
    planet:scale(scale*0.28,scale*0.28)
    planet.x = x
    planet.y = y
    planet.alpha = 0
    planet.color = color
    parent:insert(planet)
    transition.to( planet, { time=2000, alpha=1 })
    planet:toFront()

    --------------------------------------

    if(slash) then
        local icon = display.newImage(titleOrIcon)
        icon:scale(scale*1.5,scale*1.5)
        icon.x = planet.x
        icon.y = planet.y
        icon.alpha = 0
        parent:insert(icon)

        transition.to( icon, { time=2000, alpha=1 }) 
        icon:toFront()
    else
        local text = display.newText( titleOrIcon, 0, 0, FONT, titleSize )
        text:setFillColor( 255 )    
        text.x = x
        text.y = y
        text.alpha = 0
        planet.text = text
        parent:insert(text)

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
        parent:insert(lock)
        transition.to( lock, { time=2000, alpha=0.6 })
        planet:setFillColor(30,30,30)
        lock:toFront()
    else
        utils.onTouch(planet, function()
            musicManager:playGrab()
            action()
        end)
        if(effect) then
            effectsManager.buttonEffect(x,y,scale)
        end
    end

    return planet

end