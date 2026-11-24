#define CTAG_SILVER_INQUISITION "silver_inquisition"
#define SILVER_INQUISITION_PQ 18
#define SILVER_HUNT_ARROWS 8
#define SILVER_HUNT_BOLTS 4
#define SILVER_INQUISITION_CLERIC_PATRONS list( \
	/datum/patron/divine/undivided, \
	/datum/patron/divine/astrata, \
	/datum/patron/divine/noc, \
	/datum/patron/divine/dendor, \
	/datum/patron/divine/abyssor, \
	/datum/patron/divine/ravox, \
	/datum/patron/divine/necra, \
	/datum/patron/divine/xylix, \
	/datum/patron/divine/pestra, \
	/datum/patron/divine/malum, \
	/datum/patron/divine/eora, \
	/datum/patron/inhumen/graggar, \
	/datum/patron/inhumen/matthios, \
	/datum/patron/inhumen/baotha, \
)

/datum/migrant_wave/silver_inquisition
	name = "Серебряная инквизиция"
	track = MIGRANT_TRACK_EVENT
	weight = 0
	can_roll = FALSE
	hidden = TRUE
	max_spawns = 1
	required_roles = list(
		/datum/migrant_role/silver_inquisitor = 3,
	)
	optional_roles = list(
		/datum/migrant_role/silver_inquisitor = 2,
	)
	greet_text = "Слишком много крови выпито в этих землях. Инквизиция собрала серебро, забыла о спорах между богами и отправила нас вычистить вампирское гнездо."

/datum/migrant_role/silver_inquisitor
	name = "Серебряный инквизитор"
	min_pq = SILVER_INQUISITION_PQ
	forbidden_races = list(RACES_CONSTRUCT RACES_DESPISED RACES_OOZE)
	banned_flaws = list(/datum/charflaw/silverweakness, /datum/charflaw/wanted)
	advclass_cat_rolls = list(CTAG_SILVER_INQUISITION = 20)
	townie_contract_gate_exempt = TRUE
	greet_text = "Вера у каждого в отряде своя, цель одна: очистить эти земли от вампирской угрозы."

/datum/migrant_role/silver_inquisitor/after_spawn(mob/living/carbon/human/character)
	. = ..()
	if(!character?.mind)
		return
	var/datum/objective/silver_inquisition/cleansing = new(owner = character.mind)
	character.mind.add_personal_objective(cleansing)
	character.mind.announce_personal_objectives()

/datum/objective/silver_inquisition
	name = "cleanse the vampire threat"
	explanation_text = "Очистить эти земли от вампирской угрозы."

/datum/objective/silver_inquisition/check_completion()
	for(var/datum/antagonist/vampire/vampire in GLOB.antagonists)
		if(considered_alive(vampire.owner))
			return FALSE
	return TRUE

/datum/advclass/silver_inquisitor
	name = "Инквизитор"
	allowed_sexes = list(MALE, FEMALE)
	category_tags = list(CTAG_DISABLED)
	cmode_music = sound("sound/music/combat_inqcommander.ogg")
	townie_contract_gate_exempt = TRUE
	vampcompat = FALSE
	tempo_capable = TRUE
	min_pq = SILVER_INQUISITION_PQ

/datum/advclass/silver_inquisitor/warrior
	name = "Инквизитор-воин"
	tutorial = "Вы первым входите в логово и последним из него выходите. Латы, щит и благословлённое серебро держат чудовищ на расстоянии от тех, кто идёт следом."
	outfit = /datum/outfit/job/roguetown/silver_inquisitor/warrior
	class_select_category = CLASS_CAT_WARRIOR
	category_tags = list(CTAG_SILVER_INQUISITION)
	traits_applied = list(
		TRAIT_STEELHEARTED,
		TRAIT_HEAVYARMOR,
		TRAIT_SILVER_BLESSED,
		TRAIT_INQUISITION,
		TRAIT_PERFECT_TRACKER,
	)
	subclass_stats = list(
		STATKEY_STR = 3,
		STATKEY_CON = 3,
		STATKEY_WIL = 3,
		STATKEY_PER = 1,
		STATKEY_SPD = -1,
	)
	subclass_skills = list(
		/datum/skill/combat/shields = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/wrestling = SKILL_LEVEL_EXPERT,
		/datum/skill/magic/holy = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/swords = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/maces = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/axes = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/knives = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/unarmed = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/athletics = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/tracking = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/climbing = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/swimming = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/riding = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/reading = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/medicine = SKILL_LEVEL_APPRENTICE,
	)

