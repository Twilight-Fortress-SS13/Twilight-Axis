// /datum/component/combo_core/soundbreaker
// Moves ALL soundbreaker globals into this component.
// External systems talk via signals ONLY:
// - spells prime note
// - aftermiss/resolveAdjacentClick consume prepared
// - defense hook (riff proc)
// - projectile hit (note projectile)
// - status on_remove clears visuals/history
//
// Inside component: direct procs.

/proc/soundbreaker_get_component(mob/living/user)
	if(!isliving(user))
		return null

	var/datum/component/combo_core/soundbreaker/C = user.GetComponent(/datum/component/combo_core/soundbreaker)
	if(!C)
		C = user.AddComponent(/datum/component/combo_core/soundbreaker)
	return C

/proc/soundbreaker_prime_note(mob/living/user, note_id, damage_mult, damage_type, note_name)
	var/datum/component/combo_core/soundbreaker/C = soundbreaker_get_component(user)
	return C ? C.PrimeNote(note_id, damage_mult, damage_type, note_name) : FALSE

/proc/soundbreaker_get_damage_flag(bclass, damage_type)
	switch(bclass)
		if(BCLASS_BLUNT, BCLASS_SMASH, BCLASS_TWIST, BCLASS_PUNCH)
			return "blunt"
		if(BCLASS_CHOP, BCLASS_CUT, BCLASS_LASHING, BCLASS_PUNISH)
			return "slash"
		if(BCLASS_PICK, BCLASS_STAB, BCLASS_PIERCE)
			return "stab"

	return "blunt"

/proc/soundbreaker_riff_defense_success(mob/living/defender)
	if(!isliving(defender))
		return
	SEND_SIGNAL(defender, COMSIG_SOUNDBREAKER_RIFF_DEFENSE_SUCCESS)

/datum/component/combo_core/soundbreaker
	// Inherit engine
	parent_type = /datum/component/combo_core

	// cached lists for overhead (remove mob vars)
	var/list/note_history

	// proxy weapon (remove mob var)
	var/obj/item/soundbreaker_proxy/proxy

	var/list/granted_spells = list()
	var/spells_granted = FALSE
	var/last_input_dir = SOUTH
	var/list/note_mas = list()

/datum/component/combo_core/soundbreaker/Initialize(_combo_window, _max_history)
	. = ..(_combo_window || SB_COMBO_WINDOW, _max_history || SB_MAX_HISTORY)
	if(. == COMPONENT_INCOMPATIBLE)
		return .

	note_history = list()
	RegisterSignal(owner, COMSIG_SOUNDBREAKER_PRIME_NOTE, PROC_REF(_sig_prime_note))
	RegisterSignal(owner, COMSIG_ATTACK_TRY_CONSUME, PROC_REF(_sig_try_consume_prepared))
	RegisterSignal(owner, COMSIG_SOUNDBREAKER_RIFF_DEFENSE_SUCCESS, PROC_REF(_sig_riff_defense_success))
	RegisterSignal(owner, COMSIG_SOUNDBREAKER_NOTE_PROJECTILE_HIT, PROC_REF(_sig_note_projectile_hit))
	RegisterSignal(owner, COMSIG_SOUNDBREAKER_COMBO_CLEARED, PROC_REF(_sig_combo_cleared))
	GrantSpells()

/datum/component/combo_core/soundbreaker/Destroy(force)
	if(owner)
		UnregisterSignal(owner, COMSIG_SOUNDBREAKER_PRIME_NOTE)
		UnregisterSignal(owner, COMSIG_ATTACK_TRY_CONSUME)
		UnregisterSignal(owner, COMSIG_SOUNDBREAKER_RIFF_DEFENSE_SUCCESS)
		UnregisterSignal(owner, COMSIG_SOUNDBREAKER_NOTE_PROJECTILE_HIT)
		UnregisterSignal(owner, COMSIG_SOUNDBREAKER_COMBO_CLEARED)
		RevokeSpells()

	if(proxy)
		if(!QDELETED(proxy))
			proxy.force = 0
			proxy.last_attack_target = null
			qdel(proxy)
	proxy = null

	note_history = null
	return ..()

// ----------------- combo_core overrides -----------------
/datum/component/combo_core/soundbreaker/DefineRules()
	RegisterRule("echo",        list(1,1,1),        10,  PROC_REF(_cb_echo))
	RegisterRule("tempo",       list(2,2,2),        30,  PROC_REF(_cb_tempo))
	RegisterRule("harmonic",    list(3,1,2),        50,  PROC_REF(_cb_harmonic))
	RegisterRule("reverb_cut",  list(4,2,1,3),      80,  PROC_REF(_cb_reverb_cut))
	RegisterRule("bass_drop",   list(4,1,2,3),      90,  PROC_REF(_cb_bass_drop))
	RegisterRule("syncopation", list(3,2,4,1),      70,  PROC_REF(_cb_syncopation))
	RegisterRule("crescendo",   list(2,3,1,3,2),   110,  PROC_REF(_cb_crescendo))
	RegisterRule("overture",   	list(1,4,3,4,2),   100,  PROC_REF(_cb_overture))

/datum/component/combo_core/soundbreaker/proc/_cb_overture(rule_id, mob/living/target, zone)
	if(!owner || !target)
		return FALSE
	ComboOverture(target)
	return TRUE

/datum/component/combo_core/soundbreaker/proc/_cb_crescendo(rule_id, mob/living/target, zone)
	ComboCrescendo(target)
	return TRUE

/datum/component/combo_core/soundbreaker/proc/_cb_bass_drop(rule_id, mob/living/target, zone)
	ComboBassDrop(target)
	return TRUE

/datum/component/combo_core/soundbreaker/proc/_cb_reverb_cut(rule_id, mob/living/target, zone)
	ComboReverbCut(target)
	return TRUE

/datum/component/combo_core/soundbreaker/proc/_cb_syncopation(rule_id, mob/living/target, zone)
	ComboSyncopation(target)
	return TRUE

/datum/component/combo_core/soundbreaker/proc/_cb_harmonic(rule_id, mob/living/target, zone)
	ComboHarmonicBurst(target)
	return TRUE

/datum/component/combo_core/soundbreaker/proc/_cb_tempo(rule_id, mob/living/target, zone)
	ComboTempoFlick(target)
	return TRUE

/datum/component/combo_core/soundbreaker/proc/_cb_echo(rule_id, mob/living/target, zone)
	ComboEchoBeat(target)
	return TRUE

/datum/component/combo_core/soundbreaker/OnHistoryChanged()
	UpdateNoteOverlays()

