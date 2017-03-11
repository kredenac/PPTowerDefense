--drzite tab size na 4!!!
function love.load()
	love.window.setTitle("Defense of the Burek")
	defaultWidth, defaultHeight = 1024, 768
	love.window.setMode( defaultWidth, defaultHeight )
	math.randomseed(os.time())
	--ucitavanje modula
	gui = require("gui")
	map = require("map")
	enemy = require("enemy")

	numRocks = 19
	map.generateEmpty(19,10, numRocks)

	love.mouse.setVisible(false)
	defaultCursor = love.graphics.newImage("img/mouse_cursor.png")
	mouseImg = defaultCursor

	music = love.audio.newSource("img/music.mp3")
	music:play()
	musicVolume = 0 --da ne slusamo stalno
	love.audio.setVolume(musicVolume)
	love.keyboard.setKeyRepeat(true)
	love.graphics.setLineWidth(5)
	randomMovementOn = true
end

function love.update(dt)
	if randomMovementOn then
		moveRandom()
	end
end

moves = {}
function moveRandom()
	local move = {"w", "s", "a", "d"}
	if moves[1]==nil then
		local go = move[math.random(4)]
		local times = math.random(10) + 3
		for i=1,times do
			table.insert(moves, go)
		end
	end
	enemy.moveCreeps(table.remove(moves))
end

function love.draw()
	gui.draw()
	map.draw()
	enemy.drawCreeps()

	enemy.targetEnemies()

	drawMouse(mouseImg)
end

function drawMouse(mouseImg)
	mousex,mousey=love.mouse.getPosition()
	love.graphics.setColor(255,255,255)
	love.graphics.draw(mouseImg, mousex, mousey, 0, 0.5)
end

function love.mousemoved(x, y, dx, dy, istouch)
	gui.mouseMoved(x, y)
	map.mouse(x, y)
end

function love.mousepressed(x, y, button, istouch)
	gui.mousePressed(x, y, button)
	if gui.selectedTurretType ~= 0 then
		mouseImg = gui.buttons[gui.selectedTurretType].cursor
	else
		mouseImg = defaultCursor
	end

	local x, y = map.mouse(x, y)
	local leftClick = button == 1
	--kliknuto x,y polje, postavi tu turret
	if leftClick then --jer nema lenjog izracunavanja
		if ( x > 0 and y > 0) then
			map.newTurret(x, y, gui.selectedTurretType)
		end
	end
	local rightClick = button == 2
	if rightClick then
		if ( x > 0 and y > 0 ) then
			map.removeTurret(x, y)
		end
	end
end

function updateMouse()
	gui.mouse()
	if gui.selectedTurretType ~= 0 then
		mouseImg = gui.buttons[gui.selectedTurretType].cursor
	else
		mouseImg = defaultCursor
	end

	local x,y = map.mouse()
	local leftClick = love.mouse.isDown(1)
	--kliknuto x,y polje, postavi tu turret
	if leftClick then --jer nema lenjog izracunavanja
		if ( x > 0 and y > 0) then
			map.newTurret(x, y, gui.selectedTurretType)
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
	if key == "r" then
		randomMovementOn = not randomMovementOn
		if randomMovementOn then
			enemy.step = 0.1
		else
			enemy.step = 0.33
		end
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
	map.updateSize()
end

function tableSize(tab)
	c = 0
	for k,v in pairs(tab) do
		c = c + 1
	end
	return c
end
