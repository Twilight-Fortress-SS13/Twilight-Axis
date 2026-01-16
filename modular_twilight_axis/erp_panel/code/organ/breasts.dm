#define BREAST_BASE_PROD_PER_SIZE		0.4
#define BREAST_STORAGE_PER_SIZE			20
#define BREAST_INJECTION_PER_SIZE		1
#define BREAST_NUTRITION_COST_PER_UNIT	0.5
#define BREAST_STORAGE_BASE 40

/datum/sex_organ/breasts
	organ_type = SEX_ORGAN_BREASTS
	producing_reagent_id = /datum/reagent/consumable/milk/erp
	stored_liquid_max = 75
	producing_reagent_rate = 0

/datum/sex_organ/breasts/New(obj/item/organ/breasts/organ)
	. = ..()
	var/size = clamp(organ.breast_size, 1, 5)
	if(!organ || !organ.lactating)
		return
	
	var/datum/reagent/reagent_object = GLOB.chemical_reagents_list[producing_reagent_id]
	if(!reagent_object)
		return 	

	stored_liquid_max = BREAST_STORAGE_BASE + (max(size,4) * BREAST_STORAGE_PER_SIZE)
	producing_reagent_rate = size * BREAST_BASE_PROD_PER_SIZE
	injection_amount = size * BREAST_INJECTION_PER_SIZE

	if(stored_liquid)
		stored_liquid.maximum_volume = stored_liquid_max
	else
		stored_liquid = new(stored_liquid_max)

	if(producing_reagent_id && producing_reagent_rate > 0 && has_storage())
		start_production_timer()
		stored_liquid.add_reagent(reagent_object.type, (stored_liquid_max/10))

/datum/sex_organ/breasts/proc/get_hunger_mult()
	var/mob/living/carbon/human/H = get_owner()
	if(!istype(H))
		return 1.0

	if(HAS_TRAIT(H, TRAIT_NOHUNGER))
		return 0

	var/nut = H.nutrition

	if(nut <= NUTRITION_LEVEL_STARVING)
		return 0.1
	if(nut <= NUTRITION_LEVEL_HUNGRY)
		return 0.4
	if(nut <= NUTRITION_LEVEL_FED)
		return 0.7

	return 1.0

/datum/sex_organ/breasts/produce_liquid(datum/reagent/reagent_object, amount)
	if(!has_storage() || amount <= 0)
		return 0

	if(!reagent_object && producing_reagent_id)
		reagent_object = GLOB.chemical_reagents_list[producing_reagent_id]
	if(!reagent_object)
		return 0

	var/mob/living/carbon/human/human_object = get_owner()
	var/mult = get_production_multiplier()
	if(mult <= 0)
		return 0

	var/h_mult = get_hunger_mult()
	if(h_mult <= 0)
		return 0

	amount *= mult * h_mult
	if(istype(human_object))
		var/max_from_nutrition = max(0, human_object.nutrition - NUTRITION_LEVEL_STARVING)
		if(max_from_nutrition <= 0)
			return 0
		if(amount > max_from_nutrition)
			amount = max_from_nutrition

	pending_production += amount
	if(pending_production < SEX_MIN_REAGENT_QUANT)
		return 0

	var/to_add = pending_production
	var/added = stored_liquid.add_reagent(reagent_object.type, to_add)
	if(added > 0)
		pending_production = max(0, pending_production - added)
		renew_timer(drain_interval)
		if(istype(human_object))
			human_object.adjust_nutrition(-added * BREAST_NUTRITION_COST_PER_UNIT)

	return added