/datum/component/combo_core/soundbreaker/OnHistoryCleared(reason)
	ClearNoteIcons()

// ----------------- external signal handlers -----------------

/datum/component/combo_core/soundbreaker/proc/_sig_prime_note(datum/source, note_id, damage_mult, damage_type, note_name)
	SIGNAL_HANDLER
	if(PrimeNote(note_id, damage_mult, damage_type, note_name))
		return COMPONENT_SOUNDBREAKER_PRIMED
	return 0

/datum/component/combo_core/soundbreaker/proc/_sig_try_consume_prepared(datum/source, atom/target_atom, zone)
	SIGNAL_HANDLER

	if(!owner)
		return 0

	if(!owner.has_status_effect(/datum/status_effect/buff/soundbreaker_prepared))
		return 0

	INVOKE_ASYNC(src, PROC_REF(TryConsumePreparedAttack), target_atom, zone)
	return COMPONENT_ATTACK_CONSUMED

/datum/component/combo_core/soundbreaker/proc/_sig_riff_defense_success(datum/source)
	SIGNAL_HANDLER
	RiffOnSuccessfulDefense()
	return 0

/datum/component/combo_core/soundbreaker/proc/_sig_note_projectile_hit(datum/source, mob/living/target, damage_mult, damage_type, zone)
	SIGNAL_HANDLER
	if(!owner || QDELETED(owner))
		return 0

	var/mob/living/local_owner = owner
	INVOKE_ASYNC(src, PROC_REF(_async_note_projectile_hit), local_owner, target, damage_mult, damage_type, zone)
	return 0


/datum/component/combo_core/soundbreaker/proc/_async_note_projectile_hit(mob/living/local_owner, mob/living/target, damage_mult, damage_type, zone)
	if(!local_owner || QDELETED(local_owner) || !target)
		return

	ApplyDamage(target, damage_mult, BCLASS_PUNCH, zone, damage_type)
	OnHit(target, SOUNDBREAKER_NOTE_BARE, zone)

/datum/component/combo_core/soundbreaker/proc/_sig_combo_cleared(datum/source)
	SIGNAL_HANDLER
	ClearNoteIcons()
	ClearHistory("external_clear")
	return 0

// ----------------- Public-ish API used by shims or internal calls -----------------
/datum/component/combo_core/soundbreaker/proc/GrantSpells()
	if(spells_granted || !owner?.mind)
		return

	var/mob/living/L = owner

	RevokeSpells()
	var/list/paths = list(
		/obj/effect/proc_holder/spell/self/soundbreaker/bend,
		/obj/effect/proc_holder/spell/self/soundbreaker/bare,
		/obj/effect/proc_holder/spell/self/soundbreaker/shed,
		/obj/effect/proc_holder/spell/self/soundbreaker/riff
	)

	for(var/path in paths)
		var/obj/effect/proc_holder/spell/S = new path
		L.mind.AddSpell(S)
		granted_spells += S

	spells_granted = TRUE

/datum/component/combo_core/soundbreaker/proc/RevokeSpells()
	if(!owner)
		return

	if(!length(granted_spells))
		spells_granted = FALSE
		return

	if(owner.mind)
		for(var/obj/effect/proc_holder/spell/S as anything in granted_spells)
			if(S)
				owner.mind.RemoveSpell(S)
	else
		for(var/obj/effect/proc_holder/spell/S as anything in granted_spells)
			if(S)
				qdel(S)

	granted_spells = list()
	spells_granted = FALSE

/datum/component/combo_core/soundbreaker/ConsumeOnCombo(rule_id)
	..()
	if(owner)
		owner.apply_status_effect(/datum/status_effect/buff/soundbreaker_breaker_window,GetComboStacks())

/datum/component/combo_core/soundbreaker/proc/GetProxy()
	if(!owner)
		return null
	if(proxy && QDELETED(proxy))
		proxy = null

	if(!proxy)
		proxy = new /obj/item/soundbreaker_proxy(owner)

	return proxy

/datum/component/combo_core/soundbreaker/proc/OnHit(mob/living/target, note_id, zone = BODY_ZONE_CHEST)
	if(!owner || !note_id || !target)
		return

	var/turf/ot = get_turf(owner)
	var/turf/tt = get_turf(target)
	if(ot && tt)
		var/d = get_dir(ot, tt)
		if(d)
			last_input_dir = d
	else
		last_input_dir = owner.dir

	ShowNoteIcon(note_id)
	RegisterInput(note_id, target, zone)
	AddComboStack()
	var/new_stacks = GetComboStacks()
	var/in_rhythm = IsValidPrefix()

	if(in_rhythm && new_stacks >= 1)
		owner.apply_status_effect(/datum/status_effect/buff/soundbreaker_breaker_window, new_stacks)
	else
		owner.remove_status_effect(/datum/status_effect/buff/soundbreaker_breaker_window)

/datum/component/combo_core/soundbreaker/proc/AddComboStack()
	if(!owner)
		return
	owner.apply_status_effect(/datum/status_effect/buff/soundbreaker_combo)

/datum/component/combo_core/soundbreaker/proc/GetComboStacks()
	if(!owner)
		return 0
	var/datum/status_effect/buff/soundbreaker_combo/C = owner.has_status_effect(/datum/status_effect/buff/soundbreaker_combo)
	if(!C)
		return 0
	return C.stacks

/datum/component/combo_core/soundbreaker/proc/HasMusic()
	if(!owner)
		return FALSE

	var/obj/item/L = owner.get_item_for_held_index(1)
	var/obj/item/R = owner.get_item_for_held_index(2)

	if(istype(L, /obj/item/rogue/instrument) || istype(R, /obj/item/rogue/instrument))
		return TRUE

	if(owner.has_stress_event(/datum/stressevent/music))
		return TRUE

	return FALSE

/datum/component/combo_core/soundbreaker/proc/GetTargetTurf(atom/target_atom)
	if(!target_atom)
		return null
	if(isturf(target_atom))
		return target_atom
	return get_turf(target_atom)

/datum/component/combo_core/soundbreaker/proc/GetAimDir(atom/target_atom)
	if(!owner)
		return SOUTH
	if(!target_atom)
		return owner.dir

	var/turf/ot = get_turf(owner)
	var/turf/tt = get_turf(target_atom)
	if(!ot || !tt)
		return owner.dir

	var/d = get_dir(ot, tt)
	return d ? d : owner.dir

/datum/component/combo_core/soundbreaker/proc/FaceTurf(turf/T)
	if(!owner || !T)
		return

	var/d = GetAimDir(T)
	if(d)
		owner.setDir(d)

