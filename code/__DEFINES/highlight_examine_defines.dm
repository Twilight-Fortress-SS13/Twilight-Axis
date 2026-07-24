// Zizo items
#define HERESYDESC_ZIZO_WEAPON "Мрачное оружие воинов Зизо"
#define HERESYDESC_ZIZO_ARMOR "Проклятый доспех воинов Зизо"
#define HERESYDESC_ZIZO_RELIC "Реликвия мрачного творения Зизо"
#define HERESYDESC_ZIZO_ICON "На нём изображён мрачный крест Зизо"
#define HERESYDESC_ZIZO_MISC "Известный дизайн Зизо"
#define HERESYDESC_ZIZO_AVANTYNE "Оно выковано из мерзкого авантина Зизо"
#define HERESYDESC_ZIZO_ARTIFICE "Искусно созданный образец Зизо, воссозданный с пугающей точностью"
#define HERESYDESC_ZIZO_ARTIFICE_RECLAIMED "Загадочный дизайн из древних времен"

// Matthios items
#define HERESYDESC_MATTHIOS_WEAPON "Оружие алчных воинов Маттиоса"
#define HERESYDESC_MATTHIOS_ARMOR "Доспех алчных воинов Маттиоса"
#define HERESYDESC_MATTHIOS_RELIC "Реликвия алчного дизайна Маттиоса"
#define HERESYDESC_MATTHIOS_ICON "На нём изображён символ Маттиоса"
#define HERESYDESC_MATTHIOS_MISC "Известный образец Маттиоса"

// Graggar items
#define HERESYDESC_GRAGGAR_WEAPON "Оружие кровожадных воинов Граггара"
#define HERESYDESC_GRAGGAR_ARMOR "Зловещий доспех воинов Граггара"
#define HERESYDESC_GRAGGAR_RELIC "Реликвия жестокого замысла Граггара"
#define HERESYDESC_GRAGGAR_ICON "На нём изображён символ жестокого Граггара"
#define HERESYDESC_GRAGGAR_MISC "Известный образец, созданный Граггаром"

// Baotha items
#define HERESYDESC_BAOTHA_WEAPON "Оружие гнустных воинов Баоты"
#define HERESYDESC_BAOTHA_ARMOR "Доспех гнустных воинов Баоты"
#define HERESYDESC_BAOTHA_RELIC "Реликвия, созданная по развратным замыслам Баоты"
#define HERESYDESC_BAOTHA_ICON "На нём изображён символ развратной Баоты"
#define HERESYDESC_BAOTHA_MISC "Известный образец творчества Баоты"

// Abyssor dream items
#define HERESYDESC_DREAM_ITEM "Оружие из кошмаров Абиссора. Оно опасно, и не должно находиться в руках простых смертных, что не обладают знаниями о том, как сдержать его зловещую мощь"
// Dreamwalker items
#define HERESYDESC_DREAMWALKER_WEAPON "Оружие загадочного и жестокого культа Кошмара"
#define HERESYDESC_DREAMWALKER_ARMOR "Доспехи загадочного и жестокого культа Кошмара"

// Misc items
#define HERESYDESC_GRONN "Символ странных верований Севера"
#define HERESYDESC_WEEPING_CROSS "Он сделан из странного металла, который словно бы кровоточит"

// Vampire Lord Items - General theme is mysterious but a bad omen
#define HERESYDESC_VAMPIRE "Неестественный зачарованный доспех, выкованный из гилбранза. Его поверхность будто бы искрится странной энергией"
#define HERESYDESC_VAMPIRE_CROWN "Неестественная зачарованнная корона, что искрится странной энергией" 
#define HERESYDESC_VAMPIRE_SWORD "Неестественный меч из неизвестного сплава, что искрится странной энергией"

