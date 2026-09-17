/datum/virtue/utility/riding
	name = "Saddleborn"
	desc = "I am skilled at riding animals of all kinds, and have an especially strong bond with one, allowing me to call it from afar and send it away as needed. Should my treasured companion ever die, my mood will not recover."
	ui_fa_icon = "horse"
	custom_text = "Provides an ability that allows you to select a type of mount to call to your side, and additionally name. Noble characters are able to choose horses. Gains two abilities to send the mount away and call it back as needed (outdoors only). If the chosen mount dies, -10 to mood for the rest of the round (cannot be recovered from in any circumstance)."
	added_skills = list(list(/datum/skill/misc/riding, 1, SKILL_LEVEL_EXPERT))
	added_traits = list(TRAIT_EQUESTRIAN)

/datum/virtue/utility/riding/apply_to_human(mob/living/carbon/human/recipient)
	// neatly handles everything, when we want it, when we need it.
	if(!recipient.HasSpell(/obj/effect/proc_holder/spell/self/choose_riding_virtue_mount))
		recipient.AddSpell(new /obj/effect/proc_holder/spell/self/choose_riding_virtue_mount)

GLOBAL_LIST_INIT(virtue_mount_choices, (list(
	/mob/living/simple_animal/hostile/retaliate/rogue/saiga/tame/saddled,
	/mob/living/simple_animal/hostile/retaliate/rogue/saiga/saigabuck/tame/saddled,
	/mob/living/simple_animal/hostile/retaliate/rogue/swine/hog/tame/saddled,
	/mob/living/simple_animal/hostile/retaliate/rogue/goatmale/tame/saddled,
	/mob/living/simple_animal/hostile/retaliate/rogue/goat/tame,
)))

GLOBAL_LIST_INIT(virtue_mount_choices_noble, (list(
	list("fogbeast mare", /mob/living/simple_animal/hostile/retaliate/rogue/fogbeast/tame/saddled),
	list("fogbeast stallion", /mob/living/simple_animal/hostile/retaliate/rogue/fogbeast/male/tame/saddled),
)))

GLOBAL_LIST_INIT(virtue_mount_choices_anthrax, (list(
	list("drider spider", /mob/living/simple_animal/hostile/retaliate/rogue/drider/tame/saddled),
)))

/datum/stressevent/precious_mob_died
	timer = 60 MINUTES //TA EDIT
	stressadd = 10
	desc = span_red("There will never be another creature like them. They are lost, and so am I.")

/datum/component/precious_creature
	// Who does this creature belong to?
	var/datum/weakref/owner

/datum/component/precious_creature/Initialize(mob/living/the_owner)
	if (!the_owner || !isliving(the_owner))
		return COMPONENT_INCOMPATIBLE

	owner = WEAKREF(the_owner)
	RegisterSignal(parent, COMSIG_MOB_DEATH, PROC_REF(precious_died))

/datum/component/precious_creature/proc/precious_died()
	var/mob/living/our_owner = owner.resolve()
	if(!our_owner || QDELETED(our_owner))
		return
	if(ishuman(our_owner)) // TA EDIT START
		var/mob/living/carbon/human/human_owner = our_owner
		if(!human_owner.saddleborn_mount || human_owner.saddleborn_mount.resolve() != parent)
			return // TA EDIT END
	to_chat(our_owner, span_boldwarning("A quavering pang of loneliness streaks through your chest like cold lightning, sinking to the pit of your stomach. THEY ARE GONE!"))
	our_owner.add_stress(/datum/stressevent/precious_mob_died)

/mob/living/carbon/human
	/// Weakref to our bespoke Saddleborn mount (added by the virtue)
	var/datum/weakref/saddleborn_mount
	var/saddleborn_mount_targeting = FALSE // TA EDIT
	var/saddleborn_mount_change_in_progress = FALSE // TA EDIT

/obj/effect/proc_holder/spell/self/choose_riding_virtue_mount
	name = "Choose Mount"
	desc = "Recall the form of your treasured Saddleborn mount."
	school = "transmutation"
	overlay_state = "book1"
	chargedrain = 0
	chargetime = 0