/datum/component/combo_core/soundbreaker/proc/GetPrimaryFromClick(atom/target_atom, turf/target_turf)
	if(isliving(target_atom))
		return target_atom
	return _first_living_on_turf(target_turf)

// ----------------- Prepared note -----------------
/datum/component/combo_core/soundbreaker/proc/NoteDisplayName(note_id)
	switch(note_id)
		if(SOUNDBREAKER_NOTE_BEND) return "Bend"
		if(SOUNDBREAKER_NOTE_BARE) return "Barre"
		if(SOUNDBREAKER_NOTE_SHED) return "Shred"
		if(SOUNDBREAKER_NOTE_RIFF) return "Riff"
	return "Unknown"

/// Returns TRUE if primed (new or refreshed)
/datum/component/combo_core/soundbreaker/proc/PrimeNote(note_id, damage_mult, damage_type, note_name)
	if(!owner || !note_id)
		return FALSE

	var/nname = note_name || NoteDisplayName(note_id)

	owner.remove_status_effect(/datum/status_effect/buff/soundbreaker_prepared)
	owner.apply_status_effect(/datum/status_effect/buff/soundbreaker_prepared, note_id, damage_mult, damage_type, nname)

	var/datum/status_effect/buff/soundbreaker_prepared/P = owner.has_status_effect(/datum/status_effect/buff/soundbreaker_prepared)
	if(!P)
		return FALSE

	P.set_payload(note_id, damage_mult, damage_type, nname)
	return TRUE

/// Consume prepared note on swing attempt.
/datum/component/combo_core/soundbreaker/proc/TryConsumePreparedAttack(atom/target_atom, zone = BODY_ZONE_CHEST)
	if(QDELETED(src))
		return

	if(!owner)
		return FALSE

	var/datum/status_effect/buff/soundbreaker_prepared/P = owner.has_status_effect(/datum/status_effect/buff/soundbreaker_prepared)
	if(!P)
		return FALSE

	var/aim_dir = GetAimDir(target_atom)
	if(ismob(target_atom))
		owner.face_atom(target_atom)
	else
		if(aim_dir)
			owner.setDir(aim_dir)

	var/note_id = P.note_id
	var/damage_mult = P.damage_mult
	var/damage_type = P.damage_type
	damage_mult *= (!HasMusic() ? 0.6 : 1)

	owner.remove_status_effect(/datum/status_effect/buff/soundbreaker_prepared)
	var/mob/living/last_hit = ExecuteNote(target_atom, aim_dir, note_id, damage_mult, damage_type, zone)
	if(last_hit)
		OnHit(last_hit, note_id, zone)
		return TRUE

	if(TryHitAtom(target_atom, damage_mult, damage_type, BCLASS_PUNCH, zone))
		return TRUE

	playsound(owner, 'sound/combat/sp_whip_whiff.ogg', 40, TRUE)
	return TRUE

/datum/component/combo_core/soundbreaker/proc/ExecuteNote(atom/target_atom, aim_dir, note_id, damage_mult, damage_type, zone = BODY_ZONE_CHEST)
	if(!owner || !note_id)
		return null
	if(!aim_dir)
		aim_dir = owner.dir

	switch(note_id)
		if(SOUNDBREAKER_NOTE_BEND)
			return NoteBendPlay(target_atom, aim_dir, damage_mult, damage_type, zone)
		if(SOUNDBREAKER_NOTE_BARE)
			return NoteBarePlay(target_atom, aim_dir, damage_mult, damage_type, zone)
		if(SOUNDBREAKER_NOTE_SHED)
			return NoteShedPlay(target_atom, aim_dir, damage_mult, damage_type, zone)
		if(SOUNDBREAKER_NOTE_RIFF)
			return NoteRiffPlay(target_atom, aim_dir, damage_mult, damage_type, zone)

	return null

// ----------------- Damage pipeline (moved from globals) -----------------
/datum/component/combo_core/soundbreaker/proc/GetAimTurf(atom/target_atom)
	if(target_atom)
		return get_turf(target_atom)
	return null

/datum/component/combo_core/soundbreaker/proc/GetDamageFlag(bclass, damage_type)
	switch(bclass)
		if(BCLASS_BLUNT, BCLASS_SMASH, BCLASS_TWIST, BCLASS_PUNCH)
			return "blunt"
		if(BCLASS_CHOP, BCLASS_CUT, BCLASS_LASHING, BCLASS_PUNISH)
			return "slash"
		if(BCLASS_PICK, BCLASS_STAB, BCLASS_PIERCE)
			return "stab"

	switch(damage_type)
		if(BRUTE) return "blunt"
		if(BURN)  return "fire"
		if(TOX)   return "bio"
		if(OXY)   return "oxy"

	return "blunt"

/// Public: apply damage multiplier to a target
/datum/component/combo_core/soundbreaker/proc/ApplyDamage(mob/living/target, damage_mult = 1, bclass = BCLASS_PUNCH, zone = BODY_ZONE_CHEST, damage_type = BRUTE, is_combo = FALSE)
	if(!owner || !target)
		return FALSE

	var/dmg = ScaleDamage(damage_mult, is_combo = is_combo)
	if(dmg <= 0)
		return FALSE

	zone = GetEffectiveHitZone(target, zone)
	if(GetComboStacks() >= 5)
		bclass = BCLASS_PIERCE
		
	var/ap = CalcAP(bclass)
	return AttackViaPipeline(target, dmg, bclass, damage_type, zone, ap)

/// Used by notes/combos when they want exact target, not random on turf
/datum/component/combo_core/soundbreaker/proc/HitSpecific(mob/living/target, damage_mult = 1, damage_type = BRUTE, bclass = BCLASS_PUNCH, zone = BODY_ZONE_CHEST)
	if(!owner || !target)
		return FALSE
	zone = TryGetZone(zone)
	return ApplyDamage(target, damage_mult, bclass, zone, damage_type)

/// Random living target on turf (excluding owner)
/datum/component/combo_core/soundbreaker/proc/HitOneOnTurf(turf/T, damage_mult = 1, damage_type = BRUTE, bclass = BCLASS_PUNCH, zone)
	if(!owner || !T)
		return null

	var/list/candidates = list()
	for(var/mob/living/L in T)
		if(L == owner)
			continue
		if(L.stat == DEAD)
			continue
		candidates += L

	if(!length(candidates))
		return null

	var/mob/living/target = pick(candidates)
	if(!zone)
		zone = TryGetZone(null)
	if(ApplyDamage(target, damage_mult, bclass, zone, damage_type))
		return target
	return null

