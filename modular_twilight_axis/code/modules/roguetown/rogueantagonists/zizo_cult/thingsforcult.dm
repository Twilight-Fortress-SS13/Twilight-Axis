//хуйня для работоспособности культа, ктрл+с, ктрл+м, чтобы он хотя-бы работал, как в пре на оффах. Может потом сделаем норм, а может нет. 

//хуйня из code/__DEFINES/_globals.dm
//All characters between < a > inclusive of the bracket
GLOBAL_DATUM_INIT(html_tags, /regex, regex(@"<.*?>", "g"))


// code/__DEFINES/dcs/signals/signals_mob.dm
//бля крч там по списку с пра - https://github.com/Azure-Peak/Azure-Peak/pull/5092/files 
///From mob/living/proc/wabbajack(): (randomize_type)
#define COMSIG_LIVING_PRE_WABBAJACKED "living_mob_wabbajacked"
	/// Return to stop the rest of the wabbajack from triggering.
	#define STOP_WABBAJACK (1<<0)
///From mob/living/proc/on_wabbajack(): (mob/living/new_mob)
#define COMSIG_LIVING_ON_WABBAJACKED "living_wabbajacked"

// Randomization keys for calling wabbajack with.
// Note the contents of these keys are important, as they're displayed to the player
// Ex: (You turn into a "monkey", You turn into a "xenomorph")
#define WABBAJACK_HUMAN "humanoid"
#define WABBAJACK_ANIMAL "animal"


// randomise_appearance_prefs() and randomize_human_appearance() proc flags
#define RANDOMIZE_GENDER (1<<0)
#define RANDOMIZE_SPECIES (1<<1)
#define RANDOMIZE_PRONOUNS (1<<2)
#define RANDOMIZE_VOICETYPE (1<<3)
#define RANDOMIZE_NAME (1<<4)
#define RANDOMIZE_AGE (1<<5)
#define RANDOMIZE_UNDERWEAR (1<<6)
#define RANDOMIZE_HAIRSTYLE (1<<7)
#define RANDOMIZE_FACIAL_HAIRSTYLE (1<<8)
#define RANDOMIZE_HAIR_COLOR (1<<9)
#define RANDOMIZE_FACIAL_HAIR_COLOR (1<<10)
#define RANDOMIZE_SKIN_TONE (1<<11)
#define RANDOMIZE_EYE_COLOR (1<<12)
#define RANDOMIZE_FEATURES (1<<13)

#define RANDOMIZE_HAIR_FEATURES (RANDOMIZE_HAIRSTYLE | RANDOMIZE_FACIAL_HAIRSTYLE)
#define RANDOMIZE_HAIR_COLORS (RANDOMIZE_HAIR_COLOR | RANDOMIZE_HAIR_COLORS)
#define RANDOMIZE_HAIR_ALL (RANDOMIZE_HAIR_FEATURES | RANDOMIZE_HAIR_COLORS)
//смотрящий глазюк
/obj/item/scrying/eye
	name = "accursed eye"
	desc = "It is pulsating."
	icon = 'modular_twilight_axis/code/modules/roguetown/rogueantagonists/zizo_cult/sprites/scryeye.dmi'
	icon_state ="scryeye"
	cooldown = 10 MINUTES
/obj/item/scrying/eye/Initialize(mapload, ...)
	. = ..()
	AddComponent(/datum/component/cursed_item, TRAIT_CABAL, "EYE")

//шадоу плащ но без уникального спрайта, бяка
/obj/item/clothing/cloak/half/shadowcloak/cult
	name = "Zizo cultistic's cloak"
	desc = "Those who wear, thy should beware, for those who do; never come back as who they once were again."
	allowed_race = NON_DWARVEN_RACE_TYPES
	body_parts_covered = ARMS|CHEST|VITALS
	armor = ARMOR_PADDED_GOOD

/obj/item/clothing/cloak/half/shadowcloak/cult/Initialize(mapload, ...)
	. = ..()
	AddComponent(/datum/component/cursed_item, TRAIT_CABAL, "CLOAK")
