//all unigue scrap items - here

/obj/item/flashlight/flare/torch/lantern/scrap
	name = "iron scrap lamptern"
	icon_state = "lamp"
	icon = 'modular_twilight_axis/icons/roguetown/items/lighting.dmi'
	desc = "A light to guide the way."
	light_outer_range = 5
	on = FALSE
	flags_1 = CONDUCT_1
	slot_flags = ITEM_SLOT_HIP
	obj_flags = CAN_BE_HIT
	force = 1
	on_damage = 5
	fuel = 120 MINUTES
	should_self_destruct = FALSE
	grid_width = 32
	grid_height = 64
	extinguishable = FALSE
	weather_resistant = TRUE
	experimental_onhip = FALSE
