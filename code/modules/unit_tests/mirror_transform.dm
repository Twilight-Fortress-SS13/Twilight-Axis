// Skin colors must round-trip through the mirror and the limb renderer.
/datum/unit_test/mirror_transform_skin_color/Run()
	var/mob/living/carbon/human/human = allocate(/mob/living/carbon/human)
	ADD_TRAIT(human, TRAIT_MIRROR_MAGIC, TRAIT_GENERIC)
	var/datum/mirror_appearance_ui/editor = allocate(/datum/mirror_appearance_ui, human)
	var/list/species_names = list("Axian", "Fluvian", "Lupian", "Tabaxi", "Venardine", "Verminvolk", "Wild-Kin", "Revenant", "Drakian", "Kobold", "Zardman", "Half-Kin")
	var/tested = 0
	for(var/species_type in subtypesof(/datum/species))
		if(!(initial(species_type:name) in species_names))
			continue
		human.set_species(species_type)
		human.skin_tone = "aa2233"
		human.dna.features["mcolor"] = "445566"
		tested++
		var/expected_color = "12ab34"
		TEST_ASSERT(editor.apply_skin_color(human, 1, "#[expected_color]"), "Mirror rejected skin color for [human.dna.species.name]")
		TEST_ASSERT_EQUAL(LOWER_TEXT(editor.get_current_skin_color(human, 1)), "#[expected_color]", "Mirror color did not round-trip for [human.dna.species.name]")
		for(var/obj/item/bodypart/part as anything in human.bodyparts)
			var/render_color = part.species_color || part.skin_tone
			TEST_ASSERT_EQUAL(LOWER_TEXT(render_color), expected_color, "Wrong limb color for [human.dna.species.name]: [part.body_zone]")
		for(var/tier in 2 to 3)
			TEST_ASSERT(editor.apply_skin_color(human, tier, "#[expected_color]"), "Mirror rejected mutant color [tier]")
			TEST_ASSERT_EQUAL(LOWER_TEXT(human.dna.features["mcolor[tier]"]), expected_color, "Mutant colors must be stored without a hash")
	TEST_ASSERT_EQUAL(tested, length(species_names), "Some affected species were not tested")

/datum/unit_test/half_kin_ancestry/Run()
	var/mob/living/carbon/human/human = allocate(/mob/living/carbon/human)
	human.set_species(/datum/species/demihuman)
	human.skin_tone = SKIN_COLOR_GRENZELHOFT
	human.dna.features["mcolor"] = "ff0000"
	human.update_body_parts()
	TEST_ASSERT(mirror_uses_skin_tones(human), "Half-Kin must use ancestry for skin")
	for(var/obj/item/bodypart/part as anything in human.bodyparts)
		TEST_ASSERT_EQUAL(part.skin_tone, SKIN_COLOR_GRENZELHOFT, "Ancestry did not reach the limb")
		TEST_ASSERT(!part.species_color, "Mutant color overrides Half-Kin ancestry")

/datum/unit_test/mirror_transform_body_hair/Run()
	var/mob/living/carbon/human/human = allocate(/mob/living/carbon/human)
	ADD_TRAIT(human, TRAIT_MIRROR_MAGIC, TRAIT_GENERIC)
	var/datum/mirror_appearance_ui/editor = allocate(/datum/mirror_appearance_ui, human)
	var/datum/tgui/ui = allocate(/datum/tgui, human, editor, "MirrorAppearance")
	var/obj/item/bodypart/chest = human.get_bodypart(BODY_ZONE_CHEST)
	var/list/choices = list(
		"pubes" = list(/datum/bodypart_feature/pubes, /datum/sprite_accessory/pubes/hairy, /datum/sprite_accessory/pubes/trim),
		"pits" = list(/datum/bodypart_feature/pits, /datum/sprite_accessory/pits/trim, /datum/sprite_accessory/pits/hairy),
	)
	for(var/feature_key in choices)
		var/list/options = choices[feature_key]
		editor.ui_act("set_body_hair", list("feature" = feature_key, "path" = "[options[2]]"), ui)
		var/datum/bodypart_feature/current = editor.get_current_feature(chest, options[1])
		TEST_ASSERT_NOTNULL(current, "Could not add [feature_key] through mirror UI")
		current.accessory_colors = "#123456"
		editor.ui_act("set_body_hair", list("feature" = feature_key, "path" = "[options[3]]"), ui)
		current = editor.get_current_feature(chest, options[1])
		TEST_ASSERT_NOTNULL(current, "Changing style removed [feature_key]")
		TEST_ASSERT_EQUAL(current.accessory_type, options[3], "Style did not change")
		TEST_ASSERT_EQUAL(current.accessory_colors, "#123456", "Changing style lost body hair color")
		editor.ui_act("set_body_hair", list("feature" = feature_key, "path" = "/datum/sprite_accessory/hair/head"), ui)
		TEST_ASSERT_EQUAL(editor.get_current_feature(chest, options[1]), current, "Invalid style changed body hair")
		editor.ui_act("set_body_hair", list("feature" = feature_key, "path" = ""), ui)
		TEST_ASSERT_NULL(editor.get_current_feature(chest, options[1]), "Could not remove [feature_key]")
