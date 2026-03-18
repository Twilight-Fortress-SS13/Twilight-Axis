/mob/living/carbon/human
	var/datum/weakref/sex_surrender_ref

/mob/living/proc/get_erp_organs()
	var/list/L = list()

	var/mob/living/carbon/human/H = src
	if(!istype(H))
		return L

	for(var/obj/item/organ/O in H.internal_organs)
		if(O.sex_organ)
			L += O.sex_organ

	for(var/obj/item/bodypart/B in H.bodyparts)
		if(B.sex_organ)
			L += B.sex_organ

	return L

/mob/living/proc/get_erp_organ(type)
	for(var/datum/erp_sex_organ/O in get_erp_organs())
		if(O.erp_organ_type == type)
			return O
	return null

/mob/living/carbon/human/proc/is_lamia_taur()
	if(!islist(bodyparts) || !bodyparts.len)
		return FALSE

	for(var/obj/item/bodypart/taur/lamia/L in bodyparts)
		if(!QDELETED(L))
			return TRUE

	return FALSE

/mob/living/carbon/human/proc/is_physically_restrained(node_flags)
	if(handcuffed || legcuffed)
		return TRUE

	if(node_flags & SEX_ORGAN_MOUTH)
		if(is_mouth_covered())
			return TRUE

	if(node_flags & SEX_ORGAN_HANDS)
		if(HAS_TRAIT(src, TRAIT_HANDS_BLOCKED))
			return TRUE

		var/L = get_item_for_held_index(LEFT_HANDS)
		var/R = get_item_for_held_index(RIGHT_HANDS)

		if((L && !is_sex_toy(L)) && (R && !is_sex_toy(R)))
			return TRUE

	if(node_flags & SEX_ORGAN_LEGS)
		if(legcuffed)
			return TRUE

	return FALSE

/mob/living/carbon/human/proc/get_worn_kink_tags()
	var/list/out = list()
	for(var/obj/item/I in get_equipped_items())
		if(!istype(I, /obj/item/clothing))
			continue
		var/obj/item/clothing/C = I
		var/list/L = C.get_propagade_kinks()
		if(!L || !L.len)
			continue
		for(var/k in L)
			out[k] = TRUE
	return out

/mob/living/carbon/human/proc/is_dullahan_head_partner()
	return FALSE

/mob/living/carbon/human/proc/is_erp_blocked_as_target()
	if(is_erp_defiant_in_combat())
		return TRUE

	if(has_erp_leprosy())
		return TRUE

	return FALSE

/mob/living/carbon/human/proc/is_erp_defiant_in_combat()
	return defiant && cmode

/mob/living/carbon/human/proc/is_erp_defiant()
	return defiant && client.prefs.sexable

/mob/living/carbon/human/proc/has_erp_leprosy()
	if(HAS_TRAIT(src, TRAIT_LEPROSY))
		return TRUE

	return FALSE

/mob/living/proc/start_erp_session(mob/living/target)
	if(!ishuman(src) || !ishuman(target))
		return

	return erp_try_start(src, target, src)

/mob/living/proc/start_erp_session_atom(atom/target_atom)
	if(!ishuman(src))
		return

	return erp_try_start(src, target_atom, src)

/mob/living/carbon/human/MiddleMouseDrop_T(atom/movable/dragged, mob/living/user)
	if(user.mmb_intent)
		return ..()

	if(!dragged)
		return

	var/is_head = istype(dragged, /obj/item/bodypart/head/dullahan)

	if(dragged != user && !is_head)
		return

	var/atom/initiator = is_head ? dragged : user

	return erp_try_start(initiator, src, user)

/mob/living/simple_animal/MiddleMouseDrop_T(atom/movable/dragged, mob/living/user)
	if(user.mmb_intent)
		return ..()

	if(!dragged)
		return

	var/is_head = istype(dragged, /obj/item/bodypart/head/dullahan)

	if(dragged != user && !is_head)
		return

	var/atom/initiator = is_head ? dragged : user

	return erp_try_start(initiator, src, user)

/mob/living/carbon/human/proc/set_sex_surrender_to(mob/living/carbon/human/mob_object)
	if(mob_object)
		sex_surrender_ref = WEAKREF(mob_object)
	else
		sex_surrender_ref = null

/mob/living/carbon/human/proc/is_surrendering_to(mob/living/carbon/human/mob_object)
	if(!mob_object || !sex_surrender_ref)
		return FALSE

	var/mob/living/carbon/human/target = sex_surrender_ref.resolve()
	if(!target || QDELETED(target))
		sex_surrender_ref = null
		return FALSE

	return target == mob_object

/mob/living/carbon/human/grippedby(mob/living/carbon/user, instant = FALSE)
	if(is_surrendering_to(user))
		instant = TRUE
		var/old_surrendering = surrendering
		surrendering = TRUE

		. = ..()

		surrendering = old_surrendering
		return .

	. = ..()
	return .

