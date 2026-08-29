
/client
		//////////////////////
		//BLACK MAGIC THINGS//
		//////////////////////
	parent_type = /datum
		////////////////
		//ADMIN THINGS//
		////////////////
	///Contains admin info. Null if client is not an admin.
	var/datum/admins/holder = null
	///Needs to implement InterceptClickOn(user,params,atom) proc
	var/datum/click_intercept = null
	///Used for admin AI interaction
	var/AI_Interact = FALSE

	///Used to cache this client's bans to save on DB queries
	var/ban_cache = null
	///Contains the last message sent by this client - used to protect against copy-paste spamming.
	var/last_message = ""
	///contins a number of how many times a message identical to last_message was sent.
	var/last_message_count = 0
	///How many messages sent in the last 10 seconds
	var/total_message_count = 01
	///Next tick to reset the total message counter
	var/total_count_reset = 0
	///Internal counter for clients sending irc relay messages via ahelp to prevent spamming. Set to a number every time an admin reply is sent, decremented for every client send.
	var/ircreplyamount = 0

		/////////
		//OTHER//
		/////////
	///Player preferences datum for the client
	var/datum/preferences/prefs = null
	///last turn of the controlled mob, I think this is only used by mechs?
	var/last_turn = 0
	///Move delay of controlled mob, related to input handling
	var/move_delay = 0
	///Current area of the controlled mob
	var/area = null

		///////////////
		//SOUND STUFF//
		///////////////
	///Active balloon alert count, used to vertically stack concurrent balloons so they don't overlap.
	var/active_balloon_count = 0
	///Currently playing ambience sound
	var/ambience_playing = null
	///Whether an ambience sound has been played and one shouldn't be played again, unset by a callback
	var/list/played = list()
	var/list/nextspooky = 0

	var/patreonlevel = -1
	var/is_donator = FALSE

		////////////
		//SECURITY//
		////////////
	// comment out the line below when debugging locally to enable the options & messages menu
	control_freak = 1

		////////////////////////////////////
		//things that require the database//
		////////////////////////////////////
	///Used to determine how old the account is - in days.
	var/player_age = -1
	///Date that this account was first seen in the server
	var/player_join_date = null
	///So admins know why it isn't working - Used to determine what other accounts previously logged in from this ip
	var/related_accounts_ip = "Requires database"
	///So admins know why it isn't working - Used to determine what other accounts previously logged in from this computer id
	var/related_accounts_cid = "Requires database"
	///Date of byond account creation in ISO 8601 format
	var/account_join_date = null
	///Age of byond account in days
	var/account_age = -1

	preload_rsc = PRELOAD_RSC

	var/atom/movable/screen/click_catcher/void

	///used to make a special mouse cursor, this one for mouse up icon
	var/mouse_up_icon = null
	///used to make a special mouse cursor, this one for mouse up icon
	var/mouse_down_icon = null
	/// world.time of last intercepted mouse-up, used to prevent double-clicks after signal intercept
	var/click_intercept_time = 0

	///Used for ip intel checking to identify evaders, disabled because of issues with traffic
	var/ip_intel = "Disabled"

	///Last ping of the client
	var/lastping = 0
	///Average ping of the client
	var/avgping = 0
	///world.time they connected
	var/connection_time
	///world.realtime they connected
	var/connection_realtime
	///world.timeofday they connected
	var/connection_timeofday

	///If the client is currently in player preferences
	var/inprefs = FALSE
	///Used for limiting the rate of topic sends by the client to avoid abuse
	var/list/topiclimiter
	///Used for limiting the rate of clicks sends by the client to avoid abuse
	var/list/clicklimiter

	///goonchat chatoutput of the client
	var/datum/chatOutput/chatOutput

	///lazy list of all credit object bound to this client
	var/list/credits = list()

	///these persist between logins/logouts during the same round.
	var/datum/player_details/player_details

	///Should only be a key-value list of north/south/east/west = atom/movable/screen.
	var/list/char_render_holders

	///Amount of keydowns in the last keysend checking interval
	var/client_keysend_amount = 0
	///World tick time where client_keysend_amount will reset
	var/next_keysend_reset = 0
	///World tick time where keysend_tripped will reset back to false
	var/next_keysend_trip_reset = 0
	///When set to true, user will be autokicked if they trip the keysends in a second limit again
	var/keysend_tripped = FALSE

	var/atom/movable/screen/movable/mouseover/mouseovertext
	var/atom/movable/screen/movable/mouseover/mouseoverbox
	///custom movement keys for this client
	var/list/movement_keys = list()

	/// Messages currently seen by this client
	var/list/seen_messages

	var/list/current_weathers = list()
	var/last_weather_x
	var/last_weather_y
	var/last_weather_z
	var/obj/weather_effect/fog_parallax/particle_weather_parallax
	var/turf/particle_weather_parallax_previous_turf
	var/atom/particle_weather_parallax_eye
	var/atom/movable/particle_weather_parallax_bound_movable
	var/mob/particle_weather_parallax_mob
	var/atom/movable/screen/plane_master/weather_effect/particle_weather_parallax_plane_master
	var/datum/particle_weather/particle_weather_parallax_weather
	var/particle_weather_parallax_camera_offset_x = 0
	var/particle_weather_parallax_camera_offset_y = 0
	var/turf/particle_weather_world_previous_turf
	var/atom/particle_weather_world_eye
	var/atom/movable/particle_weather_world_bound_movable
	var/mob/particle_weather_world_mob
	var/atom/movable/screen/plane_master/weather_effect/particle_weather_world_plane_master
	var/datum/particle_weather/particle_weather_world_weather
	var/particle_weather_world_camera_offset_x = 0
	var/particle_weather_world_camera_offset_y = 0
	/// our current tab
	var/stat_tab = "Round Info" //TA EDIT

	/// list of all tabs
	var/list/panel_tabs = list()
	/// Signature of the last listed-turf contents sent, to skip redundant rebuilds.
	var/listedturf_sig
	var/listedturf_dirty = FALSE
	var/list/listedturf_appearances
	/// Whether the living-only Stats tab is currently shown in the statbrowser.
	var/statbrowser_stats_shown = FALSE

	var/list/open_popups = list()

	var/loop_sound = FALSE
	var/rain_sound = FALSE
	var/last_droning_sound
	var/sound/droning_sound

	// List of all asset filenames sent to this client by the asset cache, along with their assoicated md5s
	var/list/sent_assets = list()
	/// List of all completed blocking send jobs awaiting acknowledgement by send_asset
	var/list/completed_asset_jobs = list()
	/// Last asset send job id.
	var/last_asset_job = 0
	var/last_completed_asset_job = 0

	/// Cooldowns for Real like - For Mentor
	var/list/real_like_cooldowns  = list()
	/// Total Real likes recieved in a round - For Mentor
	var/real_likes_received  = 0


