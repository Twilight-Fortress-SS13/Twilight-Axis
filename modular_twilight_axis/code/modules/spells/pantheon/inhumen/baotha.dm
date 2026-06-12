/obj/effect/proc_holder/spell/invoked/lux_steal
	name = "Lux Steal"
	desc = "A miracle that allows you to extract Lux from a living creature. \
	Casting this miracle on a sentient creature that is under the influence of drugs or alcohol will allow you to extract a portion of the creature's life. \
	This also works when the target is highly aroused. \
	Casting this miracle on yourself will cause you to regurgitate the Lux you have swallowed."
	action_icon = 'modular_twilight_axis/icons/mob/actions/baothamiracles.dmi'
	overlay_icon = 'modular_twilight_axis/icons/mob/actions/baothamiracles.dmi'
	overlay_state = "luxsteal0"
	releasedrain = 100
	chargedrain = 0
	chargetime = 0
	range = 1
	warnie = "sydwarning"
	movement_interrupt = FALSE
	invocation_type = "none"
	associated_skill = /datum/skill/magic/holy
	antimagic_allowed = TRUE
	recharge_time = 5 SECONDS 
	miracle = TRUE
	devotion_cost = 0
	var/lux = FALSE
	var/pure = FALSE

/obj/effect/proc_holder/spell/invoked/lux_steal/cast(list/targets, mob/living/user)
	if(!ishuman(targets?[1]))
		revert_cast()
		return FALSE

	var/mob/living/carbon/human/H = targets[1]
	if(H == user)
		if(lux)
			lux = FALSE
			var/lux_type = /obj/item/reagent_containers/lux_impure
			if(pure)
				lux_type = /obj/item/reagent_containers/lux
				pure = FALSE
			var/obj/item/reagent_containers/L = new lux_type (user.loc)
			user.visible_message(span_love("[user] regurgitate [L] out of his mouth, and a pink-slime-covered object falls into his hands!"))
			user.put_in_hands(L)
			return TRUE
	if(lux)
		to_chat(user, span_warning("I already carrying someone elses Lux inside me."))
		return FALSE
	if(prob(20 + ((H.STAPER - 10) * 10)))
		to_chat(H, span_warning("Something wrong..."))

	if(!do_after(user, 5 SECONDS, TRUE, H, TRUE))
		to_chat(user, span_warning("My concentration breaks!"))
		revert_cast()
		return FALSE
	devotion_cost = 100
	var/list/arousal_data = list()
	SEND_SIGNAL(H, COMSIG_SEX_GET_AROUSAL, arousal_data)
	var/point_count = 0
	if(arousal_data["arousal"] >= 80)
		to_chat(user, span_love("My pray has arousual!"))
		point_count += 2
	if(H.has_stress_event(/datum/stressevent/TAlasthigh))
		to_chat(user, span_love("My pray has under my high-blessing!"))
		point_count += 1
	if(H.has_status_effect(/datum/status_effect/buff/druqks))
		to_chat(user, span_love("My pray has under druqks!"))
		point_count += 1
	if(H.has_status_effect(/datum/status_effect/buff/drunk))
		to_chat(user, span_love("My pray has drunked!"))
		point_count += 1
	if(H.has_status_effect(/datum/status_effect/buff/ozium))
		to_chat(user, span_love("My pray has under ozium!"))
		point_count += 1
	if(point_count < 2)
		revert_cast()
		return FALSE
	user.visible_message(span_love("[user] brings his lips close to [H]'s, capturing [H] in a passionate kiss!"))
	if(H.has_status_effect(/datum/status_effect/debuff/devitalised) || H.has_status_effect(/datum/status_effect/debuff/devitalised/greater) || istiefling(H))
		to_chat(user, span_warning("NO LUX!"))
		return FALSE
	var/apply_greater
	lux = TRUE
	overlay_state = "luxsteal1"
	if(isaasimar(H))
		pure = TRUE
		apply_greater = TRUE
	user.visible_message(span_love("[user] swallows something, breaking the kiss!"))
	SEND_SIGNAL(user, COMSIG_LUX_EXTRACTED, H)
	record_round_statistic(STATS_LUX_HARVESTED)
	H.apply_status_effect((apply_greater ? /datum/status_effect/debuff/devitalised/greater : /datum/status_effect/debuff/devitalised))
	return TRUE

