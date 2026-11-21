/datum/voicepack/female/get_sound(soundin, modifiers)
	switch(soundin)
		if("venard_cackle")
			. = list(
				'modular_twilight_axis/sound/vo/mobs/venard/fox_cackle_1.ogg',
				'modular_twilight_axis/sound/vo/mobs/venard/fox_cackle_2.ogg',
				'modular_twilight_axis/sound/vo/mobs/venard/fox_cackle_3.ogg',
				)

	return . || ..()