/client/proc/clear_particle_weather_world_effect()
	if(particle_weather_world_bound_movable)
		UnregisterSignal(particle_weather_world_bound_movable, COMSIG_MOVABLE_MOVED)
		particle_weather_world_bound_movable = null
	particle_weather_world_previous_turf = null
	particle_weather_world_eye = null
	particle_weather_world_mob = null
	particle_weather_world_plane_master = null
	particle_weather_world_weather = null

/client/proc/get_particle_weather_world_effect()
	var/atom/movable/screen/plane_master/weather_effect/PM = locate(/atom/movable/screen/plane_master/weather_effect) in screen
	if(!PM || QDELETED(PM) || !PM.weather_visual || QDELETED(PM.weather_visual))
		return null
	return PM.weather_visual

/client/proc/ensure_particle_weather_world_effect(force = FALSE)
	var/datum/particle_weather/W = SSParticleWeather.runningWeather
	if(!mob || !W || !W.running || W.parallax_weather || !W.weather_icon_state)
		clear_particle_weather_world_effect()
		return FALSE
	var/atom/current_eye = eye ? eye : mob
	var/atom/movable/current_movable_eye = istype(current_eye, /atom/movable) ? current_eye : null
	var/atom/movable/screen/plane_master/weather_effect/current_plane_master = locate(/atom/movable/screen/plane_master/weather_effect) in screen
	if(!current_plane_master || QDELETED(current_plane_master) || !current_plane_master.weather_visual || QDELETED(current_plane_master.weather_visual))
		return FALSE
	var/obj/weather_effect/effect = current_plane_master.weather_visual
	var/visual_missing_from_plane = !(effect in current_plane_master.vis_contents)
	if(!force && particle_weather_world_weather == W && particle_weather_world_eye == current_eye && particle_weather_world_mob == mob && particle_weather_world_bound_movable == current_movable_eye && particle_weather_world_plane_master == current_plane_master && !visual_missing_from_plane)
		return TRUE
	var/turf/T = get_turf(current_eye)
	if(!T)
		return FALSE

	var/eye_changed = particle_weather_world_eye != current_eye
	var/mob_changed = particle_weather_world_mob != mob
	var/plane_changed = particle_weather_world_plane_master != current_plane_master
	var/weather_changed = particle_weather_world_weather != W

	if(visual_missing_from_plane)
		current_plane_master.vis_contents += effect

	if(particle_weather_world_bound_movable != current_movable_eye)
		if(particle_weather_world_bound_movable)
			UnregisterSignal(particle_weather_world_bound_movable, COMSIG_MOVABLE_MOVED)
		particle_weather_world_bound_movable = current_movable_eye
		if(particle_weather_world_bound_movable)
			RegisterSignal(particle_weather_world_bound_movable, COMSIG_MOVABLE_MOVED, PROC_REF(on_particle_weather_world_moved))

	if(force || eye_changed || mob_changed || plane_changed || weather_changed || visual_missing_from_plane || !particle_weather_world_previous_turf)
		effect.set_world_lock_camera_offset(particle_weather_world_camera_offset_x, particle_weather_world_camera_offset_y)
		effect.set_absolute_world_position(T)
		particle_weather_world_previous_turf = T

	particle_weather_world_eye = current_eye
	particle_weather_world_mob = mob
	particle_weather_world_plane_master = current_plane_master
	particle_weather_world_weather = W
	return TRUE

