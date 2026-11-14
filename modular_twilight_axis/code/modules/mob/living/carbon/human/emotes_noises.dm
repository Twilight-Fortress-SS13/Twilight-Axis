/datum/emote/living/flap
	key_third_person = "хлопает"
	message = "хлопает крыльями."

/datum/emote/living/flap/aflap
	key_third_person = "хлопает!"
	message = "агрессивно хлопает крыльями!"

/datum/emote/living/meow
	key_third_person = "мяукает!"
	message = "мяукает!"
	message_muffled = "издаёт приглушённый звук!"

/datum/emote/living/mreow
	key_third_person = "протяжно мяукает!"
	message = "протяжно мяукает!"
	message_muffled = "приглушённо и протяжно мяукает!"

/datum/emote/living/mrrp
	key_third_person = "мурлычет!"
	message = "мурлычет!"
	message_muffled = "издает приглушенный звук!"

/datum/emote/living/caw
	key_third_person = "каркает!"
	message = "каркает!"
	message_muffled = "издает приглушенный звук!"

/datum/emote/living/peep
	key_third_person = "щебечет!"
	message = "щебечет!"
	message_muffled = "издает приглушенный звук!"

/datum/emote/living/hoot
	key_third_person = "ухает!"
	message = "ухает!"
	message_muffled = "издает приглушенный звук!"

/datum/emote/living/squeak
	key_third_person = "пищит!"
	message = "пищит!"
	message_muffled = "издает приглушенный звук!"

/datum/emote/living/hiss
	key_third_person = "шипит!"
	message = "шипит!"
	message_muffled = "издает приглушенный звук!"

/datum/emote/living/phiss
	key_third_person = "шипит!"
	message = "шипит!"
	message_muffled = "издает приглушенный звук!"

/datum/emote/living/roar
	key_third_person = "ревёт!"
	message = "ревёт!"
	message_muffled = "издает приглушенный звук!"

/datum/emote/living/howl
	key_third_person = "воет!"
	message = "воет!"
	message_muffled = "издает приглушенный звук!"

/datum/emote/living/cackle
	key_third_person = "хохочет!"
	message = "хохочет!"
	message_muffled = "издает приглушенный звук!"

/datum/emote/living/whine
	key_third_person = "скулит."
	message = "скулит."
	message_muffled = "издает приглушенный звук!"

/datum/emote/living/fwhine
	key_third_person = "скулит по-венардински"
	message = "скулит по-венардински."
	message_muffled = "издает приглушенный звук!"

/datum/emote/living/psnort
	key_third_person = "фыркает"
	message = "издает протяжное фырканье."
	message_muffled = "издает приглушенный звук!"

/datum/emote/living/oink
	key_third_person = "хрюкает."
	message = "хрюкает."
	message_muffled = "издает приглушенный звук!"

/datum/emote/living/trill
	key_third_person = "издаёт трель!"
	message = "издаёт трель!"
	message_muffled = "издает приглушенный звук!"

/datum/emote/living/purr
	key_third_person = "мурлычет!"
	message = "мурлычет!"
	message_muffled = "издает приглушенный звук!"

/datum/emote/living/moo
	key_third_person = "мычит!"
	message = "мычит!"
	message_muffled = "издает приглушенный звук!"

/datum/emote/living/bark
	key_third_person = "гавкает!"
	message = "гавкает!"
	message_muffled = "издает приглушенный звук!"

/datum/emote/living/growl
	key_third_person = "рычит!"
	message = "рычит!"
	message_muffled = "издает приглушенный звук!"

/datum/emote/living/prbt
	key_third_person = "фыркает!"
	message = "фыркает!"
	message_muffled = "издает приглушенный звук!"

/datum/emote/living/bleat
	key_third_person = "блеет!"
	message = "блеет!"
	message_muffled = "издает приглушенный звук!"

/datum/emote/living/chitter
	message = "стрекочет!"
	message_muffled = "издает приглушенное стрекотание!"

/datum/emote/living/flutter
	key_third_person = "трепещет!"
	message = "трепещет!"

/datum/emote/living/yip
	key_third_person = "тявкает!"
	message = "тявкает!"
	message_muffled = "приглушённо тявкает!"

/datum/emote/living/lizard_bellow
	key_third_person = "ревёт"
	message = "ревёт!"
	message_muffled = "издаёт приглушённый рёв!"

/datum/emote/living/lizard_hiss
	key_third_person = "шипит"
	message = "шипит!"
	message_muffled = "приглушенно шипит!"

/datum/emote/living/lizard_squeal
	key_third_person = "визжит!"
	message = "визжит!"
	message_muffled = "приглушённо визжит!"

/datum/emote/living/emote_lizard_thump
	key_third_person = "топает!"
	message = "топает!"

/datum/emote/living/cackle/venardine
	key = "venard_cackle"

/mob/living/carbon/human/proc/emote_cackle_venard()
	set name = "Cackle (Venard)"
	set category = "Emotes.Wildtongue"

	if(!istype(usr.getorganslot(ORGAN_SLOT_TONGUE), /obj/item/organ/tongue/wild_tongue/venardine))
		return

	emote("venard_cackle", intentional = TRUE, animal = TRUE)
