function love.load()
	--ucitavanje modula test.
	t=require("map")
end

function love.update(dt)

end


function love.draw()
	t.ispis()
end
