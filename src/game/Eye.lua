-----------------------------------------------------------------------------------------

Eye = {}    

-----------------------------------------------------------------------------------------

function Eye:new()  

    local object = {
        RADIUS = 35,

        sprite             = nil,
        timeLastThrow     = system.getTimer(),
    }

    setmetatable(object, { __index = Eye })
    return object
end

-----------------------------------------------------------------------------------------
-- sprite.x, sprite.y : coordonnees dans le monde, dans la camera
-- screenX, screenY : coordonnees a lecran, pour les touches

function Eye:screenX()
    return sprite.x*game.zoom
end

function Eye:screenY()
    return sprite.y*game.zoom
end

-------------------------------------

function Eye:init(x,y)

    ---------------------------

    self.previousVy = 0

    ---------------------------

    self.sprite = display.newImage( game.camera, "assets/images/game/enemy.eye.png")

    self.sprite:scale(0.3,0.3)
    self.sprite.x = x
    self.sprite.y = y

    self.sprite.isEnemy = true
    self.throws = true

    physics.addBody( self.sprite, "static", { 
        density = 5, 
        friction = 1, 
        bounce = 0.2,
        radius = self.RADIUS
    })

    ---------------------------

    self.sprite.isEnemy              = true
    self.sprite.isFixedRotation = true
    self.sprite:addEventListener( "collision", function(event) self:collide(event) end )
    self.sprite:addEventListener( "preCollision", function(event) self:preCollide(event) end )

    ---------------------------

    effectsManager.lightEye(self.sprite)  
end    

-------------------------------------

function Eye:miniEye(x,y)
    local scale = 0.3 + random(1,40)*0.01    
    self.sprite = display.newImage( game.camera, "assets/images/game/mini.eye.png" )
    self.sprite:scale(scale,scale)
    self.sprite.alpha = 0.4
    self.sprite.x = x
    self.sprite.y = y
    self.throws = false
end    

-------------------------------------

function Eye:initBackgroundEye(x,y)
    self.sprite = display.newImage(  "assets/images/game/eye.blur.png" )
    self.sprite.x = x
    self.sprite.y = y
    self.throws = false
end    

-------------------------------------

function Eye:destroy()
    physicsManager.destroyObjectWithEffect(self.sprite)
end

-------------------------------------

function Eye:refresh()

    if(self.isDestroyed) then return end

    local a, b, direction

    a    = vector2D:new(self.sprite.x,self.sprite.y)
    b     = vector2D:new(character.sprite.x, character.sprite.y)
    direction = vector2D:Sub(b, a)

    self.direction = direction

    local c = direction.x/direction:magnitude()
    local s = direction.y/direction:magnitude()

    local alpha = math.deg(math.atan2(s,c))

    self.sprite.rotation = alpha - 90

    if(self.throws) then
        local now = system.getTimer()
        if(now - self.timeLastThrow > random(4500,8000)) then
            self.timeLastThrow = now
            self:throw()
        end
    end

end

-------------------------------------

function Eye:preCollide(event)
    if(event.contact) then
        if(event.other.isSensor) then
            event.contact.isEnabled = false
        end
    end
end

-------------------------------------

function Eye:collide( event )

    if(event.other.isRock) then
        self.isDestroyed = true
        utils.destroyFromDisplay(self.sprite) 
    end

end

-------------------------------------

function Eye:throw()
    physicsManager.eyeThrow(self)
end

------------------------------------------

return Eye