/datum/advclass/silver_inquisitor/archer
	name = "Инквизитор-лучник"
	tutorial = "Вампир быстр, но стрела быстрее. Вы выслеживаете добычу по крови и кладёте серебро туда, где когда-то билось сердце."
	outfit = /datum/outfit/job/roguetown/silver_inquisitor/archer
	class_select_category = CLASS_CAT_RANGER
	category_tags = list(CTAG_SILVER_INQUISITION)
	traits_applied = list(
		TRAIT_STEELHEARTED,
		TRAIT_DODGEEXPERT,
		TRAIT_SILVER_BLESSED,
		TRAIT_INQUISITION,
		TRAIT_PERFECT_TRACKER,
	)
	subclass_stats = list(
		STATKEY_PER = 3,
		STATKEY_SPD = 2,
		STATKEY_WIL = 2,
		STATKEY_STR = 1,
		STATKEY_CON = 1,
	)
	subclass_skills = list(
		/datum/skill/combat/bows = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/crossbows = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/magic/holy = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/knives = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/swords = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/wrestling = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/unarmed = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/tracking = SKILL_LEVEL_MASTER,
		/datum/skill/misc/sneaking = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/athletics = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/climbing = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/swimming = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/reading = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/medicine = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/traps = SKILL_LEVEL_JOURNEYMAN,
	)

/datum/advclass/silver_inquisitor/duelist
	name = "Инквизитор-дуэлянт"
	tutorial = "Вы не ломаете врага, а разбираете его по частям. Один точный укол благословлённого серебра стоит десяти ударов железом."
	outfit = /datum/outfit/job/roguetown/silver_inquisitor/duelist
	class_select_category = CLASS_CAT_ROGUE
	category_tags = list(CTAG_SILVER_INQUISITION)
	traits_applied = list(
		TRAIT_STEELHEARTED,
		TRAIT_DODGEEXPERT,
		TRAIT_SILVER_BLESSED,
		TRAIT_INQUISITION,
		TRAIT_PERFECT_TRACKER,
	)
	subclass_stats = list(
		STATKEY_SPD = 3,
		STATKEY_PER = 2,
		STATKEY_WIL = 2,
		STATKEY_INT = 1,
		STATKEY_CON = 1,
	)
	subclass_skills = list(
		/datum/skill/combat/swords = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/whipsflails = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/magic/holy = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/knives = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/wrestling = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/unarmed = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/athletics = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/climbing = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/tracking = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/sneaking = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/lockpicking = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/swimming = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/reading = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/medicine = SKILL_LEVEL_APPRENTICE,
	)

/datum/advclass/silver_inquisitor/mage
	name = "Инквизитор-маг"
	tutorial = "Против чужой магии нужна своя. Вы снимаете чары с логова, сжигаете то, до чего не дотянется клинок, и держите серебро под рукой на случай, если чары подведут."
	outfit = /datum/outfit/job/roguetown/silver_inquisitor/mage
	class_select_category = CLASS_CAT_MAGE
	category_tags = list(CTAG_SILVER_INQUISITION)
	traits_applied = list(
		TRAIT_STEELHEARTED,
		TRAIT_ARCYNE,
		TRAIT_SILVER_BLESSED,
		TRAIT_INQUISITION,
		TRAIT_PERFECT_TRACKER,
	)
	subclass_stats = list(
		STATKEY_INT = 4,
		STATKEY_PER = 2,
		STATKEY_WIL = 2,
		STATKEY_SPD = 1,
	)
	subclass_mage_aspects = list("mastery" = FALSE, "major" = 1, "minor" = 2, "utilities" = 8, "ward" = TRUE)
	subclass_skills = list(
		/datum/skill/magic/arcane = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/arcyne = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/staves = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/knives = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/wrestling = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/unarmed = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/reading = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/tracking = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/athletics = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/climbing = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/swimming = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/medicine = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/alchemy = SKILL_LEVEL_APPRENTICE,
	)

