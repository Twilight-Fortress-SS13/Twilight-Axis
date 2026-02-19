/datum/antagonist/zizocultist
	name = "Zizoid Lackey"
	roundend_category = "Zizoid Cultists"
	antagpanel_category = "Zizoid Cult"
	job_rank = ROLE_ZIZOIDCULTIST
	antag_hud_type = ANTAG_HUD_ZIZOID
	rogue_enabled = TRUE
	antag_hud_name = "zizoid_lackey"
	confess_lines = list(
		"DEATH TO THE TEN!",
		"PRAISE ZIZO!",
		"I AM THE FUTURE!",
		"NO GODS! ONLY MASTERS!",
	)
	var/islesser = TRUE
	var/change_stats = TRUE

	innate_traits = list(
		TRAIT_STEELHEARTED,
		TRAIT_VILLAIN,
		TRAIT_CABAL,
	)

/datum/antagonist/zizocultist/zizo_knight
	change_stats = FALSE
	name = "Zizoid's knight"

/datum/antagonist/zizocultist/leader
	name = "Zizoid Cultist"
	antag_hud_type = ANTAG_HUD_ZIZOID
	antag_hud_name = "zizoid"
	islesser = FALSE
	innate_traits = list(
		TRAIT_DECEIVING_MEEKNESS,
		TRAIT_STEELHEARTED,
		TRAIT_NOMOOD,
		TRAIT_VILLAIN,
		TRAIT_CRITICAL_RESISTANCE,
		TRAIT_CABAL,
	)

/datum/antagonist/zizocultist/examine_friendorfoe(datum/antagonist/examined_datum, mob/examiner, mob/examined)
	if(istype(examined_datum, /datum/antagonist/zizocultist/leader))
		return span_boldnotice("OUR LEADER!")
	if(istype(examined_datum, /datum/antagonist/zizocultist))
		return span_boldnotice("A lackey for the future.")
	if(istype(examined_datum, /datum/antagonist/assassin))
		return span_boldnotice("A GRAGGAROID! A CULTIST OF GRAGGAR!")

/datum/antagonist/zizocultist/on_gain()
	. = ..()
	var/mob/living/carbon/human/H = owner.current
	SSmapping.retainer.cultists |= owner
	H.set_patron(/datum/patron/inhumen/zizo)
	SSmapping.retainer.cultist_number += 1

	owner.special_role = "Zizoid Lackey"
	H.cmode_music = 'sound/music/combat_cult.ogg'
	H.playsound_local(get_turf(H), 'sound/music/maniac.ogg', 80, FALSE, pressure_affected = FALSE)
	H.verbs |= list(/mob/living/carbon/human/proc/communicate, /mob/living/carbon/human/proc/cultist_number, /mob/living/carbon/human/proc/ascension_check)
	add_antag_hud(antag_hud_type, antag_hud_name, owner.current)

	if(change_stats)
		H.change_stat(STATKEY_STR, 2)
		H.adjust_skillrank(/datum/skill/misc/reading, 3, 3, TRUE)

	if(islesser)
		add_objective(/datum/objective/zizoserve)
		if(!change_stats)
			return
		H.adjust_skillrank(/datum/skill/combat/knives, 1, 1, TRUE)
		H.adjust_skillrank(/datum/skill/combat/swords, 1, 1, TRUE)
		H.adjust_skillrank(/datum/skill/combat/polearms, 1, 1, TRUE)
		H.change_stat(STATKEY_INT, -2)
		H.grant_language(/datum/language/undead)
		return

	add_objective(/datum/objective/zizo)
	owner.special_role = ROLE_ZIZOIDCULTIST
	H.verbs |= /mob/living/carbon/human/proc/release_minion
	if(!change_stats)
		return
	H.adjust_skillrank(/datum/skill/combat/knives, 1, 1, TRUE)
	H.adjust_skillrank(/datum/skill/combat/swords, 1, 1, TRUE)
	H.adjust_skillrank(/datum/skill/combat/wrestling, 1, 1, TRUE)
	H.adjust_skillrank(/datum/skill/misc/athletics, 1, 1, TRUE)
	H.change_stat(STATKEY_STR, 2)
	H.change_stat(STATKEY_PER, 2)
	H.change_stat(STATKEY_WIL, 1)
	H.change_stat(STATKEY_CON, 2)
	H.change_stat(STATKEY_SPD, 1)
	H.change_stat(STATKEY_INT, 1)
	H.grant_language(/datum/language/undead)

/datum/antagonist/zizocultist/greet()
	to_chat(owner, span_danger("I'm a lackey to the LEADER. A new future begins."))
	owner.announce_objectives()