// Inquisitional gear
#define HERESYDESC_INQUIS_WHISPERER "Очень необычный дизайн кольца... Кажется, оно шепчет?" //Only shows while not equipped on ring slot
#define HERESYDESC_INQUIS_CHURNER "Я СЛЫШУ МОЛЬБЫ О ПОМОЩИ, ДОНОСЯЩИЕСЯ ИЗНУТРИ, ЧТО ЭТО ТАКОЕ?!!" //Only shows while active

#define VIBEDESC_FRIEND "Верный союзник Короны."
#define VIBEDESC_FOE "Заклятый враг Короны."
#define VIBEDESC_CROWN "Реликвия, освященная Астратой."
#define VIBEDESC_GOLGATHA "Реликвия, ниспосланная Всеотцом."

/**
* -========= HERESY ITEM SEVERITY LEVELS =========-
*
* The more "Severely" heretical an item is, the more
* alarmingly the item will be presented on examine.
*
* -===============================================-*/
/** For items that are both blatantly heretical AND actively dangerous.
* Items should be marked with this if the expected response to seeing someone
* carrying them is to quickly escalate to violence.
* 
* i.e. heretic armor, avantyne weapons
*/
#define EXAMINEHIGHLIGHT_HERESYSEVERITY_ALARMING 1
/** For items that are heretical and will get you in trouble if you're caught with them,
* but not enough for people to jump straight to violence on sight without probable cause.
* 
* i.e. Ascendant amulets
*/
#define EXAMINEHIGHLIGHT_HERESYSEVERITY_SUSPICIOUS 2
/** For items that are unusual displays of faith that are either not commonly known expressions
* of heretical beliefs, or are simply inoffensive enough that the common Tennite / Psydonite probably won't
* get in someone's hair about it, but will likely give the wielders funny looks and odd squints.
*
* i.e. Gronn/Fjall carving amulets
*/
#define EXAMINEHIGHLIGHT_HERESYSEVERITY_ODD 3

#define EXAMINEHIGHLIGHT_VIBE_FRIEND 4
#define EXAMINEHIGHLIGHT_VIBE_FOE 5
#define EXAMINEHIGHLIGHT_VIBE_CROWN 6
#define EXAMINEHIGHLIGHT_VIBE_GOLGATHA 7

/** For items that are unnautral or clearly cursed, I.E ancient ceremonial armor, the vlord sword
* not defined enough that the average Tennite / Psydonite would always attack on sight but definitely it will
* get you probably taken captive/questioned by the Inqusition or pulled over by the Clergy/Garrison if you were just openly showing it.
*
* i.e. The Ichor Fang, Weeping Psycross, Blacksite Items like Listeners in their Obvious Form
*/
#define EXAMINEHIGHLIGHT_HERESYSEVERITY_VERYODD 8

// Heresy severity colors
#define COLOR_HERESYSEVERITY_ALARMING "#c43535"
#define COLOR_HERESYSEVERITY_SUSPICIOUS "#c49337"
#define COLOR_HERESYSEVERITY_ODD "#c564c5"
#define COLOR_HERESYSEVERITY_VERYODD "#c564c5"

//Other Colors
#define COLOR_VIBE_FRIEND "#6476c5"
#define COLOR_VIBE_FOE "#c43535"
#define COLOR_VIBE_CROWN "#ffdc7c"
#define COLOR_VIBE_GOLGATHA "#94f8ff"

