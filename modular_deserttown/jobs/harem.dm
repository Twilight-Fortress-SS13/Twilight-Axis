/datum/job/roguetown/harem
	title = "Harem Favorite"
	f_title = "Harem Favorite"
	flag = HAREM
	department_flag = NOBLEMEN
	faction = "Station"
	total_positions = 0
	spawn_positions = 0
	allowed_sexes = list(MALE, FEMALE)
	forbidden_races = list(RACES_CONSTRUCT RACES_DESPISED RACES_OOZE)
	outfit = /datum/outfit/job/roguetown/harem
	display_order = JDO_LADY
	advclass_cat_rolls = list(CTAG_HAREM = 20)
	tutorial = "Вы — один из трёх фаворитов султанского гарема. Ваше место при дворе держится не на крови и гербах, а на близости к трону, умении слышать желания правителя, хранить тайны и выживать среди интриг. Вряд ли вы выбирали себе эту жизнь, но она может подарить вам роскошь и власть, о которых другие могут только мечтать. С другой стороны, она же может обернуться для вас тюрьмой, в которой вы будете заперты, пока султан не решит иначе."
	give_bank_account = TRUE
	min_pq = 3
	max_pq = null
	round_contrib_points = 2
	vice_restrictions = list(/datum/charflaw/mute, /datum/charflaw/unintelligible)
	job_subclasses = list(
		/datum/advclass/harem/courtier,
		/datum/advclass/harem/diplomat,
		/datum/advclass/harem/schemer,
		/datum/advclass/harem/keeper,
		/datum/advclass/harem/augur,
	)
	same_job_respawn_delay = 30 MINUTES

/datum/advclass/harem/courtier
	name = "Silken Courtier"
	tutorial = "Вы — самая приближённая фигура султанского двора, возвышенная после рождения признанного наследника престола. Вы должны быть рядом, слышать то, что нельзя доверить советникам, и внимательно следить, чтобы ваше чадо было готово к унаследованию трона, ведь, скорее всего, других фаворитов мучает зависть из-за вашего положения и всегда может случится так, что наследник не доживет до получения власти."
	outfit = /datum/outfit/job/roguetown/harem/courtier
	traits_applied = list(TRAIT_SEEPRICES, TRAIT_NOBLE)
	category_tags = list(CTAG_HAREM)
	maximum_possible_slots = 1
	subclass_stats = list(
		STATKEY_LCK = 3,
		STATKEY_INT = 2,
		STATKEY_WIL = 2,
		STATKEY_PER = 1,
	)
	subclass_skills = list(
		/datum/skill/combat/knives = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/unarmed = SKILL_LEVEL_NOVICE,
		/datum/skill/combat/wrestling = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/athletics = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/climbing = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/music = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/reading = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/medicine = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/riding = SKILL_LEVEL_JOURNEYMAN,
	)

/datum/outfit/job/roguetown/harem/courtier
	neck = /obj/item/storage/belt/rogue/pouch/coins/rich
	belt = /obj/item/storage/belt/rogue/leather/plaquegold
	backr = /obj/item/storage/backpack/rogue/satchel/short
	id = /obj/item/scomstone/garrison
	job_bitflag = BITFLAG_ROYALTY
	backpack_contents = list(
		/obj/item/rogueweapon/huntingknife/idagger/steel/decorated = 1,
		/obj/item/rogueweapon/scabbard/sheath/royal = 1,
		/obj/item/storage/keyring/lord = 1,
	)

/datum/outfit/job/roguetown/harem/courtier/pre_equip(mob/living/carbon/human/H)
	. = ..()
	if(should_wear_femme_clothes(H))
		head = /obj/item/clothing/head/roguetown/turban/fancypurple
		armor = /obj/item/clothing/suit/roguetown/shirt/robe/bisht/purple
		shoes = /obj/item/clothing/shoes/roguetown/gladiator
	else if(should_wear_masc_clothes(H))
		head = /obj/item/clothing/head/roguetown/turban/fancypurple
		pants = /obj/item/clothing/under/roguetown/sirwal/fancy/random
		shirt = /obj/item/clothing/suit/roguetown/shirt/dress/thawb/gold
		armor = /obj/item/clothing/suit/roguetown/shirt/robe/bisht/purple
		shoes = /obj/item/clothing/shoes/roguetown/shalal
	if(H.mind)
		SStreasury.grant_savings(ECONOMIC_UPPER_CLASS, H)