/obj/effect/proc_holder/spell/self/mirage
	name = "Mirage"
	desc = "Provide you mirror magic effect."
	action_icon = 'modular_twilight_axis/icons/mob/actions/baothamiracles.dmi'
	overlay_icon = 'modular_twilight_axis/icons/mob/actions/baothamiracles.dmi'
	overlay_state = "mirage"
	releasedrain = 10
	chargedrain = 0
	chargetime = 0
	chargedloop = /datum/looping_sound/invokeholy
	sound = 'sound/foley/gross.ogg'
	associated_skill = /datum/skill/magic/holy
	antimagic_allowed = FALSE
	invocation_type = "none"
	recharge_time = 0
	devotion_cost = 40
	miracle = TRUE
	var/used = FALSE

#define TRAIT_MIRAGE "Mirage"

/obj/effect/proc_holder/spell/self/mirage/cast(mob/living/carbon/human/user)
	var/skill_level = user.get_skill_level(associated_skill)
	devotion_cost = 40-(5*skill_level)
	playsound(get_turf(user), 'sound/magic/haste.ogg', 80, TRUE, soundping = TRUE)
	user.visible_message(span_love("[user]'s body begins shrouded in a corrosive purple haze that obscures his silhouette!"))
	var/mirage_type = list("Name", "Feature", "Nevermind")
	var/selection = input(user, "Rituals of Gedonism", src) as null|anything in mirage_type
	ADD_TRAIT(user, TRAIT_MIRAGE, TRAIT_MIRACLE)
	ADD_TRAIT(user, TRAIT_EDIT_DESCRIPTORS, TRAIT_MIRACLE)
	switch(selection) // put ur rite selection here
		if("Name")
			mirror_full_transform(user)
		if("Feature")
			perform_mirror_transform(user)
		if("Nevermind")
			revert_cast()
	REMOVE_TRAIT(user, TRAIT_MIRAGE, TRAIT_MIRACLE)
	REMOVE_TRAIT(user, TRAIT_EDIT_DESCRIPTORS, TRAIT_MIRACLE)
	return TRUE

/proc/mirror_full_transform(mob/living/carbon/user)
	if(!ishuman(user))
		return

	var/mob/living/carbon/human/H = user
	var/should_update = FALSE
	var/newname = copytext(sanitize_name(input(H, "Who are we again?", "Name change", H.name) as null|text),1,MAX_NAME_LEN)

	if(!newname)
		return
	H.real_name = newname
	H.name = newname
	if(H.dna)
		H.dna.real_name = newname
	if(H.mind)
		H.mind.name = newname
	if(should_update)
		H.update_body()

//T0 that tells the user the person's vice.
/obj/effect/proc_holder/spell/invoked/TAbaothavice
	name = "Show desires"
	desc = "Tells you the targets vice and arousal."
	action_icon = 'modular_twilight_axis/icons/mob/actions/baothamiracles.dmi'
	overlay_icon = 'modular_twilight_axis/icons/mob/actions/baothamiracles.dmi'
	overlay_state = "vice"
	releasedrain = 10
	chargedrain = 0
	chargetime = 0
	range = 3
	warnie = "sydwarning"
	movement_interrupt = FALSE
	invocation_type = "none"
	associated_skill = /datum/skill/magic/holy
	antimagic_allowed = TRUE
	recharge_time = 3 SECONDS 
	miracle = TRUE
	devotion_cost = 10
	var/list/fake_vices = list()

