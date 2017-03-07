local M={}

M.img = love.graphics.newImage("img/enemy.png")
M.creeps={}

local newCreep={}
newCreep.health=100
newCreep.posx=1
newCreep.posy=1
newCreep.dmg=10

--FIXME e sad.. da l ovo u enemy.lua ili map.lua? najbolje u neki nov fajl
--iscrtava nisan od kule do neprijatelja
function M.targetEnemies()
    love.graphics.setColor(255, 0, 0)
    local offsetx = chunkW / 2
    local offsety = chunkH / 2
    for _, v in pairs(map.turrets) do
		i, j = v.x, v.y
		creeps = enemy.nearTower(i,j)
		if creeps ~= nil then
			for _,k in pairs(creeps) do
				love.graphics.line((i-1)*chunkW + offsetx, (j-1)*chunkH + offsety,
					(k.posx-1)*chunkW + offsetx, (k.posy-1)*chunkH + offsety)
			end
		end
	end
end

-- shallow-copy tabele, samo copy paste vrednosti
--TODO izdvoji u poseban fajl mby
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
    for _,k in pairs(M.creeps) do
        if math.abs(k.posx - i) <=1 and math.abs(k.posy - j) <=1 then
            table.insert(result, k)
        end
    end
    return result
end

numCreeps=0
function M.spawnCreeps()
    table.insert(M.creeps, copy(newCreep) )
    numCreeps=numCreeps+1
    print(numCreeps)
end

--samo za testiranje. treba da slusa 'naredjenja' od A*, a ne usr input
function M.moveCreeps(key)
    dx, dy = 0, 0
    if key == "w" then
		dy = -1
	end
    if love.keyboard.isDown("s") then
		dy = 1
	end
    if love.keyboard.isDown("a") then
		dx = -1
	end
    if love.keyboard.isDown("d") then
		dx = 1
	end

    for _,i in pairs(M.creeps) do
        tryx = i.posx + dx
        tryy = i.posy + dy
        --nema lenjog izracunavanja...
        --print("tryx>=1 and tryx<=map.map.width ",(tryx>=1 and tryx<=map.map.width ))
        if tryx>=1 and tryx<=map.map.width then
            --print("map.map[tryx][i.posy] == map.const.empty ",(map.map[tryx][i.posy].val == map.const.empty))
            if map.map[tryx][i.posy].val == map.const.empty then
                i.posx = tryx
            end
        end
        --print("tryx>=1 and tryx<=map.map.height ",tryx>=1 and tryx<=map.map.height)
        if tryy>=1 and tryy<=map.map.height then
            --print("map.map[i.posx][tryy].val == map.const.empty ", map.map[i.posx][tryy].val == map.const.empty)
            if map.map[i.posx][tryy].val == map.const.empty then
                i.posy = tryy
            end
        end

    end
end

function M.drawCreeps()
    love.graphics.setColor(255,255,255)
    for _,i in pairs(M.creeps) do
        love.graphics.draw(M.img,  (i.posx-1)*chunkW, (i.posy-1)*chunkH,
            0, 1/5, 1/5)
    end
end
return M
