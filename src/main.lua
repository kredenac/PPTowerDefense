--drzite tab size na 4!!!
--TODO indeksi
function love.load()
	love.window.setTitle("Defense of the Burek")
	defaultWidth, defaultHeight = 1024, 768
	love.window.setMode( defaultWidth, defaultHeight )
	math.randomseed(os.time())
	--ucitavanje modula
	gui = require("gui")
	map = require("map")
	enemy = require("enemy")
	astar = require("astar")

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
	--Ovako bi trebalo da se ispisuje mapa,sto ne radi zbog mesanja indexa, tj loseg generateEmpty
	--Pise da je u mat.mat.height i width kao sto treba da bude, ali to nije stvarno slucaj
-- 	for i=1, map.map.height do
-- 		for j=1, map.map.width do
-- 			io.write(map.map[i][j].val)
-- 			io.write(" ")
-- 		end
-- 		print()
-- 	end


	--astar.print()
end

function love.update(dt)
	enemy.targetEnemies(dt)
	enemy.moveCreeps()

end

function love.draw()
	map.draw()
	enemy.drawRays()
	 -- TODO zar ne treba deo da se pomeri u update

	gui.draw()
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
	   --TODO srediti malo
	   astar.init(map, 1, 19)
	   creep = {}
	   creep.posx=10
	   creep.posy=1
	   path = astar.calculatePath(creep, 1,19)
	--    astar.print()
	   enemy.spawnCreeps(path)
	   --enemy.moveCreeps()
   end

--    if key == "p" then
-- -- 	   io.write(astar.nodes.map.width)
-- 	   	astar.init(map, 1, 19)
-- 	   --astar.heuristic(1,19)
-- 	   for i=1, astar.nodes.height do
-- 		   for j=1, astar.nodes.width do
-- 			   io.write(astar.nodes[i][j].h)
-- 			   io.write(" ")
-- 			end
-- 			print()
-- 	   end
--
-- 	   creep = {}
-- 	   creep.posx=1
-- 	   creep.posy=1
--
-- 	   astar.calculatePath(creep, 1,19)
--
--    end
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