/obj/effect/proc_holder/spell/invoked/TAbaothavice/cast(list/targets, mob/living/user)
	if(!ishuman(targets?[1]))
		revert_cast()
		return FALSE

	var/mob/living/carbon/human/H = targets[1]
	var/vice_found

	if(HAS_TRAIT(H, TRAIT_DECEIVING_MEEKNESS) && user.get_skill_level(/datum/skill/magic/holy) <= SKILL_LEVEL_NOVICE)
		if(isnull(fake_vices[H]))
			fake_vices[H] = pick(GLOB.character_flaws)
		vice_found = fake_vices[H]

		if(prob(50 + ((H.STAPER - 10) * 10)))
			to_chat(H, span_warning("A pair of prying eyes were laid on me..."))

	if(!vice_found)
		if(H.charflaws)
			var/list/vices = list()
			for(var/datum/charflaw/cf in H.charflaws)
				vices.Add(cf.name)
			vice_found = english_list(vices)
		else
			to_chat(user, span_warning("Their heart is unreadable."))
			revert_cast()
			return FALSE

	to_chat(user, span_info("They are... [span_warning("a [vice_found]")]"))
	var/list/arousal_data = list()
	SEND_SIGNAL(H, COMSIG_SEX_GET_AROUSAL, arousal_data)
	var/arousal = arousal_data["arousal"]
	to_chat(user, span_info("Their arousal is [span_warning("[arousal]")]"))
	return TRUE

// T0: Bless drink
/obj/effect/proc_holder/spell/self/TAbless_drink
	name = "Bless Drink"
	desc = "Blesses a container to allow it to be drunk to no end. Lasts about a minute. Due to the potency of alchemical mixes and of thoroughly cooked beverages, does not function on them."
	action_icon = 'modular_twilight_axis/icons/mob/actions/baothamiracles.dmi'
	overlay_icon = 'modular_twilight_axis/icons/mob/actions/baothamiracles.dmi'
	overlay_state = "bless_drink"
	releasedrain = 10
	chargedrain = 0
	chargetime = 0
	range = 1
	warnie = "sydwarning"
	movement_interrupt = FALSE
	invocation_type = "none"
	associated_skill = /datum/skill/magic/holy
	antimagic_allowed = TRUE
	recharge_time = 1 MINUTES
	miracle = TRUE
	devotion_cost = 10
	var/duration = 60 SECONDS
	var/static/list/reagent_blacklist = list(
		/datum/reagent/rotcure,
		/datum/reagent/vitae,
		/datum/reagent/medicine/stampot,
		/datum/reagent/medicine/strongstam,
		/datum/reagent/medicine/strongmana,
		/datum/reagent/medicine/manapot,
		/datum/reagent/medicine/healthpot,
		/datum/reagent/medicine/stronghealth,
		/datum/reagent/buff/tri,
		/datum/reagent/buff/constitution,
		/datum/reagent/buff/fortune,
		/datum/reagent/buff/endurance,
		/datum/reagent/buff/strength,
		/datum/reagent/buff/speed,
		/datum/reagent/buff/perception,
		/datum/reagent/consumable/caffeine/,
		/datum/reagent/consumable/golden_calendula_tea,
		/datum/reagent/water/medicine,
	)

// Anything that heals has been restricted - caffeine for the stat buff, golden calendula tea is like a weaker red. This is solely for flavor purposes, effectively.
/obj/effect/proc_holder/spell/self/TAbless_drink/cast(list/targets, mob/living/user)
	if(!ishuman(user))
		revert_cast()
		return FALSE
	var/held = user.get_active_held_item()
	if(!istype(held, /obj/item/reagent_containers/glass))
		revert_cast()
		to_chat(user, span_info("This is not a suitable container for this!"))
		return FALSE
	
	var/obj/item/reagent_containers/glass/target_container = held
	for(var/reagent in reagent_blacklist)
		if(target_container.reagents.has_reagent(reagent))
			revert_cast()
			to_chat(user, span_info("The drink within is too potent."))
			return FALSE

	if(target_container.is_infinite)
		revert_cast()
		to_chat(user, span_info("This is already blessed!"))
		return FALSE

	var/dur = duration * user.get_skill_level(associated_skill)
	var/printed_dur = round(dur / 600)
	if(target_container.set_infinite(user, dur))
		user.playsound_local(get_turf(user), 'sound/magic/baotha_blessdrink.ogg', 100, TRUE)
		to_chat(user, span_notice("The drink swirls for a mote. This will last around [printed_dur] minute[(printed_dur > 1) ? "s" : ""]."))
	else
		revert_cast()
		return FALSE
	return TRUE

