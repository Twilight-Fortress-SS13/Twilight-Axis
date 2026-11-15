
// Rat
/mob/living/carbon/human/species/wildshape/rat
	name = "Rat"
	race = /datum/species/shaperat
	footstep_type = FOOTSTEP_MOB_CLAW
	ambushable = FALSE
	skin_armor = null
	wildshape_icon = 'icons/roguetown/mob/monster/rat.dmi'
	wildshape_icon_state = "srat"
	give_miracles = FALSE

/mob/living/carbon/human/species/wildshape/rat/gain_inherent_skills()
	. = ..()
	if(mind)
		adjust_skillrank(/datum/skill/misc/swimming, SKILL_LEVEL_EXPERT, TRUE)
		adjust_skillrank(/datum/skill/misc/athletics, SKILL_LEVEL_MASTER, TRUE)
		adjust_skillrank(/datum/skill/misc/climbing, SKILL_LEVEL_EXPERT, TRUE)
		adjust_skillrank(/datum/skill/misc/sneaking, SKILL_LEVEL_MASTER, TRUE)

		STASTR = 1
		STACON = 1 // YOU GONNA DIE FROM ONE HIT, HA-HA-HA!!!
		STAWIL = 16
		STAPER = 14
		STASPD = 16
		STAINT = 12

		real_name = "rat"
		faction += "rats"

/datum/species/shaperat
	name = "rat"
	id = "shaperat"
	species_traits = list(NO_UNDERWEAR, NO_ORGAN_FEATURES, NO_BODYPART_FEATURES)
	inherent_traits = list(
		TRAIT_KNEESTINGER_IMMUNITY,
		TRAIT_STEELHEARTED,
		TRAIT_INFINITE_ENERGY,
		TRAIT_WILD_EATER,
		TRAIT_LONGSTRIDER,
		TRAIT_PERFECT_TRACKER,
		TRAIT_DODGEEXPERT,
		TRAIT_WEAPONLESS,
		TRAIT_NOPVE,
		TRAIT_KEENEARS,
		TRAIT_HARDDISMEMBER,
		TRAIT_BREADY,
	)
	inherent_biotypes = MOB_HUMANOID
	no_equip = list(SLOT_SHIRT, SLOT_HEAD, SLOT_WEAR_MASK, SLOT_ARMOR, SLOT_GLOVES, SLOT_SHOES, SLOT_PANTS, SLOT_CLOAK, SLOT_BELT, SLOT_BACK_R, SLOT_BACK_L, SLOT_S_STORE)
	nojumpsuit = 1
	sexes = 1
	offset_features = list(OFFSET_HANDS = list(0,2), OFFSET_HANDS_F = list(0,2))
	organs = list(
		ORGAN_SLOT_BRAIN = /obj/item/organ/brain,
		ORGAN_SLOT_HEART = /obj/item/organ/heart,
		ORGAN_SLOT_LUNGS = /obj/item/organ/lungs,
		ORGAN_SLOT_EYES = /obj/item/organ/eyes/night_vision,
		ORGAN_SLOT_EARS = /obj/item/organ/ears,
		ORGAN_SLOT_TONGUE = /obj/item/organ/tongue/wild_tongue,
		ORGAN_SLOT_LIVER = /obj/item/organ/liver,
		ORGAN_SLOT_STOMACH = /obj/item/organ/stomach,
		ORGAN_SLOT_APPENDIX = /obj/item/organ/appendix,
		ORGAN_SLOT_GUTS = /obj/item/organ/guts,
		)

	languages = list(
		/datum/language/beast,
		/datum/language/common,
	)

/datum/species/shaperat/send_voice(mob/living/carbon/human/H)
	playsound(get_turf(H), pick('sound/vo/mobs/rat/rat_life.ogg','sound/vo/mobs/rat/rat_life2.ogg','sound/vo/mobs/rat/rat_life3.ogg','sound/vo/mobs/rat/aggro (1).ogg','sound/vo/mobs/rat/aggro (2).ogg', 'sound/vo/mobs/rat/aggro (3).ogg'), 80, TRUE, -1)

