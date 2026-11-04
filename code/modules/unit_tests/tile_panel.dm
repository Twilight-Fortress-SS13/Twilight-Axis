/datum/unit_test/tile_panel_preview_cache/Run()
	var/mob/living/carbon/human/viewer = allocate(/mob/living/carbon/human)
	var/obj/item/rogue/instrument/lute/first = allocate(/obj/item/rogue/instrument/lute)
	var/obj/item/rogue/instrument/lute/second = allocate(/obj/item/rogue/instrument/lute)
	var/datum/tile_panel/panel = viewer.get_tile_panel()
	second.appearance = first.appearance
	var/first_key = panel._build_visual_cache_key(first)
	TEST_ASSERT_EQUAL(first_key, panel._build_visual_cache_key(second), "Identical objects should reuse a preview")
	var/cache_size = GLOB.tilepanel_preview_icons.len
	var/list/row = panel._get_or_build_row(first)
	TEST_ASSERT_NULL(row["appearance_ref"], "Listing a row must not eagerly render an icon")
	TEST_ASSERT_EQUAL(GLOB.tilepanel_preview_icons.len, cache_size, "Listing must not populate the render cache")
	panel.appearance_cache[REF(first)] = list("key" = first_key, "appearance_ref" = "cached.png")
	TEST_ASSERT_EQUAL(panel._get_cached_appearance_ref(first), "cached.png", "Unchanged appearances should reuse their URL")
	first.color = "#ff0000"
	TEST_ASSERT_NULL(panel._get_cached_appearance_ref(first), "Changing appearance must invalidate its cached URL")
	first.color = null
	var/mutable_appearance/overlay = mutable_appearance(first.icon, "lute")
	overlay.color = "#00ff00"
	first.overlays += overlay
	TEST_ASSERT_NULL(panel._get_cached_appearance_ref(first), "Changing overlays must invalidate the cached URL")
	GLOB.tilepanel_preview_icons[first_key] = 'icons/roguetown/items/music.dmi'
	TEST_ASSERT_EQUAL(GLOB.tilepanel_preview_icons[panel._build_visual_cache_key(second)], 'icons/roguetown/items/music.dmi', "Shared cache must accept appearance snapshots as keys")
	GLOB.tilepanel_preview_icons.Remove(first_key)
	var/icon/preview = panel._make_preview_icon(first)
	TEST_ASSERT_NOTNULL(preview, "A requested instrument preview should render")
	TEST_ASSERT(preview.Width() <= 64 && preview.Height() <= 64, "Previews must be bounded in size")
