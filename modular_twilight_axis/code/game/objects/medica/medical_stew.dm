#define MEDICA_COOKING_TIME 60 SECONDS

/datum/container_craft/cooking/medica
	abstract_type = /datum/container_craft/cooking/medica
	crafting_time = MEDICA_COOKING_TIME

/datum/container_craft/cooking/medica/viscera
	name = "viscera decoction"
	requirements = list(/obj/item/alch/viscera = 1)
	created_reagent = /datum/reagent/medicine/viscera

/datum/container_craft/cooking/medica/base_health_brute
	name = "calendula decoction"
	requirements = list(/obj/item/alch/calendula = 1)
	created_reagent = /datum/reagent/medicine/boil/calendula

/datum/container_craft/cooking/medica/base_health_burn
	name = "taraxacum decoction"
	requirements = list(/obj/item/alch/taraxacum = 1)
	created_reagent = /datum/reagent/medicine/boil/taraxacum

/datum/container_craft/cooking/medica/base_health_wound
	name = "leech decoction"
	requirements = list(/obj/item/natural/worms/leech = 1)
	created_reagent = /datum/reagent/medicine/boil/leech

/datum/container_craft/cooking/medica/base_health_blood
	name = "bone meal decoction"
	requirements = list(/obj/item/alch/bonemeal = 1)
	created_reagent = /datum/reagent/medicine/boil/bonedust

/datum/container_craft/cooking/medica/base_health_tox_tobacco
	name = "tobacco decoction"
	requirements = list(/obj/item/alch/tobaccodust = 1)
	created_reagent = /datum/reagent/medicine/boil/leaf

/datum/container_craft/cooking/medica/base_health_tox_swamp
	name = "swampweed decoction"
	requirements = list(/obj/item/alch/swampdust = 1)
	created_reagent = /datum/reagent/medicine/boil/leaf

#undef MEDICA_COOKING_TIME