//Baotha's Blessings - T0, reverses overdose effect on a target + soothing moodlet. Useful to T0/Devotee because it allows them to stop an OD death, but puts them on the clock. (Medieval narcan..... #BanNarcan)

/obj/effect/proc_holder/spell/invoked/TAbaothablessings
	name = "Baotha's Blessings"
	desc = "Gets the target drunk and stops them from overdosing for a time."
	action_icon = 'modular_twilight_axis/icons/mob/actions/baothamiracles.dmi'
	overlay_icon = 'modular_twilight_axis/icons/mob/actions/baothamiracles.dmi'
	overlay_state = "blessing"
	releasedrain = 30
	chargedrain = 0
	chargetime = 0
	range = 4
	warnie = "sydwarning"
	movement_interrupt = FALSE
	sound = 'sound/magic/heal.ogg'
	invocation_type = "none"
	associated_skill = /datum/skill/magic/holy
	antimagic_allowed = TRUE
	recharge_time = 30 SECONDS
	miracle = TRUE
	devotion_cost = 10

/obj/effect/proc_holder/spell/invoked/TAbaothablessings/cast(list/targets, mob/living/user)
	if(isliving(targets[1]))
		var/mob/living/carbon/target = targets[1]
		if(HAS_TRAIT(target, TRAIT_PSYDONITE))
			target.visible_message(span_info("[target] stirs for a moment, the miracle dissipates."), span_notice("A dull warmth swells in your heart, only to fade as quickly as it arrived."))
			user.playsound_local(user, 'sound/magic/PSY.ogg', 100, FALSE, -1)
			playsound(target, 'sound/magic/PSY.ogg', 100, FALSE, -1)
			return FALSE
		if(target.has_status_effect(/datum/status_effect/buff/druqks/baotha))
			to_chat(user, span_warning("They're already blessed by these effects!"))
			revert_cast()
			return FALSE
		target.apply_status_effect(/datum/status_effect/buff/druqks/baotha) //Gets the trait temorarily, basically will just stop any active/upcoming ODs.	
		target.visible_message("<span class='info'>[target]'s eyes appear to gloss over!</span>", "<span class='notice'>I feel.. at ease.</span>")
	return TRUE

// T1, orison inspired healing spell that pours a drink called Lover's Ruin. Works like a red for baotha blessed, poisons non-blessed.
/obj/effect/proc_holder/spell/targeted/touch/TAloversruin
	name = "Lover's Ruin"
	desc = "A toast to passion that ends in ash.\n \
		Beseech Baotha to pour wine onto a container. Poisons the unfaithful, rewards Her blessed with healing."
	action_icon = 'modular_twilight_axis/icons/mob/actions/baothamiracles.dmi'
	overlay_icon = 'modular_twilight_axis/icons/mob/actions/baothamiracles.dmi'
	overlay_state = "ruin"
	chargedrain = 0
	chargetime = 0
	releasedrain = 5
	miracle = TRUE
	devotion_cost = 5
	chargedloop = /datum/looping_sound/invokegen
	associated_skill = /datum/skill/magic/holy
	hand_path = /obj/item/melee/touch_attack/TAloversruin
	recharge_time = 2 MINUTES

/obj/item/melee/touch_attack/TAloversruin
	name = "Baotha's Touch"
	catchphrase = null
	possible_item_intents = list(/datum/intent/fill)
	icon = 'icons/mob/roguehudgrabs.dmi'
	icon_state = "pulling"
	icon_state = "grabbing_greyscale"
	color = "#FFFFFF"
	var/right_click = FALSE

/obj/item/melee/touch_attack/TAloversruin/attack_self()
	qdel(src)