//котелок, но культа
/obj/item/clothing/head/roguetown/helmet/skullcap/cult
	name = "Zizo cultistic's hood"
	desc = "It echoes with ominous laughter. Worn over a skullcap"
	icon = 'modular_twilight_axis/code/modules/roguetown/rogueantagonists/zizo_cult/sprites/clothes/warlock.dmi'
	mob_overlay_icon = 'modular_twilight_axis/code/modules/roguetown/rogueantagonists/zizo_cult/sprites/clothes/on_mob/warlock.dmi'
	icon_state = "warlockhood"
	flags_inv = HIDEEARS|HIDEFACE|HIDEHAIR|HIDEFACIALHAIR

	body_parts_covered = NECK|HAIR|EARS|HEAD

/obj/item/clothing/head/roguetown/helmet/skullcap/cult/Initialize(mapload, ...)
	. = ..()
	AddComponent(/datum/component/cursed_item, TRAIT_CABAL, "HOOD")
//коса культа.. дайте две
/obj/item/rogueweapon/zizo/neant
	name = "neant"
	desc = "A dark scythe with a long chain, used to cut the life essence from people, or whip them into shape. The blade is an ominous purple."
	icon_state = "neant"
	icon = 'modular_twilight_axis/icons/roguetown/weapons/64.dmi'
	drop_sound = 'modular_twilight_axis/code/modules/roguetown/rogueantagonists/zizo_cult/sounds/blade_drop.ogg'
	slot_flags = ITEM_SLOT_BACK
	resistance_flags = FIRE_PROOF
	dropshrink = 0.75
	max_blade_int = 200
	max_integrity = 720
	possible_item_intents = list(/datum/intent/spear/cut/bardiche)
	gripped_intents = list(/datum/intent/axe/chop/scythe, /datum/intent/whip, /datum/intent/shoot/neant)
	thrown_bclass = BCLASS_CUT
	blade_dulling = DULLING_BASHCHOP
	wdefense = 8
	force = 25
	force_wielded = 25
	throwforce = 25
	minstr = 10
	sellprice = 550
	wbalance = WBALANCE_HEAVY
	associated_skill = /datum/skill/combat/polearms

	COOLDOWN_DECLARE(fire_projectile)

/obj/item/rogueweapon/zizo/neant/getonmobprop(tag)
	. = ..()
	if(tag)
		switch(tag)
			if("gen")
				return list("shrink" = 0.6,"sx" = -7,"sy" = 2,"nx" = 7,"ny" = 3,"wx" = -2,"wy" = 1,"ex" = 1,"ey" = 1,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = -38,"sturn" = 37,"wturn" = 30,"eturn" = -30,"nflip" = 0,"sflip" = 8,"wflip" = 8,"eflip" = 0)
			if("wielded")
				return list("shrink" = 0.6,"sx" = 5,"sy" = -3,"nx" = -5,"ny" = -2,"wx" = -5,"wy" = -1,"ex" = 3,"ey" = -2,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = 7,"sturn" = -7,"wturn" = 16,"eturn" = -22,"nflip" = 8,"sflip" = 0,"wflip" = 8,"eflip" = 0)
			if("onbelt")
				return list("shrink" = 0.3,"sx" = -2,"sy" = -5,"nx" = 4,"ny" = -5,"wx" = 0,"wy" = -5,"ex" = 2,"ey" = -5,"nturn" = 0,"sturn" = 0,"wturn" = 0,"eturn" = 0,"nflip" = 0,"sflip" = 0,"wflip" = 0,"eflip" = 0,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0)

/obj/item/rogueweapon/zizo/neant/Initialize(mapload, ...)
	. = ..()
	AddComponent(/datum/component/cursed_item, TRAIT_CABAL, "NEANT")

/obj/item/rogueweapon/zizo/neant/attack(mob/living/M, mob/living/user)
	if(user.used_intent.tranged)
		return
	return ..()

