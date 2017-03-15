local M={}

M.img = love.graphics.newImage("img/enemy.png")
M.creeps = {}
M.rows = {} -- IDs in each row
M.step = 0.1
local creep={}
creep.health=1000
--coords chunka
creep.posx=1
creep.posy=1
--pozicija u chunku
creep.x = 0
creep.y = 0
creep.dmg=10
numCreeps=0
creepValue = 10
--iscrtava nisan od kule do neprijatelja
function M.targetEnemies()
    local offsetx = chunkW / 2
    local offsety = chunkH / 2 + gui.topBarHeight

    for _, v in pairs(map.turrets) do
		local i, j = v.x, v.y
		local creeps = enemy.nearTower(i,j)
        local startx = (i-1)*chunkW + offsetx
        local starty = (j-1)*chunkH + offsety

        col = turret[v.type]
        love.graphics.setColor(col.rayr, col.rayg, col.rayb)
		for _,v in pairs(creeps) do
            --draw ray
            local endx = (M.creeps[v].posx-1 + M.creeps[v].x/2)*chunkW + offsetx
            local endy = (M.creeps[v].posy-1 + M.creeps[v].y/2)*chunkH + offsety
			love.graphics.line(startx, starty,endx, endy)
            --inflict damage
            local dead = M.creeps[v]:inflictDamage(3)
            if dead then
                 print(index)
                 M.rows[M.creeps[v].posy][v] = nil
                 M.creeps[v] = nil
                 numCreeps = numCreeps - 1
                 gui.gold = gui.gold + creepValue
                 -- TODO kad umre da iskoci + (gold) iznad njega
            end
		end
	end
end

function creep:inflictDamage(dmg)
    self.health = self.health - dmg
    return self.health <= 0
end

-- shallow-copy tabele, samo copy paste vrednosti
function copy (t)
    if type(t) ~= "table" then return t end
    local meta = getmetatable(t)
    local target = {}
    for k, v in pairs(t) do target[k] = v end
    setmetatable(target, meta)
    return target
end

--prolazi kroz sve kripove i gleda da l su blizu kule
--moze se optimizovati ako se cuvaju svi kripovi u odredjenom polju
function M.nearTower(i,j)
    local result = {}
    for k,v in pairs(M.creeps) do
        if math.abs(v.posx - i) <=1 and math.abs(v.posy - j) <=1 then
            table.insert(result, k)
        end
    end
    return result
end

creepId = 1
function M.spawnCreeps()
    local newCreep = copy(creep)
    M.creeps[creepId] = newCreep

    if M.rows[creep.posy] == nil then
      M.rows[creep.posy] = {}
    end
    M.rows[creep.posy][creepId] = true
    -- table.insert(M.rows[creep.posy],creepId);

    creepId = creepId + 1
    numCreeps = numCreeps + 1
    --print(numCreeps)
end

--samo za testiranje. treba da slusa 'naredjenja' od A*, a ne usr input
function M.moveCreeps(key)
    local dx, dy = 0, 0
    local step = M.step
    -- print(key)
    if key == "w" then
  		dy = -step
  	end
    if key == "s" then
  		dy = step
  	end
    if key == "a" then
  		dx = -step
  	end
    if key == "d" then
  		dx = step
  	end

    -- print (dx,dy)

    for index,i in pairs(M.creeps) do
        local tryx = i.x + dx
        local tryy = i.y + dy

        local oldPosY = i.posy;

        if tryx <= -1 then
            if i.posx - 1 >= 1 then
                if map.map[i.posx - 1][i.posy].val == map.const.empty then
                    i.posx = i.posx - 1
                    i.x = 1 - step
                end
            end
        elseif tryx >= 1 then
            if i.posx + 1 <= map.map.width then
                if map.map[i.posx + 1][i.posy].val == map.const.empty then
                    i.posx = i.posx + 1
                    i.x = -1 + step
                end
            end
        elseif tryy >= 1 then
            if i.posy + 1 <= map.map.height then
                if map.map[i.posx][i.posy + 1].val == map.const.empty then
                    i.posy = i.posy + 1
                    i.y = -1 + step
                end
            end
        elseif tryy <= -1 then
            if i.posy - 1 >= 1 then
                if map.map[i.posx][i.posy - 1].val == map.const.empty then
                    i.posy = i.posy - 1
                    i.y = 1 - step
                end
            end
        else
            i.x = tryx
            i.y = tryy
        end

        if i.posy ~= oldPosY then
          if M.rows[i.posy] == nil then
            M.rows[i.posy] = {}
          end
          M.rows[i.posy][index] = true
          M.rows[oldPosY][index] = nil
          -- table.insert(M.rows[i.posy],index)
          -- table.remove(M.rows[oldPosY],index)
          -- print(index)
        end
    end
end

function M.drawCreeps(row)
    local hpBarAbove = 5
    local hpBarWidth = 30
    local scalex, scaley = 0.2, 0.2

    -- for _,i in pairs(M.creeps) do
    if M.rows[row] == nil then
        return
    end
    for index,a in pairs(M.rows[row]) do
        i = M.creeps[index]
        if i == nil then
            return
        end
        -- print(a)
        local x = (i.posx-1 + i.x/2)*chunkW
        local y = gui.topBarHeight + (i.posy-1 + i.y/2)*chunkH
        --draw hp
        local hpPercent = i.health / creep.health
        love.graphics.setColor(255*(1-hpPercent),255*hpPercent,0)
        love.graphics.line(x, y + hpBarAbove, x + hpBarWidth * hpPercent, y+ hpBarAbove)
        --draw creep
        love.graphics.setColor(255,255,255)
        love.graphics.draw(M.img, x, y, 0, scalex, scaley)
    end
    -- print()
end
return M