/obj/item/melee/touch_attack/TAloversruin/afterattack(atom/target, mob/living/carbon/human/user, proximity)
	if(istype(user.used_intent, /datum/intent/fill) && create_ichor(target, user))
		qdel(src)

/datum/reagent/medicine/TAloversruin
	name = "Lover's Ruin"
	description = "A sweet smelling concoction. It has small charred petals swimming on the surface."
	color = "#9c2745"
	taste_description = "sin"

/datum/reagent/medicine/TAloversruin/on_mob_life(mob/living/carbon/M)
	if(HAS_TRAIT(M, TRAIT_CRACKHEAD))
		if(volume >= 10)
			M.reagents.remove_reagent(/datum/reagent/medicine/TAloversruin, 2)
		if(M.blood_volume < BLOOD_VOLUME_NORMAL)
			M.blood_volume = min(M.blood_volume+5, BLOOD_VOLUME_NORMAL)
		var/list/wCount = M.get_wounds()
		if(wCount.len > 0)
			M.heal_wounds(2, list(/datum/wound/slash, /datum/wound/puncture, /datum/wound/bite, /datum/wound/bruise, /datum/wound/dynamic))
		if(volume > 0.99)
			M.adjustBruteLoss(-2  * REAGENTS_EFFECT_MULTIPLIER, 0)
			M.adjustFireLoss(-2  * REAGENTS_EFFECT_MULTIPLIER, 0)
			M.adjustOxyLoss(-2, 0)
			M.adjustToxLoss(-2, 0)
			M.adjustOrganLoss(ORGAN_SLOT_BRAIN, -5  * REAGENTS_EFFECT_MULTIPLIER)
			M.adjustCloneLoss(-4  * REAGENTS_EFFECT_MULTIPLIER, 0)
	else
		M.adjustToxLoss(3, 0)
		M.adjustOxyLoss(1, 0)
	..()

/obj/item/melee/touch_attack/TAloversruin/proc/create_ichor(atom/thing, mob/living/carbon/human/user)
	if(!thing.Adjacent(user))
		to_chat(user, span_info("I need to be closer to [thing] in order to try filling it with the concoction."))
		return

	if(thing.is_refillable())
		if(thing.reagents.holder_full())
			to_chat(user, span_warning("[thing] is full."))
			return
		
		user.visible_message(span_info("[user] extends a hand over [thing]. Sweet-smelling ichor drips from [user.p_their()] fingertips, like blood."), span_notice("I call forth [user.patron.name], to fill [thing] with Her blessings..."))

		var/holy_skill = user.get_skill_level(attached_spell.associated_skill)
		var/drip_speed = 56 - (holy_skill * 8)
		var/fatigue_spent = 0
		var/fatigue_used = max(3, holy_skill)
		while(do_after(user, drip_speed, target = thing))
			if(thing.reagents.holder_full() || (user.devotion.devotion - fatigue_used <= 0))
				break

			var/water_qty = max(1, holy_skill) + 1
			var/list/water_contents = list(/datum/reagent/medicine/loversruin = water_qty)
			var/datum/reagents/reagents_to_add = new()
			reagents_to_add.add_reagent_list(water_contents)
			reagents_to_add.trans_to(thing, reagents_to_add.total_volume, transfered_by = user, method = INGEST)

			fatigue_spent += fatigue_used
			user.stamina_add(fatigue_used)
			user.devotion?.update_devotion(-1.0)

			if(prob(80))
				playsound(user, 'sound/items/fillcup.ogg', 55, TRUE)
		
		return max(50, fatigue_spent)
	else
		to_chat(user, span_info("I'll need to find a container that can hold Her blessing."))

