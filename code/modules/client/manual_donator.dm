// Copypasta of bordercontrol system
GLOBAL_LIST_EMPTY(donatorCkeys)
GLOBAL_VAR_INIT(donatorCkeysSaveFile, new /savefile("data/donators.db"))
GLOBAL_VAR_INIT(donatorLoaded, 0)

/proc/is_donator(key)
	key = ckey(key)
	if(!key)
		return FALSE
	if(check_patreon_lvl(key) > 0)
		return TRUE
	if(!GLOB.donatorLoaded)
		load_donators()
	return LAZYISIN(GLOB.donatorCkeys, key)

/proc/donator_addkey(key)
	var/keyAsCkey = ckey(key)
	if(!keyAsCkey)
		return FALSE
	var/added_by = null
	if(usr && usr.ckey)
		added_by = usr.ckey
	if(db_set_donator_tier(keyAsCkey, 1, "legacy_admin", added_by, "Added through old donator verb"))
		GLOB.PatreonsLoaded = FALSE
		load_patreons(TRUE)
		refresh_online_donator_cache(keyAsCkey)
		return TRUE
	if(!GLOB.donatorLoaded)
		load_donators()
	if(LAZYISIN(GLOB.donatorCkeys, keyAsCkey))
		return FALSE
	LAZYINITLIST(GLOB.donatorCkeys)
	ADD_SORTED(GLOB.donatorCkeys, keyAsCkey, /proc/cmp_text_asc)
	save_donators()
	return TRUE

/proc/donator_removekey(key)
	key = ckey(key)
	if(!key)
		return FALSE
	var/removed_by = null
	if(usr && usr.ckey)
		removed_by = usr.ckey
	if(db_remove_donator(key, removed_by, "legacy_admin_removed"))
		GLOB.PatreonsLoaded = FALSE
		load_patreons(TRUE)
		refresh_online_donator_cache(key)
		return TRUE
	if(!LAZYISIN(GLOB.donatorCkeys, key))
		return TRUE
	if(GLOB.donatorCkeys)
		LAZYREMOVE(GLOB.donatorCkeys, key)
	save_donators()
	return TRUE

/proc/load_donators()
	LAZYCLEARLIST(GLOB.donatorCkeys)
	LAZYINITLIST(GLOB.donatorCkeys)
	if(!GLOB.donatorCkeysSaveFile)
		return FALSE
	GLOB.donatorCkeysSaveFile["donatorCkeys"] >> GLOB.donatorCkeys
	GLOB.donatorLoaded = TRUE

/proc/save_donators()
	if(!GLOB.donatorCkeys)
		return FALSE
	if(!GLOB.donatorCkeysSaveFile)
		return FALSE
	GLOB.donatorCkeysSaveFile["donatorCkeys"] << GLOB.donatorCkeys

// Procs goes here
/datum/admins/proc/admin_add_donator_verb()
	set name = "BC - Add Donator Ckey"
	set category = "SERVER"
	var/key = input("CKey to Add", "Add Donator CKey") as null|text
	if(key)
		var/confirm = alert("Add [key] to the donator list as tier 1?", , "Yes", "No")
		if(confirm == "Yes")
			message_admins("[key_name(usr)] added [key] to the donator list as tier 1.")
			log_admin("[key_name(usr)] added [key] to the donator list as tier 1.")
			donator_addkey(key)

/datum/admins/proc/admin_remove_donator_verb()
	set name = "BC - Remove Donator Ckey"
	set category = "SERVER"
	if(!GLOB.PatreonsLoaded)
		load_patreons()
	if(!GLOB.donatorLoaded)
		load_donators()
	var/list/current_donators = GLOB.allpatreons.Copy()
	for(var/donator_key in GLOB.donatorCkeys)
		current_donators |= donator_key
	var/key = input("CKey to Remove", "Remove Donator CKey") as null|anything in current_donators
	if(key)
		var/confirm = alert("Remove [key] from the donator list?", , "Yes", "No")
		if(confirm == "Yes")
			message_admins("[key_name(usr)] removed [key] from the donator list.")
			log_admin("[key_name(usr)] removed [key] from the donator list.")
			donator_removekey(key)
