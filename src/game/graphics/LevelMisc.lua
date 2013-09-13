--
-- created with TexturePacker (http://www.codeandweb.com/texturepacker)
--
-- $TexturePacker:SmartUpdate:7f556e784b82d58554e49b2e10ed9204:1/1$
--
-- local LevelMisc = require("mysheet")
-- local myImageSheet = graphics.newImageSheet( "mysheet.png", LevelMisc:getSheet() )
-- local sprite = display.newSprite( myImageSheet , {frames={LevelMisc:getFrameIndex("sprite")}} )
--

local LevelMisc = {}

LevelMisc.sheet =
{
    frames = {
    
        {
            -- character.simple.bad
            x=2,
            y=68,
            width=64,
            height=64,

        },
        {
            -- character.simple.green
            x=2,
            y=2,
            width=64,
            height=64,

        },
        {
            -- character.simple
            x=54,
            y=134,
            width=63,
            height=63,

        },
        {
            -- panel.exit
            x=2,
            y=134,
            width=50,
            height=120,

        },
        {
            -- panel.finger
            x=68,
            y=2,
            width=52,
            height=94,

        },
        {
            -- piece
            x=54,
            y=199,
            width=30,
            height=30,

            sourceX = 1,
            sourceY = 1,
            sourceWidth = 32,
            sourceHeight = 32
        },
        {
            -- simple.piece
            x=68,
            y=98,
            width=30,
            height=31,

            sourceX = 2,
            sourceY = 0,
            sourceWidth = 34,
            sourceHeight = 33
        },
    },
    
    sheetContentWidth = 128,
    sheetContentHeight = 256
}

LevelMisc.frameIndex =
{

    ["character.simple.bad"] = 1,
    ["character.simple.green"] = 2,
    ["character.simple"] = 3,
    ["panel.exit"] = 4,
    ["panel.finger"] = 5,
    ["piece"] = 6,
    ["simple.piece"] = 7,
}

function LevelMisc:getSheet()
    return self.sheet;
end

function LevelMisc:getFrameIndex(name)
    return self.frameIndex[name];
end

return LevelMisc
