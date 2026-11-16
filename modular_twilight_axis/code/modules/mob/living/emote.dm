/* Twilight Axis Localisation */
GLOBAL_LIST_INIT(zone_translations, list(
		BODY_ZONE_HEAD = "голову",
		BODY_ZONE_CHEST = "туловище",
		BODY_ZONE_R_ARM = "правую руку",
		BODY_ZONE_L_ARM = "левую руку",
		BODY_ZONE_R_LEG = "правую ногу",
		BODY_ZONE_L_LEG = "левую ногу",
		BODY_ZONE_PRECISE_R_INHAND = "правую ладонь",
		BODY_ZONE_PRECISE_L_INHAND = "левую ладонь",
		BODY_ZONE_PRECISE_R_FOOT = "правую ступню",
		BODY_ZONE_PRECISE_L_FOOT = "левую ступню",
		BODY_ZONE_PRECISE_SKULL = "череп",
		BODY_ZONE_PRECISE_EARS = "уши",
		BODY_ZONE_PRECISE_R_EYE = "правый глаз",
		BODY_ZONE_PRECISE_L_EYE = "левый глаз",
		BODY_ZONE_PRECISE_NOSE = "нос",
		BODY_ZONE_PRECISE_MOUTH = "рот",
		BODY_ZONE_PRECISE_NECK = "шею",
		BODY_ZONE_PRECISE_STOMACH = "живот",
		BODY_ZONE_PRECISE_GROIN = "пах"
	))

/datum/emote/living/blush
	key_third_person = "краснеет"
	message = "краснеет."
	emote_type = EMOTE_VISIBLE

/mob/living/carbon/human/verb/emote_blush()
	set name = "Краснеть"
	set category = "Emotes"

	emote("blush", intentional = TRUE)

/datum/emote/living/pray
	key_third_person = "молится"
	message = "произносит молитву."

/datum/emote/living/meditate
	key_third_person = "медитирует"
	message = "медитирует."

/datum/emote/living/bow
	key_third_person = "кланяется"
	message = "кланяется."
	message_param = "кланяется %t."

/datum/emote/living/burp
	key_third_person = "рыгает"
	message = "рыгает."
	message_muffled = "издает приглушенный звук."

/datum/emote/living/choke
	key_third_person = "задыхается"
	message = "задыхается!"

/datum/emote/living/cross
	key_third_person = "скрещивает руки"
	message = "скрещивает руки."

/datum/emote/living/collapse
	key_third_person = "теряет сознание"
	message = "теряет сознание."

/datum/emote/living/whisper
	key_third_person = "шепчет"
	message = "шепчет."
	message_mime = "что-то шепчет."

/datum/emote/living/cough
	key_third_person = "кашляет"
	message = "кашляет."

/datum/emote/living/clearthroat
	key_third_person = "прочищает горло"
	message = "прочищает горло."
	message_muffled = "издает приглушенный звук."

/datum/emote/living/dance
	key_third_person = "танцует"
	message = "танцует."

/datum/emote/living/drool
	key_third_person = "пускает слюни"
	message = "пускает слюни."

/datum/emote/living/faint
	key_third_person = "валится с ног"
	message = "валится с ног."

/datum/emote/living/frown
	key_third_person = "хмурится"
	message = "хмурится."

/datum/emote/living/gag
	key_third_person = "давится"
	message = "давится."

/datum/emote/living/gasp
	key_third_person = "ахает"
	message = "ахает!"
	message_muffled = "приглушённо ахает."

/datum/emote/living/breathgasp
	key_third_person = "ловит ртом воздух"
	message = "ловит ртом воздух!"

/datum/emote/living/giggle
	key_third_person = "хихикает"
	message = "хихикает."

/datum/emote/living/chuckle
	key_third_person = "усмехается"
	message = "усмехается."

/datum/emote/living/glare
	key_third_person = "сверлит взглядом"
	message = "сверлит взглядом."
	message_param = "сверлит взглядом %t."

/datum/emote/living/grin
	key_third_person = "ухмыляется"
	message = "ухмыляется."

/datum/emote/living/groan
	key_third_person = "тяжело вздыхает"
	message = "тяжело вздыхает."
	message_muffled = "издает приглушенный вздох."

