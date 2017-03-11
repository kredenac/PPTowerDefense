local M={}

M.color = {}
M.color.r = 255
M.color.g = 255
M.color.b = 255
M.color.a = 255

M.topBarHeight = 50
M.bottomBarHeight = 150

goldIcon = love.graphics.newImage("img/gold.png")
M.gold = 1000

fireTurretImg = love.graphics.newImage("img/turret.png")
frostTurretImg = love.graphics.newImage("img/frostTurret.png")
enemyImg = love.graphics.newImage("img/enemy.png")
M.buttons = {}
M.buttons[1] = {}
M.buttons[2] = {}
M.buttons[3] = {}
M.buttons[1].img = fireTurretImg
M.buttons[2].img = frostTurretImg
M.buttons[3].img = enemyImg
M.buttons[1].cursor = fireTurretImg
M.buttons[2].cursor = frostTurretImg
M.buttons[3].cursor = enemyImg
M.buttons[1].hover = false
M.buttons[2].hover = false
M.buttons[3].hover = false
-- TODO samo jedan moze biti hoverovan, nema potreba za ovoliko boolova

M.selectedTurretType = 0
buttonMargin = 10
buttonPadding = 10

buttonSize = M.bottomBarHeight - 2 * buttonMargin
buttonInnerSize = buttonSize - 2 * buttonPadding

function drawButton(n,img)
  love.graphics.setColor(55,55,55, 100)
  love.graphics.rectangle("fill", buttonMargin + (n-1)*(buttonSize+buttonMargin),  love.graphics.getHeight() - buttonSize - buttonMargin, buttonSize, buttonSize)

  local scale = 1/(img:getHeight()/buttonInnerSize)

  offsetx =  - (buttonSize/scale - img:getWidth())/2

  local alpha
  if M.buttons[n].hover == true or M.selectedTurretType == n then
    alpha = 255
  else
    alpha = 200
  end
  love.graphics.setColor(255,255,255,alpha)
  love.graphics.draw(img, buttonMargin + (n-1)*(buttonSize+buttonMargin),  love.graphics.getHeight() - buttonSize - buttonMargin + buttonPadding, 0, scale, scale, offsetx, 0)
end

function drawTopBar()
  love.graphics.setColor(M.color.r, M.color.g, M.color.b, M.color.a)
  love.graphics.rectangle("fill", 0, 0, love.graphics.getWidth(), M.topBarHeight)

  local scale = 1/(goldIcon:getHeight()/M.topBarHeight)
  love.graphics.draw(goldIcon, 0 , 0 , 0, scale, scale, 0, 0)
  love.graphics.setColor(155,155,0)
  love.graphics.setNewFont(35)
  love.graphics.print(tostring(M.gold), 50 , 5, 0 )
end

function drawBottomBar()
  love.graphics.setColor(M.color.r, M.color.g, M.color.b, M.color.a)
  love.graphics.rectangle("fill", 0, love.graphics.getHeight() - M.bottomBarHeight, love.graphics.getWidth(), M.bottomBarHeight)
end

function M.draw()
  drawTopBar()
  drawBottomBar()
  for i,_ in pairs(M.buttons) do
    drawButton(i,M.buttons[i].img)
  end
end

function M.mouseMoved(x, y)
    mouseX, mouseY = x, y
    isy = mouseY > love.graphics.getHeight() - buttonSize - buttonMargin and mouseY < love.graphics.getHeight() - buttonMargin
    for i=1, 3 do
        isx = mouseX > buttonMargin + (i-1)*(buttonSize+buttonMargin) and mouseX < (i)*(buttonSize+buttonMargin)
        if isx and isy then
            M.buttons[i].hover = true
        else
            M.buttons[i].hover = false
        end
    end
end

function M.mousePressed(x, y, button)
    mouseX, mouseY = x, y
    isy = mouseY > love.graphics.getHeight() - buttonSize - buttonMargin and mouseY < love.graphics.getHeight() - buttonMargin
    for i=1, 3 do
        isx = mouseX > buttonMargin + (i-1)*(buttonSize+buttonMargin) and mouseX < (i)*(buttonSize+buttonMargin)

        if isx and isy then
            M.buttons[i].hover = true
            local leftClick = button == 1
            if leftClick == true then
                M.selectedTurretType = i
            end
        else
            M.buttons[i].hover = false
        end
    end
    --ako je kliknuto nesto sto nije turret
    if M.selectedTurretType ~= 1 and M.selectedTurretType ~=2 then
        M.selectedTurretType = 0
    end
end

return M
