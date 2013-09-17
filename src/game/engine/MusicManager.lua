-----------------------------------------------------------------------------------------

module(..., package.seeall)

-----------------------------------------------------------------------------------------

local main = audio.loadSound("assets/music/btw.mp3")
local intro = audio.loadSound("assets/music/intro.mp3")

local channelIntro
local channelMusic

-----------------------------------------------------------------------------------------

function playMusic()
--	audio.fadeOut({ channel=channelIntro, time=800 } )
	channelMusic = audio.play( main, {
--		fadeIn = 1500,
		loops=-1,
	})
end

function playIntro()
	channelIntro = audio.play( intro, {
		loops=-1,
	})
end