/datum/advclass/silver_inquisitor/cleric
	name = "Инквизитор-клерик"
	tutorial = "Вы несёте чудеса своего бога туда, где его имени боятся. Кому именно вы молитесь, отряду безразлично: вампиров ненавидят все."
	outfit = /datum/outfit/job/roguetown/silver_inquisitor/cleric
	class_select_category = CLASS_CAT_CLERIC
	category_tags = list(CTAG_SILVER_INQUISITION)
	allowed_patrons = SILVER_INQUISITION_CLERIC_PATRONS
	extra_context = "Подкласс доступен последователям любого бога, кроме Псайдона и Зизо."
	traits_applied = list(
		TRAIT_STEELHEARTED,
		TRAIT_MEDIUMARMOR,
		TRAIT_SILVER_BLESSED,
		TRAIT_INQUISITION,
		TRAIT_PERFECT_TRACKER,
	)
	subclass_stats = list(
		STATKEY_WIL = 3,
		STATKEY_STR = 2,
		STATKEY_CON = 2,
		STATKEY_INT = 1,
		STATKEY_PER = 1,
	)
	subclass_skills = list(
		/datum/skill/magic/holy = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/maces = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/whipsflails = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/shields = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/polearms = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/knives = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/wrestling = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/unarmed = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/medicine = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/reading = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/athletics = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/tracking = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/climbing = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/swimming = SKILL_LEVEL_JOURNEYMAN,
	)

/datum/outfit/job/roguetown/silver_inquisitor
	name = "Silver Inquisitor"
	var/list/silver_kits
	var/miracle_tier = CLERIC_T1
	var/miracle_regen = CLERIC_REGEN_WEAK
	var/miracle_limit = CLERIC_REQ_1

/datum/outfit/job/roguetown/silver_inquisitor/pre_equip(mob/living/carbon/human/inquisitor, visualsOnly = FALSE)
	..()
	has_loadout = TRUE
	cloak = get_order_tabard(inquisitor.patron)
	id = get_order_amulet(inquisitor.patron)
	shoes = /obj/item/clothing/shoes/roguetown/boots/otavan/inqboots
	belt = /obj/item/storage/belt/rogue/leather/black
	backl = /obj/item/storage/backpack/rogue/satchel/otavan
	backpack_contents = list(
		/obj/item/storage/belt/rogue/pouch/coins/mid = 1,
		/obj/item/flashlight/flare/torch/metal = 1,
		/obj/item/rogueweapon/scabbard/sheath/noble = 1,
	)
	if(istype(inquisitor.patron, /datum/patron/old_god))
		backpack_contents[/obj/item/rogueweapon/huntingknife/idagger/steel/silver/stake/psy/preblessed] = 1
	else
		backpack_contents[/obj/item/rogueweapon/huntingknife/idagger/steel/silver/stake/preblessed] = 1
	if(visualsOnly || !inquisitor.mind || isnull(miracle_tier))
		return
	var/datum/devotion/devotion = new /datum/devotion(inquisitor, inquisitor.patron)
	devotion.grant_miracles(inquisitor, cleric_tier = miracle_tier, passive_gain = miracle_regen, devotion_limit = miracle_limit)

