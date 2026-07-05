
#define CTAG_CATAPHRACT		"CAT_CATAPHRACT"	// Knight alt
#define CTAG_AZEB		"CAT_AZEB"		// Warden (?) alt
#define CTAG_AZEBAGHA	"CAT_AZEBAGHA"		// Warden (?) alt
#define CTAG_JANISSARYSERGEANT	"CAT_JANISSARYSERGEANT"		// Sergeant class - Handles Sergeant class selector (weapons selection)
#define CTAG_JANISSARY			"CAT_JANISSARY"		// Menatarms alt
#define CTAG_SLAVEMASTER	"CAT_SLAVEMASTER"
#define CTAG_PSLAVE			"CAT_PSLAVE"
#define CTAG_HEADSLAVE		"CAT_HEADSLAVE"		// Seneschal's aesthetic choices.
#define CTAG_SULTAN		"CAT_SULTAN"
#define CTAG_VIZIER		"CAT_VIZIER"
#define CTAG_SHEIKH		"CAT_SHEIKH"
#define CTAG_FREEMAN		"CAT_FREEMAN"
#define CTAG_LOSTGRENZEL	"CAT_LOSTGRENZEL"
#define CTAG_HAREM			"CAT_HAREM"	




// #define NOBLEMEN		(1<<0)

// #define LORD		(1<<0)
// #define LADY		(1<<1)
// #define HAND		(1<<2)
// #define STEWARD		(1<<3)
#define SULTAN	(1<<0)
#define VIZIER	(1<<0)
#define SHEIKH	(1<<0)
#define HAREM	(1<<0)
#define CATAPHRACT	(1<<4)
#define JANISSARYSERGEANT	(1<<6)
// #define GUARD_CAPTAIN		(1<<5)
// #define MARSHAL		(1<<6)
// #define HOSTAGE		(1<<7)
// #define SUITOR		(1<<8)

// #define GARRISON		(1<<1)

// #define GUARDSMAN	(1<<0)
#define JANISSARY	(1<<1)
#define SLAVEMASTER	(1<<2)
// #define SQUIRE		(1<<3)
#define BOGGUARD	(1<<4)
#define AZEB	(1<<4)
// #define SERGEANT	(1<<5)
#define AZEBAGHA	(1<<5)
// #define SHERIFF		(1<<6)

// #define CHURCHMEN		(1<<2)

// #define PRIEST		(1<<0)
// #define MONK		(1<<1)
// #define GRAVEDIGGER	(1<<2)
// #define DRUID		(1<<3)

// #define COURTIERS	(1<<3)

// #define JESTER		(1<<0)
// #define DTWIZARD		(1<<1)
// #define PHYSICIAN 	(1<<2)
#define HEADSLAVE		(1<<3)

// #define YEOMEN		(1<<4)

// #define BARKEEP		(1<<0)
// #define ARCHIVIST	(1<<1)
// #define ALCHEMIST	(1<<5)
// #define MERCHANT	(1<<8)
// #define SCRIBE		(1<<9)
// #define CRIER		(1<<10)
// #define KEEPER		(1<<11)

// #define PEASANTS	(1<<5)

// #define HUNTER		(1<<0)
// #define FARMER		(1<<1)
// #define FISHER		(1<<3)
// #define LUMBERJACK	(1<<4)
// #define MINER		(1<<5)
// #define COOK		(1<<6)
// #define KNAVEWENCH (1<<7)
// #define GRABBER		(1<<8)
// #define NITEMASTER	(1<<9)
// #define WENCH		(1<<10)
// #define BEGGAR		(1<<11)
// #define VILLAGER	(1<<14)
// #define PRISONERR	(1<<15)
// #define PRISONERB	(1<<16)
// #define LUNATIC		(1<<17)
// #define MIGRANT		(1<<18)
// #define ASSASSIN	(1<<19)
// #define YOUNGFOLK	(1<<6)

