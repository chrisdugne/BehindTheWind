--
-- created with TexturePacker (http://www.codeandweb.com/texturepacker)
--
-- $TexturePacker:SmartUpdate:8d66ee0e9ab28eda3f92824f288cdd2c:1/1$
--
-- local Line = require("mysheet")
-- local myImageSheet = graphics.newImageSheet( "mysheet.png", Line:getSheet() )
-- local sprite = display.newSprite( myImageSheet , {frames={Line:getFrameIndex("sprite")}} )
--

local Line = {}

Line.sheet =
{
    frames = {
        {
            -- line1
            x=154,
            y=38,
            width=68,
            height=15,

            sourceX = 0,
            sourceY = 4,
            sourceWidth = 150,
            sourceHeight = 19
        },
        {
            -- line2
            x=154,
            y=21,
            width=68,
            height=15,

            sourceX = 0,
            sourceY = 4,
            sourceWidth = 150,
            sourceHeight = 19
        },
        {
            -- line3
            x=154,
            y=2,
            width=78,
            height=17,

            sourceX = 0,
            sourceY = 2,
            sourceWidth = 150,
            sourceHeight = 19
        },
        {
            -- line4
            x=148,
            y=55,
            width=102,
            height=17,

            sourceX = 0,
            sourceY = 2,
            sourceWidth = 150,
            sourceHeight = 19
        },
        {
            -- line5
            x=138,
            y=74,
            width=112,
            height=19,

            sourceX = 0,
            sourceY = 0,
            sourceWidth = 150,
            sourceHeight = 19
        },
        {
            -- line6
            x=2,
            y=86,
            width=128,
            height=19,

            sourceX = 0,
            sourceY = 0,
            sourceWidth = 150,
            sourceHeight = 19
        },
        {
            -- line7
            x=2,
            y=65,
            width=134,
            height=19,

            sourceX = 0,
            sourceY = 0,
            sourceWidth = 150,
            sourceHeight = 19
        },
        {
            -- line8
            x=2,
            y=44,
            width=144,
            height=19,

            sourceX = 0,
            sourceY = 0,
            sourceWidth = 150,
            sourceHeight = 19
        },
        {
            -- line9
            x=2,
            y=2,
            width=150,
            height=19,

        },
        {
            -- line10
            x=2,
            y=23,
            width=150,
            height=19,

        },
    },
    
    sheetContentWidth = 256,
    sheetContentHeight = 128
}

Line.frameIndex =
{
    ["line1"]     = 1,
    ["line2"]     = 2,
    ["line3"]     = 3,
    ["line4"]     = 4,
    ["line5"]     = 5,
    ["line6"]     = 6,
    ["line7"]     = 7,
    ["line8"]     = 8,
    ["line9"]     = 9,
    ["line10"] = 10,
}

function Line:newSequence()
    return { 
           name = "turn",  --name of animation sequence
           start = 1,  --starting frame index
           count = 10,  --total number of frames to animate consecutively before stopping or looping
           time = 300,  --optional, in milliseconds; if not supplied, the sprite is frame-based
           loopCount = 1,  --optional. 0 (default) repeats forever; a positive integer specifies the number of loops
           loopDirection = "forward"  --optional, either "forward" (default) or "bounce" which will play forward then backwards through the sequence of frames
       }  --if defining more sequences, place a comma here and proceed to the next sequence sub-table
end

function Line:getSheet()
    return self.sheet;
end

function Line:getFrameIndex(name)
    return self.frameIndex[name];
end

return Line