/datum/antagonist/zizocultist/leader/greet()
	to_chat(owner, span_danger("I'm a cultist to the ALMIGHTY. They call it the UNSPEAKABLE. I require LACKEYS to make my RITUALS easier. I SHALL ASCEND."))
	owner.announce_objectives()

/datum/antagonist/zizocultist/can_be_owned(datum/mind/new_owner)
	. = ..()
	if(.)
		if(new_owner.current == SSticker.rulermob)
			return FALSE
		if(new_owner.current.job in GLOB.church_positions)
			return FALSE
		if(new_owner.current.job in GLOB.inquisition_positions)
			return FALSE
		if(new_owner.unconvertable)
			return FALSE
		if(new_owner.current && HAS_TRAIT(new_owner.current, TRAIT_MINDSHIELD))
			return FALSE

/datum/antagonist/zizocultist/proc/add_cultist(datum/mind/cult_mind)
	if(is_zizocultist(cult_mind) || is_zizolackey(cult_mind))
		return FALSE
	var/datum/antagonist/zizocultist/new_lackey = new /datum/antagonist/zizocultist(cult_mind)

	cult_mind.add_antag_datum(new_lackey)

	new_lackey.on_gain()
	return TRUE

/datum/objective/zizo
	name = "ASCEND"
	explanation_text = "Ensure that I ascend."
	team_explanation_text = "Ensure that I ascend."
	triumph_count = 5

/datum/objective/zizo/check_completion()
	if(SSmapping.retainer.cult_ascended)
		return TRUE

/datum/objective/zizoserve
	name = "Serve your Leader"
	explanation_text = "Serve your leader and ensure that they ascend."
	team_explanation_text = "Serve your leader and ensure that they ascend."
	triumph_count = 3

/datum/objective/zizoserve/check_completion()
	if(SSmapping.retainer.cult_ascended)
		return TRUE

/datum/antagonist/zizocultist/proc/add_objective(datum/objective/O)
	var/datum/objective/V = new O
	objectives += V

/datum/antagonist/zizocultist/proc/remove_objective(datum/objective/O)
	objectives -= O

/datum/antagonist/zizocultist/roundend_report()
	var/traitorwin = TRUE

	to_chat(world, printplayer(owner))

	var/count = 0
	if(islesser) // don't need to spam up the chat with all spawn
		if(objectives.len)//If the traitor had no objectives, don't need to process this.
			for(var/datum/objective/objective in objectives)
				objective.update_explanation_text()
				if(objective.check_completion())
					to_chat(owner, "<B>Goal #[count]</B>: [objective.explanation_text] <span class='greentext'>TRIUMPH!</span>")
				else
					to_chat(owner, "<B>Goal #[count]</B>: [objective.explanation_text] <span class='redtext'>Failure.</span>")
					traitorwin = FALSE
				count += objective.triumph_count
	else
		if(objectives.len)//If the traitor had no objectives, don't need to process this.
			for(var/datum/objective/objective in objectives)
				objective.update_explanation_text()
				if(objective.check_completion())
					to_chat(world, "<B>Goal #[count]</B>: [objective.explanation_text] <span class='greentext'>TRIUMPH!</span>")
				else
					to_chat(world, "<B>Goal #[count]</B>: [objective.explanation_text] <span class='redtext'>Failure.</span>")
					traitorwin = FALSE
				count += objective.triumph_count

	var/special_role_text = lowertext(name)
	if(traitorwin)
		if(count)
			if(owner)
				owner.adjust_triumphs(count)
		to_chat(world, span_greentext(">The [special_role_text] has TRIUMPHED!"))
		if(owner?.current)
			owner.current.playsound_local(get_turf(owner.current), 'sound/misc/triumph.ogg', 100, FALSE, pressure_affected = FALSE)
	else
		to_chat(world, span_redtext("The [special_role_text] has FAILED!"))
		if(owner?.current)
			owner.current.playsound_local(get_turf(owner.current), 'sound/misc/fail.ogg', 100, FALSE, pressure_affected = FALSE)

// VERBS

