--
-- created with TexturePacker (http://www.codeandweb.com/texturepacker)
--
-- $TexturePacker:SmartUpdate:403f8b9af12def6b0cf080037d317a2f:1/1$
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
            -- ivy2.mini
            x=310,
            y=163,
            width=152,
            height=159,

        },
        {
            -- ivy3.mini
            x=156,
            y=324,
            width=152,
            height=159,

        },
        {
            -- ivy4.mini
            x=156,
            y=163,
            width=152,
            height=159,

        },
        {
            -- ivy5.mini
            x=310,
            y=2,
            width=152,
            height=159,

        },
        {
            -- ivy6.mini
            x=156,
            y=2,
            width=152,
            height=159,

        },
        {
            -- ivy7.mini
            x=2,
            y=324,
            width=152,
            height=159,

        },
        {
            -- ivy8.mini
            x=2,
            y=163,
            width=152,
            height=159,

        },
        {
            -- ivy9.mini
            x=2,
            y=2,
            width=152,
            height=159,

        },
    },
    
    sheetContentWidth = 512,
    sheetContentHeight = 512
}

SheetInfo.frameIndex =
{

    ["ivy2.mini"] = 1,
    ["ivy3.mini"] = 2,
    ["ivy4.mini"] = 3,
    ["ivy5.mini"] = 4,
    ["ivy6.mini"] = 5,
    ["ivy7.mini"] = 6,
    ["ivy8.mini"] = 7,
    ["ivy9.mini"] = 8,
}

function SheetInfo:getSheet()
    return self.sheet;
end

function SheetInfo:getFrameIndex(name)
    return self.frameIndex[name];
end

return SheetInfo
