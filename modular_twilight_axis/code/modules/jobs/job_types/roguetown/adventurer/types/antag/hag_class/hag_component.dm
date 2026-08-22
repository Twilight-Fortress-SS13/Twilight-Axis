GLOBAL_LIST_EMPTY(boon_registry)

/datum/component/hag_curio_tracker/New()
	. = ..()
	boon_registry = GLOB.boon_registry
