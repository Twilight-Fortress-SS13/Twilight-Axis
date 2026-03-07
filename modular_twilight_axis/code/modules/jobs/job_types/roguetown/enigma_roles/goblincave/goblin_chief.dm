#define GOBLINCHIEF_ANNOUNCEMENT_COOLDOWN (2 MINUTES)

/datum/job/roguetown/goblin_chief
	title = "Goblin Chief"
	flag = GOBLINCHIEF
	department_flag = GOBLINCAVE
	faction = "Station"
	total_positions = 1
	spawn_positions = 1
	allowed_races = list(
		/datum/species/goblinp,
		/datum/species/halforc
	)
	allowed_patrons = list(/datum/patron/inhumen/graggar)
	tutorial = "Ты — Вожак, избранный Граггаром, воплощение абсолютной власти в племени. \
				Твоя жестокость — не злоба, а священный язык, которым ты доказываешь племени, что слабость недостойна жить. \
				Ты обязан ежедневно доказывать племени, почему именно ты — вожак, оставляя после себя страх, который громче любых слов." 
	class_categories = FALSE

	outfit = null
	outfit_female = null

	display_order = JDO_GOBLINCHIEF
	selection_color = JCOLOR_WANDERER
	show_in_credits = FALSE
	min_pq = -25
	max_pq = null

	advclass_cat_rolls = list(CTAG_GOBLINCHIEF = 10)

	announce_latejoin = FALSE
	wanderer_examine = TRUE
	advjob_examine = FALSE
	always_show_on_latechoices = TRUE
	job_reopens_slots_on_death = FALSE
	same_job_respawn_delay = 30 MINUTES

	cmode_music = 'sound/music/cmode/antag/combat_darkstar.ogg'

	job_subclasses = list(
		/datum/advclass/goblin_chief/chief,
	)

/datum/job/roguetown/goblin_chief/after_spawn(mob/living/H, mob/M, latejoin = TRUE)
	. = ..()
	if(ishuman(H))
		var/mob/living/carbon/human/human = H
		human.grant_language(/datum/language/orcish)

/datum/advclass/goblin_chief/chief
	name = "Chief"
	tutorial = "Ты — Вожак, избранный Граггаром, воплощение абсолютной власти в племени. \
				Твоя жестокость — не злоба, а священный язык, которым ты доказываешь племени, что слабость недостойна жить. \
				Ты обязан ежедневно доказывать племени, почему именно ты — вожак, оставляя после себя страх, который громче любых слов." 
	outfit = /datum/outfit/job/roguetown/goblin_chief/chief
	category_tags = list(CTAG_GOBLINCHIEF)
	subclass_languages = list(/datum/language/thievescant)
	traits_applied = list(TRAIT_STEELHEARTED, TRAIT_CRITICAL_RESISTANCE, TRAIT_STRONGBITE, TRAIT_HEAVYARMOR, TRAIT_GOBLINCAVE)
	subclass_stats = list(
		STATKEY_STR = 4,
		STATKEY_INT = -3,
		STATKEY_SPD = -2,
		STATKEY_CON = 3,
		STATKEY_WIL = 2,
	)
	subclass_skills = list(
		/datum/skill/misc/tracking = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/knives = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/swimming = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/wrestling = SKILL_LEVEL_MASTER,
		/datum/skill/combat/unarmed = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/athletics = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/climbing = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/reading = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/sneaking = SKILL_LEVEL_NOVICE,
	)

