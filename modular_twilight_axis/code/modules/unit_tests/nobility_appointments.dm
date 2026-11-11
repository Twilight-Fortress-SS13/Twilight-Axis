/datum/unit_test/local_nobility_appointments

/datum/unit_test/local_nobility_appointments/proc/check(condition, label)
	if(!condition)
		Fail(label, __FILE__, __LINE__)

/datum/unit_test/local_nobility_appointments/proc/character(
	real_name,
	role = "Towner",
	tier = null
)
	var/mob/living/carbon/human/nobility_fixture/H = allocate(
		/mob/living/carbon/human/nobility_fixture
	)
	H.mind_initialize()
	H.name = real_name
	H.real_name = real_name
	H.job = role
	H.mind.assigned_role = role
	H.mind.ta_nobility_tier = tier
	if(!isnull(tier))
		ADD_TRAIT(H, TRAIT_NOBLE, JOB_TRAIT)
	return H

/datum/unit_test/local_nobility_appointments/Run()
	checkRoleActions()
	checkSquire()
	checkChampion()
	checkInitialBanneret()
	checkRetinue()

/datum/unit_test/local_nobility_appointments/proc/checkRoleActions()
	var/mob/living/carbon/human/actor = character("Arthur Vale")
	actor.taSyncNobleAppointments()
	check(
		!actor.mind.ta_squire_action && !actor.mind.ta_champion_action,
		"Commoner has neither noble action"
	)

	ADD_TRAIT(actor, TRAIT_NOBLE, JOB_TRAIT)
	actor.mind.ta_nobility_tier = 0
	var/datum/action/cooldown/spell/takeprotege/legacy = new
	var/datum/action/cooldown/spell/learnspell/unrelated = new
	actor.mind.AddSpell(legacy)
	actor.mind.AddSpell(unrelated)
	add_verb(actor, /mob/living/carbon/human/proc/declarechampion)
	actor.taSyncNobleAppointments()
	check(
		!actor.mind.has_spell(/datum/action/cooldown/spell/takeprotege) \
		&& !(legacy in actor.actions) \
		&& QDELETED(legacy),
		"Refreshing appointments removes only the legacy squire spell"
	)
	check(
		!(/mob/living/carbon/human/proc/declarechampion in actor.verbs),
		"Refreshing appointments removes the legacy champion verb"
	)
	check(
		actor.mind.has_spell(/datum/action/cooldown/spell/learnspell) \
		&& unrelated.owner == actor,
		"Replacing appointments preserves unrelated spells and actions"
	)
	actor.mind.RemoveSpell(unrelated)
	check(
		actor.mind.ta_squire_action?.owner == actor,
		"Landless noble can appoint a squire"
	)
	check(
		!actor.mind.ta_champion_action,
		"Landless noble cannot declare a champion"
	)

	actor.mind.ta_nobility_tier = 3
	actor.taSyncNobleAppointments()
	check(
		actor.mind.ta_champion_action?.owner == actor,
		"Other T3 noble can declare a champion"
	)
	for(var/role in list("Hand", "Steward", "Marshal", "King", "Queen"))
		actor.mind.assigned_role = role
		actor.taSyncNobleAppointments()
		check(
			!actor.mind.ta_champion_action \
			&& actor.mind.ta_squire_action?.owner == actor,
			"[role] retains squire action and cannot declare a champion"
		)

	actor.mind.assigned_role = "Prince"
	actor.mind.ta_nobility_tier = null
	actor.taSyncNobleAppointments()
	check(
		actor.mind.ta_champion_action?.owner == actor,
		"Prince can declare a champion independently of a private manor"
	)
	REMOVE_TRAIT(actor, TRAIT_NOBLE, JOB_TRAIT)
	actor.taSyncNobleAppointments()
	check(
		!actor.mind.ta_squire_action && !actor.mind.ta_champion_action,
		"Losing noble status removes both role actions"
	)

