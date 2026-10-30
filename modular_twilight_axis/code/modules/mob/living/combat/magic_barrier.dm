// Magic Barrier (TRAIT_MAGEARMOR)
// Возвращаем то, что Форон отнял у нас в коммите 2f7e7cb8cf "Nuke Mage Armor".

/atom/movable/screen/alert/status_effect/magic_barrier
	name = "Magick Barrier"
	desc = "An arcyne barrier surrounds me, ready to absorb the next blow."
	icon = 'modular_twilight_axis/icons/mob/screen_alert_magic_barrier.dmi'
	icon_state = "barrier_full"

/datum/status_effect/magic_barrier
	id = "magic_barrier"
	duration = -1
	status_type = STATUS_EFFECT_UNIQUE
	alert_type = /atom/movable/screen/alert/status_effect/magic_barrier
	needs_processing = FALSE

/atom/movable/screen/alert/status_effect/magic_barrier_cooldown
	name = "Shattered Barrier"
	desc = "My magick barrier is shattered!"
	icon = 'modular_twilight_axis/icons/mob/screen_alert_magic_barrier.dmi'
	icon_state = "barrier_shattered"

/datum/status_effect/magic_barrier_cooldown
	id = "magic_barrier_cooldown"
	status_type = STATUS_EFFECT_UNIQUE
	alert_type = /atom/movable/screen/alert/status_effect/magic_barrier_cooldown

/datum/status_effect/magic_barrier_cooldown/on_apply()
	. = ..()
	duration = max(7 - owner.get_skill_level(/datum/skill/combat/arcyne), 1) MINUTES

/datum/status_effect/magic_barrier_cooldown/on_remove()
	. = ..()

	// Эффект сняли досрочно — барьер не восстанавливаем.
	if(world.time < duration)
		return

	if(QDELETED(owner) || !HAS_TRAIT(owner, TRAIT_MAGEARMOR))
		return

	to_chat(owner, span_notice("My magical barrier reforms."))
	playsound(owner, 'sound/magic/magearmorup.ogg', 75, FALSE)
	owner.apply_status_effect(/datum/status_effect/magic_barrier)

/atom/movable/screen/alert/status_effect/magic_barrier_suppressed
	name = "Armour Interference"
	desc = "My armour is too heavy. My magick barrier cannot reform while I wear it."
	icon = 'modular_twilight_axis/icons/mob/screen_alert_magic_barrier.dmi'
	icon_state = "barrier_suppressed"

/datum/status_effect/magic_barrier_suppressed
	id = "magic_barrier_suppressed"
	duration = -1
	status_type = STATUS_EFFECT_UNIQUE
	alert_type = /atom/movable/screen/alert/status_effect/magic_barrier_suppressed
	needs_processing = FALSE

/mob/living/carbon/human/Initialize(mapload)
	. = ..()
	RegisterSignal(src, SIGNAL_ADDTRAIT(TRAIT_MAGEARMOR), PROC_REF(on_magearmor_gained))
	RegisterSignal(src, SIGNAL_REMOVETRAIT(TRAIT_MAGEARMOR), PROC_REF(on_magearmor_lost))

/mob/living/carbon/human/proc/on_magearmor_gained(datum/source)
	SIGNAL_HANDLER
	update_magic_barrier_suppression()

	if(has_status_effect(/datum/status_effect/magic_barrier_suppressed) \
		|| has_status_effect(/datum/status_effect/magic_barrier_cooldown))
		return

	apply_status_effect(/datum/status_effect/magic_barrier)

/mob/living/carbon/human/proc/on_magearmor_lost(datum/source)
	SIGNAL_HANDLER
	remove_status_effect(/datum/status_effect/magic_barrier)
	remove_status_effect(/datum/status_effect/magic_barrier_cooldown)
	remove_status_effect(/datum/status_effect/magic_barrier_suppressed)

// Мы не можем использовать COMSIG_MOB_UNEQUIPPED_ITEM для возвращения регена барьера без костылей,
// потому как он отправляется, когда слоты ещё не обнулены.
// Оверайд вместо сигнала нужен, чтобы не забагалось раздевание не через собственные ручки
// (например, когда пешку раздевают третьи лица или броня слетает через вайс Loose Straps).
/mob/living/carbon/human/doUnEquip(obj/item/I, force, newloc, no_move, invdrop = TRUE, silent = FALSE)
	. = ..()
	if(. && istype(I, /obj/item/clothing) && !QDELETED(src))
		update_magic_barrier_suppression()

