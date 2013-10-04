--
-- created with TexturePacker (http://www.codeandweb.com/texturepacker)
--
-- $TexturePacker:SmartUpdate:f28e77b3040d0558af5f51b34ae3a1e2:1/1$
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
            -- 1-boxEmpty
            x=2,
            y=76,
            width=104,
            height=35,

        },
        {
            -- 2-bigGrass
            x=2,
            y=2,
            width=210,
            height=35,

        },
        {
            -- 3-boxCoin
            x=2,
            y=39,
            width=105,
            height=35,

        },
    },
    
    sheetContentWidth = 256,
    sheetContentHeight = 128
}

SheetInfo.frameIndex =
{

    ["1-boxEmpty"] = 1,
    ["2-bigGrass"] = 2,
    ["3-boxCoin"] = 3,
}

function SheetInfo:getSheet()
    return self.sheet;
end

function SheetInfo:getFrameIndex(name)
    return self.frameIndex[name];
end

return SheetInfo