//T1, Baotha's version of Eora's Bud (now renamed True Peace Bloom). Applies the TRAIT_CRACKHEAD baothans have.
/obj/effect/proc_holder/spell/invoked/TAgriefflower
	name = "False Serenity Bloom"
	desc = "A gift for those whom you have choosen as worthy of Her grace, to be able to imbibe in Her gifts as you do."
	clothes_req = FALSE
	range = 7
	action_icon = 'modular_twilight_axis/icons/mob/actions/baothamiracles.dmi'
	overlay_icon = 'modular_twilight_axis/icons/mob/actions/baothamiracles.dmi'
	overlay_state = "bloom"
	sound = list('sound/magic/magnet.ogg')
	releasedrain = 40
	chargetime = 10
	warnie = "spellwarning"
	no_early_release = TRUE
	charging_slowdown = 1
	chargedloop = /datum/looping_sound/invokegen
	associated_skill = /datum/skill/magic/holy
	recharge_time = 30 MINUTES //To avoid spamming this shit and giving all heretics florida-man crackhead superpowers. No Bro.

/obj/effect/proc_holder/spell/invoked/TAgriefflower/cast(mob/living/user)
	var/turf/T = get_turf(user)
	if(!isclosedturf(T))
		new /obj/item/clothing/ring/TAgriefflower(T)
		return TRUE

	to_chat(user, span_warning("The targeted location is blocked. Her gift cannot be invoked."))
	revert_cast()
	return FALSE

/obj/item/clothing/ring/TAgriefflower
	name = "rosa ring"
	desc = "Once a flower of love, now touched by Baotha's hand. Its petals whisper of desire, despair, and the kind of longing that never dies. Worn by those who cannot let go."
	icon_state = "peaceflower"
	item_state = "peaceflower"
	icon = 'icons/roguetown/items/produce.dmi'
	mob_overlay_icon = 'icons/roguetown/clothing/onmob/head_items.dmi'

/obj/item/clothing/ring/TAgriefflower/equipped(mob/living/carbon/human/user, slot)
	. = ..()
	if(slot == SLOT_RING)
		user.apply_status_effect(/datum/status_effect/buff/griefflower)

/obj/item/clothing/ring/TAgriefflower/dropped(mob/living/carbon/human/user)
	. = ..()
	if(istype(user) && user?.wear_ring == src)
		user.remove_status_effect(/datum/status_effect/buff/griefflower)

// Insufflation - effectively just drugging yourself. Lets you pick, the same as Enrapturing Powder. T1, for now, to make up for the loss of the Baotha Blessing buff.

/obj/effect/proc_holder/spell/self/TAinsufflation 
	name = "Insufflation"
	desc = "Imbibes yourself on one of four drugs, in Her name. Your intent will determine the drug ingested. \n\
	\
	Feint intent will dose you on Spice, giving you +5 INT, +3 SPD, and -5 FOR. \n\
	\
	Aimed intent will dose you on Moondust, giving you +3 SPD, +3 WILL, and -2 INT. \n\
	\
	Strong intent will dose you on Herozium, giving you -5 SPD, +4 WILL, -3 INT, +3 CON, pain immunity, and resistance to damage slowdown. \n\
	\
	Swift intent will dose you on Starsugar, giving you +4 SPD, +4 WILL -3 INT, -3 CON, darkvision, and dodge expert."
	action_icon = 'modular_twilight_axis/icons/mob/actions/baothamiracles.dmi'
	overlay_icon = 'modular_twilight_axis/icons/mob/actions/baothamiracles.dmi'
	overlay_state = "powder"
	clothes_req = FALSE
	associated_skill = /datum/skill/magic/holy
	chargedloop = /datum/looping_sound/invokeholy
	releasedrain = 10
	chargedrain = 0
	chargetime = 15
	recharge_time = 10 SECONDS
	invocation_type = "emote"
	invocations = list("flicks their wrist, filling the air in front of them with a fine powder.")
	antimagic_allowed = TRUE
	miracle = TRUE
	devotion_cost = 30

/obj/effect/proc_holder/spell/self/TAinsufflation/cast(list/targets, mob/user)
	if(!ishuman(user))
		revert_cast()
		return FALSE
	switch(user.rmb_intent.name)
		if("feint")
			user.reagents.add_reagent(/datum/reagent/druqks, 4)
			return TRUE
		if("aimed")
			user.reagents.add_reagent(/datum/reagent/moondust_purest, 8)
			return TRUE
		if("strong")
			user.reagents.add_reagent(/datum/reagent/herozium, 8)
			return TRUE
		if("swift")
			user.reagents.add_reagent(/datum/reagent/starsugar, 8)
			return TRUE
		else
			user.reagents.add_reagent(/datum/reagent/herozium, 8)
			return TRUE

