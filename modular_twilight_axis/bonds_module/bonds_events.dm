/proc/bonds_identity_visible(mob/living/carbon/human/person)
	if(!ishuman(person))
		return FALSE
	if(!person.real_name)
		return FALSE
	return person.get_visible_name() == person.real_name

/proc/bonds_build_snapshot(mob/living/carbon/human/person)
	if(!ishuman(person))
		return null
	var/datum/job/role = bonds_job_datum_of(person)
	return list(
		"name" = person.real_name,
		"vcolor" = person.voice_color,
		"job" = role ? role.get_informed_title(person) : (person.job || "Unknown"),
		"job_key" = role ? role.title : (person.job || "Unknown"),
		"species" = person.dna?.species?.name || "Unknown",
		"gender" = person.gender,
		"age" = person.age,
	)

/proc/bonds_mind_of(mob/living/carbon/human/person)
	if(!ishuman(person))
		return null
	return person.mind

/datum/bond_history
	var/label = ""
	var/story = ""
	var/created_at = 0
	var/warmth_delta = 0
	var/weight_delta = 0
	var/pinned = FALSE
	var/dream = FALSE

/datum/bond_event
	abstract_type = /datum/bond_event
	var/category = BOND_CATEGORY_VIOLENCE
	var/warmth_transient = 0
	var/weight_transient = 0
	var/warmth_commit = 0
	var/weight_commit = 0
	var/timeout = 0
	var/tag_applied = BOND_TAG_NONE
	var/scored_propagation = TRUE
	var/history_label = "Событие"
	var/datum/social_bond/bond
	var/timer_id
	var/started_at = 0
	var/applied_scale = 1

/datum/bond_event/Destroy(force)
	if(timer_id)
		deltimer(timer_id)
		timer_id = null
	bond = null
	return ..()

/datum/bond_event/proc/start()
	started_at = world.time
	if(timeout <= 0)
		return
	timer_id = addtimer(CALLBACK(src, PROC_REF(expire)), timeout, TIMER_STOPPABLE)

/datum/bond_event/proc/refresh()
	started_at = world.time
	if(timeout <= 0)
		return
	if(timer_id)
		deltimer(timer_id)
	timer_id = addtimer(CALLBACK(src, PROC_REF(expire)), timeout, TIMER_STOPPABLE)

/datum/bond_event/proc/expire()
	timer_id = null
	var/datum/social_bond/owner_bond = bond
	bond = null
	if(owner_bond)
		owner_bond.detach_event(src)
	qdel(src)

/datum/bond_event/proc/build_story(datum/social_bond/context)
	return "[context.display_name()]."

/datum/bond_event/proc/can_apply(datum/mind/subject, datum/mind/object)
	return TRUE

/datum/bond_event/struck_by
	category = BOND_CATEGORY_VIOLENCE
	warmth_transient = -18
	weight_transient = 22
	warmth_commit = -7
	weight_commit = 15
	timeout = 8 MINUTES
	tag_applied = BOND_TAG_SHED_BLOOD
	history_label = "Насилие"

/datum/bond_event/struck_by/build_story(datum/social_bond/context)
	return "[context.display_name()] поднял на меня оружие."

/datum/bond_event/struck_them
	category = BOND_CATEGORY_VIOLENCE
	warmth_transient = -6
	weight_transient = 12
	warmth_commit = -2
	weight_commit = 8
	timeout = 8 MINUTES
	history_label = "Насилие"

/datum/bond_event/struck_them/build_story(datum/social_bond/context)
	return "Я поднял оружие на [context.display_name()]."

/datum/bond_event/beaten_by
	category = BOND_CATEGORY_VIOLENCE
	warmth_transient = -10
	weight_transient = 14
	warmth_commit = -4
	weight_commit = 11
	timeout = 6 MINUTES
	history_label = "Драка"

/datum/bond_event/beaten_by/build_story(datum/social_bond/context)
	return "[context.display_name()] распустил на меня руки."

/datum/bond_event/beat_them
	category = BOND_CATEGORY_VIOLENCE
	warmth_transient = -4
	weight_transient = 8
	warmth_commit = -1.5
	weight_commit = 6
	timeout = 6 MINUTES
	history_label = "Драка"

/datum/bond_event/beat_them/build_story(datum/social_bond/context)
	return "Я распустил руки на [context.display_name()]."