/datum/outfit/job/roguetown/goblin_chief/chief/pre_equip(mob/living/carbon/human/H, visualsOnly)
	..()
	to_chat(H, span_warning("You are a goblin chief. Crush your enemies!"))
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
	if(H.mind)
		H.verbs += /mob/living/carbon/human/proc/goblinchief_announcement
	if(!H.mind)
		return

	var/weapons = list("Steel Warhammer and Shield","Steel Handclaw","Grand Maul","Discipline - Unarmed")
	var/weapon_choice = input(H, "Choose your WEAPON.", "TAKE UP ARMS.") as anything in weapons
	switch(weapon_choice)
		if("Steel Warhammer and Shield")
			H.adjust_skillrank_up_to(/datum/skill/combat/maces, SKILL_LEVEL_MASTER, TRUE)
			H.adjust_skillrank_up_to(/datum/skill/combat/shields, SKILL_LEVEL_MASTER, TRUE)
			head = /obj/item/clothing/head/roguetown/helmet/heavy/volfplate/berserker
			r_hand = /obj/item/rogueweapon/mace/warhammer/steel
			gloves = /obj/item/clothing/gloves/roguetown/bandages
			armor = /obj/item/clothing/suit/roguetown/armor/regenerating/skin/disciple/barbarian
			backr = /obj/item/rogueweapon/shield/wood
		if("Steel Handclaw")
			H.adjust_skillrank_up_to(/datum/skill/combat/unarmed, SKILL_LEVEL_MASTER, TRUE)
			ADD_TRAIT(H, TRAIT_CIVILIZEDBARBARIAN, TRAIT_GENERIC)
			H.adjust_skillrank_up_to(/datum/skill/combat/axes, SKILL_LEVEL_JOURNEYMAN, TRUE)
			head = /obj/item/clothing/head/roguetown/helmet/heavy/volfplate/berserker
			r_hand = /obj/item/rogueweapon/handclaw/steel
			gloves = /obj/item/clothing/gloves/roguetown/plate/graggar
			armor = /obj/item/clothing/suit/roguetown/armor/regenerating/skin/disciple/barbarian
		if("Grand Maul")
			H.adjust_skillrank_up_to(/datum/skill/combat/maces, SKILL_LEVEL_MASTER, TRUE)
			head = /obj/item/clothing/head/roguetown/helmet/heavy/volfplate/berserker
			r_hand = /obj/item/rogueweapon/mace/maul/grand
			gloves = /obj/item/clothing/gloves/roguetown/plate/graggar
			armor = /obj/item/clothing/suit/roguetown/armor/regenerating/skin/disciple/barbarian
		if ("Discipline - Unarmed")
			H.adjust_skillrank_up_to(/datum/skill/combat/unarmed, SKILL_LEVEL_MASTER, TRUE)
			ADD_TRAIT(H, TRAIT_CIVILIZEDBARBARIAN, TRAIT_GENERIC)
			head = /obj/item/clothing/head/roguetown/helmet/heavy/volfplate/berserker
			gloves = /obj/item/clothing/gloves/roguetown/bandages/pugilist
			armor = /obj/item/clothing/suit/roguetown/armor/regenerating/skin/disciple/barbarian
	mask = /obj/item/clothing/mask/rogue/facemask
	id = /obj/item/clothing/neck/roguetown/psicross/inhumen/graggar/bronze
	shirt = /obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/iron
	neck = /obj/item/clothing/neck/roguetown/chaincoif/full
	belt = /obj/item/storage/belt/rogue/leather
	pants = /obj/item/clothing/under/roguetown/chainlegs/kilt
	shoes = /obj/item/clothing/shoes/roguetown/boots/armor
	wrists = /obj/item/clothing/wrists/roguetown/bracers/iron
	cloak = /obj/item/clothing/cloak/graggar
	if(should_wear_masc_clothes(H))
		H.dna.species.soundpack_m = new /datum/voicepack/male/goblincave()
	if(should_wear_femme_clothes(H))
		H.dna.species.soundpack_f = new /datum/voicepack/female/goblincave()
	backl = /obj/item/storage/backpack/rogue/satchel
	backpack_contents = list(
		/obj/item/flashlight/flare/torch = 1,
		/obj/item/recipe_book/survival = 1,
		/obj/item/rogueweapon/scabbard/sheath = 1,
		/obj/item/rogueweapon/huntingknife/bronze = 1,
		/obj/item/storage/keyring/goblinchief = 1,
		)

/mob/living/carbon/human/proc/goblinchief_announcement()
	set name = "Announcement"
	set category = "CHIEF"
	if(stat)
		return
	var/announcementinput = input("Вырази волю Граггара...", "Make an Announcement") as text|null
	if(announcementinput)
		if(!src.can_speak_vocal())
			to_chat(src,span_warning("I can't speak!"))
			return FALSE
		if(!istype(get_area(src), /area/rogue/under/cave/goblincave))//Nuh uh
			to_chat(src, span_warning("I can only speak from within the Cave."))
			return FALSE
		if (!COOLDOWN_FINISHED(src, goblinchief_announcement_cd))
			to_chat(src, span_warning("You must wait before speaking again."))
			return FALSE
		visible_message(span_warning("[src] takes a deep breath, preparing to make an announcement."))
		if(do_after(src, 15 SECONDS, target = src)) // Reduced to 15 seconds from 30 on the original Herald PR. 15 is well enough time for sm1 to shove you.
			say(announcementinput)
			var/sanitized_input = trim(copytext(sanitize(announcementinput), 1, MAX_MESSAGE_LEN))
			var/accented_input = treat_message_accent(sanitized_input, strings("accent_universal.json", "universal"), 1)
			var/treated_input = treat_message(accented_input, /datum/language/common)
			priority_announce("[treated_input]", "<span class='reallybig'>The Graggar Champion Roars</span>", 'sound/vo/mobs/troll/idle2.ogg', sender = src)
			COOLDOWN_START(src, goblinchief_announcement_cd, GOBLINCHIEF_ANNOUNCEMENT_COOLDOWN)
		else
			to_chat(src, span_warning("Your announcement was interrupted!"))
			return FALSE

#undef GOBLINCHIEF_ANNOUNCEMENT_COOLDOWN
