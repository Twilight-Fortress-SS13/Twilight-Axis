/proc/roll_text(message, ...)
	var/static/list/translations = list(
		"Strength" = "Сила",
		"Perception" = "Восприятие",
		"Intelligence" = "Интеллект",
		"Constitution" = "Телосложение",
		"Willpower" = "Воля",
		"Speed" = "Скорость",
		"Fortune" = "Удача",
		"Charisma" = "Харизма",
		"strength" = "Сила",
		"perception" = "Восприятие",
		"intelligence" = "Интеллект",
		"constitution" = "Телосложение",
		"willpower" = "Воля",
		"speed" = "Скорость",
		"fortune" = "Удача",
		"charisma" = "Харизма",
		"I cannot send IC messages. (muted)" = "Я не могу отправлять игровые сообщения: чат заблокирован.",
		"CRITICALLY SUCCEEDS" = "КРИТИЧЕСКИЙ УСПЕХ",
		"CRITICAL FAILS" = "КРИТИЧЕСКИЙ ПРОВАЛ",
		"SUCCEEDS" = "УСПЕХ",
		"FAILS" = "ПРОВАЛ",
		"Xylix's Dice Box" = "Кости Ксайликса",
		"Which stat will you roll?" = "Какую характеристику проверить?",
		"That is not a roll I know how to make." = "Не удалось разобрать выражение броска.",
		"A roll can have one stat added to it, and not taken away." = "К броску можно прибавить одну характеристику; вычитать её нельзя.",
		"That bonus is beyond reckoning." = "Слишком большой модификатор.",
		"<b>Success!</b>" = "<b>Успех!</b>",
		"<b>Failure!</b>" = "<b>Провал!</b>",
		" — success" = " — успех",
		" — failure" = " — провал",
		"There is nobody nearby to challenge!" = "Поблизости некого вызвать на состязание!",
		"Who will you challenge?" = "Кого вызвать на состязание?",
		"Custom Roll" = "Свои кости",
		"Neither prevails!" = "Ничья!",
		"unknown_stat" = "Неизвестная характеристика «%1».",
		"too_many_dice" = "Нельзя бросить больше %1 костей за раз.",
		"invalid_sides" = "У кости должно быть от 2 до %1 граней.",
		"bonus_header" = "<br>Модификатор <b>%1</b>",
		"needs_at_least" = "<br>Нужно %1 или больше",
		"needs_over" = "<br>Нужно больше %1",
		"stat_result" = "%1 — %2",
		"opponent_busy" = "%1 сейчас не до игр.",
		"contest_title" = "Состязание с %1!",
		"contest_declined" = "%1 отказывается от состязания.",
		"contest_cancelled" = "Состязание с %1 не состоялось.",
		"traits_header" = "<br>Особенности <b>%1</b>",
		"rolls" = "бросает кости:",
		"dice_result" = "бросает %1: %2%3",
		"challenged" = "вызывает на состязание:",
		"defends" = "отвечает броском:",
		"challenge_notice" = "Вызываю %1 на состязание: %2. Ожидаю ответный бросок.",
		"defend_notice" = "%1 вызывает меня на состязание: %2. Выберите характеристику для ответа или откажитесь.",
		"prevails" = "побеждает!",
		"critically" = "с критическим результатом ",
		"syntax_help" = "Запись: число костей D число граней, затем модификаторы и /DC со сложностью. D20 — одна двадцатигранная кость; 2D6+3 — две шестигранных и бонус 3. Можно прибавить STR, PER, INT, CON, WIL, SPD, FOR или CHA. Пример: 3D6+STR+1/DC12. Суффикс /NOCRIT отключает критические результаты. Для быстрого броска введите в чат *2D10+STR/DC15.",
	)
	var/text = translations[message] || message
	for(var/index in length(args) to 2 step -1)
		text = replacetext(text, "%[index - 1]", "[args[index]]")
	return text

/datum/emote/living/stat_roll/strength
	attempt_message_list = list(
		"испытывает свою силу...",
		"прикладывает усилие...",
		"напрягает мышцы...",
	)

	success_message_list = list(
		"демонстрирует свою силу!",
		"оправдывает наличие таких мышц!",
		"доказывает, что силен!",
	)

	failure_message_list = list(
		"руки похожи на ветки",
		"не сможет поднять даже стул",
		"стоило есть больше мяса",
	)

