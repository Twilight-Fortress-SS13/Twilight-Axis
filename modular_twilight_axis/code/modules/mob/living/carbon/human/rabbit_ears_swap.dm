#define RABBIT_EAR_SWAP_COOLDOWN (3 SECONDS)

GLOBAL_LIST_INIT(rabbit_ear_swap_cycle, list(
	/datum/sprite_accessory/ears/big/rabbit_medium,
	/datum/sprite_accessory/ears/big/rabbit_floppy,
	/datum/sprite_accessory/ears/big/rabbit_floppyalt,
))

/mob/living/carbon/human
	COOLDOWN_DECLARE(rabbit_ear_swap_cd)

/mob/living/carbon/human/proc/has_swappable_rabbit_ears()
	var/obj/item/organ/ears/ears = getorganslot(ORGAN_SLOT_EARS)
	if(!ears || !ears.accessory_type)
		return FALSE
	return (ears.accessory_type in GLOB.rabbit_ear_swap_cycle)

/mob/living/carbon/human/proc/update_rabbit_ear_swap_verb()
	if(has_swappable_rabbit_ears())
		add_verb(src, /mob/living/carbon/human/proc/swap_rabbit_ears)
	else
		remove_verb(src, /mob/living/carbon/human/proc/swap_rabbit_ears)

/mob/living/carbon/human/proc/swap_rabbit_ears()
	set name = "Swap Rabbit Ears"
	set category = "RoleUnique.Ears"
	set desc = "Change the shape of my rabbit ears."

	if(stat == DEAD)
		return

	if(!has_swappable_rabbit_ears())
		remove_verb(src, /mob/living/carbon/human/proc/swap_rabbit_ears)
		to_chat(src, span_warning("I don't have rabbit ears that I could move around."))
		return

	if(!COOLDOWN_FINISHED(src, rabbit_ear_swap_cd))
		var/seconds_left = CEILING((rabbit_ear_swap_cd - world.time) / 10, 1)
		to_chat(src, span_warning("My ears need a moment before I can fidget with them again ([seconds_left]s)."))
		return

	var/obj/item/organ/ears/ears = getorganslot(ORGAN_SLOT_EARS)
	var/list/cycle = GLOB.rabbit_ear_swap_cycle
	var/current_index = cycle.Find(ears.accessory_type)
	var/new_type = cycle[(current_index % length(cycle)) + 1]

	ears.set_accessory_type(new_type, ears.accessory_colors)

	if(dna)
		var/datum/organ_dna/ear_dna = dna.organ_dna[ORGAN_SLOT_EARS]
		if(ear_dna)
			ear_dna.accessory_type = new_type
			ear_dna.accessory_colors = ears.accessory_colors

	update_body()
	COOLDOWN_START(src, rabbit_ear_swap_cd, RABBIT_EAR_SWAP_COOLDOWN)

	var/datum/sprite_accessory/new_style = SPRITE_ACCESSORY(new_type)
	to_chat(src, span_notice("I shift my ears into [new_style.name]."))