/client/proc/on_particle_weather_world_moved(atom/movable/source, atom/oldloc, direction)
	SIGNAL_HANDLER
	update_particle_weather_world_effect()

/client/proc/update_particle_weather_world_effect(force = FALSE)
	if(!ensure_particle_weather_world_effect(force))
		return
	var/atom/current_eye = eye ? eye : mob
	var/atom/movable/moving_eye = istype(current_eye, /atom/movable) ? current_eye : null
	var/turf/posobj = get_turf(current_eye)
	if(!posobj)
		return
	var/obj/weather_effect/effect = get_particle_weather_world_effect()
	if(!effect)
		return
	if(!particle_weather_world_previous_turf || particle_weather_world_previous_turf.z != posobj.z)
		particle_weather_world_previous_turf = posobj
		effect.set_absolute_world_position(posobj)
		return
	var/offset_x = posobj.x - particle_weather_world_previous_turf.x
	var/offset_y = posobj.y - particle_weather_world_previous_turf.y
	var/glide_rate = 0
	if(moving_eye?.glide_size > 0)
		glide_rate = round(world.icon_size / moving_eye.glide_size * world.tick_lag, world.tick_lag)
	particle_weather_world_previous_turf = posobj
	if(!offset_x && !offset_y)
		return
	var/largest_change = max(abs(offset_x), abs(offset_y))
	var/teleport_threshold = glide_rate ? max(12, round((glide_rate / world.tick_lag) * 3) + 1) : 12
	var/animate_position = glide_rate && largest_change <= teleport_threshold
	if(force || largest_change > teleport_threshold)
		effect.set_absolute_world_position(posobj)
		return
	effect.update_world_position(offset_x, offset_y, glide_rate, animate_position)

/client/proc/set_particle_weather_world_camera_offset(new_offset_x, new_offset_y, transition_time = 0, easing_mode = 0)
	particle_weather_world_camera_offset_x = new_offset_x
	particle_weather_world_camera_offset_y = new_offset_y
	var/obj/weather_effect/effect = get_particle_weather_world_effect()
	if(effect && SSParticleWeather.runningWeather?.running && !SSParticleWeather.runningWeather.parallax_weather)
		effect.set_world_lock_camera_offset(new_offset_x, new_offset_y, transition_time, easing_mode)

/client/proc/reset_particle_weather_parallax_plane()
	var/atom/movable/screen/plane_master/weather_effect/PM = locate(/atom/movable/screen/plane_master/weather_effect) in screen
	if(!PM)
		particle_weather_parallax_plane_master = null
		return
	PM.filters = list(filter(type="alpha", render_source=WEATHER_RENDER_TARGET))
	particle_weather_parallax_plane_master = PM

