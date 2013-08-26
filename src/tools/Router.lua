-----------------------------------------------------------------------------------------
--
-- router.lua
--
-----------------------------------------------------------------------------------------

module(..., package.seeall)

-----------------------------------------------------------------------------------------

function openAppHome()
	hud.explodeHUD()
	storyboard.gotoScene( "src.views.AppHome" )
end

---------------------------------------------

function openPlayground()
	storyboard.gotoScene( "src.views.Playground" )
end

---------------------------------------------

function openLevelEditor()
	storyboard.gotoScene( "src.views.LevelEditor" )
end

---------------------------------------------

function openLevelSelection()
	storyboard.gotoScene( "src.views.LevelSelection" )
end

---------------------------------------------

function openOptions()
	storyboard.gotoScene( "src.views.Options" )
end

---------------------------------------------

function openScore()
	storyboard.gotoScene( "src.views.Score" )
end

---------------------------------------------

function openBuy()
	storyboard.gotoScene( "src.views.Buy" )
end