/obj/item/rogueweapon/zizo/neant/afterattack(atom/target, mob/living/user, proximity_flag, click_parameters)
	. = ..()
	if(!HAS_TRAIT(user, TRAIT_CABAL) || !istype(user.patron, /datum/patron/inhumen/zizo))
		return
	if(user.used_intent?.tranged)
		handle_magick(user, target)
		return
	if(!ishuman(target))
		return
	if(check_zone(user.zone_selected) != BODY_ZONE_CHEST)
		return
	var/mob/living/carbon/human/H = target
	if(!H.has_status_effect(/datum/status_effect/debuff/devitalised))
		return
	var/dead = H.stat == DEAD
	if((H.health < H.crit_threshold) || dead)
		var/speed = dead ? 3 SECONDS : 7 SECONDS
		visible_message(user, span_notice("Neant lights up and begins to tear at [target]..."))
		if(!do_after(user, speed, H))
			return
		var/obj/item/bodypart/chest/C = H.get_bodypart(BODY_ZONE_CHEST)
		if(!C)
			return
		playsound(get_turf(user), 'sound/surgery/scalpel2.ogg', 70)
		if(do_after(user, 0.5 SECONDS, target))
			C.add_wound(/datum/wound/slash/incision)

		playsound(get_turf(user), 'sound/surgery/organ2.ogg', 70)
		if(do_after(user, 0.5 SECONDS, target))
			C.add_wound(/datum/wound/fracture/chest)

		new /obj/item/reagent_containers/lux(get_turf(target))

		H.apply_status_effect(/datum/status_effect/debuff/devitalised)
		SEND_SIGNAL(user, COMSIG_LUX_EXTRACTED, target)
		record_featured_stat(FEATURED_STATS_CRIMINALS, user)
		record_round_statistic(STATS_LUX_HARVESTED)

		H.add_splatter_floor()
		H.adjustBruteLoss(20)
		visible_message(user, span_notice("Neant's blade draws the lux from [target]!"))

/obj/item/rogueweapon/zizo/neant/proc/handle_magick(mob/living/user, atom/target)
	if(!COOLDOWN_FINISHED(src, fire_projectile))
		return
	var/client/client = user.client
	if(!client?.chargedprog)
		return

	var/startloc = get_turf(src)
	var/obj/projectile/bullet/neant/PJ = new(startloc)
	PJ.starting = startloc
	PJ.firer = user
	PJ.fired_from = src
	PJ.original = target
	playsound(get_turf(user),'modular_twilight_axis/code/modules/roguetown/rogueantagonists/zizo_cult/sounds/neantspecial.ogg', 70)

	if(user.STAPER > 8)
		PJ.accuracy += (user.STAPER - 8) * 2 //each point of perception above 8 increases standard accuracy by 2.
		PJ.bonus_accuracy += (user.STAPER - 8) //Also, increases bonus accuracy by 1, which cannot fall off due to distance.

	if(user.STAINT > 10) // Every point over 10 INT adds 10% damage
		PJ.damage = PJ.damage * (user.STAINT / 10)
		PJ.accuracy += (user.STAINT - 10) * 3

	new /obj/effect/temp_visual/dir_setting/firing_effect/neant(get_step(user, user.dir), user.dir)
	PJ.preparePixelProjectile(target, user)
	PJ.fire()
	user.changeNext_move(CLICK_CD_RANGE)
	COOLDOWN_START(src, fire_projectile, 4 SECONDS)

/obj/projectile/bullet/neant
	name = "Profane Evisceration"
	icon = 'modular_twilight_axis/code/modules/roguetown/rogueantagonists/zizo_cult/sprites/special.dmi'
	icon_state = "neantprojectile"
	hitsound = 'sound/combat/hits/hi_arrow2.ogg'
	range = 8
	damage = 20
	armor_penetration = 30
	damage_type = BRUTE
	woundclass = BCLASS_CUT
	flag =  "piercing"
	speed = 1
	accuracy = 80

/obj/effect/temp_visual/dir_setting/firing_effect/neant
	icon = 'modular_twilight_axis/code/modules/roguetown/rogueantagonists/zizo_cult/sprites/special.dmi'
	icon_state = "neantspecial"
	duration = 4

/datum/intent/shoot/neant
	name = "shoot"
	icon_state = "inshoot"
	warnie = "aimwarn"
	tranged = TRUE
	chargetime = 2 SECONDS
	no_early_release = TRUE
	noaa = TRUE
	charging_slowdown = 2

/datum/intent/shoot/neant/prewarning()
	if(mastermob)
		mastermob.visible_message(span_warning("[mastermob] draws [masteritem]!"))

