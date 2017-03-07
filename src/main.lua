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
--	updateKeyboard()
end

function love.draw()
	map.draw()
	enemy.drawCreeps()

	enemy.targetEnemies()

	drawMouse()
end

function drawMouse()
	mousex,mousey=love.mouse.getPosition()
	love.graphics.setColor(255,255,255)
	love.graphics.draw(mouseImg, mousex, mousey, 0, 0.5)
end

function updateMouse()
	local x,y = map.mouse()
	local leftClick = love.mouse.isDown(1)
	--kliknuto x,y polje, postavi tu turret
	if leftClick then --jer nema lenjog izracunavanja
		if ( x > 0 and y > 0) then
			map.newTurret(x, y)
		end
	end
	local rightClick = love.mouse.isDown(2)
	if rightClick then
		if ( x > 0 and y > 0 ) then
			map.removeTurret(x, y)
		end
	end
end


--callbacks koje updateuju da li je dugme pritisnuto ili ne

function love.keypressed( key )
   if key == "w" or key == "s" or key == "a" or key == "d" then
      enemy.moveCreeps(key)
   end

   if key == "m" then
	   musicVolume = -musicVolume  + 1
	   print(musicVolume)
	   love.audio.setVolume(musicVolume)
   end

   if key == "escape" then
	   love.event.quit()
   end

   --for testing
   if key == "space" then
	   enemy.spawnCreeps()
   end
end

function love.keyreleased( key )
   if key == "w" then

   end
end

--callback na resize
function love.resize(w, h)
  print(("Window resized to width: %d and height: %d."):format(w, h))
  M.updateSize()
end

function tableSize(tab)
	c = 0
	for k,v in pairs(tab) do
		c = c + 1
	end
	return c
end
