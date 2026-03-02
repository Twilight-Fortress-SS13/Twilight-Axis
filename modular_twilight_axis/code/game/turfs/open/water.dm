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
