/*
	Basically we got a subsystem for the shitty subjob handling and new menu as of 4/30/2024 that goes with it
*/

/*
	REMINDER TO RETEST THE OVERFILL HELPER
*/
SUBSYSTEM_DEF(role_class_handler)
	name = "Role Class Handler"
	wait = 10
	init_order = INIT_ORDER_ROLE_CLASS_HANDLER
	priority = FIRE_PRIORITY_ROLE_CLASS_HANDLER
	runlevels = RUNLEVEL_LOBBY|RUNLEVEL_GAME|RUNLEVEL_SETUP
	flags = SS_NO_FIRE

/*
	a list of datums dedicated to helping handle a class selection session
	ex: class_select_handlers[ckey] = /datum/class_select_handler
	contents: class_select_handlers = list("ckey" = /datum/class_select_handler, "ckey2" = /datum/class_select_handler,... etc)
*/
	var/list/class_select_handlers = list()

/*
	This ones basically a list for if you want to give a specific ckey a specific isolated datum
	ex: special_session_queue[ckey] += /datum/advclass/BIGMAN
	contents: special_session_queue = list("ckey" = list("funID" = /datum/advclass/class), "ckey2" = list("funID" = /datum/advclass/class)... etc)
*/
	var/list/list/special_session_queue = list()


/*
	This is basically a big assc list of lists attached to tags which contain /datum/advclass datums
	ex: sorted_class_categories[CTAG_GAPEMASTERS] += /datum/advclass/GAPER
	contents: sorted_class_categories = list("CTAG_GAPEMASTERS" = list(/datum/advclass/GAPER, /datum/advclass/GAPER2)... etc)
	Snowflake lists:
		CTAG_ALLCLASS = list(every single class datum that exists outside of the parent)
*/
	var/list/sorted_class_categories = list()


	/// Whether bandits have been injected in the game
	var/bandits_in_round = FALSE

	// Whether assassins have been injected in the game
	var/assassins_in_round = FALSE

	/// Assoc list of class registers to keep track of what townies and migrant parties are and message listeners
	var/list/class_registers = list()

/*
	We init and build the ass lists
*/
/datum/controller/subsystem/role_class_handler/Initialize()
	build_category_lists()

	initialized = TRUE

	return ..()


// This covers both class datums and drifter waves
/datum/controller/subsystem/role_class_handler/proc/build_category_lists()
	var/list/all_classes = list()
	init_subtypes(/datum/advclass, all_classes) // Init all the classes
	sorted_class_categories[CTAG_ALLCLASS] = all_classes

	//Time to sort these classes, and sort them we shall.
	for(var/datum/advclass/class in all_classes)
		for(var/ctag in class.category_tags)
			if(!sorted_class_categories[ctag]) // New cat
				sorted_class_categories[ctag] = list()
			sorted_class_categories[ctag] += class

	//Well that about covers it really.

// A dum helper to adjust the class amount, we could do it elsewhere but this will also inform any relevant class handlers open.
/datum/controller/subsystem/role_class_handler/proc/adjust_class_amount(datum/advclass/target_datum, amount)
	target_datum.total_slots_occupied += amount

	if(!(target_datum.maximum_possible_slots == -1)) // Is the class not set to infinite?
		if((target_datum.total_slots_occupied >= target_datum.maximum_possible_slots)) // We just hit a cap, iterate all the class handlers and inform them.
			for(var/HANDLER in class_select_handlers)
				var/datum/class_select_handler/found_menu = class_select_handlers[HANDLER]

				if(target_datum in found_menu.rolled_classes) // We found the target datum in one of the classes they rolled aka in the list of options they got visible,
					found_menu.rolled_class_is_full(target_datum) //  inform the datum of its error.

/datum/controller/subsystem/role_class_handler/proc/get_advclass_by_name(advclass_name)
	for(var/category in sorted_class_categories)
		for(var/datum/advclass/class as anything in sorted_class_categories[category])
			if(class.name != advclass_name)
				continue
			return class
	return null


/datum/controller/subsystem/role_class_handler/proc/get_class_register(register_id)
	if(!class_registers[register_id])
		var/datum/class_register/register = new /datum/class_register()
		register.id = register_id
		class_registers[register_id] = register
	return class_registers[register_id]

/datum/controller/subsystem/role_class_handler/proc/add_class_register_msg(register_id, msg, mob/invoker)
	var/datum/class_register/register = get_class_register(register_id)
	register.add_message(msg, invoker)

/datum/controller/subsystem/role_class_handler/proc/add_class_register_listener(register_id, mob/listener)
	var/datum/class_register/register = get_class_register(register_id)
	register.add_listener(listener)

/datum/controller/subsystem/role_class_handler/proc/remove_class_register_listener(register_id, mob/listener)
	var/datum/class_register/register = get_class_register(register_id)
	register.remove_listener(listener)
