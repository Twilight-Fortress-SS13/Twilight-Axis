/obj/item/manor_delivery
	name = "package"
	desc = "A package from a faraway land. Stamped with the Trade Company's seal, which implies it was properly processed and taxed upon arrival."
	icon = 'icons/roguetown/clothing/storage.dmi'
	icon_state = "deliverypackage3"
	item_state = "deliverypackage"
	var/manor_income
	var/obj/item/paper/manor_note
	var/estate_dispatched = FALSE

/obj/item/manor_delivery/attack_self(mob/user)
	user.temporarilyRemoveItemFromInventory(src, TRUE)
	var/amount = manor_income
	manor_income = 0
	if(amount)
		budget2change(amount, user, null, TRUE, FALSE)
	playsound(src.loc, 'sound/blank.ogg', 50, TRUE)
	user.visible_message(span_warning("[user] opens [src]."))
	if(manor_note)
		manor_note.forceMove(user.loc)
	qdel(src)

/obj/item/manor_delivery/proc/deliverToEstateOwner(datum/mind/recipient)
	if(QDELETED(src) || estate_dispatched)
		return FALSE
	if(QDELETED(recipient))
		qdel(src)
		return FALSE
	estate_dispatched = TRUE
	return recipient.enqueueEstateCorrespondence(src)

/datum/mind/proc/enqueueEstateCorrespondence(obj/item/letter)
	// Route by mind even when the recipient is disconnected or the central mail
	// store is unavailable.
	manor_packages += letter
	if(
		current \
		&& current.stat != DEAD \
		&& !current.has_status_effect(/datum/status_effect/ugotmail)
	)
		current.apply_status_effect(/datum/status_effect/ugotmail)
	return TRUE

/datum/manor
	var/estate_correspondent
	var/last_estate_news

GLOBAL_LIST_EMPTY(ta_estate_news_remaining)

/// Each pool shares its shuffled queue across the round. Draw from its end.
/proc/taDrawEstateNews(pool, previous, refill = FALSE)
	var/list/remaining = GLOB.ta_estate_news_remaining[pool]
	if(isnull(remaining) || (refill && !length(remaining)))
		var/list/catalogue = pool == "common" ? GLOB.ta_estate_common_news \
			: GLOB.ta_estate_cultural_news[pool]
		if(!length(catalogue))
			return null
		remaining = shuffle(catalogue)
		GLOB.ta_estate_news_remaining[pool] = remaining
	var/last = length(remaining)
	if(!last)
		return null
	if(remaining[last] == previous)
		if(last == 1)
			return null
		remaining.Swap(last - 1, last)
	return pop(remaining)

/datum/manor/proc/getEstateCulture(mob/living/carbon/human/owner)
	var/datum/ta_noble_title/title = owner.taNobilityTitle()
	var/culture = title?.culture || owner.taNobilityCulture()
	if(culture == "court")
		return SSmapping.config.map_name == "Dun World" ? "zybantu" : "azuria"
	return culture

/datum/manor/proc/pickEstateNews(culture)
	var/regional_first = length(GLOB.ta_estate_cultural_news[culture]) \
		&& (!last_estate_news || prob(50))
	var/first_pool = regional_first ? culture : "common"
	var/second_pool = regional_first ? "common" : culture
	var/news = taDrawEstateNews(first_pool, last_estate_news) \
		|| taDrawEstateNews(second_pool, last_estate_news)
	if(!news)
		news = taDrawEstateNews(first_pool, last_estate_news, TRUE) \
			|| taDrawEstateNews(second_pool, last_estate_news, TRUE)
	if(!news)
		// A manor with no regional pool may have already seen the last
		// unclaimed common story.
		var/list/common = GLOB.ta_estate_common_news
		var/index = rand(1, length(common))
		if(common[index] == last_estate_news)
			index = index % length(common) + 1
		news = common[index]
	last_estate_news = news
	return news

/datum/manor/proc/getEstateCorrespondent(mob/living/carbon/human/owner)
	if(estate_correspondent)
		return estate_correspondent

	var/tier = owner.taNobilityTier()
	var/steward_title = "староста"
	if(tier >= 2)
		var/culture = getEstateCulture(owner)
		var/list/titles = list()
		for(var/title_id in GLOB.ta_noble_titles)
			var/datum/ta_noble_title/title = GLOB.ta_noble_titles[title_id]
			if(title.culture == culture && title.tier == tier - 1)
				titles += title
		var/datum/ta_noble_title/chosen_title = length(titles) ? pick(titles) \
			: null
		steward_title = chosen_title ? chosen_title.estateLetterTitle() : (
			tier == 2 ? "лорд" : "барон"
		)

	var/first_name = random_human_name(MALE, FALSE) || "Edmund"
	var/surname = \
		pick(world.file2list("strings/rt/names/human/humnorlast.txt")) || "Vale"
	estate_correspondent = "[steward_title] [first_name] [surname]"
	return estate_correspondent

