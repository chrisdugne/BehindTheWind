-----------------------------------------------------------------------------------------
-- Project: Utils for uralys.libs
--
-- Date: May 8, 2013
--
-- Version: 1.5
--
-- File name    : Utils.lua
-- 
-- Author: Chris Dugne @ Uralys - www.uralys.com
--
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

module(..., package.seeall)

-----------------------------------------------------------------------------------------

function onTouch(object, action)
    object:addEventListener    ("touch", function(event)
        if(event.phase == "began") then
            action() 
        end
        return true 
    end)
end

-----------------------------------------------------------------------------------------

function getMinSec(seconds)
    local min = math.floor(seconds/60)
    local sec = seconds - min * 60

    if(sec < 10) then
        sec = "0" .. sec
    end

    return min, sec
end

function getMinSecMillis(millis)
    local min = math.floor(millis/60000)
    local sec = math.floor((millis - min * 60 * 1000)/1000)
    local ms = math.floor(millis - min * 60 * 1000 - sec * 1000)

    if(sec < 10) then
        sec = "0" .. sec
    end

    if(ms < 10) then
        ms = "00" .. ms
    elseif(ms < 100) then
        ms = "0" .. ms
    end

    return min, sec, ms
end

function getUrlParams(url)

    local index = string.find(url,"?")
    local paramsString = url:sub(index+1, string.len(url) )

    local params = {}

    fillNextParam(params, paramsString);

    return params;

end

function fillNextParam(params, paramsString)

    local indexEqual = string.find(paramsString,"=")
    local indexAnd = string.find(paramsString,"&")

    local indexEndValue
    if(indexAnd == nil) then 
        indexEndValue = string.len(paramsString) 
    else 
        indexEndValue = indexAnd - 1 
    end

    if ( indexEqual ~= nil ) then
        local varName = paramsString:sub(0, indexEqual-1)
        local value = paramsString:sub(indexEqual+1, indexEndValue)
        params[varName] = url_decode(value)

        if (indexAnd ~= nil) then
            paramsString = paramsString:sub(indexAnd+1, string.len(paramsString) )
            fillNextParam(params, paramsString)
        end

    end

end


-----------------------------------------------------------------------------------------

