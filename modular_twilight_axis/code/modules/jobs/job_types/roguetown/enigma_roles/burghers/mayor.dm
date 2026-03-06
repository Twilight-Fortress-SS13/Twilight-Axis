/datum/job/roguetown/mayor
	title = "Mayor"
	flag = MAYOR
	department_flag = BURGHERS
	faction = "Station"
	total_positions = 1
	spawn_positions = 1
	allowed_races = ACCEPTED_RACES
	allowed_sexes = list(MALE, FEMALE)
	display_order = JDO_MAYOR
	tutorial = "Погрязший в коррупции или же великий благодетель, быть может, что-то между - вы мэр города Рокхилл и пользуетесь уважением и почётом среди его жителей. \
	В эти тяжкие дни на вас легло бремя управления городом, именно к вам обращаются доверчивые горожане за помощью и советом. \
	12 лет прошло с тех пор, как барон умер при загадочных обстоятельствах, а заместо него в замке поселился Король и его свита. Королевству Энигма с каждым годом становится всё хуже. \
	Пусть Король и правит всеми вами, но может настало время что-то изменить?"
	outfit = /datum/outfit/job/roguetown/mayor
	whitelist_req = TRUE
	advclass_cat_rolls = list(CTAG_MAYOR = 2)
	give_bank_account = TRUE
	min_pq = 5 
	max_pq = null
	round_contrib_points = 5

	cmode_music = 'sound/music/combat_poacher.ogg'
	job_traits = list(TRAIT_SEEPRICES, TRAIT_EMPATH, TRAIT_INTELLECTUAL,)
	job_subclasses = list(
		/datum/advclass/mayor
	)
	spells = list()

/datum/advclass/mayor
	name = "Mayor"
	tutorial = "Погрязший в коррупции или же великий благодетель, быть может, что-то между - вы мэр города Рокхилл и пользуетесь уважением и почётом среди его жителей. \
	В эти тяжкие дни на вас легло бремя управления городом, именно к вам обращаются доверчивые горожане за помощью и советом. \
	12 лет прошло с тех пор, как барон умер при загадочных обстоятельствах, а заместо него в замке поселился Король и его свита. Королевству Энигма с каждым годом становится всё хуже. \
	Пусть Король и правит всеми вами, но может настало время что-то изменить?"
	outfit = /datum/outfit/job/roguetown/mayor/basic
	category_tags = list(CTAG_MAYOR)
	subclass_stats = list(
		STATKEY_INT = 4,
		STATKEY_WIL = 1,
		STATKEY_LCK = 1,
		STATKEY_SPD = 1,
		STATKEY_STR = -1,
		STATKEY_CON = -1,
	)
	subclass_skills = list(
		/datum/skill/misc/reading = SKILL_LEVEL_MASTER,
		/datum/skill/combat/swords = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/wrestling = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/athletics = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/knives = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/craft/crafting = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/sewing = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/twilight_firearms = SKILL_LEVEL_JOURNEYMAN,
	)

/datum/outfit/job/roguetown/mayor
	name = "Mayor"
	jobtype = /datum/job/roguetown/mayor