/// Apply extra armor wear on successful hit.
/// Designed to be called AFTER a confirmed successful attack.
/datum/component/combo_core/soundbreaker/proc/apply_combo_armor_wear(
	mob/living/carbon/human/target,
	hit_zone,
	attack_flag,
	force_dynamic,
	multiplier = 1
)
	if(!target || !attack_flag || !force_dynamic)
		return

	// базовый расчёт износа
	var/wear = round(force_dynamic * multiplier)
	wear = clamp(wear, 1, 25)
	if(wear <= 0)
		return

	var/cover_flag
	switch(hit_zone)
		if(BODY_ZONE_HEAD)   cover_flag = HEAD
		if(BODY_ZONE_CHEST)  cover_flag = CHEST
		if(BODY_ZONE_L_ARM, BODY_ZONE_R_ARM) cover_flag = ARMS
		if(BODY_ZONE_L_LEG, BODY_ZONE_R_LEG) cover_flag = LEGS
		else
			return

	for(var/obj/item/clothing/C in target.contents)
		if(C.loc != target)
			continue
		if(!(C.body_parts_covered & cover_flag))
			continue
		if(!C.armor)
			continue

		var/rating = C.armor.getRating(attack_flag)
		if(!isnum(rating) || rating <= 0)
			continue

		C.take_damage(wear, BRUTE, "blunt")

/datum/component/combo_core/soundbreaker/proc/_get_stamina_pct(mob/living/L)
	if(!L)
		return 1
	if(!isnum(L.max_stamina) || L.max_stamina <= 0)
		return 1
	if(!isnum(L.stamina))
		return 1
	return clamp(L.stamina / L.max_stamina, 0, 1)

/datum/component/combo_core/soundbreaker/proc/AttackViaPipeline(mob/living/target, damage, bclass = BCLASS_PUNCH, damage_type = BRUTE, zone = null, armor_penetration = 0, params = null)
	if(!owner || !target)
		return FALSE

	zone = TryGetZone(zone)

	var/obj/item/soundbreaker_proxy/P = GetProxy()
	if(!P)
		return FALSE

	if(P.loc != owner)
		P.forceMove(owner)

	if(!islist(params))
		params = list()

	P.force = damage
	P.force_dynamic = damage
	P.damtype = damage_type
	P.thrown_bclass = bclass
	P.d_type = GetDamageFlag(bclass, damage_type)
	P.armor_penetration = armor_penetration

	var/obj/item/active = owner.get_active_held_item()
	P.name = active ? active.name : "soundbreaking strike"

	var/old_hand = owner.active_hand_index
	P.last_attack_success = FALSE
	P.last_attack_target = null
	owner.face_atom(target)
	owner.do_attack_animation(target, ATTACK_EFFECT_DISARM)
	P.melee_attack_chain(owner, target, params)
	var/success_main = P.last_attack_success

	// dual swing
	var/success_off = FALSE
	if(HAS_TRAIT(owner, TRAIT_DUALWIELDER))
		var/offhand_index = (old_hand == 1) ? 2 : 1
		var/obj/item/main_item = owner.held_items[old_hand]
		var/obj/item/off_item  = owner.held_items[offhand_index]

		var/allow_dual = FALSE
		if(!main_item && !off_item)
			allow_dual = TRUE
		else if(main_item && off_item && main_item != off_item && (istype(main_item, off_item) || istype(off_item, main_item)))
			allow_dual = TRUE

		if(allow_dual)
			if(!(owner.check_arm_grabbed(offhand_index)) && (owner.last_used_double_attack <= world.time))
				if(owner.stamina_add(2))
					owner.last_used_double_attack = world.time + 3 SECONDS
					owner.visible_message(
						span_warning("[owner] seizes an opening and strikes with [owner.p_their()] off-hand!"),
						span_green("There's an opening! I strike with my off-hand!")
					)

					owner.active_hand_index = offhand_index
					P.last_attack_success = FALSE
					P.last_attack_target = null
					owner.face_atom(target)
					owner.do_attack_animation(target, ATTACK_EFFECT_DISARM)
					P.melee_attack_chain(owner, target, params)
					success_off = P.last_attack_success

	owner.active_hand_index = old_hand
	return (success_main || success_off)

#define SB_MIN_DAMAGE_MULT 0.75
#define SB_MAX_DAMAGE_MULT 1.5

/mob/living/carbon/human/get_punch_dmg()
	var/damage
	if(STASTR > UNARMED_DAMAGE_DEFAULT || STASTR < 10)
		damage = STASTR
	else
		damage = UNARMED_DAMAGE_DEFAULT

	var/used_str = STASTR

	var/obj/G = get_item_by_slot(SLOT_GLOVES)
	if(domhand)
		used_str = get_str_arms(used_hand)

	if(used_str >= 11)
		damage = max(damage + (damage * ((used_str - 10) * 0.3)), 1)

	if(used_str <= 9)
		damage = max(damage - (damage * ((10 - used_str) * 0.1)), 1)

	if(istype(G, /obj/item/clothing/gloves/roguetown))
		var/obj/item/clothing/gloves/roguetown/GL = G
		damage = (damage * GL.unarmed_bonus)

	if(mind)
		if(mind.has_antag_datum(/datum/antagonist/werewolf))
			return 50

	damage += dna.species.punch_damage
	return damage

/datum/component/combo_core/soundbreaker/proc/GetBaseUnarmedDamage(hand_index = null)
	if(!owner)
		return 0

	if(ishuman(owner))
		var/mob/living/carbon/human/H = owner
		if(H.mind && H.mind.has_antag_datum(/datum/antagonist/werewolf))
			return 30

		var/used_str = H.get_stat(STATKEY_STR)
		if(H.domhand)
			var/hand = hand_index || H.active_hand_index
			used_str = H.get_str_arms(hand)

		var/damage
		if(H.get_stat(STATKEY_STR) > UNARMED_DAMAGE_DEFAULT || H.get_stat(STATKEY_STR) < 10)
			damage = H.get_stat(STATKEY_STR)
		else
			damage = UNARMED_DAMAGE_DEFAULT

		if(used_str >= 11)
			damage = max(damage + (damage * ((used_str - 10) * 0.33)), 1)

		if(used_str <= 9)
			damage = max(damage - (damage * ((10 - used_str) * 0.1)), 1)

		var/obj/G = H.get_item_by_slot(SLOT_GLOVES)
		if(istype(G, /obj/item/clothing/gloves/roguetown))
			var/obj/item/clothing/gloves/roguetown/GL = G
			damage = (damage * GL.unarmed_bonus)

		if(H.dna?.species)
			damage += H.dna.species.punch_damage

		return max(1, round(damage))

	return max(1, round(owner.get_stat(STATKEY_STR)))

