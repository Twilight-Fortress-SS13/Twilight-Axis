//Healing springs.
//Intended for deep dungeon / hidden areas.
/turf/open/water/ocean/deep/thermalwater
	name = "healing hot spring"
	desc = "A warm spring with gentle ripples. Standing here soothes your body."
	icon = 'icons/turf/roguefloor.dmi'
	icon_state = "together"
	water_color = "#23b9df"
	water_reagent = /datum/reagent/water
	var/heal_interval = 5 SECONDS
	var/heal_amount = 20
	var/last_heal = 0

/turf/open/water/ocean/deep/thermalwater/Initialize()
	. = ..()
	START_PROCESSING(SSobj, src)

/turf/open/water/ocean/deep/thermalwater/process()
	if(world.time < last_heal + heal_interval)
		return

	for(var/mob/living/carbon/M in src)
		if(M.stat == DEAD) continue

		if(M.getBruteLoss())
			M.adjustBruteLoss(-heal_amount)
		if(M.getFireLoss())
			M.adjustFireLoss(-heal_amount)
		if(M.getToxLoss())
			M.adjustToxLoss(-heal_amount)
		if(M.getOxyLoss())
			M.adjustOxyLoss(-heal_amount*2)

//Someone else can put this on a timer. I can't be bothered.
//		M.visible_message(span_notice("[M] looks a bit better after soaking in the spring."))

	last_heal = world.time


/turf/open/water/ocean/deep/scaldingwater
	name = "Magic flow"
	desc = "The water is boiling and steaming. It looks like it could energize you, if you can survive the heat."
	icon = 'icons/turf/roguefloor.dmi'
	icon_state = "acid"
	water_color = "#ff7f50"
	water_reagent = /datum/reagent/water
	

	var/tick_interval = 2 SECONDS 
	var/energy_gain = 35 
	var/fire_damage = 5 
	var/last_tick = 0

/turf/open/water/ocean/deep/scaldingwater/Initialize()
	. = ..()
	START_PROCESSING(SSobj, src)

/turf/open/water/ocean/deep/scaldingwater/Destroy()
	STOP_PROCESSING(SSobj, src)
	return ..()

/turf/open/water/ocean/deep/scaldingwater/process()
	if(world.time < last_tick + tick_interval)
		return

	for(var/mob/living/carbon/M in src)
		if(M.stat == DEAD) 
			continue

		M.adjustFireLoss(fire_damage)
		
		M.energy_add(energy_gain)

		if(prob(5))
			to_chat(M, span_danger("The water sears your flesh, but adrenaline rushes through you!"))
			M.emote("gasp")

	last_tick = world.time
