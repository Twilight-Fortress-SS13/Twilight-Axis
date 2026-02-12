#define THRALLS_METHUSELAH	69
#define THRALLS_ANCILLAE	20
#define THRALLS_NEONATE		5
#define THRALLS_THINBLOOD 	1 // 0 - infinity. THINBLOOD can't convert anyway due the code.
#define THRALLS_DEFAULT 	1

/datum/antagonist/vampire/on_gain()
	. = ..()

	var/static/list/thrall_caps = alist(
		GENERATION_METHUSELAH = THRALLS_METHUSELAH,
		GENERATION_ANCILLAE  = THRALLS_ANCILLAE,
		GENERATION_NEONATE   = THRALLS_NEONATE,
		GENERATION_THINBLOOD = THRALLS_THINBLOOD,
	)

	var/cap = thrall_caps[generation]
	if(isnull(cap))
		cap = THRALLS_DEFAULT

	max_thralls = cap

#undef THRALLS_METHUSELAH
#undef THRALLS_ANCILLAE
#undef THRALLS_NEONATE
#undef THRALLS_THINBLOOD
#undef THRALLS_DEFAULT