/datum/emote/living/stat_roll/perception
	attempt_message_list = list(
		"очень тщательно всматривается...",
		"фокусирует взгляд...",
		"прищуривается...",
	)

	success_message_list = list(
		"может похвастаться орлиным зрением!",
		"видит то, что не видят другие!",
		"видит мельчайшую деталь!",
	)

	failure_message_list = list(
		"видимо страдает близорукостью!",
		"похоже обладает катарактой!",
		"слеп....",
	)

/datum/emote/living/stat_roll/intelligence
	attempt_message_list = list(
		"задумывается...",
		"сводит свои брови...",
		"задумчиво чешет подбородок...",
	)

	success_message_list = list(
		"доказывает, что в рядах одних из умнейших!",
		"доказывает остроту своего ума!",
		"знает, что делает!",
	)

	failure_message_list = list(
		"вообще не понимает, где находится...",
		"голова, как кочерыжка",
		"как сложить два плюс два - осталось загадкой...",
	)

/datum/emote/living/stat_roll/constitution
	attempt_message_list = list(
		"испытывает свою крепость",
		"готовится к удару...",
		"приготовился терпеть...",
	)

	success_message_list = list(
		"даже не дрогнул!",
		"крепок, как дуб!",
		"даже не повел и бровью!",
	)

	failure_message_list = list(
		"одни кожа, да кости...",
		"покачивается, как травинка на ветру",
		"хрупок, как хрусталь",
	)

/datum/emote/living/stat_roll/willpower
	attempt_message_list = list(
		"испытывает свою силу воли...",
		"собирается с мыслями...",
		"готовиться доказать свою решимость...",
	)

	success_message_list = list(
		"преодолевает это",
		"никогда не сдается!",
		"пройдет сквозь огонь и воду",
	)

	failure_message_list = list(
		"труслив как цыпленок",
		"руки опускаются...",
		"испугается, даже, если никто не крикнет",
	)

/datum/emote/living/stat_roll/speed
	attempt_message_list = list(
		"готовит свой лучшее движение...",
		"демонстрирует свою гибкость...",
		"пытается разогнаться...",
	)

	success_message_list = list(
		"показывает блестящий контроль своего тела",
		"изгибается, словно кошка",
		"невероятная гибкость",
	)

	failure_message_list = list(
		"похоже владеет двумя левыми",
		"переигрывает себя",
		"медленнее улитки...",
	)

/datum/emote/living/stat_roll/fortune
	attempt_message_list = list(
		"испытывает свою удачу...",
		"ловит момент...",
		"взвешивает ставки...",
	)

	success_message_list = list(
		"мог бы найти слиток в луже",
		"будто бы, крольчия лапка в кармане!",
		"светиться истинной удачей!",
	)

	failure_message_list = list(
		"понимает, что игра была проигрышной с самого начала...",
		"удача явно не на его стороне",
		"все ставки против...",
	)

/datum/emote/living/stat_roll/charisma
	attempt_message_list = list(
		"пытается сохранить самообладание...",
		"пробует произвести впечатление...",
		"обдумывает следующий шаг...",
	)

	success_message_list = list(
		"переполнен непоколебимой уверенностью!",
		"- лицо, подобно каменной маске",
		"... лик подобен богу",
	)

	failure_message_list = list(
		"кипит от неуверенности...",
		"не очень-то убедительно...",
		"собранность висит на честном слове...",
	)

/datum/emote/living/stat_roll/strength
	crit_success_message_list = list("вызывает гордость Равокса!")
	crit_failure_message_list = list("не может напрячь ни единой мышцы.")

/datum/emote/living/stat_roll/perception
	crit_success_message_list = list("замечает каждую мелочь!")
	crit_failure_message_list = list("не видит дальше собственного носа.")

/datum/emote/living/stat_roll/intelligence
	crit_success_message_list = list("блистает умом!")
	crit_failure_message_list = list("не может связать и двух мыслей.")

/datum/emote/living/stat_roll/constitution
	crit_success_message_list = list("показывает железную выносливость!")
	crit_failure_message_list = list("едва держится на ногах.")

/datum/emote/living/stat_roll/willpower
	crit_success_message_list = list("сохраняет несокрушимую решимость!")
	crit_failure_message_list = list("теряет остатки решимости.")

/datum/emote/living/stat_roll/speed
	crit_success_message_list = list("двигается молниеносно!")
	crit_failure_message_list = list("путается в собственных ногах.")

/datum/emote/living/stat_roll/fortune
	crit_success_message_list = list("пользуется благосклонностью Ксайликса!")
	crit_failure_message_list = list("привлекает все возможные неудачи.")

/datum/emote/living/stat_roll/charisma
	crit_success_message_list = list("может очаровать саму Баоту!")
	crit_failure_message_list = list("производит худшее из возможных впечатлений.")
