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
turret={}
turret.img = love.graphics.newImage("img/turret.png")
background = {}
background.img = love.graphics.newImage("img/sand.jpg")

screen = {}

--update vars pri resize
function M.updateSize()
    screen.width = love.graphics.getWidth()
    screen.height = love.graphics.getHeight()
    background.scalex = 1/(background.img:getWidth()/screen.width)
    background.scaley = 1/(background.img:getHeight()/screen.height)
    print(screen.width, screen.height)
    print(background.scalex.." "..background.scaley)
    chunkW = screen.width / M.map.width
    chunkH = screen.height / M.map.height
    --kolko se slicica skalira. kada ubacimo resize ovo treba update
    --da ne bismo bas svaki frame za svaku kulu racunali
    turret.scalex=1/(turret.img:getWidth()/(chunkW-1)) -- minus 1 zbog ivice grida
    turret.scaley=1/(turret.img:getHeight()/(chunkH-1))*1.5--TODO ulepsaj
end


-- Generise praznu mapu
-- postavlja chunkW i chunkH, sto je visina i sirina svakog pravougaonika

function M.generateEmpty(width,height)
    for i=1,width do
        M.map[i] = {}
        for j=1,height do
            M.map[i][j] = {}
            M.map[i][j].val = M.const.empty
            --TODO umesto val nek ima .obj, a obj u sebi val
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
        for j=1 , M.map.height do
            isx = mouseX > (i-1)*chunkW and mouseX < i*chunkW
            isy = mouseY > (j-1)*chunkH and mouseY < j*chunkH
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
--TODO sredi donji deo turreta da se ne preklapa sa prozirnim
function M.draw()
    love.graphics.draw(background.img, 0, 0, 0, background.scalex, background.scaley )
    local highlight=255
    for i=1 , M.map.width do
        for j=1 , M.map.height do

            if M.map[i][j].hover == false then
                love.graphics.setColor(M.color.r, M.color.g, M.color.b, M.color.a)
            else
                love.graphics.setColor(M.colorHover.r, M.colorHover.g,
                    M.colorHover.b, M.colorHover.a)
            end
                love.graphics.rectangle("fill", (i-1)*chunkW, (j-1)*chunkH, chunkW-1, chunkH-1)

            --draw turret
            if M.map[i][j].val == M.const.turret then
                love.graphics.setColor(255,255,255)
                love.graphics.draw(turret.img,  (i-1)*chunkW, (j-1)*chunkH,
        --orientation, scale x,       scale y, offsetx, offsety
                    0, turret.scalex, turret.scaley, 0, chunkH*0.5)

            end
        end
    end
end

--returning the module
return M