//Enrapturing Powder - T2, basically a crackhead blowing cocaine in your face.

/obj/effect/proc_holder/spell/invoked/projectile/TAblowingdust
	name = "Enrapturing Powder"
	desc = "Blows dust of a potent painkilling drug at the target."
	action_icon = 'modular_twilight_axis/icons/mob/actions/baothamiracles.dmi'
	overlay_icon = 'modular_twilight_axis/icons/mob/actions/baothamiracles.dmi'
	overlay_state = "powder"
	clothes_req = FALSE
	range = 3	//POCKET OPIUM!
	associated_skill = /datum/skill/magic/holy
	projectile_type = /obj/projectile/magic/TAblowingdust
	chargedloop = /datum/looping_sound/invokeholy
	releasedrain = 30
	chargedrain = 0
	chargetime = 15
	recharge_time = 10 SECONDS
	invocation_type = "emote"
	invocations = list("flicks their wrist, filling the air in front of them with a fine powder.")
	devotion_cost = 30

/obj/projectile/magic/TAblowingdust
	name = "unholy dust"
	icon_state = "spark"
	nodamage = FALSE
	damage = 1
	poisontype = /datum/reagent/herozium
	poisonfeel = "burning" //Would make sense for your eyes or nose to burn, I guess.
	poisonamount = 8 //Decent bit of high, three doses would be just above the overdose threshold if applied fast enough.

/obj/projectile/magic/TAblowingdust/on_hit(target, mob/living/M)
	. = ..()
	if(!istype(M))
		return
	if(target)
		to_chat(target, span_warning("Gah! Something.. got in my - eyes.."))
		M.blur_eyes(2)

// T2 - clears all stress. Forget your worries, pookie bear.
/obj/effect/proc_holder/spell/invoked/TAlasthigh
	name = "Last High"
	desc = "Pleasure's perfume, just before the fall."
	action_icon = 'modular_twilight_axis/icons/mob/actions/baothamiracles.dmi'
	overlay_icon = 'modular_twilight_axis/icons/mob/actions/baothamiracles.dmi'
	overlay_state = "last_high"
	releasedrain = 30
	chargedrain = 0
	chargetime = 0
	range = 7
	warnie = "sydwarning"
	sound = 'sound/magic/timestop.ogg'
	invocations = list("completely clouds the air around them in a purple smog!")	//useful against any men in the mirror
	invocation_type = "emote"
	associated_skill = /datum/skill/magic/holy
	antimagic_allowed = TRUE
	recharge_time = 5 MINUTES
	miracle = TRUE
	devotion_cost = 75

/obj/effect/proc_holder/spell/invoked/TAlasthigh/cast(list/targets, mob/living/user)
	if(isliving(targets[1]))
		var/mob/living/target = targets[1]
		if(target.mob_biotypes & MOB_UNDEAD)
			return FALSE

		target.visible_message(
			span_info("[target] is forced to deeply inhale a sweet smelling mist. They twist and choke as spittle runs down the corner of their mouth, yet an eerie calm passes over them."), 
			span_notice("The world fades around me. My throat melts, my stomach churns, and the pounding in my chest feels relentless. I can barely move, but it doesn't matter. Oblivion melts into love in front of my glossed-over eyes.")
		)
		target.adjustToxLoss(3)
		target.add_stress(/datum/stressevent/TAlasthigh)
		return TRUE

/datum/stressevent/TAlasthigh
	timer = 10 MINUTES
	stressadd = -99
	desc = span_hypnophrase("The world fades around me. My throat melts, my stomach churns, and the pounding in my chest feels relentless. I can barely move, but it doesn't matter. Oblivion melts into love in front of my glossed-over eyes.") 


