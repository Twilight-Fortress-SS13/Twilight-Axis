/datum/component/church_weapon
	dupe_mode = COMPONENT_DUPE_UNIQUE
	///trait that will avoid triggering the curse
	var/required_trait

/datum/component/church_weapon/Initialize(god_trait)
	. = ..()
	if(!isitem(parent))
		return COMPONENT_INCOMPATIBLE
	required_trait = god_trait

	RegisterSignal(parent, COMSIG_ITEM_EQUIPPED, PROC_REF(on_equip))

/datum/component/church_weapon/proc/on_equip()
	SIGNAL_HANDLER
	var/obj/item/I = parent
	if(!ishuman(I.loc))
		return
	var/mob/living/carbon/human/user = I.loc
	if(!HAS_TRAIT(user, required_trait))
		spawn(0)
			if(istype(user.patron, /datum/patron/inhumen))
				to_chat(user, span_warning("YOU FOOL! IT IS ANATHEMA TO YOU! GET AWAY!"))
				user.Stun(40)
				user.Knockdown(40)
				to_chat(user, span_warning("[user] lets out a painful shriek as the sword lashes out at them!"))
				user.emote("agony")
				user.adjust_fire_stacks(5)
				user.ignite_mob()
			else	//Everyone else
				to_chat(user, span_warning("A painful jolt across your entire body sends you to the ground. You cannot touch this thing."))
				user.emote("groan")
				user.Stun(10)