tracks = {

	{ -- track 1

		["attributes"] = {
						["orientation"] = 0,
						["starts"] = { -- feel like this could be auto-generated on a per-track basis, but not sure if that's "better"
										{  -- start 1
											["xloc"] = 60,
											["yloc"] = 300,
											
										},

										{  -- start 2
											["xloc"] = 100,
											["yloc"] = 300,
											
										},
																				
										{  -- start 3
											["xloc"] = 60,
											["yloc"] = 350,
											
										},
										
										{  -- start 4
											["xloc"] = 100,
											["yloc"] = 350,
											
										},
									}, -- ending "starts"
									
						}, -- ending "attributes"

		["layout"] = {
		{0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,}, 
		{0, 0, 2, 1, 1, 1, 1, 1, 1, 3, 0, 0,}, 
		{0, 2, 1, 1, 1, 1, 1, 1, 1, 1, 3, 0,}, 
		{0, 1, 1, 1, 4, 0, 0, 5, 1, 1, 1, 0,}, 
		{0, 1, 1, 1, 0, 0, 0, 0, 1, 1, 1, 0,}, 
		{0, 1, 1, 1, 0, 0, 0, 0, 1, 1, 1, 0,}, 
		{0, 1, 1, 1, 0, 0, 0, 0, 1, 1, 1, 0,}, 
		{0, 1, 1, 1, 0, 0, 0, 0, 1, 1, 1, 0,}, 
		{0, 1, 1, 1, 0, 0, 0, 0, 1, 1, 1, 0,}, 
		{0, 1, 1, 1, 0, 0, 0, 0, 1, 1, 1, 0,}, 
		{0, 1, 1, 1, 0, 0, 0, 0, 1, 1, 1, 0,}, -- middle of track
		{0, 1, 1, 1, 0, 0, 0, 0, 1, 1, 1, 0,}, 
		{0, 1, 1, 1, 0, 0, 0, 0, 1, 1, 1, 0,}, 
		{0, 1, 1, 1, 0, 0, 0, 0, 1, 1, 1, 0,}, 
		{0, 1, 1, 1, 0, 0, 0, 0, 1, 1, 1, 0,}, 
		{0, 1, 1, 1, 0, 0, 0, 0, 1, 1, 1, 0,}, 
		{0, 1, 1, 1, 0, 0, 0, 0, 1, 1, 1, 0,}, 
		{0, 1, 1, 1, 3, 0, 0, 2, 1, 1, 1, 0,}, 
		{0, 5, 1, 1, 1, 1, 1, 1, 1, 1, 4, 0,}, 
		{0, 0, 5, 1, 1, 1, 1, 1, 1, 4, 0, 0,}, 
		{0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,}, 
					}, -- ending layout

		["collision"] = {}, -- initialize the table

	}, -- end track 1

} -- end the tracks

trackpieces = {
				["wall"] = {},
				["track"] = {},
				["triangleBR"] = {},
				["triangleBL"] = {},
				["triangleUL"] = {},
				["triangleUR"] = {},

}

carCollisionZones = {}
