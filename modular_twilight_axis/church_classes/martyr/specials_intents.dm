/obj/effect/temp_visual/necra_soul
	icon = 'icons/effects/effects.dmi'
	icon_state = "curseblob"
	layer = ABOVE_MOB_LAYER
	duration = 0.8 SECONDS
	alpha = 220

/obj/effect/temp_visual/necra_mark
	icon = 'icons/effects/effects.dmi'
	icon_state = "blip"
	layer = ABOVE_MOB_LAYER
	duration = 1.2 SECONDS
	pixel_y = 16

/obj/effect/temp_visual/necra_burst
	icon = 'icons/effects/effects.dmi'
	icon_state = "curseblob"
	layer = ABOVE_MOB_LAYER
	duration = 0.6 SECONDS
	alpha = 240

/obj/effect/temp_visual/astrata_mark
	icon = 'icons/effects/effects.dmi'
	icon_state = "at_shield2"
	layer = ABOVE_MOB_LAYER
	duration = 1.2 SECONDS
	pixel_y = 16

/obj/effect/temp_visual/ravox_impact
	icon = 'icons/effects/effects.dmi'
	icon_state = "kick_fx"
	layer = ABOVE_MOB_LAYER
	duration = 0.6 SECONDS
	pixel_y = 0

/obj/effect/temp_visual/ravox_charge_step
	icon = 'icons/effects/effects.dmi'
	icon_state = "kick_fx"
	layer = BELOW_MOB_LAYER
	duration = 0.25 SECONDS
	alpha = 180

/obj/effect/temp_visual/malum_forge_impact
	icon = 'icons/effects/effects.dmi'
	icon_state = "lavastaff_warn"
	layer = ABOVE_MOB_LAYER
	duration = 0.8 SECONDS
	alpha = 255

/obj/effect/temp_visual/malum_forge_burst
	icon = 'icons/effects/effects.dmi'
	icon_state = "strike"
	layer = ABOVE_MOB_LAYER
	duration = 0.5 SECONDS
	alpha = 255

/obj/effect/malum_scorched_ground
	name = "scorched ground"
	icon = 'icons/effects/effects.dmi'
	icon_state = "lavastaff_warn"
	anchored = TRUE
	density = FALSE
	mouse_opacity = FALSE
	layer = BELOW_MOB_LAYER
	alpha = 180

	var/end_time = 0
	var/fire_stacks_tick = 1
	var/slow_tick = 1

/obj/effect/temp_visual/abyssor_trident_trail
	icon = 'icons/effects/effects.dmi'
	icon_state = "curseblob"
	layer = BELOW_MOB_LAYER
	duration = 0.35 SECONDS
	alpha = 170

/obj/effect/temp_visual/abyssor_trident_hit
	icon = 'icons/effects/effects.dmi'
	icon_state = "splash"
	layer = ABOVE_MOB_LAYER
	duration = 0.6 SECONDS
	alpha = 220

/obj/effect/temp_visual/abyssor_trident_reel
	icon = 'icons/effects/effects.dmi'
	icon_state = "curseblob"
	layer = ABOVE_MOB_LAYER
	duration = 0.4 SECONDS
	alpha = 210

/obj/effect/temp_visual/abyssor_trident_finish
	icon = 'icons/effects/effects.dmi'
	icon_state = "stab"
	layer = ABOVE_MOB_LAYER
	duration = 0.5 SECONDS
	alpha = 255

/obj/effect/abyssor_trident_flight
	name = "abyssor trident"
	anchored = TRUE
	density = FALSE
	mouse_opacity = FALSE
	layer = ABOVE_MOB_LAYER
	pixel_x = -16
	pixel_y = -16

/obj/effect/temp_visual/dendor_vines_begin
	icon = 'modular_twilight_axis/icons/effects/effects.dmi'
	icon_state = "vines_begin"
	layer = BELOW_MOB_LAYER
	duration = 1.5 SECONDS
	alpha = 255
	pixel_y = 0

/obj/effect/temp_visual/dendor_vines_mid
	icon = 'modular_twilight_axis/icons/effects/effects.dmi'
	icon_state = "vines_mid"
	layer = ABOVE_MOB_LAYER
	duration = 7 SECONDS
	alpha = 255
	pixel_y = 0

/obj/effect/temp_visual/dendor_vines_end
	icon = 'modular_twilight_axis/icons/effects/effects.dmi'
	icon_state = "vines_end"
	layer = ABOVE_MOB_LAYER
	duration = 0.3 SECONDS
	alpha = 255
	pixel_y = 0

/obj/effect/malum_scorched_ground/Initialize(mapload, duration_override = 20 SECONDS)
	. = ..()
	end_time = world.time + duration_override
	START_PROCESSING(SSobj, src)

/obj/effect/malum_scorched_ground/Destroy()
	STOP_PROCESSING(SSobj, src)
	return ..()

/obj/effect/malum_scorched_ground/process()
	if(world.time >= end_time)
		qdel(src)
		return

	for(var/mob/living/L in loc)
		L.adjust_fire_stacks(fire_stacks_tick)
		L.ignite_mob()
		L.Slowdown(slow_tick)

/atom/movable/screen/alert/status_effect/debuff/necra_harvested
	name = "Жатва Некры"
	desc = "Под вуалью Некры твои силы увядают."
	icon_state = "debuff"

/datum/status_effect/debuff/necra_harvested
	id = "necra_harvested"
	status_type = STATUS_EFFECT_UNIQUE
	duration = 20 SECONDS
	alert_type = /atom/movable/screen/alert/status_effect/debuff/necra_harvested

/datum/status_effect/debuff/necra_harvested/on_apply()
	effectedstats = list(
		"constitution" = -3,
		"speed" = -2,
		"willpower" = -2
	)
	. = ..()