/datum/emote/living/grimace
	key_third_person = "морщится"
	message = "морщится."

/datum/emote/living/jump
	key_third_person = "прыгает"
	message = "прыгает!"

/datum/emote/living/leap
	key_third_person = "скачет"
	message = "скачет!"

/datum/emote/living/kiss
	key_third_person = "целует"

/datum/emote/living/lick
	key_third_person = "облизывает"
	message = "облизывает."
	message_param = "облизывает %t."

/datum/emote/living/spit
	key_third_person = "плюет"
	message = "плюет на землю."
	message_param = "плюет в %t."

/datum/emote/living/spit/run_emote(mob/user, params, type_override, intentional)
	message_param = initial(message_param) // reset
	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		if(H.mouth)
			if(H.mouth.spitoutmouth)
				H.visible_message(span_warning("[H] выплевывает [H.mouth]."))
				H.dropItemToGround(H.mouth, silent = FALSE)
			return
	..()

/datum/emote/living/hug
	key_third_person = "обнимает"
	message_param = "обнимает %t."

/datum/emote/living/slap
	key_third_person = "шлепает"
	message_param = "отвешивает пощечину %t."

/datum/emote/living/slap/run_emote(mob/user, params, type_override, intentional)
	message_param = initial(message_param)
	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		if(H.zone_selected == BODY_ZONE_PRECISE_GROIN)
			message_param = "шлепает %t по заднице."
		else if(H.zone_selected == BODY_ZONE_PRECISE_SKULL)
			message_param = "отвешивает подзатыльник %t."
		else if(H.zone_selected == BODY_ZONE_PRECISE_L_HAND || H.zone_selected == BODY_ZONE_PRECISE_R_HAND)
			message_param = "шлепает по руке %t."
		else if(H.zone_selected == BODY_ZONE_CHEST)
			message_param = "шлепает грудь %t."
	..()

/datum/emote/living/pinch
	message_param = "щипает %t."

/datum/emote/living/pinch/run_emote(mob/user, params, type_override, intentional)
	message_param = initial(message_param)
	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		if(H.zone_selected == BODY_ZONE_HEAD)
			message_param = "щипает %t за щеку."
		else if(H.zone_selected == BODY_ZONE_PRECISE_L_HAND || H.zone_selected == BODY_ZONE_PRECISE_R_HAND)
			message_param = "щипает %t за руку."
		else if(H.zone_selected == BODY_ZONE_CHEST)
			message_param = "щипает грудь %t."
		else
			var/ru_zone_selected = GLOB.zone_translations[user.zone_selected]
			message_param = "щипает %t за [ru_zone_selected]."
	..()

/datum/emote/living/laugh
	key_third_person = "смеется"
	message = "смеется."
	message_mime = "бесшумно смеется."
	message_muffled = "приглушенно смеется."

/datum/emote/living/look
	key_third_person = "смотрит"
	message = "смотрит."
	message_param = "разглядывает %t."

/mob/living/carbon/human/verb/emote_look()
	set name = "Смотреть"
	set category = "Emotes"

	emote("look", intentional = TRUE)

/datum/emote/living/nod
	key_third_person = "кивает"
	message = "кивает."
	message_param = "кивает %t."

/datum/emote/living/point
	key_third_person = "указывает"
	message = "указывает."
	message_param = "указывает на %t."

/datum/emote/living/pout
	key_third_person = "дуется"
	message = "дуется."

/mob/living/carbon/human/verb/emote_pout()
	set name = "Дуться"
	set category = "Emotes"

	emote("pout", intentional = TRUE)

/datum/emote/living/scream
	key_third_person = "кричит"
	message = "кричит!"
	message_mime = "делает вид, что кричит!"
	message_muffled = "издает сдавленный звук в попытке закричать."

/datum/emote/living/scream/painscream
	message = "кричит от боли!"

/datum/emote/living/scream/strain
	message = "перенапрягается!"

/datum/emote/living/scream/agony
	message = "кричит в агонии!"

/datum/emote/living/haltyell
	message = "требует остановиться!"

/datum/emote/living/rage
	message = "кричит в ярости!"

/datum/emote/living/attnwhistle
	message = "привлекает внимание свистом!"
	message_muffled = "издает приглушенный звук."

