/datum/intent/dagger/chop/necra
	damfactor = 1.2
	intent_intdamage_factor = 1.35 // I HAVE NO PICK BUT I MUST KILL
	swingdelay = 10
	clickcd = 10
	penfactor = PEN_MEDIUM

/datum/intent/dagger/cut/dendor // me like cut
	damfactor = 1.1
	clickcd = 8

/datum/intent/dagger/thrust/dendor // me no like stab
	damfactor = 0.8

/datum/intent/dagger/thrust/pick/abyssor
	damfactor = 1.2

/datum/intent/dagger/thrust/malum // hits slower but harder slight DPM buff
	damfactor = 1.3
	clickcd = 10

/obj/item/rogueweapon/huntingknife/idagger/steel/devilsknife
	name ="devilsknife"
	desc = "More a sickle than a knife. It is said that Xylix once won these in a game of chance against an archdevil. These are simple reproductions, with jingling bells attached to the blades."
	icon_state = "devilsknife"
	icon = 'modular_twilight_axis/icons/roguetown/weapons/32.dmi'
	force = 22 // 10% - This is a 8 clickCD weapon
	max_integrity = 200

/obj/item/rogueweapon/huntingknife/throwingknife/steel/noc
	name = "twilight fang"
	desc = "Large tossblade meant for both fighting and throwing. Perfect for striking from the shadows of Noc."
	item_state = "bone_dagger"
	possible_item_intents = list(/datum/intent/dagger/thrust, /datum/intent/dagger/cut, /datum/intent/dagger/thrust/pick, /datum/intent/dagger/sucker_punch)
	force = 21
	throwforce = 28
	throw_speed = 4
	max_integrity = 200
	armor_penetration = 40
	icon_state = "noc_dagger"
	icon = 'modular_twilight_axis/icons/roguetown/weapons/32.dmi'
	embedding = list("embedded_pain_multiplier" = 4, "embed_chance" = 30, "embedded_fall_chance" = 5)

/obj/item/rogueweapon/huntingknife/idagger/steel/astrata
	name ="dawnbringer"
	desc = "A blade forged in the name of Astrata herself. It glistens under the light reminding your foes what is coming."
	icon_state = "astrata_dagger"
	icon = 'modular_twilight_axis/icons/roguetown/weapons/32.dmi'
	force = 22
	max_integrity = 200

/obj/item/rogueweapon/huntingknife/idagger/steel/parrying/eora
	name = "misericorde"
	icon_state = "eora_dagger"
	icon = 'modular_twilight_axis/icons/roguetown/weapons/32.dmi'
	force = 10
	throwforce = 10
	desc = "A parrying dagger created to be used in the free hand and deliver mercy to the foes you've bested."
	sheathe_icon = "spdagger"
	wdefense = 9 // Eoran rapier has 8 def so I had to bump it to 9 in order to parry with a dagger
	max_integrity = 200

/obj/item/rogueweapon/huntingknife/idagger/steel/ravox
	name ="echo of triumph"
	desc = "Once, it was a greatsword wielded by the chosen of Ravox. After centuries of battles, the blade finally broke. However, the remaining pieces were reforged into a dagger that reminds battles of the past."
	icon_state = "ravox_dagger"
	icon = 'modular_twilight_axis/icons/roguetown/weapons/32.dmi'
	force = 22
	max_integrity = 200

/obj/item/rogueweapon/huntingknife/idagger/steel/abyssor
	name ="darkwater ripper"
	desc = "Fierce dagger quenched in the abyssal depths. If you listen closely, you can hear the clashing of waves during high tide."
	icon_state = "abyssor_dagger"
	icon = 'modular_twilight_axis/icons/roguetown/weapons/32.dmi'
	possible_item_intents = list(/datum/intent/dagger/thrust, /datum/intent/dagger/cut, /datum/intent/dagger/thrust/pick/abyssor, /datum/intent/dagger/sucker_punch)
	force = 22
	max_integrity = 200

/obj/item/rogueweapon/huntingknife/idagger/steel/dendor
	name ="maddening thorn"
	desc = "Simple yet wickedly sharp blade fixed to the handle grown whole. The hilt is covered by tiny prickly thorns that slowly madden the wielder."
	icon_state = "dendor_dagger"
	icon = 'modular_twilight_axis/icons/roguetown/weapons/32.dmi'
	possible_item_intents = list(/datum/intent/dagger/thrust/dendor, /datum/intent/dagger/cut/dendor, /datum/intent/dagger/thrust/pick, /datum/intent/dagger/sucker_punch)
	force = 22
	max_integrity = 200

/obj/item/rogueweapon/huntingknife/idagger/steel/malum
	name ="embertongue"
	desc = "Wavy flamelike blade forged in the name of Malum himself."
	icon_state = "malum_dagger"
	icon = 'modular_twilight_axis/icons/roguetown/weapons/32.dmi'
	possible_item_intents = list(/datum/intent/dagger/thrust/malum, /datum/intent/dagger/cut, /datum/intent/dagger/thrust/pick, /datum/intent/dagger/sucker_punch)
	force = 22
	wdefense = 2
	max_integrity = 200

