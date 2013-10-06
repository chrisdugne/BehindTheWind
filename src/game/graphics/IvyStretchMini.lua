--
-- created with TexturePacker (http://www.codeandweb.com/texturepacker)
--
-- $TexturePacker:SmartUpdate:53362f6326a6f4f2072662f51acc7537:1/1$
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
            -- ivy2.stretch.mini
            x=144,
            y=526,
            width=140,
            height=260,

        },
        {
            -- ivy3.stretch.mini
            x=2,
            y=526,
            width=140,
            height=260,

        },
        {
            -- ivy4.stretch.mini
            x=286,
            y=264,
            width=140,
            height=260,

        },
        {
            -- ivy5.stretch.mini
            x=144,
            y=264,
            width=140,
            height=260,

        },
        {
            -- ivy6.stretch.mini
            x=2,
            y=264,
            width=140,
            height=260,

        },
        {
            -- ivy7.stretch.mini
            x=286,
            y=2,
            width=140,
            height=260,

        },
        {
            -- ivy8.stretch.mini
            x=144,
            y=2,
            width=140,
            height=260,

        },
        {
            -- ivy9.stretch.mini
            x=2,
            y=2,
            width=140,
            height=260,

        },
    },
    
    sheetContentWidth = 512,
    sheetContentHeight = 1024
}

SheetInfo.frameIndex =
{

    ["ivy2.stretch.mini"] = 1,
    ["ivy3.stretch.mini"] = 2,
    ["ivy4.stretch.mini"] = 3,
    ["ivy5.stretch.mini"] = 4,
    ["ivy6.stretch.mini"] = 5,
    ["ivy7.stretch.mini"] = 6,
    ["ivy8.stretch.mini"] = 7,
    ["ivy9.stretch.mini"] = 8,
}

function SheetInfo:getSheet()
    return self.sheet;
end

function SheetInfo:getFrameIndex(name)
    return self.frameIndex[name];
end

return SheetInfo