/mob/living/carbon/human/Login()
	. = ..()
	client?.prefs?.apply_erp_kinks_to_mob(src)
	SSerp.apply_prefs_for_mob(src)

/obj/item/bodypart/head/dullahan/MiddleMouseDrop_T(atom/movable/dragged, mob/living/user)
	if(user.mmb_intent)
		return ..()

	if(dragged != user)
		return

	return erp_try_start(user, src, user)

/obj/item/bodypart/head/dullahan/drop_limb(special)
	var/mob/living/carbon/human/user = original_owner
	var/datum/species/dullahan/user_species = user.dna.species

	user_species.soul_light_on(user)
	user_species.headless = TRUE
	SEND_SIGNAL(user, COMSIG_ERP_ANATOMY_CHANGED)
	
	grabbedby = SANITIZE_LIST(grabbedby)
	if(grabbedby)
		for(var/obj/item/grabbing/grab in grabbedby)
			if(grab.grab_state != GRAB_AGGRESSIVE)
				continue

			var/mob/living/carbon/human = grab.grabbee
			var/hand_index = human.get_held_index_of_item(grab)
			human.dropItemToGround(grab)

			if(!special)
				insert_worn_items()

			. = ..()

			human.put_in_hand(src, hand_index)
			grabbedby.Cut()
			return

		grabbedby.Cut()

	if(!special)
		insert_worn_items()

	. = ..()

/obj/item/bodypart/head/dullahan/attach_limb(mob/living/carbon/human/user)
	var/mob/living/carbon/human/user_dullahan = original_owner ? original_owner : user
	var/datum/species/dullahan/user_species = user_dullahan.dna.species
	user_species.soul_light_off()
	user_species.headless = FALSE
	SEND_SIGNAL(user, COMSIG_ERP_ANATOMY_CHANGED)
	for(var/item_slot in head_items)
		var/obj/item/worn_item = head_items[item_slot]
		if(worn_item)
			user_dullahan.equip_to_slot(worn_item, text2num(item_slot))
	head_items = list()
	return ..()

/mob/living/carbon/human/species/wildshape
	var/added_penis = FALSE
	var/added_testicles = FALSE
	var/added_breasts = FALSE
	var/added_vagina = FALSE

/mob/living/carbon/human/species/wildshape/proc/ensure_form_sex_organs_from_original(mob/living/carbon/human/original)
	if(!original)
		return

	if(ispath(internal_organs_slot?[ORGAN_SLOT_PENIS]))
		internal_organs_slot[ORGAN_SLOT_PENIS] = null
	if(ispath(internal_organs_slot?[ORGAN_SLOT_TESTICLES]))
		internal_organs_slot[ORGAN_SLOT_TESTICLES] = null
	if(ispath(internal_organs_slot?[ORGAN_SLOT_BREASTS]))
		internal_organs_slot[ORGAN_SLOT_BREASTS] = null
	if(ispath(internal_organs_slot?[ORGAN_SLOT_VAGINA]))
		internal_organs_slot[ORGAN_SLOT_VAGINA] = null

	if(original.getorganslot(ORGAN_SLOT_TESTICLES) && !getorganslot(ORGAN_SLOT_TESTICLES))
		var/obj/item/organ/testicles/T = new
		T.Insert(src, TRUE, FALSE)
		added_testicles = TRUE

	if(original.getorganslot(ORGAN_SLOT_PENIS) && !getorganslot(ORGAN_SLOT_PENIS))
		var/obj/item/organ/penis/knotted/big/P = new
		P.Insert(src, TRUE, FALSE)
		added_penis = TRUE

	if(original.getorganslot(ORGAN_SLOT_BREASTS) && !getorganslot(ORGAN_SLOT_BREASTS))
		var/obj/item/organ/breasts/B = new
		B.Insert(src, TRUE, FALSE)
		added_breasts = TRUE

	if(original.getorganslot(ORGAN_SLOT_VAGINA) && !getorganslot(ORGAN_SLOT_VAGINA))
		var/obj/item/organ/vagina/V = new
		V.Insert(src, TRUE, FALSE)
		added_vagina = TRUE

	SEND_SIGNAL(src, COMSIG_ERP_ANATOMY_CHANGED)

/mob/living/carbon/human/species/wildshape/proc/remove_form_sex_organs()
	if(added_penis)
		var/obj/item/organ/penis/P = getorganslot(ORGAN_SLOT_PENIS)
		if(P)
			P.Remove(src)
			qdel(P)
		added_penis = FALSE

	if(added_testicles)
		var/obj/item/organ/testicles/T = getorganslot(ORGAN_SLOT_TESTICLES)
		if(T)
			T.Remove(src)
			qdel(T)
		added_testicles = FALSE

	if(added_breasts)
		var/obj/item/organ/breasts/B = getorganslot(ORGAN_SLOT_BREASTS)
		if(B)
			B.Remove(src)
			qdel(B)
		added_breasts = FALSE

	if(added_vagina)
		var/obj/item/organ/vagina/V = getorganslot(ORGAN_SLOT_VAGINA)
		if(V)
			V.Remove(src)
			qdel(V)
		added_vagina = FALSE

	SEND_SIGNAL(src, COMSIG_ERP_ANATOMY_CHANGED)

