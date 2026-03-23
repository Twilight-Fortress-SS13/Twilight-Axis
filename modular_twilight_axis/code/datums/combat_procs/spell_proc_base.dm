#define COMSIG_SPELL_PROC_PRE_CAST "spell_proc_pre_cast"
#define COMSIG_SPELL_PROC_CAST_RESOLVED "spell_proc_cast_resolved"

/datum/component/spell_proc
	dupe_mode = COMPONENT_DUPE_UNIQUE

	var/mob/living/owner

/datum/component/spell_proc/Initialize()
	. = ..()
	if(!isliving(parent))
		return COMPONENT_INCOMPATIBLE

	owner = parent
	RegisterSignal(owner, COMSIG_SPELL_PROC_PRE_CAST, PROC_REF(_on_pre_cast))
	RegisterSignal(owner, COMSIG_SPELL_PROC_CAST_RESOLVED, PROC_REF(_on_cast_resolved))

/datum/component/spell_proc/Destroy(force)
	if(owner)
		UnregisterSignal(owner, list(
			COMSIG_SPELL_PROC_PRE_CAST,
			COMSIG_SPELL_PROC_CAST_RESOLVED,
		))
	owner = null
	return ..()

/datum/component/spell_proc/proc/_on_pre_cast(datum/source, spell_slot, spell_school, spell_kind, list/context)
	SIGNAL_HANDLER

	if(source != owner || !owner)
		return

	if(!islist(context))
		context = list()

	OnSpellProcPreCast(spell_slot, spell_school, spell_kind, context)

/datum/component/spell_proc/proc/_on_cast_resolved(datum/source, spell_slot, spell_school, spell_kind, success, list/context)
	SIGNAL_HANDLER

	if(source != owner || !owner)
		return

	if(!islist(context))
		context = list()

	OnSpellProcCastResolved(spell_slot, spell_school, spell_kind, success, context)

/datum/component/spell_proc/proc/OnSpellProcPreCast(spell_slot, spell_school, spell_kind, list/context)
	return

/datum/component/spell_proc/proc/OnSpellProcCastResolved(spell_slot, spell_school, spell_kind, success, list/context)
	return
