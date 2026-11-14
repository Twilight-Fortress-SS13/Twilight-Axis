GLOBAL_LIST_INIT(ta_noble_titles, taBuildNobleTitles())

/datum/ta_noble_title
	var/id
	var/culture
	var/tier
	var/male
	var/female
	var/analogue
	var/territorial_male
	var/territorial_female

/datum/ta_noble_title/New(
	new_culture,
	new_tier,
	new_male,
	new_female,
	new_analogue,
	new_territorial_male,
	new_territorial_female
)
	culture = new_culture
	tier = new_tier
	male = new_male
	female = new_female || new_male
	analogue = new_analogue
	territorial_male = new_territorial_male || male
	territorial_female = new_territorial_female || female
	id = "[culture]/[tier]/[male]"
	return ..()

/datum/ta_noble_title/proc/honorific(feminine = FALSE)
	return feminine ? female : male

/datum/ta_noble_title/proc/territorial(feminine = FALSE)
	return feminine ? territorial_female : territorial_male

/proc/taRegisterNobleTitle(
	list/catalogue,
	culture,
	tier,
	male,
	female,
	analogue,
	territorial_male,
	territorial_female
)
	var/datum/ta_noble_title/title = new(
		culture,
		tier,
		male,
		female,
		analogue,
		territorial_male,
		territorial_female
	)
	catalogue[title.id] = title

/// Service titles sit below the landless noble tier and never appear in its
// title pool.
/proc/taRegisterSquireTitle(
	list/catalogue,
	culture,
	male = "Squire",
	female = null
)
	var/datum/ta_noble_title/title = new(culture, -1, male, female, "Squire")
	title.id = "[culture]/-1/Squire"
	catalogue[title.id] = title

/mob/living/carbon/human/proc/taSquireNobilityTitle()
	if(!HAS_TRAIT(src, TRAIT_SQUIRE_REPAIR))
		return null
	return GLOB.ta_noble_titles["[taNobilityCulture()]/-1/Squire"] \
		|| GLOB.ta_noble_titles["azuria/-1/Squire"]