/mob/living/carbon/human/proc/praise()
	set name = "Praise the Dark Lady!"
	set category = "ZIZO"

	if(stat >= UNCONSCIOUS || !can_speak_vocal())
		return
	record_round_statistic(STATS_ZIZO_PRAISED)
	audible_message("\The [src] praises <span class='bold'>Zizo</span>!")
	playsound(src.loc, pick('modular_twilight_axis/code/modules/roguetown/rogueantagonists/zizo_cult/sounds/zizo1.ogg', 'modular_twilight_axis/code/modules/roguetown/rogueantagonists/zizo_cult/sounds/zizo2.ogg','modular_twilight_axis/code/modules/roguetown/rogueantagonists/zizo_cult/sounds/zizo3.ogg','modular_twilight_axis/code/modules/roguetown/rogueantagonists/zizo_cult/sounds/zizo4.ogg','modular_twilight_axis/code/modules/roguetown/rogueantagonists/zizo_cult/sounds/zizo5.ogg','modular_twilight_axis/code/modules/roguetown/rogueantagonists/zizo_cult/sounds/zizo6.ogg'), 100)
	log_say("[key_name(src)] has praised zizo! (zizo cultist verb) [loc_name(src)]")

/mob/living/carbon/human/proc/communicate()
	set name = "Communicate with Cult"
	set category = "ZIZO"

	if(stat >= UNCONSCIOUS || !can_speak_vocal())
		return

	var/mob/living/carbon/human/H = src
	var/speak = input("What do you speak of?", "ZIZO") as text|null
	if(!speak)
		return
	whisper("O schlet'a ty'schkotot ty'skvoro...")
	sleep(5)
	if(stat >= UNCONSCIOUS || !can_speak_vocal())
		return
	whisper("[speak]")

	for(var/datum/mind/V in SSmapping.retainer.cultists)
		to_chat(V, "<span style = \"font-size:110%; font-weight:bold\"><span style = 'color:#8a13bd'>A message from </span><span style = 'color:#[H.voice_color]'>[src.real_name]</span>: [speak]</span>")
		playsound_local(V.current, 'modular_twilight_axis/code/modules/roguetown/rogueantagonists/zizo_cult/sounds/skvor.ogg',100)

	log_telepathy("[key_name(src)] used cultist telepathy to say: [speak]")

/mob/living/carbon/human/proc/cultist_number()
	set name = "Number of Cultists"
	set category = "ZIZO"

	if(stat >= UNCONSCIOUS || !can_speak_vocal())
		return
	
	var/mob/living/carbon/human/H = src

	to_chat(H, "Number of cultists: [SSmapping.retainer.cultist_number]")