/// Fully randomizes everything in the character.
// Reflect changes in [datum/preferences/proc/randomise_appearance_prefs]
/mob/living/carbon/human/proc/randomize_human_appearance(randomise_flags = ALL, include_donator = TRUE)
	if(!dna)
		return

	if(randomise_flags & RANDOMIZE_SPECIES)
		var/rando_race = GLOB.species_list[pick(get_selectable_species(include_donator))]
		set_species(new rando_race(), FALSE)

	var/datum/species/species = dna.species

	if(NOEYESPRITES in species?.species_traits)
		randomise_flags &= ~RANDOMIZE_EYE_COLOR

	if(randomise_flags & RANDOMIZE_GENDER)
		gender = species.sexes ? pick(MALE, FEMALE) : PLURAL

	if(randomise_flags & RANDOMIZE_AGE)
		age = pick(species.possible_ages)

	if(randomise_flags & RANDOMIZE_NAME)
		real_name = species.random_name(gender, TRUE)

	if(randomise_flags & RANDOMIZE_SKIN_TONE)
		var/list/skin_list = species.get_skin_list()
		skin_tone = pick_assoc(skin_list)

	if(randomise_flags & RANDOMIZE_EYE_COLOR)
		var/obj/item/organ/eyes/eyes = getorganslot(ORGAN_SLOT_EYES)
		eyes.eye_color = random_eye_color()

/mob/living/proc/set_eyes_closed(closed)
	if(eyesclosed == closed)
		return

	eyesclosed = closed

	if(eyesclosed)
		become_blind("eyelids")
	else
		cure_blind("eyelids")

	if(hud_used)
		var/atom/movable/screen/eye_intent/eyet = locate() in hud_used.static_inventory
		eyet.update_icon(UPDATE_ICON)

// Used in polymorph code to shapeshift mobs into other creatures
/**
 * Polymorphs our mob into another mob.
 * If successful, our current mob is qdeleted!
 *
 * what_to_randomize - what are we randomizing the mob into? See the defines for valid options.
 * change_flags - only used for humanoid randomization (currently), what pool of changeflags should we draw from?
 *
 * Returns a mob (what our mob turned into) or null (if we failed).
 */
/mob/living/proc/wabbajack(what_to_randomize, change_flags = WABBAJACK)
	if(stat == DEAD || (status_flags & GODMODE))
		return

	if(SEND_SIGNAL(src, COMSIG_LIVING_PRE_WABBAJACKED, what_to_randomize) & STOP_WABBAJACK)
		return

	ADD_TRAIT(src,TRAIT_HANDS_BLOCKED, TRAIT_GENERIC)
	icon = null
	cut_overlays()
	invisibility = INVISIBILITY_ABSTRACT

	var/list/item_contents = list()

	for(var/obj/item/item in src)
		if(!dropItemToGround(item))
			qdel(item)
			continue
		item_contents += item

	var/mob/living/new_mob

	var/static/list/possible_results = list(
		WABBAJACK_HUMAN,
		WABBAJACK_ANIMAL,
	)

	// If we weren't passed one, pick a default one
	what_to_randomize ||= pick(possible_results)

	switch(what_to_randomize)

		if(WABBAJACK_ANIMAL)
			var/picked_animal = pick(
				/mob/living/simple_animal/hostile/retaliate/bat,
				/mob/living/simple_animal/hostile/retaliate/rogue/chicken,
				/mob/living/simple_animal/hostile/retaliate/rogue/cow,
				/mob/living/simple_animal/hostile/retaliate/goat,
				/mob/living/simple_animal/hostile/retaliate/rogue/spider,
				/mob/living/simple_animal/pet/cat,
				/mob/living/simple_animal/hostile/retaliate/rogue/mudcrab/cabbit,
			)
			new_mob = new picked_animal(loc)

		if(WABBAJACK_HUMAN)
			var/mob/living/carbon/human/new_human = new(loc)

			// 50% chance that we'll also randomice race
			if(prob(50))
				var/list/chooseable_races = list()
				for(var/datum/species/species_type as anything in subtypesof(/datum/species))
					if(initial(species_type.changesource_flags) & change_flags)
						chooseable_races += species_type

				if(length(chooseable_races))
					new_human.set_species(pick(chooseable_races))

			// Randomize everything but the species, which was already handled above.
			new_human.randomize_human_appearance(~RANDOMIZE_SPECIES)
			new_human.update_body()
			new_human.dna.update_dna_identity()
			new_mob = new_human

		else
			stack_trace("wabbajack() was called without an invalid randomization choice. ([what_to_randomize])")

	if(!new_mob)
		return

	to_chat(src, span_hypnophrase(span_big("Your form morphs into that of a [what_to_randomize]!")))


/datum/status_effect/debuff/fleshmend_exhaustion 
	id = "fleshmend_tax"
	duration = 6000
	alert_type = /atom/movable/screen/alert/status_effect/fleshmend_tax
	effectedstats = list(STATKEY_STR = -2, STATKEY_SP = -2, STATKEY_CON = -2)

