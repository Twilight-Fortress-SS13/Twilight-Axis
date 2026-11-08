/datum/emote/living/carbon/human/cry
	key_third_person = "плачет"
	message = "плачет."

/datum/emote/living/carbon/human/cry/can_run_emote(mob/living/user, status_check = TRUE , intentional)
	. = ..()
	if(. && iscarbon(user))
		var/mob/living/carbon/C = user
		if(C.silent || !C.can_speak())
			message = "всхлипывает. Поток слез стекает по лицу."

/datum/emote/living/carbon/human/eyebrow
	message = "приподнимает бровь."

/datum/emote/living/carbon/human/grumble
	key_third_person = "бухтит"
	message = "бухтит."
	message_muffled = "приглушенно бухтит."

/datum/emote/living/carbon/human/handshake
	message = "пожимает себе руку."
	message_param = "пожимает руку %t."

/datum/emote/living/carbon/human/pale
	message = "бледнеет на мгновенье."

/datum/emote/living/carbon/human/raise
	key_third_person = "поднимает руку"
	message = "поднимает руку."

/datum/emote/living/carbon/human/salute
	key_third_person = "салютует"
	message = "салютует."
	message_param = "салютует %t."

/datum/emote/living/carbon/human/shrug
	key_third_person = "пожимает плечами"
	message = "пожимает плечами."

/datum/emote/living/carbon/human/wag
	key_third_person = "виляет"
	message = "виляет своим хвостом."

/datum/emote/living/carbon/human/wing
	key_third_person = "машет крыльями"
	message = "хлопает своими крыльями."

/datum/emote/living/flap
	key_third_person = "хлопает"
	message = "хлопает крыльями."

/datum/emote/living/flap/aflap
	key_third_person = "хлопает!"
	message = "агрессивно хлопает крыльями!"

/datum/emote/living/meow
	key_third_person = "мяукает!"
	message = "мяукает!"
	message_muffled = "издает приглушенный звук"

/datum/emote/living/mrrp
	key_third_person = "недовольно мурчит!"
	message = "недовольно мурчит!"
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
	key_third_person = "рычит!"
	message = "рычит!"
	message_muffled = "издает приглушенный звук!"

/datum/emote/living/howl
	key_third_person = "воет!"
	message = "воет!"
	message_muffled = "издает приглушенный звук!"

/datum/emote/living/cackle
	key_third_person = "насмехается!"
	message = "насмехается!"
	message_muffled = "издает приглушенный звук!"

/datum/emote/living/whine
	key_third_person = "скулит."
	message = "скулит."
	message_muffled = "издает приглушенный звук!"

/datum/emote/living/fwhine
	key_third_person = "скулит по венардински"
	message = "скулит по венардински."
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
	key_third_person = "трещит!"
	message = "трещит!"
	message_muffled = "издает приглушенный звук!"

/datum/emote/living/purr
	key_third_person = "мурчит!"
	message = "мурчит!"
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
	key_third_person = "ухает!"
	message = "ухает!"
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
	key_third_person = "ипает!"
	message = "ипает!"
	message_muffled = "издает приглушенное ип!"

/datum/emote/living/lizard_bellow
	key_third_person = "ревет"
	message = "ревет!"
	message_muffled = "издает приглушенный рев!"

/datum/emote/living/lizard_hiss
	key_third_person = "шипит"
	message = "шипит!"
	message_muffled = "приглушенно шипит!"

/datum/emote/living/lizard_squeal
	key_third_person = "пищит!"
	message = "пищит!"
	message_muffled = "приглушенно пищит!"

/datum/emote/living/emote_lizard_thump
	key_third_person = "топает!"
	message = "топает!"

/datum/emote/living/carbon/human/mumble
	message = "бормочет."

/datum/emote/living/carbon/human/eflick
	message = "шевелит ушами."

/datum/emote/living/gulp
	message = "сглатывает."

/datum/emote/living/crack
	message = "хрустит костяшками пальцев."

/datum/emote/living/facepalm
	message = "закрывает лицо ладонью."

/datum/emote/living/mreow
	message = "мяукает!"
	message_muffled = "приглушённо мяукает!"
