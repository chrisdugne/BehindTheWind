-----------------------------------------------------------------------------------------

Game = {}

-----------------------------------------------------------------------------------------

function Game:new()  

	local object = { 
		camera 	= display.newGroup(),
		focus 	= CHARACTER
	}

	setmetatable(object, { __index = Game })  
	return object
end

-----------------------------------------------------------------------------------------

function Game:init()
	utils.emptyGroup(self.camera)
	Runtime:addEventListener( "enterFrame", self.refreshCamera )
	--camera:scale(0.3,0.3)
end

------------------------------------------

function Game:refreshCamera(event)
	if(character.sprite) then
		if(not character.rock or game.focus == CHARACTER) then	
      	local leftDistance 		= character.sprite.x + game.camera.x
      	local rightDistance 		= display.contentWidth - leftDistance
      
      	local topDistance 		= character.sprite.y + game.camera.y
      	local bottomDistance 	= display.contentHeight - topDistance
      	
      	if(rightDistance < display.contentWidth*0.38) then
      		game.camera.x = - character.sprite.x + display.contentWidth*0.62
      	elseif(leftDistance < display.contentWidth*0.38) then
      		game.camera.x = - character.sprite.x + display.contentWidth*0.38
      	end
      
      	if(bottomDistance < display.contentHeight*0.28) then
      		game.camera.y = - character.sprite.y + display.contentHeight*0.72
      	elseif(topDistance < display.contentHeight*0.28) then
      		game.camera.y = - character.sprite.y + display.contentHeight*0.28
      	end
      
      elseif(game.focus == ROCK) then
      	if(character.rock.x) then 
      		game.camera.x = -character.rock.x + display.contentWidth*0.5
      		game.camera.y = -character.rock.y + display.contentHeight*0.5
      	end
      end
	end
end

------------------------------------------

return Game