/datum/component/combo_core/soundbreaker/proc/TryHitAtom(atom/target_atom, damage_mult = 1, damage_type = BRUTE, bclass = BCLASS_PUNCH, zone = BODY_ZONE_CHEST, params = null)
	if(!owner || !target_atom)
		return FALSE
	if(isliving(target_atom))
		return FALSE

	var/obj/item/soundbreaker_proxy/P = GetProxy()
	if(!P)
		return FALSE
	if(P.loc != owner)
		P.forceMove(owner)

	var/dmg = ScaleDamage(damage_mult) * 2
	if(dmg <= 0)
		return FALSE

	P.force = dmg
	P.force_dynamic = dmg
	P.damtype = damage_type
	P.thrown_bclass = bclass
	P.d_type = GetDamageFlag(bclass, damage_type)
	P.armor_penetration = CalcAP(bclass)

	var/obj/item/active = owner.get_active_held_item()
	P.name = active ? active.name : "soundbreaking strike"

	P.last_attack_success = FALSE
	P.last_attack_target = null

	owner.face_atom(target_atom)
	owner.do_attack_animation(target_atom, ATTACK_EFFECT_DISARM)
	P.melee_attack_chain(owner, target_atom, params)

	return P.last_attack_success

/datum/component/combo_core/soundbreaker/proc/ScaleDamage(damage_mult = 1, hand_index = null, is_combo = FALSE)
	if(!owner || damage_mult <= 0)
		return 0

	var/damage
	var/obj/item/holding = owner.get_active_held_item()
	if(holding)
		damage = holding.force
	else
		damage = GetBaseUnarmedDamage(hand_index)

	var/con = owner.get_stat(STATKEY_CON)
	var/con_bonus = (con - 10) * 0.1
	damage += damage * con_bonus

	damage *= damage_mult
	var/skill = 1
	if(holding)
		skill = owner.get_skill_level(holding.associated_skill)
	else
		skill = owner.get_skill_level(/datum/skill/combat/unarmed)
	var/music_skill = owner.get_skill_level(/datum/skill/misc/music)

	var/skill_bonus = (skill * 0.2) + (music_skill * 0.1)
	skill_bonus = clamp(skill_bonus, SB_MIN_DAMAGE_MULT, SB_MAX_DAMAGE_MULT)

	damage *= skill_bonus

	var/stacks = GetComboStacks()
	var/mult = is_combo ? 0 : 0.4
	damage += stacks * mult

	return max(1, round(damage))

#undef SB_MIN_DAMAGE_MULT
#undef SB_MAX_DAMAGE_MULT

/datum/component/combo_core/soundbreaker/proc/_pick_combo_victim_on_turf(turf/T, mob/living/primary)
	if(!T)
		return null

	if(primary && get_turf(primary) == T && primary.stat != DEAD)
		return primary

	for(var/mob/living/L in T)
		if(L == owner)
			continue
		if(L.stat == DEAD)
			continue
		return L

	return null

/datum/component/combo_core/soundbreaker/proc/CalcAP(bclass)
	if(!owner)
		return 0

	var/ap = 30
	var/stacks = GetComboStacks()
	ap += stacks * 5

	var/unarmed = owner.get_skill_level(/datum/skill/combat/unarmed)
	ap += (unarmed * 5)

	if(bclass == BCLASS_PIERCE)
		ap += 10

	return clamp(ap, 0, 100)

// ----------------- Rhythm reset -----------------

/datum/component/combo_core/soundbreaker/proc/ResetRhythm()
	if(!owner)
		return
	owner.remove_status_effect(/datum/status_effect/buff/soundbreaker_combo)
	ClearNoteIcons()
	ClearHistory("rhythm_reset")

// ----------------- small helpers -----------------
/datum/component/combo_core/soundbreaker/proc/TryGetZone(zone)
	if(zone)
		return zone
	if(owner?.zone_selected)
		return owner.zone_selected
	return BODY_ZONE_CHEST

/datum/component/combo_core/soundbreaker/proc/IsOffbalanced(mob/living/L)
	if(!L)
		return FALSE
	return L.IsOffBalanced()

/datum/component/combo_core/soundbreaker/proc/SafeOffbalance(mob/living/L, duration)
	if(!L)
		return
	L.OffBalance(duration)

/datum/component/combo_core/soundbreaker/proc/SafeSlow(mob/living/L, amount)
	if(!L)
		return
	L.Slowdown(amount)

/datum/component/combo_core/soundbreaker/proc/Knockback(mob/living/target, tiles)
	if(!owner || !target)
		return
	var/dir = get_dir(owner, target)
	var/turf/start = get_turf(target)
	var/turf/dest = get_ranged_target_turf(start, dir, tiles)
	if(dest)
		target.safe_throw_at(dest, tiles, 1, owner, force = MOVE_FORCE_EXTREMELY_STRONG)

/datum/component/combo_core/soundbreaker/proc/GetEffectiveHitZone(mob/living/target, desired_zone)
	if(!desired_zone || !owner || !target)
		return BODY_ZONE_CHEST

	var/obj/item/I = owner.get_active_held_item()
	var/datum/intent/used_intent = owner.used_intent

	var/eff = accuracy_check(desired_zone, owner, target, /datum/skill/combat/unarmed, used_intent, I)
	return eff || BODY_ZONE_CHEST

/datum/component/combo_core/proc/IsValidPrefix()
	if(!history || !rules)
		return FALSE

	var/list/skills_seq = list()
	for(var/datum/combo_input_entry/E as anything in history)
		skills_seq += E.skill_id

	for(var/datum/combo_rule/R as anything in rules)
		if(IsPrefix(skills_seq, R.pattern))
			return TRUE

	return FALSE

/datum/component/combo_core/proc/IsPrefix(list/seq, list/pattern)
	if(length(seq) > length(pattern))
		return FALSE

	for(var/i in 1 to length(seq))
		if(seq[i] != pattern[i])
			return FALSE

	return TRUE

// ----------------- Note visuals (overhead) -----------------
/datum/component/combo_core/soundbreaker/proc/GetNoteIconState(note_id)
	switch(note_id)
		if(SOUNDBREAKER_NOTE_BEND) return "note_strike"
		if(SOUNDBREAKER_NOTE_BARE) return "note_wave"
		if(SOUNDBREAKER_NOTE_SHED) return "note_encore"
		if(SOUNDBREAKER_NOTE_RIFF) return "note_riff"
	return null

