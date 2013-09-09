--
-- created with TexturePacker (http://www.codeandweb.com/texturepacker)
--
-- $TexturePacker:SmartUpdate:95af9e4dbfc739fc516428d05559ac02:1/1$
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
            -- character.jump.1
            x=2,
            y=2,
            width=64,
            height=64,

        },
        {
            -- character.simple
            x=2,
            y=68,
            width=63,
            height=63,

        },
        {
            -- panel.exit
            x=2,
            y=133,
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
    },
    
    sheetContentWidth = 128,
    sheetContentHeight = 256
}

SheetInfo.frameIndex =
{

    ["character.jump.1"] = 1,
    ["character.simple"] = 2,
    ["panel.exit"] = 3,
    ["panel.finger"] = 4,
}

function SheetInfo:getSheet()
    return self.sheet;
end

function SheetInfo:getFrameIndex(name)
    return self.frameIndex[name];
end

return SheetInfo
