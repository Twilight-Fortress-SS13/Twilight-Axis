#ifndef TRAIT_SANDSTORM_GOGGLES
#define TRAIT_SANDSTORM_GOGGLES "sandstorm_goggles"
#endif

/obj/item/clothing/mask/rogue/spectacles/goggles
	name = "sand goggles"
	icon_state = "goggles_sandstorm"
	desc = "A set of goggles of an older design, made to protect the wearer from sandstorms."
	break_sound = "glassbreak"
	attacked_sound = 'sound/combat/hits/onglass/glasshit.ogg'
	max_integrity = 35
	integrity_failure = 0.5
	resistance_flags = FIRE_PROOF
	body_parts_covered = EYES
	anvilrepair = /datum/skill/craft/armorsmithing

/obj/item/clothing/mask/rogue/spectacles/goggles/equipped(mob/user, slot)
	. = ..()
	if(slot == SLOT_WEAR_MASK || slot == SLOT_HEAD)
		ADD_TRAIT(user, TRAIT_SANDSTORM_GOGGLES, "generic")
	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		H.update_fov_angles()

/obj/item/clothing/mask/rogue/spectacles/goggles/dropped(mob/user)
	. = ..()
	if(HAS_TRAIT(user, TRAIT_SANDSTORM_GOGGLES))
		REMOVE_TRAIT(user, TRAIT_SANDSTORM_GOGGLES, "generic")
	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		H.update_fov_angles()

/datum/supply_pack/rogue/luxury/sandstormgoggle
	name = "Sandstorm Goggles"
	cost = 60
	contains = list(
		/obj/item/clothing/mask/rogue/spectacles/goggles
	)