// Heresy severity descriptions
#define EXAMINEHIGHLIGHT_TOOLTIP_HERESYSEVERITY_ALARMING "<font color=[COLOR_HERESYSEVERITY_ALARMING]><b>ЕРЕСЬ!</b></font><br>Этот зловещий дизайн используется еретиками, скрывающимися в темных уголках Гримории. Встреча с владельцем такого предмета не сулит ничего хорошего для последователей Десяти и Одного."
#define EXAMINEHIGHLIGHT_TOOLTIP_HERESYSEVERITY_SUSPICIOUS "<font color=[COLOR_HERESYSEVERITY_SUSPICIOUS]><b>Вероятно, еретический дизайн!</b></font><br>Такие предметы часто обнаруживаются у схваченных ересиархов, и, предположительно, являются символами их веры. Последователи Десяти и Одного отнесутся к владельцу как минимум с подозрением."
#define EXAMINEHIGHLIGHT_TOOLTIP_HERESYSEVERITY_ODD "<font color=[COLOR_HERESYSEVERITY_ODD]><b>Странное проявление веры... </b></font><br>Хоть этот предмет и не несет на себе явного символа еретической веры, он явно указывает на принадлежность к необычным, возможно, языческим верованиям. Инквизиция, вероятно, следит за владельцами таких предметов."
#define EXAMINEHIGHLIGHT_TOOLTIP_HERESYSEVERITY_VERYODD "<font color=[COLOR_HERESYSEVERITY_ALARMING]><b>Это очень подозрительный дизайн!</b></font><br>Такие предметы часто обнаруживаются у схваченных ересиархов. Открытое их ношение служит поводом для подозрений со стороны последователей Десяти и Одного."

#define EXAMINEHIGHLIGHT_TOOLTIP_VIBE_FRIEND "<font color=[COLOR_VIBE_FRIEND]><b>Проявление преданности.</b></font><br>Символ верных подданных Короны. Многие простые жители могут видеть во владельце друга, союзника или слугу Короны."
#define EXAMINEHIGHLIGHT_TOOLTIP_VIBE_FOE "<font color=[COLOR_VIBE_FOE]><b>Проявление мятежа.</b></font><br>Символ тех, кто противостоит Короне. Многие простые жители могут относиться ко владельцу с подозрением, видя в нем мятежника или врага государства."
#define EXAMINEHIGHLIGHT_TOOLTIP_VIBE_CROWN "<font color=[COLOR_VIBE_CROWN]><b>Тяжела корона, и таковой она будет всегда.</b></font><br>Такие символы не даруются легкомысленно, ибо они означают власть, осуществляемую под вечным светом Астраты. Это признанный знак божественного суверенитета, символизирующий священное право на правление, предоставленное Госпожёй Порядка избранной династии. Большинство подданных должны относиться к его носителю с почтением, признавая положение и власть, на которые могут претендовать лишь немногие."
#define EXAMINEHIGHLIGHT_TOOLTIP_VIBE_GOLGATHA "<font color=[COLOR_VIBE_GOLGATHA]><b>`Пламя СВЯЩЕННОЙ КОМЕТЫ СИОН выжжет любую ТЬМУ из Псайдонии, пока не останутся лишь РУИНЫ СТАРОГО МИРА.`</b></font><br>В этом артефакте содержится нестабильный осколок <font color=[COLOR_VIBE_GOLGATHA]><b>кометы СИОН</b></font> – древней реликвии, ниспосланной с небес самим Псайдоном в ранние годы Войны в Небесах. Служители псайдонитской веры, вероятно, <b>отреагируют крайне негативно,</b> если мне не вверено владение этим предметом."

// Heresy severity symbols
#define EXAMINEHIGHLIGHT_SYMBOL_HERESYSEVERITY_SUSPICIOUS "!"
#define EXAMINEHIGHLIGHT_SYMBOL_HERESYSEVERITY_VERYODD "!"
/// Zcross unicode in HTML form
#define EXAMINEHIGHLIGHT_SYMBOL_HERESYSEVERITY_ALARMING "&#x16E3;"
#define EXAMINEHIGHLIGHT_SYMBOL_HERESYSEVERITY_ODD "?"

#define SYMBOL_VIBE_FRIEND "&#x26E8;"
#define SYMBOL_VIBE_FOE "&#x2694;"
#define SYMBOL_VIBE_CROWN "&#x2654;"
#define SYMBOL_VIBE_GOLGATHA "&#5833;"
