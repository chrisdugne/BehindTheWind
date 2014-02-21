--
-- created with TexturePacker (http://www.codeandweb.com/texturepacker)
--
-- $TexturePacker:SmartUpdate:bae9d597a053e5cb7cc251b7f6830564:1/1$
--
-- local Piece = require("mysheet")
-- local myImageSheet = graphics.newImageSheet( "mysheet.png", Piece:getSheet() )
-- local sprite = display.newSprite( myImageSheet , {frames={Piece:getFrameIndex("sprite")}} )
--

local Piece = {}

Piece.sheet =
{
    frames = {
    
        {
            -- powerpiece powerup
            x=36,
            y=138,
            width=32,
            height=32,

        },
        {
            -- powerpiece powerup1
            x=2,
            y=206,
            width=32,
            height=32,

        },
        {
            -- powerpiece powerup2
            x=36,
            y=70,
            width=32,
            height=32,

        },
        {
            -- powerpiece powerup3
            x=2,
            y=70,
            width=32,
            height=32,

        },
        {
            -- powerpiece powerup4
            x=70,
            y=36,
            width=32,
            height=32,

        },
        {
            -- powerpiece powerup5
            x=36,
            y=36,
            width=32,
            height=32,

        },
        {
            -- powerpiece powerup6
            x=2,
            y=36,
            width=32,
            height=32,

        },
        {
            -- powerpiece powerup7
            x=70,
            y=2,
            width=32,
            height=32,

        },
        {
            -- powerpiece powerup8
            x=36,
            y=2,
            width=32,
            height=32,

        },
        {
            -- powerpiece powerup9
            x=2,
            y=2,
            width=32,
            height=32,

        },
        {
            -- powerpiece powerup10
            x=2,
            y=172,
            width=32,
            height=32,

        },
        {
            -- powerpiece powerup11
            x=2,
            y=138,
            width=32,
            height=32,

        },
        {
            -- powerpiece powerup12
            x=70,
            y=104,
            width=32,
            height=32,

        },
        {
            -- powerpiece powerup13
            x=36,
            y=104,
            width=32,
            height=32,

        },
        {
            -- powerpiece powerup14
            x=2,
            y=104,
            width=32,
            height=32,

        },
        {
            -- powerpiece powerup15
            x=70,
            y=70,
            width=32,
            height=32,

        },
    },
    
    sheetContentWidth = 128,
    sheetContentHeight = 256
}

Piece.frameIndex =
{
    ["powerpiece powerup"] = 1,
    ["powerpiece powerup1"] = 2,
    ["powerpiece powerup10"] = 3,
    ["powerpiece powerup11"] = 4,
    ["powerpiece powerup12"] = 5,
    ["powerpiece powerup13"] = 6,
    ["powerpiece powerup14"] = 7,
    ["powerpiece powerup15"] = 8,
    ["powerpiece powerup2"] = 9,
    ["powerpiece powerup3"] = 10,
    ["powerpiece powerup4"] = 11,
    ["powerpiece powerup5"] = 12,
    ["powerpiece powerup6"] = 13,
    ["powerpiece powerup7"] = 14,
    ["powerpiece powerup8"] = 15,
    ["powerpiece powerup9"] = 16,
}

function Piece:newSequence()
    return { 
           name = "turn",  --name of animation sequence
           start = 1,  --starting frame index
           count = 16,  --total number of frames to animate consecutively before stopping or looping
           time = math.random(800,1200),  --optional, in milliseconds; if not supplied, the sprite is frame-based
           loopCount = 0,  --optional. 0 (default) repeats forever; a positive integer specifies the number of loops
           loopDirection = "forward"  --optional, either "forward" (default) or "bounce" which will play forward then backwards through the sequence of frames
       }  --if defining more sequences, place a comma here and proceed to the next sequence sub-table
end

function Piece:getSheet()
    return self.sheet;
end

function Piece:getFrameIndex(name)
    return self.frameIndex[name];
end

return Piece
