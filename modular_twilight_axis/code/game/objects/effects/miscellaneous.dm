/obj/effect/temp_visual/small_smoke/gunsmoke
	layer = FLY_LAYER
	plane = GAME_PLANE_UPPER
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT

/obj/effect/temp_visual/small_smoke/gunsmoke/Initialize(mapload, set_dir)
	. = ..()
	if(set_dir)
		dir = set_dir
	var/matrix/M = matrix()
	M.Turn(rand(-45, 45))
	M.Scale(rand(11, 16) / 10)
	var/drift_x = 0
	var/drift_y = 0
	switch(dir)
		if(NORTH)
			drift_y = rand(8, 16)
			drift_x = rand(-8, 8)
		if(SOUTH)
			drift_y = rand(-16, -8)
			drift_x = rand(-8, 8)
		if(EAST)
			drift_x = rand(8, 16)
			drift_y = rand(-8, 8)
		if(WEST)
			drift_x = rand(-16, -8)
			drift_y = rand(-8, 8)
			
	M.Translate(drift_x, drift_y)
	spawn(1)
		if(src)
			animate(src, transform = M, alpha = 0, time = rand(10, 15), easing = SINE_EASING | EASE_OUT)
			spawn(20)
				if(src)
					qdel(src)