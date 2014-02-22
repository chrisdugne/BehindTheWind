-----------------------------------------------------------------------------------------

ScoreManager = {}    

-----------------------------------------------------------------------------------------

function ScoreManager:new()  

    local object = {
        score     = {}
    }

    setmetatable(object, { __index = ScoreManager })
    return object
end

--------------------------------------------------------------------------------------------------------------------------
--- RESULT BOARD
--------------------------------------------------------------------------------------------------------------------------

function ScoreManager:displayScore()

    local top = display.newRect(game.hud, display.contentWidth/2, -display.contentHeight/5, display.contentWidth, display.contentHeight/5)
    top.alpha = 0
    top:setFillColor(0)

    local bottom = display.newRect(game.hud, display.contentWidth/2, display.contentHeight, display.contentWidth, display.contentHeight/5)
    bottom.alpha = 0
    bottom:setFillColor(0)

    local board = display.newRoundedRect(game.hud, 0, 0, display.contentWidth/2, display.contentHeight/2, 20)
    board.x = display.contentWidth/2
    board.y = display.contentHeight/2
    board.alpha = 0
    board:setFillColor(0)

    transition.to( top, { time=800, alpha=1, y = top.contentHeight/2 })
    transition.to( bottom, { time=800, alpha=1, y = display.contentHeight - top.contentHeight/2 })  
    transition.to( board, { time=800, alpha=0.6, onComplete= function() self:fillBoard() end})  

end

----------------------------------

function ScoreManager:fillBoard()
    print("fillBoard ------------- ")
    utils.tprint(self.score)

    self:displayTime()
end

function ScoreManager:displayTime()

    local timeIcon      = display.newImage( game.hud, "assets/images/hud/clock.png")
    timeIcon.x          = display.contentWidth*0.3
    timeIcon.y          = display.contentHeight*0.32

    local timeText  = display.newText( game.hud, self.score.time, 0, 0, FONT, 25 )
    timeText:setFillColor( 255 )    
    timeText.anchorX    = 0
    timeText.anchorY    = 0.5
    timeText.x          = display.contentWidth*0.34
    timeText.y          = display.contentHeight*0.32

    local timePoints    = display.newText( game.hud, "", 0, 0, FONT, 38 )
    timePoints:setFillColor( 255 )    
    timePoints.anchorX  = 1
    timePoints.anchorY  = 0.5    
    timePoints.x        = display.contentWidth*0.72
    timePoints.y        = display.contentHeight*0.32

    timePoints.currentDisplay = 0
    utils.displayCounter(self.score.timePoints, timePoints, 1, 0.5, display.contentWidth*0.72, function()
        self:displayEnergies()
    end)
end


function ScoreManager:displayEnergies()

    local energiesCaughtIcon = display.newImage( game.hud, "assets/images/hud/energy.png")
    energiesCaughtIcon.x = display.contentWidth*0.3
    energiesCaughtIcon.y = display.contentHeight*0.39
    energiesCaughtIcon:scale(0.5,0.5)

    local text = self.score.energiesCaught .. " / " .. #CHAPTERS[game.chapter].levels[game.level].energies

    local energiesCaughtText = display.newText( game.hud, text, 0, 0, FONT, 25 )
    energiesCaughtText:setFillColor( 255 )    
    energiesCaughtText.anchorX    = 0
    energiesCaughtText.anchorY    = 0.5
    energiesCaughtText.x = display.contentWidth*0.34
    energiesCaughtText.y = display.contentHeight*0.39


    local plus = display.newText( game.hud, "+", 0, 0, FONT, 38 )
    plus:setFillColor( 255 )    
    plus.x = display.contentWidth*0.62
    plus.y = display.contentHeight*0.39

    local energyPoints = display.newText( game.hud, "", 0, 0, FONT, 38 )
    energyPoints:setFillColor( 255 )    
    energyPoints.anchorX    = 1
    energyPoints.anchorY    = 0.5
    energyPoints.x = display.contentWidth*0.72
    energyPoints.y = display.contentHeight*0.39

    local points = self.score.energiesCaught * self.score.energiesCaught

    energyPoints.currentDisplay = 0

    if(self.score.energiesCaught > 0) then
        utils.displayCounter(points, energyPoints, 1, 0.5, display.contentWidth*0.72, function()
            self:displayRing()
        end)
    else
        energyPoints.text = 0
        self:displayRing()
    end

