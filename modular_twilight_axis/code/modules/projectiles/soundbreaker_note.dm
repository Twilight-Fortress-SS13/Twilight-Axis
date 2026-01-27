/obj/projectile/soundbreaker_note
	name = "sound note"
	icon = 'modular_twilight_axis/icons/roguetown/misc/soundanims.dmi'
	icon_state = "note_projectile"

	speed = 1
	range = 7
	damage = 0
	anchored = FALSE

	var/mob/living/owner
	var/damage_mult = 0.5
	damage_type = BRUTE
	var/zone = BODY_ZONE_CHEST
	var/hit_processed = FALSE

/obj/projectile/soundbreaker_note/Initialize(mapload, mob/living/source, _dmg_mult, _dmg_type, _zone)
	. = ..()
	owner = source
	if(_dmg_mult)
		damage_mult = _dmg_mult
	if(_dmg_type)
		damage_type = _dmg_type
	if(_zone)
		zone = _zone

/obj/projectile/soundbreaker_note/Bump(atom/A)
	if(hit_processed)
		return
	return ..()

/obj/projectile/soundbreaker_note/on_hit(atom/target, blocked = FALSE)
	if(hit_processed)
		return
	hit_processed = TRUE

	. = ..()

	if(blocked)
		return
	if(!isliving(target) || !owner)
		return

	paused = TRUE
	fired = FALSE
	STOP_PROCESSING(SSprojectiles, src)

	var/mob/living/L = target
	SEND_SIGNAL(owner, COMSIG_SOUNDBREAKER_NOTE_PROJECTILE_HIT, L, damage_mult, damage_type, zone)

	qdel(src)
