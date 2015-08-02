

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
	
	if key == "n" then -- reset all the debug stuff to 'n'ormal
		debugColMap = "off"
		debugColCar = "off"
		drawcars = "on"
	end
	
	if key == "5" then -- how many tiles are collide-able in the collision table
		local colcount = 0
		local colempty = 0
		for y = 1,#tracks[currenttrack].collision do
			for x = 1,#tracks[currenttrack].collision[y] do
				if tracks[currenttrack].collision[y][x] == 1 then
					colcount = colcount + 1
				
				elseif tracks[currenttrack].collision[y][x] == 0 then
					colempty = colempty + 1
				end
				
			end
		end
		print(colcount)
		print(colempty)
	end
					
	if key == "6" then
		local cartablecount = 0
		local cartableempty = 0
		for y = 1,#carCollisionZones do
			for x = 1,#carCollisionZones[y] do
				if carCollisionZones[y][x] > 0 then
					cartablecount = cartablecount + 1
				elseif carCollisionZones[y][x] == 0 then
					cartableempty = cartableempty + 1
				elseif #carCollisionZones[y] == nil then
					print("row "..y.." column "..x.." is empty")
				end
			end
		end
		print("car collision tiles: "..cartablecount)		
		print("entries of 0 in the car collision table: "..cartableempty)
	end
	
end

function keysRacing(dt) -- these are the actual movement keys called from love.update, not the static keys from love.keypressed

	local thiscar = racers[player]
	
	if love.keyboard.isDown("left") then
		thiscar.orientation = thiscar.orientation - (2 * dt)
		--if thiscar.orientation >= 2 * math.pi or thiscar.orientation <= -2 * math.pi then 
		--	thiscar.orientation = 0
		--end
	end
	
	if love.keyboard.isDown("right") then
		thiscar.orientation = thiscar.orientation + (2 * dt)
		--if thiscar.orientation >= 2 * math.pi or thiscar.orientation <= -2 * math.pi then 
		--	thiscar.orientation = 0
		--end
	end

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

	-- debug
	if love.keyboard.isDown("r") then
		thiscar.speed = -1
	end	
	
end