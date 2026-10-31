/obj/item/clothing/ring/active/shimmeringlens
	cdtime = 3 MINUTES
	/// Who is currently looking through the lens (to remove the trait from the right mob).
	var/mob/living/lens_user

/obj/item/clothing/ring/active/shimmeringlens/proc/get_cd_left()
	if(!cooldowny)
		return 0
	return max(0, (cooldowny + cdtime) - world.time)

/obj/item/clothing/ring/active/shimmeringlens/examine(mob/user)
	. = ..()
	if(active)
		. += span_notice("It is being looked through right now.")
		return
	var/time_left = get_cd_left()
	if(time_left > 0)
		. += span_warning("It is still gathering arcana. ([DisplayTimeText(time_left)] remaining)")
	else
		. += span_notice("It is ready to be used.")

/obj/item/clothing/ring/active/shimmeringlens/attack_right(mob/user)
	if(loc != user)
		return
	if(active)
		to_chat(user, span_warning("I am already using this lens."))
		return
	var/time_left = get_cd_left()
	if(time_left > 0)
		to_chat(user, span_warning("Pulses weakily-! It must still be gathering arcana. ([DisplayTimeText(time_left)] remaining)"))
		return
	user.visible_message(span_warning("[user] looks through the [src]!"))
	if(activate_sound)
		playsound(user, activate_sound, 100, FALSE, -1)
	cooldowny = world.time
	addtimer(CALLBACK(src, PROC_REF(demagicify)), activetime)
	active = TRUE
	activate(user)

/obj/item/clothing/ring/active/shimmeringlens/activate(mob/user)
	lens_user = user
	ADD_TRAIT(user, TRAIT_XRAY_VISION, "[type]")

/obj/item/clothing/ring/active/shimmeringlens/demagicify()
	if(lens_user)
		REMOVE_TRAIT(lens_user, TRAIT_XRAY_VISION, "[type]")
		lens_user = null
	active = FALSE

/obj/item/clothing/ring/active/shimmeringlens/Destroy()
	if(lens_user)
		REMOVE_TRAIT(lens_user, TRAIT_XRAY_VISION, "[type]")
		lens_user = null
	return ..()
