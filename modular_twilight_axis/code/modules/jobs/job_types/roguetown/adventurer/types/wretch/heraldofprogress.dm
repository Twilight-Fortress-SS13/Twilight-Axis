/datum/advclass/wretch/herald_of_progress
	name = "Herald of Salvation"
	tutorial = "Your melodies bring about melancholy visions of the future. Your soliloquies are punctuated by whispered truths of the past. Dread change, the promises of tomorrow come to fruition all the same. You are the herald of salvation, a soothsayer of what is to be. The realm is a stage, and you are Her voice."
	allowed_sexes = list(MALE, FEMALE)
	outfit = /datum/outfit/job/roguetown/wretch/herald_of_progress
	cmode_music = 'modular_twilight_axis/sound/music/combat/combatheraldprogress.ogg'
	class_select_category = CLASS_CAT_CLERIC
	category_tags = list(CTAG_WRETCH)
	traits_applied = list(TRAIT_DODGEEXPERT, TRAIT_DECEIVING_MEEKNESS, TRAIT_ARCYNE)
	subclass_mage_aspects = list("mastery" = FALSE, "major" = 1, "minor" = 0, "utilities" = 3, "locked_aspects" = list(/datum/magic_aspect/fulgurmancy))
	maximum_possible_slots = 1 // only one frontman
	subclass_skills = list(
		/datum/skill/misc/swimming = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/athletics = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/wrestling = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/unarmed = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/knives = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/axes = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/climbing = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/reading = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/stealing = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/lockpicking = SKILL_LEVEL_JOURNEYMAN, //sneaky evil bard
		/datum/skill/misc/music = SKILL_LEVEL_LEGENDARY,
		/datum/skill/magic/holy = SKILL_LEVEL_EXPERT,
		/datum/skill/magic/arcane = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/crafting = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/sewing = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/medicine = SKILL_LEVEL_JOURNEYMAN,
	)
	subclass_stats = list(
		STATKEY_WIL = 4,
		STATKEY_CON = 2,
		STATKEY_SPD = 2,
	)
	subclass_stashed_items = list(
		"Sewing Kit" = /obj/item/repair_kit,
		"Stashed Funds" = /obj/item/roguecoin/silver/pile/wretchpile
	)

/datum/outfit/job/roguetown/wretch/herald_of_progress/pre_equip(mob/living/carbon/human/H)
	head = /obj/item/clothing/head/roguetown/roguehood/red
	mask = /obj/item/clothing/mask/rogue/lordmask/zizite
	cloak = /obj/item/clothing/cloak/raincloak/red
	neck = /obj/item/clothing/neck/roguetown/chaincoif
	pants = /obj/item/clothing/under/roguetown/heavy_leather_pants
	shirt = /obj/item/clothing/suit/roguetown/armor/gambeson
	backl = /obj/item/storage/backpack/rogue/satchel
	armor = /obj/item/clothing/suit/roguetown/shirt/robe/monk
	r_hand = /obj/item/rogue/instrument/ztratocaster
	belt = /obj/item/storage/belt/rogue/leather/tossbelt/blade/iron
	beltr  = /obj/item/rogueweapon/huntingknife/idagger/steel
	gloves = /obj/item/clothing/gloves/roguetown/fingerless_leather
	id = /obj/item/clothing/neck/roguetown/psicross/inhumen/aalloy/cult
	shoes = /obj/item/clothing/shoes/roguetown/boots/maille/iron
	backpack_contents = list(
		/obj/item/storage/belt/rogue/pouch/coins/poor = 1,
		/obj/item/flashlight/flare/torch/lantern/prelit = 1,
		/obj/item/rogueweapon/scabbard/sheath = 1,
		/obj/item/lockpick = 1,
		/obj/item/reagent_containers/glass/bottle/rogue/manapot	= 1,
		/obj/item/reagent_containers/glass/bottle/alchemical/healthpot = 1,
		)
	if(H.mind)
		H.set_patron(/datum/patron/inhumen/zizo)
		if(H.mind.current)
			H.mind.current.faction += "[H.name]_faction"
		var/datum/devotion/C = new /datum/devotion(H, H.patron)
		C.grant_miracles(H, cleric_tier = CLERIC_T3, passive_gain = CLERIC_REGEN_MINOR, start_maxed = TRUE)
		H.mind.RemoveSpell(new /datum/action/cooldown/spell/zizo/rituos)
		H.mind.RemoveSpell(new /datum/action/cooldown/spell/conjure_summon/zizo/skeleton_swarm)
		H.mind.AddSpell(new /datum/action/cooldown/spell/conjure_summon/zizo/skeleton_swarm/sotto)
		var/datum/inspiration/I = new /datum/inspiration(H)
		I.grant_inspiration(H, bard_tier = BARD_T2)
		H.set_blindness(0)
		wretch_select_bounty(H)
	var/skelet = list("Yes", "No")
	var/skelet_choice = input(H, "Choose your specie.", "WANNA BE SKELETON?") as anything in skelet
	H.set_blindness(0)
	switch(skelet_choice)
		if("Yes")
			skelet(H)
		if("No")
			return TRUE