/datum/unit_test/local_nobility_appointments/proc/checkSquire()
	var/mob/living/carbon/human/liege = character("Ser Edgar Vale", "Knight", 2)
	var/mob/living/carbon/human/squire = character("Knappe Hugo West", "Squire")
	var/mob/living/carbon/human/outsider = character("Theo Reed")
	ADD_TRAIT(squire, TRAIT_SQUIRE, JOB_TRAIT)
	ADD_TRAIT(outsider, TRAIT_SQUIRE_REPAIR, TRAIT_GENERIC)
	check(
		!HAS_TRAIT(outsider, TRAIT_SQUIRE),
		"Squire Knowledge alone does not confer the squire status"
	)
	check(!liege.has_empath_for(squire), "Empathy is absent before appointment")

	taLinkSquire(liege, squire)
	check(
		liege.get_squire() == squire && squire.get_knight_lord() == liege,
		"Squire appointment establishes both sides of the bond"
	)
	check(
		liege.has_empath_for(squire) \
		&& !liege.has_empath_for(outsider) \
		&& !squire.has_empath_for(liege),
		"Squire empathy is available only to the liege for their own squire"
	)
	check(
		liege.has_status_effect(/datum/status_effect/buff/protege_ward) \
		&& squire.has_status_effect(
			/datum/status_effect/buff/protege_vigilance
		),
		"Nearby liege and squire receive both presence effects"
	)
	check(
		span_notice( \
			"Squire of Ser Edgar Vale." \
		) in squire.taNobleAppointmentExamineText(),
		"Squire examine shows the liege"
	)

	SEND_SIGNAL(squire, COMSIG_LIVING_DEATH, FALSE)
	SEND_SIGNAL(liege, COMSIG_LIVING_DEATH, FALSE)
	check(
		liege.has_stress_event(/datum/stressevent/protege_dead) \
		&& squire.has_stress_event(/datum/stressevent/protege_lord_dead),
		"Each participant is notified of the other's death"
	)
	squire_bond_break(liege, squire)
	check(
		!liege.get_squire() \
		&& !squire.get_knight_lord() \
		&& !liege.has_empath_for(squire),
		"Breaking the bond clears both references and empathy"
	)
	check(
		!liege.has_status_effect(/datum/status_effect/buff/protege_ward) \
		&& !squire.has_status_effect(
			/datum/status_effect/buff/protege_vigilance
		),
		"Breaking the bond clears both presence effects"
	)

/datum/unit_test/local_nobility_appointments/proc/checkChampion()
	var/mob/living/carbon/human/prince = character(
		"Prince Edwin Vale",
		"Prince",
		3
	)
	var/mob/living/carbon/human/champion = character("Hugo West")
	var/mob/living/carbon/human/outsider = character("Theo Reed")
	var/original_luck = prince.get_stat(STATKEY_LCK)
	var/original_ward_will = prince.get_stat(STATKEY_WIL)
	var/original_con = champion.get_stat(STATKEY_CON)
	var/original_champion_will = champion.get_stat(STATKEY_WIL)
	check(
		taCanStartChampionBond(prince, champion) \
		&& taLinkChampion(prince, champion),
		"A free pair can form a championship"
	)
	check(
		taIsChampionPair(prince, champion) \
		&& !taCanStartChampionBond(prince, outsider) \
		&& !taCanStartChampionBond(outsider, champion),
		"Championship is two-way and blocks a competing pair"
	)
	check(
		span_notice( \
			"Champion of Prince Edwin Vale." \
		) in champion.taNobleAppointmentExamineText(),
		"Champion examine shows the ward"
	)
	check(
		prince.get_stat(STATKEY_LCK) == original_luck + 1 \
		&& prince.get_stat(STATKEY_WIL) == original_ward_will + 1,
		"Ward receives one luck and one willpower"
	)
	check(
		champion.get_stat(STATKEY_CON) == original_con + 1 \
		&& champion.get_stat(STATKEY_WIL) == original_champion_will + 1,
		"Champion receives one constitution and one willpower"
	)

	taClearChampionPair(prince, champion)
	check(
		!taIsChampionPair(prince, champion) \
		&& !prince.has_status_effect(/datum/status_effect/buff/noble_ward) \
		&& !champion.has_status_effect(
			/datum/status_effect/buff/noble_champion
		),
		"Revocation clears the pair and both effects"
	)
	check(
		prince.get_stat(STATKEY_LCK) == original_luck \
		&& prince.get_stat(STATKEY_WIL) == original_ward_will \
		&& champion.get_stat(STATKEY_CON) == original_con \
		&& champion.get_stat(STATKEY_WIL) == original_champion_will,
		"Revocation restores original stats"
	)
	check(
		prince.has_stress_event(/datum/stressevent/lostchampion) \
		&& champion.has_stress_event(/datum/stressevent/lostward),
		"Revocation gives both expected stress events"
	)

