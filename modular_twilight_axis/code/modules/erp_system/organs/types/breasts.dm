#define BREAST_BASE_PROD_PER_SIZE		0.2
#define BREAST_STORAGE_PER_SIZE			20
#define BREAST_INJECTION_PER_SIZE		1
#define BREAST_NUTRITION_COST_PER_UNIT	0.5
#define BREAST_STORAGE_BASE 40

/datum/erp_sex_organ/breasts
	erp_organ_type = SEX_ORGAN_BREASTS
	var/breast_size = 1
	active_arousal = 0.9
	passive_arousal = 1.1
	active_pain = 0.02
	passive_pain = 0.4

/datum/erp_sex_organ/breasts/New(obj/item/organ/breasts/B)
	. = ..(B)
	breast_size = clamp(B.breast_size, 1, 5)

	if(B.lactating)
		var/new_capacity = BREAST_STORAGE_BASE + breast_size * BREAST_STORAGE_PER_SIZE
		storage = new(new_capacity, src)
		producing = new (new_capacity, src)
		producing.producing_reagent = /datum/reagent/consumable/milk/erp
		producing.production_rate = breast_size * BREAST_BASE_PROD_PER_SIZE

/datum/erp_sex_organ/breasts/get_production_mult()
	var/obj/item/organ/breasts/organ_object = host
	if(!istype(organ_object))
		return 0

	var/mob/living/carbon/human/H = organ_object.owner
	if(!istype(H))
		return 0

	if(H.nutrition <= NUTRITION_LEVEL_STARVING)
		return 0.1
	if(H.nutrition <= NUTRITION_LEVEL_HUNGRY)
		return 0.4
	if(H.nutrition <= NUTRITION_LEVEL_FED)
		return 0.7

	return 1.0

/obj/item/organ/breasts/Insert(mob/living/carbon/M, ...)
	. = ..()
	if(!sex_organ)
		sex_organ = new /datum/erp_sex_organ/breasts(src)

/datum/erp_sex_organ/breasts/on_inject(datum/erp_sex_link/link, inject_mode, target, datum/reagents/R, mob/living/carbon/human/who)
	. = ..()
	if(!link || !R)
		return
	if(R.total_volume <= 0)
		return

	var/mob/living/carbon/human/me = get_owner()
	if(!istype(me))
		return

	var/mob/living/carbon/human/partner = null
	if(me == link.actor_active?.physical)
		partner = link.actor_passive?.physical
	else if(me == link.actor_passive?.physical)
		partner = link.actor_active?.physical

	if(!istype(partner))
		return

	to_chat(me, span_warning("Я чувствую, как молоко покидает мою грудь."))
	to_chat(partner, span_warning("Я чувствую, как молоко [me] попадает мне в рот."))

#undef BREAST_BASE_PROD_PER_SIZE
#undef BREAST_STORAGE_PER_SIZE
#undef BREAST_INJECTION_PER_SIZE
#undef BREAST_NUTRITION_COST_PER_UNIT
#undef BREAST_STORAGE_BASE