/datum/bond_event/killed_by
	category = BOND_CATEGORY_DEATH
	warmth_transient = -60
	weight_transient = 70
	warmth_commit = -35
	weight_commit = 45
	timeout = 30 MINUTES
	tag_applied = BOND_TAG_KILLED_ME
	history_label = "Смерть"

/datum/bond_event/killed_by/build_story(datum/social_bond/context)
	return "[context.display_name()] меня убил."

/datum/bond_event/killed_them
	category = BOND_CATEGORY_DEATH
	warmth_transient = -20
	weight_transient = 45
	warmth_commit = -8
	weight_commit = 25
	timeout = 30 MINUTES
	tag_applied = BOND_TAG_KILLED_THEM
	history_label = "Смерть"

/datum/bond_event/killed_them/build_story(datum/social_bond/context)
	return "Я убил [context.display_name()]."

/datum/bond_event/embraced_by
	category = BOND_CATEGORY_KINDNESS
	warmth_transient = 14
	weight_transient = 12
	warmth_commit = 7
	weight_commit = 12
	timeout = 10 MINUTES
	tag_applied = BOND_TAG_COMFORTED
	history_label = "Тепло"

/datum/bond_event/embraced_by/build_story(datum/social_bond/context)
	return "[context.display_name()] меня обнял."

/datum/bond_event/embraced_them
	category = BOND_CATEGORY_KINDNESS
	warmth_transient = 10
	weight_transient = 10
	warmth_commit = 5
	weight_commit = 10
	timeout = 10 MINUTES
	history_label = "Тепло"

/datum/bond_event/embraced_them/build_story(datum/social_bond/context)
	return "Я обнял [context.display_name()]."

/datum/bond_event/murder_attempt_by
	category = BOND_CATEGORY_DEATH
	warmth_transient = -45
	weight_transient = 55
	warmth_commit = -28
	weight_commit = 40
	timeout = 20 MINUTES
	tag_applied = BOND_TAG_SHED_BLOOD
	history_label = "Покушение"

/datum/bond_event/murder_attempt_by/build_story(datum/social_bond/context)
	return "[context.display_name()] добивал меня, когда я уже не стоял на ногах."

/datum/bond_event/murder_attempt_them
	category = BOND_CATEGORY_DEATH
	warmth_transient = -8
	weight_transient = 30
	warmth_commit = -6
	weight_commit = 25
	timeout = 20 MINUTES
	history_label = "Покушение"

/datum/bond_event/murder_attempt_them/build_story(datum/social_bond/context)
	return "Я добивал [context.display_name()], когда он уже не стоял на ногах."

/datum/bond_event/seed
	abstract_type = /datum/bond_event/seed
	category = BOND_CATEGORY_SEED
	timeout = 0
	scored_propagation = FALSE
	var/flavor_key = ""
	var/flavor_label = ""
	var/opposite_type
	var/pickable = TRUE

/datum/bond_event/seed/served_together
	flavor_key = "served"
	flavor_label = "Служили вместе"
	warmth_commit = 22
	weight_commit = 30
	tag_applied = BOND_TAG_SERVED_TOGETHER
	history_label = "Прошлое"

/datum/bond_event/seed/served_together/build_story(datum/social_bond/context)
	return "Мы с [context.display_name()] когда-то тянули лямку бок о бок."

/datum/bond_event/seed/drinking_mates
	flavor_key = "drink"
	flavor_label = "Собутыльники"
	warmth_commit = 28
	weight_commit = 24
	history_label = "Прошлое"

/datum/bond_event/seed/drinking_mates/build_story(datum/social_bond/context)
	return "Мы с [context.display_name()] не раз просыпались под одним столом."

/datum/bond_event/seed/bad_blood
	flavor_key = "badblood"
	flavor_label = "Старая вражда"
	warmth_commit = -30
	weight_commit = 35
	history_label = "Прошлое"

/datum/bond_event/seed/bad_blood/build_story(datum/social_bond/context)
	return "Между мной и [context.display_name()] давно пробежала кошка."

/datum/bond_event/seed/debtor
	flavor_key = "debt"
	flavor_label = "Старый долг"
	warmth_commit = -8
	weight_commit = 30
	tag_applied = BOND_TAG_OWES_DEBT
	history_label = "Прошлое"
	opposite_type = /datum/bond_event/seed/creditor