/obj/item/clothing/equipped(mob/user, slot)
	. = ..()
	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		H.update_magic_barrier_suppression()

/mob/living/carbon/human/proc/update_magic_barrier_suppression()
	if(!HAS_TRAIT(src, TRAIT_MAGEARMOR))
		return

	var/suppressed = has_status_effect(/datum/status_effect/magic_barrier_suppressed)

	if(!check_magic_barrier_armor_class())
		if(suppressed)
			return

		if(has_status_effect(/datum/status_effect/magic_barrier))
			playsound(src, 'sound/magic/magearmordown.ogg', 75, FALSE)
			visible_message(
				span_warning("[src]'s magick barrier falters and breaks under the weight of [p_their()] armour!"),
				span_boldwarning("The weight of my armour disrupts the magick barrier!")
			)
		else
			to_chat(src, span_warning("My armour is too heavy. My magick barrier cannot reform while I wear it."))

		remove_status_effect(/datum/status_effect/magic_barrier)
		remove_status_effect(/datum/status_effect/magic_barrier_cooldown)
		apply_status_effect(/datum/status_effect/magic_barrier_suppressed)

		return

	if(!suppressed)
		return

	remove_status_effect(/datum/status_effect/magic_barrier_suppressed)
	apply_status_effect(/datum/status_effect/magic_barrier_cooldown)
	to_chat(src, span_info("Without that armor interfering, my magick barrier begins to reform."))

// Должен вызываться перед тем, как проходит атака ближнего боя.
// Возвращает TRUE, если барьер должен её впитать.
/mob/living/proc/check_mage_armor(atom/source)
	if(!has_status_effect(/datum/status_effect/magic_barrier))
		return FALSE
	if(!cmode)
		return FALSE
	if(!source || source == src)  // Нужно ли ломать собственный барьер..?
		return FALSE
	if(!check_magic_barrier_armor_class())
		return FALSE

	remove_status_effect(/datum/status_effect/magic_barrier)
	apply_status_effect(/datum/status_effect/magic_barrier_cooldown)

	playsound(src, 'sound/magic/magearmordown.ogg', 75, FALSE)
	visible_message(
		span_warning("[src]'s magick barrier flares and absorbs the blow!"),
		span_boldwarning("My magick barrier absorbs the hit and dissipates!")
	)

	return TRUE

// TRUE, если персонаж носит армор, совместимый с барьером.
/mob/living/proc/check_magic_barrier_armor_class()
	return TRUE

/mob/living/carbon/human/check_magic_barrier_armor_class()
	return highest_ac_worn(FALSE, TRUE) <= ARMOR_CLASS_LIGHT

// В первую очередь пробуем парирование/уклонение, затем уже расходуем барьер.
// Распространяется только на ближний бой, чтобы маги не впитывали аркебузу.
/mob/living/checkdefense(datum/intent/attack_intent, mob/living/user)
	. = ..()
	if(.)
		return
	if(check_mage_armor(user))
		return TRUE

GLOBAL_LIST_INIT(magearmor_advclasses, list(
	/datum/advclass/hedgemage,
	/datum/advclass/mage,
	/datum/advclass/mage/spellsinger,
	/datum/advclass/heartfelt/hand/advisor,
	/datum/advclass/heartfelt/lord/archmage,
	/datum/advclass/heartfelt/retinue/magos,
	/datum/advclass/trader/scholar,
	/datum/advclass/wretch/necromancer,
	/datum/advclass/wretch/roguemage,
	/datum/advclass/wapprentice/associate,
	/datum/advclass/wapprentice/associate/apprentice,
	/datum/advclass/hand/advisor,
	/datum/advclass/lord/mage,
	/datum/advclass/heir/bookworm,
	/datum/advclass/mercenary/warscholar,
	/datum/advclass/vagabond_mage,
	// Ниже идут классы, появившиеся после удаления барьера.
	/datum/advclass/mage/spellfist,
	/datum/advclass/mage/spellthief,
	// "Spellblade 2 rework" отдельно удалил спеллблейдам барьер, посему их здесь нет.
))

GLOBAL_LIST_INIT(magearmor_jobs, list(
	/datum/job/roguetown/archivist,
	/datum/job/roguetown/magician,
))

/datum/advclass/New()
	. = ..()
	if(type in GLOB.magearmor_advclasses)
		LAZYOR(traits_applied, TRAIT_MAGEARMOR)

/datum/job/New()
	. = ..()
	if(type in GLOB.magearmor_jobs)
		LAZYOR(job_traits, TRAIT_MAGEARMOR)
