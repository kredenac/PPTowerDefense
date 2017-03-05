local M={}
--M is a module table

M.map = {}

M.map.width = 0
M.map.height = 0

-- globalne predefinisane boje, da ustedimo memoriju (ne stavljamo na svaki chunk)
M.color = {}
M.color.r = 0
M.color.g = 70
M.color.b = 70

M.const={}
M.const.empty=0
M.const.wall=1
M.const.turret=2

turret={}
turret.color={}
turret.color.r=M.color.r
turret.color.g=M.color.g
turret.color.b=M.color.b

-- slicno za hover
M.colorHover = {}
M.colorHover.r = 0
M.colorHover.g = 170
M.colorHover.b = 170

-- Generise praznu mapu
-- postavlja chunkW i chunkH, sto je visina i sirina svakog pravougaonika
-- TODO screen width i height verovatno treba da se stave na neko globalnije mesto

function M.generateEmpty(width,height)
    for i=1,width do
        M.map[i] = {}
        for j=1,height do
            M.map[i][j] = {}
            M.map[i][j].val = M.const.empty
            M.map[i][j].hover = false
        end
    end

    M.map.width = width
    M.map.height = height

    screen = {}
    screen.width = love.graphics.getWidth()
    screen.height = love.graphics.getHeight()

    chunkW = screen.width / M.map.width
    chunkH = screen.height / M.map.height

end

-- Promeni boju chunka na hover
-- moze matematicki da se izracuna u kom je polju, umesto for petlje
-- mada nije mnogo bitno jer je mali grid
-- TODO akcija na klik, mozda razdvojiti u fje
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
function M.draw()
    for i=1 , M.map.width do
        for j=1 , M.map.height do
            if M.map[i][j].val == M.const.turret then
                love.graphics.setColor(255,255, 255)
                love.graphics.draw(turretImg,  (i-1)*chunkW, (j-1)*chunkH,
                    0, 1/(turretImg:getWidth()/(chunkW-1)),
                    1/(turretImg:getHeight()/(chunkH-1)) )
            elseif M.map[i][j].hover == false then
                love.graphics.setColor(M.color.r, M.color.g, M.color.b)
                love.graphics.rectangle("fill", (i-1)*chunkW, (j-1)*chunkH, chunkW-1, chunkH-1)
            else
                love.graphics.setColor(M.colorHover.r, M.colorHover.g, M.colorHover.b)
                love.graphics.rectangle("fill", (i-1)*chunkW, (j-1)*chunkH, chunkW-1, chunkH-1)
            end

        end
    end
end

--returning the module
return M