/datum/bond_event/seed/debtor/build_story(datum/social_bond/context)
	return "Я задолжал [context.display_name()] и всё никак не отдам."

/datum/bond_event/seed/creditor
	flavor_key = "debt"
	flavor_label = "Старый долг"
	warmth_commit = -14
	weight_commit = 34
	history_label = "Прошлое"
	opposite_type = /datum/bond_event/seed/debtor
	pickable = FALSE

/datum/bond_event/seed/creditor/build_story(datum/social_bond/context)
	return "[context.display_name()] мне должен и не спешит рассчитаться."

/datum/bond_stage
	abstract_type = /datum/bond_stage
	var/label = "Незнакомец"
	var/desc = ""
	var/category = BOND_GROUP_KNOWN
	var/accent = "#8a8a8a"
	var/priority = 0
	var/warmth_min = BOND_WARMTH_MIN
	var/warmth_max = BOND_WARMTH_MAX
	var/weight_min = BOND_WEIGHT_MIN
	var/weight_max = BOND_WEIGHT_MAX
	var/required_tags = BOND_TAG_NONE
	var/forbidden_tags = BOND_TAG_NONE

/datum/bond_stage/proc/matches(datum/social_bond/bond)
	if(bond.warmth < warmth_min || bond.warmth > warmth_max)
		return FALSE
	if(bond.weight < weight_min || bond.weight > weight_max)
		return FALSE
	if(required_tags && ((bond.tags & required_tags) != required_tags))
		return FALSE
	if(forbidden_tags && (bond.tags & forbidden_tags))
		return FALSE
	return TRUE

/datum/controller/subsystem/bonds/proc/build_stage_prototypes()
	var/list/collected = list()
	for(var/datum/bond_stage/stage_type as anything in typesof(/datum/bond_stage))
		if(IS_ABSTRACT(stage_type))
			continue
		collected += new stage_type()
	sortTim(collected, GLOBAL_PROC_REF(cmp_bond_stage_priority))
	stage_prototypes = collected

/proc/cmp_bond_stage_priority(datum/bond_stage/a, datum/bond_stage/b)
	return b.priority - a.priority

/datum/controller/subsystem/bonds/proc/resolve_stage(datum/social_bond/bond)
	RETURN_TYPE(/datum/bond_stage)
	if(!bond)
		return null
	for(var/datum/bond_stage/stage as anything in stage_prototypes)
		if(stage.matches(bond))
			return stage
	return null

/datum/bond_stage/stranger
	label = "Незнакомец"
	desc = "Лицо, которое ничего вам не говорит."
	category = BOND_GROUP_KNOWN
	accent = "#7a7a7a"
	priority = 0
	weight_max = 15

/datum/bond_stage/acquaintance
	label = "Знакомый"
	desc = "Вы пересекались, не более того."
	category = BOND_GROUP_KNOWN
	accent = "#9aa0a6"
	priority = 10
	weight_min = 15
	warmth_min = -15
	warmth_max = 15

/datum/bond_stage/warm
	label = "Приятель"
	desc = "С этим человеком легко."
	category = BOND_GROUP_WARM
	accent = "#7fb069"
	priority = 20
	weight_min = 15
	warmth_min = 15

/datum/bond_stage/friend
	label = "Друг"
	desc = "Вы держитесь друг за друга."
	category = BOND_GROUP_WARM
	accent = "#4c9f70"
	priority = 30
	weight_min = 30
	warmth_min = 40
	warmth_max = 75

/datum/bond_stage/close_friend
	label = "Близкий друг"
	desc = "Мало кому вы доверяете так же."
	category = BOND_GROUP_WARM
	accent = "#2f8f5b"
	priority = 40
	weight_min = 50
	warmth_min = 75

/datum/bond_stage/cold
	label = "Холодок"
	desc = "Что-то между вами не так."
	category = BOND_GROUP_COLD
	accent = "#a08a6a"
	priority = 20
	weight_min = 15
	warmth_max = -15

/datum/bond_stage/rival
	label = "Соперник"
	desc = "Вы меряетесь с ним при каждом удобном случае."
	category = BOND_GROUP_COLD
	accent = "#c08a3e"
	priority = 30
	weight_min = 50
	warmth_min = -60
	warmth_max = -15

