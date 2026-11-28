/obj/item/reagent_containers/food/snacks/metal
	name = "iron wafers"
	desc = "Thin, crisp metal wafers, forged for a Fluvian feast."
	icon = 'modular_twilight_axis/icons/obj/food/metalic_food.dmi'
	icon_state = "iron_jerk5"
	experimental_inhand = TRUE
	bitesize = 5
	list_reagents = list(/datum/reagent/consumable/nutriment = 5)
	tastes = list("metal" = 1)
	faretype = FARE_LAVISH
	customfoodfilling = FALSE
	burntime = 0
	smeltresult = null
	has_item_quality = TRUE
	resistance_flags = FIRE_PROOF
	var/icon_prefix = "iron_jerk"
	var/metal_mood = 2
	var/obj/item/mineral_type = /obj/item/rogueore/iron

/obj/item/reagent_containers/food/snacks/metal/canconsume(
	mob/eater, mob/user, silent = FALSE)
	if(!..())
		return FALSE
	if(eater.stat == DEAD)
		return FALSE
	var/mob/living/living = eater
	if(HAS_TRAIT(eater, TRAIT_IRONMAN))
		if(living.has_status_effect(/datum/status_effect/buff/ingotmuncher) \
			|| living.has_status_effect(/datum/status_effect/buff/oremuncher) \
			|| living.has_status_effect(/datum/status_effect/buff/gemmuncher))
			if(!silent)
				to_chat(user, span_warning("Still processing minerals!"))
			return FALSE
	return TRUE

/obj/item/reagent_containers/food/snacks/metal/On_Consume(mob/living/eater)
	if(HAS_TRAIT(eater, TRAIT_IRONMAN))
		var/mineral_price = GLOB.material_baseline_prices[mineral_type]
		if(!mineral_price)
			mineral_price = initial(mineral_type.sellprice)
		var/power = (5 + mineral_price * 1.25) / bitesize
		eater.apply_status_effect(/datum/status_effect/buff/oremuncher, power)
	else if(ishuman(eater))
		var/mob/living/carbon/human/human = eater
		if(istype(human.dna?.species, /datum/species/moth))
			var/quality_bonus = clamp(
				item_quality - ITEM_QUALITY_STANDARD, -2, 3)
			var/datum/stressevent/event = human.add_stress(
				/datum/stressevent/metal_feast)
			if(event)
				event.stressadd = -max(1, metal_mood + quality_bonus)
		else
			human.add_nausea(200)
	else if(iscarbon(eater))
		var/mob/living/carbon/carbon = eater
		carbon.add_nausea(200)
	eater.taste(reagents)
	if(bitecount < bitesize)
		icon_state = "[icon_prefix][bitesize - bitecount]"
		update_icon()
	if(!reagents.total_volume)
		qdel(src)

/datum/stressevent/metal_feast
	desc = span_green("A delicious feast of finely forged metal!")
	stressadd = -2
	timer = 20 MINUTES

/obj/item/reagent_containers/food/snacks/metal/iron
	name = "iron wafers"
	icon_state = "iron_jerk5"
	icon_prefix = "iron_jerk"
	metal_mood = 2
	mineral_type = /obj/item/rogueore/iron

/obj/item/reagent_containers/food/snacks/metal/steel
	name = "steel wafers"
	icon_state = "steel_jerk5"
	icon_prefix = "steel_jerk"
	metal_mood = 3
	mineral_type = /obj/item/ingot/steel

/obj/item/reagent_containers/food/snacks/metal/bronze
	name = "bronze wafers"
	icon_state = "bronz_jerk5"
	icon_prefix = "bronz_jerk"
	metal_mood = 2
	mineral_type = /obj/item/ingot/bronze

/obj/item/reagent_containers/food/snacks/metal/silver
	name = "silver wafers"
	icon_state = "silver_jerk5"
	icon_prefix = "silver_jerk"
	metal_mood = 4
	mineral_type = /obj/item/rogueore/silver

/obj/item/reagent_containers/food/snacks/metal/gold
	name = "gold wafers"
	icon_state = "gold_jerk5"
	icon_prefix = "gold_jerk"
	metal_mood = 4
	mineral_type = /obj/item/rogueore/gold

/obj/item/reagent_containers/food/snacks/metal/blacksteel
	name = "blacksteel wafers"
	icon_state = "blacksteel_jerk5"
	icon_prefix = "blacksteel_jerk"
	metal_mood = 5
	mineral_type = /obj/item/ingot/blacksteel

/obj/item/reagent_containers/food/snacks/metal/silverblessed
	name = "blessed silver wafers"
	icon_state = "bless_steel_jerk5"
	icon_prefix = "bless_steel_jerk"
	metal_mood = 5
	mineral_type = /obj/item/ingot/silverblessed

/obj/item/reagent_containers/food/snacks/metal/steelholy
	name = "holy steel wafers"
	icon_state = "bless_steel_jerk5"
	icon_prefix = "bless_steel_jerk"
	metal_mood = 5
	mineral_type = /obj/item/ingot/steelholy

/obj/item/reagent_containers/food/snacks/metal/crackers
	name = "gilded steel crackers"
	desc = "Bite-sized steel crackers glazed with gold. \
		A festive crunch for Fluvian teeth, a regrettable snack for others."
	icon_state = "metalick_cracker6"
	icon_prefix = "metalick_cracker"
	metal_mood = 4
	mineral_type = /obj/item/ingot/steel
	bitesize = 6
