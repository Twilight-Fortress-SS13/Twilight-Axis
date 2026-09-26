/datum/unit_test/zizo_rituals/Run()
	var/turf/open/floor/center = get_step(get_step(run_loc_floor_bottom_left, NORTH), EAST)
	var/obj/effect/decal/cleanable/sigil/sigil = allocate(/obj/effect/decal/cleanable/sigil, center)
	var/list/ingredient_types = list()
	for(var/ritual_name in GLOB.ritualslist)
		var/datum/ritual/ritual = GLOB.ritualslist[ritual_name]
		for(var/required_type in list(ritual.center_requirement, ritual.n_req, ritual.e_req, ritual.s_req, ritual.w_req))
			if(ispath(required_type, /obj/item))
				ingredient_types |= required_type

	TEST_ASSERT(length(ingredient_types), "Rituals must have item requirements")
	for(var/required_type in ingredient_types)
		var/obj/item/ingredient = allocate(required_type, center)
		var/obj/item/spare = allocate(required_type, center)
		TEST_ASSERT_EQUAL(sigil.find_ritual_ingredient(center, required_type), ingredient, "Must select a matching ingredient for [required_type]")
		sigil.consume_ritual_ingredient(ingredient)
		TEST_ASSERT(QDELETED(ingredient), "Ritual ingredient [required_type] was not consumed")
		TEST_ASSERT(!(ingredient in center.contents), "Consumed ingredient [required_type] must leave the rune")
		TEST_ASSERT(!QDELETED(spare), "Extra ingredients must remain on the rune")
		qdel(spare)

	var/mob/living/carbon/human/user = allocate(/mob/living/carbon/human, center)
	TEST_ASSERT_EQUAL(sigil.find_ritual_ingredient(center, /mob/living/carbon/human), user, "Rituals must accept human targets")
	sigil.consume_ritual_ingredient(user)
	TEST_ASSERT(!QDELETED(user), "Human targets must remain for the ritual's effect")
	qdel(sigil)

	var/obj/item/rope/restraints = allocate(/obj/item/rope)
	user.bloody_hands = 1
	TEST_ASSERT(user.can_draw_sigil(), "An unrestrained human with bloody hands should be able to draw")
	user.handcuffed = restraints
	TEST_ASSERT(!user.can_draw_sigil(), "A bound human must not be able to draw")
	user.draw_sigil()
	TEST_ASSERT(!(locate(/obj/effect/decal/cleanable/sigil) in center), "Drawing while bound must not create a sigil")
	TEST_ASSERT_EQUAL(user.bloody_hands, 1, "Failed drawing must not use blood")
	user.handcuffed = null

	addtimer(CALLBACK(src, PROC_REF(bind_user), user, restraints), 1)
	center.generateSigils(user)
	TEST_ASSERT(!(locate(/obj/effect/decal/cleanable/sigil) in center), "Becoming bound during drawing must interrupt it")
	TEST_ASSERT_EQUAL(user.bloody_hands, 1, "Interrupted drawing must not use blood")
	user.handcuffed = null

	center.generateSigils(user)
	TEST_ASSERT(locate(/obj/effect/decal/cleanable/sigil) in center, "An unrestrained human must successfully draw a sigil")
	TEST_ASSERT_EQUAL(user.bloody_hands, 0, "Successful drawing must use blood")

/datum/unit_test/zizo_rituals/proc/bind_user(mob/living/carbon/human/user, obj/item/rope/restraints)
	user.handcuffed = restraints