/datum/species/shaperat/regenerate_icons(mob/living/carbon/human/human)
	human.icon = 'icons/roguetown/mob/monster/rat.dmi'
	human.base_intents = list(INTENT_HELP, INTENT_DISARM, INTENT_GRAB)
	human.icon_state = "srat"
	human.update_damage_overlays()
	return TRUE

// Rous, more tanky and cool than rat, but costs more
/mob/living/carbon/human/species/wildshape/rous
	name = "Rous"
	race = /datum/species/shaperous
	footstep_type = FOOTSTEP_MOB_CLAW
	ambushable = FALSE
	wildshape_icon = 'icons/roguetown/mob/monster/bigrat.dmi'
	wildshape_icon_state = "rat"
	give_miracles = FALSE
	skin_armor = new /obj/item/clothing/suit/roguetown/armor/skin_armor/rous_skin

/mob/living/carbon/human/species/wildshape/rous/gain_inherent_skills()
	. = ..()
	if(mind)
		adjust_skillrank(/datum/skill/misc/swimming, SKILL_LEVEL_JOURNEYMAN, TRUE)
		adjust_skillrank(/datum/skill/misc/athletics, SKILL_LEVEL_EXPERT, TRUE)
		adjust_skillrank(/datum/skill/misc/climbing, SKILL_LEVEL_EXPERT, TRUE)
		adjust_skillrank(/datum/skill/misc/sneaking, SKILL_LEVEL_JOURNEYMAN, TRUE)
		adjust_skillrank(/datum/skill/combat/unarmed, SKILL_LEVEL_EXPERT, TRUE)
		adjust_skillrank(/datum/skill/combat/wrestling, SKILL_LEVEL_JOURNEYMAN, TRUE)

		STASTR = 7
		STACON = 12
		STAWIL = 14
		STAPER = 15
		STASPD = 15
		STAINT = 9

		real_name = "rous"
		faction += "rats"
		mind.AddSpell(new /obj/effect/proc_holder/spell/self/rousclaws)

/datum/species/shaperous
	name = "rous"
	id = "shaperous"
	species_traits = list(NO_UNDERWEAR, NO_ORGAN_FEATURES, NO_BODYPART_FEATURES)
	inherent_traits = list(
		TRAIT_KNEESTINGER_IMMUNITY,
		TRAIT_STEELHEARTED,
		TRAIT_INFINITE_ENERGY,
		TRAIT_STRONGBITE,
		TRAIT_WILD_EATER,
		TRAIT_LONGSTRIDER,
		TRAIT_PERFECT_TRACKER,
		TRAIT_DODGEEXPERT,
		TRAIT_GNARLYDIGITS,
	)
	inherent_biotypes = MOB_HUMANOID
	no_equip = list(SLOT_SHIRT, SLOT_HEAD, SLOT_WEAR_MASK, SLOT_ARMOR, SLOT_GLOVES, SLOT_SHOES, SLOT_PANTS, SLOT_CLOAK, SLOT_BELT, SLOT_BACK_R, SLOT_BACK_L, SLOT_S_STORE)
	nojumpsuit = 1
	sexes = 1
	offset_features = list(OFFSET_HANDS = list(0,2), OFFSET_HANDS_F = list(0,2))
	organs = list(
		ORGAN_SLOT_BRAIN = /obj/item/organ/brain,
		ORGAN_SLOT_HEART = /obj/item/organ/heart,
		ORGAN_SLOT_LUNGS = /obj/item/organ/lungs,
		ORGAN_SLOT_EYES = /obj/item/organ/eyes/night_vision,
		ORGAN_SLOT_EARS = /obj/item/organ/ears,
		ORGAN_SLOT_TONGUE = /obj/item/organ/tongue/wild_tongue,
		ORGAN_SLOT_LIVER = /obj/item/organ/liver,
		ORGAN_SLOT_STOMACH = /obj/item/organ/stomach,
		ORGAN_SLOT_APPENDIX = /obj/item/organ/appendix,
		ORGAN_SLOT_GUTS = /obj/item/organ/guts,
		)

	languages = list(
		/datum/language/beast,
		/datum/language/common,
	)

