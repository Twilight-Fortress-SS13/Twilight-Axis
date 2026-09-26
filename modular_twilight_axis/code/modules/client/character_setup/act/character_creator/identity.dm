/datum/preferences/proc/log_ready_character_name_change(mob/user, old_name, new_name)
	if(old_name == new_name || !istype(user, /mob/dead/new_player))
		return
	var/mob/dead/new_player/new_player = user
	if(new_player.ready != PLAYER_READY_TO_PLAY)
		return
	log_game("([user.key ? user.key : "NO KEY"]) changed readied character name from ([old_name]) to ([new_name])")
