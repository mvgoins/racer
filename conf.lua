function love.conf(t)
	t.console = true
	
	t.identity = "racer"
	t.window.title = "RACER"
	
	t.window.resizeable = true
	
	t.window.length = 800
	t.window.height = 800
	
	t.modules.joystick = true
end