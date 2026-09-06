/datum/voicepack/vurdalak

/datum/voicepack/vurdalak/get_sound(soundin, modifiers)
	var/used
	switch(soundin)
		if("aggro", "rage")
			used = pick('sound/vo/mobs/vurdalak/vurdalak_rage.ogg')

		if("deathgurgle")
			used = pick('sound/vo/mobs/vurdalak/vurd_death.ogg', 'sound/vo/mobs/vurdalak/vurdalak_dying.ogg')

		if("firescream", "painscream", "agony", "superagony")
			used = pick('sound/vo/mobs/vurdalak/vurdalak_scream.ogg', 'sound/vo/mobs/vurdalak/vurdalak_dying.ogg')

		if("pain", "paincrit", "painmoan", "embed")
			used = pick('sound/vo/mobs/vurdalak/vurdalak_scream.ogg', 'sound/vo/mobs/vurdalak/vurdalak_dying.ogg')

		if("jump", "leap")
			used = pick('sound/vo/mobs/vurdalak/vurd_jump.ogg', 'sound/vo/mobs/vurdalak/vurdalak_jump2.ogg')

		if("scream", "howl")
			used = pick('sound/vo/mobs/vurdalak/vurdalak_scream.ogg')

		if("idle", "gasp")
			used = pick('sound/vo/mobs/vurdalak/vurdalak_breath1.ogg', 'sound/vo/mobs/vurdalak/vurdalak_breath2.ogg')


	if(!used)
		used = ..(soundin, modifiers)
	return used