// #define APPRENTICE	(1<<0)
// #define CHURCHLING	(1<<1)
#define SLAVE		(1<<2)
// #define ORPHAN		(1<<3)
// #define CLERK 		(1<<6)
// #define MAGEAPPRENTICE	(1<<7)
// #define APOTHECARY	(1<<8)

// #define WANDERERS		(1<<7)

// #define VETERAN			(1<<1)
// #define WANDERER		(1<<2)
// #define ADVENTURER      (1<<3)
// #define BANDIT		    (1<<4)
// #define COURTAGENT	    (1<<5)
#define COURTSLAVE	    (1<<5) //desert
// #define WRETCH          (1<<6)
// #define TRADER			(1<<7)

// #define INQUISITION (1<<10)

// #define PURITAN		(1<<0)
// #define ORTHODOXIST	(1<<1)
// #define ABSOLVER (1<<2)

// #define GUILDSMEN	(1<<11)

// #define GUILDMASTER (1<<1)
// #define GUILDSMAN  	(1<<2)
// #define TAILOR		(1<<3)


/datum/job/roguetown/lord/after_spawn(mob/living/L, mob/M, latejoin = TRUE)//
	if(SSmapping.config.map_name == "Desert Town")
		spells = list( /obj/effect/proc_holder/spell/self/convertrole/slave,
		/obj/effect/proc_holder/spell/self/convertrole/azeb,
		/obj/effect/proc_holder/spell/self/grant_title,
		/obj/effect/proc_holder/spell/self/convertrole/guard,
		/obj/effect/proc_holder/spell/self/grant_nobility,
		)
		cmode_music = 'sound/music/combat_desert2.ogg'
	..()

/datum/job/roguetown/prince/after_spawn(mob/living/L, mob/M, latejoin = TRUE)//
	if(SSmapping.config.map_name == "Desert Town")
		cmode_music = 'sound/music/combat_desert2.ogg'
	..()
	
/datum/job/roguetown/councillor/after_spawn(mob/living/L, mob/M, latejoin = TRUE)//
	if(SSmapping.config.map_name == "Desert Town")
		cmode_music = 'sound/music/combat_desert2.ogg'
	..()

/datum/job/roguetown/hand/after_spawn(mob/living/L, mob/M, latejoin = TRUE)//
	if(SSmapping.config.map_name == "Desert Town")
		cmode_music = 'sound/music/combat_desert2.ogg'
	..()

/datum/job/roguetown/squire/after_spawn(mob/living/L, mob/M, latejoin = TRUE)//
	if(SSmapping.config.map_name == "Desert Town")
		cmode_music = 'sound/music/combat_desert2.ogg'
	..()

// СПЕЛЛ КОНВЕРТА В РАБА
/obj/effect/proc_holder/spell/self/convertrole/slave
	name = "Recruit Slave"
	desc = "Позволяет обратить цель в рабство. Примените на цель, чтобы предложить ей стать рабом добровольно. Для насильственного подчинения цель должна быть связана, а вы должны держать её в агрессивном захвате (hard grab). Насильственный процесс занимает 30 секунд."
	new_role = "Slave"
	overlay_state = "recruit_servant"
	recruitment_faction = "Servants"
	recruitment_message = "Служи мне, %RECRUIT!"
	accept_message = "ДА, МАСТЕР!"
	refuse_message = "НЕТ!"
	recharge_time = 100

/obj/effect/proc_holder/spell/self/convertrole/slave/can_convert(mob/living/carbon/human/recruit)
	if(QDELETED(recruit))
		return FALSE
	if(!recruit.mind)
		return FALSE
	return TRUE