/datum/emote/living/scowl
	key_third_person = "смотрит исподлобья"
	message = "смотрит исподлобья."

/mob/living/carbon/human/verb/emote_scowl()
	set name = "Смотреть исподлобья"
	set category = "Emotes"

	emote("scowl", intentional = TRUE)

/datum/emote/living/shakehead
	key_third_person = "качает головой"
	message = "качает головой."

/datum/emote/living/shake
	key_third_person = "мотает головой"
	message = "мотает головой."

/datum/emote/living/shiver
	key_third_person = "дрожит"
	message = "дрожит."

/datum/emote/living/sigh
	key_third_person = "вздыхает"
	message = "вздыхает."
	message_muffled = "делает приглушенный вздох."

/datum/emote/living/whistle
	key_third_person = "насвистывает"
	message = "насвистывает."
	message_muffled = "издает приглушенный звук."

/datum/emote/living/hmm
	key_third_person = "хмыкает"
	message = "хмыкает."
	message_muffled = "приглушенно хмыкает."

/datum/emote/living/huh
	key_third_person = "хмыкает?"
	message_muffled = "издает приглушенный звук."

/datum/emote/living/hum
	key_third_person = "напевает"
	message = "напевает."
	message_muffled = "приглушенно напевает."

/datum/emote/living/smile
	key_third_person = "улыбается"
	message = "улыбается."

/datum/emote/living/sneeze
	key_third_person = "чихает"
	message = "чихает."
	message_muffled = "приглушенно чихает."

/datum/emote/living/hmph
	key_third_person = "хмыкает!"
	message = "хмыкает!"
	message_muffled = "приглушенно хмыкает."

/mob/living/carbon/human/verb/emote_hmph()
	set name = "Хмыкнуть!"
	set category = "Emotes.Noises"

	emote("hmph", intentional = TRUE)

/datum/emote/living/shh
	key_third_person = "шикает"
	message = "шикает."
	message_muffled = "приглушенно шикает."

/datum/emote/living/smug
	key_third_person = "самодовольно ухмыляется"
	message = "самодовольно ухмыляется."

/mob/living/carbon/human/verb/emote_smug()
	set name = "Самодовольно ухмыляться"
	set category = "Emotes"

	emote("smug", intentional = TRUE)

/datum/emote/living/sniff
	key_third_person = "нюхает"
	message = "нюхает."

/mob/living/carbon/human/verb/emote_sniff()
	set name = "Нюхать"
	set category = "Emotes"

	emote("sniff", intentional = TRUE)

/datum/emote/living/snore
	key_third_person = "храпит"
	message = "храпит."
	message_mime = "сопит."

/datum/emote/living/stare
	key_third_person = "пристально смотрит"
	message = "пристально смотрит."
	message_param = "пристально смотрит на %t."

/mob/living/carbon/human/verb/emote_stare()
	set name = "Пристально смотреть"
	set category = "Emotes"

	emote("stare", intentional = TRUE)

/datum/emote/living/strech
	key_third_person = "потягивается"
	message = "потягивается."

/mob/living/carbon/human/verb/emote_strech()
	set name = "Потягиваться"
	set category = "Emotes"

	emote("stretch", intentional = TRUE)

/datum/emote/living/sway
	key_third_person = "шатается"
	message = "шатается."

/mob/living/carbon/human/verb/emote_sway()
	set name = "Шататься"
	set category = "Emotes"

	emote("sway", intentional = TRUE)

/datum/emote/living/tremble
	key_third_person = "дрожит"
	message = "дрожит от страха!"

/mob/living/carbon/human/verb/emote_tremble()
	set name = "Дрожать от страха"
	set category = "Emotes"

	emote("tremble", intentional = TRUE)

/datum/emote/living/twitch
	key_third_person = "дергается"
	message = "судорожно подергивается."

/datum/emote/living/twitch_s
	message = "дергается."

/datum/emote/living/warcry
	key_third_person = "издает боевой клич!"
	message = "выкрикивает вдохновляющий боевой клич!"
	message_muffled = "издает приглушенный крик."

/datum/emote/living/wave
	key_third_person = "машет"
	message = "машет."

