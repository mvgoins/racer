

require "controls"
require "views"
require "assets"
require "tracks"

view = "title"
currenttrack = 1

debug = "off"

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
			trackpieces.wall[y][x] = 0
			trackpieces.track[y][x] = 1
			trackpieces.triangleBR[y][x] = 0
			trackpieces.triangleBL[y][x] = 0
			trackpieces.triangleUL[y][x] = 0
			trackpieces.triangleUR[y][x] = 0
		end
	end

	for y = 1,32 do
		for x = 1,y do
			trackpieces.triangleBR[y][33 - x] = 1
		end
	end
			
			
	for y = 1,32 do
		for x = 1,y do
			trackpieces.triangleBL[y][x] = 1
		end
	end
	
	for y = 1,32 do
		for x = 1,33 - y do
			trackpieces.triangleUL[y][x] = 1
		end
	end
	
	for y = 1,32 do
		for x = y,32 do
			trackpieces.triangleUR[y][x] = 1
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
		--print(cartokens[i])
		--print(tracks[currenttrack])
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

					}
		print(" ...finished")
	end -- ending racers building
	
	
	local collisionY = 0
	local collisionX = 0
	local newcol = 0
	local entries = 0
	local rowset = 0
	-- build the collision map
	
	for y = 1, #tracks[currenttrack].layout do
		for newrow = 1,32 do
			tracks[currenttrack].collision[newrow + 32 * (y - 1)] = {}
		end
		--print("collision rows: "..#tracks[currenttrack].collision)
		
		for x = 1, #tracks[currenttrack].layout[y] do
		--print("column row "..x)
			for r = 1,32 do
				for c = 1,32 do

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
		
		keysRacing(dt)
		
		for racer,stats in ipairs(racers) do

			local thiscar = racers[racer] -- makes things easier to type/keep track of
			
			racerSpeed(dt,thiscar) -- speed happens after the racer has adjusted orientation
			
			thiscar.locX = thiscar.locX + thiscar.speed * math.cos(thiscar.orientation - math.pi/2)
			thiscar.locY = thiscar.locY + thiscar.speed * math.sin(thiscar.orientation - math.pi/2)
--			print("ceiling values of x,y is "..math.ceil(thiscar.locX)..","..math.ceil(thiscar.locY))
			

			checkY = math.ceil(thiscar.locY)
			checkX = math.ceil(thiscar.locX)
						
			if tracks[currenttrack].collision[checkY][checkX] == 0 then
				thiscar.orientation = thiscar.orientation + math.pi
			end
					
			-- adjust speed to min/max as very last step	
			if thiscar.speed < 0 then
				thiscar.speed = 0
			end
			
			if thiscar.speed > thiscar.maxspeed then
				thiscar.speed = thiscar.maxspeed
			end
			-- nothing below this line but function ends!			
			
		end
		

		
	end -- end running tracking
		
		

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