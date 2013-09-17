--
-- created with TexturePacker (http://www.codeandweb.com/texturepacker)
--
-- $TexturePacker:SmartUpdate:4e27cdd048064688658a6274c7120c2b:1/1$
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
            -- 1.character.simple.bad
            x=2,
            y=68,
            width=64,
            height=64,

        },
        {
            -- 2.character.simple.green
            x=2,
            y=2,
            width=64,
            height=64,

        },
        {
            -- 3.character.simple
            x=54,
            y=134,
            width=63,
            height=63,

        },
        {
            -- 4.panel.exit
            x=2,
            y=134,
            width=50,
            height=120,

        },
        {
            -- 5.panel.finger
            x=68,
            y=2,
            width=52,
            height=94,

        },
        {
            -- 6.piece
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
            -- 7.ring
            x=68,
            y=98,
            width=30,
            height=30,

            sourceX = 1,
            sourceY = 1,
            sourceWidth = 32,
            sourceHeight = 32
        },
        {
            -- 8.mini.eye
            x=100,
            y=98,
            width=20,
            height=20,

        },
    },
    
    sheetContentWidth = 128,
    sheetContentHeight = 256
}

LevelMisc.frameIndex =
{

    ["1.character.simple.bad"] = 1,
    ["2.character.simple.green"] = 2,
    ["3.character.simple"] = 3,
    ["4.panel.exit"] = 4,
    ["5.panel.finger"] = 5,
    ["6.piece"] = 6,
    ["7.ring"] = 7,
    ["8.mini.eye"] = 8,
}

function LevelMisc:getSheet()
    return self.sheet;
end

function LevelMisc:getFrameIndex(name)
    return self.frameIndex[name];
end

return LevelMisc
