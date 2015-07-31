
function viewTitle()

	love.graphics.printf("RACER",0,200,800)
	
	love.graphics.printf("[N]ew Game",0,225,800)
	
end

function viewRace()

	local carscale = 1

 -- draws the tiles -- this needs a transformation to match up with collision map
	if currenttrack == 1 then
		for y = 1, #tracks[currenttrack].layout do
			for x = 1,#tracks[currenttrack].layout[y] do
				local xspot = 0 + 32 * (x - 1)
				local yspot = 0 + 32 * (y - 1)
				local tile = tracks[currenttrack].layout[y][x]
				love.graphics.draw(wall,xspot,yspot)
				
				if tile == 1 then
					love.graphics.draw(track,xspot,yspot)
				elseif tile >= 2 and tile <=5 then
					love.graphics.draw(curvepieces[tile],xspot,yspot)
				end
			end
		end
	end 
	
	-- collision debug block
	if debugColMap == "on" then
		for y = 1,#tracks[currenttrack].collision do
			for x = 1,#tracks[currenttrack].collision[y] do
					local xspot = x -- 200 + x
					local yspot = y -- 0 + y		
				thistile = tracks[currenttrack].collision[y][x]
				if thistile == 0 then
					love.graphics.setColor(colordarkgrey)
					love.graphics.rectangle("fill",xspot,yspot,1,1)
					love.graphics.setColor(colorwhite)
				elseif thistile == 1 then
					love.graphics.setColor(colorgrey)
					love.graphics.rectangle("fill",xspot,yspot,1,1)
					love.graphics.setColor(colorwhite)
				end
			end
		end	
	end
	
	if debugColCar == "on" then
		for y = 1,#carCollisionZones do
			for x = 1,#carCollisionZones[y] do
				local thistile = carCollisionZones[y][x]
				if thistile ~= 0 then
					if thistile == 1 then
						love.graphics.setColor(colorred)
						love.graphics.rectangle("fill",x,y,1,1)
					elseif thistile == 2 then
						love.graphics.setColor(colorblue)
						love.graphics.rectangle("fill",x,y,1,1)
					elseif thistile == 3 then
						love.graphics.setColor(colorgreen)
						love.graphics.rectangle("fill",x,y,1,1)
					elseif thistile == 4 then
						love.graphics.setColor(coloryellow)
						love.graphics.rectangle("fill",x,y,1,1)
					end
				end
			end
		end
		love.graphics.setColor(colorwhite)
		
		local thiscar = racers[player]
		local colmap = tracks[currenttrack].collision
		local xcount = 0
		local ycount = 0
		for y = -9,10 do
			ycount = ycount + 1
			xcount = 0
			for x = -9,10 do
				xcount = xcount + 1
				local checkx = math.floor(thiscar.locX + x)
				local checky = math.floor(thiscar.locY + y)
				if colmap[checky][checkx] == 1 then
					love.graphics.setColor(colorred)
				end
				if y >= -7 and y <=8 then
					if x >= -7 and x <= 8 then
						love.graphics.setColor(colorblue)
					end
				end
				love.graphics.print(colmap[checky][checkx],400 + 10 * xcount,100 + 10 * ycount)
				love.graphics.setColor(colorwhite)
			end
		end
	end
					
	--[[ debug for testing block maps
	for y = 1,#trackpieces.triangleBR do
		for x = 1,#trackpieces.triangleBR[y] do
			if trackpieces.triangleBR[y][x] == 0 then
				love.graphics.setColor(colordarkgrey)
			end
			love.graphics.rectangle("fill",200 + x,y - 1,1,1)
			love.graphics.setColor(colorwhite)
		end
	end --]]
	
	-- end debug block
	
	if drawcars == "on" then -- debug code
	
	for racer,stats in ipairs(racers) do -- draw some race cars!
		local thiscar = racers[racer]
		love.graphics.draw(thiscar.color,thiscar.locX,thiscar.locY,thiscar.orientation,carscale,carscale,16,20)
		
		if thiscar.speed >= 0.5 then
			love.graphics.draw(zoom1,thiscar.locX,thiscar.locY,thiscar.orientation,carscale,carscale,16,20)
		end
		
		if thiscar.speed >= 1.5 then
			love.graphics.draw(zoom2,thiscar.locX,thiscar.locY,thiscar.orientation,carscale,carscale,16,20)
		end		
		
	end
	
	end -- end the "if drawcars" check

	if raceStatus == "starting" then
		love.graphics.print("STARTING IN: "..math.ceil(countdown),50,125)
	end

	love.graphics.print("speed: "..racers[player].speed,10,10)
	love.graphics.print("gas: "..racers[player].gas,10,25)
	love.graphics.print("brake: "..racers[player].brake,10,40)
	love.graphics.print("orientation "..racers[player].orientation,10,55)
	love.graphics.print("real X: "..racers[player].locX,400,0)
	love.graphics.print("ceiling X: "..math.ceil(racers[player].locX),400,15)
	love.graphics.print("real Y: "..racers[player].locY,400,30)
	love.graphics.print("ceiling Y: "..math.ceil(racers[player].locY),400,45)

end

