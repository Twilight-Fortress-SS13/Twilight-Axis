/obj/item/organ/vagina
	name = "vagina"
	icon = 'modular_twilight_axis/icons/roguetown/items/surgery.dmi' //TA_EDIT
	icon_state = "womb" //TA_EDIT
	visible_organ = TRUE
	zone = BODY_ZONE_PRECISE_GROIN
	slot = ORGAN_SLOT_VAGINA
	accessory_type = /datum/sprite_accessory/vagina/human
	var/pregnant = FALSE
	var/fertility = TRUE

/obj/item/organ/vagina/proc/be_impregnated(mob/living/carbon/human/father)
	if(pregnant)
		return
	if(!owner)
		return
	if(owner.stat == DEAD)
		return
	if(pregnant)
		to_chat(owner, span_love("I feel a surge of warmth in my belly again..."))
		return
	to_chat(owner, span_love("I feel a surge of warmth in my belly, I’m definitely pregnant!"))
	pregnant = TRUE