/datum/special_intent/martyr_necra_harvest
	name = "Necra's Harvest"
	desc = "Ты проводишь косой мрачную жатву, отмечая живых для сбора. Спустя миг Некра забирает часть их сил и восстанавливает при помощи них твое тело."
	tile_coordinates = list(
		list(-1,0), list(0,0), list(1,0),
		list(-2,1), list(-1,1), list(0,1), list(1,1), list(2,1)
	)

	use_clickloc = FALSE
	respect_adjacency = TRUE
	respect_dir = TRUE

	delay = 0.5 SECONDS
	fade_delay = 0.4 SECONDS

	pre_icon_state = "trap"
	post_icon_state = "sweep_fx"

	sfx_pre_delay = 'sound/combat/parry/bladed/bladedsmall (3).ogg'
	sfx_post_delay = 'sound/combat/sidesweep_hit.ogg'

	cooldown = 45 SECONDS
	stamcost = 25

	var/base_dam = 0
	var/harvest_dam = 0
	var/list/harvest_targets = list()

	var/harvest_delay = 1 SECONDS
	var/heal_per_target = 16
	var/self_commit = 0.7 SECONDS

	var/list/necra_cries = list(
		"Некра, Дама в Вуали, прими их души.",
		"Час их настал — Некра, пожни их.",
		"Некра, укрой их во мраке своей вуали.",
		"Да исполнится жатва Некры."
	)

/datum/special_intent/martyr_necra_harvest/_reset()
	base_dam = 0
	harvest_dam = 0
	harvest_targets = list()
	. = ..()

/datum/special_intent/martyr_necra_harvest/process_attack()
	var/obj/item/rogueweapon/W = iparent
	var/scalemod = max(((howner.STASTR + howner.STAPER + howner.STAWIL) / 30), 1)

	base_dam = W.force_dynamic * scalemod
	harvest_dam = W.force_dynamic * scalemod * 1.3

	. = ..()

/datum/special_intent/martyr_necra_harvest/on_create()
	. = ..()
	howner.Immobilize(self_commit)
	howner.say(pick(necra_cries))

/datum/special_intent/martyr_necra_harvest/apply_hit(turf/T)
	var/added_any = FALSE

	for(var/mob/living/L in get_hearers_in_view(0, T))
		if(L == howner)
			continue

		if(L in harvest_targets)
			continue

		harvest_targets += L
		added_any = TRUE

		if(L.mobility_flags & MOBILITY_STAND)
			apply_generic_weapon_damage(L, base_dam, "slash", BODY_ZONE_CHEST, bclass = BCLASS_CUT)

		L.apply_status_effect(/datum/status_effect/debuff/exposed, 3 SECONDS)
		L.apply_status_effect(/datum/status_effect/debuff/necra_harvested, 20 SECONDS)

		var/turf/mark_turf = get_turf(L)
		if(mark_turf)
			new /obj/effect/temp_visual/necra_mark(mark_turf)

	if(added_any)
		addtimer(CALLBACK(src, PROC_REF(resolve_harvest)), harvest_delay)

	..()

/datum/special_intent/martyr_necra_harvest/proc/resolve_harvest()
	if(!howner || QDELETED(howner))
		return

	if(!length(harvest_targets))
		return

	var/heal_total = 0

	for(var/mob/living/L in harvest_targets)
		if(!L || QDELETED(L))
			continue

		var/turf/T = get_turf(L)
		var/turf/U = get_turf(howner)

		if(T && U)
			var/obj/effect/temp_visual/necra_soul/soul = new(T)
			animate(soul, pixel_x = (U.x - T.x) * 32, pixel_y = (U.y - T.y) * 32, alpha = 0, time = 6)

		if(L.mobility_flags & MOBILITY_STAND)
			apply_generic_weapon_damage(L, harvest_dam, "slash", BODY_ZONE_CHEST, bclass = BCLASS_CHOP)

		L.visible_message(
			span_danger("[L] теряет силу под жатвой Некры!"),
			span_userdanger("Моя сила утекает прочь!")
		)

		heal_total += heal_per_target

	if(heal_total > 0)
		var/heal_brute = heal_total * 0.5
		var/heal_fire = heal_total * 0.3
		var/heal_tox = heal_total * 0.2

		howner.adjustBruteLoss(-heal_brute)
		howner.adjustFireLoss(-heal_fire)
		howner.adjustToxLoss(-heal_tox)

		var/turf/H = get_turf(howner)
		if(H)
			new /obj/effect/temp_visual/necra_burst(H)
			playsound(H, 'sound/magic/necra_sight.ogg', 70, TRUE)

		howner.visible_message(
			span_warning("[howner] черпает силу из собранных душ!"),
			span_notice("Некра возвращает мне силы.")
		)



/datum/special_intent/martyr_astrata_verdict
	name = "Astrata's Verdict"
	desc = "Ты клеймишь всех грешников перед собой священным огнем. После краткой задержки на каждого из них обрушивается суд Астраты."
	tile_coordinates = list(
		list(-1,0), list(0,0), list(1,0),
		list(-1,1), list(0,1), list(1,1),
		            list(0,2)
	)
	use_clickloc = FALSE
	respect_adjacency = TRUE
	respect_dir = TRUE
	delay = 0.6 SECONDS
	fade_delay = 0.4 SECONDS
	pre_icon_state = "trap"
	post_icon_state = "stab"
	sfx_pre_delay = 'sound/combat/parry/bladed/bladedsmall (3).ogg'
	sfx_post_delay = 'sound/magic/lightning.ogg'
	cooldown = 50 SECONDS
	stamcost = 25

	var/self_immob_dur = 1 SECONDS
	var/mark_delay = 1.1 SECONDS
	var/mark_fire_stacks = 3
	var/base_dam = 0
	var/verdict_dam = 0
	var/list/marked_targets = list()
	var/verdict_token = 0

	var/list/astrata_cries = list(
		"Астрата, узри виновных!",
		"Да свершится суд Астраты!",
		"Астрата, низвергни свой приговор!",
		"Пусть свет Астраты рассудит вас!"
	)

/datum/special_intent/martyr_astrata_verdict/_reset()
	base_dam = 0
	verdict_dam = 0
	marked_targets = list()
	verdict_token++
	. = ..()

