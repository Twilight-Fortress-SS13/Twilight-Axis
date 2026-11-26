/datum/component/cursed_item
	dupe_mode = COMPONENT_DUPE_UNIQUE
	///trait, or trait list, that will avoid triggering the curse. Now cursed items can have more than one trait be immune to them!
	var/list/required_traits
	///used for the text you get upon triggering the curse
	var/item_type
	var/verbed

/datum/component/cursed_item/Initialize(god_traits, item_class, verbiage = "PUNISHED")
	. = ..()
	if(!isitem(parent))
		return COMPONENT_INCOMPATIBLE
	if(islist(god_traits))
		required_traits = god_traits
	else
		required_traits = list(god_traits)
	item_type = item_class
	verbed = verbiage

	if(isclothing(parent)) // TA EDIT START
		var/obj/item/clothing/cursed_clothing = parent
		cursed_clothing.resistance_flags |= FIRE_PROOF // TA EDIT END

	RegisterSignal(parent, COMSIG_ITEM_EQUIPPED, PROC_REF(on_equip))

/datum/component/cursed_item/proc/on_equip()
	SIGNAL_HANDLER
	var/obj/item/I = parent
	if(!ishuman(I.loc))
		return
	var/mob/living/carbon/human/user = I.loc
	for(var/trait in required_traits)
		if(HAS_TRAIT(user, trait))
		//TA Edit start
			if(istype(I,/obj/item/clothing) && HAS_TRAIT(I, TRAIT_NODROP))
				RegisterSignal(user,COMSIG_CURSED_ITEM_BURNED,PROC_REF(demilitirize))
			return
	spawn(0)
		to_chat(user, "<font color='red'>UNWORTHY HANDS TOUCHING THIS [item_type], CEASE OR BE [verbed]!</font>")
		user.adjust_fire_stacks(5)
		user.ignite_mob()
		user.Stun(40)

/datum/component/cursed_item/proc/demilitirize(mob/living/user)
	var/obj/item/clothing/I = parent
	I.armor = null
	I.max_integrity = 50
	if(I.obj_integrity > I.max_integrity)
		I.obj_integrity = I.max_integrity
//TA Edit end