/datum/outfit/job/roguetown/silver_inquisitor/proc/get_order_amulet(datum/patron/patron)
	var/static/list/amulets = list(
		/datum/patron/old_god = /obj/item/clothing/neck/roguetown/psicross/silver,
		/datum/patron/divine/undivided = /obj/item/clothing/neck/roguetown/psicross/silver/undivided,
		/datum/patron/divine/astrata = /obj/item/clothing/neck/roguetown/psicross/silver/astrata,
		/datum/patron/divine/noc = /obj/item/clothing/neck/roguetown/psicross/silver/noc,
		/datum/patron/divine/necra = /obj/item/clothing/neck/roguetown/psicross/silver/necra,
		/datum/patron/divine/dendor = /obj/item/clothing/neck/roguetown/psicross/silver/dendor,
		/datum/patron/divine/abyssor = /obj/item/clothing/neck/roguetown/psicross/silver/abyssor,
		/datum/patron/divine/ravox = /obj/item/clothing/neck/roguetown/psicross/silver/ravox,
		/datum/patron/divine/xylix = /obj/item/clothing/neck/roguetown/psicross/silver/xylix,
		/datum/patron/divine/pestra = /obj/item/clothing/neck/roguetown/psicross/silver/pestra,
		/datum/patron/divine/malum = /obj/item/clothing/neck/roguetown/psicross/silver/malum,
		/datum/patron/divine/eora = /obj/item/clothing/neck/roguetown/psicross/silver/eora,
		/datum/patron/inhumen/zizo = /obj/item/clothing/neck/roguetown/psicross/silver/zizo,
		/datum/patron/inhumen/graggar = /obj/item/clothing/neck/roguetown/psicross/silver/graggar,
		/datum/patron/inhumen/matthios = /obj/item/clothing/neck/roguetown/psicross/silver/matthios,
		/datum/patron/inhumen/baotha = /obj/item/clothing/neck/roguetown/psicross/silver/baotha,
	)
	return amulets[patron?.type] || /obj/item/clothing/neck/roguetown/psicross/silver

/datum/outfit/job/roguetown/silver_inquisitor/proc/get_order_tabard(datum/patron/patron)
	var/static/list/tabards = list(
		/datum/patron/old_god = /obj/item/clothing/cloak/tabard/devotee/psydon,
		/datum/patron/divine/undivided = /obj/item/clothing/cloak/tabard/stabard/crusader/t/undivided,
		/datum/patron/divine/astrata = /obj/item/clothing/cloak/tabard/devotee/astrata,
		/datum/patron/divine/noc = /obj/item/clothing/cloak/tabard/devotee/noc,
		/datum/patron/divine/necra = /obj/item/clothing/cloak/tabard/devotee/necra,
		/datum/patron/divine/dendor = /obj/item/clothing/cloak/tabard/devotee/dendor,
		/datum/patron/divine/abyssor = /obj/item/clothing/cloak/tabard/devotee/abyssor,
		/datum/patron/divine/ravox = /obj/item/clothing/cloak/tabard/devotee/ravox,
		/datum/patron/divine/xylix = /obj/item/clothing/cloak/tabard/devotee/xylix,
		/datum/patron/divine/pestra = /obj/item/clothing/cloak/tabard/devotee/pestra,
		/datum/patron/divine/malum = /obj/item/clothing/cloak/tabard/devotee/malum,
		/datum/patron/divine/eora = /obj/item/clothing/cloak/tabard/devotee/eora,
	)
	return tabards[patron?.type] || /obj/item/clothing/cloak/tabard/stabard/crusader/t

/datum/outfit/job/roguetown/silver_inquisitor/choose_loadout(mob/living/carbon/human/inquisitor)
	. = ..()
	if(!length(silver_kits))
		return
	var/choice = tgui_input_list(inquisitor, "Какое серебро я возьму в этот поход?", "СЕРЕБРО ИНКВИЗИЦИИ", silver_kits)
	if(QDELETED(inquisitor))
		return
	var/list/kit = silver_kits[choice || silver_kits[1]]
	var/list/kit_items = kit["items"]
	for(var/item_type in kit_items)
		give_kit_item(inquisitor, item_type, kit_items[item_type])
	var/list/kit_skills = kit["skills"]
	for(var/skill_type in kit_skills)
		inquisitor.adjust_skillrank_up_to(skill_type, kit_skills[skill_type], TRUE)
	if(!kit["implement"])
		return
	var/implement_type = choose_implement(inquisitor, kit["implement"])
	if(implement_type && !QDELETED(inquisitor))
		give_kit_item(inquisitor, implement_type, SLOT_BACK_R)

/datum/outfit/job/roguetown/silver_inquisitor/proc/give_kit_item(mob/living/carbon/human/inquisitor, item_type, slot)
	var/obj/item/kit_item = new item_type(get_turf(inquisitor))
	bless_silver(inquisitor, kit_item)
	if(slot && inquisitor.equip_to_slot_if_possible(kit_item, slot, FALSE, TRUE, TRUE, TRUE))
		return
	inquisitor.put_in_hands(kit_item)