/datum/special_intent/martyr_astrata_verdict/process_attack()
	var/obj/item/rogueweapon/W = iparent
	var/scalemod = max(((howner.STASTR + howner.STAPER + howner.STAWIL) / 30), 1)

	base_dam = W.force_dynamic * scalemod * 0.9
	verdict_dam = W.force_dynamic * scalemod * 1.8

	. = ..()

/datum/special_intent/martyr_astrata_verdict/on_create()
	. = ..()
	howner.Immobilize(self_immob_dur)
	howner.apply_status_effect(/datum/status_effect/debuff/clickcd, self_immob_dur)
	howner.say(pick(astrata_cries))

/datum/special_intent/martyr_astrata_verdict/apply_hit(turf/T)
	for(var/mob/living/L in get_hearers_in_view(0, T))
		if(L == howner)
			continue
		if(L in marked_targets)
			continue

		marked_targets += L

		L.adjust_fire_stacks(mark_fire_stacks)
		L.ignite_mob()
		L.apply_status_effect(/datum/status_effect/debuff/exposed, 3 SECONDS)

		if(L.mobility_flags & MOBILITY_STAND)
			apply_generic_weapon_damage(L, base_dam, "fire", BODY_ZONE_CHEST, bclass = BCLASS_CUT)

		var/turf/mark_turf = get_turf(L)
		if(mark_turf)
			new /obj/effect/temp_visual/astrata_mark(mark_turf)

		L.visible_message(
			span_warning("[L] отмечен судом Астраты!"),
			span_warning("Священное пламя выжигает на мне клеймо суда!")
		)

		var/current_token = verdict_token
		addtimer(CALLBACK(src, PROC_REF(execute_verdict), L, current_token), mark_delay)

	playsound(T, 'sound/combat/sidesweep_hit.ogg', 100, TRUE)
	..()

/datum/special_intent/martyr_astrata_verdict/proc/execute_verdict(mob/living/target, token)
	if(token != verdict_token)
		return
	if(!target || QDELETED(target) || !howner || QDELETED(howner))
		return
	if(target.stat == DEAD)
		return

	var/turf/target_turf = get_turf(target)
	var/turf/howner_turf = get_turf(howner)

	if(!target_turf || !howner_turf)
		return
	if(target_turf.z != howner_turf.z)
		return
	if(get_dist(howner, target) > 8)
		return

	for(var/mob/living/carbon/M in viewers(world.view, howner))
		M.lightning_flashing = TRUE
		M.update_sight()
		addtimer(CALLBACK(M, TYPE_PROC_REF(/mob/living/carbon, reset_lightning)), 2)

	var/turf/beam_from = get_step(get_step(target, NORTH), NORTH)
	if(beam_from)
		beam_from.Beam(target, icon_state = "lightning[rand(1,12)]", time = 5)

	playsound(target, 'sound/magic/lightning.ogg', 100, FALSE)

	var/final_dam = verdict_dam
	if(target.fire_stacks > 0)
		final_dam *= 1.25
	if(target.has_status_effect(/datum/status_effect/debuff/exposed) || target.has_status_effect(/datum/status_effect/debuff/vulnerable))
		final_dam *= 1.2

	target.adjust_fire_stacks(4)
	target.ignite_mob()

	target.Immobilize(0.5 SECONDS)
	target.apply_status_effect(/datum/status_effect/debuff/clickcd, 6 SECONDS)
	target.electrocute_act(1, src, 1, SHOCK_NOSTUN)
	target.apply_status_effect(/datum/status_effect/buff/lightningstruck, 6 SECONDS)

	if(target.mobility_flags & MOBILITY_STAND)
		apply_generic_weapon_damage(target, final_dam, "fire", BODY_ZONE_CHEST, bclass = BCLASS_CUT)

	target.visible_message(
		span_warning("Суд Астраты обрушивается на [target]!"),
		span_warning("Божественный приговор низвергается на меня!")
	)



/datum/special_intent/martyr_ravox_charge
	name = "Ravox's Charge"
	desc = "Ты взываешь к Равоксу и несешься к выбранной точке. Когда ты достигаешь ее, все враги вокруг валятся с ног. Если ты никого не заденешь, то рухнешь сам."
	tile_coordinates = list(
		list(-1,0), list(0,0), list(1,0),
		list(-1,1), list(0,1), list(1,1),
		list(-1,-1), list(0,-1), list(1,-1)
	)
	use_clickloc = TRUE
	respect_adjacency = FALSE
	respect_dir = FALSE
	delay = 0.1 SECONDS
	fade_delay = 0.4 SECONDS
	pre_icon_state = "fx_trap_long"
	post_icon_state = "kick_fx"
	sfx_pre_delay = 'sound/combat/rend_start.ogg'
	sfx_post_delay = 'sound/combat/ground_smash1.ogg'
	cooldown = 40 SECONDS
	stamcost = 30
	range = 7

	var/dam = 0
	var/knockdown_dur = 2 SECONDS
	var/self_knockdown_dur = 5 SECONDS
	var/self_stun_dur = 5 SECONDS
	var/hit_someone = FALSE
	var/charge_running = FALSE
	var/list/ravox_cries = list(
		"Во славу Равокса!",
		"Равокс, веди меня в битву!",
		"Равокс, узри мою доблесть!",
		"Во имя Равокса, сразись со мной!"
	)

/datum/special_intent/martyr_ravox_charge/_reset()
	hit_someone = FALSE
	charge_running = FALSE
	dam = 0
	. = ..()

/datum/special_intent/martyr_ravox_charge/process_attack()
	SHOULD_CALL_PARENT(FALSE)

	if(!howner)
		return
	if(!(howner.mobility_flags & MOBILITY_STAND))
		to_chat(howner, span_warning("Мне нужно стоять на ногах, чтобы совершить рывок!"))
		return
	if(!click_loc)
		return
	if(!check_range(howner, click_loc))
		return
	if(!_do_after())
		return
	if(!apply_cost(howner))
		return

	var/turf/start = get_turf(howner)
	var/turf/finish = click_loc
	if(!start || !finish)
		return
	if(start == finish)
		return

	var/obj/item/rogueweapon/W = iparent
	var/scalemod = max(((howner.STASTR + howner.STACON + howner.STAWIL) / 30), 1)
	dam = W.force_dynamic * scalemod * 1.25

	_add_log()
	_reset()
	charge_running = TRUE

	howner.setDir(get_dir(howner, finish))
	howner.say(pick(ravox_cries))
	playsound(howner, sfx_pre_delay, 100, TRUE)

	apply_cooldown(cooldown)
	continue_charge()

