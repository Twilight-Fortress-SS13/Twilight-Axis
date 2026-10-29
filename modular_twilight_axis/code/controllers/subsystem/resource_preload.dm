#define RESOURCE_URLS_FILE "[global.config.directory]/resource_urls.json"

/// Feeds every player the CDN asset bundles listed in config/resource_urls.json
/// (written by tools/deploy_asset_bundles.sh) one at a time through client.preload_rsc:
/// all icon bundles first, then sounds.
/// BYOND has no "download finished" callback, so the next bundle is handed out after
/// a delay estimated from the previous bundle's size.
SUBSYSTEM_DEF(resource_preload)
	name = "Resource Preload"
	wait = 1 SECONDS
	priority = FIRE_PRIORITY_PING
	flags = SS_BACKGROUND
	runlevels = RUNLEVEL_LOBBY | RUNLEVELS_DEFAULT

	/// Dated CDN directory the bundles come from
	var/version
	/// Ordered list of list("url" = ..., "size" = bytes), icons before sounds
	var/list/bundles = list()
	/// ckey -> index of the last bundle handed to that player this round
	var/list/progress = list()
	/// ckey -> world.time after which that player gets the next bundle
	var/list/next_send = list()
	/// ckey -> REF() of the client connection the progress belongs to
	var/list/connections = list()
	/// Download speed we plan for when spacing out bundles
	var/assumed_bytes_per_second = 2 * 1024 * 1024
	var/min_delay = 5 SECONDS
	var/max_delay = 2 MINUTES
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
			bundles += list(list("url" = entry["url"], "size" = isnum(entry["size"]) ? entry["size"] : 0))
	log_config("Loaded [length(bundles)] asset bundles for version [version]")

/datum/controller/subsystem/resource_preload/fire(resumed)
	if(!resumed)
		src.currentrun = GLOB.clients.Copy()

	var/list/currentrun = src.currentrun
	while(length(currentrun))
		var/client/client = currentrun[currentrun.len]
		currentrun.len--

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
	next_send[ckey] = world.time + clamp(bundle["size"] / assumed_bytes_per_second * (1 SECONDS), min_delay, max_delay)

#undef RESOURCE_URLS_FILE
