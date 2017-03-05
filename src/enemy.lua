local M={}

M.img = love.graphics.newImage("img/enemy.png")
M.creeps={}

local newCreep={}
newCreep.health=100
newCreep.posx=1
newCreep.posy=1
newCreep.dmg=10

function M.spawnCreeps()
    M.creeps[1]=newCreep
end

function M.moveCreeps()
--A*
end

function M.drawCreeps()
    love.graphics.setColor(255,255,255)
    for _,i in pairs(M.creeps) do
        love.graphics.draw(M.img,  (i.posx-1)*chunkW, (i.posy-1)*chunkH,
            0, 1/2, 1/2)
    end
end
return M
