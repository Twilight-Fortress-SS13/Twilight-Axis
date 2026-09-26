/datum/charflaw/gefheretic
	name = "Heretic"
	desc = "It doesn't matter where I am running from. From the sands of the south, where Noc holds the dominion, from the north, where shamans offer sacrifices to the spirits, or from the wealthy islands, where Astrata rules the church. On my face is the mark of the Heretic, inflicted by a vile anointed of God."
	var/required_pq = 15
	var/static/list/allowed_jobs = list(
		"Adventurer",
		"Trader",
	)
/datum/charflaw/gefheretic/apply_post_equipment(mob/living/carbon/human/user)
	if(!istype(user) || !user.mind || !user.ckey)
		return

	if(get_playerquality(user.ckey, FALSE) < required_pq || (!(user.job in allowed_jobs)))
		var/datum/charflaw/randflaw/F = new
		user.charflaws += F
		F.on_mob_creation(user)
		F.apply_post_equipment(user)
		return
		
	GLOB.excommunicated_players += user.real_name