/datum/component/combo_core/soundbreaker/proc/ShowNoteIcon(note_id)
	if(!owner || !note_id)
		return

	if(!islist(note_history))
		note_history = list()
	note_history += note_id

	while(length(note_history) > SB_MAX_VISIBLE_NOTES)
		note_history.Cut(1, 2)

	UpdateNoteOverlays()

/datum/component/combo_core/soundbreaker/proc/UpdateNoteOverlays()
	if(!owner)
		return

	if(islist(note_mas) && length(note_mas))
		for(var/mutable_appearance/ma in note_mas)
			owner.overlays -= ma
		note_mas.Cut()
	else
		note_mas = list()

	if(!length(note_history))
		return

	var/base_y = 18
	var/step_x = 8
	var/start_x = 8
	var/idx = 0

	for(var/i = length(note_history), i >= 1, i--)
		var/note_id = note_history[i]
		var/state = GetNoteIconState(note_id)
		if(!state)
			continue

		var/mutable_appearance/ma = mutable_appearance('modular_twilight_axis/icons/roguetown/misc/soundspells.dmi', state)
		ma.layer = ABOVE_MOB_LAYER + 0.2
		ma.plane = GAME_PLANE_UPPER
		ma.pixel_y = base_y
		ma.pixel_x = -(idx * step_x) + start_x
		ma.appearance_flags = RESET_TRANSFORM|KEEP_TOGETHER|PIXEL_SCALE

		note_mas += ma
		owner.overlays += ma
		idx++

	if(owner?.client)
		owner.update_cone()

/datum/component/combo_core/soundbreaker/proc/ClearNoteIcons()
	if(!owner)
		return

	if(length(note_mas))
		for(var/mutable_appearance/ma in note_mas)
			owner.overlays -= ma
		note_mas.Cut()

	if(islist(note_history))
		note_history.Cut()
	
	if(owner?.client)
		owner.update_cone()

/datum/component/combo_core/soundbreaker/proc/ShowComboIcon(mob/living/target, icon_state)
	if(!target || !icon_state)
		return
	var/duration = 0.7 SECONDS
	target.play_overhead_indicator_flick('modular_twilight_axis/icons/roguetown/misc/soundspells.dmi', icon_state, duration, ABOVE_MOB_LAYER + 0.3, null, 16, 0)

// ----------------- FX helpers (use your existing FX objects) -----------------
/datum/component/combo_core/soundbreaker/proc/sb_fx_ring(turf/T)
	if(!T)
		return
	var/turf/spawn_turf = get_step(T, SOUTHWEST)
	if(!spawn_turf)
		spawn_turf = T
	var/obj/effect/temp_visual/soundbreaker_fx/ring/fx = new(spawn_turf)
	fx.setDir(owner.dir)

/datum/component/combo_core/soundbreaker/proc/SwingFX(turf/T)
	if(!T)
		return
	var/obj/effect/temp_visual/special_intent/fx = new(T)
	fx.icon = 'icons/effects/effects.dmi'
	fx.icon_state = "sweep_fx"

/datum/component/combo_core/soundbreaker/proc/ExclaimFX(turf/T)
	if(!T)
		return
	var/obj/effect/temp_visual/special_intent/fx = new(T)
	fx.icon = 'icons/effects/effects.dmi'
	fx.icon_state = "blip"

/datum/component/combo_core/soundbreaker/proc/GetFrontTurf(distance = 1, dir_override = null)
	if(!owner)
		return null

	var/turf/T = get_turf(owner)
	if(!T)
		return null

	var/d = dir_override || owner.dir
	if(!d)
		d = owner.dir

	for(var/i in 1 to distance)
		var/turf/next = get_step(T, d)
		if(!next)
			break
		T = next

	return T

/datum/component/combo_core/soundbreaker/proc/GetArcTurfs(distance = 1, dir_override = null)
	var/list/res = list()
	if(!owner)
		return res

	var/d = dir_override || owner.dir
	if(!d)
		d = owner.dir

	var/turf/center = GetFrontTurf(distance, d)
	if(!center)
		return res

	res += center

	var/turf/L = GetFrontTurf(distance, turn(d, 45))
	if(L) res += L

	var/turf/R = GetFrontTurf(distance, turn(d, -45))
	if(R) res += R

	return res

/datum/component/combo_core/soundbreaker/proc/GetWaveLineTurfs(distance = 1, dir_override = null)
	var/list/res = list()
	if(!owner)
		return res

	var/d = dir_override || owner.dir
	if(!d)
		d = owner.dir

	var/turf/center = GetFrontTurf(distance, d)
	if(!center)
		return res

	res += center

	var/dir_left  = turn(d, 90)
	var/dir_right = turn(d, -90)

	var/turf/L = get_step(center, dir_left)
	if(L) res += L

	var/turf/R = get_step(center, dir_right)
	if(R) res += R

	return res

/datum/component/combo_core/soundbreaker/proc/StepBehind(mob/living/target)
	if(!owner || !target)
		return

	var/turf/target_turf = get_turf(target)
	if(!target_turf)
		return

	var/dir_to_target = get_dir(owner, target)
	var/turf/behind = get_step(target_turf, dir_to_target)
	if(behind && !behind.density)
		owner.forceMove(behind)

/datum/component/combo_core/soundbreaker/proc/_turf_is_dash_blocked(turf/T)
	if(!T)
		return TRUE
	if(T.density)
		return TRUE

	for(var/atom/movable/A in T)
		if(ismob(A))
			continue
		if(A.density)
			return TRUE

	return FALSE

/datum/component/combo_core/soundbreaker/proc/_first_living_on_turf(turf/T)
	if(!T)
		return null
	var/mob/living/first_dead = null
	for(var/mob/living/L in T)
		if(L == owner)
			continue
		if(L.stat == DEAD)
			if(!first_dead)
				first_dead = L
			continue
		return L
	return first_dead

// ----------------- Notes play procs -----------------
/datum/component/combo_core/soundbreaker/proc/NoteBendPlay(atom/target_atom, aim_dir, damage_mult, damage_type, zone)
	var/turf/start = get_turf(owner)
	if(!start)
		return null

	var/turf/T = get_step(start, aim_dir)
	if(!T)
		return null

	sb_fx_eq_pillars(T, aim_dir)

	var/mob/living/M = _first_living_on_turf(T)
	if(M)
		if(HitSpecific(M, damage_mult, damage_type, BCLASS_PUNCH, zone))
			return M
	return null

