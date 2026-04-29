/// External helpers for class/special-class selection code.
/// Use these when building Pliant/TAT subclass option lists, so locked role buckets never appear.

/proc/tat_get_role_bucket_for_pliant_subclass(subclass_name)
	if(!istext(subclass_name) || !length(subclass_name))
		return null
	var/name = lowertext(subclass_name)
	if(findtext(name, "town") || findtext(name, "local") || findtext(name, "resident") || findtext(name, "towner"))
		return TAT_ROLE_BUCKET_TOWNER
	if(findtext(name, "advent") || findtext(name, "wander") || findtext(name, "outland") || findtext(name, "stray"))
		return TAT_ROLE_BUCKET_ADVENTURER
	if(findtext(name, "trade") || findtext(name, "merchant") || findtext(name, "trader"))
		return TAT_ROLE_BUCKET_TRADER
	return null

/proc/tat_can_ckey_use_role_bucket(raw_key, bucket)
	var/key = tat_normalize_ckey(raw_key)
	if(!key || !tat_is_valid_role_bucket(bucket))
		return TRUE
	return !tat_is_role_bucket_locked(key, bucket)

/proc/tat_should_hide_pliant_subclass(raw_key, subclass_name)
	var/bucket = tat_get_role_bucket_for_pliant_subclass(subclass_name)
	if(!bucket)
		return FALSE
	return !tat_can_ckey_use_role_bucket(raw_key, bucket)

/proc/tat_filter_pliant_subclasses_for_ckey(raw_key, list/subclasses)
	if(!islist(subclasses))
		return list()
	var/list/result = list()
	for(var/subclass in subclasses)
		if(tat_should_hide_pliant_subclass(raw_key, "[subclass]"))
			continue
		result += subclass
	return result
