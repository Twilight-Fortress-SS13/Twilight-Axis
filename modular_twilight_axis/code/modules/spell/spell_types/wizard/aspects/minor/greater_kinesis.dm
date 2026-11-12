// TA: Greater Kinesis minor aspect.
// Aspects are collected automatically from subtypesof(/datum/magic_aspect) by aspect_type
// (magic_aspect.dm: GLOB.magic_aspects_minor), so no original file needs editing.

/datum/magic_aspect/greater_kinesis
	name = "Greater Kinesis"
	latin_name = "Minor Aspectus Vis Maioris"
	desc = "A refinement of the humblest kinetic cantrips. Where an apprentice's Fetch and Repel can only nudge loose trinkets, the adept of Greater Kinesis grasps raw force firmly enough to hurl living bodies away and draw objects to hand at will."
	aspect_type = ASPECT_MINOR
	school_color = GLOW_COLOR_KINESIS
	binding_chants = list(
		"Let the unseen hand answer my will.",
		"Vis Maior, mihi adesse!",
	)
	unbinding_chants = list(
		"I release the unseen hand.",
		"Vis Maior, me relinquere!",
	)
	fixed_spells = list(
		/datum/action/cooldown/spell/projectile/greater_repel,
		/datum/action/cooldown/spell/projectile/greater_fetch,
	)
