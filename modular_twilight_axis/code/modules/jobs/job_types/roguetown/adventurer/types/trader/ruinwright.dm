/datum/advclass/trader/ruinwright
	name = "Grim Ruinwright"
	tutorial = "When markets burned and cities fell, you did not. You trade in salvage, rebuild from rot, and survive where others starve. Hope is a luxury. Skill is currency."
	allowed_sexes = list(MALE, FEMALE)
	allowed_races = RACES_ALL_KINDS
	outfit = /datum/outfit/job/roguetown/homesteader
	age_mod = /datum/class_age_mod/ruinwright
	traits_applied = list(TRAIT_JACKOFALLTRADES,
		TRAIT_ALCHEMY_EXPERT,
		TRAIT_SMITHING_EXPERT,
		TRAIT_SEWING_EXPERT,
		TRAIT_SURVIVAL_EXPERT,
		TRAIT_HOMESTEAD_EXPERT // No medicine but they get the full package
	)
	category_tags = list(CTAG_TRADER)
	class_select_category = CLASS_CAT_TRADER
	adaptive_name = TRUE
	subclass_stats = list(
		STATKEY_INT = 3,	//This guy's here to grind = baby.
		STATKEY_STR = 1,
		STATKEY_WIL = 1,
		STATKEY_PER = 1,
		STATKEY_LCK = 1,
	)
	subclass_skills = list(
		/datum/skill/labor/farming = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/axes = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/unarmed = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/knives = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/wrestling = SKILL_LEVEL_NOVICE,

		/datum/skill/misc/climbing = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/athletics = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/swimming = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/stealing = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/music = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/reading = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/medicine = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/sewing = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/ceramics = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/tracking = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/lockpicking = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/sneaking = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/riding = SKILL_LEVEL_APPRENTICE,

		/datum/skill/craft/crafting = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/carpentry = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/masonry = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/engineering = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/traps = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/alchemy = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/tanning = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/cooking = SKILL_LEVEL_APPRENTICE,

		/datum/skill/labor/lumberjacking = SKILL_LEVEL_APPRENTICE,
		/datum/skill/labor/fishing = SKILL_LEVEL_APPRENTICE,
		/datum/skill/labor/butchering = SKILL_LEVEL_APPRENTICE,
	)
	maximum_possible_slots = 3 // Should not fill, just a hack to make it shows what types of traders are in round

/datum/outfit/job/roguetown/homesteader/pre_equip(mob/living/carbon/human/H)
	..()
	head = pick(/obj/item/clothing/head/roguetown/hatfur,
	/obj/item/clothing/head/roguetown/hatblu,
	/obj/item/clothing/head/roguetown/nightman,
	/obj/item/clothing/head/roguetown/roguehood,
	/obj/item/clothing/head/roguetown/roguehood/random,
	/obj/item/clothing/head/roguetown/roguehood/shalal/heavyhood,
	/obj/item/clothing/head/roguetown/fancyhat)

	if(prob(50))
		mask = /obj/item/clothing/mask/rogue/spectacles

	cloak = pick(/obj/item/clothing/cloak/raincloak/furcloak,
	/obj/item/clothing/cloak/half)

	armor = pick(/obj/item/clothing/suit/roguetown/armor/workervest,
	/obj/item/clothing/suit/roguetown/armor/leather/vest)

	pants = pick(/obj/item/clothing/under/roguetown/trou,
	/obj/item/clothing/under/roguetown/tights/random)

	shirt = pick(/obj/item/clothing/suit/roguetown/shirt/undershirt/random,
	/obj/item/clothing/suit/roguetown/shirt/undershirt/puritan,
	/obj/item/clothing/suit/roguetown/armor/gambeson/light)

	shoes = pick(/obj/item/clothing/shoes/roguetown/boots/leather,
	/obj/item/clothing/shoes/roguetown/shortboots)

	belt = /obj/item/storage/belt/rogue/leather
	beltr = /obj/item/storage/belt/rogue/pouch/coins/mid
	beltl = /obj/item/flashlight/flare/torch/lantern
	backl = /obj/item/storage/backpack/rogue/backpack
	backpack_contents = list(
						/obj/item/flint = 1,
						/obj/item/flashlight/flare/torch = 1,
						/obj/item/rogueweapon/handsaw = 1,
						/obj/item/dye_brush = 1,
						/obj/item/recipe_book/builder = 1,
						/obj/item/recipe_book/survival = 1,
						/obj/item/reagent_containers/powder/salt = 3,
						/obj/item/reagent_containers/food/snacks/rogue/cheddar = 2,
						/obj/item/natural/cloth = 2,
						/obj/item/book/rogue/yeoldecookingmanual = 1,
						/obj/item/natural/worms = 2,
						/obj/item/rogueweapon/shovel/small = 1,
						/obj/item/hair_dye_cream = 3,
						/obj/item/rogueweapon/chisel = 1,
						/obj/item/natural/clay = 3,
						/obj/item/natural/clay/glassbatch = 1,
						/obj/item/rogueore/coal = 1,
						/obj/item/roguegear = 1,
	)
	if(H.mind)
		H.mind.special_items["Hammer"] = /obj/item/rogueweapon/hammer/steel
		H.mind.special_items["Sheathe"] = /obj/item/rogueweapon/scabbard/sheath
		H.mind.special_items["Hunting Knife"] = /obj/item/rogueweapon/huntingknife
		H.mind.special_items["Woodcutter's Axe"] = /obj/item/rogueweapon/stoneaxe/woodcut/steel/woodcutter
		H.mind.special_items["[pick("Good", "Bad", "Normal")] Day's Wine"] = /obj/item/reagent_containers/glass/bottle/rogue/wine
		H.mind.special_items["Barber's Innocuous Bag"] = /obj/item/storage/belt/rogue/surgery_bag/full
		H.mind.special_items["Trusty Pick"] = /obj/item/rogueweapon/pick
		H.mind.special_items["Hoe"] = /obj/item/rogueweapon/hoe
		H.mind.special_items["Tuneful Instrument"] = pick(subtypesof(/obj/item/rogue/instrument))
		H.mind.special_items["Fishing Rod"] = /obj/item/fishingrod/crafted
		H.mind.special_items["Pan for Frying"] = /obj/item/cooking/pan

		H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/diagnose/secular)