/mob/living/carbon/human/proc/ascension_check()
	set name = "Ascension Check"
	set category = "ZIZO"

	if(stat >= UNCONSCIOUS || !can_speak_vocal())
		return

	var/mob/living/carbon/human/H = src

	var/player_count = length(GLOB.joined_player_list)
	var/required_cultists = max(1, round(player_count / 6))

	var/sacrifice_info = "the Crown"
	var/target_role = "Crown"

	// Приоритет 1: Герцог (SSticker.rulermob)
	if(SSticker.rulermob && istype(SSticker.rulermob, /mob/living/carbon/human))
		var/mob/living/carbon/human/ruler = SSticker.rulermob
		if(ruler.stat != DEAD)
			if(ruler.gender == "male")
				sacrifice_info = "[ruler.real_name] (Grand Duke)"
				target_role = "Grand Duke"
			else
				sacrifice_info = "[ruler.real_name] (Grand Duchess)"
				target_role = "Grand Duchess"

	// Приоритет 2: Епископ
	if(target_role == "Crown")
		for(var/mob/living/carbon/human/HL in GLOB.human_list)
			if(HL.stat == DEAD)
				continue
			var/role_title
			if(HL.mind && HL.mind.assigned_role)
				if(istext(HL.mind.assigned_role))
					role_title = HL.mind.assigned_role
				else if(istype(HL.mind.assigned_role))
					role_title = HL.mind.assigned_role.title
				else
					role_title = null
			else
				role_title = null
			if(role_title == "Bishop")
				sacrifice_info = "[HL.real_name] (Bishop)"
				target_role = "Bishop"
				break

	// Приоритет 3: Десница
	if(target_role == "Crown")
		for(var/mob/living/carbon/human/HL in GLOB.human_list)
			if(HL.stat == DEAD)
				continue
			var/role_title
			if(HL.mind && HL.mind.assigned_role)
				if(istext(HL.mind.assigned_role))
					role_title = HL.mind.assigned_role
				else if(istype(HL.mind.assigned_role))
					role_title = HL.mind.assigned_role.title
				else
					role_title = null
			else
				role_title = null
			if(role_title == "Hand")
				sacrifice_info = "[HL.real_name] (Hand)"
				target_role = "Hand"
				break

	// Приоритет 4: Принц или Принцесса
	if(target_role == "Crown")
		for(var/mob/living/carbon/human/HL in GLOB.human_list)
			if(HL.stat == DEAD)
				continue
			var/role_title
			if(HL.mind && HL.mind.assigned_role)
				if(istext(HL.mind.assigned_role))
					role_title = HL.mind.assigned_role
				else if(istype(HL.mind.assigned_role))
					role_title = HL.mind.assigned_role.title
				else
					role_title = null
			else
				role_title = null
			if(role_title == "Prince" || role_title == "Princess")
				sacrifice_info = "[HL.real_name] ([role_title])"
				target_role = role_title
				break

	// Приоритет 5: Маршал
	if(target_role == "Crown")
		for(var/mob/living/carbon/human/HL in GLOB.human_list)
			if(HL.stat == DEAD)
				continue
			var/role_title
			if(HL.mind && HL.mind.assigned_role)
				if(istext(HL.mind.assigned_role))
					role_title = HL.mind.assigned_role
				else if(istype(HL.mind.assigned_role))
					role_title = HL.mind.assigned_role.title
				else
					role_title = null
			else
				role_title = null
			if(role_title == "Marshal")
				sacrifice_info = "[HL.real_name] (Marshal)"
				target_role = "Marshal"
				break

	// Приоритет 6: Придворный маг
	if(target_role == "Crown")
		for(var/mob/living/carbon/human/HL in GLOB.human_list)
			if(HL.stat == DEAD)
				continue
			var/role_title
			if(HL.mind && HL.mind.assigned_role)
				if(istext(HL.mind.assigned_role))
					role_title = HL.mind.assigned_role
				else if(istype(HL.mind.assigned_role))
					role_title = HL.mind.assigned_role.title
				else
					role_title = null
			else
				role_title = null
			if(role_title == "Court Magician")
				sacrifice_info = "[HL.real_name] (Court Magician)"
				target_role = "Court Magician"
				break

	// Приоритет 7: Рыцарь-капитан
	if(target_role == "Crown")
		for(var/mob/living/carbon/human/HL in GLOB.human_list)
			if(HL.stat == DEAD)
				continue
			var/role_title
			if(HL.mind && HL.mind.assigned_role)
				if(istext(HL.mind.assigned_role))
					role_title = HL.mind.assigned_role
				else if(istype(HL.mind.assigned_role))
					role_title = HL.mind.assigned_role.title
				else
					role_title = null
			else
				role_title = null
			if(role_title == "Knight Captain")
				sacrifice_info = "[HL.real_name] (Knight Captain)"
				target_role = "Knight Captain"
				break

	// Приоритет 8: Казначей
	if(target_role == "Crown")
		for(var/mob/living/carbon/human/HL in GLOB.human_list)
			if(HL.stat == DEAD)
				continue
			var/role_title
			if(HL.mind && HL.mind.assigned_role)
				if(istext(HL.mind.assigned_role))
					role_title = HL.mind.assigned_role
				else if(istype(HL.mind.assigned_role))
					role_title = HL.mind.assigned_role.title
				else
					role_title = null
			else
				role_title = null
			if(role_title == "Steward")
				sacrifice_info = "[HL.real_name] (Steward)"
				target_role = "Steward"
				break

	to_chat(H, "To ascend, you need to sacrifice [sacrifice_info] and have at least [required_cultists] cultists.")

/obj/effect/decal/cleanable/sigil
	name = "sigils"
	desc = "Strange runics. They hurt your eyes."
	icon_state = "center"
	icon = 'modular_twilight_axis/code/modules/roguetown/rogueantagonists/zizo_cult/sprites/sigils.dmi'
	clean_type = CLEAN_TYPE_LIGHT_DECAL //the sigils are made out of blood, they should be cleanable with a rag, they are also very easily spammed
	var/sigil_type

/obj/effect/decal/cleanable/sigil/examine(mob/user)
	. = ..()
	if(!sigil_type)
		return

	if(isliving(user))
		var/mob/living/living_user = user
		if(istype(living_user, /datum/patron/inhumen/zizo))
			to_chat(user, "It is of the [sigil_type] circle.")

/obj/effect/decal/cleanable/sigil/proc/consume_ingredients(datum/ritual/R)

	for(var/atom/A in get_step(src, NORTH))
		if(istype(A, R.n_req) && !ishuman(A))
			playsound(src, 'sound/foley/flesh_rem2.ogg', 30)
			qdel(A)

	for(var/atom/A in get_step(src, SOUTH))
		if(istype(A, R.s_req) && !ishuman(A))
			playsound(src, 'sound/foley/flesh_rem2.ogg', 30)
			qdel(A)

	for(var/atom/A in get_step(src, EAST))
		if(istype(A, R.e_req) && !ishuman(A))
			playsound(src, 'sound/foley/flesh_rem2.ogg', 30)
			qdel(A)

	for(var/atom/A in get_step(src, WEST))
		if(istype(A, R.w_req) && !ishuman(A))
			playsound(src, 'sound/foley/flesh_rem2.ogg', 30)
			qdel(A)

	for(var/atom/A in loc.contents)
		if(istype(A, R.center_requirement) && !ishuman(A))
			playsound(src, 'sound/foley/flesh_rem2.ogg', 30)
			qdel(A)

