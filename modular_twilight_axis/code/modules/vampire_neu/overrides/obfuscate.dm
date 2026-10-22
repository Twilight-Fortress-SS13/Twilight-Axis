/datum/coven_power/obfuscate/vanish_from_the_minds_eye
    parent_type = /datum/coven_power/obfuscate // 200 iq trick, don't remove. Trust me bro. Or we'll get duplicate def errors.

/datum/coven_power/obfuscate/vanish_from_the_minds_eye
    name = "Enhanced Unseen Presence"
    desc = "Disappear from plain view instantly while slowing and blinding your foes"
    level = 3
    research_cost = 2
    parent_type = /datum/coven_power/obfuscate/unseen_presence
    vitae_cost = parent_type::vitae_cost + 10
    COOLDOWN_DECLARE(effect_cooldown)

/datum/coven_power/obfuscate/vanish_from_the_minds_eye/activate()
    . = ..()

    if(!COOLDOWN_FINISHED(src, effect_cooldown))
        return

    for(var/mob/living/carbon/human/viewer in oviewers(7, owner))
        if(!viewer.client || viewer.stat || viewer.mob_biotypes & MOB_UNDEAD)
            continue

        viewer.Slowdown(3)
        viewer.blind_eyes(1)

    COOLDOWN_START(src, effect_cooldown, 30 SECONDS)
