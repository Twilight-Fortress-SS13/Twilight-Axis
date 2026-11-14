////////////////////////////////////////////
/obj/item/alch
	resistance_flags = FLAMMABLE
	max_integrity = 30
	var/datum/pollutant/smoke/smoke_type

////////////////////////////////////////////
/obj/item/natural/worms/leech
	resistance_flags = FLAMMABLE
	var/datum/pollutant/smoke/smoke_type

////////////////////////////////////////////
/obj/item/seeds
	max_integrity = 30

////////////////////////////////////////////

/obj/item/alch/viscera
	smoke_type = /datum/pollutant/smoke/viscera

/datum/pollutant/smoke/viscera
	reagent = /datum/reagent/medicine/viscera
	color = "#d05555"

//----------------------------------------//

/obj/item/alch/bonemeal
	smoke_type = /datum/pollutant/smoke/bonedust

/datum/pollutant/smoke/bonedust
	reagent = /datum/reagent/medicine/boil/bonedust
	color = "#a18888"
//----------------------------------------//

/obj/item/alch/swampdust
	smoke_type = /datum/pollutant/smoke/leaf

/datum/pollutant/smoke/leaf
	reagent = /datum/reagent/medicine/boil/leaf
	color = "#3f6239"
//----------------------------------------//

/obj/item/alch/tobaccodust
	smoke_type = /datum/pollutant/smoke/leaf

/datum/pollutant/smoke/leaf
	reagent = /datum/reagent/medicine/boil/leaf
	color = "#3f6239"

//----------------------------------------//

/obj/item/alch/calendula
	smoke_type = /datum/pollutant/smoke/calendula

/datum/pollutant/smoke/calendula
	reagent = /datum/reagent/medicine/boil/calendula
	color = "#e47a24"

//----------------------------------------//
/obj/item/alch/taraxacum
	smoke_type = /datum/pollutant/smoke/taraxacum

/datum/pollutant/smoke/taraxacum
	reagent = /datum/reagent/medicine/boil/taraxacum
	color = "#e3e342"

//----------------------------------------//
/obj/item/natural/worms/leech
	smoke_type = /datum/pollutant/smoke/leech

/datum/pollutant/smoke/leech
	reagent = /datum/reagent/medicine/boil/leech
	color = "#5c4a86"

//----------------------------------------//
/obj/item/alch/ozium
	smoke_type = /datum/pollutant/smoke/ozium

/datum/pollutant/smoke/ozium
	reagent = /datum/reagent/ozium

//----------------------------------------//

/obj/item/alch/firedust/fire_act()
	explosion(get_turf(src), -1, 1, 2, 4, 0, flame_range = 2)
	qdel(src)

/obj/item/alch/coaldust/fire_act()
	explosion(get_turf(src), -1, 0, 2, 3, 0, flame_range = 1)
	qdel(src)

/obj/item/proc/create_cloud(cloud_reagent, item, campfire)
	var/turf/S = get_turf(campfire)
	for(var/turf/open/T in range(1, S))
		T.pollute_turf(cloud_reagent, 100, 200)
	qdel(item)

/datum/pollutant/smoke
	name = "Smoke"
	pollutant_flags = POLLUTANT_APPEARANCE|POLLUTANT_SMELL|POLLUTANT_BREATHE_ACT
	smell_intensity = 1
	descriptor = "smell"
	scent = ""
	color = "#bebebe"
	var/reagent = null
	var/reagent_count = 5

/datum/pollutant/smoke/breathe_act(mob/living/carbon/victim, amount, total_amount)
	. = ..()
	if(victim.wear_mask)
		var/obj/item/mask = victim.wear_mask
		if(!mask.gas_transfer_coefficient)
			return
		if((3 / victim.wear_mask.gas_transfer_coefficient) >= amount)
			return
	if(reagent == /datum/reagent/ozium)
		reagent_count = 1
	if(amount > 3 && (amount / total_amount >= 0.25))
		victim.reagents?.add_reagent(reagent, reagent_count)
