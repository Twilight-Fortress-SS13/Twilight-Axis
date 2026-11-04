#define BLOOD_HANDS_MIN 2
#define BLOOD_HANDS_MAX 4

/obj/effect/decal/cleanable/blood
	mouse_opacity = MOUSE_OPACITY_ICON

/obj/effect/decal/cleanable/blood/attack_hand(mob/living/carbon/human/user)
	. = ..()
	if(!ishuman(user))
		return
	if(user.used_intent.type != INTENT_HELP)
		return
	if(user.get_active_held_item())
		return
	if(user.cmode)
		return
	if(user.bloody_hands)
		return

	user.visible_message(
		span_warning("[user] runs [user.p_their()] hand through [src]."),
		span_warning("I run my hand through [src].")
	)

	if(!do_after(user, 1 SECONDS, needhand = TRUE, target = src))
		return

	if(QDELETED(user) || QDELETED(src))
		return

	user.bloody_hands = rand(BLOOD_HANDS_MIN, BLOOD_HANDS_MAX)
	user.update_inv_gloves()

#undef BLOOD_HANDS_MIN
#undef BLOOD_HANDS_MAX