/datum/bond_stage/enemy
	label = "Враг"
	desc = "Вы не желаете ему добра."
	category = BOND_GROUP_HOSTILE
	accent = "#b4553f"
	priority = 40
	weight_min = 40
	warmth_max = -40

/datum/bond_stage/nemesis
	label = "Кровный враг"
	desc = "Между вами пролилась кровь, и это не забывается."
	category = BOND_GROUP_HOSTILE
	accent = "#8c2f2f"
	priority = 60
	weight_min = 70
	warmth_max = -75
	required_tags = BOND_TAG_SHED_BLOOD

/datum/bond_disposition
	abstract_type = /datum/bond_disposition
	var/flaw_type
	var/list/category_scales

/datum/controller/subsystem/bonds/proc/build_dispositions()
	dispositions = list()
	for(var/datum/bond_disposition/disposition_type as anything in typesof(/datum/bond_disposition))
		if(IS_ABSTRACT(disposition_type))
			continue
		dispositions += new disposition_type()
	bondlog("dispositions built: [dispositions.len]", BONDLOG_INFO)

/datum/controller/subsystem/bonds/proc/disposition_scale(mob/living/carbon/human/recipient, event_type)
	if(!ishuman(recipient))
		return 1
	var/datum/bond_event/prototype = get_event_prototype(event_type)
	if(!prototype)
		return 1
	var/scale = 1
	for(var/datum/bond_disposition/disposition as anything in dispositions)
		if(!disposition.applies_to(recipient))
			continue
		var/category_scale = disposition.category_scales?[prototype.category]
		if(isnull(category_scale))
			continue
		if(!category_scale)
			return 0
		scale *= category_scale
	return scale

/datum/controller/subsystem/bonds/proc/is_sanctioned_duel(mob/living/carbon/human/actor, mob/living/carbon/human/target)
	if(!ishuman(actor) || !ishuman(target))
		return FALSE
	if(actor.has_duelist_ring() && target.has_duelist_ring())
		return TRUE
	if(!zone_weight(actor))
		return TRUE
	return FALSE

/mob/living/carbon/human
	var/tmp/bonds_signals_bound = FALSE
	var/tmp/datum/mind/bonds_last_aggressor
	var/tmp/bonds_last_aggression_time = 0
	var/tmp/bonds_crit_at = 0

/datum/controller/subsystem/bonds/proc/on_mob_created(datum/source, mob/new_mob)
	SIGNAL_HANDLER
	if(!ishuman(new_mob))
		return
	if(istype(new_mob, /mob/living/carbon/human/dummy))
		return
	register_human(new_mob)

/datum/controller/subsystem/bonds/proc/register_human(mob/living/carbon/human/person)
	if(!person || person.bonds_signals_bound)
		return FALSE
	person.bonds_signals_bound = TRUE
	wake_seeding()
#ifndef BONDS_EVOLUTION_FROZEN
	RegisterSignal(person, COMSIG_MOB_ITEM_ATTACK, PROC_REF(on_item_attack), override = TRUE)
	RegisterSignal(person, COMSIG_MOB_ATTACKED_BY_HAND, PROC_REF(on_attacked_by_hand), override = TRUE)
	RegisterSignal(person, COMSIG_MOB_HUGGED, PROC_REF(on_hugged), override = TRUE)
	RegisterSignal(person, COMSIG_MOB_DEATH, PROC_REF(on_death), override = TRUE)
#endif
	RegisterSignal(person, COMSIG_PARENT_QDELETING, PROC_REF(on_human_qdeleting), override = TRUE)
	return TRUE

/datum/controller/subsystem/bonds/proc/unregister_human(mob/living/carbon/human/person)
	if(!person || !person.bonds_signals_bound)
		return FALSE
	person.bonds_signals_bound = FALSE
	person.bonds_last_aggressor = null
	UnregisterSignal(person, list(
		COMSIG_MOB_ITEM_ATTACK,
		COMSIG_MOB_ATTACKED_BY_HAND,
		COMSIG_MOB_HUGGED,
		COMSIG_MOB_DEATH,
		COMSIG_PARENT_QDELETING,
	))
	return TRUE

/datum/controller/subsystem/bonds/proc/on_human_qdeleting(datum/source)
	SIGNAL_HANDLER
	unregister_human(source)