/client/proc/configure_particle_weather_parallax_plane(datum/particle_weather/W)
	reset_particle_weather_parallax_plane()
	if(!W)
		return
	var/atom/movable/screen/plane_master/weather_effect/PM = locate(/atom/movable/screen/plane_master/weather_effect) in screen
	if(!PM)
		return
	if(W.filter_type)
		PM.filters += W.filter_type
	if(W.secondary_filter_type)
		PM.filters += W.secondary_filter_type
	particle_weather_parallax_plane_master = PM

/client/proc/cleanup_particle_weather_parallax_visuals(obj/weather_effect/fog_parallax/keep_visual)
	var/list/fog_visuals_to_delete = list()
	for(var/atom/movable/screen/plane_master/weather_effect/PM in screen)
		for(var/obj/weather_effect/fog_parallax/fog_visual in PM.vis_contents)
			if(fog_visual == keep_visual)
				continue
			fog_visuals_to_delete |= fog_visual
	for(var/obj/weather_effect/fog_parallax/fog_visual as anything in fog_visuals_to_delete)
		for(var/atom/movable/screen/plane_master/weather_effect/PM in screen)
			PM.vis_contents -= fog_visual
		if(!QDELETED(fog_visual))
			qdel(fog_visual)

/client/proc/clear_particle_weather_parallax()
	if(particle_weather_parallax_bound_movable)
		UnregisterSignal(particle_weather_parallax_bound_movable, COMSIG_MOVABLE_MOVED)
		particle_weather_parallax_bound_movable = null
	var/obj/weather_effect/fog_parallax/tracked_parallax = particle_weather_parallax
	cleanup_particle_weather_parallax_visuals()
	if(tracked_parallax && !QDELETED(tracked_parallax))
		if(particle_weather_parallax_plane_master)
			particle_weather_parallax_plane_master.vis_contents -= tracked_parallax
		qdel(tracked_parallax)
	particle_weather_parallax = null
	particle_weather_parallax_previous_turf = null
	particle_weather_parallax_eye = null
	particle_weather_parallax_mob = null
	particle_weather_parallax_plane_master = null
	particle_weather_parallax_weather = null
	reset_particle_weather_parallax_plane()

/client/proc/has_particle_weather_parallax_visual()
	var/atom/movable/screen/plane_master/weather_effect/PM = locate(/atom/movable/screen/plane_master/weather_effect) in screen
	if(!PM)
		return FALSE
	for(var/obj/weather_effect/fog_parallax/fog_visual in PM.vis_contents)
		if(!QDELETED(fog_visual))
			return TRUE
	return FALSE

/client/proc/set_particle_weather_parallax_camera_offset(new_offset_x, new_offset_y, transition_time = 0, easing_mode = 0)
	particle_weather_parallax_camera_offset_x = new_offset_x
	particle_weather_parallax_camera_offset_y = new_offset_y
	if(particle_weather_parallax)
		particle_weather_parallax.set_camera_offset(new_offset_x, new_offset_y, transition_time, easing_mode)

/client/proc/get_particle_weather_parallax_alpha(datum/particle_weather/W, severity_mod)
	if(!W || severity_mod <= 0)
		return 0
	var/clamped_severity = min(1, max(0, severity_mod))
	return round(W.weather_alpha_min + ((W.weather_alpha_max - W.weather_alpha_min) * clamped_severity))

