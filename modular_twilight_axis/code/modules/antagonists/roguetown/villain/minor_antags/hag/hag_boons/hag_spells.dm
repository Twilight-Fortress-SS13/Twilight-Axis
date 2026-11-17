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

/datum/hag_boon/spell/rous_form
	name = "Boon of rous form"
	desc = "Allows bearer to transform into a big, evil rat..."
	spell_type = /obj/effect/proc_holder/spell/self/wildshape/hag_rous_form
	points = 65

/obj/effect/proc_holder/spell/self/wildshape/hag_rous_form
	name = "Rous Form"
	desc = "Turns yourself into a big, evil rat!"
	invocation_type = "none"
	recharge_time = 10 SECONDS
	miracle = FALSE
	devotion_cost = 0
	clothes_req = FALSE
	human_req = FALSE
	ignore_cockblock = TRUE

	possible_shapes = list(
		/mob/living/carbon/human/species/wildshape/rous
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
	points = 50

/datum/hag_boon/spell/berserker_rage
	name = "Boon of berserker rage"
	desc = "Grants bearer a berkerker's rage, allowing it to become stronger."
	spell_type = /obj/effect/proc_holder/spell/self/rage
	points = 75

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
		/mob/living/carbon/human/species/wildshape/mirecrawler,
		/mob/living/carbon/human/species/wildshape/spider,
		/mob/living/carbon/human/species/wildshape/rous,
		/mob/living/carbon/human/species/wildshape/fox,
		/mob/living/carbon/human/species/wildshape/crow,
	)
	disallowed_equipment_type = list(/obj/item/rogueweapon)
