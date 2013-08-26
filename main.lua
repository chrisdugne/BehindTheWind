-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------

APP_NAME 			= "Atmosphere"
APP_VERSION 		= "1.0"

-----------------------------------------------------------------------------------------

IOS 					= system.getInfo( "platformName" )  == "iPhone OS"
ANDROID 				= system.getInfo( "platformName" )  == "Android"
SIMULATOR 			= system.getInfo( "environment" )  == "simulator"

-----------------------------------------------------------------------------------------

IMAGE_CENTER		= "IMAGE_CENTER";
IMAGE_TOP_LEFT 	= "IMAGE_TOP_LEFT";

-----------------------------------------------------------------------------------------

if ANDROID then
   FONT = "Macondo-Regular"
else
	FONT = "Macondo"
end

-----------------------------------------------------------------------------------------
--- Corona's libraries
json 				= require "json"
storyboard 		= require "storyboard"
store	 			= require "store"

---- Additional libs
xml 				= require "src.libs.Xml"
utils 			= require "src.libs.Utils"
vector2D			= require "src.libs.Vector2D"
gameCenter		= require "src.libs.GameCenter"

touchController = require "src.libs.TouchController"
levelDrawer 	= require "src.libs.LevelDrawer"

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
musicManager	= require "src.tools.MusicManager"

---- Game libs
hud				= require "src.game.HUD"
game				= require "src.game.Game"

-----------------------------------------------------------------------------------------
---- App globals

GLOBALS = {
	savedData 	= utils.loadTable("savedData.json"),
	levels 		= utils.loadTable("levels.json"),
	levelEditor = utils.loadTable("levelEditor.json")
}

-----------------------------------------------------------------------------------------

physics = require("physics") ; physics.start() ; physics.setGravity( 0,0 ) ; physics.setDrawMode( "normal" )
math.randomseed( os.time() )

------------------------------------------

CBE	=	require("CBEffects.Library")

------------------------------------------
	
if(not GLOBALS.savedData) then
	game.initGameData()
end

------------------------------------------

--musicManager.playMusic()

------------------------------------------

--router.openAppHome()
--router.openPlayground()
router.openLevelEditor()

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