// T3 - bond that lasts for 8 minutes as long as bonded are within 7 tiles, TRAIT_NOPAIN, spd = 5 end = 3
/obj/effect/proc_holder/spell/invoked/TAjoyride
	name = "Joyride"
	desc = "A frenzy for two to partake in."
	action_icon = 'modular_twilight_axis/icons/mob/actions/baothamiracles.dmi'
	overlay_icon = 'modular_twilight_axis/icons/mob/actions/baothamiracles.dmi'
	overlay_state = "joyride"
	range = 2
	chargetime = 0.5 SECONDS
	invocation_type = "emote"
	invocations = list("exhales. A deep-purple mist dances through the air...")		//apparently you can't get targets in the invocation
	sound = 'sound/magic/magnet.ogg'
	recharge_time = 60 SECONDS
	miracle = TRUE
	devotion_cost = 75
	associated_skill = /datum/skill/magic/holy

/obj/effect/proc_holder/spell/invoked/TAjoyride/cast(list/targets, mob/living/user)
	var/mob/living/target = targets[1]

	var/datum/component/baotha_joyride/existing = user.GetComponent(/datum/component/baotha_joyride)
	if(existing)
		to_chat(user, span_warning("Your fates are already intertwined!"))
		revert_cast()
		return FALSE

	if(!istype(target, /mob/living/carbon) || target == user)
		revert_cast()
		return FALSE

	if(!do_after(user, 3 SECONDS, target = target))
		to_chat(user, span_warning("There is no joy without concentration!"))
		revert_cast()
		return FALSE

	var/holy_skill = user.get_skill_level(associated_skill)
	user.AddComponent(/datum/component/baotha_joyride, target, user, holy_skill)
	target.AddComponent(/datum/component/baotha_joyride/partner, target, user, holy_skill)

	user.visible_message(
		span_notice("[user] and [target] inhale a magenta mist. A strange aching feeling pounds in your chest."),			//baotha, goddess of combat-cuckolding
	)
	return TRUE

//Numbing Pleasure - T3, halves pain from target for a period of time. (Similar to Ravox's without any blood-clotting and better pain suppression + good mood buff.)
/obj/effect/proc_holder/spell/invoked/TApainkiller
	name = "Numbing Pleasure"
	desc = "Numbs the targets pain and improves their mood."
	action_icon = 'modular_twilight_axis/icons/mob/actions/baothamiracles.dmi'
	overlay_icon = 'modular_twilight_axis/icons/mob/actions/baothamiracles.dmi'
	overlay_state = "pleasure"
	releasedrain = 30
	chargedrain = 0
	chargetime = 0
	range = 7
	warnie = "sydwarning"
	sound = 'sound/magic/timestop.ogg'
	invocation_type = "none"
	associated_skill = /datum/skill/magic/holy
	antimagic_allowed = TRUE
	recharge_time = 90 SECONDS
	miracle = TRUE
	devotion_cost = 75

/obj/effect/proc_holder/spell/invoked/TApainkiller/cast(list/targets, mob/living/user)
	if(isliving(targets[1]))
		var/mob/living/target = targets[1]
		var/mob/living/carbon/human/human_target = target
		var/datum/physiology/phy = human_target.physiology
		if(target.mob_biotypes & MOB_UNDEAD)
			return FALSE	//No, you don't get to feel good. You're a undead mob. Feel bad.
		target.visible_message(span_info("[target] twitches and shivers as a strange warmth radiates from them!"), span_notice("The pain from my wounds melts into sweet suffering. This feels... right."))
		phy.pain_mod *= 0.5	//Literally halves your pain modifier.
		addtimer(CALLBACK(src, PROC_REF(restore_pain_mod), phy), 1 MINUTES)
		target.apply_status_effect(/datum/status_effect/buff/vitae)					//+2 Fortune and mood buff
		return TRUE

/obj/effect/proc_holder/spell/invoked/TApainkiller/proc/restore_pain_mod(datum/physiology/physiology)
	if(!physiology)
		return

	physiology.pain_mod /= 0.5