/mob/living/carbon/human/proc/mirror_set_nudeshot_url()
	var/url = input(src, "Paste a direct image URL (http/https).", "Nude Shot URL") as null|text
	if(!url)
		return FALSE

	url = trimtext(url)
	if(length(url) > 512)
		to_chat(src, span_warning("That link is too long."))
		return FALSE

	var/lower = lowertext(url)
	if(!(findtext(lower, "http://") == 1 || findtext(lower, "https://") == 1))
		to_chat(src, span_warning("Only http/https links are allowed."))
		return FALSE

	nsfw_headshot_link = url
	update_body()
	update_body_parts()

	to_chat(src, span_notice("Your reflection settles into a new… compromising portrait."))
	return TRUE

/proc/erp_try_start(atom/initiator, atom/target_atom, mob/living/actor, silent = FALSE)
	if(!actor || !istype(actor))
		return null

	if(!target_atom || QDELETED(target_atom))
		return null

	if(istype(target_atom, /obj/structure/closet))
		return erp_try_start_container(initiator, target_atom, actor, silent)

	var/force = FALSE
	#ifdef LOCALTEST
		force = TRUE
	#endif

	if(!erp_can_use_menu_as_actor(actor, silent, force))
		return null

	var/mob/living/carbon/human/consent = SSerp.get_consent_mob_for_target(target_atom)
	if(!consent)
		return null

	if(!erp_can_target_atom_for_menu(actor, target_atom, silent, force))
		return null

	var/client/C = actor.client
	var/datum/erp_controller/EC = SSerp.get_or_create_controller(initiator, C, actor)
	if(!EC)
		return null

	EC.add_partner_atom(target_atom)
	EC.open_ui(actor)

	return EC

/proc/erp_can_use_menu_as_actor(mob/living/actor, silent = FALSE, force = FALSE)
	if(!actor || !istype(actor))
		return FALSE

	if(force)
		return TRUE

	var/mob/living/carbon/human/human_actor = actor
	if(!human_actor.can_do_sex)
		if(!silent)
			to_chat(actor, span_warning("I can't do this."))
		return FALSE

	if(human_actor.is_erp_blocked_as_target())
		return FALSE

	if(actor.client && actor.client.prefs && !actor.client.prefs.sexable)
		if(!silent)
			to_chat(actor, span_warning("You don't want to do this. (ERP preference)"))
		return FALSE

	return TRUE


/proc/erp_can_target_atom_for_menu(mob/living/actor, atom/target_atom, silent = FALSE, force = FALSE)
	if(!actor || !target_atom || QDELETED(target_atom))
		return FALSE

	var/mob/living/carbon/human/consent = SSerp.get_consent_mob_for_target(target_atom)
	if(!consent)
		return FALSE

	if(force)
		return TRUE

	if(consent.is_erp_blocked_as_target())
		return FALSE

	if(!consent.client)
		return FALSE

	if(consent.client && consent.client.prefs && !consent.client.prefs.sexable)
		if(!silent)
			to_chat(actor, span_warning("[consent] doesn't wish to be touched. (Their ERP preference)"))
			to_chat(consent, span_warning("[actor] failed to touch you. (Your ERP preference)"))
		log_combat(actor, consent, "tried unwanted ERP menu against")
		return FALSE

	return TRUE


/proc/erp_collect_valid_targets_from_container(atom/container, atom/initiator, mob/living/actor, silent = FALSE, force = FALSE)
	var/list/out = list()

	if(!container || QDELETED(container) || !actor)
		return out

	for(var/atom/movable/AM in container.contents)
		if(!AM || QDELETED(AM))
			continue

		if(!erp_can_target_atom_for_menu(actor, AM, TRUE, force))
			continue

		out += AM

	return out


/proc/erp_try_start_container(atom/initiator, atom/container, mob/living/actor, silent = FALSE)
	if(!actor || !container || QDELETED(container))
		return null

	var/force = FALSE
	#ifdef LOCALTEST
		force = TRUE
	#endif

	if(!erp_can_use_menu_as_actor(actor, silent, force))
		return null

	var/list/targets = erp_collect_valid_targets_from_container(container, initiator, actor, silent, force)
	if(!targets.len)
		if(!silent)
			to_chat(actor, span_warning("There is no valid partner inside."))
		return null

	var/client/C = actor.client
	var/datum/erp_controller/EC = SSerp.get_or_create_controller(initiator, C, actor)
	if(!EC)
		return null

	var/first = TRUE
	for(var/atom/target_atom as anything in targets)
		EC.add_partner_atom(target_atom, first)
		first = FALSE

	EC.open_ui(actor)
	return EC