/datum/manor/proc/createEstateLetter(mob/living/carbon/human/owner)
	var/datum/ta_noble_title/title = owner.taNobilityTitle()
	var/feminine = owner.titles_pref == TITLES_F
	var/feminine_address = feminine && (!title || title.tier == -1 \
		|| title.male != title.female || (title.male in list(
		"Patrician",
		"Consort",
		"Ducal Consort",
	)))
	var/address_title = title ? title.estateLetterTitle(
		feminine,
		TRUE
	) : (feminine ? "госпоже" : "господину")
	var/owner_name = owner.real_name
	var/prefix = owner.mind?.ta_nobility_prefix || title?.honorific(feminine)
	if(prefix && findtextEx(owner_name, "[prefix] ") == 1)
		owner_name = copytext_char(owner_name, length_char(prefix) + 2)

	var/estate_name = html_encode(manor_name)
	var/report_date = get_ic_date_short_as_string(GLOB.dayspassed)

	var/obj/item/paper/letter = new
	letter.info = "<i>[estate_name], [report_date]</i><br><br>"
	letter.info += \
		"<b>[feminine_address ? "Моей" : "Моему"] [address_title], \
		[html_encode(owner_name)]</b><br><br>"
	stamp_mail(
		letter,
		owner.real_name,
		html_encode(getEstateCorrespondent(owner))
	)
	return letter

/datum/manor/proc/makeEstateWithdrawalMail(
	mob/living/carbon/human/owner,
	amount
)
	var/obj/item/paper/letter = createEstateLetter(owner)
	letter.info += "Получил Ваше распоряжение и сам отсчитал из казны \
	[amount] маммон. Монеты завернул в полотно и приложил к письму, чтобы в \
	дороге не потерялось ни одной. Пусть они сослужат Вам добрую службу вдали \
	от дома."
	letter.info += "<br><br>Ваш верный подданный,<br>[letter.mailer]"
	letter.updateinfolinks()

	var/obj/item/manor_delivery/delivery = new
	delivery.manor_income = amount
	delivery.manor_note = letter
	letter.forceMove(delivery)
	return delivery

/datum/manor/proc/sendEstateReport(
	mob/living/carbon/human/owner,
	list/sold_summary,
	gross,
	estate_levy,
	import_tariff,
	net,
	is_foreign,
	payout = 0,
	pays_to_account = FALSE,
	list/stored_summary = null,
	industry_settled = FALSE,
	population_income = 0
)
	if(!owner?.mind || owner.mind.get_owned_manor() != src)
		return FALSE

	var/obj/item/paper/report = createEstateLetter(owner)
	report.info += pickEstateNews(getEstateCulture(owner))

	if(industry_settled && industry_last_production)
		var/processed_name = html_encode(
			industry_last_production["processed_good"]
		)
		var/processed = industry_last_production["processed"]
		var/consumed = industry_last_production["consumed"]
		var/points = industry_last_production["points"]
		report.info += "<br><br>На переработке подготовили [processed] × \
		[processed_name]. Мастерская использовала [consumed] ед. материала и \
		получила [points] очков производства."
	else if(industry_settled)
		var/smeltery_metal_name = industry_last_smeltery_metal == "steel" \
			? "стали" : "железа"
		var/forge_metal_name = industry_last_forge_metal == "steel" ? "сталь" \
			: "железо"
		report.info += "<br><br>В шахте добыли [industry_last_ore] ед. руды. \
		Ремесленники выплавили [industry_last_ingots] слитков \
		[smeltery_metal_name]. Кузница переработала [forge_metal_name] в \
		[industry_last_points] ОП."

	var/list/products = list()
	for(var/good in sold_summary)
		products += "[sold_summary[good]] × \
		[html_encode(get_readable_good_name(good))]"
	report.info += "<br><br>Теперь о хозяйстве. "
	if(length(products))
		report.info += "[is_foreign ? "На торгу мы сбыли" : "В закрома Короны \
			мы отправили"] [jointext(products, ", ")]."
	else
		report.info += "Книгу поставок я закрыл без новых записей."
	if(length(stored_summary))
		var/list/stored_products = list()
		for(var/good in stored_summary)
			stored_products += "[stored_summary[good]] × \
			[html_encode(get_readable_good_name(good))]"
		report.info += \
			" На складе имения оставил [jointext(stored_products, ", ")]."

	if(population_income)
		report.info += " С жителей имения собрал [population_income] маммон."
	if(gross > population_income)
		report.info += " Общий доход за этот срок составил [gross] маммон."
	else if(!gross)
		report.info += " Дохода за это время не было."
	if(estate_levy)
		report.info += " Из них [estate_levy] маммон отдали в счёт оброка."
	if(import_tariff)
		report.info += " Ещё [import_tariff] маммон взяли за ввоз."
	if(estate_levy || import_tariff)
		report.info += " Когда со сборами рассчитались, осталось [net] маммон."
	if(payout)
		if(pays_to_account)
			report.info += " По Вашему распоряжению я отправил [payout] \
			маммон на Ваш счёт у Мейстера."
		else
			report.info += " По Вашему распоряжению я отсчитал [payout] \
			маммон и приложил их к письму."
	report.info += "<br><br>Перед тем как запечатать письмо, я сверил приход \
	и расход. В казне имения сейчас [estate_treasury?.balance || 0] маммон."
	report.info += "<br><br>Ваш верный подданный,<br>[report.mailer]"
	report.updateinfolinks()

	if(payout && !pays_to_account)
		var/obj/item/manor_delivery/delivery = new
		delivery.manor_income = payout
		delivery.manor_note = report
		report.forceMove(delivery)
		return delivery.deliverToEstateOwner(owner.mind)
	return owner.mind.enqueueEstateCorrespondence(report)

