

require "controls"
require "views"
require "assets"
require "tracks"

view = "title"
currenttrack = 1

debugColMap = "off"
debugColCar = "off"
drawcars = "on"

function love.load()
end

racers = {}
participants = 4
player = nil
raceStatus = "none"
countdown = 0

function trackBlocks() -- took longer to do it this way than by hand, but WHATEVER

	for y = 1,32 do
		trackpieces.wall[y] = {}
		trackpieces.track[y] = {}
		trackpieces.triangleBR[y] = {}
		trackpieces.triangleBL[y] = {}
		trackpieces.triangleUL[y] = {}
		trackpieces.triangleUR[y] = {}

		for x = 1,32 do
			trackpieces.track[y][x] = 0 -- track is passable

			trackpieces.wall[y][x] = 1 -- not passable
			trackpieces.triangleBR[y][x] = 1
			trackpieces.triangleBL[y][x] = 1
			trackpieces.triangleUL[y][x] = 1
			trackpieces.triangleUR[y][x] = 1
		end
	end

	for y = 1,32 do
		for x = 1,y do
			trackpieces.triangleBR[y][33 - x] = 0 -- build passable space
		end
	end
			
			
	for y = 1,32 do
		for x = 1,y do
			trackpieces.triangleBL[y][x] = 0
		end
	end
	
	for y = 1,32 do
		for x = 1,33 - y do
			trackpieces.triangleUL[y][x] = 0
		end
	end
	
	for y = 1,32 do
		for x = y,32 do
			trackpieces.triangleUR[y][x] = 0
		end
	end
			
end