/datum/species/shaperous/send_voice(mob/living/carbon/human/H)
	playsound(get_turf(H), pick('sound/vo/mobs/rat/rat_life.ogg','sound/vo/mobs/rat/rat_life2.ogg','sound/vo/mobs/rat/rat_life3.ogg','sound/vo/mobs/rat/aggro (1).ogg','sound/vo/mobs/rat/aggro (2).ogg', 'sound/vo/mobs/rat/aggro (3).ogg'), 80, TRUE, -1)

/datum/species/shaperous/regenerate_icons(mob/living/carbon/human/human)
	human.icon = 'icons/roguetown/mob/monster/bigrat.dmi'
	human.base_intents = list(INTENT_HELP, INTENT_DISARM, INTENT_GRAB)
	human.icon_state = "rat"
	human.update_damage_overlays()
	return TRUE

// ROUS ITEMS //
/obj/item/clothing/suit/roguetown/armor/skin_armor/rous_skin
	slot_flags = null
	name = "fat skin"
	desc = ""
	icon_state = null
	body_parts_covered = FULL_BODY
	body_parts_inherent = FULL_BODY
	armor = ARMOR_LEATHER
	blocksound = SOFTHIT
	blade_dulling = DULLING_BASHCHOP
	sewrepair = FALSE
	max_integrity = 80
	item_flags = DROPDEL

/obj/item/rogueweapon/rous_claw
	name = "rous claw"
	desc = ""
	item_state = null
	lefthand_file = null
	righthand_file = null
	icon = 'icons/roguetown/weapons/unarmed32.dmi'
	max_blade_int = 200
	max_integrity = 200
	force = 30 // About 15 damage with our strength
	wdefense = 1
	associated_skill = /datum/skill/combat/unarmed
	wlength = WLENGTH_SHORT
	wbalance = WBALANCE_SWIFT
	w_class = WEIGHT_CLASS_NORMAL
	can_parry = TRUE //I just think this is cool as fuck, sue me
	sharpness = IS_SHARP
	parrysound = "bladedmedium"
	swingsound = BLADEWOOSH_MED
	possible_item_intents = list(/datum/intent/simple/rous)
	parrysound = list('sound/combat/parry/parrygen.ogg')
	embedding = list("embedded_pain_multiplier" = 0, "embed_chance" = 0, "embedded_fall_chance" = 0)
	item_flags = DROPDEL
	experimental_inhand = FALSE

/obj/item/rogueweapon/rous_claw/right
	icon_state = "claw_r"

/obj/item/rogueweapon/rous_claw/left
	icon_state = "claw_l"

/obj/item/rogueweapon/rous_claw/Initialize(mapload)
	. = ..()
	ADD_TRAIT(src, TRAIT_NODROP, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_NOEMBED, TRAIT_GENERIC)

// CAT SPELLS //
/obj/effect/proc_holder/spell/self/rousclaws
	name = "Rous Claws"
	desc = "!"
	overlay_state = "claws"
	antimagic_allowed = TRUE
	recharge_time = 20
	ignore_cockblock = TRUE
	var/extended = FALSE

/obj/effect/proc_holder/spell/self/rousclaws/cast(mob/user = usr)
	..()
	var/obj/item/rogueweapon/rous_claw/left/l
	var/obj/item/rogueweapon/rous_claw/right/r

	l = user.get_active_held_item()
	r = user.get_inactive_held_item()
	if(extended)
		if(istype(l, /obj/item/rogueweapon/rous_claw))
			user.dropItemToGround(l, TRUE)
			qdel(l)
		if(istype(r, /obj/item/rogueweapon/rous_claw))
			user.dropItemToGround(r, TRUE)
			qdel(r)
		extended = FALSE
	else
		l = new(user,1)
		r = new(user,2)
		user.put_in_hands(l, TRUE, FALSE, TRUE)
		user.put_in_hands(r, TRUE, FALSE, TRUE)
		extended = TRUE

/datum/intent/simple/rous
	name = "claw"
	icon_state = "incut"
	blade_class = BCLASS_CUT
	attack_verb = list("claws", "cuts", "scratches")
	animname = "cut"
	hitsound = "genslash"
	penfactor = PEN_NONE
	candodge = TRUE
	canparry = TRUE
	miss_text = "slashes the air!"
	miss_sound = "bladewooshsmall"
	item_d_type = "slash"