/mob/living/carbon/human/proc/get_saddleborn_mount_choices(show_special_messages = FALSE) // TA EDIT START
	var/list/choices = list()
	var/list/mount_choices = GLOB.virtue_mount_choices.Copy()

	if(HAS_TRAIT(src, TRAIT_NOBLE) || job == "Man at Arms")
		if(show_special_messages)
			to_chat(src, span_info("As an anointed noble, your steed can also come from pedigree stock."))
		mount_choices += GLOB.virtue_mount_choices_noble
	if(HAS_TRAIT(src, TRAIT_ANTHRAXI))
		if(show_special_messages)
			to_chat(src, span_info("As a Drow, you are skilled in handling giant spiders of the Underdark."))
		mount_choices += GLOB.virtue_mount_choices_anthrax

	for(var/i = 1, i <= mount_choices.len, i++)
		var/mob/living/simple_animal/honse
		if(islist(mount_choices[i]))
			honse = mount_choices[i][2]
			choices[mount_choices[i][1]] = honse
		else
			honse = mount_choices[i]
			choices["[honse.name]"] = honse

	return sortList(choices)

/mob/living/carbon/human/proc/create_saddleborn_mount(mount_type)
	if(!mount_type)
		return null

	var/mob/living/simple_animal/the_real_honse
	if(ispath(mount_type, /mob/living/simple_animal/hostile/retaliate/rogue/fogbeast))
		var/fogbeast_color_choice = input(src, "What color is your trusty steed?") as null|anything in GLOB.valid_fogbeast_colors
		the_real_honse = new mount_type(loc, fogbeast_color_choice)
	else
		the_real_honse = new mount_type(loc)
	if(!the_real_honse)
		return null

	the_real_honse.AddComponent(/datum/component/precious_creature, src)
	saddleborn_mount = WEAKREF(the_real_honse)
	the_real_honse.assign_livestock_owner(src)

	var/has_name = alert(src, "Have you named your noble steed?", "Saddleborn", "Yes", "No")
	if(!has_name)
		has_name = "No"
	if(has_name == "Yes")
		var/honse_name = sanitize(input(src, "What is your steed's name?", "Saddleborn"))
		if(honse_name)
			the_real_honse.name = honse_name
			the_real_honse.real_name = honse_name

	if(istype(the_real_honse, /mob/living/simple_animal/hostile/retaliate/rogue/saiga))
		var/saiga_barding = list("None","Padded Barding","Chainmail Barding")
		var/saiga_barding_choice = input(src, "What protection have you acquired for your steed?", "Saddleborn") as anything in saiga_barding
		switch(saiga_barding_choice)
			if("Padded Barding")
				the_real_honse.bbarding = new /obj/item/clothing/barding()
				the_real_honse.update_icon()
			if("Chainmail Barding")
				the_real_honse.bbarding = new /obj/item/clothing/barding/chain()
				the_real_honse.update_icon()
	else if(istype(the_real_honse, /mob/living/simple_animal/hostile/retaliate/rogue/fogbeast))
		var/fogbeast_barding = list("None","Padded Barding","Chainmail Barding")
		var/fogbeast_barding_choice = input(src, "What protection have you acquired for your steed?", "Saddleborn") as anything in fogbeast_barding
		switch(fogbeast_barding_choice)
			if("Padded Barding")
				the_real_honse.bbarding = new /obj/item/clothing/barding/fogbeast()
				the_real_honse.update_icon()
			if("Chainmail Barding")
				the_real_honse.bbarding = new /obj/item/clothing/barding/fogbeast/chain()
				the_real_honse.update_icon()

	visible_message(span_info("[src] whistles sharply, and [the_real_honse] pads up from afar to their side."), span_notice("With a trusty whistle, my treasured steed returns to my side."))
	playsound(src, 'sound/magic/saddleborn-call.ogg', 150, FALSE, 5)
	if(!buckled)
		the_real_honse.buckle_mob(src, TRUE)
		if(istype(the_real_honse, /mob/living/simple_animal/hostile/retaliate/rogue/drider/tame/saddled))
			playsound(the_real_honse, 'sound/vo/mobs/spider/speak (3).ogg', 100, FALSE, 2)
		else
			playsound(the_real_honse, 'sound/magic/saddleborn-summoned.ogg', 100, FALSE, 2)

	return the_real_honse

