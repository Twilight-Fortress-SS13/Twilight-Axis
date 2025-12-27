/datum/emote/living/pray/run_emote(mob/user, params, type_override, intentional)
	var/mob/living/carbon/follower = user
	var/datum/patron/patron = follower.patron

	var/prayer = input("Whisper your prayer:", "Prayer") as text|null
	if(!prayer)
		return
	
	//If God can hear your prayer (long enough, no bad words, etc.)
	if(patron.hear_prayer(follower, prayer))
		if(follower.has_flaw(/datum/charflaw/addiction/godfearing))
			// Stops prayers if you don't meet your patron's requirements to pray.
			if(patron?.associated_faith == /datum/faith/inhumen)
				if(!patron?.can_pray_inhumen(follower))
					return
				else
					follower.sate_addiction()
			else
				if(!patron?.can_pray(follower))
					return
				else
					follower.sate_addiction()

	/* admin stuff - tells you the followers name, key, and what patron they follow */
	var/follower_ident = "[follower.key]/([follower.real_name]) (follower of [patron])"
	message_admins("[follower_ident] [ADMIN_SM(follower)] [ADMIN_FLW(follower)] prays: [span_info(prayer)]")
	user.log_message("(follower of [patron]) prays: [prayer]", LOG_GAME)
	record_round_statistic(STATS_PRAYERS_MADE)

	follower.whisper(prayer)

	if(SEND_SIGNAL(follower, COMSIG_CARBON_PRAY, prayer) & CARBON_PRAY_CANCEL)
		return

	for(var/mob/living/LICKMYBALLS in hearers(2,src))	// Lickmyballs = person in crit.
		LICKMYBALLS.succumb_timer = world.time			//..succumb timer does nothing rn btw..
