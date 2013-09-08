--
-- created with TexturePacker (http://www.codeandweb.com/texturepacker)
--
-- $TexturePacker:SmartUpdate:9c9cac32aff349526dcd00dbc52fb7a9:1/1$
--
-- local Trees = require("mysheet")
-- local myImageSheet = graphics.newImageSheet( "mysheet.png", Trees:getSheet() )
-- local sprite = display.newSprite( myImageSheet , {frames={Trees:getFrameIndex("sprite")}} )
--

local Trees = {}

Trees.sheet =
{
    frames = {
    
        {
            -- bush.classic.green
            x=334,
            y=375,
            width=54,
            height=57,

            sourceX = 0,
            sourceY = 0,
            sourceWidth = 54,
            sourceHeight = 56
        },
        {
            -- bush.dark.black
            x=278,
            y=335,
            width=54,
            height=57,

            sourceX = 0,
            sourceY = 0,
            sourceWidth = 54,
            sourceHeight = 56
        },
        {
            -- bush.dark.pink
            x=437,
            y=325,
            width=54,
            height=57,

            sourceX = 0,
            sourceY = 0,
            sourceWidth = 54,
            sourceHeight = 56
        },
        {
            -- bush.dark.red
            x=381,
            y=316,
            width=54,
            height=57,

            sourceX = 0,
            sourceY = 0,
            sourceWidth = 54,
            sourceHeight = 56
        },
        {
            -- bush.silhouette
            x=437,
            y=266,
            width=54,
            height=57,

            sourceX = 0,
            sourceY = 0,
            sourceWidth = 54,
            sourceHeight = 56
        },
        {
            -- hugetree.classic.green
            x=126,
            y=2,
            width=122,
            height=124,

            sourceX = 4,
            sourceY = 4,
            sourceWidth = 128,
            sourceHeight = 128
        },
        {
            -- hugetree.dark.black
            x=2,
            y=380,
            width=122,
            height=124,

            sourceX = 4,
            sourceY = 4,
            sourceWidth = 128,
            sourceHeight = 128
        },
        {
            -- hugetree.dark.pink
            x=2,
            y=254,
            width=122,
            height=124,

            sourceX = 4,
            sourceY = 4,
            sourceWidth = 128,
            sourceHeight = 128
        },
        {
            -- hugetree.dark.red
            x=2,
            y=128,
            width=122,
            height=124,

            sourceX = 4,
            sourceY = 4,
            sourceWidth = 128,
            sourceHeight = 128
        },
        {
            -- hugetree.silhouette
            x=2,
            y=2,
            width=122,
            height=124,

            sourceX = 4,
            sourceY = 4,
            sourceWidth = 128,
            sourceHeight = 128
        },
        {
            -- mediumtree.classic.green
            x=202,
            y=384,
            width=74,
            height=83,

            sourceX = 0,
            sourceY = 0,
            sourceWidth = 74,
            sourceHeight = 83
        },
        {
            -- mediumtree.dark.black
            x=126,
            y=384,
            width=74,
            height=83,

            sourceX = 0,
            sourceY = 0,
            sourceWidth = 74,
            sourceHeight = 83
        },
        {
            -- mediumtree.dark.pink
            x=305,
            y=250,
            width=74,
            height=83,

            sourceX = 0,
            sourceY = 0,
            sourceWidth = 74,
            sourceHeight = 83
        },
        {
            -- mediumtree.dark.red
            x=126,
            y=252,
            width=74,
            height=83,

            sourceX = 0,
            sourceY = 0,
            sourceWidth = 74,
            sourceHeight = 83
        },
        {
            -- mediumtree.silhouette
            x=229,
            y=250,
            width=74,
            height=83,

            sourceX = 0,
            sourceY = 0,
            sourceWidth = 74,
            sourceHeight = 83
        },
        {
            -- smalltree.classic.green
            x=381,
            y=250,
            width=54,
            height=64,

            sourceX = 5,
            sourceY = 0,
            sourceWidth = 64,
            sourceHeight = 64
        },
        {
            -- smalltree.dark.black
            x=456,
            y=200,
            width=54,
            height=64,

            sourceX = 5,
            sourceY = 0,
            sourceWidth = 64,
            sourceHeight = 64
        },
        {
            -- smalltree.dark.pink
            x=456,
            y=134,
            width=54,
            height=64,

            sourceX = 5,
            sourceY = 0,
            sourceWidth = 64,
            sourceHeight = 64
        },
        {
            -- smalltree.dark.red
            x=456,
            y=68,
            width=54,
            height=64,

            sourceX = 5,
            sourceY = 0,
            sourceWidth = 64,
            sourceHeight = 64
        },
        {
            -- smalltree.silhouette
            x=456,
            y=2,
            width=54,
            height=64,

            sourceX = 5,
            sourceY = 0,
            sourceWidth = 64,
            sourceHeight = 64
        },
        {
            -- talltree.classic.green
            x=126,
            y=128,
            width=101,
            height=122,

            sourceX = 0,
            sourceY = 0,
            sourceWidth = 100,
            sourceHeight = 121
        },
        {
            -- talltree.dark.black
            x=353,
            y=126,
            width=101,
            height=122,

            sourceX = 0,
            sourceY = 0,
            sourceWidth = 100,
            sourceHeight = 121
        },
        {
            -- talltree.dark.pink
            x=250,
            y=126,
            width=101,
            height=122,

            sourceX = 0,
            sourceY = 0,
            sourceWidth = 100,
            sourceHeight = 121
        },
        {
            -- talltree.dark.red
            x=353,
            y=2,
            width=101,
            height=122,

            sourceX = 0,
            sourceY = 0,
            sourceWidth = 100,
            sourceHeight = 121
        },
        {
            -- talltree.silhouette
            x=250,
            y=2,
            width=101,
            height=122,

            sourceX = 0,
            sourceY = 0,
            sourceWidth = 100,
            sourceHeight = 121
        },
    },
    
    sheetContentWidth = 512,
    sheetContentHeight = 512
}

Trees.frameIndex =
{

    ["bush.classic.green"] = 1,
    ["bush.dark.black"] = 2,
    ["bush.dark.pink"] = 3,
    ["bush.dark.red"] = 4,
    ["bush.silhouette"] = 5,
    ["hugetree.classic.green"] = 6,
    ["hugetree.dark.black"] = 7,
    ["hugetree.dark.pink"] = 8,
    ["hugetree.dark.red"] = 9,
    ["hugetree.silhouette"] = 10,
    ["mediumtree.classic.green"] = 11,
    ["mediumtree.dark.black"] = 12,
    ["mediumtree.dark.pink"] = 13,
    ["mediumtree.dark.red"] = 14,
    ["mediumtree.silhouette"] = 15,
    ["smalltree.classic.green"] = 16,
    ["smalltree.dark.black"] = 17,
    ["smalltree.dark.pink"] = 18,
    ["smalltree.dark.red"] = 19,
    ["smalltree.silhouette"] = 20,
    ["talltree.classic.green"] = 21,
    ["talltree.dark.black"] = 22,
    ["talltree.dark.pink"] = 23,
    ["talltree.dark.red"] = 24,
    ["talltree.silhouette"] = 25,
}

function Trees:getSheet()
    return self.sheet;
end

function Trees:getFrameIndex(name)
    return self.frameIndex[name];
end

return Trees
