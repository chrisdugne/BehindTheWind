--
-- created with TexturePacker (http://www.codeandweb.com/texturepacker)
--
-- $TexturePacker:SmartUpdate:78434c5a1b2d9a3e5ef0dc87af36b9f6:1/1$
--
-- local sheetInfo = require("mysheet")
-- local myImageSheet = graphics.newImageSheet( "mysheet.png", sheetInfo:getSheet() )
-- local sprite = display.newSprite( myImageSheet , {frames={sheetInfo:getFrameIndex("sprite")}} )
--

local Trees = {}

Trees.sheet =
{
    frames = {
    
        {
            -- bush.classic.green
            x=1780,
            y=910,
            width=216,
            height=225,

        },
        {
            -- bush.dark.black
            x=1780,
            y=683,
            width=216,
            height=225,

        },
        {
            -- bush.dark.pink
            x=1780,
            y=456,
            width=216,
            height=225,

        },
        {
            -- bush.dark.red
            x=1780,
            y=229,
            width=216,
            height=225,

        },
        {
            -- bush.silhouette
            x=1780,
            y=2,
            width=216,
            height=225,

        },
        {
            -- hugetree.classic.green
            x=488,
            y=2,
            width=484,
            height=494,

            sourceX = 19,
            sourceY = 18,
            sourceWidth = 512,
            sourceHeight = 512
        },
        {
            -- hugetree.dark.black
            x=2,
            y=1490,
            width=484,
            height=494,

            sourceX = 19,
            sourceY = 18,
            sourceWidth = 512,
            sourceHeight = 512
        },
        {
            -- hugetree.dark.pink
            x=2,
            y=994,
            width=484,
            height=494,

            sourceX = 19,
            sourceY = 18,
            sourceWidth = 512,
            sourceHeight = 512
        },
        {
            -- hugetree.dark.red
            x=2,
            y=498,
            width=484,
            height=494,

            sourceX = 19,
            sourceY = 18,
            sourceWidth = 512,
            sourceHeight = 512
        },
        {
            -- hugetree.silhouette
            x=2,
            y=2,
            width=484,
            height=494,

            sourceX = 19,
            sourceY = 18,
            sourceWidth = 512,
            sourceHeight = 512
        },
        {
            -- mediumtree.classic.green
            x=1080,
            y=976,
            width=294,
            height=330,

        },
        {
            -- mediumtree.dark.black
            x=784,
            y=1469,
            width=294,
            height=330,

        },
        {
            -- mediumtree.dark.pink
            x=784,
            y=1137,
            width=294,
            height=330,

        },
        {
            -- mediumtree.dark.red
            x=488,
            y=1469,
            width=294,
            height=330,

        },
        {
            -- mediumtree.silhouette
            x=488,
            y=1137,
            width=294,
            height=330,

        },
        {
            -- smalltree.classic.green
            x=1080,
            y=1308,
            width=212,
            height=254,

            sourceX = 21,
            sourceY = 2,
            sourceWidth = 256,
            sourceHeight = 256
        },
        {
            -- smalltree.dark.black
            x=1804,
            y=1137,
            width=212,
            height=254,

            sourceX = 21,
            sourceY = 2,
            sourceWidth = 256,
            sourceHeight = 256
        },
        {
            -- smalltree.dark.pink
            x=1376,
            y=1232,
            width=212,
            height=254,

            sourceX = 21,
            sourceY = 2,
            sourceWidth = 256,
            sourceHeight = 256
        },
        {
            -- smalltree.dark.red
            x=1590,
            y=1137,
            width=212,
            height=254,

            sourceX = 21,
            sourceY = 2,
            sourceWidth = 256,
            sourceHeight = 256
        },
        {
            -- smalltree.silhouette
            x=1376,
            y=976,
            width=212,
            height=254,

            sourceX = 21,
            sourceY = 2,
            sourceWidth = 256,
            sourceHeight = 256
        },
        {
            -- talltree.classic.green
            x=488,
            y=498,
            width=401,
            height=485,

        },
        {
            -- talltree.dark.black
            x=1377,
            y=489,
            width=401,
            height=485,

        },
        {
            -- talltree.dark.pink
            x=974,
            y=489,
            width=401,
            height=485,

        },
        {
            -- talltree.dark.red
            x=1377,
            y=2,
            width=401,
            height=485,

        },
        {
            -- talltree.silhouette
            x=974,
            y=2,
            width=401,
            height=485,

        },
    },
    
    sheetContentWidth = 2048,
    sheetContentHeight = 2048
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
