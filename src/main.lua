--drzite tab size na 4
--nije mnogo bitno, al slike su u /src/img
--al ne znam da ih stavim van src a da ih ucitam

--kolko vidim kad se crta slicica mora da se postavi boja na
--belu da bi lepo iscrtalo
function love.load()
	love.window.setTitle("Placeholder")
	defaultWidth, defaultHeight = 800, 600
	love.window.setMode( defaultWidth, defaultHeight )


	--ucitavanje modula
	map=require("map")
	enemy=require("enemy")
	map.generateEmpty(15,10)

	--set mouse
	love.mouse.setVisible(false)
  	mouseImg = love.graphics.newImage("img/mouse_cursor.png")
	music = love.audio.newSource("img/music.mp3")
	--music:play() --pod comm je da ne slusamo stalno dok pravimo
	musicVolume = 1

end

function love.update(dt)
	updateMouse()
	updateKeyboard()
end


function love.draw()
	map.draw()
	enemy.drawCreeps()
	drawMouse()
end

function drawMouse()
	mousex,mousey=love.mouse.getPosition()
	love.graphics.setColor(255,255,255)
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

	--for testing
	if love.keyboard.isDown("space") then
		enemy.spawnCreeps()
	end
end

--callbacks koje updateuju da li je dugme pritisnuto ili ne

function love.keypressed( key )
   if key == "w" then
      text = "w is being pressed!"
	  print(text)
   end

   if key == "m" then
	   musicVolume = -musicVolume  + 1
	   print(musicVolume)
	   love.audio.setVolume(musicVolume)
   end
end

function love.keyreleased( key )
   if key == "w" then
      text = "w has been released!"
	  print(text)
   end
end

--callback na resize
function love.resize(w, h)
  print(("Window resized to width: %d and height: %d."):format(w, h))
  M.updateSize()
end