/datum/special_intent/martyr_ravox_charge/proc/continue_charge()
	if(!charge_running || !howner || QDELETED(howner))
		return
	if(!click_loc)
		charge_running = FALSE
		return

	var/turf/current = get_turf(howner)
	var/turf/finish = click_loc

	if(!current || !finish)
		charge_running = FALSE
		return

	new /obj/effect/temp_visual/ravox_charge_step(current)

	if(current == finish)
		charge_running = FALSE
		resolve_charge_impact()
		return

	var/next_dir = get_dir(current, finish)
	var/turf/next_turf = get_step(current, next_dir)

	if(!next_turf || next_turf.density)
		charge_running = FALSE
		resolve_charge_impact()
		return

	for(var/mob/living/L in next_turf)
		if(L == howner)
			continue
		if(QDELETED(L))
			continue

		hit_someone = TRUE
		L.Knockdown(knockdown_dur)
		L.OffBalance(3 SECONDS)
		L.apply_status_effect(/datum/status_effect/debuff/exposed, 4 SECONDS)

		if(L.mobility_flags & MOBILITY_STAND)
			apply_generic_weapon_damage(L, dam, "slash", BODY_ZONE_CHEST, bclass = BCLASS_CHOP)

		var/turf/throwtarget = get_edge_target_turf(howner, get_dir(howner, get_step_away(L, howner)))
		if(throwtarget)
			L.safe_throw_at(throwtarget, 1, 1, howner, force = MOVE_FORCE_STRONG)

		charge_running = FALSE
		resolve_charge_impact()
		return

	howner.setDir(next_dir)
	howner.forceMove(next_turf)
	howner.Immobilize(0.15 SECONDS)

	addtimer(CALLBACK(src, PROC_REF(continue_charge)), 1)

/datum/special_intent/martyr_ravox_charge/proc/resolve_charge_impact()
	if(!howner || QDELETED(howner))
		return

	var/turf/impact_center = get_turf(howner)
	if(impact_center)
		new /obj/effect/temp_visual/ravox_impact(impact_center)

	_clear_grid()
	_assign_grid_indexes()
	_create_grid()

	var/list/turfs = affected_turfs[0]
	if(!length(turfs))
		if(howner)
			howner.Knockdown(self_knockdown_dur)
			howner.Stun(self_stun_dur)
		return

	for(var/turf/T in turfs)
		var/obj/effect/temp_visual/special_intent/fx = new (T, fade_delay)
		fx.icon = _icon
		fx.icon_state = post_icon_state

	for(var/turf/T in turfs)
		apply_hit(T)

	if(sfx_post_delay)
		playsound(howner, sfx_post_delay, 100, TRUE)

	if(!hit_someone)
		howner.visible_message(
			span_warning("[howner] с грохотом падает на землю после неудачного рывка!"),
			span_warning("Я никого не сшибаю, падаю наземь и на миг теряю всякую боеспособность!")
		)
		howner.Knockdown(self_knockdown_dur)
		howner.Stun(self_stun_dur)

/datum/special_intent/martyr_ravox_charge/_create_grid()
	affected_turfs[0] = list()

	var/turf/origin = get_turf(howner)
	if(!origin)
		return

	for(var/list/l in tile_coordinates)
		var/dx = l[1]
		var/dy = l[2]

		var/turf/step = locate(origin.x + dx, origin.y + dy, origin.z)
		if(step && isturf(step) && !step.density)
			affected_turfs[0] += step

/datum/special_intent/martyr_ravox_charge/apply_hit(turf/T)
	for(var/mob/living/L in get_hearers_in_view(0, T))
		if(L == howner)
			continue

		hit_someone = TRUE

		L.Knockdown(knockdown_dur)
		L.OffBalance(3 SECONDS)
		L.apply_status_effect(/datum/status_effect/debuff/exposed, 4 SECONDS)

		if(L.mobility_flags & MOBILITY_STAND)
			apply_generic_weapon_damage(L, dam, "slash", BODY_ZONE_CHEST, bclass = BCLASS_CHOP)

		var/turf/throwtarget = get_edge_target_turf(howner, get_dir(howner, get_step_away(L, howner)))
		if(throwtarget)
			L.safe_throw_at(throwtarget, 1, 1, howner, force = MOVE_FORCE_STRONG)

	..()



#define MARTYR_MALUM_WAVE2_DELAY 3 SECONDS

/datum/special_intent/martyr_malum_hammerfall
	name = "Malum's Hammerfall"
	desc = "Сокрушающий удар по земле перед собой. Спустя миг с небес падает молот Малума, повторно поражая ту же область и сильно повреждая какие-либо стены и укрепления."
	tile_coordinates = list(
		list(-1,0), list(0,0), list(1,0),
		list(-1,1), list(0,1), list(1,1),
		list(-1,2), list(0,2), list(1,2),

		list(-1,0, MARTYR_MALUM_WAVE2_DELAY), list(0,0, MARTYR_MALUM_WAVE2_DELAY), list(1,0, MARTYR_MALUM_WAVE2_DELAY),
		list(-1,1, MARTYR_MALUM_WAVE2_DELAY), list(0,1, MARTYR_MALUM_WAVE2_DELAY), list(1,1, MARTYR_MALUM_WAVE2_DELAY),
		list(-1,2, MARTYR_MALUM_WAVE2_DELAY), list(0,2, MARTYR_MALUM_WAVE2_DELAY), list(1,2, MARTYR_MALUM_WAVE2_DELAY)
	)

	use_clickloc = FALSE
	respect_adjacency = TRUE
	respect_dir = TRUE

	delay = 1.1 SECONDS
	fade_delay = 0.6 SECONDS

	pre_icon_state = "trap"
	post_icon_state = "strike"

	sfx_pre_delay = 'sound/combat/ground_smash_start.ogg'
	sfx_post_delay = 'sound/combat/ground_smash1.ogg'

	cooldown = 60 SECONDS
	stamcost = 25

	var/current_wave = 0
	var/self_immob_dur = 1 SECONDS
	var/first_wave_dam = 0
	var/second_wave_dam = 0
	var/fire_stacks_first = 5
	var/fire_stacks_second = 3
	var/slow_dur = 4
	var/structure_damage = 450
	var/scorched_duration = 15 SECONDS

	var/list/malum_cries = list(
		"Малум, сокруши их в горне войны!",
		"Пусть пламя и молот Малума падут на вас!",
		"Малум, яви свою кузницу на поле брани!",
		"В горниле Малума вы будете перекованы в прах!"
	)

