/datum/looping_sound/instrument
	mid_length = 2400 // 4 minutes for some reason. better would be each song having a specific length
	volume = 100
	extra_range = 5
	blocked_z_levels = list(1)
	persistent_loop = TRUE
	var/stress2give = /datum/stressevent/music
	sound_group = /datum/sound_group/instruments //reserves sound channels for up to 10 instruments at a time
	filter_pref = SOUND_INSTRUMENTS

/obj/item/rogue/instrument
	name = ""
	desc = ""
	icon = 'icons/roguetown/items/music.dmi'
	icon_state = ""
	slot_flags = ITEM_SLOT_HIP|ITEM_SLOT_BACK_R|ITEM_SLOT_BACK_L
	can_parry = TRUE
	force = 23
	throwforce = 7
	throw_range = 4
	var/lastfilechange = 0
	var/curvol = 100
	var/datum/looping_sound/instrument/soundloop
	var/list/song_list = list()
	var/note_color = "#7f7f7f"
	var/groupplaying = FALSE
	var/curfile = ""
	var/playing = FALSE
	grid_height = 64
	grid_width = 32

/obj/item/rogue/instrument/equipped(mob/living/user, slot)
	. = ..()
	//TA edit - Bard chages start
	if(playing && user.get_active_held_item() != src)
		stop_music(user)
	//TA edit - Bard chages end

/obj/item/rogue/instrument/getonmobprop(tag)
	. = ..()
	if(tag)
		switch(tag)
			if("gen")
				return list("shrink" = 0.4,"sx" = 0,"sy" = 2,"nx" = 1,"ny" = -4,"wx" = -1,"wy" = 2,"ex" = 7,"ey" = 1,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = 0,"sturn" = 0,"wturn" = -2,"eturn" = -2,"nflip" = 8,"sflip" = 8,"wflip" = 8,"eflip" = 0)
			if("onbelt")
				return list("shrink" = 0.3,"sx" = -2,"sy" = -5,"nx" = 4,"ny" = -5,"wx" = 0,"wy" = -5,"ex" = 2,"ey" = -5,"nturn" = 0,"sturn" = 0,"wturn" = 0,"eturn" = 0,"nflip" = 0,"sflip" = 0,"wflip" = 0,"eflip" = 0,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0)

/obj/item/rogue/instrument/Initialize(mapload)
	soundloop = new(src, FALSE)
	//TA edit - Bard chages
	ensure_timed_tracks()
	. = ..()

/obj/item/rogue/instrument/Destroy()
	qdel(soundloop)
	. = ..()

/obj/item/rogue/instrument/dropped(mob/living/user, silent)
	..()
	//TA edit - Bard chages
	stop_music(user)

/obj/item/rogue/instrument/attack_self(mob/living/user)
	. = ..()
	if(.)
		return
	user.changeNext_move(CLICK_CD_MELEE)
	//TA edit - Bard chages start
	if(playing)
		return
	if(user.mind)
		switch(user.get_skill_level(/datum/skill/misc/music))
			if(1)
				note_color = "#ffffff"
				soundloop.stress2give = /datum/stressevent/music/novice
			if(2)
				note_color = "#ffffff"
				soundloop.stress2give = /datum/stressevent/music/apprentice
			if(3)
				note_color = "#1eff00"
				soundloop.stress2give = /datum/stressevent/music/journeyman
			if(4)
				note_color = "#0070dd"
				soundloop.stress2give = /datum/stressevent/music/expert
			if(5)
				note_color = "#a335ee"
				soundloop.stress2give = /datum/stressevent/music/master
			if(6)
				note_color = "#ff8000"
				soundloop.stress2give = /datum/stressevent/music/legendary
			else
				note_color = initial(note_color)
				soundloop.stress2give = /datum/stressevent/music
	else
		note_color = initial(note_color)
		soundloop.stress2give = /datum/stressevent/music
	ui_interact(user)
	//TA edit - Bard chages end