/obj/effect/proc_holder/spell/self/convertrole/slave/convert(mob/living/carbon/human/recruit, mob/living/carbon/human/recruiter)
	if(QDELETED(recruit) || QDELETED(recruiter))
		return FALSE

	if(recruit.stat == DEAD)
		to_chat(recruiter, span_warning("[recruit] is dead!"))
		return FALSE

	// Forceful recruitment
	if(recruit.restrained() && recruiter.pulling == recruit && recruiter.grab_state >= GRAB_AGGRESSIVE)
		recruiter.visible_message(span_warning("[recruiter] begins to forcefully enslave [recruit]!"), span_notice("You begin forcefully enslaving [recruit]..."))

		if(!do_after(recruiter, 300, target = recruit))
			to_chat(recruiter, span_warning("You fail to enslave [recruit]."))
			return FALSE

		if(QDELETED(recruit) || QDELETED(recruiter) || recruit.stat == DEAD)
			return FALSE

		if(!recruit.restrained())
			to_chat(recruiter, span_warning("[recruit] managed to break free from restraints!"))
			return FALSE

		if(recruiter.pulling != recruit || recruiter.grab_state < GRAB_AGGRESSIVE)
			to_chat(recruiter, span_warning("You lost your grip on [recruit]!"))
			return FALSE

		recruiter.say(replacetext(recruitment_message, "%RECRUIT", "[recruit]"), forced = "[name]")
		
		if(accept_message)
			recruit.say(accept_message, forced = "[name]")
			
		if(new_role)
			recruit.job = new_role
			SEND_SIGNAL(SSdcs, COMSIG_GLOB_ROLE_CONVERTED, recruiter, recruit, new_role)
			
		ADD_TRAIT(recruit, TRAIT_SLAVE, TRAIT_GENERIC)
		return TRUE

	// Voluntary recruitment
	. = ..()
	if(.)
		ADD_TRAIT(recruit, TRAIT_SLAVE, TRAIT_GENERIC)

// СПЕЛЛ КОНВЕРТА В АЗЕБЫ 
/obj/effect/proc_holder/spell/self/convertrole/azeb
	name = "Recruit Azeb"
	new_role = "Azeb"
	recruitment_faction = "Bog Guard"
	recruitment_message = "Serve the my will, %RECRUIT!"
	accept_message = "FOR THE SULTAN!"
	refuse_message = "I refuse."

// СПЕЛЛ ОСВОБОЖДЕНИЯ РАБОВ
/obj/effect/proc_holder/spell/targeted/unconvert_slave
	name = "Unbind Slave"
	desc = "Освобождает раба от его оков. Примените на цель, чтобы снять с неё статус раба. Этот процесс занимает 30 секунд."
	action_icon = 'modular_twilight_axis/icons/mob/actions/matthios_miracles.dmi'
	action_icon_state = "shacklebreaker"
	recharge_time = 600
	range = 1
	antimagic_allowed = TRUE

/obj/effect/proc_holder/spell/targeted/unconvert_slave/cast(list/targets, mob/living/carbon/human/user = usr)
	if(!targets)
		return
	for(var/mob/living/carbon/human/target in targets)
		if(!HAS_TRAIT(target, TRAIT_SLAVE))
			to_chat(user, span_warning("[target] не является рабом!"))
			continue

		if(target.stat == DEAD)
			to_chat(user, span_warning("[target] мёртв!"))
			continue

		user.visible_message(span_notice("[user] начинает освобождать [target]..."), span_notice("Вы начинаете снимать оковы с [target]..."))

		if(do_after(user, 300, target = target))
			if(QDELETED(target) || QDELETED(user) || target.stat == DEAD)
				continue
			
			REMOVE_TRAIT(target, TRAIT_SLAVE, TRAIT_GENERIC)
			REMOVE_TRAIT(target, TRAIT_SLAVE, JOB_TRAIT)
			to_chat(user, span_notice("Вы успешно освободили [target]!"))
			to_chat(target, span_notice("Вы больше не раб! [user] даровал(а) вам свободу."))
			target.job = "Freeman"
		else
			to_chat(user, span_warning("Вам не удалось освободить [target]."))

// Doctor override (я ебу чё это за роль?)
/datum/outfit/job/roguetown/adventurer/doctor/pre_equip(mob/living/carbon/human/H)
	. = ..()
	if(SSmapping.config.map_name == "Desert Town")
		head = /obj/item/clothing/head/roguetown/turban
		shirt = /obj/item/clothing/suit/roguetown/shirt/dress/thawb

