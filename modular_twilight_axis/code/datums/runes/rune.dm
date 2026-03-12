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

	/// Whether this rune may coexist with another rune of the same exact type on one weapon
	var/can_stack = TRUE

	/// Element string/define
	var/element = RUNE_ELEMENT_EARTH

	/// Trigger mask
	var/trigger_flags = RUNE_TRIGGER_ON_HIT

	/// Color used by rune stone visuals
	var/color = null

	/// Ingredients required to carve this rune from a stone.
	/// Format: list(/obj/item/something = amount, ...)
	var/list/carve_ingredients = list()


/datum/rune/proc/can_trigger(obj/item/weapon, mob/living/user, atom/target, datum/component/rune_storage/storage, datum/applied_rune/applied)
	if(!weapon || !storage || !applied)
		return FALSE

	if(!applied.rune)
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


/datum/rune/proc/scale_amount(base_value, effect_mult = 1, minimum = 1)
	if(!isnum(base_value))
		return base_value

	var/scaled = round(base_value * effect_mult)

	if(base_value > 0)
		return max(minimum, scaled)

	if(base_value < 0)
		return min(-minimum, scaled)

	return 0


/datum/rune/proc/scale_duration(base_duration, effect_mult = 1, minimum = 1)
	if(!isnum(base_duration))
		return base_duration

	return max(minimum, round(base_duration * effect_mult))


/datum/rune/proc/get_runtime_cooldown(cooldown_mult = 1)
	return round(cooldown * cooldown_mult)

/datum/rune/proc/finalize_trigger(obj/item/weapon, datum/applied_rune/applied)
	return finalize_runtime_trigger(weapon, applied, 1, 0)

/datum/rune/proc/finalize_runtime_trigger(
	obj/item/weapon,
	datum/applied_rune/applied,
	cooldown_mult = 1,
	weapon_self_damage_pct = 0
)
	if(!applied)
		return

	applied.next_trigger_time = world.time + get_runtime_cooldown(cooldown_mult)

	if(weapon && weapon_self_damage_pct > 0)
		var/self_damage = max(1, round(max(weapon.obj_integrity, 1) * weapon_self_damage_pct))
		weapon.take_damage(self_damage, BRUTE, "blunt")

/datum/rune/proc/is_same_rune_type(datum/rune/other)
	if(!other)
		return FALSE
	return type == other.type