/datum/outfit/job/roguetown/silver_inquisitor/proc/bless_silver(mob/living/carbon/human/inquisitor, obj/item/silver_item)
	var/datum/component/silverbless/blessing = silver_item.GetComponent(/datum/component/silverbless)
	if(!blessing || blessing.is_blessed)
		return
	if(istype(inquisitor.patron, /datum/patron/old_god))
		blessing.silver_type = SILVER_PSYDONIAN
		blessing.apply_bless(BLESSING_PSYDONIAN)
		return
	blessing.apply_bless(BLESSING_TENNITE)

/datum/outfit/job/roguetown/silver_inquisitor/warrior
	silver_kits = list(
		"Палаш и щит" = list(
			"items" = list(
				/obj/item/rogueweapon/sword/long/broadsword/silver = 0,
				/obj/item/rogueweapon/scabbard/sword/noble = SLOT_BELT_L,
				/obj/item/rogueweapon/shield/tower/metal = SLOT_BACK_R,
			),
			"skills" = list(/datum/skill/combat/swords = SKILL_LEVEL_EXPERT),
		),
		"Булава и щит" = list(
			"items" = list(
				/obj/item/rogueweapon/mace/steel/silver = 0,
				/obj/item/rogueweapon/shield/tower/metal = SLOT_BACK_R,
			),
			"skills" = list(/datum/skill/combat/maces = SKILL_LEVEL_EXPERT),
		),
		"Двуручный меч" = list(
			"items" = list(
				/obj/item/rogueweapon/greatsword/silver = 0,
				/obj/item/rogueweapon/scabbard/gwstrap = SLOT_BACK_R,
			),
			"skills" = list(/datum/skill/combat/swords = SKILL_LEVEL_EXPERT),
		),
		"Секира" = list(
			"items" = list(
				/obj/item/rogueweapon/greataxe/steel/knight/silver = 0,
				/obj/item/rogueweapon/scabbard/gwstrap = SLOT_BACK_R,
			),
			"skills" = list(/datum/skill/combat/axes = SKILL_LEVEL_EXPERT),
		),
	)

/datum/outfit/job/roguetown/silver_inquisitor/warrior/pre_equip(mob/living/carbon/human/inquisitor, visualsOnly = FALSE)
	..()
	head = /obj/item/clothing/head/roguetown/helmet/heavy/bucket/crusader
	neck = /obj/item/clothing/neck/roguetown/gorget/steel
	shirt = /obj/item/clothing/suit/roguetown/armor/leather/studded/cuirbouilli
	armor = /obj/item/clothing/suit/roguetown/armor/plate/full/fluted
	pants = /obj/item/clothing/under/roguetown/platelegs
	gloves = /obj/item/clothing/gloves/roguetown/plate
	wrists = /obj/item/clothing/wrists/roguetown/bracers
	shoes = /obj/item/clothing/shoes/roguetown/boots/armor
	belt = /obj/item/storage/belt/rogue/leather/steel

/datum/outfit/job/roguetown/silver_inquisitor/archer
	silver_kits = list(
		"Длинный лук и короткий меч" = list(
			"items" = list(
				/obj/item/gun/ballistic/revolver/grenadelauncher/bow/longbow = SLOT_BACK_R,
				/obj/item/quiver/silver_hunt = SLOT_BELT_R,
				/obj/item/rogueweapon/sword/short/silver = 0,
				/obj/item/rogueweapon/scabbard/sword/noble = SLOT_BELT_L,
			),
			"skills" = list(/datum/skill/combat/bows = SKILL_LEVEL_EXPERT),
		),
		"Арбалет и короткий меч" = list(
			"items" = list(
				/obj/item/gun/ballistic/revolver/grenadelauncher/crossbow = SLOT_BACK_R,
				/obj/item/quiver/bolt/silver_hunt = SLOT_BELT_R,
				/obj/item/rogueweapon/sword/short/silver = 0,
				/obj/item/rogueweapon/scabbard/sword/noble = SLOT_BELT_L,
			),
			"skills" = list(/datum/skill/combat/crossbows = SKILL_LEVEL_EXPERT),
		),
	)