// Blacksmith override
/datum/outfit/job/roguetown/blacksmith/pre_equip(mob/living/carbon/human/H)
	. = ..()
	if(SSmapping.config.map_name == "Desert Town")
		pants = /obj/item/clothing/under/roguetown/sirwal/plainrandom
		head = /obj/item/clothing/head/roguetown/turban/random
		shoes = /obj/item/clothing/shoes/roguetown/sandals

// Fisher override
/datum/outfit/job/roguetown/fisher/pre_equip(mob/living/carbon/human/H)
	. = ..()
	if(SSmapping.config.map_name == "Desert Town")
		shoes = /obj/item/clothing/shoes/roguetown/sandals
		shirt = /obj/item/clothing/suit/roguetown/shirt/dress/thawb/random
		armor = /obj/item/clothing/suit/roguetown/shirt/robe/bisht/random

// Hunter override
/datum/outfit/job/roguetown/hunter/pre_equip(mob/living/carbon/human/H)
	. = ..()
	if(SSmapping.config.map_name == "Desert Town")
		shoes = /obj/item/clothing/shoes/roguetown/shalal
		shirt = /obj/item/clothing/suit/roguetown/shirt/dress/thawb/random
		armor = /obj/item/clothing/suit/roguetown/shirt/robe/bisht/bluegrey
		head = /obj/item/clothing/head/roguetown/tagelmust

// Miner override
/datum/outfit/job/roguetown/miner/pre_equip(mob/living/carbon/human/H)
	. = ..()
	if(SSmapping.config.map_name == "Desert Town")
		shoes = /obj/item/clothing/shoes/roguetown/sandals
		shirt = /obj/item/clothing/suit/roguetown/shirt/dress/thawb/random
		armor = /obj/item/clothing/suit/roguetown/shirt/robe/bisht/bluegrey
		head = /obj/item/clothing/head/roguetown/tagelmust

// Peasant override
/datum/outfit/job/roguetown/peasant/pre_equip(mob/living/carbon/human/H)
	. = ..()
	if(SSmapping.config.map_name == "Desert Town")
		shirt = /obj/item/clothing/suit/roguetown/shirt/dress/thawb/random
		pants = /obj/item/clothing/under/roguetown/sirwal/plainrandom
		shoes = /obj/item/clothing/shoes/roguetown/sandals

// Potter override
/datum/outfit/job/roguetown/potter/pre_equip(mob/living/carbon/human/H)
	. = ..()
	if(SSmapping.config.map_name == "Desert Town")
		shirt = /obj/item/clothing/suit/roguetown/shirt/dress/thawb/random
		pants = /obj/item/clothing/under/roguetown/sirwal/plainrandom
		shoes = /obj/item/clothing/shoes/roguetown/sandals

// Seamstress override
/datum/outfit/job/roguetown/seamstress/pre_equip(mob/living/carbon/human/H)
	. = ..()
	if(SSmapping.config.map_name == "Desert Town")
		shirt = /obj/item/clothing/suit/roguetown/shirt/dress/thawb/gold
		armor = /obj/item/clothing/suit/roguetown/shirt/robe/bisht/purple
		head = /obj/item/clothing/head/roguetown/turban/fancypurple
		shoes = /obj/item/clothing/shoes/roguetown/gladiator

// Woodcutter override
/datum/outfit/job/roguetown/woodcutter/pre_equip(mob/living/carbon/human/H)
	. = ..()
	if(SSmapping.config.map_name == "Desert Town")
		shirt = /obj/item/clothing/suit/roguetown/shirt/dress/thawb
		armor = /obj/item/clothing/suit/roguetown/shirt/robe/bisht
		head = /obj/item/clothing/head/roguetown/turban/random
		shoes = /obj/item/clothing/shoes/roguetown/sandals

