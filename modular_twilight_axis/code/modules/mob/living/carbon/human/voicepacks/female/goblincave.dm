/datum/voicepack/female/goblincave/get_sound(soundin, modifiers)
	var/used
	switch(modifiers)
		if("old")
			used = getfold(soundin)
		if("young")
			used = getfyoung(soundin)
		if("silenced")
			used = getfsilenced(soundin)
	if(!used)
		switch(soundin)
			if("chuckle")
				used = list('sound/vo/female/goblin/chuckle (1).ogg','sound/vo/female/goblin/chuckle (3).ogg','sound/vo/female/goblin/chuckle (4).ogg')
			if("giggle")
				used = list('sound/vo/female/goblin/giggle (1).ogg','sound/vo/female/goblin/giggle (4).ogg','sound/vo/female/goblin/giggle (6).ogg')
			if("laugh")
				used = pick('sound/vo/mobs/gob/laugh (1).ogg','sound/vo/mobs/gob/laugh (2).ogg')
			if("pain")
				used = pick('sound/vo/mobs/gob/pain (1).ogg','sound/vo/mobs/gob/pain (2).ogg','sound/vo/mobs/gob/pain (3).ogg','sound/vo/mobs/gob/pain (4).ogg','sound/vo/mobs/gob/pain (5).ogg')
			if("paincrit")
				used = pick('sound/vo/mobs/gob/pain (1).ogg','sound/vo/mobs/gob/pain (2).ogg','sound/vo/mobs/gob/pain (3).ogg','sound/vo/mobs/gob/pain (4).ogg','sound/vo/mobs/gob/pain (5).ogg')
			if("painscream")
				used = pick('sound/vo/mobs/gob/painscream (1).ogg','sound/vo/mobs/gob/painscream (2).ogg','sound/vo/mobs/gob/painscream (3).ogg','sound/vo/mobs/gob/painscream (4).ogg','sound/vo/mobs/gob/painscream (5).ogg')


	if(!used) //we haven't found a racial specific sound so use generic
		used = ..(soundin)
	return used

