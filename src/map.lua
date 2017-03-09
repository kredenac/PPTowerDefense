local M={}
--M is a module table

M.map = {}

M.map.width = 0
M.map.height = 0

-- globalne predefinisane boje, da ustedimo memoriju (ne stavljamo na svaki chunk)
M.color = {}
M.color.r = 255
M.color.g = 255
M.color.b = 255
M.color.a = 100

M.const={}
M.const.empty=0
M.const.wall=1
M.const.turret=2

M.colorHover = {}
M.colorHover.r = 0
M.colorHover.g = 100
M.colorHover.b = 200
M.colorHover.a = 100

function M.newTurret(i, j, type)
    if map.map[i][j].val ~= map.const.empty then
        return
    end
    M.map[i][j].val = M.const.turret
    --TODO ovo je malo ruzno da bude atribut mape
    M.map[i][j].ttype = type
    newTurret = {}
    newTurret.hp = 100
    newTurret.x = i
    newTurret.y = j
    newTurret.type = type
    table.insert(M.turrets, newTurret)
    --print(tableSize(M.turrets))
end

function M.removeTurret(i, j)
    if map.map[i][j].val ~= map.const.turret then
        return
    end
    map.map[i][j].val = map.const.empty
    for k, v in pairs(M.turrets) do
        if v.x == i and v.y == j then
            M.turrets[k] = nil --ovako se brise entry iz tabele
        end
    end
end

M.turrets = {}

turret = {}
turret[1] = {}
turret[2] = {}
--TODO da ne budu slike loadovane 2x
turret[1].img = love.graphics.newImage("img/turret.png")
turret[2].img = love.graphics.newImage("img/frostTurret.png")
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

    turret.scalex = 1/(turret[1].img:getWidth()/(chunkW-1)) -- minus 1 zbog ivice grida
    turret.scaley = 1/(turret[1].img:getHeight()/(chunkH-1))*1.5--TODO ulepsaj
end


-- Generise praznu mapu
-- postavlja chunkW i chunkH, sto je visina i sirina svakog pravougaonika
function M.generateEmpty(width,height)
    for i=1,width do
        M.map[i] = {}
        for j=1,height do
            M.map[i][j] = {}
            --val je tip objekta
            M.map[i][j].val = M.const.empty
            --TODO umesto val nek ima .obj, a obj u sebi val. a mozda no need...
            M.map[i][j].hover = false
        end
    end
    M.map.width = width
    M.map.height = height
    M.updateSize()
end

-- Promeni boju chunka na hover
-- moze matematicki da se izracuna u kom je polju, umesto for petlje
-- mada nije mnogo bitno jer je mali grid
function M.mouse()
    mouseX, mouseY = love.mouse.getPosition()
    selectedX=-1
    selectedY=-1
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
                love.graphics.setColor(220,220,255)
                love.graphics.draw(img,  (i-1)*chunkW, (j-1)*chunkH,
        --orientation,                           , offsetx, offsety FIXME ulepsaj 0.4
                    0, turret.scalex, turret.scaley, 0, -chunkH*0.4/turret.scaley)

            end
        end
    end
end

--returning the module
return M