/datum/special_intent/martyr_malum_hammerfall/_reset()
	current_wave = 0
	first_wave_dam = 0
	second_wave_dam = 0
	. = ..()

/datum/special_intent/martyr_malum_hammerfall/process_attack()
	var/obj/item/rogueweapon/W = iparent
	var/scalemod = max(((howner.STASTR + howner.STACON + howner.STAWIL) / 30), 1)

	first_wave_dam = W.force_dynamic * scalemod * 1.0
	second_wave_dam = W.force_dynamic * scalemod * 1.35

	. = ..()

/datum/special_intent/martyr_malum_hammerfall/_process_grid(list/turfs, newdelay)
	current_wave++
	. = ..()

/datum/special_intent/martyr_malum_hammerfall/on_create()
	. = ..()
	howner.Immobilize(self_immob_dur)
	howner.apply_status_effect(/datum/status_effect/debuff/clickcd, self_immob_dur)
	howner.say(pick(malum_cries))

/datum/special_intent/martyr_malum_hammerfall/pre_delay(list/turfs, newdelay)
	for(var/turf/T in turfs)
		new /obj/effect/temp_visual/lavastaff(T)
	. = ..()

/datum/special_intent/martyr_malum_hammerfall/apply_hit(turf/T)
	switch(current_wave)
		if(1)
			if(!locate(/obj/effect/malum_scorched_ground) in T)
				new /obj/effect/malum_scorched_ground(T, scorched_duration)

			for(var/mob/living/L in get_hearers_in_view(0, T))
				if(L == howner)
					continue

				L.Slowdown(slow_dur)
				L.adjust_fire_stacks(fire_stacks_first)
				L.ignite_mob()

				if(L.mobility_flags & MOBILITY_STAND)
					apply_generic_weapon_damage(L, first_wave_dam, "fire", BODY_ZONE_CHEST, bclass = BCLASS_BLUNT)

			playsound(T, pick('sound/combat/ground_smash1.ogg','sound/combat/ground_smash2.ogg','sound/combat/ground_smash3.ogg'), 100, TRUE)

		if(2)
			var/turf/from_sky = locate(T.x, T.y + 6, T.z)
			if(from_sky)
				from_sky.Beam(T, icon_state = "lightning[rand(1,12)]", time = 4)

			new /obj/effect/temp_visual/malum_forge_impact(T)
			new /obj/effect/temp_visual/malum_forge_burst(T)

			for(var/mob/living/carbon/C in viewers(7, T))
				shake_camera(C, 4, 4)

			for(var/mob/living/L in get_hearers_in_view(0, T))
				if(L == howner)
					continue

				L.adjust_fire_stacks(fire_stacks_second)
				L.ignite_mob()
				L.Knockdown(1 SECONDS)
				L.apply_status_effect(/datum/status_effect/debuff/exposed, 3 SECONDS)

				if(L.mobility_flags & MOBILITY_STAND)
					apply_generic_weapon_damage(L, second_wave_dam, "fire", BODY_ZONE_CHEST, bclass = BCLASS_BLUNT, no_pen = TRUE)

			for(var/obj/structure/S in T)
				if(!istype(S, /obj/structure/flora/newbranch))
					S.take_damage(structure_damage, BRUTE, "blunt", 1)

			for(var/turf/closed/wall/W in range(0, T))
				W.take_damage(structure_damage, BRUTE, "blunt", 1)

			for(var/turf/closed/mineral/M in range(0, T))
				M.lastminer = howner
				M.take_damage(structure_damage, BRUTE, "blunt", 1)

			playsound(T, 'sound/items/bsmithfail.ogg', 100, TRUE)
			playsound(T, 'sound/combat/ground_smash1.ogg', 100, TRUE)

	..()

/datum/special_intent/martyr_malum_hammerfall/_create_grid()
	var/turf/origin = use_clickloc ? click_loc : get_step(get_turf(howner), howner.dir)
	if(!origin)
		return

	for(var/list/l in tile_coordinates)
		var/dx = l[1]
		var/dy = l[2]
		var/dtimer

		if(LAZYACCESS(l, 3))
			dtimer = l[3]

		if(respect_dir)
			switch(howner.dir)
				if(SOUTH)
					dx = -dx
					dy = -dy
				if(WEST)
					var/holder = dx
					dx = -dy
					dy = holder
				if(EAST)
					var/holder = dx
					dx = dy
					dy = -holder

		var/turf/step = locate(origin.x + dx, origin.y + dy, origin.z)
		if(step && isturf(step))
			var/list/timerlist
			if(dtimer)
				timerlist = affected_turfs[dtimer]
				if(!timerlist)
					affected_turfs[dtimer] = list()
					timerlist = affected_turfs[dtimer]
				timerlist.Add(step)
			else
				timerlist = affected_turfs[0]
				timerlist.Add(step)

#undef MARTYR_MALUM_WAVE2_DELAY

