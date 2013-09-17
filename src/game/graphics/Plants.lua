--
-- created with TexturePacker (http://www.codeandweb.com/texturepacker)
--
-- $TexturePacker:SmartUpdate:294c42ae9d8f16c6e204c74ab8ac87e6:1/1$
--
-- local Plants = require("mysheet")
-- local myImageSheet = graphics.newImageSheet( "mysheet.png", Plants:getSheet() )
-- local sprite = display.newSprite( myImageSheet , {frames={Plants:getFrameIndex("sprite")}} )
--

local Plants = {}

Plants.sheet =
{
    frames = {
    
        {
            -- flowers1.darkblack
            x=50,
            y=194,
            width=40,
            height=48,

            sourceX = 4,
            sourceY = 2,
            sourceWidth = 50,
            sourceHeight = 50
        },
        {
            -- flowers1.darkpink
            x=44,
            y=144,
            width=40,
            height=48,

            sourceX = 4,
            sourceY = 2,
            sourceWidth = 50,
            sourceHeight = 50
        },
        {
            -- flowers1
            x=44,
            y=94,
            width=40,
            height=48,

            sourceX = 4,
            sourceY = 2,
            sourceWidth = 50,
            sourceHeight = 50
        },
        {
            -- flowers1.silhouette
            x=44,
            y=44,
            width=40,
            height=48,

            sourceX = 4,
            sourceY = 2,
            sourceWidth = 50,
            sourceHeight = 50
        },
        {
            -- flowers2.darkblack
            x=2,
            y=158,
            width=40,
            height=50,

            sourceX = 4,
            sourceY = 0,
            sourceWidth = 50,
            sourceHeight = 50
        },
        {
            -- flowers2.darkpink
            x=2,
            y=106,
            width=40,
            height=50,

            sourceX = 4,
            sourceY = 0,
            sourceWidth = 50,
            sourceHeight = 50
        },
        {
            -- flowers2
            x=2,
            y=54,
            width=40,
            height=50,

            sourceX = 4,
            sourceY = 0,
            sourceWidth = 50,
            sourceHeight = 50
        },
        {
            -- flowers2.silhouette
            x=2,
            y=2,
            width=40,
            height=50,

            sourceX = 4,
            sourceY = 0,
            sourceWidth = 50,
            sourceHeight = 50
        },
        {
            -- grass1.darkblack
            x=86,
            y=132,
            width=46,
            height=42,

            sourceX = 2,
            sourceY = 8,
            sourceWidth = 50,
            sourceHeight = 50
        },
        {
            -- grass1.darkpink
            x=86,
            y=88,
            width=46,
            height=42,

            sourceX = 2,
            sourceY = 8,
            sourceWidth = 50,
            sourceHeight = 50
        },
        {
            -- grass1
            x=86,
            y=44,
            width=46,
            height=42,

            sourceX = 2,
            sourceY = 8,
            sourceWidth = 50,
            sourceHeight = 50
        },
        {
            -- grass1.silhouette
            x=2,
            y=210,
            width=46,
            height=42,

            sourceX = 2,
            sourceY = 8,
            sourceWidth = 50,
            sourceHeight = 50
        },
        {
            -- grass2.darkblack
            x=200,
            y=2,
            width=48,
            height=40,

            sourceX = 1,
            sourceY = 10,
            sourceWidth = 50,
            sourceHeight = 50
        },
        {
            -- grass2.darkpink
            x=150,
            y=2,
            width=48,
            height=40,

            sourceX = 1,
            sourceY = 10,
            sourceWidth = 50,
            sourceHeight = 50
        },
        {
            -- grass2
            x=100,
            y=2,
            width=48,
            height=40,

            sourceX = 1,
            sourceY = 10,
            sourceWidth = 50,
            sourceHeight = 50
        },
        {
            -- grass2.silhouette
            x=50,
            y=2,
            width=48,
            height=40,

            sourceX = 1,
            sourceY = 10,
            sourceWidth = 50,
            sourceHeight = 50
        },
    },
    
    sheetContentWidth = 256,
    sheetContentHeight = 256
}

Plants.frameIndex =
{

    ["flowers1.darkblack"] = 1,
    ["flowers1.darkpink"] = 2,
    ["flowers1"] = 3,
    ["flowers1.silhouette"] = 4,
    ["flowers2.darkblack"] = 5,
    ["flowers2.darkpink"] = 6,
    ["flowers2"] = 7,
    ["flowers2.silhouette"] = 8,
    ["grass1.darkblack"] = 9,
    ["grass1.darkpink"] = 10,
    ["grass1"] = 11,
    ["grass1.silhouette"] = 12,
    ["grass2.darkblack"] = 13,
    ["grass2.darkpink"] = 14,
    ["grass2"] = 15,
    ["grass2.silhouette"] = 16,
}

function Plants:getSheet()
    return self.sheet;
end

function Plants:getFrameIndex(name)
    return self.frameIndex[name];
end

return Plants
