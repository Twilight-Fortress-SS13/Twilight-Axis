/obj/effect/proc_holder/spell/self/zizo_regenerate
	name = "Regenerate"
	desc = "Your wounds painfully mend back together."
	overlay_state = "bloodrage"
	recharge_time = 1 MINUTES
	invocations = list("AHH, SO HURT!!"
	)
	invocation_type = "shout"
	sound = 'sound/misc/vampirespell.ogg'
	releasedrain = 30
	antimagic_allowed = FALSE
	ignore_cockblock = TRUE
	var/static/list/purged_effects = list(
	/datum/status_effect/incapacitating/immobilized,
	/datum/status_effect/incapacitating/paralyzed,
	/datum/status_effect/incapacitating/stun,
	/datum/status_effect/incapacitating/knockdown,)

/obj/effect/proc_holder/spell/self/zizo_regenerate/cast(list/targets, mob/user)
	. = ..()
	if(!ishuman(user))
		revert_cast()
		return FALSE
	var/mob/living/carbon/human/H = user
	H.adjustBruteLoss(-100)
	H.adjustFireLoss(-100)
	H.adjustToxLoss(-100)
	if(H.resting)
		H.set_resting(FALSE, FALSE)
	H.emote("warcry")
	for(var/effect in purged_effects)
		H.remove_status_effect(effect)
	return TRUE

/obj/item/clothing/suit/roguetown/armor/manual/resting/padded/bailiff
	name = "scar-marred skin"
	desc = "Bearing scars of countless whips leaves a gnarly visage. Now it's your time to inflict the same fate upon others."
	armor = ARMOR_PADDED
	max_integrity = ARMOR_INT_CHEST_LIGHT_MEDIUM

/obj/item/clothing/suit/roguetown/armor/manual/meditation/body/lunacy
	name = "lunacy skin"
	attachment_component = null
	desc = "The moon calls and my skin answers. I ran wild under its light until my flesh hardened like stone beneath a hunter's boot.\
	</br>Now I meditate, and it knits itself whole once more. I do not remember who I was before.\
	</br>I do not care to."
	armor = list("blunt" = DR_HEAVY, "slash" = DBLOCK_HEAVY, "stab" = DBLOCK_HEAVY, "piercing" = DBLOCK_MEDIUM, "fire" = DR_NONE, "bullet" = DR_SUPER)
	max_integrity = ARMOR_INT_CHEST_PLATE_BRIGANDINE - ARMOR_INT_CHEST_PLATE_BRIGANDINE_WEIGHT_MODIFIER
	repairmsg_end = "The moonlight fades from my skin as it settles into calm strength."
	repairmsg_continue = "My skin knits itself under the moon's gaze..."
	repairmsg_full = "My lunacy skin is already whole."

/obj/item/clothing/suit/roguetown/armor/manual/meditation/chest/lunacy
	name = "lunacy core"
	attachment_component = null
	desc = "Deeper than the skin, harder than the bone. The moon's blessing settled here first, in the place where breath lives.\
	</br>To strike this core is to strike the riverbed; the water parts, and the stone remains.\
	</br>I meditate to keep it so."
	armor = ARMOR_BRIGANDINE
	max_integrity = ARMOR_INT_CHEST_PLATE_BRIGANDINE - ARMOR_INT_CHEST_PLATE_BRIGANDINE_WEIGHT_MODIFIER
	repairmsg_end = "The moonlight fades from my chest as it settles into calm strength."
	repairmsg_continue = "My chest core knits itself under the moon's gaze..."
	repairmsg_full = "My lunacy core is already whole."
