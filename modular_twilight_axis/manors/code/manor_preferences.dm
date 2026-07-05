/datum/preferences/proc/get_manor_type_display_name(type = null)
	if(!type)
		type = manor_type
	switch(type)
		if("hunter_mansion")
			return "Hunter Mansion"
		if("village")
			return "Village"
		if("fisher_hamlet")
			return "Fisher Hamlet"
		if("mining_settlement")
			return "Mining Settlement"
	return "Manor"