/datum/outfit/job/roguetown/silver_inquisitor/archer/pre_equip(mob/living/carbon/human/inquisitor, visualsOnly = FALSE)
	..()
	head = /obj/item/clothing/head/roguetown/inqhat
	neck = /obj/item/clothing/neck/roguetown/chaincoif
	shirt = /obj/item/clothing/suit/roguetown/armor/gambeson/heavy/inq
	armor = /obj/item/clothing/suit/roguetown/armor/plate/scale/inqcoat
	pants = /obj/item/clothing/under/roguetown/heavy_leather_pants/otavan
	gloves = /obj/item/clothing/gloves/roguetown/otavan/inqgloves
	wrists = /obj/item/clothing/wrists/roguetown/bracers/leather

/datum/outfit/job/roguetown/silver_inquisitor/duelist
	silver_kits = list(
		"Рапира и кинжал" = list(
			"items" = list(
				/obj/item/rogueweapon/sword/rapier/silver = 0,
				/obj/item/rogueweapon/scabbard/sword/noble = SLOT_BELT_L,
				/obj/item/rogueweapon/huntingknife/idagger/steel/silver = 0,
			),
			"skills" = list(/datum/skill/combat/swords = SKILL_LEVEL_EXPERT),
		),
		"Короткий меч и кинжал" = list(
			"items" = list(
				/obj/item/rogueweapon/sword/short/silver = 0,
				/obj/item/rogueweapon/scabbard/sword/noble = SLOT_BELT_L,
				/obj/item/rogueweapon/huntingknife/idagger/steel/silver = 0,
			),
			"skills" = list(/datum/skill/combat/swords = SKILL_LEVEL_EXPERT),
		),
		"Кнут и кинжал" = list(
			"items" = list(
				/obj/item/rogueweapon/whip/silver = SLOT_BELT_L,
				/obj/item/rogueweapon/huntingknife/idagger/steel/silver = 0,
			),
			"skills" = list(/datum/skill/combat/whipsflails = SKILL_LEVEL_EXPERT),
		),
	)

/datum/outfit/job/roguetown/silver_inquisitor/duelist/pre_equip(mob/living/carbon/human/inquisitor, visualsOnly = FALSE)
	..()
	head = /obj/item/clothing/head/roguetown/inqhat
	neck = /obj/item/clothing/neck/roguetown/gorget/steel
	shirt = /obj/item/clothing/suit/roguetown/armor/gambeson/heavy/inq
	armor = /obj/item/clothing/suit/roguetown/armor/plate/scale/inqcoat
	pants = /obj/item/clothing/under/roguetown/heavy_leather_pants/otavan
	gloves = /obj/item/clothing/gloves/roguetown/otavan/inqgloves
	wrists = /obj/item/clothing/wrists/roguetown/bracers/leather
	if(istype(inquisitor.patron, /datum/patron/old_god))
		belt = /obj/item/storage/belt/rogue/leather/tossbelt/blade/black/silver/psy/preblessed
	else
		belt = /obj/item/storage/belt/rogue/leather/tossbelt/blade/black/silver/preblessed

/datum/outfit/job/roguetown/silver_inquisitor/mage
	miracle_tier = null
	silver_kits = list(
		"Магический посох и серебряный кинжал" = list(
			"items" = list(
				/obj/item/rogueweapon/huntingknife/idagger/steel/silver = 0,
			),
			"implement" = "greater",
		),
		"Серебряный боевой шест" = list(
			"items" = list(
				/obj/item/rogueweapon/woodstaff/quarterstaff/steel/silver = 0,
				/obj/item/rogueweapon/scabbard/gwstrap = SLOT_BACK_R,
			),
			"skills" = list(/datum/skill/combat/staves = SKILL_LEVEL_EXPERT),
		),
	)

