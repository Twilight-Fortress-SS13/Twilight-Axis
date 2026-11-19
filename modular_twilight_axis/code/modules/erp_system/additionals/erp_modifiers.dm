// Пример возможного бафа (пока не введено, но заготовка)
// /datum/status_effect/erp/oil_skin/on_apply()
// 	. = ..()
// 	var/mob/living/carbon/human/H = owner
// 	if(!istype(H))
// 		return
// 	RegisterSignal(H, COMSIG_SEX_MODIFY_EFFECT, PROC_REF(modify_sex_effect))

// /datum/status_effect/erp/oil_skin/on_remove()
// 	. = ..()
// 	var/mob/living/carbon/human/H = owner
// 	if(!istype(H))
// 		return
// 	UnregisterSignal(H, COMSIG_SEX_MODIFY_EFFECT)

// /datum/status_effect/erp/oil_skin/proc/modify_sex_effect(mob/living/carbon/human/H, list/effect)
// 	SIGNAL_HANDLER

// 	// например, снижает боль на 40%
// 	var/pain = effect["pain"] || 0
// 	pain *= 0.6
// 	effect["pain"] = pain
