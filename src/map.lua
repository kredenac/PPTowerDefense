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

-- slicno za hover
M.colorHover = {}
M.colorHover.r = 0
M.colorHover.g = 170
M.colorHover.b = 170

-- Generise praznu mapu, logicno
-- postavlja chunkW i chunkH, sto je visina i sirina svakog pravougaonika
-- TODO screen width i height verovatno treba da se stave na neko globalnije mesto

function M.generateEmpty(width,height)
  for i=1,width do
    M.map[i] = {}
    for j=1,height do
      M.map[i][j] = {}
      M.map[i][j].val = 0
      M.map[i][j].hover = 0
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
-- TODO optimizovati verovatno, akcija na klik, mozda razdvojiti u fje
function M.mouse()
	mouseX, mouseY = love.mouse.getPosition()
  for i=1 , M.map.width do
    for j=1 , M.map.height do
      isx = mouseX > (i-1)*chunkW and mouseX < i*chunkW
    	isy = mouseY > (j-1)*chunkH and mouseY < j*chunkH
      if isx and isy then
        M.map[i][j].hover = true
      else
        M.map[i][j].hover = false
      end
    end
  end
end

-- Iscrtava mapu, logicno
function M.draw()
  for i=1 , M.map.width do
    for j=1 , M.map.height do
      if M.map[i][j].hover == false then
        love.graphics.setColor(M.color.r, M.color.g, M.color.b)
      else
        love.graphics.setColor(M.colorHover.r, M.colorHover.g, M.colorHover.b)
      end
      love.graphics.rectangle("fill", (i-1)*chunkW, (j-1)*chunkH, chunkW-1, chunkH-1)
    end
  end
end

--returning the module
return M
