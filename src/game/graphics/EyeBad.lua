--
-- created with TexturePacker (http://www.codeandweb.com/texturepacker)
--
-- $TexturePacker:SmartUpdate:4dfbc8b273a28be1bab1297958b22058:1/1$
--
-- local EyeBad = require("mysheet")
-- local myImageSheet = graphics.newImageSheet( "mysheet.png", EyeBad:getSheet() )
-- local sprite = display.newSprite( myImageSheet , {frames={EyeBad:getFrameIndex("sprite")}} )
--

local EyeBad = {}

EyeBad.sequence = {
    { 
        name = "normalRun",  --name of animation sequence
        start = 1,  --starting frame index
        count = 8,  --total number of frames to animate consecutively before stopping or looping
        time = 1000,  --optional, in milliseconds; if not supplied, the sprite is frame-based
        loopCount = 0,  --optional. 0 (default) repeats forever; a positive integer specifies the number of loops
        loopDirection = "forward"  --optional, either "forward" (default) or "bounce" which will play forward then backwards through the sequence of frames
    }  --if defining more sequences, place a comma here and proceed to the next sequence sub-table
}

EyeBad.sheet =
{
    frames = {
    
        {
            -- enemy.eye.1
            x=254,
            y=758,
            width=250,
            height=250,

            sourceX = 2,
            sourceY = 2,
            sourceWidth = 256,
            sourceHeight = 256
        },
        {
            -- enemy.eye.2
            x=2,
            y=758,
            width=250,
            height=250,

            sourceX = 2,
            sourceY = 2,
            sourceWidth = 256,
            sourceHeight = 256
        },
        {
            -- enemy.eye.3
            x=254,
            y=506,
            width=250,
            height=250,

            sourceX = 2,
            sourceY = 2,
            sourceWidth = 256,
            sourceHeight = 256
        },
        {
            -- enemy.eye.4
            x=2,
            y=506,
            width=250,
            height=250,

            sourceX = 2,
            sourceY = 2,
            sourceWidth = 256,
            sourceHeight = 256
        },
        {
            -- enemy.eye.5
            x=254,
            y=254,
            width=250,
            height=250,

            sourceX = 2,
            sourceY = 2,
            sourceWidth = 256,
            sourceHeight = 256
        },
        {
            -- enemy.eye.6
            x=2,
            y=254,
            width=250,
            height=250,

            sourceX = 2,
            sourceY = 2,
            sourceWidth = 256,
            sourceHeight = 256
        },
        {
            -- enemy.eye.7
            x=254,
            y=2,
            width=250,
            height=250,

            sourceX = 2,
            sourceY = 2,
            sourceWidth = 256,
            sourceHeight = 256
        },
        {
            -- enemy.eye.8
            x=2,
            y=2,
            width=250,
            height=250,

            sourceX = 2,
            sourceY = 2,
            sourceWidth = 256,
            sourceHeight = 256
        },
    },
    
    sheetContentWidth = 512,
    sheetContentHeight = 1024
}

EyeBad.frameIndex =
{

    ["enemy.eye.1"] = 1,
    ["enemy.eye.2"] = 2,
    ["enemy.eye.3"] = 3,
    ["enemy.eye.4"] = 4,
    ["enemy.eye.5"] = 5,
    ["enemy.eye.6"] = 6,
    ["enemy.eye.7"] = 7,
    ["enemy.eye.8"] = 8,
}

function EyeBad:getSheet()
    return self.sheet;
end

function EyeBad:getFrameIndex(name)
    return self.frameIndex[name];
end

return EyeBad
