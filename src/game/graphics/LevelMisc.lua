--
-- created with TexturePacker (http://www.codeandweb.com/texturepacker)
--
-- $TexturePacker:SmartUpdate:724ecaa77e2733bf42f2cd6771982b4a:1/1$
--
-- local sheetInfo = require("mysheet")
-- local myImageSheet = graphics.newImageSheet( "mysheet.png", sheetInfo:getSheet() )
-- local sprite = display.newSprite( myImageSheet , {frames={sheetInfo:getFrameIndex("sprite")}} )
--

local SheetInfo = {}

SheetInfo.sheet =
{
    frames = {
    
        {
            -- 1.character.simple.bad
            x=56,
            y=90,
            width=64,
            height=64,

        },
        {
            -- 2.character.simple.green
            x=54,
            y=2,
            width=64,
            height=64,

        },
        {
            -- 3.character.simple
            x=120,
            y=2,
            width=63,
            height=63,

        },
        {
            -- 4.panel.exit
            x=2,
            y=2,
            width=50,
            height=120,

        },
        {
            -- 5.panel.finger
            x=2,
            y=124,
            width=52,
            height=94,

        },
        {
            -- 6.piece
            x=34,
            y=220,
            width=30,
            height=30,

            sourceX = 1,
            sourceY = 1,
            sourceWidth = 32,
            sourceHeight = 32
        },
        {
            -- 7.ring
            x=2,
            y=220,
            width=30,
            height=30,

            sourceX = 1,
            sourceY = 1,
            sourceWidth = 32,
            sourceHeight = 32
        },
        {
            -- 8.mini.eye
            x=54,
            y=68,
            width=20,
            height=20,

        },
        {
            -- 9-panel.exit
            x=56,
            y=156,
            width=33,
            height=60,

        },
    },
    
    sheetContentWidth = 256,
    sheetContentHeight = 256
}

SheetInfo.frameIndex =
{

    ["1.character.simple.bad"] = 1,
    ["2.character.simple.green"] = 2,
    ["3.character.simple"] = 3,
    ["4.panel.exit"] = 4,
    ["5.panel.finger"] = 5,
    ["6.piece"] = 6,
    ["7.ring"] = 7,
    ["8.mini.eye"] = 8,
    ["9-panel.exit"] = 9,
}

function SheetInfo:getSheet()
    return self.sheet;
end

function SheetInfo:getFrameIndex(name)
    return self.frameIndex[name];
end

return SheetInfo
