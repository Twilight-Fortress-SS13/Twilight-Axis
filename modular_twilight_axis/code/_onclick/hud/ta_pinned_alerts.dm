/datum/hud/reorganize_alerts()
	. = ..()
	var/atom/movable/screen/alert/family_alert = mymob?.alerts?["familytree_confirm"]
	if(family_alert)
		family_alert.screen_loc = "CENTER,NORTH-1"
	var/atom/movable/screen/alert/clan_alert = mymob?.alerts?["vampire_choose_clan"]
	if(clan_alert)
		clan_alert.screen_loc = "CENTER,NORTH-4"
