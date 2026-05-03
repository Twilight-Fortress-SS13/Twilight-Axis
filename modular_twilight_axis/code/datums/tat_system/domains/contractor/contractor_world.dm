// contractor world-facing objects and verbs
// Loose Lux item and the IC offering verb.

// --- BEGIN contractor_loose_lux.dm ---
/obj/item/contractor_loose_lux
	name = "loose Lux"
	desc = "Condensed loose Lux, suitable for infernal absorption."
	w_class = WEIGHT_CLASS_TINY
	var/lux_power = 100

/obj/item/contractor_loose_lux/examine(mob/user)
	. = ..()
	. += span_notice("Lux power: [lux_power].")

// --- END contractor_loose_lux.dm ---

// --- BEGIN contractor_offering_verb.dm ---
/mob/living/carbon/human/verb/offer_to_contractor()
	set name = "Offer to Contractor"
	set category = "IC"

	var/obj/item/offering = get_active_held_item()
	if(!offering)
		to_chat(src, span_warning("You need to hold an offering."))
		return
	var/value = contractor_value_offering(offering)
	if(value <= 0)
		to_chat(src, span_warning("This offering is worthless."))
		return

	var/list/candidates = list()
	for(var/mob/living/carbon/human/H in GLOB.human_list)
		if(H == src || QDELETED(H) || H.stat == DEAD)
			continue
		var/datum/component/contractor/core = H.GetComponent(/datum/component/contractor)
		if(core)
			candidates += core

	if(!length(candidates))
		to_chat(src, span_warning("No hungry presence answers your offering."))
		return

	to_chat(src, span_notice("You offer [offering] to whatever hunger may listen."))
	for(var/datum/component/contractor/core as anything in candidates)
		if(!core?.owner || QDELETED(core.owner))
			continue
		var/answer = alert(core.owner, "[src] offers [offering] (value: [value]) and asks you to answer the summons.", "Contractor Offering", "Accept", "Refuse")
		if(answer != "Accept")
			if(!contractor_contract_has_history(core, src))
				core.adjust_devotion(-CONTRACTOR_CONTRACT_REFUSAL_DEVOTION_PENALTY, TRUE)
				to_chat(core.owner, span_warning("Refusing an unbound summons costs [CONTRACTOR_CONTRACT_REFUSAL_DEVOTION_PENALTY] devotion."))
			continue
		if(QDELETED(src) || QDELETED(offering) || offering.loc != src)
			to_chat(core.owner, span_warning("The offering is no longer available."))
			return
		if(core.accept_summon(src, offering))
			return

	to_chat(src, span_warning("No contractor accepts your offering."))

// --- END contractor_offering_verb.dm ---

