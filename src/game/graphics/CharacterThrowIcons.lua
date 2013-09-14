--
-- created with TexturePacker (http://www.codeandweb.com/texturepacker)
--
-- $TexturePacker:SmartUpdate:8d6d4f2d2acc6cb2b7938bc4554e22aa:1/1$
--
-- local CharacterThrowIcons = require("mysheet")
-- local myImageSheet = graphics.newImageSheet( "mysheet.png", CharacterThrowIcons:getSheet() )
-- local sprite = display.newSprite( myImageSheet , {frames={CharacterThrowIcons:getFrameIndex("sprite")}} )
--

local CharacterThrowIcons = {}

CharacterThrowIcons.sequence = {
	{ 
		name = "seq",  --name of animation sequence
		start = 1,  --starting frame index
		count = 2,  --total number of frames to animate consecutively before stopping or looping
		time = 1000,  --optional, in milliseconds; if not supplied, the sprite is frame-based
		loopCount = 0,  --optional. 0 (default) repeats forever; a positive integer specifies the number of loops
		loopDirection = "forward"  --optional, either "forward" (default) or "bounce" which will play forward then backwards through the sequence of frames
	}  --if defining more sequences, place a comma here and proceed to the next sequence sub-table
}

CharacterThrowIcons.sheet =
{
    frames = {
    
        {
            -- character.throwFire
            x=2,
            y=88,
            width=84,
            height=84,

            sourceX = 2,
            sourceY = 2,
            sourceWidth = 86,
            sourceHeight = 86
        },
        {
            -- character.throwGrab
            x=2,
            y=2,
            width=84,
            height=84,

            sourceX = 2,
            sourceY = 2,
            sourceWidth = 86,
            sourceHeight = 86
        },
    },
    
    sheetContentWidth = 128,
    sheetContentHeight = 256
}

CharacterThrowIcons.frameIndex =
{
    ["character.throwFire"] = 1,
    ["character.throwGrab"] = 2,
}

function CharacterThrowIcons:getSheet()
    return self.sheet;
end

function CharacterThrowIcons:getFrameIndex(name)
    return self.frameIndex[name];
end

return CharacterThrowIcons
