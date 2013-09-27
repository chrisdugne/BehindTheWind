-----------------------------------------------------------------------------------------
--
-- router.lua
--
-----------------------------------------------------------------------------------------

module(..., package.seeall)

-----------------------------------------------------------------------------------------

function resetScreen()
	effectsManager.restart()
	utils.emptyGroup(game.camera)
	hud.destroy()
end

-----------------------------------------------------------------------------------------

function openAppHome()
	resetScreen()
	storyboard.gotoScene( "src.views.AppHome" )
end

---------------------------------------------

function openPlayground()
	print("--> openPlayground")
	resetScreen()
	storyboard.gotoScene( "src.views.Playground" )
end

---------------------------------------------

function openLevelEditor()
	resetScreen()
	storyboard.gotoScene( "src.views.LevelEditor" )
end

---------------------------------------------

function openLevelSelection()
	resetScreen()
	storyboard.gotoScene( "src.views.LevelSelection" )
end

---------------------------------------------

function openChapterSelection()
	resetScreen()
	storyboard.gotoScene( "src.views.ChapterSelection" )
end

---------------------------------------------

function openOptions()
	resetScreen()
	storyboard.gotoScene( "src.views.Options" )
end

---------------------------------------------

function openScore()
	resetScreen()
	storyboard.gotoScene( "src.views.Score" )
end

---------------------------------------------

function openBuy()
	resetScreen()
	storyboard.gotoScene( "src.views.Buy" )
end