/obj/item/rogue/instrument/lute
	name = "lute"
	desc = "Its graceful curves were designed to weave joyful melodies."
	icon_state = "lute"
	song_list = list(
		"A Knight's Return" = sound("sound/music/instruments/lute (1).ogg"),
		"Amongst Fare Friends" = sound("sound/music/instruments/lute (2).ogg"),
		"The Road Traveled by Few" = sound("sound/music/instruments/lute (3).ogg"),
		"Tip Thine Tankard" = sound("sound/music/instruments/lute (4).ogg"),
		"A Reed On the Wind" = sound("sound/music/instruments/lute (5).ogg"),
		"Jests On Steel Ears" = sound("sound/music/instruments/lute (6).ogg"),
		"Merchant in the Mire" = sound("sound/music/instruments/lute (7).ogg"),
		"The Power" = sound("sound/music/instruments/lute (8).ogg"),
		"Bard Dance" = sound("sound/music/instruments/lute (9).ogg"),
		"Old Time Battles" = sound("sound/music/instruments/lute (10).ogg")
	)

/obj/item/rogue/instrument/accord
	name = "accordion"
	desc = "A harmonious vessel of nostalgia and celebration."
	icon_state = "accordion"
	song_list = list(
		"Her Healing Tears" = sound("sound/music/instruments/accord (1).ogg"),
		"Peddler's Tale" = sound("sound/music/instruments/accord (2).ogg"),
		"We Toil Together" = sound("sound/music/instruments/accord (3).ogg"),
		"Just One More, Tavern Wench" = sound("sound/music/instruments/accord (4).ogg"),
		"Moonlight Carnival" = sound("sound/music/instruments/accord (5).ogg"),
		"\"Ye Best Be Goin\"" = sound("sound/music/instruments/accord (6).ogg"),
		"Beloved Blue" = sound("sound/music/instruments/accord (7).ogg")
	)

/obj/item/rogue/instrument/guitar
	name = "guitar"
	desc = "This is a guitar, chosen instrument of wanderers and the heartbroken."
	icon_state = "guitar"
	song_list = list(
		"Fire-Cast Shadows" = sound("sound/music/instruments/guitar (1).ogg"),
		"The Forced Hand" = sound("sound/music/instruments/guitar (2).ogg"),
		"Regrets Unpaid" = sound("sound/music/instruments/guitar (3).ogg"),
		"\"Took the Mammon and Ran\"" = sound("sound/music/instruments/guitar (4).ogg"),
		"Poor Man's Tithe" = sound("sound/music/instruments/guitar (5).ogg"),
		"In His Arms Ye'll Find Me" = sound("sound/music/instruments/guitar (6).ogg"),
		"El Odio" = sound("sound/music/instruments/guitar (7).ogg"),
		"Danza De Las Lanzas" = sound("sound/music/instruments/guitar (8).ogg"),
		"The Feline, Forever Returning" = sound("sound/music/instruments/guitar (9).ogg"),
		"El Beso Carmesí" = sound("sound/music/instruments/guitar (10).ogg"),
		"The Queen's High Seas" = sound("sound/music/instruments/guitar (11).ogg"),
		"Harsh Testimony" = sound("sound/music/instruments/guitar (12).ogg"),
		"Someone Fair" = sound("sound/music/instruments/guitar (13).ogg"),
		"Daisies in Bloom" = sound("sound/music/instruments/guitar (14).ogg")
	)

/obj/item/rogue/instrument/harp
	name = "harp"
	desc = "A harp of elven craftsmanship."
	icon_state = "harp"
	song_list = list(
		"Through Thine Window, He Glanced" = sound("sound/music/instruments/harb (1).ogg"),
		"The Lady of Red Silks" = sound("sound/music/instruments/harb (2).ogg"),
		"Eora Doth Watches" = sound("sound/music/instruments/harb (3).ogg"),
		"On the Breeze" = sound("sound/music/instruments/harb (4).ogg"),
		"Never Enough" = sound("sound/music/instruments/harb (5).ogg"),
		"Sundered Heart" = sound("sound/music/instruments/harb (6).ogg"),
		"Corridors of Time" = sound("sound/music/instruments/harb (7).ogg"),
		"Determination" = sound("sound/music/instruments/harb (8).ogg")
	)

