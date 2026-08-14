GLOBAL_LIST_INIT(forgottenking_aggro, list(
	"И грядет мое царствие...",
	"Я же БОГ. Как ты намереваешься убить БОГА?",
	"Я правил этой землей. И буду править снова!",
	"ТЫ УМРЕШЬ ЗА ЭТУ ДЕРЗОСТЬ!!!",
	"Склонись перед своим Королем!",
	"Ты будешь служить мне в смерти!",
	"Ваша ярость длится мгновения. Моя - вечно.",
	"ЗАБЫТЫЙ?! Я НЕ БЫЛ ЗАБЫТ! Я был... Я был...",
	"Сюда, смертные. Я обрушу на вас свой гнев!",
	"Сражаешься как герой! Именно поэтому ты умрешь первым.",
	"Я не могу пасть!",
	"*laugh",
))

/mob/living/carbon/human/species/human/northern/dungeonboss/forgottenking
	ai_controller = /datum/ai_controller/human_npc
	faction = list(FACTION_UNDEAD)
	ambushable = FALSE
	dodgetime = 40
	d_intent = INTENT_PARRY
	threat_point = THREAT_ELITE
	mob_biotypes = MOB_HUMANOID|MOB_UNDEAD
	var/fking_outfit = /datum/outfit/job/roguetown/npc/dungeon_boss/king

/mob/living/carbon/human/species/human/northern/dungeonboss/forgottenking/Initialize()
	. = ..()
	set_species(/datum/species/human/northern)
	gender = MALE
	fking_outfit = /datum/outfit/job/roguetown/npc/dungeon_boss/king
	transform = transform.Scale(1.25, 1.25)
	transform = transform.Translate(0, 0.25 * 16)
	addtimer(CALLBACK(src, PROC_REF(after_creation)), 1 SECONDS)

/mob/living/carbon/human/species/human/northern/dungeonboss/forgottenking/after_creation()
	..()
	AddComponent(/datum/component/ai_aggro_system)
	SEND_SIGNAL(src, COMSIG_MOB_MODIFY_AGGRO_LINES, GLOB.forgottenking_aggro, TRUE)
	name = "Forgotten King"
	real_name = name
	job = "King Dungeon Boss"
	ADD_TRAIT(src, TRAIT_NOMOOD, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_NOHUNGER, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_LEECHIMMUNE, INNATE_TRAIT)
	ADD_TRAIT(src, TRAIT_BREADY, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_HEAVYARMOR, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_BADTRAINER, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_NPC_EXAMINE, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_NOBREATH, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_DEATHLESS, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_NOPAIN, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_TOXIMMUNE, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_LIMBATTACHMENT, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_SILVER_WEAK, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_SELF_SUSTENANCE, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_INFINITE_STAMINA, TRAIT_GENERIC)

	equipOutfit(new /datum/outfit/job/roguetown/npc/dungeon_boss/king)
	for(var/obj/item/equipped_item in get_equipped_items() + held_items)
		equipped_item.AddComponent(/datum/component/item_on_drop/dust)
	for(var/obj/item/held_item in held_items)
		ADD_TRAIT(held_item, TRAIT_NODROP, TRAIT_GENERIC)
	def_intent_change(INTENT_PARRY)
	AddComponent(/datum/component/npc_death_line)
	dna.species.handle_body(src)
	src.regenerate_icons() //Fixes the weird body with random genders for NPCs.
	skeletonize()

/mob/living/carbon/human/species/human/northern/dungeonboss/forgottenking/fully_heal(admin_revive = FALSE, break_restraints = FALSE)
	. = ..()
	skeletonize()

