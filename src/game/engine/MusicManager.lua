-----------------------------------------------------------------------------------------

module(..., package.seeall)

-----------------------------------------------------------------------------------------

local main      = audio.loadSound("assets/music/btw.mp3")
local trigger   = audio.loadSound("assets/music/trigger.mp3")
local ring      = audio.loadSound("assets/music/ring.mp3")
local exit      = audio.loadSound("assets/music/exit.mp3")
local fall      = audio.loadSound("assets/music/fall.mp3")

local energies   = {
    audio.loadSound("assets/music/energy1.mp3"),
    audio.loadSound("assets/music/energy2.mp3"),
    audio.loadSound("assets/music/energy3.mp3"),
    audio.loadSound("assets/music/energy4.mp3"),
    audio.loadSound("assets/music/energy5.mp3")
}

local grabs   = {
    audio.loadSound("assets/music/grab1.mp3"),
    audio.loadSound("assets/music/grab2.mp3"),
    audio.loadSound("assets/music/grab3.mp3")
}

-----------------------------------------------------------------------------------------

local channelMusic 
local channelTriggers 
local channelEnergies 
local channelGrabs 

-----------------------------------------------------------------------------------------

function playMusic()
--    audio.fadeOut({ channel=channelIntro, time=800 } )
    channelMusic = audio.play( main, {
--        fadeIn = 1500,
        loops=-1,
    })
end

function playTrigger()
    channelTriggers = audio.play( ring )
    audio.setVolume( 0.6, { channel = channelTriggers } )
end

function playExit()
    channelTriggers = audio.play( exit )
    audio.setVolume( 0.9, { channel = channelTriggers } )
end

function playFall()
    channelTriggers = audio.play( fall )
    audio.setVolume( 0.6, { channel = channelTriggers } )
end

function playRing()
    channelTriggers = audio.play( ring )
    audio.setVolume( 0.9, { channel = channelTriggers } )
end

function playEnergy()
    channelEnergies = audio.play( energies[utils.random(#energies)] )
    audio.setVolume( 0.4, { channel = channelEnergies } )
end

function playGrab()
    channelGrabs = audio.play( grabs[utils.random(#grabs)] )
    audio.setVolume( 0.3, { channel = channelGrabs } )
end