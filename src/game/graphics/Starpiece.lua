--
-- created with TexturePacker (http://www.codeandweb.com/texturepacker)
--
-- $TexturePacker:SmartUpdate:2efdc3bd40db6df4c5582f05dd50dda7:1/1$
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
            -- powerpiece weiss1
            x=2,
            y=206,
            width=32,
            height=32,

        },
        {
            -- powerpiece weiss10
            x=2,
            y=172,
            width=32,
            height=32,

        },
        {
            -- powerpiece weiss11
            x=2,
            y=138,
            width=32,
            height=32,

        },
        {
            -- powerpiece weiss12
            x=70,
            y=104,
            width=32,
            height=32,

        },
        {
            -- powerpiece weiss13
            x=36,
            y=104,
            width=32,
            height=32,

        },
        {
            -- powerpiece weiss14
            x=2,
            y=104,
            width=32,
            height=32,

        },
        {
            -- powerpiece weiss15
            x=70,
            y=70,
            width=32,
            height=32,

        },
        {
            -- powerpiece weiss2
            x=36,
            y=70,
            width=32,
            height=32,

        },
        {
            -- powerpiece weiss3
            x=2,
            y=70,
            width=32,
            height=32,

        },
        {
            -- powerpiece weiss4
            x=70,
            y=36,
            width=32,
            height=32,

        },
        {
            -- powerpiece weiss5
            x=36,
            y=36,
            width=32,
            height=32,

        },
        {
            -- powerpiece weiss6
            x=2,
            y=36,
            width=32,
            height=32,

        },
        {
            -- powerpiece weiss7
            x=70,
            y=2,
            width=32,
            height=32,

        },
        {
            -- powerpiece weiss8
            x=36,
            y=2,
            width=32,
            height=32,

        },
        {
            -- powerpiece weiss9
            x=2,
            y=2,
            width=32,
            height=32,

        },
    },
    
    sheetContentWidth = 128,
    sheetContentHeight = 256
}

SheetInfo.frameIndex =
{

    ["powerpiece weiss1"] = 1,
    ["powerpiece weiss10"] = 2,
    ["powerpiece weiss11"] = 3,
    ["powerpiece weiss12"] = 4,
    ["powerpiece weiss13"] = 5,
    ["powerpiece weiss14"] = 6,
    ["powerpiece weiss15"] = 7,
    ["powerpiece weiss2"] = 8,
    ["powerpiece weiss3"] = 9,
    ["powerpiece weiss4"] = 10,
    ["powerpiece weiss5"] = 11,
    ["powerpiece weiss6"] = 12,
    ["powerpiece weiss7"] = 13,
    ["powerpiece weiss8"] = 14,
    ["powerpiece weiss9"] = 15,
}

function SheetInfo:getSheet()
    return self.sheet;
end

function SheetInfo:getFrameIndex(name)
    return self.frameIndex[name];
end

return SheetInfo
