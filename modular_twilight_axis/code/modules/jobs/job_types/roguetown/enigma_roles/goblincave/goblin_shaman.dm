/datum/job/roguetown/goblin_shaman
	title = "Goblin Shaman"
	flag = GOBLINSHAMAN
	department_flag = GOBLINCAVE
	faction = "Station"
	total_positions = 1
	spawn_positions = 1
	allowed_races = list(
		/datum/species/goblinp,
	)
	allowed_patrons = list(/datum/patron/inhumen/graggar)
	tutorial = "Ты — Шаман, голос Граггара в племени. Твоя магия — кровь, страх и сломанные души: вырезаешь руны, питаешься криками. Каждый ритуал доказывает — без твоих проклятий и крови племя сгинет."
	class_categories = FALSE

	outfit = null
	outfit_female = null

	display_order = JDO_GOBLINSHAMAN
	selection_color = JCOLOR_WANDERER
	show_in_credits = FALSE
	min_pq = -30
	max_pq = null

	advclass_cat_rolls = list(CTAG_GOBLINSHAMAN = 10)

	announce_latejoin = FALSE
	wanderer_examine = TRUE
	advjob_examine = FALSE
	always_show_on_latechoices = TRUE
	job_reopens_slots_on_death = FALSE
	same_job_respawn_delay = 30 MINUTES

	cmode_music = 'sound/music/cmode/antag/combat_darkstar.ogg'

	job_subclasses = list(
		/datum/advclass/goblin_shaman/shaman,
	)

/datum/job/roguetown/goblin_shaman/after_spawn(mob/living/H, mob/M, latejoin = TRUE)
	. = ..()
	if(ishuman(H))
		var/mob/living/carbon/human/human = H
		human.grant_language(/datum/language/orcish)

/datum/advclass/goblin_shaman/shaman
	name = "Shaman"
	tutorial = "Ты — Шаман, голос Граггара в племени. Твоя магия — кровь, страх и сломанные души: вырезаешь руны, питаешься криками. Каждый ритуал доказывает — без твоих проклятий и крови племя сгинет."
	outfit = /datum/outfit/job/roguetown/goblin_shaman/shaman
	category_tags = list(CTAG_GOBLINSHAMAN)
	traits_applied = list(TRAIT_MAGEARMOR, TRAIT_ARCYNE_T3, TRAIT_INTELLECTUAL, TRAIT_ALCHEMY_EXPERT, TRAIT_HERESIARCH, TRAIT_STEELHEARTED, TRAIT_GOBLINCAVE)
	subclass_stats = list(
		STATKEY_INT = 4,
		STATKEY_PER = 2,
		STATKEY_WIL = 1,
		STATKEY_SPD = 1,
		STATKEY_STR = -3,
		STATKEY_CON = -3,
	)
	subclass_skills = list(
		/datum/skill/combat/staves = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/polearms = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/magic/holy = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/wrestling = SKILL_LEVEL_NOVICE,
		/datum/skill/combat/unarmed = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/swimming = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/climbing = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/athletics = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/reading = SKILL_LEVEL_EXPERT,
		/datum/skill/magic/arcane = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/medicine = SKILL_LEVEL_MASTER,
		/datum/skill/craft/alchemy = SKILL_LEVEL_MASTER,
		/datum/skill/craft/crafting = SKILL_LEVEL_EXPERT,
	)

	subclass_spellpoints = 18

/datum/outfit/job/roguetown/goblin_shaman/shaman/pre_equip(mob/living/carbon/human/H, visualsOnly)
	..()
	to_chat(H, span_warning("You are a goblin shaman. Heal your allies and curse your enemies!"))
	H.dna.species.soundpack_m = new /datum/voicepack/male/goblincave()
	H.dna.species.soundpack_f = new /datum/voicepack/female/goblincave()
	if(!visualsOnly)
		var/obj/item/organ/eyes/eyes = H.getorganslot(ORGAN_SLOT_EYES)
		if(eyes)
			eyes.Remove(H, 1)
			QDEL_NULL(eyes)
		eyes = new /obj/item/organ/eyes/night_vision/wild_goblin
		eyes.Insert(H)
	H.set_blindness(-3)
	if(!H.mind)
		return

	if(H.mind) H.mind.AddSpell(new /obj/effect/proc_holder/spell/targeted/touch/prestidigitation)
	if(should_wear_masc_clothes(H))
		H.dna.species.soundpack_m = new /datum/voicepack/male/goblincave()
	if(should_wear_femme_clothes(H))
		H.dna.species.soundpack_f = new /datum/voicepack/female/goblincave()

	backl = /obj/item/storage/backpack/rogue/satchel
	shirt = /obj/item/clothing/suit/roguetown/shirt/undershirt/priest
	id = /obj/item/clothing/neck/roguetown/psicross/inhumen/graggar/bronze
	pants = /obj/item/clothing/under/roguetown/trou/leather
	shoes = /obj/item/clothing/shoes/roguetown/boots
	cloak = /obj/item/clothing/suit/roguetown/shirt/robe/black
	head = /obj/item/clothing/head/roguetown/helmet/sallet/beastskull
	neck = /obj/item/clothing/neck/roguetown/skullamulet
	mask = /obj/item/clothing/mask/rogue/skullmask
	belt = /obj/item/storage/belt/rogue/leather
	beltl = /obj/item/storage/magebag/associate
	beltr = /obj/item/storage/keyring/goblinshaman
	r_hand = /obj/item/rogueweapon/woodstaff/ruby
	backpack_contents = list(
		/obj/item/flashlight/flare/torch = 1,
		/obj/item/recipe_book/survival = 1,
		/obj/item/recipe_book/magic = 1,
		/obj/item/recipe_book/alchemy = 1,
		/obj/item/book/spellbook = 1,
		)
	var/datum/devotion/C = new /datum/devotion(H, H.patron)
	C.grant_miracles(H, cleric_tier = CLERIC_T4, passive_gain = CLERIC_REGEN_MAJOR, devotion_limit = CLERIC_REQ_4)
	if(istype(H.patron, /datum/patron/inhumen))
		H.mind?.AddSpell(new /obj/effect/proc_holder/spell/invoked/projectile/unholyblast)