/mob/living/carbon/human/proc/change_saddleborn_mount()
	set name = "Change Mount"
	set category = "RoleUnique.Virtue"

	if(!HasSpell(/obj/effect/proc_holder/spell/self/saddleborn/whistle))
		remove_verb(src, /mob/living/carbon/human/proc/change_saddleborn_mount)
		cancel_saddleborn_mount_targeting()
		return FALSE
	if(saddleborn_mount_change_in_progress)
		to_chat(src, span_warning("You are already trying to bond with a new mount."))
		return FALSE
	if(saddleborn_mount_targeting)
		cancel_saddleborn_mount_targeting()
		to_chat(src, span_notice("You stop looking for a new treasured mount."))
		return TRUE

	saddleborn_mount_targeting = TRUE
	RegisterSignal(src, COMSIG_MOB_CLICKON, PROC_REF(on_saddleborn_mount_target_click))
	client?.mouse_pointer_icon = 'modular_twilight_axis/icons/hud/animal_command_cursor.dmi'
	update_mouse_pointer()
	to_chat(src, span_notice("Click a tamed rideable animal to make it your new treasured mount. Use Change Mount again to cancel."))
	return TRUE

/mob/living/carbon/human/proc/cancel_saddleborn_mount_targeting()
	if(!saddleborn_mount_targeting)
		return
	saddleborn_mount_targeting = FALSE
	UnregisterSignal(src, COMSIG_MOB_CLICKON)
	update_mouse_pointer()

/mob/living/carbon/human/proc/on_saddleborn_mount_target_click(mob/living/source, atom/target, params)
	SIGNAL_HANDLER
	if(source != src || !saddleborn_mount_targeting)
		return
	var/list/modifiers = islist(params) ? params : params2list(params)
	if(!modifiers["left"] || modifiers["right"] || modifiers["middle"])
		return
	cancel_saddleborn_mount_targeting()
	INVOKE_ASYNC(src, PROC_REF(try_change_saddleborn_mount), target)
	return COMSIG_MOB_CANCEL_CLICKON

/mob/living/carbon/human/proc/can_use_as_saddleborn_mount(mob/living/simple_animal/candidate, show_message = FALSE)
	if(!istype(candidate) || QDELETED(candidate) || !candidate.loc || candidate.stat == DEAD)
		if(show_message)
			to_chat(src, span_warning("That is not a living animal you can bond with."))
		return FALSE
	if(candidate == saddleborn_mount?.resolve())
		if(show_message)
			to_chat(src, span_warning("[candidate] is already your treasured mount."))
		return FALSE
	if(!candidate.can_saddle || !candidate.can_buckle)
		if(show_message)
			to_chat(src, span_warning("[candidate] is not a rideable mount."))
		return FALSE
	if(!candidate.tame)
		if(show_message)
			to_chat(src, span_warning("[candidate] must be tamed before you can form this bond."))
		return FALSE
	if(candidate.client)
		if(show_message)
			to_chat(src, span_warning("You cannot replace your mount with a creature currently controlled by another player."))
		return FALSE
	if(candidate.has_buckled_mobs())
		if(show_message)
			to_chat(src, span_warning("[candidate] must have no riders before you can form this bond."))
		return FALSE
	if(!Adjacent(candidate))
		if(show_message)
			to_chat(src, span_warning("You need to stand next to [candidate] to form this bond."))
		return FALSE

	var/datum/component/precious_creature/existing_bond = candidate.GetComponent(/datum/component/precious_creature)
	var/mob/living/existing_owner = existing_bond?.owner?.resolve()
	if(ishuman(existing_owner) && existing_owner != src)
		var/mob/living/carbon/human/existing_human_owner = existing_owner
		if(existing_human_owner.saddleborn_mount?.resolve() == candidate)
			if(show_message)
				to_chat(src, span_warning("[candidate] is already another person's treasured mount."))
			return FALSE
	return TRUE

/datum/tgui_alert/saddleborn_mount_change/ui_interact(mob/user, datum/tgui/ui) // TA EDIT START
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "AlertModal", title, 420, 220)
		ui.open() // TA EDIT END

