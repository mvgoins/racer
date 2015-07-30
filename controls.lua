

function keysTitle(key)

	if key == "n" then
		player = love.math.random(1,4)
		print("player is number "..player)
		newRace()
		print("race is set up!")
		view = "race"
		print("switch to race")
	end

	if key == "escape" then
		love.event.quit()
	end

end

function keysRace(key)
	if key == "d" then
		debug = "on"
	end
	
	if key == "n" then
		debug = "off"
	end

end

function keysRacing(dt) -- these are the actual movement keys called from love.update, not the static keys from love.keypressed

	local thiscar = racers[player]
	
	if love.keyboard.isDown("z") then
		thiscar.gas = "yes"
	else
		thiscar.gas = "no"
	end
	

	if love.keyboard.isDown("x") then
		thiscar.brake = "yes"
	else
		thiscar.brake = "no"
	end
	
	if love.keyboard.isDown("left") then
		racers[player].orientation = racers[player].orientation - (2 * dt)
	end
	
	if love.keyboard.isDown("right") then
		racers[player].orientation = racers[player].orientation + (2 * dt)
	end
	
end