/obj/effect/decal/cleanable/sigil/attack_hand(mob/living/user)
	. = ..()
	if(.)
		return
	
	if(!sigil_type)
		return
	
	if(!istype(user.patron, /datum/patron/inhumen/zizo))
		return
	
	if(user.mind && user.mind.has_antag_datum(/datum/antagonist/skeleton))
		to_chat(user, span_warning("Skelet not allowed."))
		return
	
	show_ritual_tgui(user)

/obj/effect/decal/cleanable/sigil/N
	icon_state = "N"

/obj/effect/decal/cleanable/sigil/NE
	icon_state = "NE"

/obj/effect/decal/cleanable/sigil/E
	icon_state = "E"

/obj/effect/decal/cleanable/sigil/SE
	icon_state = "SE"

/obj/effect/decal/cleanable/sigil/S
	icon_state = "S"

/obj/effect/decal/cleanable/sigil/SW
	icon_state = "SW"

/obj/effect/decal/cleanable/sigil/W
	icon_state = "W"

/obj/effect/decal/cleanable/sigil/NW
	icon_state = "NW"

/turf/open/floor/proc/generateSigils(mob/M, input)
	var/turf/T = get_turf(M.loc)
	for(var/obj/A in T)
		if(istype(A, /obj/effect/decal/cleanable/sigil))
			to_chat(M, span_warning("There is already a sigil here."))
			return
		if(A.density && !(A.flags_1 & ON_BORDER_1))
			to_chat(M, span_warning("There is already something here."))
			return
	if(do_after(M, 5 SECONDS))
		M.bloody_hands--
		M.update_inv_gloves()
		var/obj/effect/decal/cleanable/sigil/C = new(src)
		C.sigil_type = input
		playsound(M, 'sound/items/write.ogg', 100)
		var/list/sigilsPath = list(
			/obj/effect/decal/cleanable/sigil/N,
			/obj/effect/decal/cleanable/sigil/S,
			/obj/effect/decal/cleanable/sigil/E,
			/obj/effect/decal/cleanable/sigil/W,
			/obj/effect/decal/cleanable/sigil/NE,
			/obj/effect/decal/cleanable/sigil/NW,
			/obj/effect/decal/cleanable/sigil/SE,
			/obj/effect/decal/cleanable/sigil/SW
		)

		for(var/i = 1; i <= GLOB.alldirs.len; i++)
			var/turf/floor = get_step(src, GLOB.alldirs[i])
			var/sigil = sigilsPath[i]

			new sigil(floor)

/mob/living/carbon/human/proc/draw_sigil()
	set name = "Draw Sigil"
	set category = "ZIZO"
	if(stat >= UNCONSCIOUS)
		return
	
	if(mind && mind.has_antag_datum(/datum/antagonist/skeleton))
		return

	var/list/runes = list("Servantry", "Transmutation", "Fleshcrafting")

	if(!bloody_hands)
		to_chat(src, span_danger("My hands aren't bloody enough."))
		return

	var/input = input("Sigil Type", "ZIZO") as null|anything in runes
	if(!input)
		return

	var/turf/open/floor/T = get_turf(src)
	if(istype(T))
		T.generateSigils(src, input)

/mob/living/carbon/human/proc/release_minion()
	set name = "Release Lackey"
	set category = "ZIZO"

	var/list/mob/living/carbon/human/possible = list()
	for(var/datum/mind/V in SSmapping.retainer.cultists)
		if(V.special_role == "Zizoid Lackey")
			possible |= V.current

	var/mob/living/carbon/human/choice = input(src, "Whom do you no longer have use for?", "TWILIGHT AXIS") as null|anything in possible
	if(choice)
		var/alert = alert(src, "Are you sure?", "TWILIGHT AXIS", "Yes", "Cancel")
		if(alert == "Yes")
			visible_message(span_danger("[src] reaches out, ripping up [choice]'s soul!</span>"))
			to_chat(choice, span_danger("I HAVE FAILED MY LEADER! I HAVE FAILED ZIZO! NOTHING ELSE BUT DEATH REMAINS FOR ME NOW!"))
			sleep(20)
			choice.gib() // Cooler than dusting.
			SSmapping.retainer.cultists -= choice.mind
			SSmapping.retainer.cultist_number -= 1
