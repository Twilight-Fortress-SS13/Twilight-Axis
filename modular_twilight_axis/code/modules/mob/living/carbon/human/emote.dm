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
