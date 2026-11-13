/datum/magic_item/greater/implement/proc/add_bonus(obj/item/rogueweapon/implement)
	return

// Добавляем статы напрямую, ещё нет компонента зачарования для перерасчёта в update_gem_state()
/datum/magic_item/greater/implement/on_apply(obj/item/i)
	. = ..()
	if(istype(i, /obj/item/rogueweapon))
		add_bonus(i)

/datum/magic_item/greater/implement/focus_amplification
	name = "focus amplification"
	description = "Runes of focus amplification are scribed along it."
	glow_color = "#3D61FF"

/datum/magic_item/greater/implement/focus_amplification/add_bonus(obj/item/rogueweapon/implement)
	implement.implement_refund += 0.10

/datum/magic_item/greater/implement/rapid_concentration
	name = "rapid concentration"
	description = "Runes of rapid concentration are scribed into its binding."
	glow_color = "#FFD27A"

/datum/magic_item/greater/implement/rapid_concentration/add_bonus(obj/item/rogueweapon/implement)
	implement.implement_cast_speed += 0.05

// The gem sets the base values (0 when the setting is empty), then each implement enchantment adds on top.
/obj/item/rogueweapon/update_gem_state()
	. = ..()
	var/datum/component/magic_item/M = GetComponent(/datum/component/magic_item)
	if(!M)
		return
	for(var/datum/magic_item/greater/implement/effect in M.magical_effects)
		effect.add_bonus(src)

// Тинктуры

/obj/item/enchantmentscroll/greater/implement
	abstract_type = /obj/item/enchantmentscroll/greater/implement
	var/implement_type

/obj/item/enchantmentscroll/greater/implement/attack_obj(obj/item/O, mob/living/user)
	if(!..())
		return
	if(!istype(O, implement_type))
		to_chat(user, span_notice("You don't think [O] will take to the enchantment. Best not to waste the ink."))
		return
	to_chat(user, span_notice("You scribe intricate runes onto [O] with [src], imbuing it with an enchantment!"))
	O.AddComponent(/datum/component/magic_item, new component)
	qdel(src)

/obj/item/enchantmentscroll/greater/implement/focus_amplification
	name = "runic tincture of focus amplification"
	desc = "A vial of quicksilver ink that amplifies a staff's focus, letting it recapture more of a spell's spent energy."
	component = /datum/magic_item/greater/implement/focus_amplification
	apply_to_pretty = "Can be applied to mage's staves only."
	effects_pretty = "The staff returns an extra 10% of a spell's resource cost."
	implement_type = /obj/item/rogueweapon/woodstaff/implement

/obj/item/enchantmentscroll/greater/implement/rapid_concentration
	name = "runic tincture of rapid concentration"
	desc = "A vial of quicksilver ink that steadies the reader of an arcyne tome, letting a spell be gathered faster."
	component = /datum/magic_item/greater/implement/rapid_concentration
	apply_to_pretty = "Can be applied to arcyne tomes only."
	effects_pretty = "The tome shortens the time needed to gather a spell by an extra 5%."
	implement_type = /obj/item/rogueweapon/spellbook

/datum/runeritual/enchanting/implement_focus_amplification
	name = "Focus Amplification"
	desc = "Lets a mage's staff recapture more spent energy."
	blacklisted = FALSE
	tier = 3
	required_atoms = list(/obj/item/rogueore/cinnabar = 1, /obj/item/reagent_containers/glass/bottle/alchemical = 1, /obj/item/magic/elemental/fragment = 2)
	result_atoms = list(/obj/item/enchantmentscroll/greater/implement/focus_amplification)

/datum/runeritual/enchanting/implement_rapid_concentration
	name = "Rapid Concentration"
	desc = "Lets an arcyne tome gather spells faster."
	blacklisted = FALSE
	tier = 3
	required_atoms = list(/obj/item/rogueore/cinnabar = 1, /obj/item/reagent_containers/glass/bottle/alchemical = 1, /obj/item/magic/fae/heartwoodcore = 1, /obj/item/magic/leyline = 1)
	result_atoms = list(/obj/item/enchantmentscroll/greater/implement/rapid_concentration)