/datum/advclass/harem/diplomat
	name = "Diplomatic Concubine"
	tutorial = "Вы — дворянин из чужого государства, отправленный в султанский гарем как живой договор, залог мира или изысканный политический дар. Ваши одежды, манеры и акцент напоминают всем, что за вами стоит другая земля, чужой двор и интересы тех, кто рассчитывает на вашу близость к султану."
	outfit = /datum/outfit/job/roguetown/harem/diplomat
	traits_applied = list(TRAIT_SEEPRICES, TRAIT_NOBLE, TRAIT_CICERONE)
	category_tags = list(CTAG_HAREM)
	maximum_possible_slots = 1
	subclass_stats = list(
		STATKEY_INT = 2,
		STATKEY_PER = 2,
		STATKEY_WIL = 1,
		STATKEY_LCK = 2,
	)
	subclass_skills = list(
		/datum/skill/combat/knives = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/unarmed = SKILL_LEVEL_NOVICE,
		/datum/skill/combat/wrestling = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/athletics = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/sneaking = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/music = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/reading = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/medicine = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/riding = SKILL_LEVEL_JOURNEYMAN,
	)

/datum/outfit/job/roguetown/harem/diplomat
	neck = /obj/item/storage/belt/rogue/pouch/coins/rich
	belt = /obj/item/storage/belt/rogue/leather/plaquegold
	backr = /obj/item/storage/backpack/rogue/satchel/short
	id = /obj/item/scomstone/garrison
	job_bitflag = BITFLAG_ROYALTY
	backpack_contents = list(
		/obj/item/rogueweapon/huntingknife/idagger/steel/decorated = 1,
		/obj/item/rogueweapon/scabbard/sheath/royal = 1,
		/obj/item/storage/keyring/harem = 1,
	)

/datum/outfit/job/roguetown/harem/diplomat/pre_equip(mob/living/carbon/human/H)
	. = ..()
	var/origin_style = get_harem_origin_style(H)
	switch(origin_style) // Надо будет дать более разнообразную одежду в зависимости от происхождения, но у меня уже сил не хватает
		if("desert")

			if(should_wear_femme_clothes(H))
				shirt = /obj/item/clothing/suit/roguetown/shirt/dress/amiradress
				shoes = /obj/item/clothing/shoes/roguetown/gladiator
			else if(should_wear_masc_clothes(H))
				pants = /obj/item/clothing/under/roguetown/sirwal/fancy/random
				shirt = /obj/item/clothing/suit/roguetown/shirt/dress/thawb/gold
				shoes = /obj/item/clothing/shoes/roguetown/shalal
		if("northern")
			if(should_wear_femme_clothes(H))
				shirt = /obj/item/clothing/suit/roguetown/armor/armordress/winterdress/monarch
				shoes = /obj/item/clothing/shoes/roguetown/boots/nobleboot
			else if(should_wear_masc_clothes(H))
				shirt = /obj/item/clothing/suit/roguetown/armor/gambeson/heavy
				armor = /obj/item/clothing/suit/roguetown/shirt/tunic/noblecoat
				shoes = /obj/item/clothing/shoes/roguetown/boots/nobleboot
		if("seaborn")
			if(should_wear_femme_clothes(H))
				shirt = /obj/item/clothing/suit/roguetown/shirt/dress/silkydress/random
				shoes = /obj/item/clothing/shoes/roguetown/anklets
			else if(should_wear_masc_clothes(H))
				shirt = /obj/item/clothing/suit/roguetown/shirt/tunic/random
				pants = /obj/item/clothing/under/roguetown/heavy_leather_pants/otavan
				shoes = /obj/item/clothing/shoes/roguetown/boots/leather/reinforced/short
		if("eastern")
			if(should_wear_femme_clothes(H))
				shirt = /obj/item/clothing/suit/roguetown/shirt/dress/silkydress/random
				shoes = /obj/item/clothing/shoes/roguetown/anklets
			else if(should_wear_masc_clothes(H))
				pants = /obj/item/clothing/under/roguetown/sirwal/fancy/random
				shirt = /obj/item/clothing/suit/roguetown/shirt/dress/thawb/gold
				shoes = /obj/item/clothing/shoes/roguetown/shalal
		else
			if(should_wear_femme_clothes(H))
				shirt = /obj/item/clothing/suit/roguetown/shirt/dress/amiradress
				shoes = /obj/item/clothing/shoes/roguetown/gladiator
			else if(should_wear_masc_clothes(H))
				pants = /obj/item/clothing/under/roguetown/sirwal/fancy/random
				shirt = /obj/item/clothing/suit/roguetown/shirt/dress/thawb/gold
				shoes = /obj/item/clothing/shoes/roguetown/shalal
	if(H.mind)
		SStreasury.grant_savings(ECONOMIC_UPPER_CLASS, H)