/atom/movable/screen/alert/status_effect/fleshmend_tax
	name = "Истощение плоти"
	desc = "Ваше тело было исцелено магией Зизо, но цена была высока. Сила, выносливость и скорость снижены."
	icon_state = "debuff"

/obj/item/clothing/neck/roguetown/psicross/inhumen/aalloy/cult
	name = "Reverted psycross of ascension's"
	desc = "This cursed zcross will give something good por followers of Zizo.."
	mob_overlay_icon = 'modular_twilight_axis/code/modules/roguetown/rogueantagonists/zizo_cult/sprites/clothes/on_mob/zcross.dmi'
	icon = 'modular_twilight_axis/code/modules/roguetown/rogueantagonists/zizo_cult/sprites/clothes/zcross.dmi'
	icon_state = "zcross"
	slot_flags = ITEM_SLOT_NECK
	sellprice = 0
	max_integrity = 100
	body_parts_covered = COVERAGE_FULL | COVERAGE_HEAD_NOSE | NECK | HANDS | FEET 
	armor = ARMOR_FATEWEAVER 
	blade_dulling = DULLING_BASHCHOP
	blocksound = PLATEHIT
	break_sound = 'sound/foley/breaksound.ogg'
	drop_sound = 'sound/foley/dropsound/armor_drop.ogg'
	armor_class = ARMOR_CLASS_LIGHT
	unenchantable = TRUE
	anvilrepair = null

/obj/item/clothing/neck/roguetown/psicross/inhumen/aalloy/cult/mob_can_equip(mob/living/M, mob/living/equipper, slot, disable_warning = FALSE, bypass_equip_delay_self = FALSE)
	if(!M.can_equip(src, slot, disable_warning, bypass_equip_delay_self))
		return FALSE

	
	if(slot == SLOT_WRISTS || (wrist_display && slot != SLOT_NECK))
		mob_overlay_icon = 'icons/roguetown/clothing/onmob/wrists.dmi'
		sleeved = 'icons/roguetown/clothing/onmob/wrists.dmi'
	else
		mob_overlay_icon = initial(mob_overlay_icon)
		sleeved = initial(sleeved)

	return TRUE

/obj/item/clothing/neck/roguetown/psicross/inhumen/aalloy/cult/Initialize()
	. = ..()
	AddComponent(/datum/component/cursed_item, TRAIT_CABAL, "CROSS")

/obj/item/clothing/neck/roguetown/psicross/inhumen/aalloy/cult/equipped(mob/living/carbon/human/user, slot)
	. = ..()
	if(slot == SLOT_RING || slot == SLOT_NECK || SLOT_WRISTS)
		ADD_TRAIT(user, TRAIT_ZIZOSIGHT, TRAIT_GENERIC)

/obj/item/clothing/neck/roguetown/psicross/inhumen/aalloy/cult/dropped(mob/living/carbon/human/user)
	. = ..()
	REMOVE_TRAIT(user, TRAIT_ZIZOSIGHT, TRAIT_GENERIC)

//статус эффекты

/datum/status_effect/debuff/ritualdefiled/cult
	id = "ritualdefiled"
	alert_type = /atom/movable/screen/alert/status_effect/debuff/ritualdefiled
	effectedstats = list(STATKEY_STR = -2, STATKEY_WIL = -3, STATKEY_CON = -1, STATKEY_SPD = -1, STATKEY_LCK = -3)
	duration = 30 MINUTES // Punishing AS FUCK, but not as punishing as being dead.

/datum/status_effect/debuff/arcynestolen
	id = "arcynestolen"
	alert_type = /atom/movable/screen/alert/status_effect/debuff/arcynestolen
	duration = 30 MINUTES

/datum/status_effect/debuff/arcynestolen/on_apply()
	. = ..()
	ADD_TRAIT(owner, TRAIT_SPELLCOCKBLOCK, id)

/datum/status_effect/debuff/arcynestolen/on_remove()
	. = ..()
	REMOVE_TRAIT(owner, TRAIT_SPELLCOCKBLOCK, id)

/atom/movable/screen/alert/status_effect/debuff/arcynestolen
	name = "Stolen arcyne"
	desc = "This cultists is stolen my magic.. Maybe it will come back later.."