/datum/controller/subsystem/bonds/proc/on_item_attack(datum/source, mob/living/target, mob/living/attacker, obj/item/weapon)
	SIGNAL_HANDLER
	handle_attack(attacker, target, weapon, /datum/bond_event/struck_them, /datum/bond_event/struck_by)

/datum/controller/subsystem/bonds/proc/on_attacked_by_hand(datum/source, mob/living/attacker, mob/living/target)
	SIGNAL_HANDLER
	handle_attack(attacker, target, null, /datum/bond_event/beat_them, /datum/bond_event/beaten_by)

/datum/controller/subsystem/bonds/proc/handle_attack(mob/living/attacker, mob/living/target, obj/item/weapon, subject_event, object_event)
	if(!reacting)
		return
	var/finishing = mark_critical(target)
	if(finishing)
		record_pair(attacker, target, /datum/bond_event/murder_attempt_them, /datum/bond_event/murder_attempt_by)
	else
		record_pair(attacker, target, subject_event, object_event)
	mark_aggressor(attacker, target)
	if(finishing)
		log_finishing_blow(attacker, target, weapon)

/datum/controller/subsystem/bonds/proc/mark_critical(mob/living/target)
	var/mob/living/carbon/human/victim = target
	if(!ishuman(victim))
		return FALSE
	var/marked = victim.bonds_crit_at && ((world.time - victim.bonds_crit_at) <= BOND_MURDER_WINDOW)
	if(victim.InCritical())
		victim.bonds_crit_at = world.time
		return marked
	return marked

/datum/controller/subsystem/bonds/proc/log_finishing_blow(mob/living/attacker, mob/living/target, obj/item/weapon)
	if(!attacker || !target)
		return
	var/tool = weapon ? "[weapon.name] ([weapon.type])" : "bare hands"
	bondlog("attempted murder: [key_name(attacker)] -> [key_name(target)] with [tool], target was already down", BONDLOG_INFO)

/datum/controller/subsystem/bonds/proc/on_hugged(datum/source, mob/living/target)
	SIGNAL_HANDLER
	record_pair(source, target, /datum/bond_event/embraced_them, /datum/bond_event/embraced_by)

/datum/controller/subsystem/bonds/proc/on_death(datum/source, gibbed)
	SIGNAL_HANDLER
	if(!reacting)
		return
	var/mob/living/carbon/human/victim = source
	if(!ishuman(victim))
		return
	var/datum/mind/killer_mind = victim.bonds_last_aggressor
	victim.bonds_last_aggressor = null
	if(!killer_mind)
		return
	if((world.time - victim.bonds_last_aggression_time) > BOND_KILL_ATTRIBUTION_WINDOW)
		return
	var/mob/living/carbon/human/killer = killer_mind.current
	if(!ishuman(killer) || killer == victim)
		return
	record_pair(killer, victim, /datum/bond_event/killed_them, /datum/bond_event/killed_by)

/datum/controller/subsystem/bonds/proc/mark_aggressor(mob/living/carbon/human/attacker, mob/living/carbon/human/target)
	if(!ishuman(attacker) || !ishuman(target) || attacker == target)
		return
	if(!attacker.mind)
		return
	target.bonds_last_aggressor = attacker.mind
	target.bonds_last_aggression_time = world.time

/datum/controller/subsystem/bonds/proc/record_pair(mob/living/carbon/human/actor, mob/living/carbon/human/subject, actor_event, subject_event)
	if(!ishuman(actor) || !ishuman(subject) || actor == subject)
		return
	var/datum/mind/actor_mind = bonds_mind_of(actor)
	var/datum/mind/subject_mind = bonds_mind_of(subject)
	if(!actor_mind || !subject_mind)
		return
	var/datum/bond_event/prototype = get_event_prototype(subject_event)
	var/hostile = prototype && (prototype.category == BOND_CATEGORY_VIOLENCE || prototype.category == BOND_CATEGORY_DEATH)
	if(hostile && is_sanctioned_duel(actor, subject))
		return

	var/subject_scale = disposition_scale(subject, subject_event)
	record(actor_mind, subject_mind, actor_event, subject)
	record(subject_mind, actor_mind, subject_event, actor, FALSE, subject_scale)
	social_impact(subject_mind, actor_mind, subject_event, subject_scale)