/datum/outfit/job/roguetown/harem/diplomat/proc/get_harem_origin_style(mob/living/carbon/human/H)
	var/origin_type = get_harem_origin_type(H)
	switch(origin_type)
		if(/datum/virtue/origin/raneshen, /datum/virtue/origin/naledi, /datum/virtue/origin/zybantian)
			return "desert"
		if(/datum/virtue/origin/azuria, /datum/virtue/origin/enigma, /datum/virtue/origin/grenzelhoft, /datum/virtue/origin/heartfelt, /datum/virtue/origin/otava, /datum/virtue/origin/gronn, /datum/virtue/origin/hammerhold, /datum/virtue/origin/racial/akhdruk)
			return "northern"
		if(/datum/virtue/origin/valorian, /datum/virtue/origin/etrusca)
			return "seaborn"
		if(/datum/virtue/origin/kazengun, /datum/virtue/origin/lingyue, /datum/virtue/origin/gyedzenese, /datum/virtue/origin/avar, /datum/virtue/origin/racial/lirvas, /datum/virtue/origin/racial/underdark, /datum/virtue/origin/racial/underdark_drow, /datum/virtue/origin/racial/ancient, /datum/virtue/origin/racial/infernal)
			return "eastern"
	return "desert"

/datum/outfit/job/roguetown/harem/diplomat/proc/get_harem_origin_type(mob/living/carbon/human/H)
	if(!H)
		return null
	var/list/origin_values = list()
	if(H.client?.prefs)
		var/datum/preferences/P = H.client.prefs
		origin_values += P.vars["origin"]
		origin_values += P.vars["origin_type"]
		origin_values += P.vars["origin_virtue"]
		origin_values += P.vars["virtues"]
	origin_values += H.vars["origin"]
	origin_values += H.vars["origin_type"]
	origin_values += H.vars["origin_virtue"]
	origin_values += H.vars["virtues"]
	for(var/origin_value in origin_values)
		var/origin_type = harem_origin_value_to_type(origin_value)
		if(origin_type)
			return origin_type
	return null

/datum/outfit/job/roguetown/harem/diplomat/proc/harem_origin_value_to_type(origin_value)
	if(!origin_value)
		return null
	if(islist(origin_value))
		var/list/origin_list = origin_value
		for(var/entry in origin_list)
			var/origin_type = harem_origin_value_to_type(entry)
			if(origin_type)
				return origin_type
		return null
	if(istype(origin_value, /datum/virtue/origin))
		var/datum/virtue/origin/origin_datum = origin_value
		return origin_datum.type
	if(ispath(origin_value, /datum/virtue/origin))
		return origin_value
	if(istext(origin_value))
		var/origin_path = text2path(origin_value)
		if(ispath(origin_path, /datum/virtue/origin))
			return origin_path
	return null

/datum/advclass/harem/schemer
	name = "Perfumed Favorite"
	tutorial = "Вас держат близко к покоям султана ради ласки, утешения, музыки и тихих ночных разговоров. Может быть, в один из таких «ночных разговоров», вы сможете зачать ребёнка, что удостоится заполучить свое место в династии султана, а может и вовсе, стать наследником, возвысив вас."
	outfit = /datum/outfit/job/roguetown/harem/schemer
	traits_applied = list(TRAIT_BEAUTIFUL, TRAIT_GOODLOVER, TRAIT_NUTCRACKER)
	category_tags = list(CTAG_HAREM)
	subclass_stats = list(
		STATKEY_SPD = 3,
		STATKEY_WIL = 2,
		STATKEY_PER = 1,
		STATKEY_LCK = 1,
	)
	subclass_skills = list(
		/datum/skill/combat/knives = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/unarmed = SKILL_LEVEL_NOVICE,
		/datum/skill/combat/wrestling = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/sneaking = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/lockpicking = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/swimming = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/athletics = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/music = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/reading = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/medicine = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/riding = SKILL_LEVEL_APPRENTICE,
	)