/mob/living/carbon/human/species/human/northern/dungeonboss/forgottenking/proc/skeletonize()
	mob_biotypes |= MOB_UNDEAD
	var/obj/item/bodypart/O = get_bodypart(BODY_ZONE_R_ARM)
	if(O)
		O.drop_limb()
		qdel(O)
	O = get_bodypart(BODY_ZONE_L_ARM)
	if(O)
		O.drop_limb()
		qdel(O)
	regenerate_limb(BODY_ZONE_R_ARM)
	regenerate_limb(BODY_ZONE_L_ARM)
	var/obj/item/organ/eyes/eyes = getorganslot(ORGAN_SLOT_EYES)
	if(eyes)
		eyes.Remove(src,1)
		QDEL_NULL(eyes)
	eyes = SSwardrobe.provide_type(/obj/item/organ/eyes/night_vision/zombie)
	eyes.Insert(src)
	for(var/obj/item/bodypart/B in bodyparts)
		B.skeletonize(FALSE)
	update_body()
	if(fking_outfit)
		var/datum/outfit/OU = new fking_outfit
		if(OU)
			equipOutfit(OU)

/mob/living/carbon/human/species/human/northern/dungeonboss/forgottenking/death(gibbed, nocutscene = FALSE)
	. = ..()
	if(!gibbed)
		dust(FALSE, FALSE, TRUE)
	for(var/mob/M in range(7,src))
		shake_camera(M, 7, 1)
	var/turf/T = get_turf(src)
	new /obj/item/roguekey/mage/forgottenking(T)

/mob/living/carbon/human/species/human/northern/dungeonboss/forgottenking
	fking_outfit = /datum/outfit/job/roguetown/npc/dungeon_boss/king

/datum/outfit/job/roguetown/npc/dungeon_boss/king/pre_equip(mob/living/carbon/human/H)
	. = ..()
	H.STASTR = 18
	H.STASPD = 14
	H.STACON = 18
	H.STAWIL = 16
	H.STAPER = 14
	H.STAINT = 18
	H.STALUC = 10

	shirt = /obj/item/clothing/suit/roguetown/armor/chainmail/hauberk
	armor = /obj/item/clothing/suit/roguetown/armor/plate/full/blacksteel/modern
	pants = /obj/item/clothing/under/roguetown/platelegs/blacksteel/modern
	shoes = /obj/item/clothing/shoes/roguetown/boots/armor/blacksteel/modern
	gloves = /obj/item/clothing/gloves/roguetown/plate/blacksteel/modern
	head = /obj/item/clothing/head/roguetown/helmet/dungeon/kinghelmet
	neck = /obj/item/clothing/neck/roguetown/bevor/blacksteel/modern
	wrists = /obj/item/clothing/wrists/roguetown/bracers/blacksteel/modern
	belt = /obj/item/storage/belt/rogue/leather
	l_hand = /obj/item/rogueweapon/mace/maul/spiked

	H.adjust_skillrank(/datum/skill/combat/maces, 5, TRUE)
	H.adjust_skillrank(/datum/skill/combat/wrestling, 5, TRUE)
	H.adjust_skillrank(/datum/skill/combat/unarmed, 4, TRUE)

	H.dna.species.soundpack_m = GLOB.voice_packs[/datum/voicepack/male/knight] //HUZZAR!!

/obj/effect/oneway
	name = "one way effect"
	desc = ""
	icon = 'icons/effects/mapping_helpers.dmi'
	icon_state = "field_dir"
	invisibility = INVISIBILITY_MAXIMUM
	anchored = TRUE

/obj/effect/oneway/CanPass(atom/movable/mover, turf/target)
	var/turf/T = get_turf(src)
	var/turf/MT = get_turf(mover)
	return ..() && (T == MT || get_dir(MT,T) == dir)

/obj/effect/oneway/forgottenking //one way barrier to the boss room. Can be despawned with the key the boss drops.
	name = "magical barrier"
	max_integrity = 99999
	desc = "Victory or death - once you pass this point you will either triumph or fall. Recommended 3 players or more."
	icon = 'icons/effects/effects.dmi'
	icon_state = "smoke"
	invisibility = SEE_INVISIBLE_LIVING
	anchored = TRUE

/obj/effect/oneway/forgottenking/attackby(obj/item/W, mob/user, params)
	. = ..()
	if(istype(W, /obj/item/roguekey/mage/forgottenking))
		visible_message(span_boldannounce("The magical barrier disperses!"))
		qdel(src)

//Loot
/obj/item/roguekey/mage/forgottenking
	name = "forgotten king' key"
	desc = "An offputting key the King dropped."
	icon_state = "toothkey"
	lockid = "forgottenking"
