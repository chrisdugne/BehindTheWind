-----------------------------------------------------------------------------------------

Enemy = {}    

-----------------------------------------------------------------------------------------

local EnemySheetconfig     = require("src.game.graphics.Character")
local EnemyImageSheet         = graphics.newImageSheet( "assets/images/game/enemyJump.png", EnemySheetconfig.sheet )

-----------------------------------------------------------------------------------------

function Enemy:new()  

    local object = {
        Enemy_SPEED = 135,
         JUMP_SPEED = -257,
        RADIUS = 16,
        
        -------
        
        sprite             = nil,
        timeLastThrow     = 0,
        
        previousVy = 0,
        nbFramesToKeep = 0
    }

    setmetatable(object, { __index = Enemy })
    return object
end

-----------------------------------------------------------------------------------------
-- sprite.x, sprite.y : coordonnees dans le monde, dans la camera
-- screenX, screenY : coordonnees a lecran, pour les touches

function Enemy:screenX()
    return sprite.x*game.zoom
end

function Enemy:screenY()
    return sprite.y*game.zoom
end

-------------------------------------

function Enemy:init(x,y)

   ---------------------------

   self.previousVy = 0

   ---------------------------
   
   self.sprite = display.newSprite( game.camera, EnemyImageSheet, EnemySheetconfig.sequence )
   
   physics.addBody( self.sprite, { 
       density = 5, 
       friction = 1, 
       bounce = 0.2,
       radius = self.RADIUS
   })

   ---------------------------
   
   self.sprite.isEnemy          = true
   self.sprite.isFixedRotation = true
    self.sprite:addEventListener( "collision", function(event) self:collide(event) end )
    self.sprite:addEventListener( "preCollision", function(event) self:preCollide(event) end )

    -- set coordinates to center on spawnpoint
   self.sprite.x = x
   self.sprite.y = y

   ---------------------------
   
end    

function Enemy:destroy()
    utils.destroyFromDisplay(self.sprite)
end

-------------------------------------

function Enemy:refresh()

    local vx, vy = self.sprite:getLinearVelocity()

    if(self.nbFramesToKeep > 0 ) then
        self.nbFramesToKeep = self.nbFramesToKeep - 1
    else
       
       if(self.floor ~= nil) then
           self.sprite:setFrame(1)
       else
          if(self.previousVy - vy > 0 and not self.hanging) then
              self.sprite:setFrame(6)
          
          elseif(vy > 230) then
              self.sprite:setFrame(5)
          elseif(vy > 5) then
              self.sprite:setFrame(4)
          elseif(vy < -220) then
              self.sprite:setFrame(2)
          elseif(vy < -5) then
              self.sprite:setFrame(3)
          else
              self.sprite:setFrame(1)
          end
       end
       
       self.previousVy = vy
   end
   
   if(self.sprite.x < character.sprite.x) then
       self:lookRight()
   else
       self:lookLeft()
   end

    local now = system.getTimer()
   if(now - self.timeLastThrow > 5000) then
        self.timeLastThrow = now
       self:throw()
   end
end

-------------------------------------

function Enemy:preCollide(event)
    if(event.contact) then
         if(event.other.isSensor) then
            event.contact.isEnabled = false
        end
   end
end

-------------------------------------
-- vy = -260 is is the start vy when jumping. 
-- so vy = -200 is around the jump start
 
function Enemy:collide( event )
    
    -------------------------------------------

    if(event.other.isRock) then return end
    if(event.other.isGrab) then return end
    if(event.other.isSensor) then return end
    if(event.other.isAttach) then print("collide with attach") return end

    local now = system.getTimer()
    if(self.leavingFloor and event.other.y == self.leavingFloor.y) then
        if(now - self.timeLeavingFloor < 70) then
           return
        end
    end

    -------------------------------------------
    
    local tileTop                     = event.other.y     - event.other.height/2 
    local characterBottom         = event.target.y     + self.RADIUS
    
    -------------------------------------------

    local characterTop             = event.target.y     - self.RADIUS
    local characterLeft             = event.target.x     - self.RADIUS
    local characterRight         = event.target.x     + self.RADIUS
    local tileBottom                 = event.other.y     + event.other.height/2
    local tileLeft                 = event.other.x     - event.other.width/2
    local tileRight                 = event.other.x     + event.other.width/2

    -------------------------------------------
    
    local vx, vy = event.target:getLinearVelocity()
    
    if(tileTop > characterBottom and event.other.isFloor and vy > -200) then
        self.floor = event.other
        self.jumping = false
        self:move()
    end
    
end

-------------------------------------

function Enemy:lookLeft()
    self.sprite.xScale = -1
end

function Enemy:lookRight()
    self.sprite.xScale = 1
end

-------------------------------------

function Enemy:move()
    if(self.floor) then
        self:jump()
    end
end

-------------------------------------

function Enemy:stop()
    self.state = self.NOT_MOVING
    local vx, vy = self.sprite:getLinearVelocity()
    if(vy < 0) then vy = vy*0.5 end
    self.sprite:setLinearVelocity( vx*0.67 , vy)
end


function Enemy:goLeft()
    local vx, vy = self.sprite:getLinearVelocity()
    
    local floorVx, floorVy = 0,0
    if(self.floor) then floorVx, floorVy = self.floor:getLinearVelocity() end
    
    self.state = self.GOING_LEFT    
    self:lookLeft()
    self.sprite:setLinearVelocity( -self.Enemy_SPEED+floorVx, vy )
end

function Enemy:goRight()
    local vx, vy = self.sprite:getLinearVelocity()
    
    local floorVx, floorVy = 0,0
    if(self.floor) then floorVx, floorVy = self.floor:getLinearVelocity() end

    self.state = GOING_RIGHT
    self:lookRight()
    self.sprite:setLinearVelocity( self.Enemy_SPEED+floorVx, vy )
end

function Enemy:jump()
    if(self.jumping or (not self.hanging and not self.floor)) then return end
    self.timeLeavingFloor = system.getTimer()
    self.leavingFloor     = self.floor
    self.jumping             = true
    
    self.floor = nil
    
    local vx, vy = self.sprite:getLinearVelocity()
    self.sprite:setLinearVelocity( vx, self.JUMP_SPEED )
end

-------------------------------------

function Enemy:throw()
    physicsManager.enemyThrow(self.sprite)
end

------------------------------------------

return Enemy