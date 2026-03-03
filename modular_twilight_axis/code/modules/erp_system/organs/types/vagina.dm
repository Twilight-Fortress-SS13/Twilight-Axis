#define VAGINA_MAX_UNITS 20
#define VAGINA_BASE_PREGNANCY_CHANCE 20
#define VAGINA_KNOT_PREGNANCY_MAX_BONUS 90

/datum/erp_sex_organ/vagina
	erp_organ_type = SEX_ORGAN_VAGINA
	var/can_be_pregnant = FALSE
	var/pregnant = FALSE
	active_arousal = 1.0
	passive_arousal = 1.15
	active_pain = 0.1
	passive_pain = 0.2

/datum/erp_sex_organ/vagina/New(obj/item/organ/vagina/V)
	. = ..()
	host = V.owner
	can_be_pregnant = V.fertility
	storage = new(VAGINA_MAX_UNITS, src)

/datum/erp_sex_organ/vagina/proc/on_climax(mob/living/carbon/human/father, arousal, knot_bonus = 0)
	if(pregnant || !can_be_pregnant || !father)
		return

	var/mob/living/carbon/human/mother = host
	if(!istype(mother))
		return

	if(!mother.is_fertile() || !father.is_virile())
		return

	var/chance = VAGINA_BASE_PREGNANCY_CHANCE
	chance += clamp(knot_bonus, 0, VAGINA_KNOT_PREGNANCY_MAX_BONUS)

	if(prob(clamp(chance, 0, 90)))
		pregnant = TRUE
		to_chat(mother, span_love("Я чувствую тепло в животе… кажется, я беременна."))

/obj/item/organ/vagina/Insert(mob/living/carbon/M, special, drop_if_replaced)
	. = ..()
	if(!sex_organ)
		sex_organ = new /datum/erp_sex_organ/vagina(src)

/datum/erp_sex_organ/vagina/extract_reagents(amount)
	if(amount <= 0)
		return null

	var/datum/reagents/R = ..(amount)
	if(!R)
		R = new(amount)

	var/missing = amount - R.total_volume
	if(missing > 0)
		R.add_reagent(/datum/reagent/erpjuice/lube, missing, null, 300, no_react = TRUE)

	if(R.total_volume <= 0)
		qdel(R)
		return null

	return R

/datum/erp_sex_organ/vagina/drop_to_ground(datum/reagents/R)
	if(!R || R.total_volume <= 0)
		return

	var/min_lube = min(3, R.maximum_volume)
	var/has_lube = R.get_reagent_amount(/datum/reagent/erpjuice/lube)
	if(has_lube < min_lube)
		R.add_reagent(/datum/reagent/erpjuice/lube, (min_lube - has_lube), null, 300, no_react = TRUE)

	return ..(R)

#undef VAGINA_MAX_UNITS
#undef VAGINA_BASE_PREGNANCY_CHANCE
#undef VAGINA_KNOT_PREGNANCY_MAX_BONUS