/mob/living/carbon/human/proc/try_change_saddleborn_mount(atom/target)
	if(saddleborn_mount_change_in_progress || !HasSpell(/obj/effect/proc_holder/spell/self/saddleborn/whistle))
		return FALSE
	var/mob/living/simple_animal/new_mount = target
	if(!can_use_as_saddleborn_mount(new_mount, TRUE))
		return FALSE

	var/mob/living/simple_animal/old_mount = saddleborn_mount?.resolve()
	var/warning
	if(old_mount && !QDELETED(old_mount))
		if(isnull(old_mount.loc))
			warning = "Replace your bond with [old_mount] and make [new_mount] your treasured mount? Your current mount is sent away. If the 15-second bonding process completes, [old_mount] will disappear forever."
		else
			warning = "Replace your bond with [old_mount] and make [new_mount] your treasured mount? [old_mount] will remain in the world, but can no longer be recalled with Mount: Whistle."
	else
		warning = "Make [new_mount] your treasured mount?"
	warning += " You must remain beside [new_mount] for 15 seconds; moving will cancel the process."

	var/datum/tgui_alert/saddleborn_mount_change/confirmation_alert = new(src, warning, "Change Mount", list("Begin Bonding", "Cancel")) // TA EDIT START
	confirmation_alert.ui_interact(src)
	confirmation_alert.wait()
	var/confirmation = confirmation_alert?.choice
	if(confirmation_alert)
		qdel(confirmation_alert) // TA EDIT END
	if(confirmation != "Begin Bonding" || !can_use_as_saddleborn_mount(new_mount, TRUE))
		return FALSE

	saddleborn_mount_change_in_progress = TRUE
	visible_message(span_notice("[src] begins patiently bonding with [new_mount]."), span_notice("I begin forming a new bond with [new_mount]..."))
	var/bond_complete = do_after(src, 15 SECONDS, target = new_mount)
	saddleborn_mount_change_in_progress = FALSE
	if(!bond_complete)
		to_chat(src, span_warning("The bonding process is interrupted."))
		return FALSE
	if(!can_use_as_saddleborn_mount(new_mount, TRUE))
		return FALSE

	old_mount = saddleborn_mount?.resolve()
	var/old_mount_was_away = old_mount && !QDELETED(old_mount) && isnull(old_mount.loc)
	saddleborn_mount = WEAKREF(new_mount)
	var/datum/component/precious_creature/new_bond = new_mount.GetComponent(/datum/component/precious_creature)
	if(new_bond)
		new_bond.owner = WEAKREF(src)
	else
		new_mount.AddComponent(/datum/component/precious_creature, src)
	new_mount.assign_livestock_owner(src)

	var/new_mount_name = tgui_input_text(src, "What would you like to name your new treasured mount?", "Rename Mount", new_mount.name, MAX_NAME_LEN)
	if(new_mount_name)
		new_mount_name = sanitize(new_mount_name)
		if(new_mount_name)
			new_mount.name = new_mount_name
			new_mount.real_name = new_mount_name

	if(old_mount_was_away && old_mount && !QDELETED(old_mount))
		qdel(old_mount)
	visible_message(span_notice("[new_mount] accepts [src] as its new treasured rider."), span_notice("My bond with [new_mount] settles into place."))
	return TRUE

/obj/effect/proc_holder/spell/self/choose_riding_virtue_mount/cast(list/targets, mob/living/carbon/human/user = usr)
	. = ..()
	var/area/place = get_area(user.loc)
	if(!place || !place.outdoors)
		to_chat(user, span_warning("You need to be outside! How do you expect your trusty steed to hear you?"))
		return

	var/list/choices = user.get_saddleborn_mount_choices(TRUE)
	var/choice = input(user, "What form does your treasured steed take?") as null|anything in choices
	var/mount_type = choices[choice]
	if(!mount_type)
		return

	var/mob/living/simple_animal/the_real_honse = user.create_saddleborn_mount(mount_type)
	if(!the_real_honse)
		return

	user.AddSpell(new /obj/effect/proc_holder/spell/self/saddleborn/sendaway)
	user.AddSpell(new /obj/effect/proc_holder/spell/self/saddleborn/whistle)
	add_verb(user, /mob/living/carbon/human/proc/change_saddleborn_mount)
	QDEL_IN(src, 0) // TA EDIT END