/obj/item/rogueweapon/huntingknife/idagger/steel/necra
	name ="osteotome"
	desc = "A macabre cleaver. The hilt is made from a humen spine reinforced with a steel tang."
	icon_state = "necra_dagger"
	icon = 'modular_twilight_axis/icons/roguetown/weapons/32.dmi'
	possible_item_intents = list(/datum/intent/dagger/cut, /datum/intent/dagger/chop/necra) // chop chop chop
	force = 23
	max_integrity = 200
	smeltresult = /obj/item/ingot/silver
	is_silver = TRUE

/obj/item/rogueweapon/huntingknife/idagger/steel/necra/ComponentInitialize()
	AddComponent(\
		/datum/component/silverbless,\
		pre_blessed = BLESSING_TENNITE,\
		silver_type = SILVER_TENNITE,\
		added_force = 0,\
		added_blade_int = 50,\
		added_int = 50,\
		added_def = 2,\
	)

/obj/item/rogueweapon/huntingknife/idagger/steel/baotha
	name = "snakes sting"
	desc = "The blade is skillfully crafted and appears to be designed for stealthy assassinations. There are visible streaks of a bubbling substance on its blade."
	icon = 'modular_twilight_axis/icons/roguetown/weapons/32.dmi'
	icon_state = "baotha_knife1"
	max_blade_int = 300
	throwforce = 40
	force = 25
	wdefense = 4
	var/last_cut = 0
	var/last_drug = 0

/obj/item/rogueweapon/huntingknife/idagger/steel/baotha/get_examine_highlight_status()
	return list(EXAMINEHIGHLIGHT_HERESYSEVERITY_ALARMING, HERESYDESC_BAOTHA_WEAPON)

/obj/item/rogueweapon/huntingknife/idagger/steel/baotha/Initialize()
	. = ..()
	icon_state = "baotha_knife1"
	addtimer(CALLBACK(src, "icon_proc"), wait = (1 SECONDS))
	AddComponent(/datum/component/cursed_item, TRAIT_CRACKHEAD, "KNIFE")
	RegisterSignal(src, COMSIG_ITEM_ATTACK_EFFECT_SELF, PROC_REF(on_hit_effects))

/obj/item/rogueweapon/huntingknife/idagger/steel/baotha/proc/icon_proc()
	icon_state = "baotha_knife2"

/obj/item/rogueweapon/huntingknife/idagger/steel/baotha/attack_self(var/mob/living/carbon/human/user)
	if(user.patron.type == /datum/patron/inhumen/baotha)
		if(do_after(user, 10, target = src))
			var/obj/item/clothing/ring/baotha/S = new/obj/item/clothing/ring/baotha(get_turf(src.loc))
			if(user.is_holding(src))
				user.dropItemToGround(src)
				user.put_in_hands(S)
			qdel(src)
			playsound(user, pick('sound/magic/magic_nulled.ogg'), 20, TRUE)
		else
			to_chat(user, "<span class='notice'>I losing concentration!</span>")

/obj/item/rogueweapon/huntingknife/idagger/steel/baotha/proc/on_hit_effects(obj/item/source, mob/living/user, obj/item/bodypart/affecting, intent, mob/living/victim, selzone)
	SIGNAL_HANDLER
	
	if(!istype(victim, /mob/living/carbon))
		return

	var/mob/living/carbon/human/target = victim
	var/random_drug = pick(list(/datum/reagent/ozium, /datum/reagent/moondust))
	var/selected_hallucination = pick(list(
		"Is this TRVE??", "IDDQD", "DAFUQ?", "I am NOT meant to see this.",
		"What... WHAT is this?", "This doesn't make SENSE.", "I don't UNDERSTAND.",
		"Why does it LOOK like that?", "Something is WRONG here.", "This isn't RIGHT.",
		"What am I looking at?", "None of THIS adds up.", "I shouldn't be SEEING this.",
		"This feels... INCORRECT.", "Why is everything like this?", "I CAN'T process this.",
		"This ISN'T how it should be.", "I don't get it.", "What is happening?",
		"This is all WRONG.", "I CAN'T tell what's REAL.", "Why does it feel off?",
		"I don't recognize this.", "This SHOULDN'T exist.", "What is THIS supposed to be?",
		"I can't FOLLOW this.", "This isn't making sense anymore.", "I think SOMETHING is broke.",
		"Why can't I understand THIS?", "This feels IMPOSSIBLE.", "I don't KNOW what I'm seeing."
	))

	if(!HAS_TRAIT(target, TRAIT_PSYCHOSIS))
		ADD_TRAIT(target, TRAIT_PSYCHOSIS, "baothaknife")
		addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(baothapsychosis), target), wait = 1 MINUTES)

	target.hallucination = rand(1,60)
	to_chat(target, span_warning(selected_hallucination))
	target.Jitter(5)

	if(prob(50))
		addtimer(CALLBACK(target, "emote", pick("giggle","laugh","chuckle")), 0)

	if(last_cut + 10 SECONDS >= world.time) return
	target.blur_eyes(5)
	target.adjust_blurriness(10)
	target.adjustToxLoss(10)
	last_cut = world.time
	if(last_drug + 1 MINUTES >= world.time) return
	target.reagents.add_reagent(random_drug, 2)
	last_drug = world.time

/proc/baothapsychosis(mob/living/carbon/target)
	if(QDELETED(target))
		return

	REMOVE_TRAIT(target, TRAIT_PSYCHOSIS, "baothaknife")