/datum/special_intent/martyr_abyssor_harpoon
	name = "Abyssor's Harpoon"
	desc = "Ты бросаешь трезубец в сторону курсора. Первый задетый враг оказывается пронзен и притягивается к тебе. Если трезубец никого не находит, то возвращается обратно."
	use_clickloc = TRUE
	respect_adjacency = FALSE
	respect_dir = FALSE
	cooldown = 30 SECONDS
	stamcost = 20
	range = 9

	var/hook_damage = 0
	var/final_damage = 0
	var/flight_delay = 1
	var/reel_delay = 1
	var/max_range = 9
	var/active_cast = FALSE

	var/base_fatdrain = 10
	var/depth_bends_dizzy = 10
	var/depth_bends_blur = 20

	var/mob/living/hooked_target
	var/obj/effect/abyssor_trident_flight/flight_fx

	var/saved_alpha = 255
	var/saved_invisibility = 0
	var/original_slot = null

	var/turf/throw_target
	var/final_wave_length = 4

	var/list/abyssor_cries = list(
		"Поймай мне добычу, трезубец!",
		"Абиссор требует свое!"
	)

/datum/special_intent/martyr_abyssor_harpoon/_reset()
	active_cast = FALSE
	hooked_target = null
	original_slot = null
	throw_target = null

	if(flight_fx)
		qdel(flight_fx)
		flight_fx = null

	saved_alpha = 255
	saved_invisibility = 0

	hook_damage = 0
	final_damage = 0
	. = ..()

/datum/special_intent/martyr_abyssor_harpoon/process_attack()
	SHOULD_CALL_PARENT(FALSE)

	if(!howner || !iparent)
		return

	if(active_cast)
		return

	if(!(howner.mobility_flags & MOBILITY_STAND))
		to_chat(howner, span_warning("Мне нужно стоять на ногах, чтобы метнуть трезубец!"))
		return

	if(!click_loc)
		return

	if(!check_range(howner, click_loc))
		return

	if(!_do_after())
		return

	if(!apply_cost(howner))
		return

	var/turf/start_turf = get_turf(howner)
	if(!start_turf)
		return

	throw_target = click_loc
	if(!throw_target)
		return

	var/obj/item/rogueweapon/W = iparent
	var/scalemod = max(((howner.STASTR + howner.STAPER + howner.STAWIL) / 30), 1)

	hook_damage = W.force_dynamic * scalemod * 0.7
	final_damage = W.force_dynamic * scalemod * 1.45

	_add_log()
	_reset()
	active_cast = TRUE
	throw_target = click_loc

	howner.setDir(get_dir(start_turf, throw_target))

	spawn_flight_visual()
	hide_weapon()

	howner.say(pick(abyssor_cries))
	playsound(howner, 'sound/foley/bubb (5).ogg', 100, TRUE)

	apply_cooldown(cooldown)
	continue_outbound(start_turf, max_range)

/datum/special_intent/martyr_abyssor_harpoon/proc/hide_weapon()
	var/obj/item/rogueweapon/spear/partizan/martyr/W = iparent
	if(!W || !flight_fx || !howner)
		return

	saved_alpha = W.alpha
	saved_invisibility = W.invisibility

	if(length(howner.held_items) >= 1 && howner.held_items[1] == W)
		original_slot = 1
	else if(length(howner.held_items) >= 2 && howner.held_items[2] == W)
		original_slot = 2
	else
		original_slot = null

	W.is_being_thrown_by_special = TRUE

	howner.temporarilyRemoveItemFromInventory(W, TRUE)
	W.forceMove(flight_fx)
	W.alpha = 0
	W.invisibility = INVISIBILITY_ABSTRACT

	howner.regenerate_icons()

/datum/special_intent/martyr_abyssor_harpoon/proc/restore_weapon()
	var/obj/item/rogueweapon/spear/partizan/martyr/W = iparent
	if(!W)
		return

	W.alpha = saved_alpha
	W.invisibility = saved_invisibility
	W.is_being_thrown_by_special = FALSE

	if(howner && !QDELETED(howner))
		W.forceMove(get_turf(howner))
		if(!howner.put_in_hands(W))
			W.forceMove(get_turf(howner))
	else
		if(flight_fx && !QDELETED(flight_fx))
			W.forceMove(get_turf(flight_fx))

	if(howner)
		howner.regenerate_icons()

/datum/special_intent/martyr_abyssor_harpoon/proc/spawn_flight_visual()
	var/obj/item/rogueweapon/W = iparent
	var/turf/T = get_turf(howner)
	if(!W || !T)
		return

	flight_fx = new /obj/effect/abyssor_trident_flight(T)
	flight_fx.icon = W.icon
	flight_fx.icon_state = W.icon_state
	if(throw_target)
		flight_fx.dir = get_dir(T, throw_target)
	else
		flight_fx.dir = howner.dir

/datum/special_intent/martyr_abyssor_harpoon/proc/continue_outbound(turf/current_turf, remaining_range)
	if(!active_cast || !howner || QDELETED(howner))
		cleanup_cast()
		return

	if(!current_turf || remaining_range <= 0)
		begin_return()
		return

	if(!throw_target)
		begin_return()
		return

	if(current_turf == throw_target)
		begin_return()
		return

	var/turf/next_turf = get_step_towards(current_turf, throw_target)
	if(!next_turf || next_turf == current_turf)
		begin_return()
		return

	new /obj/effect/temp_visual/abyssor_trident_trail(next_turf)

	if(flight_fx)
		flight_fx.forceMove(next_turf)
		flight_fx.dir = get_dir(current_turf, next_turf)

	var/mob/living/found_target = null
	for(var/mob/living/L in next_turf)
		if(L == howner)
			continue
		if(QDELETED(L))
			continue
		found_target = L
		break

	if(found_target)
		hooked_target = found_target
		on_hook_target()
		return

	if(next_turf.density)
		begin_return()
		return

	addtimer(CALLBACK(src, PROC_REF(continue_outbound), next_turf, remaining_range - 1), flight_delay)

/datum/special_intent/martyr_abyssor_harpoon/proc/apply_depth_bends(mob/living/target)
	if(!target || QDELETED(target))
		return

	if(istype(target, /mob/living/carbon))
		var/mob/living/carbon/C = target
		if(C.patron?.type != /datum/patron/divine/abyssor)
			var/fatdrain = 0
			if(howner)
				fatdrain = howner.get_skill_level(/datum/skill/magic/holy) * base_fatdrain
			if(fatdrain <= 0)
				fatdrain = 20
			C.stamina_add(fatdrain)

	target.Dizzy(depth_bends_dizzy)
	target.blur_eyes(depth_bends_blur)
	target.emote("drown")