// dirty subtype for saddleborn spells that handles checking if we can actually do fucking anything at all
/obj/effect/proc_holder/spell/self/saddleborn/proc/check_mount(mob/living/carbon/human/user)
	if (!ishuman(user))
		return FALSE

	if (!user.saddleborn_mount)
		to_chat(user, span_warning("You have no treasured mount to send away..."))
		QDEL_IN(src, 0)
		return FALSE

	var/mob/living/simple_animal/honse = user.saddleborn_mount.resolve()
	if (!honse || honse.stat == DEAD)
		to_chat(user, span_warning("Necra has them now..."))
		return FALSE

	if (honse && honse.has_buckled_mobs())
		to_chat(user, span_warning("Your mount needs to have nobody riding on it first!"))
		return FALSE

	var/area/place = get_area(user.loc)
	if (!place || !place.outdoors)
		to_chat(user, span_warning("You need to be outside!"))
		revert_cast()
		return FALSE

	return TRUE

/obj/effect/proc_holder/spell/self/saddleborn/cast(list/targets, mob/user)
	. = ..()
	if (!check_mount(user))
		return FALSE
	else
		return TRUE

/datum/status_effect/buff/healing/saddleborn
	healing_on_tick = 0.25
	duration = 5 MINUTES
	examine_text = "SUBJECTPRONOUN looks well-rested!"
	outline_colour = "#f5c2c2"

/obj/effect/proc_holder/spell/self/saddleborn/sendaway
	name = "Mount: Send Away"
	desc = "While outside, send your beloved steed away to fend for itself for a time. May take longer in more hostile climates."
	school = "transmutation"
	recharge_time = 1 MINUTES
	chargedrain = 0
	chargetime = 0
	range = 1
	ignore_los = 1 // honse is adjacent, not a range check

/obj/effect/proc_holder/spell/self/saddleborn/sendaway/cast(list/targets, mob/living/carbon/human/user)
	. = ..()
	if (!.)
		revert_cast()
		return FALSE

	var/mob/living/simple_animal/honse = user.saddleborn_mount.resolve()
	if (!user.Adjacent(honse))
		to_chat(user, span_warning("You need to be next to your steed to send them away!"))
		revert_cast()
		return FALSE

	// otherwise, start a do_after then stasis the horse and hurl it into nullspace.
	// if they do it from town or centcom, give the horse a healing effect

	var/area/rogue/place = get_area(user.loc)
	var/should_heal = (is_centcom_level(user.loc.z) || place.town_area || place.keep_area)
	user.visible_message(span_info("[user] starts fussing with [honse], preparing to send them away..."), span_notice("I start preparing to send [honse] away to roam freely and safely for a time..."))
	honse.Immobilize(11 SECONDS)
	honse.unbuckle_all_mobs(TRUE)
	if (do_mob(user, honse, 7 SECONDS, double_progress = TRUE) && check_mount(user))
		honse.unbuckle_all_mobs(TRUE)
		if (!honse.has_buckled_mobs()) // just really super make sure we can't nullspace riders with this
			honse.moveToNullspace() // BANISHED TO THE NULL DIMENSION!! hopefully this doesn't cause problems
		else
			honse.visible_message(span_warning("[honse] pads the floor irritably, looking over its shoulder at the rider on its back."))
			return FALSE
		// add sfx foley for this
		user.visible_message(span_notice("Patting [honse] on the haunches, [user] sends them trotting away."), span_notice("With a brief pat on the haunches, I send [honse] away to fend for themselves."))
		if (should_heal)
			honse.apply_status_effect(/datum/status_effect/buff/healing/saddleborn)
			to_chat(user, span_info("In these surroundings, they should be able to rest and recouperate a little."))
		return TRUE
	else
		honse.SetImmobilized(0)
		revert_cast()
		return FALSE

/obj/effect/proc_holder/spell/self/saddleborn/whistle
	name = "Mount: Whistle"
	desc = "Call for your trusty seed, summoning it back to your side after a delay. Only works outdoors. May take longer in more hostile climates."
	school = "transmutation"
	recharge_time = 1 MINUTES
	chargedrain = 0
	chargetime = 0

