function love.load()
	--ucitavanje modula test.
	map=require("map")

	map.generateEmpty(15,17)
end

function love.update(dt)
	map.mouse()
end


function love.draw()
	map.draw()
end
