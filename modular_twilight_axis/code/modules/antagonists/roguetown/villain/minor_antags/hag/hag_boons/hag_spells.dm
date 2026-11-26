// Spells
/datum/hag_boon/spell/rat_form
	name = "Boon of rat form"
	desc = "Allows bearer to transform into a small, smart rat..."
	spell_type = /obj/effect/proc_holder/spell/self/wildshape/hag_rat_form
	points = 30

/obj/effect/proc_holder/spell/self/wildshape/hag_rat_form
	name = "Rat Form"
	desc = "Turns yourself into a small rat!"
	invocation_type = "none"
	recharge_time = 10 SECONDS
	miracle = FALSE
	devotion_cost = 0
	clothes_req = FALSE
	human_req = FALSE
	ignore_cockblock = TRUE

	possible_shapes = list(
		/mob/living/carbon/human/species/wildshape/rat
	)
	disallowed_equipment_type = list(/obj/item/rogueweapon)

/datum/hag_boon/spell/troll_form
	name = "Boon of troll form"
	desc = "Allows bearer to transform into a big, slow troll..."
	spell_type = /obj/effect/proc_holder/spell/self/wildshape/hag_troll_form
	points = 85

/obj/effect/proc_holder/spell/self/wildshape/hag_troll_form
	name = "Troll Form"
	desc = "Turns yourself into a big, slow troll!"
	invocation_type = "none"
	recharge_time = 10 SECONDS
	miracle = FALSE
	devotion_cost = 0
	clothes_req = FALSE
	human_req = FALSE
	ignore_cockblock = TRUE

	possible_shapes = list(
		/mob/living/carbon/human/species/wildshape/troll
	)
	disallowed_equipment_type = list(/obj/item/rogueweapon)

/obj/effect/proc_holder/spell/self/roots_movement
	name = "Movement of roots"
	desc = "Move through the roots to someone you know..."
	recharge_time = 10 MINUTES
	miracle = FALSE
	devotion_cost = 0
	clothes_req = FALSE
	human_req = FALSE

/obj/effect/proc_holder/spell/self/roots_movement/cast(list/targets, mob/user)
	var/mob/living/carbon/human/C = user
	var/list/possible = C.mind.known_people.Copy()

	if(!possible.len)
		to_chat(C, span_warning("I have no known livings."))
		revert_cast()
		return FALSE

	var/prompt = "Choose living being to move to..."
	var/target_name = tgui_input_list(C, prompt, "Roots Moving", sort_list(possible))

	var/mob/living/carbon/human/found_mob
	for(var/mob/living/carbon/human/HL in GLOB.human_list)
		if(HL.real_name == target_name)
			found_mob = HL
			break

	if(!found_mob)
		revert_cast()
		return FALSE

	if(!isturf(found_mob.loc))
		revert_cast()
		return FALSE

	C.visible_message(span_yellow("[C]'s legs begin to cover in strange roots..."), \
							span_yellow("I starts to move to [found_mob.name]..."))

	if(!do_after(C, 10 SECONDS, TRUE, C))
		revert_cast()
		return FALSE

	C.adjust_blindness(2)
	C.forceMove(found_mob.loc)
	C.visible_message(span_yellow("[C]'s appears from the ground, covered in roots!"), \
							span_yellow("I moved throught the roots to [found_mob.name]."))

/datum/hag_boon/spell/blesscrop
	name = "Boon of bless crop"
	desc = "Allows bearer to bless crops as druid does."
	spell_type = /obj/effect/proc_holder/spell/targeted/blesscrop
	points = 20

/datum/hag_boon/spell/berserker_rage
	name = "Boon of berserker rage"
	desc = "Grants bearer a berkerker's rage, allowing it to become stronger."
	spell_type = /datum/action/cooldown/spell/rage
	points = 75

/datum/hag_boon/spell/berserker_rage/apply_boon_effect(mob/living/L)
	if(!L.mind || !spell_type)
		return

	if(!locate(spell_type) in L.mind.spell_list)
		L.mind.AddSpell(new spell_type)

	return

/datum/hag_boon/spell/berserker_rage/remove_boon_effect(mob/living/L)
	if(!L.mind || !spell_type)
		return

	if(locate(spell_type) in L.mind.spell_list)
		L.mind.AddSpell(spell_type)

	return

