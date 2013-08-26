--
-- created with TexturePacker (http://www.codeandweb.com/texturepacker)
--
-- $TexturePacker:SmartUpdate:579ea7b0207ba5f3c43065a4e3be22be:1/1$
--
-- local Tiles = require("mysheet")
-- local myImageSheet = graphics.newImageSheet( "mysheet.png", Tiles:getSheet() )
-- local sprite = display.newSprite( myImageSheet , {frames={Tiles:getFrameIndex("sprite")}} )
--

local Tiles = {}

Tiles.sheet =
{
    frames = {
    
        {
            -- box
            x=213,
            y=224,
            width=35,
            height=35,

        },
        {
            -- boxAlt
            x=213,
            y=187,
            width=35,
            height=35,

        },
        {
            -- boxCoin
            x=213,
            y=150,
            width=35,
            height=35,

        },
        {
            -- boxCoinAlt
            x=213,
            y=113,
            width=35,
            height=35,

        },
        {
            -- boxCoinAlt_disabled
            x=213,
            y=76,
            width=35,
            height=35,

        },
        {
            -- boxCoin_disabled
            x=213,
            y=39,
            width=35,
            height=35,

        },
        {
            -- boxEmpty
            x=213,
            y=2,
            width=35,
            height=35,

        },
        {
            -- boxItem
            x=187,
            y=446,
            width=35,
            height=35,

        },
        {
            -- boxItemAlt
            x=187,
            y=409,
            width=35,
            height=35,

        },
        {
            -- boxItemAlt_disabled
            x=187,
            y=372,
            width=35,
            height=35,

        },
        {
            -- boxItem_disabled
            x=187,
            y=335,
            width=35,
            height=35,

        },
        {
            -- boxWarning
            x=187,
            y=298,
            width=35,
            height=35,

        },
        {
            -- brickWall
            x=187,
            y=261,
            width=35,
            height=35,

        },
        {
            -- bridge
            x=372,
            y=24,
            width=35,
            height=10,

            sourceX = 0,
            sourceY = 25,
            sourceWidth = 35,
            sourceHeight = 35
        },
        {
            -- bridgeLogs
            x=335,
            y=24,
            width=35,
            height=13,

            sourceX = 0,
            sourceY = 22,
            sourceWidth = 35,
            sourceHeight = 35
        },
        {
            -- door_closedMid
            x=176,
            y=224,
            width=35,
            height=35,

        },
        {
            -- door_closedTop
            x=298,
            y=24,
            width=35,
            height=20,

            sourceX = 0,
            sourceY = 15,
            sourceWidth = 35,
            sourceHeight = 35
        },
        {
            -- door_openMid
            x=176,
            y=187,
            width=35,
            height=35,

        },
        {
            -- door_openTop
            x=261,
            y=24,
            width=35,
            height=20,

            sourceX = 0,
            sourceY = 15,
            sourceWidth = 35,
            sourceHeight = 35
        },
        {
            -- fence
            x=224,
            y=294,
            width=35,
            height=31,

            sourceX = 0,
            sourceY = 4,
            sourceWidth = 35,
            sourceHeight = 35
        },
        {
            -- fenceBroken
            x=224,
            y=261,
            width=35,
            height=31,

            sourceX = 0,
            sourceY = 4,
            sourceWidth = 35,
            sourceHeight = 35
        },
        {
            -- grass
            x=176,
            y=150,
            width=35,
            height=35,

        },
        {
            -- grassCenter
            x=176,
            y=113,
            width=35,
            height=35,

        },
        {
            -- grassCenter_rounded
            x=176,
            y=76,
            width=35,
            height=35,

        },
        {
            -- grassCliffLeft
            x=176,
            y=39,
            width=35,
            height=35,

        },
        {
            -- grassCliffLeftAlt
            x=176,
            y=2,
            width=35,
            height=35,

        },
        {
            -- grassCliffRight
            x=150,
            y=446,
            width=35,
            height=35,

        },
        {
            -- grassCliffRightAlt
            x=150,
            y=409,
            width=35,
            height=35,

        },
        {
            -- grassHalf
            x=446,
            y=2,
            width=35,
            height=20,

            sourceX = 0,
            sourceY = 0,
            sourceWidth = 35,
            sourceHeight = 35
        },
        {
            -- grassHalfLeft
            x=409,
            y=2,
            width=35,
            height=20,

            sourceX = 0,
            sourceY = 0,
            sourceWidth = 35,
            sourceHeight = 35
        },
        {
            -- grassHalfMid
            x=372,
            y=2,
            width=35,
            height=20,

            sourceX = 0,
            sourceY = 0,
            sourceWidth = 35,
            sourceHeight = 35
        },
        {
            -- grassHalfRight
            x=335,
            y=2,
            width=35,
            height=20,

            sourceX = 0,
            sourceY = 0,
            sourceWidth = 35,
            sourceHeight = 35
        },
        {
            -- grassHillLeft
            x=150,
            y=372,
            width=35,
            height=35,

        },
        {
            -- grassHillLeft2
            x=150,
            y=335,
            width=35,
            height=35,

        },
        {
            -- grassHillRight
            x=150,
            y=298,
            width=35,
            height=35,

        },
        {
            -- grassHillRight2
            x=150,
            y=261,
            width=35,
            height=35,

        },
        {
            -- grassLeft
            x=139,
            y=224,
            width=35,
            height=35,

        },
        {
            -- grassMid
            x=139,
            y=187,
            width=35,
            height=35,

        },
        {
            -- grassRight
            x=139,
            y=150,
            width=35,
            height=35,

        },
        {
            -- hill_large
            x=2,
            y=77,
            width=24,
            height=73,

        },
        {
            -- hill_largeAlt
            x=2,
            y=2,
            width=24,
            height=73,

        },
        {
            -- hill_small
            x=2,
            y=207,
            width=24,
            height=53,

        },
        {
            -- hill_smallAlt
            x=2,
            y=152,
            width=24,
            height=53,

        },
        {
            -- ladder_mid
            x=139,
            y=113,
            width=35,
            height=35,

        },
        {
            -- ladder_top
            x=139,
            y=76,
            width=35,
            height=35,

        },
        {
            -- liquidLava
            x=139,
            y=39,
            width=35,
            height=35,

        },
        {
            -- liquidLavaTop
            x=113,
            y=483,
            width=35,
            height=23,

            sourceX = 0,
            sourceY = 12,
            sourceWidth = 35,
            sourceHeight = 35
        },
        {
            -- liquidLavaTop_mid
            x=76,
            y=483,
            width=35,
            height=23,

            sourceX = 0,
            sourceY = 12,
            sourceWidth = 35,
            sourceHeight = 35
        },
        {
            -- liquidWater
            x=139,
            y=2,
            width=35,
            height=35,

        },
        {
            -- liquidWaterTop
            x=39,
            y=483,
            width=35,
            height=23,

            sourceX = 0,
            sourceY = 12,
            sourceWidth = 35,
            sourceHeight = 35
        },
        {
            -- liquidWaterTop_mid
            x=2,
            y=484,
            width=35,
            height=23,

            sourceX = 0,
            sourceY = 12,
            sourceWidth = 35,
            sourceHeight = 35
        },
        {
            -- lock_blue
            x=113,
            y=446,
            width=35,
            height=35,

        },
        {
            -- lock_green
            x=113,
            y=409,
            width=35,
            height=35,

        },
        {
            -- lock_red
            x=113,
            y=372,
            width=35,
            height=35,

        },
        {
            -- lock_yellow
            x=113,
            y=335,
            width=35,
            height=35,

        },
        {
            -- rockHillLeft
            x=113,
            y=298,
            width=35,
            height=35,

        },
        {
            -- rockHillRight
            x=113,
            y=261,
            width=35,
            height=35,

        },
        {
            -- sand
            x=102,
            y=224,
            width=35,
            height=35,

        },
        {
            -- sandCenter
            x=176,
            y=113,
            width=35,
            height=35,

        },
        {
            -- sandCenter_rounded
            x=176,
            y=76,
            width=35,
            height=35,

        },
        {
            -- sandCliffLeft
            x=102,
            y=187,
            width=35,
            height=35,

        },
        {
            -- sandCliffLeftAlt
            x=102,
            y=150,
            width=35,
            height=35,

        },
        {
            -- sandCliffRight
            x=102,
            y=113,
            width=35,
            height=35,

        },
        {
            -- sandCliffRightAlt
            x=102,
            y=76,
            width=35,
            height=35,

        },
        {
            -- sandHalf
            x=224,
            y=442,
            width=35,
            height=21,

            sourceX = 0,
            sourceY = 0,
            sourceWidth = 35,
            sourceHeight = 35
        },
        {
            -- sandHalfLeft
            x=224,
            y=419,
            width=35,
            height=21,

            sourceX = 0,
            sourceY = 0,
            sourceWidth = 35,
            sourceHeight = 35
        },
        {
            -- sandHalfMid
            x=224,
            y=396,
            width=35,
            height=21,

            sourceX = 0,
            sourceY = 0,
            sourceWidth = 35,
            sourceHeight = 35
        },
        {
            -- sandHalfRight
            x=224,
            y=373,
            width=35,
            height=21,

            sourceX = 0,
            sourceY = 0,
            sourceWidth = 35,
            sourceHeight = 35
        },
        {
            -- sandHillLeft
            x=102,
            y=39,
            width=35,
            height=35,

        },
        {
            -- sandHillLeft2
            x=102,
            y=2,
            width=35,
            height=35,

        },
        {
            -- sandHillRight
            x=76,
            y=446,
            width=35,
            height=35,

        },
        {
            -- sandHillRight2
            x=76,
            y=409,
            width=35,
            height=35,

        },
        {
            -- sandLeft
            x=76,
            y=372,
            width=35,
            height=35,

        },
        {
            -- sandMid
            x=76,
            y=335,
            width=35,
            height=35,

        },
        {
            -- sandRight
            x=76,
            y=298,
            width=35,
            height=35,

        },
        {
            -- snow
            x=76,
            y=261,
            width=35,
            height=35,

        },
        {
            -- snowCenter
            x=65,
            y=224,
            width=35,
            height=35,

        },
        {
            -- snowCenter_rounded
            x=65,
            y=187,
            width=35,
            height=35,

        },
        {
            -- snowCliffLeft
            x=65,
            y=150,
            width=35,
            height=35,

        },
        {
            -- snowCliffLeftAlt
            x=65,
            y=113,
            width=35,
            height=35,

        },
        {
            -- snowCliffRight
            x=65,
            y=76,
            width=35,
            height=35,

        },
        {
            -- snowCliffRightAlt
            x=65,
            y=39,
            width=35,
            height=35,

        },
        {
            -- snowHalf
            x=224,
            y=350,
            width=35,
            height=21,

            sourceX = 0,
            sourceY = 0,
            sourceWidth = 35,
            sourceHeight = 35
        },
        {
            -- snowHalfLeft
            x=224,
            y=327,
            width=35,
            height=21,

            sourceX = 0,
            sourceY = 0,
            sourceWidth = 35,
            sourceHeight = 35
        },
        {
            -- snowHalfMid
            x=187,
            y=483,
            width=35,
            height=21,

            sourceX = 0,
            sourceY = 0,
            sourceWidth = 35,
            sourceHeight = 35
        },
        {
            -- snowHalfRight
            x=150,
            y=483,
            width=35,
            height=21,

            sourceX = 0,
            sourceY = 0,
            sourceWidth = 35,
            sourceHeight = 35
        },
        {
            -- snowHillLeft
            x=65,
            y=2,
            width=35,
            height=35,

        },
        {
            -- snowHillLeft2
            x=39,
            y=446,
            width=35,
            height=35,

        },
        {
            -- snowHillRight
            x=39,
            y=409,
            width=35,
            height=35,

        },
        {
            -- snowHillRight2
            x=39,
            y=372,
            width=35,
            height=35,

        },
        {
            -- snowLeft
            x=39,
            y=335,
            width=35,
            height=35,

        },
        {
            -- snowMid
            x=39,
            y=298,
            width=35,
            height=35,

        },
        {
            -- snowRight
            x=39,
            y=261,
            width=35,
            height=35,

        },
        {
            -- stone
            x=28,
            y=224,
            width=35,
            height=35,

        },
        {
            -- stoneCenter
            x=28,
            y=187,
            width=35,
            height=35,

        },
        {
            -- stoneCenter_rounded
            x=28,
            y=150,
            width=35,
            height=35,

        },
        {
            -- stoneCliffLeft
            x=28,
            y=113,
            width=35,
            height=35,

        },
        {
            -- stoneCliffLeftAlt
            x=28,
            y=76,
            width=35,
            height=35,

        },
        {
            -- stoneCliffRight
            x=28,
            y=39,
            width=35,
            height=35,

        },
        {
            -- stoneCliffRightAlt
            x=28,
            y=2,
            width=35,
            height=35,

        },
        {
            -- stoneHalf
            x=298,
            y=2,
            width=35,
            height=20,

            sourceX = 0,
            sourceY = 0,
            sourceWidth = 35,
            sourceHeight = 35
        },
        {
            -- stoneHalfLeft
            x=261,
            y=2,
            width=35,
            height=20,

            sourceX = 0,
            sourceY = 0,
            sourceWidth = 35,
            sourceHeight = 35
        },
        {
            -- stoneHalfMid
            x=224,
            y=487,
            width=35,
            height=20,

            sourceX = 0,
            sourceY = 0,
            sourceWidth = 35,
            sourceHeight = 35
        },
        {
            -- stoneHalfRight
            x=224,
            y=465,
            width=35,
            height=20,

            sourceX = 0,
            sourceY = 0,
            sourceWidth = 35,
            sourceHeight = 35
        },
        {
            -- stoneHillLeft2
            x=2,
            y=447,
            width=35,
            height=35,

        },
        {
            -- stoneHillRight2
            x=2,
            y=410,
            width=35,
            height=35,

        },
        {
            -- stoneLeft
            x=2,
            y=373,
            width=35,
            height=35,

        },
        {
            -- stoneMid
            x=2,
            y=336,
            width=35,
            height=35,

        },
        {
            -- stoneRight
            x=2,
            y=299,
            width=35,
            height=35,

        },
        {
            -- stoneWall
            x=2,
            y=262,
            width=35,
            height=35,

        },
    },
    
    sheetContentWidth = 512,
    sheetContentHeight = 512
}

Tiles.frameIndex =
{

    ["box"] = 1,
    ["boxAlt"] = 2,
    ["boxCoin"] = 3,
    ["boxCoinAlt"] = 4,
    ["boxCoinAlt_disabled"] = 5,
    ["boxCoin_disabled"] = 6,
    ["boxEmpty"] = 7,
    ["boxItem"] = 8,
    ["boxItemAlt"] = 9,
    ["boxItemAlt_disabled"] = 10,
    ["boxItem_disabled"] = 11,
    ["boxWarning"] = 12,
    ["brickWall"] = 13,
    ["bridge"] = 14,
    ["bridgeLogs"] = 15,
    ["door_closedMid"] = 16,
    ["door_closedTop"] = 17,
    ["door_openMid"] = 18,
    ["door_openTop"] = 19,
    ["fence"] = 20,
    ["fenceBroken"] = 21,
    ["grass"] = 22,
    ["grassCenter"] = 23,
    ["grassCenter_rounded"] = 24,
    ["grassCliffLeft"] = 25,
    ["grassCliffLeftAlt"] = 26,
    ["grassCliffRight"] = 27,
    ["grassCliffRightAlt"] = 28,
    ["grassHalf"] = 29,
    ["grassHalfLeft"] = 30,
    ["grassHalfMid"] = 31,
    ["grassHalfRight"] = 32,
    ["grassHillLeft"] = 33,
    ["grassHillLeft2"] = 34,
    ["grassHillRight"] = 35,
    ["grassHillRight2"] = 36,
    ["grassLeft"] = 37,
    ["grassMid"] = 38,
    ["grassRight"] = 39,
    ["hill_large"] = 40,
    ["hill_largeAlt"] = 41,
    ["hill_small"] = 42,
    ["hill_smallAlt"] = 43,
    ["ladder_mid"] = 44,
    ["ladder_top"] = 45,
    ["liquidLava"] = 46,
    ["liquidLavaTop"] = 47,
    ["liquidLavaTop_mid"] = 48,
    ["liquidWater"] = 49,
    ["liquidWaterTop"] = 50,
    ["liquidWaterTop_mid"] = 51,
    ["lock_blue"] = 52,
    ["lock_green"] = 53,
    ["lock_red"] = 54,
    ["lock_yellow"] = 55,
    ["rockHillLeft"] = 56,
    ["rockHillRight"] = 57,
    ["sand"] = 58,
    ["sandCenter"] = 59,
    ["sandCenter_rounded"] = 60,
    ["sandCliffLeft"] = 61,
    ["sandCliffLeftAlt"] = 62,
    ["sandCliffRight"] = 63,
    ["sandCliffRightAlt"] = 64,
    ["sandHalf"] = 65,
    ["sandHalfLeft"] = 66,
    ["sandHalfMid"] = 67,
    ["sandHalfRight"] = 68,
    ["sandHillLeft"] = 69,
    ["sandHillLeft2"] = 70,
    ["sandHillRight"] = 71,
    ["sandHillRight2"] = 72,
    ["sandLeft"] = 73,
    ["sandMid"] = 74,
    ["sandRight"] = 75,
    ["snow"] = 76,
    ["snowCenter"] = 77,
    ["snowCenter_rounded"] = 78,
    ["snowCliffLeft"] = 79,
    ["snowCliffLeftAlt"] = 80,
    ["snowCliffRight"] = 81,
    ["snowCliffRightAlt"] = 82,
    ["snowHalf"] = 83,
    ["snowHalfLeft"] = 84,
    ["snowHalfMid"] = 85,
    ["snowHalfRight"] = 86,
    ["snowHillLeft"] = 87,
    ["snowHillLeft2"] = 88,
    ["snowHillRight"] = 89,
    ["snowHillRight2"] = 90,
    ["snowLeft"] = 91,
    ["snowMid"] = 92,
    ["snowRight"] = 93,
    ["stone"] = 94,
    ["stoneCenter"] = 95,
    ["stoneCenter_rounded"] = 96,
    ["stoneCliffLeft"] = 97,
    ["stoneCliffLeftAlt"] = 98,
    ["stoneCliffRight"] = 99,
    ["stoneCliffRightAlt"] = 100,
    ["stoneHalf"] = 101,
    ["stoneHalfLeft"] = 102,
    ["stoneHalfMid"] = 103,
    ["stoneHalfRight"] = 104,
    ["stoneHillLeft2"] = 105,
    ["stoneHillRight2"] = 106,
    ["stoneLeft"] = 107,
    ["stoneMid"] = 108,
    ["stoneRight"] = 109,
    ["stoneWall"] = 110,
}

function Tiles:getSheet()
    return self.sheet;
end

function Tiles:getFrameIndex(name)
    return self.frameIndex[name];
end

return Tiles
