/datum/rune
	/// Unique id for logic/UI/debug
	var/id = "base"

	/// Display name
	var/name = "Rune"

	/// Description
	var/desc = "A mysterious rune."

	/// Cooldown between activations
	var/cooldown = 0

	/// Chance to trigger, 0..100
	var/proc_chance = 100

	/// Whether this rune has a persistent effect while attached
	var/is_persistent = FALSE

	/// Element string/define
	var/element = RUNE_ELEMENT_EARTH

	/// Trigger mask
	var/trigger_flags = RUNE_TRIGGER_ON_HIT

	/// Color used by rune stone visuals
	var/color = null

/datum/rune/proc/can_trigger(obj/item/weapon, mob/living/user, atom/target, datum/component/rune_storage/storage, datum/applied_rune/applied)
	if(!weapon || !storage || !applied)
		return FALSE

	if(applied.next_trigger_time > world.time)
		return FALSE

	if(proc_chance < 100 && !prob(proc_chance))
		return FALSE

	return TRUE

/datum/rune/proc/on_apply(obj/item/weapon, mob/living/user, datum/component/rune_storage/storage, datum/applied_rune/applied)
	return

/datum/rune/proc/on_remove(obj/item/weapon, mob/living/user, datum/component/rune_storage/storage, datum/applied_rune/applied)
	return

/datum/rune/proc/on_trigger(obj/item/weapon, mob/living/user, atom/target, datum/component/rune_storage/storage, datum/applied_rune/applied)
	return

/datum/rune/proc/on_persistent_apply(obj/item/weapon, mob/living/user, datum/component/rune_storage/storage, datum/applied_rune/applied)
	return

/datum/rune/proc/on_persistent_remove(obj/item/weapon, mob/living/user, datum/component/rune_storage/storage, datum/applied_rune/applied)
	return
