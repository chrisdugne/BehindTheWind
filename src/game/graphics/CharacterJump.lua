--
-- created with TexturePacker (http://www.codeandweb.com/texturepacker)
--
-- $TexturePacker:SmartUpdate:6156402098066d4c708d43d5540765c4:1/1$
--
-- local CharacterJump = require("mysheet")
-- local myImageSheet = graphics.newImageSheet( "mysheet.png", CharacterJump:getSheet() )
-- local sprite = display.newSprite( myImageSheet , {frames={CharacterJump:getFrameIndex("sprite")}} )
--

local CharacterJump = {}

CharacterJump.sequence = {
	{ 
		name = "normalRun",  --name of animation sequence
		start = 1,  --starting frame index
		count = 6,  --total number of frames to animate consecutively before stopping or looping
		time = 1000,  --optional, in milliseconds; if not supplied, the sprite is frame-based
		loopCount = 0,  --optional. 0 (default) repeats forever; a positive integer specifies the number of loops
		loopDirection = "forward"  --optional, either "forward" (default) or "bounce" which will play forward then backwards through the sequence of frames
	}  --if defining more sequences, place a comma here and proceed to the next sequence sub-table
}

CharacterJump.sheet =
{
    frames = {
    
        {
            -- character.jump.1
            x=1,
            y=67,
            width=32,
            height=32,

        },
        {
            -- character.jump.2
            x=34,
            y=34,
            width=23,
            height=32,

        },
        {
            -- character.jump.3
            x=1,
            y=34,
            width=32,
            height=32,

        },
        {
            -- character.jump.4
            x=1,
            y=1,
            width=32,
            height=32,

        },
        {
            -- character.jump.5
            x=34,
            y=1,
            width=23,
            height=32,

        },
        {
            -- character.jump.6
            x=1,
            y=100,
            width=32,
            height=19,
   			sourceX = -8,
   			sourceY = 9,
   			sourceWidth = 1,
   			sourceHeight = 1
        },
    },
    
    sheetContentWidth = 64,
    sheetContentHeight = 128
}

CharacterJump.frameIndex =
{

    ["character.jump.1"] = 1,
    ["character.jump.2"] = 2,
    ["character.jump.3"] = 3,
    ["character.jump.4"] = 4,
    ["character.jump.5"] = 5,
    ["character.jump.6"] = 6,
}

function CharacterJump:getSheet()
    return self.sheet;
end

function CharacterJump:getFrameIndex(name)
    return self.frameIndex[name];
end

return CharacterJump