/datum/emote/living/whimper
	key_third_person = "хнычет"
	message = "хнычет."
	message_mime = "хнычет."
	message_muffled = "приглушённо хнычет."

/datum/emote/living/wsmile
	key_third_person = "слабо улыбается"
	message = "слабо улыбается."

/mob/living/carbon/human/verb/emote_wsmile()
	set name = "Слабо улыбнуться"
	set category = "Emotes"

	emote("wsmile", intentional = TRUE)

/datum/emote/living/yawn
	key_third_person = "зевает"
	message = "зевает."
	message_muffled = "приглушенно зевает."

/datum/emote/living/squint
	key_third_person = "прищуривается"
	message = "прищуривается."

/datum/emote/living/snap
	key_third_person = "щёлкает пальцами"
	message = "щёлкает пальцами!"

/datum/emote/living/blink
	key_third_person = "моргает."
	message = "моргает."

/datum/emote/living/stomp
	key_third_person = "топает"
	message = "топает!"

/datum/emote/living/snap2
	key_third_person = "дважды щёлкает пальцами"
	message = "дважды щёлкает пальцами!"

/datum/emote/living/snap3
	key_third_person = "трижды щёлкает пальцами"
	message = "трижды щёлкает пальцами!"

/datum/emote/living/fsalute
	key_third_person = "превозносит свою веру"
	message = "превозносит свою веру."

/datum/emote/living/ffsalute
	key_third_person = "превозносит свою веру"
	message = "превозносит свою веру."

/mob/living/carbon/human/verb/emote_pale()
	set name = "Побледнеть"
	set category = "Emotes"

	emote("pale", intentional = TRUE)

/mob/living/carbon/human/verb/emote_raise()
	set name = "Поднять руку"
	set category = "Emotes"

	emote("raise", intentional = TRUE)

/mob/living/carbon/human/verb/emote_salute()
	set name = "Салютовать"
	set category = "Emotes"

	emote("salute", intentional = TRUE)

/mob/living/carbon/human/verb/emote_shrug()
	set name = "Пожать плечами"
	set category = "Emotes"

	emote("shrug", intentional = TRUE)

/datum/emote/living/softmoan
	key = "softmoan"
	key_third_person = "мягко стонет"
	message = "мягко стонет."
	message_muffled = "приглушенно стонет."
	emote_type = EMOTE_AUDIBLE
	show_runechat = TRUE

/mob/living/carbon/human/verb/emote_softmoan()
	set name = "Мягко стонать"
	set category = "Emotes.Noises"

	emote("softmoan", intentional = TRUE)

/mob/living/carbon/human/verb/emote_moan()
	set name = "Стонать"
	set category = "Emotes.Noises"

	emote("moan", intentional = TRUE)

/datum/emote/living/pat
	key = "pat"
	key_third_person = "гладит по голове"
	message = ""
	message_param = "гладит по голове %t."
	emote_type = EMOTE_VISIBLE
	restraint_check = TRUE

/mob/living/carbon/human/verb/emote_pat()
	set name = "Гладить"
	set category = "Emotes"

	emote("pat", intentional = TRUE, targetted = TRUE)

/datum/emote/living/pat/adjacentaction(mob/user, mob/target)
	. = ..()
	if(!user || !target)
		return
	if(ishuman(target))
		playsound(target.loc, 'sound/vo/hug.ogg', 100, FALSE, -1)

/datum/emote/living/vomit
	message = "рвёт!"

/datum/emote/living/cough
	message_muffled = "приглушённо кашляет."

/datum/emote/living/deathgasp
	message = "испускает последний вздох."

/datum/emote/living/giggle
	message_mime = "беззвучно хихикает!"
	message_muffled = "приглушённо хихикает."

/datum/emote/living/chuckle
	message_muffled = "приглушённо усмехается."

/datum/emote/living/attack
	message_muffled = "приглушённо стонет."

/datum/emote/living/scream/superagony
	message = "кричит в невыносимой агонии!"

/datum/emote/living/pleased
	message = "издаёт довольный звук."
	message_muffled = "издаёт приглушённый звук."

/datum/emote/living/sulk
	message = "уныло поникает."

/datum/emote/beep
	message = "пищит."
	message_param = "пищит в сторону %t."
