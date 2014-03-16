---------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------

APP_NAME                = "Behind The Wind"
APP_VERSION             = "1.5.0|1" -- version|playable chapters

-----------------------------------------------------------------------------------------

IOS                     = system.getInfo( "platformName" )  == "iPhone OS"
ANDROID                 = system.getInfo( "platformName" )  == "Android"
SIMULATOR               = system.getInfo( "environment" )   == "simulator"

-----------------------------------------------------------------------------------------

--DEV                = 1
--EDITOR             = 1

-----------------------------------------------------------------------------------------

OPEN_CHAPTERS = 1

CHAPTERS = {
    {title="Chapter1 : Mist",              name = "Mist",             nbLevels = 8},
    {title="Chapter2 : Moonshine",         name = "Moonshine",        nbLevels = 8},
    {title="Chapter3 : Magic",             name = "Magic",            nbLevels = 1},
--    {title="Chapter4 : Mystery",         nbLevels = 1},
}

-----------------------------------------------------------------------------------------

SMALL_ENERGY         = 1
MEDIUM_ENERGY        = 2
BIG_ENERGY           = 3

-----------------------------------------------------------------------------------------
--- Camera focus

CHARACTER            = 1
ROCK                 = 2

-----------------------------------------------------------------------------------------

if ANDROID then
    FONT = "Macondo-Regular"    
else
    FONT = "Macondo"
end

-----------------------------------------------------------------------------------------

system.activate( "multitouch" )

-----------------------------------------------------------------------------------------
--- Corona's libraries
json                    = require "json"
storyboard              = require "storyboard"
store                   = require "store"

---- Additional libs
xml                     = require "src.libs.Xml"
utils                   = require "src.libs.Utils"
vector2D                = require "src.libs.Vector2D"
gameCenter              = require "src.libs.GameCenter"

---- Game libs
character               = require "src.game.Character"
enemy                   = require "src.game.Enemy"
eye                     = require "src.game.Eye"
hud                     = require "src.game.HUD"
tutorials               = require "src.game.tutorials.Tutorials"

Game                    = require "src.game.engine.Game"
ScoreManager            = require "src.game.engine.ScoreManager"

touchController         = require "src.game.engine.TouchController"
physicsManager          = require "src.game.engine.PhysicsManager"
effectsManager          = require "src.game.engine.EffectsManager"
musicManager            = require "src.game.engine.MusicManager"

levelDrawer             = require "src.game.levels.LevelDrawer"

-----------------------------------------------------------------------------------------

aspectRatio = display.pixelHeight / display.pixelWidth
print(system.getInfo("model"), display.pixelWidth, display.pixelHeight, aspectRatio)

-----------------------------------------------------------------------------------------

abs        = math.abs
random     = math.random

-----------------------------------------------------------------------------------------

game                = Game:new()
scoreManager        = ScoreManager:new()

-----------------------------------------------------------------------------------------
-- Translations

local translations = require("assets.Translations")
local LANG =  userDefinedLanguage or system.getPreference("ui", "language")

function T(enText)
    return translations[enText][LANG] or enText
end

-----------------------------------------------------------------------------------------
---- Server access Managers

---- App Tools
router             = require "src.tools.Router"
viewManager        = require "src.tools.ViewManager"

-----------------------------------------------------------------------------------------

FB_APP_ID = "644960942204092" 

-----------------------------------------------------------------------------------------
---- App globals

GLOBALS = {
    savedData       = utils.loadUserData("savedData.json"),
    levelEditor     = utils.loadFile("levelEditor/levelEditor.json"),
}

for i=1,#CHAPTERS do

    CHAPTERS[i].levels = {}

    for j=1,CHAPTERS[i].nbLevels do
        CHAPTERS[i].levels[j] = utils.loadFile("src/game/levels/chapter".. i .. "/level".. i .. j ..".json")
    end

end

-----------------------------------------------------------------------------------------

game:init()

-----------------------------------------------------------------------------------------

physics = require("physics") ; physics.start() ; physics.setGravity( 0,0 ) ; physics.setDrawMode( "normal" )
math.randomseed( os.time() )

------------------------------------------

CBE = require("CBEffects.Library")

------------------------------------------

if(DEV) then
---
--   display.remove(memText)
--   memText = display.newText( "0", 0, 0, FONT, 25 )
--   memText:setFillColor( 255 )    
--   memText:setReferencePoint( display.CenterReferencePoint )
--   memText.x = display.contentWidth - memText.contentWidth/2 - 10
--   memText.y = display.contentHeight - 20
--   
--   Runtime:addEventListener( "enterFrame", function()
--       local running             = effectsManager.nbRunning
--       local total             = #effectsManager.effects
--       
--       refreshMemText(running .. "/" .. total .. " - " .. math.floor(collectgarbage("count")))
--   end )

else
    print("playMusic")
    musicManager.playMusic()
end

------------------------------------------

if(EDITOR) then
    router.openLevelEditor()
else
    utils.getFacebookLikes(function()
        if(GLOBALS.savedData.requireTutorial) then
            game.chapter    = 1
            game.level      = 1
            router.openPlayground()
        else
            router.openAppHome()
        end
    end)  
end

-----------------------------------------------------------------------------------------
-- MEMORY counters (DEV)
--
--function refreshMemText(text)
--    if(memText.contentWidth) then
--        memText.text = character.grabs ..  "    " .. text
--        memText.size = 25
--        memText.x     = display.contentWidth - memText.contentWidth/2 - 10
--    end
--end

-----------------------------------------------------------------------------------------
--- iOS Status Bar
display.setStatusBar( display.HiddenStatusBar ) 

------------------------------------------
--- ANDROID BACK BUTTON

local function onKeyEvent( event )

    local phase = event.phase
    local keyName = event.keyName
    print( event.phase, event.keyName )

    if ( "back" == keyName and phase == "up" ) then
        if ( storyboard.currentScene == "splash" ) then
            native.requestExit()
        else
            if ( storyboard.isOverlay ) then
                storyboard.hideOverlay()
            else
                local lastScene = storyboard.returnTo
                print( "previous scene", lastScene )
                if ( lastScene ) then
                    storyboard.gotoScene( lastScene, { effect="crossFade", time=500 } )
                else
                    native.requestExit()
                end
            end
        end
    end

    if ( keyName == "volumeUp" and phase == "down" ) then
        local masterVolume = audio.getVolume()
        print( "volume:", masterVolume )
        if ( masterVolume < 1.0 ) then
            masterVolume = masterVolume + 0.1
            audio.setVolume( masterVolume )
        end
    elseif ( keyName == "volumeDown" and phase == "down" ) then
        local masterVolume = audio.getVolume()
        print( "volume:", masterVolume )
        if ( masterVolume > 0.0 ) then
            masterVolume = masterVolume - 0.1
            audio.setVolume( masterVolume )
        end
    end

    return true  --SEE NOTE BELOW
end

--add the key callback
Runtime:addEventListener( "key", onKeyEvent )