end

function ScoreManager:displayRing()

    if(self.score.ringsCaught > 0) then
        local ring = display.newSprite( game.hud, levelDrawer.simplePieceImageSheet, levelDrawer.pieceSheetConfig:newSequence() )
        ring.x         = display.contentWidth*0.3
        ring.y         = display.contentHeight*0.46
        ring:play()

        local ringsBonus = display.newText( game.hud, "x " .. self.score.ringsBonus, 0, 0, FONT, 38 )
        ringsBonus:setFillColor( 255 )    
        ringsBonus.anchorX    = 1
        ringsBonus.anchorY    = 0.5
        ringsBonus.x = display.contentWidth*0.72
        ringsBonus.y = display.contentHeight*0.46
    end


    timer.performWithDelay(150, function()
        self:displayPiece()
    end)
end

function ScoreManager:displayPiece()

    if(self.score.piecesCaught > 0) then
        local piece = display.newSprite( game.hud, levelDrawer.pieceImageSheet, levelDrawer.pieceSheetConfig:newSequence() )
        piece.x         = display.contentWidth*0.3
        piece.y         = display.contentHeight*0.53
        piece:play()

        local piecesBonus = display.newText( game.hud, "x " .. self.score.piecesBonus, 0, 0, FONT, 38 )
        piecesBonus:setFillColor( 255 )    
        piecesBonus.anchorX    = 1
        piecesBonus.anchorY    = 0.5
        piecesBonus.x = display.contentWidth*0.72
        piecesBonus.y = display.contentHeight*0.53
    end

    timer.performWithDelay(150, function()
        self:displayTotal()
    end)
end

function ScoreManager:displayTotal()

    local lineAnimConfig                = require("src.game.graphics.line")
    local lineSheet                     = graphics.newImageSheet( "assets/images/hud/line.png", lineAnimConfig.sheet )

    game.hud.subheaderAnim              = display.newSprite( game.hud, lineSheet, lineAnimConfig:newSequence() )
    game.hud.subheaderAnim.anchorX      = 1
    game.hud.subheaderAnim.anchorY      = 0.5
    game.hud.subheaderAnim.x            = display.contentWidth*0.725
    game.hud.subheaderAnim.y            = display.contentHeight*0.59
    game.hud.subheaderAnim:scale(1.7,1)

    game.hud.subheaderAnim:play()

    -----

    timer.performWithDelay(400, function()
        local scoreText = display.newText( game.hud, "", 0, 0, FONT, 45 )
        scoreText.anchorX    = 1
        scoreText.anchorY    = 0.5
        scoreText:setFillColor( 255 )    
        scoreText.x = display.contentWidth*0.72
        scoreText.y = display.contentHeight*0.66

        scoreText.currentDisplay = 0
        utils.displayCounter(self.score.points, scoreText, 1, 0.5, display.contentWidth*0.72, function()
            self:displayButtons()
        end)
    end)

end

function ScoreManager:displayButtons()

    ----------------
    -- replay button

    viewManager.buildEffectButton(
    game.hud,
    "assets/images/hud/again.png", 
    21, 
    0.26*aspectRatio,
    display.contentWidth*0.3,     
    display.contentHeight*0.65,     
    function()
        local thisLevel = game.level
        game.level = 0
        game:openLevel(thisLevel) 
    end
    )

    ----------------
    -- menu button

    viewManager.buildEffectButton(
    game.hud,
    "assets/images/hud/squares.png", 
    21, 
    0.26*aspectRatio,
    display.contentWidth*0.4,     
    display.contentHeight*0.65,     
    function()
        router.openLevelSelection() 
    end
    )

    ----------------
    -- next button

    local nextLevel = game.level + 1

    if(#CHAPTERS[game.chapter].levels >= nextLevel) then
        viewManager.buildEffectButton(
        game.hud,
        "assets/images/hud/play.png", 
        21, 
        0.26*aspectRatio,
        display.contentWidth*0.5,     
        display.contentHeight*0.65,     
        function()
            game.level = 0
            game:openLevel(nextLevel) 
        end
        )
    end


end

-----------------------------------------------------------------------------------------

return ScoreManager