/datum/component/combo_core/soundbreaker/proc/NoteBarePlay(atom/target_atom, aim_dir, damage_mult, damage_type, zone)
	if(!owner)
		return null

	var/turf/T = get_turf(owner)
	if(!T)
		return null

	for(var/i in 1 to 2)
		var/turf/next = get_step(T, aim_dir)
		if(!next)
			break
		T = next

		sb_fx_wave_forward(T, aim_dir)

		var/mob/living/M = null
		for(var/mob/living/L in T)
			if(L == owner)
				continue
			if(L.stat == DEAD)
				continue
			M = L
			break

		if(!M)
			continue

		if(HitSpecific(M, damage_mult, damage_type, BCLASS_PUNCH, zone))
			return M

		return null
	return null

/datum/component/combo_core/soundbreaker/proc/NoteShedPlay(atom/target_atom, aim_dir, damage_mult, damage_type, zone)
	var/turf/start = get_turf(owner)
	if(!start)
		return null

	var/turf/T = get_step(start, aim_dir)
	if(!T)
		return null

	sb_fx_note_shatter(T)

	var/mob/living/M = _first_living_on_turf(T)
	if(!M)
		return null

	if(!HitSpecific(M, damage_mult, damage_type, BCLASS_PUNCH, zone))
		return null

	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		var/hit_zone = TryGetZone(zone)
		apply_combo_armor_wear(H, hit_zone, "blunt", ScaleDamage(damage_mult), 0.75)

	return M

/datum/component/combo_core/soundbreaker/proc/NoteRiffPlay(atom/target_atom, aim_dir, damage_mult, damage_type, zone)
	var/turf/start = get_turf(owner)
	if(!start)
		return null

	var/turf/T = get_step(start, aim_dir)
	if(!T)
		return null

	sb_fx_riff_single(T)
	sb_fx_riff_cluster(owner)

	var/mob/living/M = _first_living_on_turf(T)
	if(M)
		if(HitSpecific(M, damage_mult, damage_type, BCLASS_PUNCH, zone))
			owner.apply_status_effect(/datum/status_effect/buff/soundbreaker_riff)
			return M

	owner.apply_status_effect(/datum/status_effect/buff/soundbreaker_riff)
	return null

// ----------------- Riff defense proc -----------------
/datum/component/combo_core/soundbreaker/proc/RiffOnSuccessfulDefense()
	if(!owner)
		return
	if(!owner.has_status_effect(/datum/status_effect/buff/soundbreaker_riff))
		return

	var/success_probability = 90
	if(!HasMusic())
		success_probability = 50

	if(prob(success_probability))
		AddComboStack()

	owner.remove_status_effect(/datum/status_effect/buff/soundbreaker_riff)

// ----------------- Combos (moved from globals, unchanged behavior) -----------------

/datum/component/combo_core/soundbreaker/proc/ComboEchoBeat(mob/living/target)
	ApplyDamage(target, 1.5, BCLASS_PUNCH, is_combo = TRUE)
	SafeSlow(target, 2)

	owner.visible_message(
		span_danger("[owner]'s rhythm tightens into a punishing triplet!"),
		span_notice("You land a clean triple, briefly slowing [target]."),
	)

	ShowComboIcon(target, SB_COMBO_ICON_ECHO)
	ResetRhythm()

/datum/component/combo_core/soundbreaker/proc/ComboTempoFlick(mob/living/target)
	var/d = last_input_dir || owner.dir
	if(d)
		owner.setDir(d)
	var/zone = accuracy_check(owner.zone_selected, owner, target, /datum/skill/combat/unarmed, owner.used_intent)
	sb_fire_sound_note(owner, target, 1.5, BRUTE, zone, d)
	ResetRhythm()

/datum/component/combo_core/soundbreaker/proc/ComboBassDrop(mob/living/target)
	var/zone = TryGetZone(owner.zone_selected)
	var/turf/origin = get_turf(owner)
	var/turf/tt = target ? get_turf(target) : null
	var/d = (origin && tt) ? get_dir(origin, tt) : owner.dir
	if(!d) d = owner.dir

	var/turf/front1 = GetFrontTurf(1, d)
	var/list/wave2 = GetWaveLineTurfs(2, d)
	if(islist(wave2))
		wave2 = wave2.Copy()

	if(front1)
		ExclaimFX(front1)
		_combo_4112_stage1(target, front1, zone, 1.3)

	QueueAction(0.5 SECONDS, PROC_REF(_combo_4112_stage2), target, wave2, zone, 1.8)
	ShowComboIcon(owner, SB_COMBO_ICON_BASSDROP)
	ResetRhythm()

	owner.visible_message(
		span_danger("[owner]'s bass pattern detonates in two beats!"),
		span_notice("You slam a two-beat drop: close, then wide."),
	)

/datum/component/combo_core/soundbreaker/proc/_combo_4112_stage1(mob/living/primary, turf/front1, zone, dmg)
	if(!owner || !front1)
		return

	SwingFX(front1)
	sb_fx_ring(front1)

	var/mob/living/hit = _pick_combo_victim_on_turf(front1, primary)
	if(hit && ApplyDamage(hit, dmg, BCLASS_PUNCH, zone, BRUTE, is_combo = TRUE))
		hit.Immobilize(2 SECONDS)

/datum/component/combo_core/soundbreaker/proc/_combo_4112_stage2(mob/living/primary, list/wave2, zone, dmg)
	if(!owner || !islist(wave2))
		return

	for(var/turf/T in wave2)
		if(!T)
			continue
		SwingFX(T)

		var/mob/living/hit = _pick_combo_victim_on_turf(T, primary)
		if(hit && ApplyDamage(hit, dmg, BCLASS_PUNCH, zone, BRUTE, is_combo = TRUE))
			hit.Immobilize(1 SECONDS)

/datum/component/combo_core/soundbreaker/proc/ComboReverbCut(mob/living/target)
	var/turf/origin = get_turf(owner)
	if(!origin)
		return

	var/turf/tt = target ? get_turf(target) : null
	var/d = (origin && tt) ? get_dir(origin, tt) : owner.dir
	if(!d) d = owner.dir

	var/list/turfs = GetArcTurfs(1, d)
	var/zone = TryGetZone(owner.zone_selected)

	sb_fx_ring(origin)
	var/any = FALSE

	for(var/turf/T in turfs)
		if(!T)
			continue

		SwingFX(T)

		var/mob/living/hit = _pick_combo_victim_on_turf(T, target)
		if(hit && ApplyDamage(hit, 0.75, BCLASS_PUNCH, zone, BRUTE, is_combo = TRUE))
			any = TRUE

			var/turf/throw_target = hit.loc
			for(var/i = 1 to 2)
				var/turf/next = get_step(throw_target, d)
				if(!next)
					break
				throw_target = next

			hit.safe_throw_at(throw_target, 2, 1, owner, spin = TRUE)

	if(any)
		owner.visible_message(
			span_danger("[owner] drives a wall of sound forward!"),
			span_notice("You shove foes back with a resonant wall."),
		)
		ShowComboIcon(owner, SB_COMBO_ICON_REVERBCUT)
	else
		playsound(owner, 'sound/combat/sp_whip_whiff.ogg', 40, TRUE)

	ResetRhythm()