/datum/outfit/job/roguetown/wretch/herald_of_progress/proc/skelet(mob/living/carbon/human/H)
	REMOVE_TRAITS_IN(H, SPECIES_TRAIT)
	H.hairstyle = "Bald"
	H.facial_hairstyle = "Shaved"
	H.select_skeleton_features()
	H.choose_name_popup("undead bard")
	H.mind.add_antag_datum(new /datum/antagonist/skeleton())
	change_origin(H, /datum/virtue/origin/unselectable/skeleton, "Legion")
	ADD_TRAIT(H, TRAIT_LIMBATTACHMENT, TRAIT_GENERIC)
	ADD_TRAIT(H, TRAIT_SILVER_WEAK, TRAIT_GENERIC)
	ADD_TRAIT(H, TRAIT_ZOMBIE_IMMUNE, TRAIT_GENERIC)
	ADD_TRAIT(H, TRAIT_FACELESS_KNOWN, TRAIT_GENERIC)
	ADD_TRAIT(H, TRAIT_NOMOOD, TRAIT_GENERIC)
	ADD_TRAIT(H, TRAIT_DEATHLESS, TRAIT_GENERIC)
	H.dna.species.species_traits |= NOBLOOD
	H.mob_biotypes = MOB_UNDEAD
	H.become_skeleton()
	var/obj/item/organ/eyes/eyes = H.getorganslot(ORGAN_SLOT_EYES)
	if (eyes)
		eyes.Remove(H, TRUE)
		QDEL_NULL(eyes)
	eyes = new /obj/item/organ/eyes/night_vision/zombie
	eyes.Insert(H)
	H.update_body()
	H.update_hair()
	H.update_body_parts(redraw = TRUE)
	for(var/datum/charflaw/cf in H.charflaws)
		H.charflaws.Remove(cf)
		QDEL_NULL(cf)
	H.dna.species.soundpack_m = new /datum/voicepack/skeleton()
	H.dna.species.soundpack_f = new /datum/voicepack/skeleton()

