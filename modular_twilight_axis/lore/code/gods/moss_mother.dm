/datum/patron/mossmother
	name = "The Mossmother"
	translated_name = "Матерь Мха"
	domain = "Болота."
	desc = "Существо, обитающее в глубинах болот Гримории, по природе своей занимающее неопределённое место между смертными, духами и богами. Формально она не признана частью ни одного пантеона, отвергнута Церковью Десяти как самозванка и еретическая аномалия, и всё же обладает подлинной – пусть и ущербной – крупицей божественности. Сама же Матерь Мха считает это признание незаслуженно ограниченным: боги, занимающие троны Порядка, отказываются признать её равной. Это не останется безнаказанным."
	worshippers = "Болотные ведьмы."
	confess_lines = list(
		"МАТЕРЬ МХА ВИДИТ ТЕБЯ!",
		"ТЫ ЗАПЛАТИШЬ СПОЛНА, ДОРОГУША!",
		"Ты настолько глубоко залез в задницу Псайдона, что не видишь оттуда истины, что перед глазами. Ты жалок.",
		"ВОЗМЕЗДИЕ ГРЯДЕТ.",
		"Я ЕСТЬ САМА ЗЕМЛЯ. ТЫ ДОЛЖЕН БЛАГОДАРИТЬ МЕНЯ ЗА ДОЗВОЛЕНИЕ СТУПАТЬ ПО НЕЙ.",
	)
	// The hug really often need to heal someone, to continue their work...
	miracles = list(
		/datum/action/cooldown/spell/touch/orison								= CLERIC_T0,
		/obj/effect/proc_holder/spell/self/roots_movement						= CLERIC_T1,
		/obj/effect/proc_holder/spell/self/wildshape/hag_disgusting_form		= CLERIC_T1,
		/datum/action/cooldown/spell/miracle/heal								= CLERIC_T1,
		/datum/action/cooldown/spell/miracle/bloodmiracle						= CLERIC_T1,
		)

/datum/patron/mossmother/on_lesser_heal(
	mob/living/user,
	mob/living/target,
	message_out,
	message_self,
	conditional_buff,
	situational_bonus
)
	*message_out = span_info("[target] being covering in strange moss, that's knits it's wounds.")
	*message_self = span_notice("My wounds being restored by strange moss...")

	var/bonus = 1

	if(HAS_TRAIT(target, TRAIT_FEYBOUND) || HAS_TRAIT(target, TRAIT_FEYTOUCHED) || HAS_TRAIT(target, TRAIT_ANCIENT_HAG))
		bonus += 0.5

	if(istype(target, /area/rogue/outdoors/bog) && istype(target, /area/rogue/indoors/shelter/bog) && istype(target, /area/rogue/indoors/shelter/bog_hag) && istype(target, /area/rogue/outdoors/bograt) && istype(target, /area/rogue/under/cavewet))
		bonus += 0.5

	for(var/obj/structure/roguemachine/mossmother/roots in range(5, user))
		bonus += 0.5

	if(bonus < 1)
		return

	*conditional_buff = TRUE
	*situational_bonus = bonus
	target.adjustToxLoss(-*situational_bonus*15)
	target.blood_volume = min(target.blood_volume + (BLOOD_VOLUME_SURVIVE / 3), BLOOD_VOLUME_NORMAL)
