--
-- created with TexturePacker (http://www.codeandweb.com/texturepacker)
--
-- $TexturePacker:SmartUpdate:edcdd0f466f76e14be1bc81978114528:1/1$
--
-- local Panels = require("mysheet")
-- local myImageSheet = graphics.newImageSheet( "mysheet.png", Panels:getSheet() )
-- local sprite = display.newSprite( myImageSheet , {frames={Panels:getFrameIndex("sprite")}} )
--

local Panels = {}

Panels.sheet =
{
    frames = {
    
        {
            -- panel.finger
            x=2,
            y=2,
            width=52,
            height=94,

        },
    },
    
    sheetContentWidth = 64,
    sheetContentHeight = 128
}

Panels.frameIndex =
{

    ["panel.finger"] = 1,
}

function Panels:getSheet()
    return self.sheet;
end

function Panels:getFrameIndex(name)
    return self.frameIndex[name];
end

return Panels