// Magician override
/datum/outfit/job/roguetown/magician/pre_equip(mob/living/carbon/human/H)
	. = ..()
	if(SSmapping.config.map_name == "Desert Town")
		cloak = null
		head = /obj/item/clothing/head/roguetown/jafar
		armor = /obj/item/clothing/suit/roguetown/shirt/jafar
		belt = /obj/item/storage/belt/rogue/leather/jafar
		pants = /obj/item/clothing/under/roguetown/sirwal
		shoes = /obj/item/clothing/shoes/roguetown/shalal
		r_hand = /obj/item/rogueweapon/woodstaff/riddle_of_steel/serpent

// Merchant override
/datum/outfit/job/roguetown/merchant/pre_equip(mob/living/carbon/human/H)
	. = ..()
	if(SSmapping.config.map_name == "Desert Town")
		head = /obj/item/clothing/head/roguetown/sultan/merchant
		armor = /obj/item/clothing/suit/roguetown/armor/leather/vest/open
		shirt = /obj/item/clothing/suit/roguetown/shirt/robe/bisht/merchantbisht
		if(should_wear_masc_clothes(H))
			shoes = /obj/item/clothing/shoes/roguetown/shalal
			H.dna.species.soundpack_m = new /datum/voicepack/male/wizard()
		else if(should_wear_femme_clothes(H))
			shoes = /obj/item/clothing/shoes/roguetown/gladiator

// Shophand override
/datum/outfit/job/roguetown/shophand/pre_equip(mob/living/carbon/human/H)
	. = ..()
	if(SSmapping.config.map_name == "Desert Town")
		if(should_wear_femme_clothes(H))
			pants = /obj/item/clothing/under/roguetown/tights
			shirt = /obj/item/clothing/suit/roguetown/shirt/undershirt
			armor = /obj/item/clothing/suit/roguetown/armor/leather/vest/open/random
			shoes = /obj/item/clothing/shoes/roguetown/shalal
			belt = /obj/item/storage/belt/rogue/leather/cloth/sash/random
			beltr = /obj/item/storage/belt/rogue/pouch/coins/poor
			beltl = /obj/item/storage/keyring/merchant
			backr = /obj/item/storage/backpack/rogue/satchel
		else if(should_wear_masc_clothes(H))
			pants = /obj/item/clothing/under/roguetown/sirwal/fancy/random
			belt = /obj/item/storage/belt/rogue/leather/cloth/sash/random
			shirt = /obj/item/clothing/suit/roguetown/shirt/undershirt
			armor = /obj/item/clothing/suit/roguetown/armor/leather/vest/open/random
			shoes = /obj/item/clothing/shoes/roguetown/shalal
			beltr = /obj/item/storage/belt/rogue/pouch/coins/poor
			beltl = /obj/item/storage/keyring/merchant
			backr = /obj/item/storage/backpack/rogue/satchel
			head = /obj/item/clothing/head/roguetown/turban/random

// Tailor override
/datum/outfit/job/roguetown/tailor/pre_equip(mob/living/carbon/human/H)
	. = ..()
	if(SSmapping.config.map_name == "Desert Town")
		shirt = /obj/item/clothing/suit/roguetown/shirt/dress/thawb/gold
		armor = /obj/item/clothing/suit/roguetown/shirt/robe/bisht/purple
		head = /obj/item/clothing/head/roguetown/turban/fancypurple
		shoes = /obj/item/clothing/shoes/roguetown/gladiator

// Guildsman override
/datum/outfit/job/roguetown/guildsman/pre_equip(mob/living/carbon/human/H)
	. = ..()
	if(SSmapping.config.map_name == "Desert Town")
		pants = /obj/item/clothing/under/roguetown/sirwal/plainrandom
		head = /obj/item/clothing/head/roguetown/turban/random
		shoes = /obj/item/clothing/shoes/roguetown/sandals

// Barkeep override
/datum/outfit/job/roguetown/barkeep/pre_equip(mob/living/carbon/human/H)
	. = ..()
	if(SSmapping.config.map_name == "Desert Town")
		shirt = /obj/item/clothing/suit/roguetown/shirt/dress/thawb/random
		pants = /obj/item/clothing/under/roguetown/sirwal/plainrandom
		shoes = /obj/item/clothing/shoes/roguetown/gladiator