// HAG SPELLS - We make it ignore cockblock, cuz it's non-combat spells
/obj/effect/proc_holder/spell/invoked/resurrect/hag
	ignore_cockblock = TRUE

/obj/effect/proc_holder/spell/invoked/grant_boon
	ignore_cockblock = TRUE

/obj/effect/proc_holder/spell/invoked/transmutation_rite
	ignore_cockblock = TRUE

/obj/effect/proc_holder/spell/invoked/spiritual_siphon
	ignore_cockblock = TRUE

/obj/effect/proc_holder/spell/invoked/mindlink/hag
	ignore_cockblock = TRUE

// Hag forms
/obj/effect/proc_holder/spell/self/wildshape/hag_disgusting_form
	name = "Disgusting Form"
	desc = "Turns yourself into a disgusting creature."
	invocation_type = "none"
	recharge_time = 10 SECONDS
	miracle = FALSE
	devotion_cost = 0
	clothes_req = FALSE
	human_req = FALSE
	ignore_cockblock = TRUE

	possible_shapes = list(
		/mob/living/carbon/human/species/wildshape/rat,
		/mob/living/carbon/human/species/wildshape/fox,
	)
	disallowed_equipment_type = list(/obj/item/rogueweapon)

// Make Fey spell
/obj/effect/proc_holder/spell/invoked/feytouch
	name = "Fairy Touch"
	desc = "Touch a mortal and offer him to become a feytouched, depriving him of all his debts to you."
	invocation_type = "whisper"
	invocations = list("Give up your soul and be free from debt.")
	recharge_time = 5 SECONDS
	range = 4
	overlay_icon = 'icons/mob/actions/hagspells.dmi'
	action_icon = 'icons/mob/actions/hagspells.dmi'
	overlay_state = "hand_up"
	var/confirmed_read = FALSE

/obj/effect/proc_holder/spell/invoked/feytouch/cast(list/targets, mob/user)
	var/datum/component/hag_curio_tracker/H = user.GetComponent(/datum/component/hag_curio_tracker)
	if(!H)
		to_chat(user, span_warning("How did you even get access to this without being a hag?"))
		return FALSE


	var/mob/living/carbon/human/victim = targets[1]
	if(!ishuman(victim))
		to_chat(user, span_warning("I need to cast this on a person!"))
		return FALSE
	if(!victim.client)
		to_chat(user, span_warning("They're not aware enough to give me their name!"))
		return FALSE
	if(user == victim)
		to_chat(user, span_warning("I can't make yourself a fey!"))
		return FALSE
	if(HAS_TRAIT(victim, TRAIT_FEYTOUCHED) || HAS_TRAIT(victim, TRAIT_FEYBOUND) || HAS_TRAIT(victim, TRAIT_ANCIENT_HAG))
		to_chat(user, span_warning("I can't make fey a fey..?"))
		return FALSE
	if(alert(victim, "[user] is attempting to take your soul! You will become a feytouched and you WILL HAVE to LISTEN to the hag, but your debts will be payed. Do you want to allow this? Nothing bad will happen if you say no.", "FAIRY TOUCH", "Yes", "No") != "Yes")
		to_chat(user, span_warning("They refused to your attempts."))
		to_chat(victim, span_warning("Your soul is safe, for now."))
		log_game("FEYTOUCH: [victim.real_name] ([victim.ckey]) has rejected to become fey of [user.real_name] ([user.ckey]).")
		return TRUE
	var/list/registry = H.boon_registry[victim.real_name]
	for(var/datum/hag_boon/B in registry)
		if(B.transmutable)
			B.transmutable = FALSE
			B.cursed = TRUE
	// Make it feybound, but they can't refuse to be vessel.
	ADD_TRAIT(victim, TRAIT_FEYBOUND, TRAIT_HAG_BOON)
	GLOB.fey_vessels[victim] = TRUE
	victim.extra_boon_budget = 60
	for(var/mob/living/hag_mob in GLOB.active_hags)
		var/datum/mind/hag_mind = hag_mob.mind
		if(!hag_mind)
			continue
		hag_mind.i_know_person(victim)
		victim.mind.i_know_person(hag_mind)
	to_chat(victim, span_boldnotice("The Mossmother's gaze lingers upon you. You are recognized by her daughters."))
	return TRUE