/datum/outfit/job/roguetown/harem/schemer
	neck = /obj/item/storage/belt/rogue/pouch/coins/poor
	backl = /obj/item/storage/backpack/rogue/satchel/short

/datum/outfit/job/roguetown/harem/schemer/pre_equip(mob/living/carbon/human/H)
	. = ..()
	if(should_wear_femme_clothes(H))
		head = /obj/item/lockpick/goldpin
		mask = /obj/item/clothing/mask/rogue/silkmask
		shirt = /obj/item/clothing/suit/roguetown/shirt/silkbra
		belt = /obj/item/storage/belt/rogue/leather/silkbelt
		shoes = /obj/item/clothing/shoes/roguetown/anklets
	else if(should_wear_masc_clothes(H))
		head = /obj/item/lockpick/goldpin
		pants = /obj/item/clothing/under/roguetown/sirwal/fancy/random
		belt = /obj/item/storage/belt/rogue/leather/black
		shoes = /obj/item/clothing/shoes/roguetown/gladiator
	backpack_contents = list(
		/obj/item/reagent_containers/powder/moondust = 1,
		/obj/item/storage/keyring/harem = 1,
	)
	if(H.mind)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/massage)
		var/instruments = list("Harp", "Lute", "Accordion", "Guitar", "Hurdy-Gurdy", "Viola", "Vocal Talisman", "Psyaltery", "Flute", "Drum", "Shamisen")
		var/instrument_choice = tgui_input_list(H, "Choose your instrument.", "PALACE ENTERTAINMENT", instruments)
		H.set_blindness(0)
		switch(instrument_choice)
			if("Harp")
				backr = /obj/item/rogue/instrument/harp
			if("Lute")
				backr = /obj/item/rogue/instrument/lute
			if("Accordion")
				backr = /obj/item/rogue/instrument/accord
			if("Guitar")
				backr = /obj/item/rogue/instrument/guitar
			if("Hurdy-Gurdy")
				backr = /obj/item/rogue/instrument/hurdygurdy
			if("Viola")
				backr = /obj/item/rogue/instrument/viola
			if("Vocal Talisman")
				backr = /obj/item/rogue/instrument/vocals
			if("Psyaltery")
				backr = /obj/item/rogue/instrument/psyaltery
			if("Flute")
				backr = /obj/item/rogue/instrument/flute
			if("Drum")
				backr = /obj/item/rogue/instrument/drum
			if("Shamisen")
				backr = /obj/item/rogue/instrument/shamisen
		SStreasury.grant_savings(ECONOMIC_UPPER_CLASS, H)

/datum/advclass/harem/keeper
	name = "Harem Keeper"
	tutorial = "Вы знаете, какое вино подать султану после тяжёлого совета, какую мазь держать рядом с ложем и как успокоить султанский гнев. Вы не просто обслуживаете султана, вы заботитесь о нём, и от вас зависит его здоровье и настроение. Также вам стоит следить и за состоянием других фаворитов, ведь от этого зависит атмосфера в гареме и расположение султана к вам."
	outfit = /datum/outfit/job/roguetown/harem/keeper
	traits_applied = list(TRAIT_CICERONE, TRAIT_HOMESTEAD_EXPERT, TRAIT_KEENEARS)
	category_tags = list(CTAG_HAREM)
	subclass_stats = list(
		STATKEY_WIL = 2,
		STATKEY_PER = 2,
		STATKEY_INT = 1,
		STATKEY_LCK = 1,
	)
	subclass_skills = list(
		/datum/skill/combat/knives = SKILL_LEVEL_NOVICE,
		/datum/skill/combat/unarmed = SKILL_LEVEL_NOVICE,
		/datum/skill/combat/wrestling = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/music = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/medicine = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/reading = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/athletics = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/swimming = SKILL_LEVEL_APPRENTICE,
		/datum/skill/labor/butchering = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/craft/sewing = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/cooking = SKILL_LEVEL_EXPERT,
	)

