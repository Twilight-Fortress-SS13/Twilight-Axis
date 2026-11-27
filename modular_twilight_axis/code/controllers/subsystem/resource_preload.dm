#define RESOURCE_URLS_FILE "[global.config.directory]/resource_urls.json"

/// Feeds every player the CDN asset bundles listed in config/resource_urls.json
/// (written by tools/deploy_asset_bundles.sh) one at a time through client.preload_rsc:
/// all icon bundles first, then sounds.
/// BYOND has no "download finished" callback, so the next bundle is handed out after
SUBSYSTEM_DEF(resource_preload)
	name = "Resource Preload"
	wait = 0.5 SECONDS
	priority = FIRE_PRIORITY_PING
	flags = SS_BACKGROUND
	runlevels = RUNLEVEL_LOBBY | RUNLEVELS_DEFAULT

	/// Dated CDN directory the bundles come from
	var/version
	/// Ordered list of list("url" = ..., "category" = "icons"/"sounds"), icons before sounds
	var/list/bundles = list()
	/// ckey -> index of the last bundle handed to that player this round
	var/list/progress = list()
	/// ckey -> world.time after which that player gets the next bundle
	var/list/next_send = list()
	/// ckey -> REF() of the client connection the progress belongs to
	var/list/connections = list()
	/// Delay after handing out an icon bundle
	var/icon_delay = 10 SECONDS
	/// Delay after handing out an icon bundle while the server is in the lobby runlevel
	var/icon_lobby_delay = 5 SECONDS
	/// Delay after handing out a sound bundle
	var/sound_delay = 20 SECONDS
	/// Delay after handing out a sound bundle while the server is in the lobby runlevel
	var/sound_lobby_delay = 10 SECONDS
	/// Fire interval while the server is in the lobby runlevel
	var/lobby_wait = 0.5 SECONDS
	/// Fire interval once the round is going
	var/game_wait = 2 SECONDS
	/// At most this many clients are looked at per fire, the rest wait for the next one
	var/max_clients_per_fire = 10
	/// Grace period after connecting, so we don't fight the login resource download
	var/connect_delay = 15 SECONDS

	var/list/currentrun = list()

/datum/controller/subsystem/resource_preload/stat_entry(msg)
	msg = "V:[version || "none"] B:[length(bundles)] C:[length(progress)]"
	return ..()

/datum/controller/subsystem/resource_preload/Initialize(mapload)
#if (PRELOAD_RSC != 0)
	can_fire = FALSE
	return SS_INIT_NO_NEED
#else
	load_bundles()
	if(!length(bundles))
		can_fire = FALSE
		return SS_INIT_NO_NEED
	return SS_INIT_SUCCESS
#endif

/datum/controller/subsystem/resource_preload/proc/load_bundles()
	version = null
	bundles = list()
	if(!fexists(RESOURCE_URLS_FILE))
		return
	var/list/data = safe_json_decode(file2text(RESOURCE_URLS_FILE))
	if(!islist(data))
		log_config("Failed to parse [RESOURCE_URLS_FILE]")
		return
	version = data["version"]
	for(var/category in list("icons", "sounds"))
		var/list/entries = data[category]
		if(!islist(entries))
			continue
		for(var/list/entry in entries)
			if(!istext(entry["url"]))
				continue
			bundles += list(list("url" = entry["url"], "category" = category))
	log_config("Loaded [length(bundles)] asset bundles for version [version]")

/datum/controller/subsystem/resource_preload/fire(resumed)
	wait = Master.current_runlevel == RUNLEVEL_LOBBY ? lobby_wait : game_wait

	if(!length(src.currentrun))
		src.currentrun = GLOB.clients.Copy()

	var/list/currentrun = src.currentrun
	var/processed = 0
	while(length(currentrun) && processed < max_clients_per_fire)
		var/client/client = currentrun[currentrun.len]
		currentrun.len--
		processed++

		if(client?.ckey)
			process_client(client)

		if(MC_TICK_CHECK)
			return

/datum/controller/subsystem/resource_preload/proc/process_client(client/client)
	var/ckey = client.ckey
	var/connection = REF(client)

	if(connections[ckey] != connection)
		// New connection: if the last bundle didn't get its full download window, the
		// player probably dropped mid-download, so hand that one out again.
		if(next_send[ckey] > world.time && progress[ckey])
			progress[ckey]--
		connections[ckey] = connection
		next_send[ckey] = world.time + connect_delay
		return

	if(next_send[ckey] > world.time)
		return

	var/index = progress[ckey] + 1
	if(index > length(bundles))
		return

	var/list/bundle = bundles[index]
	client.preload_rsc = bundle["url"]
	progress[ckey] = index
	next_send[ckey] = world.time + get_delay(bundle["category"])

/datum/controller/subsystem/resource_preload/proc/get_delay(category)
	var/in_lobby = Master.current_runlevel == RUNLEVEL_LOBBY
	if(category == "sounds")
		return in_lobby ? sound_lobby_delay : sound_delay
	return in_lobby ? icon_lobby_delay : icon_delay

#undef RESOURCE_URLS_FILE
