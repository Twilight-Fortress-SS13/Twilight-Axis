/datum/emote/living/lick/adjacentaction(mob/user, mob/target)
	. = ..()
	message_param = initial(message_param)
	if(!user || !target)
		return

	if(ishuman(user) && ishuman(target))
		var/mob/living/carbon/human/J = user
		var/do_change
		if(target.loc == user.loc)
			do_change = TRUE
		if(!do_change)
			if(J.pulling == target)
				do_change = TRUE

		if(do_change)
			if(J.zone_selected == BODY_ZONE_PRECISE_MOUTH)
				message_param = "licks %t lips."

			else if(J.zone_selected == BODY_ZONE_PRECISE_EARS)
				message_param = "licks the ear of %t."
				var/mob/living/carbon/human/O = target
				if(iself(O) || ishalfelf(O) || isdarkelf(O))
					if(!O.cmode)
						to_chat(target, span_love("It tickles..."))
					SEND_SIGNAL(O, COMSIG_SEX_RECEIVE_ACTION, user, 1, 0, FALSE, SEX_FORCE_LOW, SEX_SPEED_LOW, null)

			else if(J.zone_selected == BODY_ZONE_PRECISE_GROIN)
				message_param = "licks %t between the legs."
				to_chat(target, span_love("That feels nice..."))
				SEND_SIGNAL(target, COMSIG_SEX_RECEIVE_ACTION, user, 2, 0, FALSE, SEX_FORCE_LOW, SEX_SPEED_LOW, null)

			else if(J.zone_selected == BODY_ZONE_HEAD)
				message_param = "licks %t cheek"
			else
				message_param = "licks %t [parse_zone(J.zone_selected)]."

	if(user != target)
		var/mob/living/U = user
		var/mob/living/T = target

		var/datum/status_effect/erp_coating/E = T.has_status_effect(/datum/status_effect/erp_coating)
		if(E)
			var/taken = E.reagents.trans_to(U, 6)
			if(taken > 0)
				to_chat(U, span_love("Ты слизываешь с [T] влажные следы."))

	playsound(target.loc, pick("sound/vo/lick.ogg"), 100, FALSE, -1)

#define SPIT_MOUTH_DRAIN_UNITS 5

/datum/emote/living/spit/proc/_erp_try_spit_sex_mouth_liquid(mob/user)
	if(!ishuman(user))
		return FALSE

	var/mob/living/carbon/human/H = user
	var/datum/erp_sex_organ/mouth/M = H.get_erp_organ(SEX_ORGAN_MOUTH)
	if(!istype(M))
		return FALSE

	if(!M.has_liquid())
		return FALSE

	return M.spit(SPIT_MOUTH_DRAIN_UNITS)

/datum/emote/living/spit/proc/_erp_try_anchor_love_potion_in_hand(mob/user)
	if(!ishuman(user))
		return FALSE

	var/mob/living/carbon/human/H = user

	var/obj/item/reagent_containers/glass/bottle/alchemical/B = null
	var/obj/item/I = H.get_active_held_item()
	if(istype(I, /obj/item/reagent_containers/glass/bottle/alchemical))
		B = I
	else
		I = H.get_inactive_held_item()
		if(istype(I, /obj/item/reagent_containers/glass/bottle/alchemical))
			B = I

	if(!B || QDELETED(B) || !B.reagents)
		return FALSE

	var/datum/reagent/consumable/love_potion/LP = B.reagents.get_reagent(/datum/reagent/consumable/love_potion)
	if(!LP)
		return FALSE

	if(LP.get_anchor_mob())
		return FALSE

	if(!LP.set_anchor_mob(H))
		return FALSE

	to_chat(H, span_notice("You spit into the vial. The potion shimmers and binds to your essence."))
	return TRUE

/datum/emote/living/spit/run_emote(mob/user, params, type_override, intentional)
	message_param = initial(message_param)

	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		if(H.mouth)
			if(H.mouth.spitoutmouth)
				H.visible_message(span_warning("[H] spits out [H.mouth]."))
				H.dropItemToGround(H.mouth, silent = FALSE)
			return

	. = ..()

	_erp_try_spit_sex_mouth_liquid(user)
	_erp_try_anchor_love_potion_in_hand(user)

	return .


/datum/emote/living/spit/adjacentaction(mob/user, mob/target)
	. = ..()
	if(!user || !target)
		return

	if(user.gender == MALE)
		playsound(target.loc, pick('sound/vo/male/gen/spit.ogg'), 100, FALSE, -1)
	else
		playsound(target.loc, pick('sound/vo/female/gen/spit.ogg'), 100, FALSE, -1)

	_erp_try_spit_sex_mouth_liquid(user)
	_erp_try_anchor_love_potion_in_hand(user)

#undef SPIT_MOUTH_DRAIN_UNITS
