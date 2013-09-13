-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------

APP_NAME 			= "Behind The Wind"
APP_VERSION 		= "1.0"

-----------------------------------------------------------------------------------------

IOS 					= system.getInfo( "platformName" )  == "iPhone OS"
ANDROID 				= system.getInfo( "platformName" )  == "Android"
SIMULATOR 			= system.getInfo( "environment" )  	== "simulator"

-----------------------------------------------------------------------------------------

DEV				= 1
EDITOR 			= 1

-----------------------------------------------------------------------------------------

NB_LEVELS 		= 2

-----------------------------------------------------------------------------------------

SMALL_ENERGY 		= 1
MEDIUM_ENERGY 		= 2
BIG_ENERGY 			= 3

-----------------------------------------------------------------------------------------
--- Camera focus

CHARACTER 			= 1
ROCK 					= 2

-----------------------------------------------------------------------------------------

if ANDROID then
   FONT = "Macondo-Regular"
else
	FONT = "Macondo"
end

-----------------------------------------------------------------------------------------
--- Corona's libraries
json 					= require "json"
storyboard 			= require "storyboard"
store	 				= require "store"

---- Additional libs
xml 					= require "src.libs.Xml"
utils 				= require "src.libs.Utils"
vector2D				= require "src.libs.Vector2D"
gameCenter			= require "src.libs.GameCenter"

---- Game libs
character			= require "src.game.Character"
hud					= require "src.game.HUD"

Game					= require "src.game.engine.Game"
touchController 	= require "src.game.engine.TouchController"
physicsManager		= require "src.game.engine.PhysicsManager"
effectsManager		= require "src.game.engine.EffectsManager"
musicManager		= require "src.game.engine.MusicManager"

levelDrawer 		= require "src.game.levels.LevelDrawer"

-----------------------------------------------------------------------------------------

aspectRatio = display.pixelHeight / display.pixelWidth
print(system.getInfo("model"), display.pixelWidth, display.pixelHeight, aspectRatio)

-----------------------------------------------------------------------------------------

game = Game:new()

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
router 			= require "src.tools.Router"
viewManager		= require "src.tools.ViewManager"

-----------------------------------------------------------------------------------------
---- App globals

GLOBALS = {
	savedData 		= utils.loadUserData("savedData.json"),
	levelEditor 	= utils.loadFile("levelEditor/levelEditor.json"),
	levels			= {}
}

for i=1,NB_LEVELS do
	GLOBALS.levels[i] = utils.loadFile("levelEditor/level".. i ..".json")
end

-----------------------------------------------------------------------------------------

function initGameData()

	GLOBALS.savedData = {
		user = "New player",
		fullGame = GLOBALS.savedData ~= nil and GLOBALS.savedData.fullGame,
		requireTutorial = true,
		levels = {} 
	}

   for i=1,NB_LEVELS do
   	GLOBALS.savedData.levels[i] = {complete = false}
   end

	utils.saveTable(GLOBALS.savedData, "savedData.json")
end

if(not GLOBALS.savedData) then
	initGameData()
end


-----------------------------------------------------------------------------------------

physics = require("physics") ; physics.start() ; physics.setGravity( 0,0 ) ; physics.setDrawMode( "normal" )
math.randomseed( os.time() )

------------------------------------------

CBE = require("CBEffects.Library")

------------------------------------------

if(DEV) then

   display.remove(memText)
   memText = display.newText( "0", 0, 0, FONT, 25 )
   memText:setTextColor( 255 )	
   memText:setReferencePoint( display.CenterReferencePoint )
   memText.x = display.contentWidth - memText.contentWidth/2 - 10
   memText.y = display.contentHeight - 20
   
   Runtime:addEventListener( "enterFrame", function()
   	local running 			= effectsManager.nbRunning
   	local total 			= #effectsManager.effects
   	
   	refreshMemText(running .. "/" .. total .. " - " .. math.floor(collectgarbage("count")))
   end )
    
else
	musicManager.playMusic()
end

------------------------------------------

viewManager.initBack(0)

------------------------------------------

if(EDITOR) then
   router.openLevelEditor()
else
--	router.openPlayground()
   router.openAppHome()
end

-----------------------------------------------------------------------------------------
-- MEMORY counters (DEV)
--

function refreshMemText(text)
	if(memText.contentWidth) then
		memText.text = text
		memText.size = 25
		memText.x 	= display.contentWidth - memText.contentWidth/2 - 10
	end
end

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
--      	native.setKeyboardFocus( nil )
-- 		nothing
      end
   end

   return true  --SEE NOTE BELOW
end

--add the key callback
Runtime:addEventListener( "key", onKeyEvent )