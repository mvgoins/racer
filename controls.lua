

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
	if key == "1" then
		if debugColMap == "off" then
			debugColMap = "on"
		else
			debugColMap = "off"
		end
	end
	
	
	if key == "2" then
		if debugColCar == "off" then
			debugColCar = "on"
		else
			debugColCar = "off"
		end
	end
	
	if key == "c" then
		if drawcars == "off" then
			drawcars = "on"
		else
			drawcars = "off"
		end
	end
	
	if key == "n" then
		debugColMap = "off"
		debugColCar = "off"
		drawcars = "on"
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