function split(value, sep)
    local sep, fields = sep or ":", {}
    local pattern = string.format("([^%s]+)", sep)
    value:gsub(pattern, function(c) fields[#fields+1] = c end)
    return fields
end

-----------------------------------------------------------------------------------------

function emptyGroup( group )
    if(group ~= nil and group.numChildren ~= nil and group.numChildren > 0) then
        for i=group.numChildren,1,-1 do
            local child = group[i]
            transition.cancel(child)
            child:removeSelf()
            child = nil
        end
    end
end

function destroyFromDisplay(object)
    if(object) then
        display.remove(object)
        object = nil
    end
end


-----------------------------------------------------------------------------------------

function string.startsWith(String,Start)
    return string.sub(String,1,string.len(Start))==Start
end

function string.endsWith(String,End)
    return End=='' or string.sub(String,-string.len(End))==End
end

-----------------------------------------------------------------------------------------

function joinTables(t1, t2)

    local result = {}
    if(t1 == nil) then t1 = {} end
    if(t2 == nil) then t2 = {} end

    for k,v in pairs(t1) do
        result[k] = v 
    end 

    for k,v in pairs(t2) do
        result[k] = v 
    end 

    return result
end

-----------------------------------------------------------------------------------------

function removeFromTable(t, object)
    local index = 1
    for k,v in pairs(t) do
        if(t[k] == object) then
            break
        end

        index = index + 1 
    end 

    table.remove(t, index)
end

-----------------------------------------------------------------------------------------

function imageName( url )
    local index = string.find(url,"/")

    if(index == nil) then 
        if(not string.endsWith(url, ".png")) then
            url = url .. ".png"
        end
        return url;
    else
        local subURL = url:sub(index+1, string.len(url))
        return imageName(subURL)
    end
end

-----------------------------------------------------------------------------------------

--a tester  https://gist.github.com/874792

function tprint (tbl, indent)
    if not tbl then print("Table nil") return end
    if type(tbl) ~= "table" then
        print(tostring(tbl))
    else
        if not indent then indent = 0 end
        for k, v in pairs(tbl) do
            formatting = string.rep("  ", indent) .. k .. ": "
            if type(v) == "table" then
                print(formatting)
                tprint(v, indent+1)
            else
                print(formatting .. tostring(v))
            end
        end
    end
end

-----------------------------------------------------------------------------------------

function postWithJSON(data, url, next)
    post(url, json.encode(data), next, "json")
end

--------------------------------------------------------

function post(url, data, next, type)

    if(next == nil) then 
        next = function() end
    end

    local headers = {}

    if(type == nil) then
        headers["Content-Type"] = "application/x-www-form-urlencoded"
    elseif(type == "json") then
        headers["Content-Type"] = "application/json"
    end

    local params = {}
    params.headers = headers
    params.body = data

    network.request( url, "POST", next, params)
end

--------------------------------------------------------

function get(url, callback)
    network.request( url, "GET", callback)
end


--------------------------------------------------------

function isEmail(str)
    return str:match("[A-Za-z0-9%.%%%+%-]+@[A-Za-z0-9%.%%%+%-]+%.%w%w%w?%w?")
end

--------------------------------------------------------

function url_decode(str)
    str = string.gsub (str, "+", " ")
    str = string.gsub (str, "%%(%x%x)",
    function(h) return string.char(tonumber(h,16)) end)
    str = string.gsub (str, "\r\n", "\n")
    return str
end

function urlEncode(str)
    if (str) then
        str = string.gsub (str, "\n", "\r\n")
        str = string.gsub (str, "([^%w ])",
        function (c) return string.format ("%%%02X", string.byte(c)) end)
        str = string.gsub (str, " ", "+")
    end
    return str    
end

--------------------------------------------------------

function parseDate(str)
    _,_,y,m,d=string.find(str, "(%d+)-(%d+)-(%d+)")
    return tonumber(y),tonumber(m),tonumber(d)
end

function parseDateTime(str)
    local Y,M,D = parseDate(str)
    return os.time({year=Y, month=M, day=D})
end

--------------------------------------------------------

function saveTable(t, filename, directory)

    if(not directory) then
        directory = system.DocumentsDirectory
    end

    local path = system.pathForFile( filename, directory)
    local file = io.open(path, "w")
    if file then
        local contents = json.encode(t)
        file:write( contents )
        io.close( file )
        return true
    else
        return false
    end
end

function loadTable(path)
    local contents = ""
    local myTable = {}
    local file = io.open( path, "r" )
    if file then
        -- read all contents of file into a string
        local contents = file:read( "*a" )
        myTable = json.decode(contents);
        io.close( file )
        return myTable 
    end
    return nil
end

--------------------------------------------------------

function getPointsBetween(from, to, nbPoints)

    if(from.x > to.x) then
        local swap = from
        from = to
        to = swap
    end

    local x1,y1 = from.x,from.y
    local x2,y2 = to.x,to.y

    local step = math.abs(x2-x1)/nbPoints
    local points = {}

    local a = (y2-y1)/(x2-x1)

    for i=0,nbPoints do
        local x = x1 + i*step
        local y = y1 + a*(x - x1)
        table.insert(points, vector2D:new(x, y))
    end

    return points
end

--------------------------------------------------------

function networkConnection()
    local status

    local socket = require("socket")
    local test = socket.tcp()
    test:settimeout(2000) 

    -- Note that the test does not work if we put http:// in front
    local testResult = test:connect("www.google.com", 80)

    if not(testResult == nil) then
        status = true
    else
        status = false
    end

    test:close()
    test = nil
    return status
end

--------------------------------------------------------

function displayCounter(numToReach, writer, anchorX, anchorY, x, next, nextMillis)

    timer.performWithDelay(5, function()
        
        local ratio
        
        if(numToReach == writer.currentDisplay) then
            ratio = 1 
        else
            ratio = (4 * numToReach)/(numToReach - writer.currentDisplay)
        end
        
        local toAdd = math.floor(numToReach/ratio)
        if(toAdd == 0) then toAdd = 1 end

        writer.currentDisplay = math.round(writer.currentDisplay + toAdd)

        if(writer.currentDisplay > numToReach) then
            writer.currentDisplay = math.round(numToReach)    
            next()
        else
            nextMillis = 100/(numToReach - writer.currentDisplay)
            displayCounter(numToReach, writer, anchorX, anchorY, x, next, nextMillis)
        end

        writer.text         = writer.currentDisplay 
        writer.x            = x
        writer.anchorX      = anchorX
        writer.anchorY      = anchorY
    end)
end

----------------------------------------------------------------

function drawPercentageBar(parent, percentage, x, y, width, height, border)

    local border = border or height/6
    
    local back = display.newRoundedRect(parent, x, y, width, height, 0)
    back:setFillColor(18/255, 29/255, 50/255)
    parent:insert(back)
        
    
    local gradientCenter = {
        type="gradient",
        color1={ 13/255, 25/255, 45/255 }, color2={ 25/255, 39/255, 64/255 }, direction="down"
    }
    
    local center = display.newRoundedRect(parent, x , y, width-2*border, height-2*border, 0)
    center:setFillColor(gradientCenter)
    parent:insert(center)
        
    
    local gradientFill = {
        type="gradient",
        color1={ 9/255, 228/255, 9/255 }, color2={ 0, 145/255, 0 }, direction="down"
    }
    
    local fill = display.newRoundedRect(parent, x - ((width-2*border) * (1-percentage))/2 , y, (width-2*border) * percentage, height-2*border, 0)
    fill:setFillColor(gradientFill)
    parent:insert(fill)
    
end

----------------------------------------------------------------
--- before opening the app, call FB API to get the likes nb

function getFacebookLikes(openApp)

    GLOBALS.facebookLikes = -1
    
    if(networkConnection()) then
    
        utils.get("https://graph.facebook.com/uralys", function(result)
            local uralys = json.decode(result.response)
            GLOBALS.facebookLikes = uralys.likes
            openApp()
        end)    
    
    else
        openApp()
    
    end
end

--------------------------------------------------------

function loadUserData(file)
    return loadTable(system.pathForFile( file , system.DocumentsDirectory))
end

function loadFile(path)
    return loadTable(system.pathForFile( path , system.ResourceDirectory))
end

--------------------------------------------------------
--- http://developer.coronalabs.com/code/maths-library

-- returns the distance between points a and b
function distanceBetween( a, b )
    local width, height = b.x-a.x, b.y-a.y
    return (width*width + height*height)^0.5 -- math.sqrt(width*width + height*height)
    -- nothing wrong with math.sqrt, but I believe the ^.5 is faster
end
 