/obj/item/rogue/instrument/flute
	name = "flute"
	desc = "A row of slender hollow tubes of varying lengths that produce a light airy sound when blown across."
	icon_state = "flute"
	song_list = list(
		"Half-Dragon's Ten Mammon" = sound("sound/music/instruments/flute (1).ogg"),
		"'The Local Favorite'" = sound("sound/music/instruments/flute (2).ogg"),
		"Rous in the Cellar" = sound("sound/music/instruments/flute (3).ogg"),
		"Her Boots, So Incandescent" = sound("sound/music/instruments/flute (4).ogg"),
		"Moondust Minx" = sound("sound/music/instruments/flute (5).ogg"),
		"Quest to the Ends" = sound("sound/music/instruments/flute (6).ogg"),
		"Spit Shine" = sound("sound/music/instruments/flute (7).ogg"),
		"The Power" = sound("sound/music/instruments/flute (8).ogg"),
		"Bard Dance" = sound("sound/music/instruments/flute (9).ogg"),
		"Old Time Battles" = sound("sound/music/instruments/flute (10).ogg")
	)

/obj/item/rogue/instrument/drum
	name = "drum"
	desc = "Fashioned from taut skins across a sturdy frame, pulses like a giant heartbeat."
	icon_state = "drum"
	song_list = list(
		"Barbarian's Moot" = sound("sound/music/instruments/drum (1).ogg"),
		"Muster the Wardens" = sound("sound/music/instruments/drum (2).ogg"),
		"The Earth That Quakes" = sound("sound/music/instruments/drum (3).ogg"),
		"The Power" = sound("sound/music/instruments/drum (4).ogg"),
		"Bard Dance" = sound("sound/music/instruments/drum (5).ogg"),
		"Old Time Battles" = sound("sound/music/instruments/drum (6).ogg")
	)

/obj/item/rogue/instrument/hurdygurdy
	name = "hurdy-gurdy"
	desc = "A knob-driven, wooden string instrument that reminds you of the oceans far."
	icon_state = "hurdygurdy"
	song_list = list(
		"Ruler's One Ring" = sound("sound/music/instruments/hurdy (1).ogg"),
		"Tangled Trod" = sound("sound/music/instruments/hurdy (2).ogg"),
		"Motus" = sound("sound/music/instruments/hurdy (3).ogg"),
		"Becalmed" = sound("sound/music/instruments/hurdy (4).ogg"),
		"The Bloody Throne" = sound("sound/music/instruments/hurdy (5).ogg"),
		"We Shall Sail Together" = sound("sound/music/instruments/hurdy (6).ogg")
	)

/obj/item/rogue/instrument/viola
	name = "viola"
	desc = "The prim and proper Viola, every prince's first instrument taught."
	icon_state = "viola"
	song_list = list(
		"Far Flung Tale" = sound("sound/music/instruments/viola (1).ogg"),
		"G Major Cello Suite No. 1" = sound("sound/music/instruments/viola (2).ogg"),
		"Ursine's Home" = sound("sound/music/instruments/viola (3).ogg"),
		"Mead, Gold and Blood" = sound("sound/music/instruments/viola (4).ogg"),
		"Gasgow's Reel" = sound("sound/music/instruments/viola (5).ogg"),
		"The Power" = sound("sound/music/instruments/viola (6).ogg"),
		"Bard Dance" = sound("sound/music/instruments/viola (7).ogg"),
		"Old Time Battles" = sound("sound/music/instruments/viola (8).ogg")
	)

/obj/item/rogue/instrument/vocals
	name = "vocalist's talisman"
	desc = "This talisman emanates a soft shimmer of light. When held, it can amplify and even change a bard's voice."
	icon_state = "vtalisman"
	song_list = list(
		"Harpy's Call (Feminine)" = sound("sound/music/instruments/vocalsf (1).ogg"),
		"Necra's Lullaby (Feminine)" = sound("sound/music/instruments/vocalsf (2).ogg"),
		"Death Touched Aasimar (Feminine)" = sound("sound/music/instruments/vocalsf (3).ogg"),
		"Our Mother, Our Divine (Feminine)" = sound("sound/music/instruments/vocalsf (4).ogg"),
		"Wed, Forever More (Feminine)" = sound("sound/music/instruments/vocalsf (5).ogg"),
		"Paper Boats (Feminine + Vocals)" = sound("sound/music/instruments/vocalsf (6).ogg"),
		"The Dragon's Blood Surges (Masculine)" = sound("sound/music/instruments/vocalsm (1).ogg"),
		"Timeless Temple (Masculine)" = sound("sound/music/instruments/vocalsm (2).ogg"),
		"Angel's Earnt Halo (Masculine)" = sound("sound/music/instruments/vocalsm (3).ogg"),
		"A Fabled Choir (Masculine)" = sound("sound/music/instruments/vocalsm (4).ogg"),
		"A Pained Farewell (Masculine + Feminine)" = sound("sound/music/instruments/vocalsx (1).ogg"),
		"The Power (Whistling)" = sound("sound/music/instruments/vocalsx (2).ogg"),
		"Bard Dance (Whistling)" = sound("sound/music/instruments/vocalsx (3).ogg"),
		"Old Time Battles (Whistling)" = sound("sound/music/instruments/vocalsx (4).ogg")
	)