/datum/outfit/job/roguetown/mayor/basic/pre_equip(mob/living/carbon/human/H)
	..()
	H.adjust_blindness(-3)
	neck = /obj/item/storage/belt/rogue/pouch/coins/veryrich
	saiga_shoes = /obj/item/clothing/shoes/roguetown/horseshoes
	belt = /obj/item/storage/belt/rogue/leather/twilight_holsterbelt
	beltl = /obj/item/rogueweapon/scabbard/sword/royal
	beltr = /obj/item/quiver/twilight_bullet/lead
	id = /obj/item/scomstone
	r_hand = /obj/item/rogueweapon/sword/rapier/dec
	l_hand = /obj/item/gun/ballistic/twilight_firearm/arquebus_pistol
	backl = /obj/item/storage/backpack/rogue/satchel
	wrists = /obj/item/storage/keyring/mayor
	backpack_contents = list(
		/obj/item/rogueweapon/huntingknife/idagger/steel/special = 1,
		/obj/item/rogueweapon/scabbard/sheath/royal = 1,
		/obj/item/reagent_containers/glass/bottle/waterskin = 1,
		/obj/item/book/rogue/law = 1,
		/obj/item/storage/belt/rogue/pouch/coins/veryrich = 1,
		/obj/item/twilight_powderflask = 1,
	)
	if(H.pronouns == SHE_HER)
		head = /obj/item/lockpick/goldpin
		armor = /obj/item/clothing/suit/roguetown/armor/plate/cuirass/fencer
		shirt = /obj/item/clothing/suit/roguetown/shirt/dress/silkdress/steward/mayor
		gloves = /obj/item/clothing/gloves/roguetown/eastgloves1
		pants = /obj/item/clothing/under/roguetown/trou/shadowpants
		shoes = /obj/item/clothing/shoes/roguetown/boots/nobleboot
	else
		head = /obj/item/clothing/head/roguetown/chaperon/noble/mayor
		armor = /obj/item/clothing/suit/roguetown/armor/plate/cuirass/fencer
		shirt = /obj/item/clothing/suit/roguetown/shirt/tunic/silktunic/mayor
		gloves = /obj/item/clothing/gloves/roguetown/eastgloves1
		pants = /obj/item/clothing/under/roguetown/trou/shadowpants
		shoes = /obj/item/clothing/shoes/roguetown/boots/nobleboot
	if(H.mind)
		SStreasury.give_money_account(ECONOMIC_RICH, H, "Savings.")
	if(H.mind)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/self/writeresidentscroll)

/obj/item/clothing/head/roguetown/chaperon/noble/mayor
	name = "Mayor's chaperon"
	color = "#15266f"
	detail_color = "#FFFFFF"

/obj/item/clothing/suit/roguetown/shirt/tunic/silktunic/mayor
	name = "Mayor's silc tunic"
	color = "#3076ff"

/obj/item/clothing/suit/roguetown/shirt/dress/silkdress/steward/mayor
	name = "Mayor's silc dress"
	color = "#3076ff"

/obj/effect/proc_holder/spell/self/writeresidentscroll
	name = "Write resident scroll"
	desc = "Using feather, paper and your power, create every migrant's dream - a citizenship certificate. \
	You will need to be holding a feather and scroll to write reisdent scroll."
	releasedrain = 100
	chargedrain = 0
	chargetime = 0
	icon = 'icons/roguetown/items/natural.dmi'
	overlay_state = "feather"
	recharge_time = 5 MINUTES
	movement_interrupt = TRUE
	var/feather_check = FALSE

/obj/effect/proc_holder/spell/self/writeresidentscroll/cast(list/targets, mob/living/user = usr)
	. = ..()
	var/mob/living/carbon/human/H = user
	var/obj/item/writefeather
	for(var/obj/item/I in user.held_items)
		if(istype(I, /obj/item/natural/feather))
			writefeather = I
			break

	if(!writefeather)
		to_chat(user, span_warning("I need to hold a feather!"))
		revert_cast()
		return
	
	var/obj/item/sacrifice
	for(var/obj/item/I in user.held_items)
		if(istype(I, /obj/item/paper/scroll))
			sacrifice = I
			break

	if(!sacrifice)
		to_chat(user, span_warning("I need to hold a scroll!"))
		revert_cast()
		return
	
	var/turf/T = get_step(user, user.dir)
	if(!(locate(/obj/structure/table) in T))
		to_chat(user, span_warning("I need to make this on a table."))
		revert_cast()
		return
	
	user.visible_message(
		span_warning("[user] begins to write on a scroll!"),
		span_notice("I begin to write on a scroll...")
	)
	if(!do_after(user, 4 SECONDS, TRUE))
		to_chat(user, span_warning("My concentration breaks! I could not write properly."))
		revert_cast()
		return
	to_chat(H, span_info("I wrote a citizenship certificate!"))
	playsound(user, 'sound/items/write.ogg', 50, TRUE, -2)
	qdel(sacrifice)
	H.put_in_hands(new /obj/item/book/granter/residentcard, TRUE)

