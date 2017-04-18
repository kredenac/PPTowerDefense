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
creep.path={}
creep.effects={}
creep.chIndex=1
numCreeps=0
creepValue = 10
--iscrtava nisan od kule do neprijatelja
function M.targetEnemies()
    local offsetx = chunkW / 2
    local offsety = chunkH / 2 + gui.topBarHeight

    for _, turr in pairs(map.turrets) do
		local i, j = turr.x, turr.y
		local creeps = enemy.nearTower(i,j)
        local startx = (i-1)*chunkW + offsetx
        local starty = (j-1)*chunkH + offsety

        col = turret[turr.type]
        love.graphics.setColor(col.rayr, col.rayg, col.rayb)
		for _,v in pairs(creeps) do
            --draw ray
            local endx = (M.creeps[v].posx-1 + M.creeps[v].x/2)*chunkW + offsetx
            local endy = (M.creeps[v].posy-1 + M.creeps[v].y/2)*chunkH + offsety
			love.graphics.line(startx, starty,endx, endy)

            --add effect
            for _,effect in pairs(turr.effects) do
                M.creeps[v].effects[effect] = true
                print(effect)
                print(v)
            end

            --inflict damage
            local dead = M.creeps[v]:inflictDamage(turr.dmg)
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
function M.spawnCreeps(path)
    local newCreep = copy(creep)
    M.creeps[creepId] = newCreep
	M.creeps[creepId].path = copy(path)
    M.creeps[creepId].effects = {}

	-- for j=1, M.creeps[creepId].path.len do
		--print(("I : %d"):format(j))
		-- print(("X: %d, Y: %d"):format(M.creeps[creepId].path[j].x, M.creeps[creepId].path[j].y))
	-- end

    if M.rows[creep.posy] == nil then
      M.rows[creep.posy] = {}
    end
    M.rows[creep.posy][creepId] = true

    creepId = creepId + 1
    numCreeps = numCreeps + 1
end

--samo za testiranje. treba da slusa 'naredjenja' od A*, a ne usr input
function M.moveCreeps()
    local step = M.step

    -- print (dx,dy)

    for index,i in pairs(M.creeps) do
		if i.chIndex <= i.path.len then
			if i.path[i.chIndex].y > i.posx then
				dx = step
			elseif i.path[i.chIndex].y < i.posx then
				dx = -step
			else
				dx = 0
			end

			if i.path[i.chIndex].x > i.posy then
				dy = step
			elseif i.path[i.chIndex].x < i.posy then
				dy = -step
			else
				dy = 0
			end

            -- usporava zaledjenog
            print(i.effects["freeze"])
            if i.effects["freeze"] == true then
              dx = dx/2
              dy = dy/2
            end

			local tryx = i.x + dx
			local tryy = i.y + dy

			if tryx >= 2 or tryx <= -2 then
				if tryx >= 2 then
                    i.posx = i.posx+1
                else
                    i.posx = i.posx-1
                end
                tryx = 0
				i.chIndex = i.chIndex+1
            end
			i.x = tryx


			if tryy >= 2 or tryy <= -2 then
                -- brise se creep iz starog reda
                M.rows[M.creeps[index].posy][index] = nil

                if tryy >= 2 then
                    i.posy = i.posy+1
                else
                    i.posy = i.posy-1
                end
                tryy = 0

                -- upisuje se u novi red
                if M.rows[i.posy] == nil then
                  M.rows[i.posy] = {}
                end
                M.rows[i.posy][index] = true

				i.chIndex = i.chIndex+1
			end
			i.y = tryy
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
        if i.effects["freeze"] then
            love.graphics.setColor(155,155,255)
        end


        love.graphics.draw(M.img, x, y, 0, scalex, scaley)
    end
    -- print()
end
return M
