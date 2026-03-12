/obj/projectile/runeblade_bolt
	name = "runeblade bolt"
	icon = 'modular_twilight_axis/icons/roguetown/misc/soundanims.dmi'
	icon_state = "note_projectile"

	speed = 1
	range = 7
	damage = 0
	anchored = FALSE

	var/mob/living/owner
	var/obj/item/weapon_source
	var/datum/applied_rune/applied_rune
	var/effect_mult = 1
	var/cooldown_mult = 1
	var/weapon_self_damage_pct = 0
	var/hit_processed = FALSE

/obj/projectile/runeblade_bolt/Initialize(
	mapload,
	mob/living/source,
	obj/item/source_weapon,
	datum/applied_rune/source_applied,
	_new_effect_mult,
	_new_cooldown_mult,
	_new_weapon_self_damage_pct
)
	. = ..()

	if(!source || QDELETED(source) || !source_weapon || !source_applied || !source_applied.rune)
		qdel(src)
		return

	owner = source
	weapon_source = source_weapon
	applied_rune = source_applied
	effect_mult = isnum(_new_effect_mult) ? _new_effect_mult : 1
	cooldown_mult = isnum(_new_cooldown_mult) ? _new_cooldown_mult : 1
	weapon_self_damage_pct = isnum(_new_weapon_self_damage_pct) ? _new_weapon_self_damage_pct : 0

/obj/projectile/runeblade_bolt/on_hit(atom/target, blocked = FALSE)
	if(hit_processed)
		return

	hit_processed = TRUE
	. = ..()

	paused = TRUE
	fired = FALSE
	STOP_PROCESSING(SSprojectiles, src)

	if(blocked)
		qdel(src)
		return

	if(!isliving(target) || !owner || QDELETED(owner) || !weapon_source || QDELETED(weapon_source) || !applied_rune || !applied_rune.rune)
		qdel(src)
		return

	var/datum/component/rune_storage/storage = weapon_source.GetComponent(/datum/component/rune_storage)
	if(!storage)
		qdel(src)
		return

	var/datum/rune/R = applied_rune.rune
	var/obj/item/weapon = weapon_source
	var/mob/living/L = target

	R.on_trigger(weapon, owner, L, storage, applied_rune)
	R.finalize_runtime_trigger(weapon, applied_rune, cooldown_mult, weapon_self_damage_pct)

	qdel(src)

/obj/projectile/runeblade_bolt/Destroy()
	hit_processed = TRUE
	paused = TRUE
	fired = FALSE
	STOP_PROCESSING(SSprojectiles, src)
	return ..()
