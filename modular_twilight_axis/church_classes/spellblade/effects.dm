/obj/effect/noctite_select_weapon
	name = "select_weapon"
	icon = 'modular_twilight_axis/church_classes/icons/prismatic_weapons64.dmi'
	icon_state = "moonlight_saber"
	layer = ABOVE_ALL_MOB_LAYER
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	alpha = 20
	pixel_w = -48
	pixel_z = -48

/obj/effect/noctite_select_weapon/Initialize()
	. = ..()
	animate(src, transform = matrix()*0.01, time = 2 SECONDS, flags = ANIMATION_PARALLEL, easing = SINE_EASING)
	animate(src, pixel_x = 64, time = 0.45 SECONDS, flags = ANIMATION_PARALLEL, easing = SINE_EASING)
	animate(src, pixel_y = 64, time = 0.45 SECONDS, flags = ANIMATION_PARALLEL, easing = SINE_EASING, delay = 0.3 SECONDS)
	animate(src, pixel_x = 16, time = 0.45 SECONDS, flags = ANIMATION_PARALLEL, easing = SINE_EASING, delay = 0.45 SECONDS)
	animate(src, pixel_y = 16, time = 0.45 SECONDS, flags = ANIMATION_PARALLEL, easing = SINE_EASING, delay = 0.75 SECONDS)
	animate(src, pixel_x = 32, time = 0.1 SECONDS, flags = ANIMATION_PARALLEL, easing = SINE_EASING, delay = 0.9 SECONDS)
	animate(src, pixel_y = 32, time = 0.1 SECONDS, flags = ANIMATION_PARALLEL, easing = SINE_EASING, delay = 1.05 SECONDS)
	animate(src, alpha = 127, time = 0.1 SECONDS, flags = ANIMATION_PARALLEL, easing = SINE_EASING)
	animate(src, alpha = 10, time = 0.8 SECONDS, flags = ANIMATION_PARALLEL, easing = SINE_EASING, delay = 1 SECONDS)
	
	QDEL_IN_CLIENT_TIME(src, 2 SECONDS)