/obj/effect/proc_holder/spell/self/saddleborn/whistle/cast(list/targets, mob/living/carbon/human/user)
	. = ..()
	if (!.)
		revert_cast()
		return FALSE

	var/mob/living/simple_animal/honse = user.saddleborn_mount.resolve()
	var/back_from_the_void = (honse.loc == null)
	var/callback_time = back_from_the_void ? 10 SECONDS : 5 SECONDS // nullspace returns take a lot longer to incentivize leaving it in the world
	var/dangerous_summon = FALSE // will we try to proc an ambush upon return?

	if (get_dist(honse.loc, user.loc) <= world.view)
		to_chat(user, span_warning("Your trusty steed is nearby!"))
		revert_cast()
		return

	var/area/rogue/place = get_area(user.loc)
	// apply alterations to our summon time based on our location: remember, this only works outdoors!
	if (place.threat_region == THREAT_REGION_MOUNT_DECAP)
		callback_time += 10 SECONDS
		dangerous_summon = TRUE
		to_chat(user, span_warning("Mount Decapitation is a dangerous place for a mount to navigate alone..."))
	if (place.warden_area)
		callback_time += 5 SECONDS
		to_chat(user, span_warning("The murderwoods are a dangerous place for a mount to navigate alone..."))
		dangerous_summon = TRUE
	if (place.drow_area)
		callback_time += 30 SECONDS
		to_chat(user, span_warning("The underdark is a <b>VERY</b> dangerous place for a mount to navigate alone..."))
		dangerous_summon = TRUE
	if (place.keep_area)
		if (HAS_TRAIT(user, TRAIT_NOBLE))
			to_chat(user, span_info("A passing servant helps fetch your mount for you!"))
			callback_time = 3 SECONDS
		else
			callback_time -= 3 SECONDS
			to_chat(user, span_info("Your mount is trained to linger around town, and the gatekeepers are used to letting lone mounts in these days, helping you fetch it quicker."))
	if (place.town_area)
		callback_time -= 5 SECONDS
		to_chat(user, span_info("Your mount is trained to linger around town, helping you fetch it quicker."))
	if (callback_time <= 0)
		callback_time = 1 SECONDS

	playsound(user, 'sound/magic/saddleborn-call.ogg', 150, FALSE, 5)
	user.visible_message(span_danger("[user] places their fingers into their mouth and blows a sharp, shrill whistle!"), span_info("I whistle for my trusty steed, and await their return!"))
	var/honse_base_loc = honse.loc
	var/area/rogue/honse_place = get_area(honse.loc)
	honse.unbuckle_all_mobs(TRUE)
	if (!back_from_the_void && honse_place.outdoors)
		honse.visible_message(span_notice("[honse] perks its ears up in response to a distant whistle, and darts off..."))
		playsound(honse, 'sound/magic/saddleborn-call.ogg', 50, FALSE) // distant spooky whistle OooOOOo
		honse.moveToNullspace() //temporarily shuffle it off into the null dimension, to reflect it running to the player

	if (do_after(user, callback_time))
		if (!back_from_the_void && honse_place && !honse_place.outdoors)
			to_chat(user, span_warning("...but nothing comes. They musn't have heard your whistling."))
			return TRUE

		honse.forceMove(user.loc)
		if (!user.buckled)
			honse.buckle_mob(user, TRUE)
		if(istype(honse, /mob/living/simple_animal/hostile/retaliate/rogue/drider/tame/saddled))
			playsound(honse, 'sound/vo/mobs/spider/speak (3).ogg', 100, FALSE, 2)
		else
			playsound(honse, 'sound/magic/saddleborn-summoned.ogg', 100, FALSE, 2)

		if (dangerous_summon) // the horse dragged some attention uh-oh
			if (!user.goodluck(10)) // every point of fortune above 10 gives us a 10% chance to not summon
				user.consider_ambush(ignore_cooldown = TRUE)
		return TRUE
	else
		honse.forceMove(honse_base_loc) // put the honse back, and give some info as to what just happened for onlookers
		honse.visible_message(span_notice("[honse] trundles back into sight with a confused expression, ears swivelling to catch some manner of sound..."))
		revert_cast()
		return FALSE
