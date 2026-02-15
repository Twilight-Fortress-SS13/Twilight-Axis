/obj/effect/proc_holder/spell/invoked/rotting_cloud
	name = "Rotting Cloud"
	desc = "Summons a thick, putrid cloud of rot that infects the air. Those who breathe it will develop miasma in their blood."
	school = "conjuration"
	cost = 3
	chargetime = 20
	range = 7 
	spell_tier = 2
	selection_type = "range"
	releasedrain = 30
	chargedrain = 1
	invocations = list("Permuto!")
	invocation_type = "shout"
	recharge_time = 60 SECONDS
	warnie = "spellwarning"
	no_early_release = TRUE
	movement_interrupt = FALSE
	gesture_required = TRUE
	charging_slowdown = 2
	overlay_state = "animate"
	xp_gain = TRUE
	glow_color = GLOW_COLOR_ARCANE
	glow_intensity = GLOW_INTENSITY_LOW
	chargedloop = /datum/looping_sound/invokegen
	associated_skill = /datum/skill/magic/arcane
	var/phase_effect = /obj/effect/temp_visual/blink
	var/cloud_radius = 2 
	var/pollution_amount = 200 
	var/pollution_cap = 300 
	glow_color = "#3a6600"
	zizo_spell = TRUE

/obj/effect/proc_holder/spell/invoked/rotting_cloud/cast(list/targets, mob/user = usr)
	var/turf/target_turf = get_turf(targets[1])
	
	if(!target_turf)
		return

	playsound(target_turf, 'sound/items/steamrelease.ogg', 75, TRUE)
	
	for(var/turf/open/T in range(cloud_radius, target_turf))
		T.pollute_turf(/datum/pollutant/rot, pollution_amount, pollution_cap)
		
		var/obj/effect/temp_visual/dir_setting/curse/C = new(T)
		C.color = "#3a6600"

	user.visible_message(span_warning("<b>[user]</b> summons a foul-smelling green mist!"), \
						 span_notice("You call forth the spirits of rot to choke the air!"))
	
	return TRUE