/obj/item/rogue/instrument/ztratocaster
	name = "Salus"
	desc = "An guitar with two necks, which uses lost technologies of Celestial Empire, what is inaccessible for mortal creatures. She radiates a strange, cursed energy and her body sharp enough to shred."
	icon = 'modular_twilight_axis/icons/obj/items/zizocazter.dmi'
	icon_state = "ztratocaster"
	force = 15
	force_wielded = 35
	possible_item_intents = list(/datum/intent/axe/cut, /datum/intent/axe/chop, SPEAR_BASH)
	gripped_intents = list(/datum/intent/axe/cut/long, /datum/intent/axe/chop/long, SPEAR_BASH)
	associated_skill = /datum/skill/combat/axes
	song_list = list("Laid To Rest" = 'modular_twilight_axis/sound/music/instruments/ztrato (1).ogg',
	"Fulmen" = 'modular_twilight_axis/sound/music/instruments/ztrato (2).ogg',
	"Painkiller" = 'modular_twilight_axis/sound/music/instruments/ztrato (3).ogg',
	"Abyssor's Bane" = 'modular_twilight_axis/sound/music/instruments/ztrato (4).ogg',
	"Holy Warrior" = 'modular_twilight_axis/sound/music/instruments/ztrato (5).ogg',
	"Be the lightning" = 'modular_twilight_axis/sound/music/instruments/ztrato (6).ogg',
	"The last stand" = 'modular_twilight_axis/sound/music/instruments/ztrato (7).ogg',
	"The bell rings for Psydon" = 'modular_twilight_axis/sound/music/instruments/ztrato (8).ogg',
	"I came from hell" = 'modular_twilight_axis/sound/music/instruments/ztrato (9).ogg',
	"Your punishment" = 'modular_twilight_axis/sound/music/instruments/ztrato (10).ogg',
	"Breaking in" = 'modular_twilight_axis/sound/music/instruments/ztrato (11).ogg',
	"Disgraceful" = 'modular_twilight_axis/sound/music/instruments/ztrato (12).ogg')
	blade_dulling = DULLING_BASHCHOP
	w_class = WEIGHT_CLASS_HUGE
	minstr = 8
	max_blade_int = 300
	max_integrity = 250
	anvilrepair = /datum/skill/craft/weaponsmithing
	obj_flags = CAN_BE_HIT
	integrity_failure = 0.2
	smeltresult = null
	wdefense = 7
	wbalance = WBALANCE_NORMAL
	experimental_onhip = TRUE
	experimental_onback = TRUE

/obj/item/rogue/instrument/ztratocaster/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/cursed_item, TRAIT_CABAL, "INSTRUMENT")

/obj/item/rogue/instrument/ztratocaster/get_examine_highlight_status()
	return list(EXAMINEHIGHLIGHT_HERESYSEVERITY_ALARMING, HERESYDESC_ZIZO_WEAPON)

/obj/item/rogue/instrument/ztratocaster/getonmobprop(tag)
	. = ..()
	if(tag)
		switch(tag)
			if("wielded")
				return list("shrink" = 0.6,"sx" = 5,"sy" = -3,"nx" = -5,"ny" = -2,"wx" = -5,"wy" = -1,"ex" = 3,"ey" = -2,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = 7,"sturn" = -7,"wturn" = 16,"eturn" = -22,"nflip" = 8,"sflip" = 0,"wflip" = 8,"eflip" = 0)
			if("onbelt")
				return list("shrink" = 0.3,"sx" = -2,"sy" = -5,"nx" = 4,"ny" = -5,"wx" = 0,"wy" = -5,"ex" = 2,"ey" = -5,"nturn" = 0,"sturn" = 0,"wturn" = 0,"eturn" = 0,"nflip" = 0,"sflip" = 0,"wflip" = 0,"eflip" = 0,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0)

/obj/item/clothing/mask/rogue/lordmask/zizite
	name = "fateful visage"
	icon = 'modular_twilight_axis/icons/roguetown/clothing/masks.dmi'
	mob_overlay_icon = 'modular_twilight_axis/icons/roguetown/clothing/onmob/masks.dmi'
	item_state = "zizomask"
	icon_state = "zizomask"
	desc = "To advance, at any cost."
	alternate_worn_layer = HOOD_LAYER
	max_integrity = ARMOR_INT_MASK_IRON + 100
	armor = ARMOR_PLATE
	flags_inv = HIDEFACE|HIDESNOUT
	sellprice = 0

/datum/action/cooldown/spell/conjure_summon/zizo/skeleton_swarm/sotto
	sound = list('modular_twilight_axis/sound/magic/sottovoce.ogg')
