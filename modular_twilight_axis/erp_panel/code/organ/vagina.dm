/datum/sex_organ/vagina
	organ_type = SEX_ORGAN_VAGINA
	stored_liquid_max = VAGINA_MAX_UNITS
	var/can_be_pregnant = FALSE
	var/pregnant = FALSE

/datum/sex_organ/vagina/New(obj/item/organ/vagina/organ)
	. = ..()
	can_be_pregnant = organ.fertility

/datum/sex_organ/vagina/proc/on_intimate_climax(mob/living/carbon/human/father,	arousal_value = 0,	knot_bonus = 0)

	if(!father)
		return
	if(pregnant)
		return
	if(!can_be_pregnant)
		return

	var/obj/item/organ/vagina/vagina = organ_link
	if(!organ_link)
		return

	var/mob/living/carbon/owner = vagina.owner
	if(!owner)
		return
	if(!owner || owner.stat == DEAD)
		return

	var/mob/living/carbon/human/mother = owner
	if(!istype(mother))
		return

	if(!mother.is_fertile() || !father.is_virile())
		return

	var/chance = VAGINA_BASE_PREGNANCY_CHANCE

	var/max_arousal = ERP_UI_MAX_AROUSAL
	if(max_arousal <= 0)
		max_arousal = 100

	var/norm = clamp(arousal_value / max_arousal, 0, 1)
	var/arousal_mult = 0.5 + norm
	chance *= arousal_mult

	knot_bonus = clamp(knot_bonus, 0, VAGINA_KNOT_PREGNANCY_MAX_BONUS)
	chance += knot_bonus

	chance = clamp(round(chance), 0, 90)

	if(!chance)
		return

	if(prob(chance))
		be_impregnated(father)

/datum/sex_organ/vagina/proc/be_impregnated(mob/living/carbon/human/father)
	if(pregnant)
		return
	if(!can_be_pregnant)
		return
	
	var/obj/item/organ/vagina/vagina = organ_link
	if(!organ_link)
		return

	var/mob/living/carbon/owner = vagina.owner
	if(!owner || owner.stat == DEAD)
		return

	pregnant = TRUE
	to_chat(owner, span_love("I feel a surge of warmth in my belly, I’m definitely pregnant!"))