/client/proc/ensure_particle_weather_parallax(force_reconfigure = FALSE)
	var/datum/particle_weather/W = SSParticleWeather.runningWeather
	if(!mob || !W || !W.running || !W.parallax_weather || !W.weather_icon_state)
		clear_particle_weather_parallax()
		return FALSE
	var/atom/current_eye = eye ? eye : mob
	var/atom/movable/current_movable_eye = istype(current_eye, /atom/movable) ? current_eye : null
	var/atom/movable/screen/plane_master/weather_effect/current_plane_master = locate(/atom/movable/screen/plane_master/weather_effect) in screen
	if(!current_plane_master)
		return FALSE
	if(particle_weather_parallax && QDELETED(particle_weather_parallax))
		particle_weather_parallax = null
	var/obj/weather_effect/fog_parallax/existing_parallax = locate(/obj/weather_effect/fog_parallax) in current_plane_master.vis_contents
	if(!force_reconfigure && particle_weather_parallax && existing_parallax == particle_weather_parallax && particle_weather_parallax_weather == W && particle_weather_parallax_bound_movable == current_movable_eye && particle_weather_parallax_eye == current_eye && particle_weather_parallax_mob == mob && particle_weather_parallax_plane_master == current_plane_master && !QDELETED(particle_weather_parallax_plane_master))
		return TRUE
	var/visual_adopted = FALSE
	if(!particle_weather_parallax && existing_parallax && !QDELETED(existing_parallax))
		particle_weather_parallax = existing_parallax
		visual_adopted = TRUE
	cleanup_particle_weather_parallax_visuals(particle_weather_parallax)
	var/turf/T = get_turf(current_eye)
	if(!T)
		return FALSE

	var/eye_changed = particle_weather_parallax_eye != current_eye
	var/mob_changed = particle_weather_parallax_mob != mob
	var/plane_changed = current_plane_master != particle_weather_parallax_plane_master
	var/weather_changed = particle_weather_parallax_weather != W
	var/visual_created = FALSE
	var/visual_missing_from_plane = FALSE

	if(particle_weather_parallax_bound_movable != current_movable_eye)
		if(particle_weather_parallax_bound_movable)
			UnregisterSignal(particle_weather_parallax_bound_movable, COMSIG_MOVABLE_MOVED)
		particle_weather_parallax_bound_movable = current_movable_eye
		if(particle_weather_parallax_bound_movable)
			RegisterSignal(particle_weather_parallax_bound_movable, COMSIG_MOVABLE_MOVED, PROC_REF(on_particle_weather_parallax_moved))

	if(!particle_weather_parallax)
		particle_weather_parallax = new
		visual_created = TRUE
	if(plane_changed)
		if(particle_weather_parallax_plane_master)
			particle_weather_parallax_plane_master.vis_contents -= particle_weather_parallax
		if(!(particle_weather_parallax in current_plane_master.vis_contents))
			current_plane_master.vis_contents += particle_weather_parallax
		particle_weather_parallax_plane_master = current_plane_master
	else if(!(particle_weather_parallax in current_plane_master.vis_contents))
		current_plane_master.vis_contents += particle_weather_parallax
		visual_missing_from_plane = TRUE

	var/full_reconfigure = force_reconfigure || weather_changed || visual_created || visual_adopted
	if(full_reconfigure || plane_changed)
		configure_particle_weather_parallax_plane(W)
	if(full_reconfigure)
		var/effect_color = SSParticleWeather.current_effect_color ? SSParticleWeather.current_effect_color : W.weather_visual_color
		particle_weather_parallax.configure_parallax(W, effect_color, get_particle_weather_parallax_alpha(W, W.severityMod()))
		particle_weather_parallax.set_camera_offset(particle_weather_parallax_camera_offset_x, particle_weather_parallax_camera_offset_y)

	if(full_reconfigure || eye_changed || mob_changed || plane_changed || visual_missing_from_plane)
		particle_weather_parallax.set_absolute_position(T)
		particle_weather_parallax_previous_turf = T

	particle_weather_parallax_eye = current_eye
	particle_weather_parallax_mob = mob
	particle_weather_parallax_weather = W
	return TRUE

/client/proc/on_particle_weather_parallax_moved(atom/movable/source, atom/oldloc, direction)
	SIGNAL_HANDLER
	update_particle_weather_parallax()