/datum/outfit/job/roguetown/silver_inquisitor/mage/pre_equip(mob/living/carbon/human/inquisitor, visualsOnly = FALSE)
	..()
	head = /obj/item/clothing/head/roguetown/inqhat
	neck = /obj/item/clothing/neck/roguetown/chaincoif
	shirt = /obj/item/clothing/suit/roguetown/armor/gambeson/heavy/inq
	armor = /obj/item/clothing/suit/roguetown/armor/plate/scale/inqcoat
	pants = /obj/item/clothing/under/roguetown/heavy_leather_pants/otavan
	gloves = /obj/item/clothing/gloves/roguetown/otavan/inqgloves
	wrists = /obj/item/clothing/wrists/roguetown/bracers/leather
	beltr = /obj/item/storage/magebag
	backpack_contents[/obj/item/rogueweapon/spellbook/greater] = 1
	backpack_contents[/obj/item/chalk] = 1
	backpack_contents[/obj/item/reagent_containers/glass/bottle/rogue/manapot] = 1

/datum/outfit/job/roguetown/silver_inquisitor/cleric
	miracle_tier = CLERIC_T3
	miracle_regen = CLERIC_REGEN_MINOR
	miracle_limit = CLERIC_REQ_3
	silver_kits = list(
		"Булава и щит" = list(
			"items" = list(
				/obj/item/rogueweapon/mace/steel/silver = 0,
				/obj/item/rogueweapon/shield/tower/metal = SLOT_BACK_R,
			),
			"skills" = list(/datum/skill/combat/maces = SKILL_LEVEL_EXPERT),
		),
		"Молот и щит" = list(
			"items" = list(
				/obj/item/rogueweapon/mace/warhammer/steel/silver = 0,
				/obj/item/rogueweapon/shield/tower/metal = SLOT_BACK_R,
			),
			"skills" = list(/datum/skill/combat/maces = SKILL_LEVEL_EXPERT),
		),
		"Моргенштерн и щит" = list(
			"items" = list(
				/obj/item/rogueweapon/flail/sflail/silver = 0,
				/obj/item/rogueweapon/shield/tower/metal = SLOT_BACK_R,
			),
			"skills" = list(/datum/skill/combat/whipsflails = SKILL_LEVEL_EXPERT),
		),
		"Алебарда" = list(
			"items" = list(
				/obj/item/rogueweapon/halberd/silver = 0,
				/obj/item/rogueweapon/scabbard/gwstrap = SLOT_BACK_R,
			),
			"skills" = list(/datum/skill/combat/polearms = SKILL_LEVEL_EXPERT),
		),
	)

/datum/outfit/job/roguetown/silver_inquisitor/cleric/pre_equip(mob/living/carbon/human/inquisitor, visualsOnly = FALSE)
	..()
	head = /obj/item/clothing/head/roguetown/helmet/sallet/visored
	neck = /obj/item/clothing/neck/roguetown/chaincoif
	shirt = /obj/item/clothing/suit/roguetown/armor/gambeson/heavy/inq
	armor = /obj/item/clothing/suit/roguetown/armor/chainmail/hauberk
	pants = /obj/item/clothing/under/roguetown/chainlegs
	gloves = /obj/item/clothing/gloves/roguetown/chain
	wrists = /obj/item/clothing/wrists/roguetown/bracers
	if(!visualsOnly && istype(inquisitor.patron, /datum/patron/divine/dendor))
		inquisitor.adjust_skillrank_up_to(/datum/skill/magic/druidic, SKILL_LEVEL_JOURNEYMAN, TRUE)

/obj/item/quiver/silver_hunt/Initialize(mapload)
	. = ..()
	for(var/arrow_number in 1 to max_storage)
		if(arrow_number <= SILVER_HUNT_ARROWS)
			arrows += new /obj/item/ammo_casing/caseless/rogue/arrow/silver()
		else
			arrows += new /obj/item/ammo_casing/caseless/rogue/arrow/steel()
	update_icon()

/obj/item/quiver/bolt/silver_hunt/Initialize(mapload)
	. = ..()
	for(var/bolt_number in 1 to max_storage)
		if(bolt_number <= SILVER_HUNT_BOLTS)
			arrows += new /obj/item/ammo_casing/caseless/rogue/bolt/silver()
		else
			arrows += new /obj/item/ammo_casing/caseless/rogue/bolt/holy()
	update_icon()

#undef CTAG_SILVER_INQUISITION
#undef SILVER_INQUISITION_PQ
#undef SILVER_HUNT_ARROWS
#undef SILVER_HUNT_BOLTS
#undef SILVER_INQUISITION_CLERIC_PATRONS
