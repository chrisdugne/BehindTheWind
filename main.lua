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
SIMULATOR 			= system.getInfo( "environment" )  == "simulator"

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
	level1 			= utils.loadFile("levelEditor/level1.json"),
	levelEditor 	= utils.loadFile("levelEditor/levelEditor.json"),
}

camera = display.newGroup()

-----------------------------------------------------------------------------------------

physics = require("physics") ; physics.start() ; physics.setGravity( 0,0 ) ; physics.setDrawMode( "normal" )
math.randomseed( os.time() )

------------------------------------------

CBE = require("CBEffects.Library")

------------------------------------------

--musicManager.playMusic()

------------------------------------------

--router.openAppHome()
router.openPlayground()
--router.openLevelEditor()

-----------------------------------------------------------------------------------------
-- DEV ONLY
--
-----------------------------------------------
-- MEMORY counters
--
hud.initTopRightText()

Runtime:addEventListener( "enterFrame", function()
	local running 			= effectsManager.nbRunning
	local total 			= #effectsManager.effects
	
	hud.refreshTopRightText(running .. "/" .. total .. " - " .. math.floor(collectgarbage("count")))
end )

-----------------------------------------------
-- RESET BUTTON

--local reset = display.newCircle( 20, 20, 15 )
--reset.alpha = 0.01
--
--reset:addEventListener ( "touch", function(event) 
--	if(event.phase == "began") then
--		router.openAppHome()
--	end
--	
--	return true
--end )


-----------------------------------------------------------------------------------------
--	
--if(not GLOBALS.savedData) then
--	initGameData()
--end
--
--function initGameData()
--
--	GLOBALS.savedData = {
--		user = "New player",
--		fullGame = GLOBALS.savedData ~= nil and GLOBALS.savedData.fullGame,
--		requireTutorial = true,
--		levels = {{available = true}}, 
--		scores = {
--			classic={},
--		}
--	}
--
--	utils.saveTable(GLOBALS.savedData, "savedData.json")
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
--      	native.setKeyboardFocus( nil )
-- 		nothing
      end
   end

   return true  --SEE NOTE BELOW
end

--add the key callback
Runtime:addEventListener( "key", onKeyEvent )