/client/proc/update_particle_weather_parallax(force = FALSE)
	if(!ensure_particle_weather_parallax(force))
		return
	var/atom/current_eye = eye ? eye : mob
	var/atom/movable/moving_eye = istype(current_eye, /atom/movable) ? current_eye : null
	var/turf/posobj = get_turf(current_eye)
	if(!posobj)
		return
	if(!particle_weather_parallax_previous_turf || particle_weather_parallax_previous_turf.z != posobj.z)
		particle_weather_parallax_previous_turf = posobj
		particle_weather_parallax.set_absolute_position(posobj)
		return
	var/offset_x = posobj.x - particle_weather_parallax_previous_turf.x
	var/offset_y = posobj.y - particle_weather_parallax_previous_turf.y
	var/glide_rate = 0
	if(moving_eye?.glide_size > 0)
		glide_rate = round(world.icon_size / moving_eye.glide_size * world.tick_lag, world.tick_lag)
	particle_weather_parallax_previous_turf = posobj
	if(!offset_x && !offset_y)
		return
	var/largest_change = max(abs(offset_x), abs(offset_y))
	var/teleport_threshold = glide_rate ? max(12, round((glide_rate / world.tick_lag) * 3) + 1) : 12
	var/run_parallax = glide_rate && largest_change <= teleport_threshold
	if(force || largest_change > teleport_threshold)
		particle_weather_parallax.set_absolute_position(posobj)
		return
	particle_weather_parallax.update_parallax(offset_x, offset_y, glide_rate, run_parallax)

/client/proc/set_particle_weather_parallax_alpha(severity_mod, transition_time = 5)
	var/datum/particle_weather/W = SSParticleWeather.runningWeather
	if(!W || !W.parallax_weather || !particle_weather_parallax)
		return
	var/new_alpha = get_particle_weather_parallax_alpha(W, severity_mod)
	particle_weather_parallax.set_effect_alpha(new_alpha, transition_time)

/client/proc/update_weather(force)
	if(!mob)
		return
	if(!isobserver(mob) && !isliving(mob))
		return
	if(SSParticleWeather.runningWeather?.parallax_weather)
		update_particle_weather_parallax()
	else if(particle_weather_parallax || particle_weather_parallax_weather || particle_weather_parallax_plane_master || has_particle_weather_parallax_visual())
		clear_particle_weather_parallax()
	if(!force && mob.x == last_weather_x && mob.y == last_weather_y && mob.z == last_weather_z)
		return
	last_weather_x = mob.x
	last_weather_y = mob.y
	last_weather_z = mob.z
	var/area/A = get_area(mob)
	var/obj/PMW = locate(/atom/movable/screen/plane_master/weather) in screen
	if(PMW && A)
		if(A.outdoors)
			PMW.filters = list()
		else
			if(!PMW.filters || !islist(PMW.filters) || !PMW.filters.len)
				PMW.filters = filter(type="alpha", render_source = "*rainzone", flags = MASK_INVERSE)

	for(var/W in current_weathers)
		var/found = FALSE
		for(var/datum/weather/WE in SSweather.curweathers)
			if(WE.type == W)
				if(WE.stage == MAIN_STAGE)
					for(var/image/I in current_weathers[W])
						if(!(I in images))
							images += I
					for(var/atom/movable/screen/O in current_weathers[W])
						if(!(O in screen))
							screen += O
					found = TRUE
		if(!found)
			for(var/I in current_weathers[W])
				current_weathers[W] -= I
				fade_weather(I)

	for(var/datum/weather/WE in SSweather.curweathers)
		if(WE.stage != MAIN_STAGE)
			continue
		if(!current_weathers[WE.type])
			current_weathers[WE.type] = list()
		for(var/image/P in current_weathers[WE.type]) //need to update position of particles
			current_weathers[WE.type] -= P
			fade_weather(P)
		for(var/visual_type in WE.weather_visuals)
			var/found = FALSE
			for(var/atom/movable/screen/existing_visual in current_weathers[WE.type])
				if(istype(existing_visual, visual_type))
					found = TRUE
					break
			if(found)
				continue
			var/atom/movable/screen/new_visual = new visual_type()
			screen += new_visual
			current_weathers[WE.type] += new_visual

/client/proc/fade_weather(W)
	if(!W)
		return
	var/image/P = W
	if(istype(P))
		animate(P,alpha = 0, time=20)
		addtimer(CALLBACK(src,PROC_REF(kill_weather),P),20)
	else //screen obj
		var/atom/movable/screen/O = W
		animate(O,alpha = 0, time=10)
		addtimer(CALLBACK(src,PROC_REF(kill_weather),O),10)


/client/proc/kill_weather(P)
	if(!P)
		return
	var/image/I = P
	if(istype(I))
		images -= I
		for(var/obj/O in I.vis_contents)
			I.vis_contents -= O
			qdel(O)
		qdel(I)
	else
		screen -= P
		qdel(P)
