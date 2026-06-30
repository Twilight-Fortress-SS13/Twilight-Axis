/*
			< ATTENTION >
	If you need to add more map_adjustment, check 'map_adjustment_include.dm'
	These 'map_adjustment.dm' files shouldn't be included in 'dme'
*/

/datum/map_adjustment/template/deserttown
	map_file_name = "deserttown.dmm"
	realm_name = "Al-Ashur"
	// BEGIN DESERT TOWN CONTRACTS (Rollback by removing this list)
	threat_regions = list(
		THREAT_REGION_DESERT_NEAR,
		THREAT_REGION_DESERT_DEEP,
	)
	realm_type = "Sultanate"
	realm_type_short = "Sultanate"
	slot_adjust = list(
		// /datum/job/roguetown/mercenary = 7, //haha fuck you one less slot!!
		// /datum/job/roguetown/apothecary = 1, //remodelled the building for more room
		/datum/job/roguetown/gnoll = 3,//hyenas just belong here!
	)
	title_adjust = list(
		/datum/job/roguetown/cook = list(display_title = "Abd-Al-Matbakh", f_title = "Abd-Al-Matbakh"),
		/datum/job/roguetown/tapster = list(display_title = "Abd-Al-Khidma", f_title = "Abd-Al-Khidma"),
		/datum/job/roguetown/bathworker = list(display_title = "Khadim-Hammam", f_title = "Khadim-Hammam"),
		/datum/job/roguetown/merchant = list(display_title = "Tajir-Kalan", f_title = "Tajir-Kalan"),
		/datum/job/roguetown/bathmaster = list(display_title = "Hammami", f_title = "Hammami"),
		/datum/job/roguetown/innkeeper = list(display_title = "Sahib-Al-Khan", f_title = "Sahib-Al-Khan"),
		/datum/job/roguetown/apothecary = list(display_title = "Attar", f_title = "Attar"),
		/datum/job/roguetown/guildsman = list(display_title = "Tawaifi", f_title = "Tawaifi"),
		/datum/job/roguetown/guildmaster = list(display_title = "Rais-Al-Tawaifa", f_title = "Rais-Al-Tawaifa"),
		/datum/job/roguetown/adventurer/courtagent = list (display_title = "Enslaved kafir", f_title = "Enslaved kafir"),
		/datum/job/roguetown/marshal = list(display_title = "Mushir", f_title = "Mushira"),
		/datum/job/roguetown/prince = list(display_title = "Amir", f_title = "Amira"),
		/datum/job/roguetown/priest =  list(display_title = "High Priest", f_title = "High Priestess"),
		/datum/job/roguetown/clerk = list(display_title = "Katib", f_title = "Katiba"),
		/datum/job/roguetown/squire = list(display_title = "Radif", f_title = "Radifah"),
		/datum/job/roguetown/physician = list(display_title = "Palace Physician"),
		/datum/job/roguetown/villager = list(display_title = "Villager"),
		/datum/job/roguetown/magician = list(display_title = "Palace Magician"),
		/datum/job/roguetown/pilgrim = list(display_title = "Nomad"),
	)
	tutorial_adjust = list(
		/datum/job/roguetown/cook = "Волею судьбы вы попали в рабство к Сахибу-Аль-Хану. Это не самая худшая судьба, особенно зная что вы работаете с едой: готовите, сохраняете, придумываете рецепты. Но клеймо раба гнетёт...",
		/datum/job/roguetown/tapster = "Волею судьбы вы попали в рабство к Сахибу-Аль-Хану. Это не самая худшая судьба, учитывая с кем и как вы работаете: вы не более чем прислуга, разносящий еду и обслуживающий клиентов караван-сарая. Но клеймо раба гнетёт...",
		/datum/job/roguetown/bathworker = "Неважно добровольно ли, силой ли, или как либо ещё - но вы оказались рабом в хаммаме. Это не самая худшая судьба, учитывая что вас могли, вероятно, попросту убить?... Но теперь вы бесправная вещь в руках Хаммами - вашего Господина, именно ему решать вашу дальнейшую судьбу",
		/datum/job/roguetown/merchant = "Таджир-Калан, как вас здесь именуют, означает 'старшего торговца', что довольно точно отражает ваше положение: вы возглавляете местный торговый базар, именно вы решаете куда и какой караван пойдёт, что он продаст и что он купит. Это весьма и весьма влиятельное положение - однако роспуск таваифа Шейхов, в котором ваш предшественник занимал одну из главных ролей, значительно подкосил ваше положение, ныне вы ничуть не лучше обезьянки - крутитесь, бегайте, прыгайте, выполняйте пожелания господ с монетами.. И может когда-нибудь вы вернёте себе положение в Султанате.",
		/datum/job/roguetown/bathmaster = "Зибантийский хаммам это целая наука. Столетия декаданса Золотой Империи на своём закате породили бесчисленные способы удовлетворить себя и кого-то другого. Вы - не просто банщик, вы - Хаммами, мастер хаммама, господин банных мальчиков и девочек, к вам приходят самые светлейшие особы Султаната - и никто кроме вас об этом не знает их самые грязные и самые извращения, самые изощрённые и потаённые желания: всё раскрывается и становится явным в обстановке хаммама... И кто же стоит за тем, чтобы этим всем управлять?... Конечно, вы.",
		/datum/job/roguetown/innkeeper = "Сахиб-Аль-Клан, то-есть, хозяин караван-сарая - говоря простым языком ТАВЕРНЫ - это тот, кто держит за собой целый постоялый двор, где останавливаются многочисленные путешественники, наёмники и разного рода сомнительные личности. Через ваши уши проходит целая плеяда слухов, как торговых так и бытовых, порой проходит слушок из самого Аль-Касра!.. Но не стоит забываться, ведь вы такой-же слуга Султана как и все здесь.",
		/datum/job/roguetown/apothecary = "Вы - Аттар, то-есть, лекарь, врач, целитель - как вас только не называют. В пустынях Зибантии к этому призванию относятся особенно трепетно: многие пустынные придания и легенды повествуют о мудрых целителях, полу-мистических людях, что целительствуют сколько не научным рассчётом - сколько связью с богами.",
		/datum/job/roguetown/guildsman = "Вы полноправный член таваифа ремесленников, что был создан заново сравнительно недавно. Так или иначе связанный со своим Раис-Аль-Таваифом, вы трудитесь как на его - так и на благо таваифа, не забывая взять себе определённый процент.",
		/datum/job/roguetown/guildmaster = "Несколько лет назад таваиф, то-есть объединение ремесленников и торговцев, который возглавляли влиятельные шейхи Аль-Ашура, был упразднён и распущен. Сразу после этого случилось 'восстание Шейхов' и дюны заполнились пустынными бандитами. Вы, Раис-Аль-Таваифа, ныне возглавляете созданный заново недавно таваиф ремесленников, однако не имеете практически никакого влияния, по сравнению с тем, что было у таваифа ранее. Выполняйте заказы Султана и местных жителей и быть может, однажды, вы вернёте себе несметные богатства Шейхов.",
		/datum/job/roguetown/adventurer/courtagent = "Волею судеб вы стали рабом. Но вы были слишком полезны - ваши связи, ваши умения, ваши способности приглянулись ВИЗИРЮ. Теперь Вы обязаны ему не только своей жизнью - но и отсутствием какого-либо клейма. Вам дано поручение - шпионаж. Слушайтесь своего Господина и быть может, однажды, вас сделают свободным.",
		/datum/job/roguetown/marshal = "Зибантия никогда не была спокойным местом, всегда находились пустынники что решили развязать войну за торговые маршруты. Однако ситуация значительно ухудшилась после сумеречной войны. Вы - Мушир, главнокомандующий воинства Султана. В вашем распоряжении находятся катафракты, янычары и азебы - к последним вы всегда относились настороженно, какой верности можно ожидать от рабов?",
		/datum/job/roguetown/physician = "Вы личный лекарь Султана, который лично избрал вас для такого ответственного занятия. В вашем распоряжении значительные интеллектуальные труды всего востока - не посмейте же посрамить право называться лекарем самого Султана!",
		/datum/job/roguetown/magician = "Твой путь это священный обет, посвященный покорению искусства арканы и неутолимой жажды познания. \
        Ты обязан своей жизнью Султану, ибо лишь его щедрые маммоны позволили тебе продолжать изыскания в эти суровые времена. \
        Взамен ты не раз доказывал свою верность престолу, служа справедливым кади его величества.",
		/datum/job/roguetown/squire = "Ты - Радиф, младший соратник и верный оруженосец на службе у закованного в сталь Фариса. \
        Твой удел - нести щит своего мастера, чистить его пластинчатый доспех и ухаживать за его боевым сайгаком в прохладе оазисов. \
        Пусть знатная хасса и шейхи во дворцах едва замечают твое присутствие, на поле боя ты — его щит, его тень и его самый верный клинок. \
        Учись прилежно, стойко терпи суровость тренировок в песках фронтира, и однажды, пролив достаточно вражеской крови в грядущих войнах славы, \
        ты заслужишь право омыть свой лик золотом и самому наречься истинным Фарисом Султаната.",
		/datum/job/roguetown/prince = "Ты никогда не ведал, что такое зимняя стужа, не знал терзаний голода и, конечно, не трудился ни дня в своей жизни. \
        Ты волен, словно птица в небесах, и можешь предаваться любым порокам, покуда твои родители восседают на престоле. \
        Но однажды тебе придется повзрослеть, и тогда настанет день, когда твоя беспечность обойдется тебе куда дороже, чем несколько растраченных маммонов.",
		/datum/job/roguetown/clerk = "Писец-катиб, сборщик податей, благословенный глупец. Ты помогаешь султанскому Визирю во всем, что ему потребуется, и берешь на себя его бремя, когда тот отсутствует. Пусть ты и не принадлежишь к благородной хассе, это далеко не худшая доля. Вот только есть одна оговорка: если султанские маммоны будут утеряны или бесследно исчезнут, знатный вельможа всегда сможет откупиться и избежать рабских колодок. А ты? Эх... Ну, говорят, в Гизе в это время года на редкость красиво.",
		/datum/job/roguetown/shophand = "Ты трудишься в величайшей лавке Аль-Ашура по воле купца, который приковал тебя к этой тягостной рутине. \
        Раскладывать товары по полкам и вести учет для своего господина — занятие монотонное и отупляющее, но у тебя хотя бы есть кров \
        и сытая жизнь в тепле. Быть может, со временем тебе удастся стать кем-то большим, нежели просто слугой.",
	)
	/// Jobs that this map won't use
	blacklist = list(
		/datum/job/roguetown/hag,
		// /datum/job/roguetown/adventurer//Adventurers (Could rename which are 'foreigners but who cares)'
		// /datum/job/roguetown/wretch,
		/datum/job/roguetown/bandit,
		// /datum/job/roguetown/pilgrim, //I have Nomads in the dtvillager.dm //actually this makes sense as a non-zyb foreigner!
		// /datum/job/roguetown/trader,
		// /datum/job/roguetown/assassin,

		/datum/job/roguetown/lord,// sultan//moved to an if-map-then-outfit
		/datum/job/roguetown/knight,// cataphract
		/datum/job/roguetown/hand,// vizier
		// /datum/job/roguetown/suitor,
		/datum/job/roguetown/steward, //gonna try merging this role with Vizier EDIT: with the higher pop we can afford to keep em separate now
		// /datum/job/roguetown/consort,
		// /datum/job/roguetown/captain,
		// /datum/job/roguetown/bailiff,

		//church. Fine as is

		/datum/job/roguetown/seneschal,// headslave
		/datum/job/roguetown/councillor,// sheikh
		// /datum/job/roguetown/magician,// moved to an if-map-then-outfit statement in the baseblock
		/datum/job/roguetown/jester, //are jesters really a desert thing? Maybe ought to push people into playing slaves instead..?
		// /datum/job/roguetown/physician,

		/datum/job/roguetown/manorguard,//  mamaluk
		// /datum/job/roguetown/rookie,//  mamalukrookie!
	//	/datum/job/roguetown/guardsman,//  mamaluk
		/datum/job/roguetown/vanguard,//  jannissary
		/datum/job/roguetown/warden,//  jannissary
		/datum/job/roguetown/sergeant,//janissary sergeant
		// /datum/job/roguetown/squire,
		// /datum/job/roguetown/veteran,
	//	/datum/job/roguetown/watchcaptain,
	//	/datum/job/roguetown/wardenmaster,

		//trader (probably fine to keep as it is)

		/datum/job/roguetown/crier, //would be fun to integrate in with the arena? Reimplement when building is added
		// /datum/job/roguetown/archivist,
		// /datum/job/roguetown/barkeep,
		// /datum/job/roguetown/guildmaster,
		// /datum/job/roguetown/guildsman,
		// /datum/job/roguetown/merchant,
		// /datum/job/roguetown/niteman,
		// /datum/job/roguetown/tailor,
		// /datum/job/roguetown/elder,
		
		// /datum/job/roguetown/villager,
		// /datum/job/roguetown/farmer,
		// /datum/job/roguetown/prisonerb,
		// /datum/job/roguetown/prisonerr,
		// /datum/job/roguetown/hostage,
		// /datum/job/roguetown/nightmaiden, // Current ones are probably fine?
		// /datum/job/roguetown/cook,
	//	/datum/job/roguetown/knavewench, //maybe after expanding the tavern for it
		// /datum/job/roguetown/lunatic,


		//inquisition. Fine as is

		//mercenaries. Fine as is
		
		/datum/job/roguetown/servant,//slave
		// /datum/job/roguetown/apothecary,
		// /datum/job/roguetown/churchling,
		// /datum/job/roguetown/clerk, //gonna try merging this with Sheikh - EDIT with higher pop we can afford to keep this role around
		// /datum/job/roguetown/wapprentice,
		// /datum/job/roguetown/orphan,
		// /datum/job/roguetown/prince,//dtprince
		// /datum/job/roguetown/shophand,
		
	//	/datum/job/roguetown/tribalchieftain,
	//	/datum/job/roguetown/tribalshaman,
	//	/datum/job/roguetown/tribalguard,
	//	/datum/job/roguetown/tribalrabble,
	//	/datum/job/roguetown/tribalvillager,

		/datum/job/roguetown/royal_guard, 
		/datum/job/roguetown/sheriff, 
		/datum/job/roguetown/town_watch, 
		/datum/job/roguetown/vanguard, 
		/datum/job/roguetown/courtphysician, 
		/datum/job/roguetown/knight_enigma, 
		/datum/job/roguetown/royal_sergeant, 
		/datum/job/roguetown/overseer, 
		/datum/job/roguetown/mayor,
		/datum/job/roguetown/bailiff,
	)


/*list to blacklist for other maps (update as new replacements are added)
		/datum/job/roguetown/cataphract,
		/datum/job/roguetown/vizier,
		/datum/job/roguetown/headslave,
		/datum/job/roguetown/sheikh,
		/datum/job/roguetown/janissary,
		/datum/job/roguetown/janissarysergeant,
		/datum/job/roguetown/azeb,
		/datum/job/roguetown/azebagha,
		/datum/job/roguetown/slavemaster,
		/datum/job/roguetown/dtslave, */

/datum/map_adjustment/template/deserttown/on_mapping_init()
	. = ..()
	setup_deserttown_economy()