/datum/unit_test/local_nobility_appointments/proc/checkInitialBanneret()
	var/old_map = SSmapping.config.map_name
	var/mob/old_ruler = SSticker.rulermob
	var/datum/weakref/old_duke = SSticker.ta_initial_duke
	var/datum/weakref/old_banneret = SSticker.ta_initial_banneret
	var/old_assigned = SSticker.ta_ducal_champion_assigned
	var/mob/living/carbon/human/duke = character(
		"Grand Duke Edgar Vale",
		"Grand Duke",
		3
	)
	var/mob/living/carbon/human/banneret = character(
		"Ser Hugo West",
		"Knight",
		3
	)
	banneret.advjob = "Knight Banneret"
	SSticker.rulermob = duke

	for(var/duke_first in list(FALSE, TRUE))
		SSmapping.config.map_name = "Azure Peak"
		SSticker.ta_ducal_champion_assigned = FALSE
		SSticker.ta_initial_duke = null
		SSticker.ta_initial_banneret = null
		banneret.mind.ta_initial_knight_spawn = FALSE
		banneret.taRegisterInitialBanneret()
		check(
			!SSticker.ta_initial_banneret,
			"Latejoin Banneret does not become the initial champion"
		)
		banneret.mind.ta_initial_knight_spawn = TRUE
		if(duke_first)
			SSticker.taRegisterInitialDuke(duke)
			banneret.taRegisterInitialBanneret()
		else
			banneret.taRegisterInitialBanneret()
			SSticker.taRegisterInitialDuke(duke)
		check(
			taIsChampionPair(duke, banneret) \
			&& SSticker.ta_ducal_champion_assigned,
			"Round-start Duke and Banneret are paired in either spawn order"
		)
		taClearChampionPair(duke, banneret, FALSE)
		check(
			!SSticker.taTryAssignDucalChampion(),
			"Revoking the automatic championship does not regenerate it"
		)

	SSmapping.config.map_name = "Rockhill"
	SSticker.ta_ducal_champion_assigned = FALSE
	SSticker.ta_initial_duke = null
	SSticker.ta_initial_banneret = null
	SSticker.taRegisterInitialDuke(duke)
	banneret.taRegisterInitialBanneret()
	check(
		!SSticker.ta_initial_duke && !taIsChampionPair(duke, banneret),
		"King of Rockhill does not get an automatic Banneret"
	)
	check(
		!duke.taCanDeclareChampion(),
		"King of Rockhill cannot manually declare a champion"
	)

	SSticker.rulermob = old_ruler
	SSticker.ta_initial_duke = old_duke
	SSticker.ta_initial_banneret = old_banneret
	SSticker.ta_ducal_champion_assigned = old_assigned
	SSmapping.config.map_name = old_map

/datum/unit_test/local_nobility_appointments/proc/checkRetinue()
	var/mob/living/carbon/human/employer = character(
		"Lord Edgar Vale",
		"Towner",
		0
	)
	var/list/capacities = list(0, 1, 3, 10)
	var/offer = /mob/living/carbon/human/proc/taOfferRetinueService
	var/manage = /mob/living/carbon/human/proc/taManageRetinueService
	var/leave = /mob/living/carbon/human/proc/taLeaveRetinueService
	for(var/tier = 0 to 3)
		employer.mind.ta_nobility_tier = tier
		employer.taSyncRetinueVerbs()
		var/capacity = capacities[tier + 1]
		check(
			employer.taRetinueCapacity() == capacity \
			&& ((offer in employer.verbs) == !!capacity),
			"T[tier] has the expected retainer capacity and offer verb"
		)
		var/list/contracts = list()
		for(var/index = 1 to capacity)
			var/mob/living/carbon/human/retainer = character("Retainer [index]")
			var/datum/ta_retainer_contract/contract = allocate(
				/datum/ta_retainer_contract,
				employer.mind,
				retainer.mind
			)
			contracts += contract
			check(
				retainer.mind.ta_retinue_service == contract \
				&& (leave in retainer.verbs),
				"Service links the retainer and gives their leave verb"
			)
			var/list/examine_lines = list()
			SEND_SIGNAL( \
				retainer, \
				COMSIG_PARENT_EXAMINE, \
				retainer, \
				examine_lines \
			)
			check(
				span_notice( \
					"In the service of Lord Edgar Vale." \
				) in examine_lines,
				"Service appears in examine"
			)
		check(
			length(employer.mind.ta_retinue_employments) == capacity \
			&& ((manage in employer.verbs) == !!capacity),
			"T[tier] can track every contract and exposes management while \
			serving"
		)
		for(var/datum/ta_retainer_contract/contract as anything in contracts)
			var/mob/living/carbon/human/retainer = contract.retainer_body
			qdel(contract)
			var/list/examine_lines = list()
			SEND_SIGNAL( \
				retainer, \
				COMSIG_PARENT_EXAMINE, \
				retainer, \
				examine_lines \
			)
			check(
				!retainer.mind.ta_retinue_service \
				&& !(leave in retainer.verbs) \
				&& !length(examine_lines),
				"Ended service clears examine, the contract and the leave verb"
			)
		check(
			!length(employer.mind.ta_retinue_employments) \
			&& !(manage in employer.verbs),
			"Ending service reopens all slots and removes management when no \
			one serves"
		)