/// Russian nominative for the steward's signature and dative for the recipient.
/datum/ta_noble_title/proc/estateLetterTitle(feminine = FALSE, dative = FALSE)
	if(tier == -1)
		if(feminine)
			return dative ? "оруженосице" : "оруженосица"
		return dative ? "оруженосцу" : "оруженосец"
	var/list/forms
	switch(honorific(feminine))
		if("Lord")
			forms = list("лорд", "лорду")
		if("Lady")
			forms = list("леди", "леди")
		if("High Lord")
			forms = list("высший лорд", "высшему лорду")
		if("High Lady")
			forms = list("высшая леди", "высшей леди")
		if("Ser")
			forms = list("сэр", "сэру")
		if("Dame", "Dama")
			forms = list("дама", "даме")
		if("Grand Duke")
			forms = list("великий герцог", "великому герцогу")
		if("Grand Duchess")
			forms = list("великая герцогиня", "великой герцогине")
		if("King")
			forms = list("король", "королю")
		if("Queen")
			forms = list("королева", "королеве")
		if("Prince")
			forms = list("принц", "принцу")
		if("Princess")
			forms = list("принцесса", "принцессе")
		if("Sultan")
			forms = list("султан", "султану")
		if("Sultana")
			forms = list("султана", "султане")
		if("Vizier")
			forms = list("визирь", "визирю")
		if("Mushir")
			forms = list("мушир", "муширу")
		if("Mushirah")
			forms = list("мушира", "мушире")
		if("Amir", "Emir")
			forms = list("эмир", "эмиру")
		if("Amirah", "Emira")
			forms = list("эмира", "эмире")
		if("Duke", "Herzog", "Duca", "Duc", "Duque", "Doux")
			forms = list("герцог", "герцогу")
		if("Duchess", "Herzogin", "Duchessa", "Duchesse", "Duquesa")
			forms = list("герцогиня", "герцогине")
		if("Count", "Graf", "Conte", "Comte", "Conde")
			forms = list("граф", "графу")
		if("Countess", "Gräfin", "Contessa", "Comtesse", "Condesa")
			forms = list("графиня", "графине")
		if("Marquess", "Marchese", "Marquis", "Marqués")
			forms = list("маркиз", "маркизу")
		if("Marchioness", "Marchesa", "Marquise", "Marquesa")
			forms = list("маркиза", "маркизе")
		if("Markgraf")
			forms = list("маркграф", "маркграфу")
		if("Markgräfin")
			forms = list("маркграфиня", "маркграфине")
		if("Baron", "Barone", "Barón", "Freiherr")
			forms = list("барон", "барону")
		if("Baroness", "Baronessa", "Baronne", "Baronesa", "Freifrau")
			forms = list("баронесса", "баронессе")
		if("Viscount", "Visconte", "Vicomte", "Vizconde")
			forms = list("виконт", "виконту")
		if("Viscountess", "Viscontessa", "Vicomtesse", "Vizcondesa")
			forms = list("виконтесса", "виконтессе")
		if("Ritter", "Cavaliere", "Chevalier")
			forms = list("рыцарь", "рыцарю")
		if("Ritterin")
			forms = list("рыцарственная дама", "рыцарственной даме")
		if("Edler")
			forms = list("эдлер", "эдлеру")
		if("Edle")
			forms = list("эдле", "эдле")
		if("Junker")
			forms = list("юнкер", "юнкеру")
		if("Junkerin")
			forms = list("юнкерина", "юнкерине")
		if("Signore")
			forms = list("синьор", "синьору")
		if("Signora")
			forms = list("синьора", "синьоре")
		if("Señor", "Seigneur")
			forms = list("сеньор", "сеньору")
		if("Señora")
			forms = list("сеньора", "сеньоре")
		if("Nobile")
			forms = list("нобиле", "нобиле")
		if("Don")
			forms = list("дон", "дону")
		if("Doña")
			forms = list("донья", "донье")
		if("Knyaz")
			forms = list("князь", "князю")
		if("Knyaginya")
			forms = list("княгиня", "княгине")
		if("Boyar")
			forms = list("боярин", "боярину")
		if("Boyarina")
			forms = list("боярыня", "боярыне")
		if("Pomeshchik")
			forms = list("помещик", "помещику")
		if("Pomeshchitsa")
			forms = list("помещица", "помещице")
		if("Pan")
			forms = list("пан", "пану")
		if("Pani")
			forms = list("пани", "пани")
		if("Jarl")
			forms = list("ярл", "ярлу")
		if("Hersir")
			forms = list("херсир", "херсиру")
		if("Chieftain")
			forms = list("вождь", "вождю")
		if("Thane")
			forms = list("тан", "тану")
		if("Hirdman")
			forms = list("хирдман", "хирдману")
		if("Hirdwoman")
			forms = list("хирдманка", "хирдманке")
		if("Satrap")
			forms = list("сатрап", "сатрапу")
		if("Bey")
			forms = list("бей", "бею")
		if("Begum")
			forms = list("бегум", "бегум")
		if("Agha")
			forms = list("ага", "аге")
		if("Faris")
			forms = list("фарис", "фарису")
		if("Sayyid")
			forms = list("сайид", "сайиду")
		if("Sayyida")
			forms = list("сайида", "сайиде")
		if("Kephale")
			forms = list("кефале", "кефале")
		if("Archon")
			forms = list("архонт", "архонту")
		if("Daimyo")
			forms = list("даймё", "даймё")
		if("Hatamoto")
			forms = list("хатамото", "хатамото")
		if("Gokenin")
			forms = list("гокэнин", "гокэнину")
		if("Samurai")
			forms = list("самурай", "самураю")
		if("Hou")
			forms = list("хоу", "хоу")
		if("Gong")
			forms = list("гун", "гуну")
		if("Nan")
			forms = list("нань", "наню")
		if("Zi")
			forms = list("цзы", "цзы")
		if("Bo")
			forms = list("бо", "бо")
		if("Shenshi")
			forms = list("шэньши", "шэньши")
		if("Shi")
			forms = list("ши", "ши")
		if("Hujak")
			forms = list("худжак", "худжаку")
		if("Gongjak")
			forms = list("конджак", "конджаку")
		if("Namjak")
			forms = list("намджак", "намджаку")
		if("Jajak")
			forms = list("чаджак", "чаджаку")
		if("Baekjak")
			forms = list("пэкджак", "пэкджаку")
		if("Yangban")
			forms = list("янбан", "янбану")
		if("Seonbi")
			forms = list("сонби", "сонби")
		if("Nemes")
			forms = list("немеш", "немешу")
		if("Patrician")
			forms = feminine ? list(
				"патрицианка",
				"патрицианке",
			) : list("патриций", "патрицию")
		if("Consort")
			forms = feminine ? list(
				"супруга",
				"супруге",
			) : list("супруг", "супругу")
		if("Ducal Consort")
			forms = feminine ? list(
				"герцогская супруга",
				"герцогской супруге",
			) : list("герцогский супруг", "герцогскому супругу")
	if(!forms)
		forms = feminine ? list(
			"госпожа",
			"госпоже",
		) : list("господин", "господину")
	return forms[dative ? 2 : 1]
