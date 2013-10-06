--
-- created with TexturePacker (http://www.codeandweb.com/texturepacker)
--
-- $TexturePacker:SmartUpdate:8ecc98735e2210b9d6f6b3f31b9412ac:1/1$
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
            -- ivy2
            x=2,
            y=1482,
            width=352,
            height=368,

        },
        {
            -- ivy3
            x=2,
            y=1112,
            width=352,
            height=368,

        },
        {
            -- ivy4
            x=356,
            y=742,
            width=352,
            height=368,

        },
        {
            -- ivy5
            x=2,
            y=742,
            width=352,
            height=368,

        },
        {
            -- ivy6
            x=356,
            y=372,
            width=352,
            height=368,

        },
        {
            -- ivy7
            x=2,
            y=372,
            width=352,
            height=368,

        },
        {
            -- ivy8
            x=356,
            y=2,
            width=352,
            height=368,

        },
        {
            -- ivy9
            x=2,
            y=2,
            width=352,
            height=368,

        },
    },
    
    sheetContentWidth = 1024,
    sheetContentHeight = 2048
}

SheetInfo.frameIndex =
{

    ["ivy2"] = 1,
    ["ivy3"] = 2,
    ["ivy4"] = 3,
    ["ivy5"] = 4,
    ["ivy6"] = 5,
    ["ivy7"] = 6,
    ["ivy8"] = 7,
    ["ivy9"] = 8,
}

function SheetInfo:getSheet()
    return self.sheet;
end

function SheetInfo:getFrameIndex(name)
    return self.frameIndex[name];
end

return SheetInfo
