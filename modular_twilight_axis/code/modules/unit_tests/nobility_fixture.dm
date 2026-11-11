// Exercise account PQ and triumph thresholds without a connected client.
/mob/living/carbon/human/nobility_fixture
	var/test_pq = 50
	var/test_triumphs = 100

/mob/living/carbon/human/nobility_fixture/taNobilityAccountPq()
	return test_pq

/mob/living/carbon/human/nobility_fixture/get_triumphs()
	return test_triumphs

/mob/living/carbon/human/nobility_fixture/adjust_triumphs(
	amt,
	counted = TRUE,
	source,
	reason
)
	test_triumphs += amt

/mob/living/carbon/human/nobility_fixture/proc/prepareFixture(
	fixture_name,
	landless = FALSE
)
	mind_initialize()
	name = fixture_name
	real_name = fixture_name
	job = "Towner"
	mind.assigned_role = "Towner"
	equip_to_slot(
		new /obj/item/clothing/suit/roguetown/shirt/undershirt(src),
		SLOT_SHIRT,
		TRUE
	)
	equip_to_slot(
		new /obj/item/clothing/under/roguetown/tights(src),
		SLOT_PANTS,
		TRUE
	)
	dna.species.soundpack_m = GLOB.voice_packs[/datum/voicepack/male]
	dna.species.soundpack_f = GLOB.voice_packs[/datum/voicepack/female]
	if(landless)
		var/datum/quirk/noble/quirk = new
		apply_quirk(src, quirk)
		qdel(quirk)
		return
	var/datum/virtue/utility/noble/V = new
	V.unlisted = TRUE
	apply_virtue(src, V)
	qdel(V)