/datum/component/combo_core/soundbreaker/proc/ComboSyncopation(mob/living/target)
	ApplyDamage(target, 0.4, BCLASS_PUNCH, is_combo = TRUE)

	var/zone = TryGetZone(owner.zone_selected)

	if(ishuman(target))
		var/mob/living/carbon/human/H = target
		apply_combo_armor_wear(H, zone, "blunt", ScaleDamage(2.75), 2)

	owner.visible_message(
		span_danger("[owner]'s syncopation rattles through [target]'s gear!"),
		span_notice("You drive vibration into armor, wearing it down hard."),
	)

	ShowComboIcon(target, SB_COMBO_ICON_SYNCOPATION)
	ResetRhythm()

/datum/component/combo_core/soundbreaker/proc/ComboHarmonicBurst(mob/living/target)
	if(!owner || !target)
		return

	var/turf/start = get_turf(owner)
	if(!start)
		return

	if(owner.pulledby)
		if(!owner.resist_grab(TRUE))
			soundbreaker_spawn_afterimage(owner, start, 0.3 SECONDS)
			ShowComboIcon(target, SB_COMBO_ICON_HARMONIC)
			ResetRhythm()
			return

	var/dash_dir = get_dir(owner, target)
	if(!dash_dir)
		dash_dir = owner.dir

	var/zone = TryGetZone(owner.zone_selected)
	var/dmg_mult = 0.85
	var/dmg_type = BRUTE

	var/turf/t1 = get_step(start, dash_dir)
	if(!t1 || _turf_is_dash_blocked(t1))
		soundbreaker_spawn_afterimage(owner, start, 0.8 SECONDS)
		ShowComboIcon(target, SB_COMBO_ICON_HARMONIC)
		ResetRhythm()
		return

	var/turf/t2 = get_step(t1, dash_dir)

	soundbreaker_spawn_afterimage(owner, start, 0.8 SECONDS)
	soundbreaker_spawn_afterimage(owner, t1, 0.8 SECONDS)
	var/mob/living/hit_mob = null

	if(!t2 || _turf_is_dash_blocked(t2))
		owner.forceMove(t1)

		var/mob/living/M1 = _first_living_on_turf(t1)
		if(M1 && ApplyDamage(M1, dmg_mult, BCLASS_PUNCH, zone, dmg_type, is_combo = TRUE))
			hit_mob = M1

		if(hit_mob)
			owner.face_atom(hit_mob)

		owner.visible_message(
			span_danger("[owner] surges forward in a sharp harmonic dash!"),
			span_notice("You dash and strike on the beat."),
		)
		ShowComboIcon(target, SB_COMBO_ICON_HARMONIC)
		ResetRhythm()
		return

	var/mob/living/M1 = _first_living_on_turf(t1)
	if(M1 && ApplyDamage(M1, dmg_mult, BCLASS_PUNCH, zone, dmg_type, is_combo = TRUE))
		hit_mob = M1

	var/mob/living/M2 = _first_living_on_turf(t2)
	if(M2 && ApplyDamage(M2, dmg_mult, BCLASS_PUNCH, zone, dmg_type, is_combo = TRUE))
		hit_mob = M2

	if(M2)
		var/turf/behind2 = get_step(t2, dash_dir)
		if(behind2 && !_turf_is_dash_blocked(behind2))
			owner.forceMove(behind2)
			soundbreaker_spawn_afterimage(behind2, t2, 0.8 SECONDS)
		else
			owner.forceMove(t2)
	else
		owner.forceMove(t2)

	if(hit_mob)
		owner.face_atom(hit_mob)

	owner.visible_message(
		span_danger("[owner] surges forward in a sharp harmonic dash!"),
		span_notice("You dash and strike on the beat."),
	)

	ShowComboIcon(target, SB_COMBO_ICON_HARMONIC)
	ResetRhythm()

/datum/component/combo_core/soundbreaker/proc/ComboCrescendo(mob/living/target)
	if(!owner || !target)
		return

	ApplyDamage(target, 1.5, BCLASS_PUNCH, is_combo = TRUE)
	if(isnum(target.max_stamina) && target.max_stamina > 0)
		var/drain = round(target.max_stamina * SB_CRESCENDO_STAM_DRAIN_PCT)
		drain = clamp(drain, 1, 999)
		target.stamina_add(drain)

	var/stam_pct = _get_stamina_pct(target)
	if(stam_pct <= SB_CRESCENDO_STAM_DRAIN_PCT)
		SafeOffbalance(target, 2.5 SECONDS)

		owner.visible_message(
			span_danger("[owner] lands a crushing crescendo, breaking [target]'s footing!"),
			span_notice("You smash through [target]'s tempo and break their footing!"),
		)
	else
		owner.visible_message(
			span_danger("[owner] hammers [target] with a crushing crescendo!"),
			span_notice("You slam [target]'s stamina with a heavy uppercut beat."),
		)

	ShowComboIcon(target, SB_COMBO_ICON_CRESCENDO)
	ResetRhythm()

/datum/component/combo_core/soundbreaker/proc/ComboOverture(mob/living/target)
	ApplyDamage(target, 1.75, BCLASS_PUNCH, is_combo = TRUE)
	target.Stun(1.5 SECONDS)

	owner.visible_message(
		span_danger("[owner] ends the phrase with a brutal finisher!"),
		span_notice("You finish hard—either dropping them if they're shaken, or crushing them outright."),
	)

	ShowComboIcon(target, SB_COMBO_ICON_OVERTURE)
	ResetRhythm()

/datum/component/combo_core/soundbreaker/proc/OnNoteProjectileHit(mob/living/local_owner, mob/living/target, damage_mult, damage_type, zone)
	if(!local_owner || QDELETED(local_owner) || !target)
		return

	ApplyDamage(target, damage_mult, BCLASS_PUNCH, zone, damage_type)
