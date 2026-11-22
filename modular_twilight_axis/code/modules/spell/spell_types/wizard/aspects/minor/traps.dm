/datum/magic_aspect/traps
	name = "Traps"
	latin_name = "Minor Aspectus Exotutelae"
	desc = "TODO"
	aspect_type = ASPECT_MINOR
	school_color = GLOW_COLOR_ARCANE
	binding_chants = list()
	unbinding_chants = list()
	choice_spells = list(
		/obj/effect/proc_holder/spell/invoked/ShroudTrap,
        /obj/effect/proc_holder/spell/invoked/rotting_cloud,
	)