/obj/item/rogue/instrument/shamisen
	name = "shamisen"
	desc = "The shamisen, or simply \"three strings\", is an kazengunese stringed instrument with a washer, which is usually played with the help of a bachi."
	icon_state = "shamisen"
	lefthand_file = 'icons/mob/inhands/items_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/items_righthand.dmi'
	song_list = list(
		"A Rambling Tongue" = sound("sound/music/instruments/shamisen A Rambling Tongue.ogg"),
		"Ashitaka" = sound("sound/music/instruments/shamisen The Legend of Ashitaka.ogg"),
		"Daimyo Dreamwalker" = sound("sound/music/instruments/shamisen Daimyo Dreamwalker.ogg"),
		"Fire Phoenix" = sound("sound/music/instruments/shamisen Fire Phoenix.ogg"),
		"Kaiju Islands" = sound("sound/music/instruments/shamisen Kaiju Islands.ogg"),
		"Lavender Village" = sound("sound/music/instruments/shamisen Lavender Village.ogg"),
		"Morning Is Coming" = sound("sound/music/instruments/shamisen Morning Is Coming.ogg"),
		"Pouncing Shadow" = sound("sound/music/instruments/shamisen Pouncing Shadow.ogg"),
		"Rising Sun" = sound("sound/music/instruments/shamisen Rising Sun.ogg"),
		"Those Who Fight" = sound("sound/music/instruments/shamisen Those Who Fight.ogg"),
		"Village in the Mountains" = sound("sound/music/instruments/shamisen Village in the Mountains.ogg"),
		"Winning the Soul" = sound("sound/music/instruments/shamisen Winning the Soul.ogg"),
		"Cursed Apple" = sound("sound/music/instruments/shamisen (1).ogg"),
		"Fire Dance" = sound("sound/music/instruments/shamisen (2).ogg"),
		"Lute" = sound("sound/music/instruments/shamisen (3).ogg"),
		"Tsugaru Ripple" = sound("sound/music/instruments/shamisen (4).ogg"),
		"Tsugaru" = sound("sound/music/instruments/shamisen (5).ogg"),
		"Season" = sound("sound/music/instruments/shamisen (6).ogg"),
		"Parade" = sound("sound/music/instruments/shamisen (7).ogg"),
		"Koshiro" = sound("sound/music/instruments/shamisen (8).ogg")
	)

/obj/item/rogue/instrument/psyaltery
	name = "psyaltery"
	desc = "A traditional form of boxed zither or box-harp that may be played plucked, with a plectrum or with hammers. They are particularly associated with divine beings, aasimars and liturgies."
	icon_state = "psyaltery"
	song_list = list(
		"Disciples Tower" = sound("sound/music/instruments/psyaltery (1).ogg"),
		"Green Sleeves" = sound("sound/music/instruments/psyaltery (2).ogg"),
		"Midyear Melancholy" = sound("sound/music/instruments/psyaltery (3).ogg"),
		"Santa Psydonia" = sound("sound/music/instruments/psyaltery (4).ogg"),
		"Le Venardine" = sound("sound/music/instruments/psyaltery (5).ogg"),
		"Azurea Fair" = sound("sound/music/instruments/psyaltery (6).ogg"),
		"Amoroso" = sound("sound/music/instruments/psyaltery (7).ogg"),
		"Lupian's Lullaby" = sound("sound/music/instruments/psyaltery (8).ogg"),
		"White Wine Before Breakfast" = sound("sound/music/instruments/psyaltery (9).ogg"),
		"Chevalier de Naledi" = sound("sound/music/instruments/psyaltery (10).ogg")
	)
