--drzite tab size na 4
--nije mnogo bitno, al slike su u /src/img
--al ne znam da ih stavim van src a da ih ucitam
function love.load()
	--ucitavanje modula map
	map=require("map")
	map.generateEmpty(15,17)
	--set mouse
	love.mouse.setVisible(false)
  	mouseImg = love.graphics.newImage("img/mouse_cursor.png")
	--turret
	turretImg = love.graphics.newImage("img/turret.png")
end

function love.update(dt)
	updateMouse()
	updateKeyboard()
end


function love.draw()
	map.draw()
	drawMouse()
end

function drawMouse()
	mousex,mousey=love.mouse.getPosition()
	love.graphics.draw(mouseImg, mousex, mousey, 0, 0.5)
end

function updateMouse()
	local x,y = map.mouse()
	local down = love.mouse.isDown(1)
	--kliknuto x,y polje, postavi tu turret
	if (down and x > 0 and y > 0 and map.map[x][y].val == map.const.empty) then
		map.map[x][y].val = map.const.turret
	end
end

function updateKeyboard()
	if love.keyboard.isDown("escape") then
		love.event.quit()
	end
end