/datum/special_intent/martyr_abyssor_harpoon/proc/on_hook_target()
	if(!hooked_target || QDELETED(hooked_target))
		begin_return()
		return

	var/turf/target_turf = get_turf(hooked_target)
	if(!target_turf)
		begin_return()
		return

	if(flight_fx)
		flight_fx.forceMove(target_turf)
		flight_fx.layer = ABOVE_MOB_LAYER

	new /obj/effect/temp_visual/abyssor_trident_hit(target_turf)

	hooked_target.visible_message(
		span_warning("[hooked_target] оказывается пронзен трезубцем, который начинает его тянуть к мученику!"),
		span_userdanger("Трезубец впивается в меня и тянет к мученику!")
	)

	if(hooked_target.mobility_flags & MOBILITY_STAND)
		apply_generic_weapon_damage(hooked_target, hook_damage, "stab", BODY_ZONE_CHEST, bclass = BCLASS_STAB)

	apply_depth_bends(hooked_target)
	hooked_target.Immobilize(0.6 SECONDS)
	hooked_target.apply_status_effect(/datum/status_effect/debuff/exposed, 4 SECONDS)

	playsound(target_turf, 'sound/combat/sidesweep_hit.ogg', 100, TRUE)

	continue_reel_target()

/datum/special_intent/martyr_abyssor_harpoon/proc/continue_reel_target()
	if(!active_cast || !howner || QDELETED(howner))
		cleanup_cast()
		return

	if(!hooked_target || QDELETED(hooked_target))
		begin_return()
		return

	var/turf/owner_turf = get_turf(howner)
	var/turf/target_turf = get_turf(hooked_target)

	if(!owner_turf || !target_turf)
		begin_return()
		return

	if(target_turf.z != owner_turf.z)
		begin_return()
		return

	if(get_dist(hooked_target, howner) <= 1)
		finish_reel()
		return

	var/turf/next_turf = get_step_towards(target_turf, owner_turf)
	if(!next_turf || next_turf == target_turf)
		finish_reel()
		return

	if(next_turf.density)
		finish_reel()
		return

	for(var/mob/living/L in next_turf)
		if(L == hooked_target)
			continue
		if(L == howner)
			continue
		if(QDELETED(L))
			continue
		finish_reel()
		return

	new /obj/effect/temp_visual/abyssor_trident_reel(next_turf)

	hooked_target.forceMove(next_turf)
	hooked_target.Immobilize(0.2 SECONDS)

	if(flight_fx)
		flight_fx.forceMove(next_turf)
		flight_fx.dir = get_dir(target_turf, next_turf)

	addtimer(CALLBACK(src, PROC_REF(continue_reel_target)), reel_delay)

/datum/special_intent/martyr_abyssor_harpoon/proc/finish_reel()
	if(!active_cast)
		return
	if(!howner || QDELETED(howner))
		cleanup_cast()
		return

	var/turf/owner_turf = get_turf(howner)
	if(!owner_turf)
		cleanup_cast()
		return

	var/turf/wave_target = throw_target
	if(hooked_target && !QDELETED(hooked_target))
		wave_target = get_turf(hooked_target)

	if(!wave_target)
		wave_target = get_step(owner_turf, howner.dir)

	if(!wave_target)
		cleanup_cast()
		return

	var/list/impact_turfs = list()
	var/turf/current = owner_turf

	for(var/i in 1 to final_wave_length)
		var/turf/next_turf = get_step_towards(current, wave_target)
		if(!next_turf || next_turf == current)
			break
		if(next_turf.density)
			break

		impact_turfs += next_turf
		current = next_turf

	for(var/turf/T in impact_turfs)
		new /obj/effect/temp_visual/abyssor_trident_finish(T)

	for(var/turf/T in impact_turfs)
		apply_hit(T)

	playsound(owner_turf, 'sound/foley/bubb (5).ogg', 100, TRUE)

	cleanup_cast()

/datum/special_intent/martyr_abyssor_harpoon/apply_hit(turf/T)
	for(var/mob/living/L in get_hearers_in_view(0, T))
		if(L == howner)
			continue

		apply_depth_bends(L)
		L.apply_status_effect(/datum/status_effect/debuff/vulnerable, 4 SECONDS)
		L.apply_status_effect(/datum/status_effect/debuff/exposed, 3 SECONDS)

		if(L.mobility_flags & MOBILITY_STAND)
			apply_generic_weapon_damage(L, final_damage, "stab", BODY_ZONE_CHEST, bclass = BCLASS_PICK)

		L.visible_message(
			span_danger("[L] пронзен трезубцем!"),
			span_userdanger("Меня пронзают трезубцем!")
		)

	..()

/datum/special_intent/martyr_abyssor_harpoon/proc/begin_return()
	if(!active_cast)
		return

	if(!flight_fx || !howner || QDELETED(howner))
		cleanup_cast()
		return

	continue_return()

/datum/special_intent/martyr_abyssor_harpoon/proc/continue_return()
	if(!active_cast || !howner || QDELETED(howner))
		cleanup_cast()
		return

	if(!flight_fx)
		cleanup_cast()
		return

	var/turf/current_turf = get_turf(flight_fx)
	var/turf/owner_turf = get_turf(howner)

	if(!current_turf || !owner_turf)
		cleanup_cast()
		return

	if(current_turf == owner_turf)
		cleanup_cast()
		return

	var/turf/next_turf = get_step_towards(current_turf, owner_turf)
	if(!next_turf || next_turf == current_turf)
		cleanup_cast()
		return

	new /obj/effect/temp_visual/abyssor_trident_trail(next_turf)

	if(flight_fx)
		flight_fx.forceMove(next_turf)
		flight_fx.dir = get_dir(current_turf, next_turf)

	if(!hooked_target)
		var/mob/living/found_target = null
		for(var/mob/living/L in next_turf)
			if(L == howner)
				continue
			if(QDELETED(L))
				continue
			found_target = L
			break

		if(found_target)
			hooked_target = found_target
			on_hook_target()
			return

	if(next_turf == owner_turf)
		cleanup_cast()
		return

	addtimer(CALLBACK(src, PROC_REF(continue_return)), flight_delay)

