--
-- created with TexturePacker (http://www.codeandweb.com/texturepacker)
--
-- $TexturePacker:SmartUpdate:a5e3a502211fe9e869f45a3e403f5318:1/1$
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
            -- ivy2.stretch
            x=284,
            y=1046,
            width=280,
            height=520,

        },
        {
            -- ivy3.stretch
            x=2,
            y=1046,
            width=280,
            height=520,

        },
        {
            -- ivy4.stretch
            x=566,
            y=524,
            width=280,
            height=520,

        },
        {
            -- ivy5.stretch
            x=284,
            y=524,
            width=280,
            height=520,

        },
        {
            -- ivy6.stretch
            x=2,
            y=524,
            width=280,
            height=520,

        },
        {
            -- ivy7.stretch
            x=566,
            y=2,
            width=280,
            height=520,

        },
        {
            -- ivy8.stretch
            x=284,
            y=2,
            width=280,
            height=520,

        },
        {
            -- ivy9.stretch
            x=2,
            y=2,
            width=280,
            height=520,

        },
    },
    
    sheetContentWidth = 1024,
    sheetContentHeight = 2048
}

SheetInfo.frameIndex =
{

    ["ivy2.stretch"] = 1,
    ["ivy3.stretch"] = 2,
    ["ivy4.stretch"] = 3,
    ["ivy5.stretch"] = 4,
    ["ivy6.stretch"] = 5,
    ["ivy7.stretch"] = 6,
    ["ivy8.stretch"] = 7,
    ["ivy9.stretch"] = 8,
}

function SheetInfo:getSheet()
    return self.sheet;
end

function SheetInfo:getFrameIndex(name)
    return self.frameIndex[name];
end

return SheetInfo