// Archivist override
/datum/outfit/job/roguetown/archivist/pre_equip(mob/living/carbon/human/H)
	. = ..()
	if(SSmapping.config.map_name == "Desert Town")
		head = /obj/item/clothing/head/roguetown/tagelmust
		shoes = /obj/item/clothing/shoes/roguetown/gladiator

//SQUIRE override
/datum/outfit/job/roguetown/squire/pre_equip(mob/living/carbon/human/H)
	. = ..()
	if(SSmapping.config.map_name == "Desert Town")
		cloak = /obj/item/clothing/cloak/citywatch/janissary
		head = /obj/item/clothing/head/roguetown/helmet/janissaryhelm
		shoes = /obj/item/clothing/shoes/roguetown/shalal/reinforced
		shirt = /obj/item/clothing/suit/roguetown/armor/gambeson/zyb

// Trait Slave for specific jobs in Desert Town
/datum/job/roguetown/shophand/after_spawn(mob/living/L, mob/M, latejoin = TRUE)
	..()
	if(SSmapping.config.map_name == "Desert Town")
		ADD_TRAIT(L, TRAIT_SLAVE, TRAIT_GENERIC)

/datum/job/roguetown/bathworker/after_spawn(mob/living/L, mob/M, latejoin = TRUE)
	..()
	if(SSmapping.config.map_name == "Desert Town")
		ADD_TRAIT(L, TRAIT_SLAVE, TRAIT_GENERIC)

/datum/job/roguetown/cook/after_spawn(mob/living/L, mob/M, latejoin = TRUE)
	..()
	if(SSmapping.config.map_name == "Desert Town")
		ADD_TRAIT(L, TRAIT_SLAVE, TRAIT_GENERIC)

/datum/job/roguetown/tapster/after_spawn(mob/living/L, mob/M, latejoin = TRUE)
	..()
	if(SSmapping.config.map_name == "Desert Town")
		ADD_TRAIT(L, TRAIT_SLAVE, TRAIT_GENERIC)

/datum/controller/subsystem/job/Initialize(timeofday)
	. = ..()
	if(SSmapping && SSmapping.config && SSmapping.config.map_name == "Desert Town")
		GLOB.bounty_posters["AZURIA"] = "The Sultanate of Al-Ashur"
		GLOB.bounty_posters["GRENZELHOFT"] = "The Exalted Church of Zybantia"
		if(!(/mob/living/simple_animal/hostile/retaliate/rogue/camel/tame/saddled in GLOB.virtue_mount_choices))
			GLOB.virtue_mount_choices += /mob/living/simple_animal/hostile/retaliate/rogue/camel/tame/saddled

/datum/job/roguetown/veteran/after_spawn(mob/living/L, mob/M, latejoin = TRUE)
	..()
	if(SSmapping.config.map_name == "Desert Town")
		if(ishuman(L))
			var/mob/living/carbon/human/H = L
			for(var/obj/item/roguekey/veteran/old_key in H.get_all_contents())
				qdel(old_key)
			var/obj/item/storage/keyring/veteran_d/keys = new(H)
			if(!H.equip_to_appropriate_slot(keys))
				if(!H.put_in_hands(keys))
					keys.forceMove(H.drop_location())

/datum/job/roguetown/physician/after_spawn(mob/living/L, mob/M, latejoin = TRUE)
	..()
	if(SSmapping.config.map_name == "Desert Town")
		if(ishuman(L))
			var/mob/living/carbon/human/H = L
			for(var/obj/item/storage/keyring/physician/old_key in H.get_all_contents())
				qdel(old_key)
			var/obj/item/storage/keyring/courtphysician/keys = new(H)
			if(!H.equip_to_appropriate_slot(keys))
				if(!H.put_in_hands(keys))
					keys.forceMove(H.drop_location())
