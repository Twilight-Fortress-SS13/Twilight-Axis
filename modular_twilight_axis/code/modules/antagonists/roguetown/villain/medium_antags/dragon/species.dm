/mob/living/carbon/human/species/wyvern
	race = /datum/species/wyvern
	footstep_type = FOOTSTEP_MOB_HEAVY

/mob/living/carbon/human/species/wyvern/updatehealth()
	..()

	remove_movespeed_modifier(MOVESPEED_ID_DAMAGE_SLOWDOWN)
	remove_movespeed_modifier(MOVESPEED_ID_DAMAGE_SLOWDOWN_FLYING)

/mob/living/carbon/human/species/wyvern/male
	gender = MALE

/mob/living/carbon/human/species/wyvern/female
	gender = FEMALE

/datum/species/wyvern
	name = "Wyvern"
	id = "wyvern"
	custom_rotation_icon = TRUE
	custom_base_icon = "dragon_cool"
	species_traits = list(NO_UNDERWEAR, NO_ORGAN_FEATURES, NO_BODYPART_FEATURES)
	inherent_traits = list(
		TRAIT_NO_VOICEPACK_OVERRIDE, //They have voicepack lines.
		TRAIT_IGNORESLOWDOWN,
		TRAIT_IGNOREDAMAGESLOWDOWN,
		TRAIT_CRITICAL_RESISTANCE,
		TRAIT_NOFALLDAMAGE1,
		TRAIT_STRENGTH_UNCAPPED,
		TRAIT_PIERCEIMMUNE,
		TRAIT_HARDDISMEMBER,
		TRAIT_NOSTINK,
		TRAIT_NASTY_EATER,
		TRAIT_ORGAN_EATER,
		TRAIT_BREADY,
		TRAIT_STEELHEARTED,
		TRAIT_BASHDOORS,
		TRAIT_STRONGBITE,
		TRAIT_GNARLYDIGITS,
		TRAIT_ZJUMP,
		TRAIT_NUDIST,
		TRAIT_UNLYCKERABLE, //Just stop
		TRAIT_NOFIRE,
		TRAIT_LEAPER,
	)
	inherent_biotypes = MOB_HUMANOID
	no_equip = list(SLOT_SHIRT, SLOT_HEAD, SLOT_WEAR_MASK, SLOT_ARMOR, SLOT_GLOVES, SLOT_SHOES, SLOT_PANTS, SLOT_CLOAK, SLOT_BELT, SLOT_BACK_L, SLOT_BACK_R, SLOT_S_STORE)
	nojumpsuit = 1
	sexes = 1
	offset_features = list(OFFSET_HANDS = list(0,2), OFFSET_HANDS_F = list(0,2))
	soundpack_m = /datum/voicepack/gnoll
	soundpack_f = /datum/voicepack/gnoll
	enflamed_icon = "widefire"
	organs = list(
		ORGAN_SLOT_BRAIN = /obj/item/organ/brain,
		ORGAN_SLOT_HEART = /obj/item/organ/heart,
		ORGAN_SLOT_LUNGS = /obj/item/organ/lungs,
		ORGAN_SLOT_EYES = /obj/item/organ/eyes/night_vision,
		ORGAN_SLOT_EARS = /obj/item/organ/ears,
		ORGAN_SLOT_TONGUE = /obj/item/organ/tongue/lizard,
		ORGAN_SLOT_LIVER = /obj/item/organ/liver,
		ORGAN_SLOT_STOMACH = /obj/item/organ/stomach,
		ORGAN_SLOT_APPENDIX = /obj/item/organ/appendix,
		ORGAN_SLOT_GUTS = /obj/item/organ/guts,
	)
	languages = list(
		/datum/language/common,
		/datum/language/draconic,
		/datum/language/beast,
	)

/datum/species/wyvern/regenerate_icons(mob/living/carbon/human/H)
	H.icon = 'modular/icons/mob/96x96/ratwood_dragon.dmi'
	H.icon_state = "dragon_cool"
	H.base_intents = list(INTENT_HELP, INTENT_DISARM, INTENT_GRAB)
	H.update_damage_overlays()
	H.update_inv_armor_special()
	H.base_pixel_x = -32
	H.pixel_x = -32
	H.base_pixel_y = -8
	H.pixel_y = -8
	return TRUE

/datum/species/wyvern/on_species_gain(mob/living/carbon/human/C, datum/species/old_species)
	. = ..()
	RegisterSignal(C, COMSIG_MOB_SAY, PROC_REF(handle_speech))
	C.icon_state = "dragon_cool"
	C.base_pixel_x = -32
	C.pixel_x = -32
	C.base_pixel_y = -8
	C.pixel_y = -8
	C.regenerate_icons()

/datum/species/wyvern/on_species_loss(mob/living/carbon/C)
	. = ..()
	UnregisterSignal(C, COMSIG_MOB_SAY)

/datum/species/wyvern/send_voice(mob/living/carbon/human/H)
	if(H.m_intent == MOVE_INTENT_SNEAK)
		return
	playsound(get_turf(H), pick('sound/vo/mobs/wwolf/wolftalk1.ogg','sound/vo/mobs/wwolf/wolftalk2.ogg'), 100, TRUE, -1)

/datum/species/wyvern/update_damage_overlays(mob/living/carbon/human/H)
	H.remove_overlay(DAMAGE_LAYER)
	var/list/hands = list()
	var/mutable_appearance/inhand_overlay = mutable_appearance("[H.icon_state]-dam", layer=-DAMAGE_LAYER)
	var/burnhead = 0
	var/brutehead = 0
	var/burnch = 0
	var/brutech = 0
	var/obj/item/bodypart/affecting = H.get_bodypart(BODY_ZONE_HEAD)
	if(affecting)
		burnhead = (affecting.burn_dam / affecting.max_damage)
		brutehead = (affecting.brute_dam / affecting.max_damage)
	affecting = H.get_bodypart(BODY_ZONE_CHEST)
	if(affecting)
		burnch = (affecting.burn_dam / affecting.max_damage)
		brutech = (affecting.brute_dam / affecting.max_damage)
	var/usedloss = 0
	if(burnhead > usedloss)
		usedloss = burnhead
	if(brutehead > usedloss)
		usedloss = brutehead
	if(burnch > usedloss)
		usedloss = burnch
	if(brutech > usedloss)
		usedloss = brutech
	inhand_overlay.alpha = 255 * usedloss

	hands += inhand_overlay
	H.overlays_standing[DAMAGE_LAYER] = hands
	H.apply_overlay(DAMAGE_LAYER)
	return TRUE

/datum/species/wyvern/random_name(gender,unique,lastname)
	return "[pick(GLOB.wolf_prefixes)] [pick(GLOB.wolf_suffixes)]"