/proc/taBuildNobleTitles()
	var/list/catalogue = list()
	for(var/culture in list("azuria", "enigma"))
		taRegisterNobleTitle(catalogue, culture, 3,
			"High Lord", "High Lady", "High Lord"
		)
		taRegisterNobleTitle(catalogue, culture, 3,
			"Marquess", "Marchioness", "Marquess"
		)
		taRegisterNobleTitle(catalogue, culture, 3,
			"Duke", "Duchess", "Duke"
		)
		taRegisterNobleTitle(catalogue, culture, 2,
			"Baron", "Baroness", "Baron"
		)
		taRegisterNobleTitle(catalogue, culture, 2,
			"Viscount", "Viscountess", "Viscount"
		)
		taRegisterNobleTitle(catalogue, culture, 1,
			"Lord", "Lady", "Lord/Lady"
		)
		taRegisterNobleTitle(catalogue, culture, 0,
			"Ser", "Dame", "Ser/Dame", "Knight", "Knight"
		)
	// heartfelt
	taRegisterNobleTitle(catalogue, "heartfelt", 3,
		"Count", "Countess", "High Lord/Duke"
	)
	taRegisterNobleTitle(catalogue, "heartfelt", 3,
		"Marquess", "Marchioness", "Marquess"
	)
	taRegisterNobleTitle(catalogue, "heartfelt", 3,
		"Duke", "Duchess", "Duke"
	)
	taRegisterNobleTitle(catalogue, "heartfelt", 2,
		"Baron", "Baroness", "Baron"
	)
	taRegisterNobleTitle(catalogue, "heartfelt", 2,
		"Viscount", "Viscountess", "Viscount"
	)
	taRegisterNobleTitle(catalogue, "heartfelt", 1,
		"Lord", "Lady", "Lord/Lady"
	)
	taRegisterNobleTitle(catalogue, "heartfelt", 0,
		"Ser", "Dame", "Ser/Dame", "Knight", "Knight"
	)
	taRegisterNobleTitle(catalogue, "heartfelt", 0,
		"Lord", "Lady", "Ser/Dame"
	)
	// grenzelhoft
	taRegisterNobleTitle(catalogue, "grenzelhoft", 3,
		"Graf", "Gräfin", "Count"
	)
	taRegisterNobleTitle(catalogue, "grenzelhoft", 3,
		"Markgraf", "Markgräfin", "Marquess"
	)
	taRegisterNobleTitle(catalogue, "grenzelhoft", 3,
		"Herzog", "Herzogin", "Duke"
	)
	taRegisterNobleTitle(catalogue, "grenzelhoft", 2,
		"Freiherr", "Freifrau", "Baron"
	)
	taRegisterNobleTitle(catalogue, "grenzelhoft", 1,
		"Edler", "Edle", "Lord/Lady"
	)
	taRegisterNobleTitle(catalogue, "grenzelhoft", 1,
		"Junker", "Junkerin", "Lord/Lady"
	)
	taRegisterNobleTitle(catalogue, "grenzelhoft", 0,
		"Ritter", "Ritterin", "Ser/Dame"
	)
	taRegisterNobleTitle(catalogue, "grenzelhoft", 0,
		"Edler", "Edle", "Ser/Dame"
	)
	// valoria
	taRegisterNobleTitle(catalogue, "valoria", 3,
		"Conte", "Contessa", "High Lord/Duke"
	)
	taRegisterNobleTitle(catalogue, "valoria", 3,
		"Marchese", "Marchesa", "High Lord/Duke"
	)
	taRegisterNobleTitle(catalogue, "valoria", 3,
		"Duca", "Duchessa", "High Lord/Duke"
	)
	taRegisterNobleTitle(catalogue, "valoria", 2,
		"Barone", "Baronessa", "Baron/Viscount"
	)
	taRegisterNobleTitle(catalogue, "valoria", 2,
		"Visconte", "Viscontessa", "Baron/Viscount"
	)
	taRegisterNobleTitle(catalogue, "valoria", 1,
		"Signore", "Signora", "Lord/Lady"
	)
	taRegisterNobleTitle(catalogue, "valoria", 1,
		"Patrician", "Patrician", "Lord/Lady"
	)
	taRegisterNobleTitle(catalogue, "valoria", 0,
		"Cavaliere", "Dama", "Ser/Dame", "Knight", "Knight"
	)
	taRegisterNobleTitle(catalogue, "valoria", 0,
		"Nobile", "Nobile", "Ser/Dame"
	)
	// otava
	taRegisterNobleTitle(catalogue, "otava", 3,
		"Comte", "Comtesse", "High Lord/Duke"
	)
	taRegisterNobleTitle(catalogue, "otava", 3,
		"Marquis", "Marquise", "High Lord/Duke"
	)
	taRegisterNobleTitle(catalogue, "otava", 3,
		"Duc", "Duchesse", "High Lord/Duke"
	)
	taRegisterNobleTitle(catalogue, "otava", 2,
		"Baron", "Baronne", "Baron"
	)
	taRegisterNobleTitle(catalogue, "otava", 2,
		"Vicomte", "Vicomtesse", "Baron/Viscount"
	)
	taRegisterNobleTitle(catalogue, "otava", 1,
		"Seigneur", "Dame", "Lord/Lady"
	)
	taRegisterNobleTitle(catalogue, "otava", 0,
		"Chevalier", "Dame", "Ser/Dame", "Knight", "Knight"
	)
	// etrusca
	taRegisterNobleTitle(catalogue, "etrusca", 3,
		"Conde", "Condesa", "High Lord/Duke"
	)
	taRegisterNobleTitle(catalogue, "etrusca", 3,
		"Marqués", "Marquesa", "High Lord/Duke"
	)
	taRegisterNobleTitle(catalogue, "etrusca", 3,
		"Duque", "Duquesa", "High Lord/Duke"
	)
	taRegisterNobleTitle(catalogue, "etrusca", 2,
		"Barón", "Baronesa", "Baron/Viscount"
	)
	taRegisterNobleTitle(catalogue, "etrusca", 2,
		"Vizconde", "Vizcondesa", "Baron/Viscount"
	)
	taRegisterNobleTitle(catalogue, "etrusca", 1,
		"Señor", "Señora", "Lord/Lady"
	)
	taRegisterNobleTitle(catalogue, "etrusca", 0,
		"Don", "Doña", "Ser/Dame"
	)
	// hammerhold
	taRegisterNobleTitle(catalogue, "hammerhold", 3,
		"Knyaz", "Knyaginya", "High Lord/Duke"
	)
	taRegisterNobleTitle(catalogue, "hammerhold", 2,
		"Boyar", "Boyarina", "Baron/Viscount"
	)
	taRegisterNobleTitle(catalogue, "hammerhold", 1,
		"Pomeshchik", "Pomeshchitsa", "Lord/Lady"
	)
	taRegisterNobleTitle(catalogue, "hammerhold", 0,
		"Pan", "Pani", "Ser/Dame"
	)
	// gronn
	taRegisterNobleTitle(catalogue, "gronn", 3,
		"Jarl", "Jarl", "High Lord/Duke"
	)
	taRegisterNobleTitle(catalogue, "gronn", 2,
		"Hersir", "Hersir", "Baron/Viscount"
	)
	taRegisterNobleTitle(catalogue, "gronn", 2,
		"Chieftain", "Chieftain", "Baron/Viscount"
	)
	taRegisterNobleTitle(catalogue, "gronn", 1,
		"Thane", "Thane", "Lord/Lady"
	)
	taRegisterNobleTitle(catalogue, "gronn", 0,
		"Hirdman", "Hirdwoman", "Ser/Dame"
	)
	// zybantu
	taRegisterNobleTitle(catalogue, "zybantu", 3,
		"Emir", "Emira", "High Lord/Duke"
	)
	taRegisterNobleTitle(catalogue, "zybantu", 3,
		"Satrap", "Satrap", "High Lord/Duke"
	)
	taRegisterNobleTitle(catalogue, "zybantu", 2,
		"Bey", "Begum", "Baron/Viscount"
	)
	taRegisterNobleTitle(catalogue, "zybantu", 1,
		"Agha", "Agha", "Lord/Lady"
	)
	taRegisterNobleTitle(catalogue, "zybantu", 0,
		"Faris", "Faris", "Ser/Dame"
	)
	taRegisterNobleTitle(catalogue, "zybantu", 0,
		"Sayyid", "Sayyida", "Ser/Dame"
	)
	// raneshen
	taRegisterNobleTitle(catalogue, "raneshen", 3,
		"Emir", "Emira", "High Lord/Duke"
	)
	taRegisterNobleTitle(catalogue, "raneshen", 3,
		"Satrap", "Satrap", "High Lord/Duke"
	)
	taRegisterNobleTitle(catalogue, "raneshen", 2,
		"Bey", "Begum", "Baron/Viscount"
	)
	taRegisterNobleTitle(catalogue, "raneshen", 1,
		"Agha", "Agha", "Lord/Lady"
	)
	taRegisterNobleTitle(catalogue, "raneshen", 0,
		"Faris", "Faris", "Ser/Dame"
	)
	taRegisterNobleTitle(catalogue, "raneshen", 0,
		"Sayyid", "Sayyida", "Ser/Dame"
	)
	// naledi
	taRegisterNobleTitle(catalogue, "naledi", 3,
		"Doux", "Doux", "High Lord/Duke"
	)
	taRegisterNobleTitle(catalogue, "naledi", 3,
		"Kephale", "Kephale", "High Lord/Duke"
	)
	taRegisterNobleTitle(catalogue, "naledi", 2,
		"Archon", "Archon", "Baron/Viscount"
	)
	taRegisterNobleTitle(catalogue, "naledi", 1,
		"Lord", "Lady", "Lord/Lady"
	)
	taRegisterNobleTitle(catalogue, "naledi", 0,
		"Faris", "Faris", "Ser/Dame"
	)
	taRegisterNobleTitle(catalogue, "naledi", 0,
		"Lord", "Lady", "Ser/Dame"
	)
	// kazengun
	taRegisterNobleTitle(catalogue, "kazengun", 3,
		"Daimyo", "Daimyo", "High Lord/Duke"
	)
	taRegisterNobleTitle(catalogue, "kazengun", 2,
		"Hatamoto", "Hatamoto", "Baron/Viscount"
	)
	taRegisterNobleTitle(catalogue, "kazengun", 1,
		"Gokenin", "Gokenin", "Lord/Lady"
	)
	taRegisterNobleTitle(catalogue, "kazengun", 0,
		"Samurai", "Samurai", "Ser/Dame"
	)
	// gyedzai
	taRegisterNobleTitle(catalogue, "gyedzai", 3,
		"Hou", "Hou", "High Lord/Duke"
	)
	taRegisterNobleTitle(catalogue, "gyedzai", 3,
		"Gong", "Gong", "High Lord/Duke"
	)
	taRegisterNobleTitle(catalogue, "gyedzai", 2,
		"Nan", "Nan", "Baron/Viscount"
	)
	taRegisterNobleTitle(catalogue, "gyedzai", 2,
		"Zi", "Zi", "Baron/Viscount"
	)
	taRegisterNobleTitle(catalogue, "gyedzai", 2,
		"Bo", "Bo", "Baron/Viscount"
	)
	taRegisterNobleTitle(catalogue, "gyedzai", 1,
		"Shenshi", "Shenshi", "Lord/Lady"
	)
	taRegisterNobleTitle(catalogue, "gyedzai", 0,
		"Shi", "Shi", "Ser/Dame"
	)
	// jeoseon
	taRegisterNobleTitle(catalogue, "jeoseon", 3,
		"Hujak", "Hujak", "High Lord/Duke"
	)
	taRegisterNobleTitle(catalogue, "jeoseon", 3,
		"Gongjak", "Gongjak", "High Lord/Duke"
	)
	taRegisterNobleTitle(catalogue, "jeoseon", 2,
		"Namjak", "Namjak", "Baron/Viscount"
	)
	taRegisterNobleTitle(catalogue, "jeoseon", 2,
		"Jajak", "Jajak", "Baron/Viscount"
	)
	taRegisterNobleTitle(catalogue, "jeoseon", 2,
		"Baekjak", "Baekjak", "Baron/Viscount"
	)
	taRegisterNobleTitle(catalogue, "jeoseon", 1,
		"Yangban", "Yangban", "Lord/Lady"
	)
	taRegisterNobleTitle(catalogue, "jeoseon", 0,
		"Seonbi", "Seonbi", "Ser/Dame"
	)
	// aavnr
	taRegisterNobleTitle(catalogue, "aavnr", 3,
		"Nemes", "Nemes", "High Lord/Duke"
	)
	taRegisterNobleTitle(catalogue, "aavnr", 2,
		"Nemes", "Nemes", "Baron/Viscount"
	)
	taRegisterNobleTitle(catalogue, "aavnr", 1,
		"Nemes", "Nemes", "Lord/Lady"
	)
	taRegisterNobleTitle(catalogue, "aavnr", 0,
		"Nemes", "Nemes", "Ser/Dame"
	)
	// akhdruk
	taRegisterNobleTitle(catalogue, "akhdruk", 3,
		"Badh-Lord", "Badh-Lord", "Duke"
	)
	taRegisterNobleTitle(catalogue, "akhdruk", 2,
		"Thane", "Thane", "Count"
	)
	taRegisterNobleTitle(catalogue, "akhdruk", 1,
		"Clan Elder", "Clan Elder", "Lord/Lady"
	)
	taRegisterNobleTitle(catalogue, "akhdruk", 1,
		"Master Engineer", "Master Engineer", "Lord/Lady"
	)
	taRegisterNobleTitle(catalogue, "akhdruk", 0,
		"Guildmaster", "Guildmaster", "Ser/Dame"
	)
	// drow
	taRegisterNobleTitle(catalogue, "drow", 3,
		"Archon", "Archontessa", "Duke"
	)
	taRegisterNobleTitle(catalogue, "drow", 3,
		"Patron", "Matron Mother", "Duke"
	)
	taRegisterNobleTitle(catalogue, "drow", 2,
		"Despot", "Despina", "Baron/Count"
	)
	taRegisterNobleTitle(catalogue, "drow", 1,
		"Dominus", "Domina", "Lord/Lady"
	)
	taRegisterNobleTitle(catalogue, "drow", 0,
		"Chevalier", "Chevalier", "Ser/Dame"
	)
	// lirvas
	taRegisterNobleTitle(catalogue, "lirvas", 3,
		"Goldscale", "Goldscale", "Count"
	)
	taRegisterNobleTitle(catalogue, "lirvas", 3,
		"Archon", "Archon", "Count"
	)
	taRegisterNobleTitle(catalogue, "lirvas", 2,
		"Tyrant", "Tyrant", "Baron"
	)
	taRegisterNobleTitle(catalogue, "lirvas", 2,
		"Patrician", "Patrician", "Viscount"
	)
	taRegisterNobleTitle(catalogue, "lirvas", 2,
		"Dynast", "Dynast", "Baron"
	)
	taRegisterNobleTitle(catalogue, "lirvas", 1,
		"Magnate", "Magnate", "Lord/Lady"
	)
	taRegisterNobleTitle(catalogue, "lirvas", 1,
		"Optimate", "Optimate", "Lord/Lady"
	)
	taRegisterNobleTitle(catalogue, "lirvas", 0,
		"Gilded", "Gilded", "Ser/Dame"
	)
	taRegisterNobleTitle(catalogue, "lirvas", 0,
		"Inscribed", "Inscribed", "Ser/Dame"
	)
	taRegisterNobleTitle(catalogue, "court", 3,
		"Grand Duke", "Grand Duchess", "Grand Duke"
	)
	taRegisterNobleTitle(catalogue, "court", 3,
		"King", "Queen", "King"
	)
	taRegisterNobleTitle(catalogue, "court", 3,
		"Prince", "Princess", "Prince"
	)
	taRegisterNobleTitle(catalogue, "court", 3,
		"Ducal Consort", "Ducal Consort", "Ducal Consort"
	)
	taRegisterNobleTitle(catalogue, "court", 3,
		"Sultan", "Sultana", "Sultan"
	)
	taRegisterNobleTitle(catalogue, "court", 3,
		"Amir", "Amirah", "Amir"
	)
	taRegisterNobleTitle(catalogue, "court", 3,
		"Mushir", "Mushirah", "Mushir"
	)
	taRegisterNobleTitle(catalogue, "court", 3,
		"Vizier", "Vizier", "Vizier"
	)
	taRegisterNobleTitle(catalogue, "court", 3,
		"Consort", "Consort", "Consort"
	)
	taRegisterNobleTitle(catalogue, "court", 3,
		"High Lord", "High Lady", "High Lord"
	)
	taRegisterNobleTitle(catalogue, "court", 3,
		"Ser", "Dame", "Ser", "Knight Banneret", "Knight Banneret"
	)
	taRegisterNobleTitle(catalogue, "court", 2,
		"Lord", "Lady", "Lord"
	)
	taRegisterNobleTitle(catalogue, "court", 2,
		"Ser", "Dame", "Ser", "Knight", "Knight"
	)
	taRegisterNobleTitle(catalogue, "court", 0,
		"Ser", "Dame", "Ser", "Knight", "Knight"
	)
	taRegisterNobleTitle(catalogue, "court", 1,
		"Lord", "Lady", "Lord"
	)
	taRegisterNobleTitle(catalogue, "court", 2,
		"Baron", "Baroness", "Baron"
	)
	taRegisterNobleTitle(catalogue, "court", 2,
		"Faris", "Faris", "Faris"
	)

	taRegisterSquireTitle(catalogue, "azuria")
	taRegisterSquireTitle(catalogue, "enigma")
	taRegisterSquireTitle(catalogue, "heartfelt")
	taRegisterSquireTitle(catalogue, "grenzelhoft", "Knappe")
	taRegisterSquireTitle(catalogue, "valoria", "Scudiero", "Scudiera")
	taRegisterSquireTitle(catalogue, "otava", "Écuyer", "Écuyère")
	taRegisterSquireTitle(catalogue, "etrusca", "Escudero", "Escudera")
	taRegisterSquireTitle(catalogue, "hammerhold", "Giermek")
	taRegisterSquireTitle(catalogue, "gronn", "Kertilsvein")
	taRegisterSquireTitle(catalogue, "zybantu", "Fata", "Fatat")
	taRegisterSquireTitle(catalogue, "raneshen", "Fata", "Fatat")
	taRegisterSquireTitle(catalogue, "naledi", "Hypaspist")
	taRegisterSquireTitle(catalogue, "kazengun", "Koshō")
	taRegisterSquireTitle(catalogue, "gyedzai", "Shicong")
	taRegisterSquireTitle(catalogue, "jeoseon", "Sijong")
	taRegisterSquireTitle(catalogue, "aavnr", "Nökör")
	taRegisterSquireTitle(catalogue, "akhdruk", "Shieldbearer")
	taRegisterSquireTitle(catalogue, "drow", "Initiate")
	taRegisterSquireTitle(catalogue, "lirvas")
	return catalogue
