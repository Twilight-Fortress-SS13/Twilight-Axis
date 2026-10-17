/datum/unit_test/bard_invitation_cleanup/Run()
	var/mob/living/carbon/human/leader = allocate(/mob/living/carbon/human)
	var/mob/living/carbon/human/participant = allocate(/mob/living/carbon/human)
	var/mob/living/carbon/human/unrelated = allocate(/mob/living/carbon/human)
	var/obj/item/rogue/instrument/lute/lead_instrument = allocate(/obj/item/rogue/instrument/lute)
	var/obj/item/rogue/instrument/lute/other_instrument = allocate(/obj/item/rogue/instrument/lute)
	var/datum/bard_band_member/member = new
	member.player = participant
	member.instrument = other_instrument
	lead_instrument.band_invite_active = TRUE
	lead_instrument.band_accepting = TRUE
	lead_instrument.band_invite_leader = leader
	lead_instrument.band_reserved_members = list(member)
	lead_instrument.band_reserved_instruments = list(other_instrument)
	leader.bard_band_owner = lead_instrument
	participant.bard_band_owner = lead_instrument
	other_instrument.band_owner = lead_instrument
	unrelated.bard_band_owner = other_instrument
	var/datum/preload_owner = new
	var/preload_channel = SSsounds.instrument_channels.acquire_channel(preload_owner)
	lead_instrument.band_preloads["test"] = list("channel" = preload_channel, "listeners" = list(), "owner" = preload_owner)
	var/token = lead_instrument.band_invite_token
	lead_instrument.cancel_band_invite()
	TEST_ASSERT_NULL(leader.bard_band_owner, "Cancellation must release the leader")
	TEST_ASSERT_NULL(participant.bard_band_owner, "Cancellation must release unanswered invitations")
	TEST_ASSERT_NULL(other_instrument.band_owner, "Cancellation must release the reserved instrument")
	TEST_ASSERT_NULL(SSsounds.instrument_channels.channel_owners["[preload_channel]"], "Cancellation must release preload channels")
	TEST_ASSERT_EQUAL(unrelated.bard_band_owner, other_instrument, "Cancellation must not touch another band")
	TEST_ASSERT(lead_instrument.band_invite_token != token, "Old dialog responses must be invalidated")
	unrelated.bard_band_owner = null
	qdel(member)

/datum/unit_test/bard_stop_actual_player/Run()
	var/mob/living/carbon/human/player = allocate(/mob/living/carbon/human)
	var/mob/living/carbon/human/viewer = allocate(/mob/living/carbon/human)
	var/obj/item/rogue/instrument/lute/instrument = allocate(/obj/item/rogue/instrument/lute)
	instrument.current_player = player
	player.bard_music_playing = TRUE
	player.bard_auto_singing = TRUE
	viewer.bard_music_playing = TRUE
	instrument.stop_music(viewer)
	TEST_ASSERT(!player.bard_music_playing && !player.bard_auto_singing, "Stop must clear the actual performer")
	TEST_ASSERT(viewer.bard_music_playing, "Stop must not clear an unrelated viewer")
	viewer.bard_music_playing = FALSE

// Exercise the real instrument channel lifecycle without emitting sound or scheduling playback.
/datum/looping_sound/instrument/channel_test/on_start()
	return

/datum/unit_test/bard_channel_pool/Run()
	var/datum/sound_group/instruments/pool = SSsounds.instrument_channels
	TEST_ASSERT_EQUAL(pool.reserved_channels.len, 32, "Music must keep its original fixed budget")
	var/general_before = SSsounds.channel_reserve_high
	var/list/loops = list()
	for(var/i in 1 to 100)
		var/datum/looping_sound/instrument/channel_test/loop = new
		allocated += loop
		loops += loop
	var/idle_preserved_general = SSsounds.channel_reserve_high == general_before
	var/idle_preserved_music = !pool.channel_leases.len

	// Simulate a late round in which all reservable general channels are in use.
	var/datum/general_owner = new
	while(SSsounds.reserve_sound_channel(general_owner))
		continue
	var/general_exhausted = SSsounds.channel_reserve_high
	var/list/playing_channels = list()
	var/all_started = TRUE
	var/unique_channels = TRUE
	for(var/i in 1 to 32)
		var/datum/looping_sound/instrument/channel_test/loop = loops[i]
		if(!loop.start())
			all_started = FALSE
		if(!loop.channel || loop.channel in playing_channels)
			unique_channels = FALSE
		playing_channels += loop.channel
	var/datum/looping_sound/instrument/channel_test/overflow = loops[33]
	var/overflow_refused = !overflow.start() && overflow.stopped
	var/no_general_fallback = SSsounds.channel_reserve_high == general_exhausted
	var/datum/looping_sound/instrument/channel_test/first = loops[1]
	var/released_channel = first.channel
	qdel(first)
	var/deletion_reused = overflow.start() && overflow.channel == released_channel
	for(var/datum/looping_sound/instrument/channel_test/loop as anything in loops)
		if(!QDELETED(loop))
			loop.stop()
	SSsounds.free_datum_channels(general_owner)
	qdel(general_owner)

	TEST_ASSERT(idle_preserved_general && idle_preserved_music, "Unused instruments must consume no playback slots")
	TEST_ASSERT(all_started && unique_channels, "All 32 instruments must play independently even when the general pool is exhausted")
	TEST_ASSERT(overflow_refused && no_general_fallback, "A full music pool must not borrow channels or overwrite a performer")
	TEST_ASSERT(deletion_reused, "Deleting a playing loop must return its music slot")
	TEST_ASSERT(!pool.channel_leases.len && !pool.channel_owners.len, "Stopping all instruments must return every lease")
	TEST_ASSERT_EQUAL(SSsounds.channel_reserve_high, general_before, "Music must preserve surrounding sound reservations")

/datum/unit_test/bard_channel_pool_repeated/Run()
	var/datum/sound_group/instruments/pool = SSsounds.instrument_channels
	var/general_before = SSsounds.channel_reserve_high
	var/datum/looping_sound/instrument/channel_test/loop = new
	allocated += loop
	var/repeated_ok = TRUE
	for(var/i in 1 to 200)
		if(!loop.start())
			repeated_ok = FALSE
		var/playing_channel = loop.channel
		if(!loop.start() || loop.channel != playing_channel || pool.channel_leases.len != 1)
			repeated_ok = FALSE
		loop.stop()
		loop.stop()
		if(pool.channel_leases.len || pool.channel_owners.len)
			repeated_ok = FALSE
	TEST_ASSERT(repeated_ok, "Repeated starts and stops must be idempotent and leak no music slots")
	TEST_ASSERT_EQUAL(SSsounds.channel_reserve_high, general_before, "Repeated music playback must not reserve general channels")
