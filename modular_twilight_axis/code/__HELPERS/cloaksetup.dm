/mob/proc/taCloakOwnerName()
	if(mind?.assigned_role != "Squire")
		return real_name
	var/prefix = mind.ta_nobility_prefix
	if(prefix && findtextEx(real_name, "[prefix] ") == 1)
		return copytext_char(real_name, length_char(prefix) + 2)
	return real_name