/datum/outfit/job/roguetown/harem/keeper
	neck = /obj/item/storage/belt/rogue/pouch/coins/poor
	backr = /obj/item/storage/backpack/rogue/satchel/short
	backpack_contents = list(
		/obj/item/reagent_containers/glass/bottle/rogue/wine = 1,
		/obj/item/reagent_containers/powder/moondust = 1,
		/obj/item/toy/cards/deck = 1,
		/obj/item/rogueweapon/huntingknife/idagger/steel = 1,
		/obj/item/storage/keyring/harem = 1,
	)

/datum/outfit/job/roguetown/harem/keeper/pre_equip(mob/living/carbon/human/H)
	. = ..()
	if(should_wear_femme_clothes(H))
		shirt = /obj/item/clothing/suit/roguetown/shirt/dress/silkydress/random
		belt = /obj/item/storage/belt/rogue/leather/cloth/upgraded/lady
		shoes = /obj/item/clothing/shoes/roguetown/anklets
	else if(should_wear_masc_clothes(H))
		pants = /obj/item/clothing/under/roguetown/sirwal/fancy/random
		shirt = /obj/item/clothing/suit/roguetown/shirt/dress/thawb/gold
		belt = /obj/item/storage/belt/rogue/leather/cloth/upgraded/lady
		shoes = /obj/item/clothing/shoes/roguetown/shalal
	if(H.mind)
		SStreasury.grant_savings(ECONOMIC_UPPER_CLASS, H)

/datum/advclass/harem/augur
	name = "Bone Augur"
	tutorial = "Вы попали в султанский гарем не из-за красоты или покладистого нрава. Вы умеете читать судьбу по костям, игральным кубикам и кофейной гуще, видите дурные знаки раньше других и знаете, какие слова сказать султану, когда ночь становится слишком тихой."
	outfit = /datum/outfit/job/roguetown/harem/augur
	traits_applied = list(TRAIT_KEENEARS, TRAIT_CICERONE)
	category_tags = list(CTAG_HAREM)
	maximum_possible_slots = 1
	subclass_stats = list(
		STATKEY_INT = 2,
		STATKEY_PER = 2,
		STATKEY_WIL = 2,
		STATKEY_LCK = 1,
	)
	subclass_skills = list(
		/datum/skill/combat/knives = SKILL_LEVEL_NOVICE,
		/datum/skill/combat/unarmed = SKILL_LEVEL_NOVICE,
		/datum/skill/combat/wrestling = SKILL_LEVEL_NOVICE,
		/datum/skill/magic/arcane = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/sneaking = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/music = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/reading = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/medicine = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/athletics = SKILL_LEVEL_NOVICE,
		/datum/skill/craft/cooking = SKILL_LEVEL_NOVICE,
	)

/datum/outfit/job/roguetown/harem/augur
	neck = /obj/item/storage/belt/rogue/pouch/coins/poor
	backr = /obj/item/storage/backpack/rogue/satchel/short
	belt = /obj/item/storage/belt/rogue/leather/black
	backpack_contents = list(
		/obj/item/storage/pill_bottle/dice = 1,
		/obj/item/toy/cards/deck/tarot = 1,
		/obj/item/reagent_containers/food/snacks/grown/coffeebeans = 4,
		/obj/item/rogueweapon/huntingknife/idagger/steel = 1,
		/obj/item/storage/keyring/harem = 1,
	)

/datum/outfit/job/roguetown/harem/augur/pre_equip(mob/living/carbon/human/H)
	. = ..()
	if(should_wear_femme_clothes(H))
		head = /obj/item/clothing/head/roguetown/turban/dark
		armor = /obj/item/clothing/suit/roguetown/shirt/robe/bisht/black
		shoes = /obj/item/clothing/shoes/roguetown/anklets
	else if(should_wear_masc_clothes(H))
		head = /obj/item/clothing/head/roguetown/turban/dark
		pants = /obj/item/clothing/under/roguetown/sirwal/fancy/random
		armor = /obj/item/clothing/suit/roguetown/shirt/robe/bisht/black
		shoes = /obj/item/clothing/shoes/roguetown/shalal
	if(H.mind)
		H.mind.AddSpell(new /datum/action/cooldown/spell/touch/prestidigitation)
		H.mind.AddSpell(new /datum/action/cooldown/spell/readomen)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/baothavice/augur)
		SStreasury.grant_savings(ECONOMIC_UPPER_CLASS, H)

/obj/effect/proc_holder/spell/invoked/baothavice/augur
	devotion_cost = 0
	recharge_time = 60 SECONDS