// Troll, tanky and powerful, but really slow
/mob/living/carbon/human/species/wildshape/troll
	name = "Troll"
	race = /datum/species/shapetroll
	footstep_type = FOOTSTEP_MOB_HEAVY
	ambushable = FALSE
	wildshape_icon = 'icons/roguetown/mob/monster/trolls/trolls.dmi'
	wildshape_icon_state = "troll"
	give_miracles = FALSE
	skin_armor = new /obj/item/clothing/suit/roguetown/armor/skin_armor/troll_skin

/mob/living/carbon/human/species/wildshape/troll/gain_inherent_skills()
	. = ..()
	if(mind)
		adjust_skillrank(/datum/skill/misc/swimming, SKILL_LEVEL_JOURNEYMAN, TRUE)
		adjust_skillrank(/datum/skill/misc/athletics, SKILL_LEVEL_EXPERT, TRUE)
		adjust_skillrank(/datum/skill/misc/climbing, SKILL_LEVEL_JOURNEYMAN, TRUE)
		adjust_skillrank(/datum/skill/combat/unarmed, SKILL_LEVEL_EXPERT, TRUE)
		adjust_skillrank(/datum/skill/combat/wrestling, SKILL_LEVEL_JOURNEYMAN, TRUE)
		adjust_skillrank(/datum/skill/craft/cooking, SKILL_LEVEL_APPRENTICE, TRUE)
		adjust_skillrank(/datum/skill/craft/masonry, SKILL_LEVEL_APPRENTICE, TRUE)
		STASTR = 14
		STACON = 16
		STAWIL = 14
		STAPER = 12
		STASPD = 8
		STAINT = 6

		real_name = "troll"
		faction += "trolls"
		mind.AddSpell(new /obj/effect/proc_holder/spell/self/trollarms)

/datum/species/shapetroll
	name = "troll"
	id = "shapetroll"
	species_traits = list(NO_UNDERWEAR, NO_ORGAN_FEATURES, NO_BODYPART_FEATURES)
	inherent_traits = list(
		TRAIT_KNEESTINGER_IMMUNITY,
		TRAIT_STEELHEARTED,
		TRAIT_INFINITE_ENERGY,
		TRAIT_STRONGBITE,
		TRAIT_WILD_EATER,
		TRAIT_NASTY_EATER,
		TRAIT_BOGWALKER,
		TRAIT_BLOOD_RESISTANCE,
		TRAIT_HARDDISMEMBER,
		TRAIT_NOPAINSTUN,
	)
	inherent_biotypes = MOB_HUMANOID
	no_equip = list(SLOT_SHIRT, SLOT_HEAD, SLOT_WEAR_MASK, SLOT_ARMOR, SLOT_GLOVES, SLOT_SHOES, SLOT_PANTS, SLOT_CLOAK, SLOT_BELT, SLOT_BACK_R, SLOT_BACK_L, SLOT_S_STORE)
	nojumpsuit = 1
	sexes = 1
	offset_features = list(OFFSET_HANDS = list(0,2), OFFSET_HANDS_F = list(0,2))
	organs = list(
		ORGAN_SLOT_BRAIN = /obj/item/organ/brain,
		ORGAN_SLOT_HEART = /obj/item/organ/heart,
		ORGAN_SLOT_LUNGS = /obj/item/organ/lungs,
		ORGAN_SLOT_EYES = /obj/item/organ/eyes/night_vision,
		ORGAN_SLOT_EARS = /obj/item/organ/ears,
		ORGAN_SLOT_TONGUE = /obj/item/organ/tongue/wild_tongue,
		ORGAN_SLOT_LIVER = /obj/item/organ/liver,
		ORGAN_SLOT_STOMACH = /obj/item/organ/stomach,
		ORGAN_SLOT_APPENDIX = /obj/item/organ/appendix,
		ORGAN_SLOT_GUTS = /obj/item/organ/guts,
		)

	languages = list(
		/datum/language/beast,
		/datum/language/common,
	)

