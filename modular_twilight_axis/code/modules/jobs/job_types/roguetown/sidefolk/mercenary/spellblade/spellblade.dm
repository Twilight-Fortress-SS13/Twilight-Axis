/datum/advclass/mercenary/twilight_noctite_spellblade
	name = "Newmoon Spellblade"
	tutorial = "Орден Новолуния был известен как хранители самых таинственных арканных техник, и секретов магии, кои хранили в строжайшем секрете за стенами монастыря. \
		Но это было в прошлом. \
		Ваш монастырь был сожжен во время войны, и многие из тех кто хранил тайны ордена сгорели заживо вместе с знаниями, которые они не могли отпустить. \
		Теперь вы один из немногих выживших. Вы могли выжить из-за трусости, из-за того что вы отсутствовали во время тех событий.  \
		Или, волей случая вы пережили пожар. У вас теперь нет ничего, кроме ваших знаний. Может, хоть они смогут спасти вас от голодной смерти, ибо орден Новолуния обречен."
	outfit = /datum/outfit/job/roguetown/spellblade
	category_tags = list(CTAG_MERCENARY, CTAG_MERCPARTY_VANGUARD)
	class_select_category = CLASS_CAT_RANESHENI
	subclass_languages = list(/datum/language/raneshi)
	traits_applied = list(TRAIT_MEDIUMARMOR, TRAIT_NIGHT_OWL, TRAIT_ARCYNE)
	subclass_mage_aspects = list("mastery" = FALSE, "major" = FALSE, "minor" = 2, "utilities" = 6)
	maximum_possible_slots = 2
	subclass_stats = list(
		STATKEY_CON = 1,
		STATKEY_WIL = 2,
		STATKEY_INT = 4,
	)
	subclass_skills = list(
		/datum/skill/misc/climbing = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/athletics = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/reading = SKILL_LEVEL_MASTER,
		/datum/skill/misc/medicine = SKILL_LEVEL_NOVICE,
		/datum/skill/magic/arcane = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/lockpicking = SKILL_LEVEL_JOURNEYMAN,
	)

	subclass_stashed_items = list(
		"Накидка Новолунья" = /obj/item/clothing/cloak/half/newmoon,
	)

	allowed_patrons = list(/datum/patron/divine/noc)

/datum/outfit/job/roguetown/spellblade
	wrists = /obj/item/clothing/neck/roguetown/psicross/silver/noc
	head = /obj/item/clothing/head/roguetown/roguehood/newmoon
	armor = /obj/item/clothing/suit/roguetown/armor/leather/newmoon_jacket
	id = /obj/item/clothing/ring/gold
	backl = /obj/item/storage/backpack/rogue/satchel
	gloves = /obj/item/clothing/gloves/roguetown/fingerless
	neck = /obj/item/storage/belt/rogue/pouch/coins/poor
	pants = /obj/item/clothing/under/roguetown/trou/leather
	shirt = /obj/item/clothing/suit/roguetown/shirt/tunic/newmoon
	shoes = /obj/item/clothing/shoes/roguetown/boots/leather/reinforced
	belt = /obj/item/storage/belt/rogue/leather
	mask = /obj/item/clothing/mask/rogue/ragmask/newmoon
	backpack_contents = list(
		/obj/item/lockpickring/mundane = 1,
		/obj/item/rogueweapon/scabbard/sheath = 1,
		/obj/item/roguekey/mercenary = 1,
		/obj/item/rogueweapon/spellbook = 1
		)

/datum/outfit/job/roguetown/spellblade/pre_equip(mob/living/carbon/human/H)
	..()

	H.cmode_music = sound("modular_twilight_axis/church_classes/sound/cmode_spellblade.ogg")

	if(H.mind)
		SStreasury.give_money_account(ECONOMIC_LOWER_MIDDLE_CLASS, H, "Church Funding.")

	var/obj/effect/proc_holder/spell/targeted/spellblade_select_weapon/select_weapon
	select_weapon = new /obj/effect/proc_holder/spell/targeted/spellblade_select_weapon

	var/obj/effect/proc_holder/spell/invoked/spellblade_summon_weapon/summon_weapon
	summon_weapon = new /obj/effect/proc_holder/spell/invoked/spellblade_summon_weapon
	summon_weapon.weapon_select = select_weapon
	select_weapon.summon_weapon = summon_weapon

	H.AddSpell(select_weapon)
	H.AddSpell(summon_weapon)
	H.AddSpell(new /obj/effect/proc_holder/spell/self/noctite_fortify)