/datum/special_intent/martyr_abyssor_harpoon/proc/cleanup_cast()
	restore_weapon()

	if(flight_fx)
		qdel(flight_fx)
		flight_fx = null

	hooked_target = null
	active_cast = FALSE
	original_slot = null
	throw_target = null

/obj/item/rogueweapon/spear/partizan/martyr/attack(mob/living/target, mob/living/user)
	if(is_being_thrown_by_special)
		return FALSE
	return ..()

/obj/item/rogueweapon/spear/partizan/martyr/afterattack(atom/target, mob/user, proximity_flag, click_parameters)
	if(is_being_thrown_by_special)
		return FALSE
	return ..()

/obj/item/rogueweapon/spear/partizan/martyr/attack_self(mob/user)
	if(is_being_thrown_by_special)
		return FALSE
	return ..()

/obj/effect/dendor_vine_hold/Initialize(mapload, duration_override = 8.4 SECONDS)
	. = ..()
	QDEL_IN(src, duration_override)



/datum/special_intent/martyr_dendor_vine_reap
	name = "Dendor's Vine Reap"
	desc = "Ты проводишь косой перед собой, и из земли вырываются лианы Дендора. Они хватают своих жертв за ноги и не дают им некоторое время двигаться. "
	tile_coordinates = list(
		list(-1,0), list(0,0), list(1,0),
		list(-2,1), list(-1,1), list(0,1), list(1,1), list(2,1)
	)

	use_clickloc = FALSE
	respect_adjacency = TRUE
	respect_dir = TRUE

	delay = 0.5 SECONDS
	fade_delay = 0.4 SECONDS

	pre_icon_state = "trap"
	post_icon_state = "sweep_fx"

	sfx_pre_delay = 'sound/combat/parry/bladed/bladedsmall (3).ogg'
	sfx_post_delay = 'modular_twilight_axis/sound/misc/vines.ogg'

	cooldown = 45 SECONDS
	stamcost = 25

	var/base_dam = 0
	var/constrict_dam = 0
	var/list/entangled_targets = list()

	var/self_commit = 0.7 SECONDS

	var/vine_begin_delay = 1.5 SECONDS
	var/vine_mid_duration = 7 SECONDS
	var/vine_end_duration = 0.3 SECONDS
	var/entangle_dur = 7.3 SECONDS

	var/exposed_dur = 4 SECONDS
	var/vulnerable_dur = 5 SECONDS

	var/list/dendor_cries = list(
		"Дендор, оплети их корнями и лозой!",
		"Да восстанет чаща Дендора против вас!",
		"Дендор, свяжи их волей леса!",
		"Пусть лианы Дендора сомкнутся на вас!"
	)

/datum/special_intent/martyr_dendor_vine_reap/_reset()
	base_dam = 0
	constrict_dam = 0
	entangled_targets = list()
	. = ..()

/datum/special_intent/martyr_dendor_vine_reap/process_attack()
	var/obj/item/rogueweapon/W = iparent
	var/scalemod = max(((howner.STASTR + howner.STAPER + howner.STAWIL) / 30), 1)

	base_dam = W.force_dynamic * scalemod * 0.8
	constrict_dam = W.force_dynamic * scalemod * 1.05

	. = ..()

/datum/special_intent/martyr_dendor_vine_reap/on_create()
	. = ..()
	howner.Immobilize(self_commit)
	howner.say(pick(dendor_cries))

/datum/special_intent/martyr_dendor_vine_reap/apply_hit(turf/T)
	for(var/mob/living/L in get_hearers_in_view(0, T))
		if(L == howner)
			continue
		if(L in entangled_targets)
			continue

		entangled_targets += L

		if(L.mobility_flags & MOBILITY_STAND)
			apply_generic_weapon_damage(L, base_dam, "slash", BODY_ZONE_CHEST, bclass = BCLASS_CUT)

		L.apply_status_effect(/datum/status_effect/debuff/exposed, exposed_dur)

		var/turf/mark_turf = get_turf(L)
		if(mark_turf)
			new /obj/effect/temp_visual/dendor_vines_begin(mark_turf)

		L.visible_message(
			span_warning("Под [L] начинают стремительно прорастать лианы Дендора!"),
			span_userdanger("Подо мной прорастают лианы!")
		)

		addtimer(CALLBACK(src, PROC_REF(begin_entangle), L), vine_begin_delay)

	..()

/datum/special_intent/martyr_dendor_vine_reap/proc/begin_entangle(mob/living/L)
	if(!howner || QDELETED(howner))
		return
	if(!L || QDELETED(L))
		return
	if(L.stat == DEAD)
		return

	var/turf/T = get_turf(L)
	if(T)
		new /obj/effect/temp_visual/dendor_vines_mid(T)

	L.Immobilize(entangle_dur)
	L.apply_status_effect(/datum/status_effect/debuff/vulnerable, vulnerable_dur)
	L.apply_status_effect(/datum/status_effect/debuff/exposed, exposed_dur)

	if(L.mobility_flags & MOBILITY_STAND)
		apply_generic_weapon_damage(L, constrict_dam, "slash", BODY_ZONE_CHEST, bclass = BCLASS_CHOP)

	L.visible_message(
		span_danger("Лианы Дендора резко смыкаются вокруг [L]!"),
		span_userdanger("Лианы резко стягиваются на мне и сковывают меня!")
	)

	if(T)
		playsound(T, sfx_post_delay, 70, TRUE)

	addtimer(CALLBACK(src, PROC_REF(begin_release), L), vine_mid_duration)

/datum/special_intent/martyr_dendor_vine_reap/proc/begin_release(mob/living/L)
	if(!L || QDELETED(L))
		return
	if(L.stat == DEAD)
		return

	var/turf/T = get_turf(L)
	if(T)
		new /obj/effect/temp_visual/dendor_vines_end(T)