/datum/species/shapetroll/send_voice(mob/living/carbon/human/H)
	playsound(get_turf(H), pick('sound/vo/mobs/troll/aggro1.ogg', 'sound/vo/mobs/troll/aggro2.ogg', 'sound/vo/mobs/troll/idle1.ogg', 'sound/vo/mobs/troll/idle2.ogg', 'sound/vo/mobs/troll/cidle1.ogg'), 80, TRUE, -1)

/datum/species/shapetroll/regenerate_icons(mob/living/carbon/human/human)
	human.icon = 'icons/roguetown/mob/monster/trolls/trolls.dmi'
	human.base_intents = list(INTENT_HELP, INTENT_DISARM, INTENT_GRAB)
	human.icon_state = "troll"
	human.update_damage_overlays()
	return TRUE

/obj/item/clothing/suit/roguetown/armor/skin_armor/troll_skin
	slot_flags = null
	name = "troll's skin"
	desc = ""
	icon_state = null
	body_parts_covered = FULL_BODY
	body_parts_inherent = FULL_BODY
	armor = ARMOR_PLATE
	blocksound = SOFTHIT
	blade_dulling = DULLING_BASHCHOP
	sewrepair = FALSE
	max_integrity = 250
	item_flags = DROPDEL

/datum/intent/simple/troll
	name = "punch"
	clickcd = CLICK_CD_MELEE
	icon_state = "instrike"
	blade_class = BCLASS_BLUNT
	attack_verb = list("punches", "hits")
	animname = "strike"
	hitsound = "punch_hard"
	penfactor = PEN_LIGHT
	candodge = TRUE
	canparry = TRUE
	miss_text = "punches the air!"
	miss_sound = "bluntswoosh"
	item_d_type = "slash"

/obj/item/rogueweapon/troll_arm
	name = "troll arm"
	desc = ""
	item_state = null
	lefthand_file = null
	righthand_file = null
	icon = 'icons/roguetown/weapons/misc32.dmi'
	max_blade_int = 600
	max_integrity = 600
	force = 25 // about 35 dmg with 14 str
	block_chance = 0
	wdefense = 6
	blade_dulling = DULLING_SHAFT_WOOD
	associated_skill = /datum/skill/combat/unarmed
	wlength = WLENGTH_NORMAL
	wbalance = WBALANCE_HEAVY
	w_class = WEIGHT_CLASS_NORMAL
	can_parry = TRUE
	sharpness = IS_BLUNT
	swingsound = BLUNTWOOSH_MED
	possible_item_intents = list(/datum/intent/simple/troll)
	parrysound = list('sound/combat/parry/parrygen.ogg')
	embedding = list("embedded_pain_multiplier" = 0, "embed_chance" = 0, "embedded_fall_chance" = 0)
	item_flags = DROPDEL
	experimental_inhand = FALSE

/obj/item/rogueweapon/troll_arm/right
	icon_state = "claw_r"

/obj/item/rogueweapon/troll_arm/left
	icon_state = "claw_l"

/obj/item/rogueweapon/troll_arm/Initialize(mapload)
	. = ..()
	ADD_TRAIT(src, TRAIT_NODROP, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_NOEMBED, TRAIT_GENERIC)

/obj/effect/proc_holder/spell/self/trollarms
	name = "Troll Claws"
	desc = "!"
	overlay_state = "claws"
	antimagic_allowed = TRUE
	recharge_time = 2 SECONDS
	ignore_cockblock = TRUE
	var/extended = FALSE

/obj/effect/proc_holder/spell/self/trollarms/cast(mob/user = usr)
	..()
	var/obj/item/rogueweapon/troll_arm/left/left = user.get_active_held_item()
	var/obj/item/rogueweapon/troll_arm/right/right = user.get_inactive_held_item()

	if(extended)
		if(istype(left, /obj/item/rogueweapon/troll_arm))
			user.dropItemToGround(left, TRUE)
			qdel(left)

		if(istype(right, /obj/item/rogueweapon/troll_arm))
			user.dropItemToGround(right, TRUE)
			qdel(right)

		extended = FALSE
		return

	left = new(user, 1)
	right = new(user, 2)
	user.put_in_hands(left, TRUE, FALSE, TRUE)
	user.put_in_hands(right, TRUE, FALSE, TRUE)
	extended = TRUE
