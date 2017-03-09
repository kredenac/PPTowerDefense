local M={}

M.color = {}
M.color.r = 255
M.color.g = 255
M.color.b = 255
M.color.a = 255

M.topBarHeight = 50
M.bottomBarHeight = 150

ButtonImg = love.graphics.newImage("img/turret.png")
ButtonImg2 = love.graphics.newImage("img/frostTurret.png")
ButtonImg3 = love.graphics.newImage("img/enemy.png")
M.buttons = {}
M.buttons[1] = {}
M.buttons[2] = {}
M.buttons[3] = {}
M.buttons[1].img = ButtonImg
M.buttons[2].img = ButtonImg2
M.buttons[3].img = ButtonImg3
M.buttons[1].cursor = ButtonImg
M.buttons[2].cursor = ButtonImg2
M.buttons[3].cursor = ButtonImg3
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

  scale = 1/(img:getHeight()/buttonInnerSize)

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

function M.mouse()
    mouseX, mouseY = love.mouse.getPosition()
    isy = mouseY > love.graphics.getHeight() - buttonSize - buttonMargin and mouseY < love.graphics.getHeight() - buttonMargin
    for i=1 , 3 do
        isx = mouseX > buttonMargin + (i-1)*(buttonSize+buttonMargin) and mouseX < (i)*(buttonSize+buttonMargin)
        --TODO promeni za klik i ulepsaj
        if isx and isy and (i==1 or i==2) then
            M.buttons[i].hover = true
            local leftClick = love.mouse.isDown(1)
            if leftClick == true then
              if M.selectedTurretType == i then
                -- M.selectedTurretType = 0
                -- FIXME Da ne bi treptalo stoji i umesto 0. Promeni kad prebacis u callback
                M.selectedTurretType = i
              else
                M.selectedTurretType = i
              end
            end
        else
            M.buttons[i].hover = false
        end
    end
    --TODO nek radi selectovanje clickom
    return selectedX, selectedY
end

return M