/datum/job/roguetown/trader/New()
	. = ..()
	job_subclasses |= list(/datum/advclass/trader/ruinwright)

/datum/class_age_mod/ruinwright/apply_age_mod(mob/living/carbon/human/H)
	if(!H)
		return

	var/list/age_skill_list = list(
		/datum/skill/misc/music,
		/datum/skill/misc/reading,
		/datum/skill/misc/medicine,
		/datum/skill/craft/sewing,
		/datum/skill/craft/ceramics,
		/datum/skill/misc/tracking,
		/datum/skill/misc/riding,

		/datum/skill/craft/crafting,
		/datum/skill/craft/carpentry,
		/datum/skill/craft/masonry,
		/datum/skill/craft/engineering,
		/datum/skill/craft/traps,
		/datum/skill/craft/alchemy,
		/datum/skill/craft/tanning,
		/datum/skill/craft/cooking,

		/datum/skill/labor/lumberjacking,
		/datum/skill/labor/fishing,
		/datum/skill/labor/butchering
	)

	switch(H.age)

		if(AGE_MIDDLEAGED)
			for(var/skill_type in age_skill_list)
				H.adjust_skillrank(skill_type, 1, TRUE)
			H.change_stat(STATKEY_INT, 1)
			H.change_stat(STATKEY_STR, -1)
			to_chat(H, span_notice("Years of hard trade have sharpened your mind."))
			to_chat(H, span_warning("But the road has begun to wear your body down."))

		if(AGE_OLD)
			for(var/skill_type in age_skill_list)
				H.adjust_skillrank(skill_type, 2, TRUE)

			H.change_stat(STATKEY_STR, -2)
			H.change_stat(STATKEY_INT, 2)
			H.change_stat(STATKEY_SPD, -1)
			to_chat(H, span_notice("Decades among ruins have made you cunning beyond skilled."))
			to_chat(H, span_danger("But time takes its toll on flesh and sinew."))

/datum/job/roguetown/trader/after_spawn(mob/living/H, mob/M, latejoin = FALSE)
	. = ..()

	if(!ishuman(H))
		return

	if(SSmapping?.config?.map_file != "dun_world")
		return

	var/datum/advclass/AC = SSrole_class_handler.get_advclass_by_name(H.advjob)

	if(istype(AC, /datum/advclass/trader/ruinwright))
		handle_ruinwright_spawn(H)

/proc/handle_ruinwright_spawn(mob/living/carbon/human/H)
	if(!H)
		return

	var/roll = rand(1, 100)

	if(roll <= 25)
		return

	var/turf/T
	var/message

	if(roll <= 50)
		T = locate(23, 326, 4)
		message = span_danger("You awaken where death walks openly.")

	else if(roll <= 75)
		T = locate(151, 331, 3)
		message = span_warning("The air here carries the scent of trouble.")

	else
		T = locate(137, 258, 2)
		message = span_notice("This place feels uneasy, but survivable.")

	if(!T)
		return

	H.forceMove(T)
	to_chat(H, message)



