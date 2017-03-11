local M={}
--M is a module table

M.map = {}

M.map.width = 0
M.map.height = 0

-- globalne predefinisane boje
M.color = {}
M.color.r = 255
M.color.g = 255
M.color.b = 255
M.color.a = 100

M.const={}
M.const.empty=0
M.const.rock=1
M.const.turret=2

M.colorHover = {}
M.colorHover.r = 0
M.colorHover.g = 100
M.colorHover.b = 200
M.colorHover.a = 100

function M.newTurret(i, j, type)
    if M.map[i][j].val ~= M.const.empty or type == 0 or
       gui.gold - turret[type].cost < 0 then
       return
    end
    M.map[i][j].val = M.const.turret

    M.map[i][j].ttype = type
    newTurret = {}
    newTurret.hp = 100
    newTurret.x = i
    newTurret.y = j
    newTurret.type = type
    table.insert(M.turrets, newTurret)
    gui.gold = gui.gold - turret[type].cost
end

function M.removeTurret(i, j)
    if map.map[i][j].val ~= map.const.turret then
        return
    end
    map.map[i][j].val = map.const.empty
    for k, v in pairs(M.turrets) do
        if v.x == i and v.y == j then
            M.turrets[k] = nil --ovako se brise entry iz tabele
            gui.gold = gui.gold + turret[M.map[i][j].ttype].cost/2
        end
    end
end

M.turrets = {}

turret = {}
turret[1] = {}
turret[2] = {}
turret[1].img = fireTurretImg
turret[2].img = frostTurretImg
turret[1].cost = 50
turret[2].cost = 40

turret[1].rayr = 255
turret[1].rayg = 0
turret[1].rayb = 0
turret[2].rayr = 150
turret[2].rayg = 200
turret[2].rayb = 255

rock = {}
rock.img = love.graphics.newImage("img/rock.png")
background = {}
background.img = love.graphics.newImage("img/sand.jpg")
screen = {}

--update vars pri resize
function M.updateSize(topBar, bottomBar)
    screen.width = love.graphics.getWidth()
    screen.height = love.graphics.getHeight() - gui.topBarHeight - gui.bottomBarHeight
    background.scalex = 1/(background.img:getWidth()/screen.width)
    background.scaley = 1/(background.img:getHeight()/screen.height)
    -- print(screen.width, screen.height)
    chunkW = screen.width / M.map.width
    chunkH = screen.height / M.map.height
    --kolko se slicica skalira. kada ubacimo resize ovo treba update
    --da ne bismo bas svaki frame za svaku kulu racunali
    local turretToChunkHeight = 1.5
    local rockToChunkHeight = 1.2
    rock.scalex = 1/(rock.img:getWidth()/chunkW)
    rock.scaley = 1/(rock.img:getHeight()/chunkH)*rockToChunkHeight
    rock.offsety = gui.topBarHeight - rock.img:getHeight()*rock.scaley
    turret.scalex = 1/(turret[1].img:getWidth()/chunkW)
    turret.scaley = 1/(turret[1].img:getHeight()/chunkH)*turretToChunkHeight
    turret.offsety = gui.topBarHeight - turret[1].img:getHeight()*turret.scaley
end


-- Generise praznu mapu
-- postavlja chunkW i chunkH, sto je visina i sirina svakog pravougaonika
function M.generateEmpty(width,height, numRocks)
    for i=1,width do
        M.map[i] = {}
        for j=1,height do
            M.map[i][j] = {}
            --val je tip objekta
            M.map[i][j].val = M.const.empty
            M.map[i][j].hover = false
        end
    end
    generateRocks(width, height, numRocks)
    M.map.width = width
    M.map.height = height
    M.updateSize()
end

function generateRocks(w, h, n)
    for i=1, n do
        local x = math.random(w)
        local y = math.random(h)
        M.map[x][y].val = M.const.rock
    end
end
-- Promeni boju chunka na hover
-- moze matematicki da se izracuna u kom je polju, umesto for petlje
-- mada nije mnogo bitno jer je mali grid
function M.mouse(x, y)
    local mouseX, mouseY = x, y
    local selectedX = -1
    local selectedY = -1
    for i=1 , M.map.width do
        isx = mouseX > (i-1)*chunkW and mouseX < i*chunkW
        for j=1 , M.map.height do
            isy = mouseY > 50 + (j-1)*chunkH and mouseY < gui.topBarHeight + j*chunkH
            if isx and isy then
                M.map[i][j].hover = true
                selectedX, selectedY = i , j
            else
                M.map[i][j].hover = false
            end
        end
    end
    return selectedX, selectedY
end

-- Iscrtava mapu
function M.draw()
    love.graphics.setColor(255, 255, 255, 255)
    love.graphics.draw(background.img, 0, gui.topBarHeight, 0, background.scalex, background.scaley )

    local highlight=255
    for i=1 , M.map.width do
        for j=1 , M.map.height do

            if M.map[i][j].hover == false then
                love.graphics.setColor(M.color.r, M.color.g, M.color.b, M.color.a)
            else
                love.graphics.setColor(M.colorHover.r, M.colorHover.g,
                    M.colorHover.b, M.colorHover.a)
            end
            love.graphics.rectangle("fill", (i-1)*chunkW, gui.topBarHeight + (j-1)*chunkH, chunkW-1, chunkH-1)

            --draw turret
            if M.map[i][j].val == M.const.turret then
                local img = turret[M.map[i][j].ttype].img
                love.graphics.setColor(255,255,255)
                love.graphics.draw(img,  (i-1)*chunkW, j*chunkH + turret.offsety,
                    0, turret.scalex, turret.scaley)
            --draw rock
            elseif M.map[i][j].val == M.const.rock then
                love.graphics.setColor(255,255,255)
                love.graphics.draw(rock.img,  (i-1)*chunkW, j*chunkH + rock.offsety,
                    0, rock.scalex, rock.scaley)

            end
        end
    end
end

--returning the module
return M