function newRace()

	thistrack = tracks[currenttrack]
		
	trackBlocks() -- this shouldn't happen here, it should be in love.load or such
	
	
	print("starting the setup")
	racers = {}
	print("emptied the racer table")
	for i = 1,participants do -- build the table of racers
		print("Racer "..i)
		racers[i] = {
						["color"] = cartokens[i],
						["locX"] = tracks[currenttrack].attributes.starts[i].xloc,
						["locY"] = tracks[currenttrack].attributes.starts[i].yloc,
						["isPlayer"] = "no",
						["orientation"] = tracks[currenttrack].attributes.orientation,
						["speed"] = 0,
						["maxspeed"] = 2,
						["gas"] = "no",
						["brake"] = "no",
						["lap"] = 1,
						["maxlap"] = 3,
						["collisionmarker"] = i,
						["didhit"] = "no",
					}
		print(" ...finished")
	end -- ending racers building
	
	-- build the collision map
	for y = 1, #tracks[currenttrack].layout do
		for newrow = 1,32 do
			tracks[currenttrack].collision[newrow + 32 * (y - 1)] = {}
			--carCollisionZones[newrow + 32 * (y - 1)] = {}
		end
		--print("collision rows: "..#tracks[currenttrack].collision)
		
		for x = 1, #tracks[currenttrack].layout[y] do
		--print("column row "..x)
			for r = 1,32 do
				for c = 1,32 do
					--carCollisionZones[r + 32 * (y - 1)][c + 32 * (x - 1)] = 0
					if thistrack.layout[y][x] == 0 then
						thistrack.collision[r + 32 * (y - 1)][c + 32 * (x - 1)] = trackpieces.wall[r][c]

					elseif thistrack.layout[y][x] == 1 then
						thistrack.collision[r + 32 * (y - 1)][c + 32 * (x - 1)] = trackpieces.track[r][c]

					elseif thistrack.layout[y][x] == 2 then
						thistrack.collision[r + 32 * (y - 1)][c + 32 * (x - 1)] = trackpieces.triangleBR[r][c]
					
					elseif thistrack.layout[y][x] == 3 then
						thistrack.collision[r + 32 * (y - 1)][c + 32 * (x - 1)] = trackpieces.triangleBL[r][c]
					
					elseif thistrack.layout[y][x] == 4 then
						thistrack.collision[r + 32 * (y - 1)][c + 32 * (x - 1)] = trackpieces.triangleUL[r][c]
					
					elseif thistrack.layout[y][x] == 5 then
						thistrack.collision[r + 32 * (y - 1)][c + 32 * (x - 1)] = trackpieces.triangleUR[r][c]
					
					end
				end
			end
		end
	end

	racers[player].isPlayer = "yes"
	
	countdown = 3
	raceStatus = "starting"
	

end



function love.update(dt)

	local thistrack = tracks[currenttrack]

	if raceStatus == "starting" then
		countdown = countdown - dt
		if countdown <= 0 then
			raceStatus = "running"
		end
	end

	if raceStatus == "running" then -- main action happens here -- break out into separate function(s) for clarity?
		
		keysRacing(dt) -- accept all key inputs first
		
		-- reset the car collision table
		for y = 1, #tracks[currenttrack].layout do
			for newrow = 1,32 do
				carCollisionZones[newrow + 32 * (y - 1)] = {}
			end
			
			for x = 1, #tracks[currenttrack].layout[y] do
				for r = 1,32 do
					for c = 1,32 do
						carCollisionZones[r + 32 * (y - 1)][c + 32 * (x - 1)] = 0				
					end
				end
			end
		end
		
		-- update the car collision table
		for racer,stats in ipairs(racers) do
			local thiscar = racers[racer] -- makes things easier to type/keep track of

			for y = -7,8 do
				for x = -7,8 do
					local carcolY = math.floor(thiscar.locY + y)
					local carcolX = math.floor(thiscar.locX + x)
					carCollisionZones[carcolY][carcolX] = racers[racer].collisionmarker
				end
			end
		end -- moving this for now?
		
		for racer,stats in ipairs(racers) do

			local thiscar = racers[racer] -- makes things easier to type/keep track of
			thiscar.didhit = "no"
			
			-- have the computer racers adjust orientation and gas/brake
			if thiscar.isPlayer == "no" then
			end	
			

			-- give the car a new speed
			racerSpeed(dt,thiscar) -- speed happens after the racer has adjusted orientation
			
			-- set the future x and y values the car is trying to move into
			local newX = thiscar.locX + thiscar.speed * math.cos(thiscar.orientation - math.pi/2) -- I forget why this. to offset the 0 = 90 orientation?
			local newY = thiscar.locY + thiscar.speed * math.sin(thiscar.orientation - math.pi/2)
			
			-- round those values so that you can check them against tables
			local checkY = math.ceil(newX) -- NOTE: you need to math.floor or .ceil the location values if you're going to match them on a table!
			local checkX = math.ceil(newY) -- NOTE: otherwise you throw an error every time you try and move the car (because there are no fractional array points)
			
			-- did you hit something?
			local me = thiscar.collisionmarker
			
			for y = -7,8 do
				for x = -7,8 do
					if thistrack.collision[checkY + y][checkX + x] == 1 then
						print("hit at "..checkX + x..","..checkY + y)
						print("the hit tile was a "..thistrack.collision[checkY + y][checkX + x])
						print("car orientation was "..thiscar.orientation)
						print("car speed was "..thiscar.speed)
						thiscar.orientation = thiscar.orientation + math.pi -- original, simple rebound ..uh, not working right now?
						thiscar.speed = thiscar.speed * 0.75
						thiscar.didhit = "yes"
						print("new car orientation is "..thiscar.orientation)
						print("new car speed is "..thiscar.speed)
					end					
			
				
					if carCollisionZones[checkY + y][checkX + x] ~= 0 and carCollisionZones[checkY + y][checkX + x] ~= me then
						print("hit a car!")
						print("checking "..checkY + y..","..checkX + x)
						print(#carCollisionZones)
						print(#carCollisionZones[checkY + y][checkX + x])
						local target = carCollisionZones[checkY + y][checkX + x]
						print("hit car number "..target)
						racers[target].speed = racers[target].speed + 0.25 * thiscar.speed
						thiscar.speed = thiscar.speed * 0.90
						thiscar.didhit = "yes"
						print("hit resolved")
					end
				end
			end -- end collision checks 

			-- has there been an orientation change? if so, recalculate newX, newY
			if thiscar.didhit == "yes" then 
				newX = thiscar.locX + thiscar.speed * math.cos(thiscar.orientation - math.pi/2)
				newY = thiscar.locY + thiscar.speed * math.sin(thiscar.orientation - math.pi/2)
			end
			
			-- moving the car
			thiscar.locX = newX
			thiscar.locY = newY
					
			-- adjust speed to min/max as very last step	
			if thiscar.speed < 0 then
				thiscar.speed = 0
			end
			
			if thiscar.speed > thiscar.maxspeed then
				thiscar.speed = thiscar.maxspeed
			end
			-- nothing below this line but function ends!			
			
		end -- ending the ipairs(racers) updates
		

		
	end -- end race updates
		
		

end


function racerSpeed(dt,thiscar)
	

	if thiscar.gas == "yes" then
		if thiscar.speed < thiscar.maxspeed then
			thiscar.speed = thiscar.speed + dt
		end
	elseif thiscar.gas == "no" and thiscar.speed > 0 then
		thiscar.speed = thiscar.speed - dt
	end
	
	if thiscar.brake == "yes" and thiscar.speed > 0 then
		thiscar.speed = thiscar.speed - (2 * dt)
	end
	
end




function love.draw()

	if view == "title" then
		viewTitle()
	
	elseif view == "race" then
		viewRace()
	end
	
end



function love.keypressed(key)

	if view == "title" then
		keysTitle(key)
	
	elseif view == "race" then
		keysRace(key)
	end
	
end