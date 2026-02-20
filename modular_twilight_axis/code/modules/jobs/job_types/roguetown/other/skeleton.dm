/datum/job/roguetown/skeleton
    title = "Skeleton"
    faction = "Station"
    tutorial = null
    total_positions = 0
    spawn_positions = 0
    antag_job = TRUE
    outfit = /datum/outfit/job/roguetown/cult/skeleton/zizoid/raider
    give_bank_account = FALSE
    hidden_job = TRUE

    job_traits = list(
        TRAIT_NOMOOD,
        TRAIT_NOLIMBDISABLE,
        TRAIT_NOHUNGER,
        TRAIT_NOBREATH,
        TRAIT_NOPAIN,
        TRAIT_TOXIMMUNE,
        TRAIT_NOSLEEP,
        TRAIT_SHOCKIMMUNE
    )

/datum/job/roguetown/skeleton/after_spawn(mob/living/carbon/human/spawned, client/player_client)
    . = ..()

    spawned.mind.special_role = "Skeleton"
    spawned.mind?.current.job = null

    // Randomize stats here
    spawned.STASTR = rand(8, 10)
    spawned.STASPD = rand(7, 10)
    spawned.STAINT = 1
    spawned.STACON = 3

    if(spawned.dna && spawned.dna.species)
        spawned.dna.species.species_traits |= NOBLOOD
        spawned.dna.species.soundpack_m = new /datum/voicepack/skeleton()
        spawned.dna.species.soundpack_f = new /datum/voicepack/skeleton()

    spawned.regenerate_limb(BODY_ZONE_R_ARM)
    spawned.regenerate_limb(BODY_ZONE_L_ARM)

    for(var/obj/item/bodypart/part as anything in spawned.bodyparts)
        part.skeletonize(FALSE)

    spawned.base_intents = list(INTENT_HELP, INTENT_DISARM, INTENT_GRAB, /datum/intent/simple/claw)
    spawned.update_a_intents()
    spawned.ambushable = FALSE
    spawned.underwear = "Nude"
    spawned.update_body()
    spawned.mob_biotypes = MOB_UNDEAD
    spawned.grant_language(/datum/language/undead)

/datum/job/roguetown/skeleton/zizoid
	title = "Cult Summon"
	outfit = /datum/outfit/job/roguetown/cult/skeleton/zizoid/raider

/datum/job/roguetown/skeleton/zizoid/after_spawn(mob/living/carbon/human/spawned, client/player_client)
    . = ..()
    spawned.mind?.special_role = "Cult Summon"
    spawned.mind?.current.job = null
    spawned.set_patron(/datum/patron/inhumen/zizo)

    // Randomized stats
    spawned.STASTR = rand(8, 17)
    spawned.STASPD = rand(7, 10)
    spawned.STAINT = 1
    spawned.STACON = 3

    spawned.verbs |= /mob/living/carbon/human/proc/praise
    spawned.verbs |= /mob/living/carbon/human/proc/communicate

/datum/outfit/skeleton
	name = "Skeleton"

/datum/outfit/skeleton/pre_equip(mob/living/carbon/human/equipped_human)
	. = ..()
	equipped_human.underwear = "Nude"
