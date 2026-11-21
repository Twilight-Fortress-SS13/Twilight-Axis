/obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/janissary
	name = "janissary chainmail"
	desc = "A longer steel maille that protects the legs."
	sleeved = 'modular_twilight_axis/icons/roguetown/clothing/onmob/helpers/sleeves_armor.dmi'
	icon = 'modular_deserttown/icons/clothing/armor.dmi'
	mob_overlay_icon = 'modular_deserttown/icons/clothing/onmob/armor.dmi'
	icon_state = "mamaluke"
	item_state = "mamaluke"
	max_integrity = 350
	slot_flags = ITEM_SLOT_ARMOR

/obj/item/clothing/suit/roguetown/armor/plate/cataphract
	name = "cataphract plate-scale armor"
	desc = "Metal scales interwoven intricately to form flexible protection!"
	icon = 'modular_deserttown/icons/clothing/armor.dmi'
	mob_overlay_icon = 'modular_deserttown/icons/clothing/onmob/armor.dmi'
	sleeved = 'modular_twilight_axis/icons/roguetown/clothing/onmob/helpers/sleeves_armor.dmi'
	icon_state = "cataphract"
	icon_state = "cataphract"
	body_parts_covered = COVERAGE_ALL_BUT_HANDFEET | NECK
	equip_delay_self = 12 SECONDS
	unequip_delay_self = 12 SECONDS
	equip_delay_other = 3 SECONDS
	strip_delay = 6 SECONDS
	max_integrity = ARMOR_INT_CHEST_PLATE_STEEL
	smelt_bar_num = 4
	armor_class = ARMOR_CLASS_HEAVY
	armor = ARMOR_PLATE
	slot_flags = ITEM_SLOT_ARMOR

/obj/item/clothing/suit/roguetown/armor/plate/cataphract/mushir
	name = "mushir's plate-scale armor"
	color = "#514339"

/obj/item/clothing/suit/roguetown/armor/plate/full/blacksteel/legate/sultan
	name = "sultan's full-plate armor"
	desc = "Внушительный и величественный латный доспех, по надежности не уступающий лучшим рыцарским латам, выкованный на основе старых доспехов времен Божественной Империи. \
	Тяжкий и кропотливый труд мастеров кузнечного дела возвел создание рельефного торса в абсолют, превратив грубую броню в произведение искусства и украсив темные пластины и плечи золотой вязью. \
	Облаченный в этот грозный доспех Султан способен выдержать натиск целой армии, оставаясь недосягаемым для клинков неверных. Блеск драгоценного металла и мрак черностали скрывают под собой смертного правителя, \
	оставляя взору лишь величие престола. </br>‎  </br>Перед лицом смерти повелитель обязан оставаться несокрушимым символом."

/obj/item/clothing/head/roguetown/helmet/blacksteel/legate/sultan
	name = "sultan's helmet"
	desc = "Тяжелый боевой шлем из черностали, созданный придворными мастерами из лат павших рыцарей Запада и украшенный остатками их знамен для единственного повелителя, чья власть освящена самой верой. Султан — меч и щит своей империи, чей гнев подобен испепеляющему самуму, а милость дарует жизнь. \
	Лицо правителя закрывает глухая золотая маска с узкими прорезями для глаз, не позволяющая врагам увидеть ни тени сомнения. Золотые лучи короны переплавленные из венцов дворян Черной Империи, вплавленны в темный купол сияют над полем боя подобно неугасимому солнцу. \
	</br>‎  </br>Кто скрывается за бесстрастным металлом — мудрый отец народа или беспощадный завоеватель? Надевая лик владыки, помни, что назад пути уже нет."

/obj/item/clothing/shoes/roguetown/boots/armor/blacksteel/legate/sultan
	name = "sultan's babouches"
	desc = "Тяжелые боевые султанские бабуши из мягкого сафьяна, окованные золотом и черносталью. Когда-то это были шлемы гордых рыцарей Грензельхофта, теперь же в них маршируют по горячему песку Зибантии. \
	</br>‎  </br>Трофеи былых завоеваний и чужая слава ныне служат лишь опорой для шагов победителя. Помни об этом, когда взойдешь на вершину собственного триумфа."

/obj/item/clothing/gloves/roguetown/plate/blacksteel/legate/sultan
	name = "sultan's plate gauntlets"
	desc = "Черносталевые латные перчатки, богато инкрустированные золотом. На их ладонях вычеканено суровое изречение: 'Моей волей и моей дланью любая дерзость будет сокрушена'. \
	</br>‎  </br>Что тяжелее нести владыке — скипетр дарующий жизнь или клинок несущий гибель? В день великого суда отвечать придется за каждый взмах руки."

/obj/item/clothing/under/roguetown/platelegs/blacksteel/legate/sultan
	name = "sultan's blacksteel plate chausses"
	desc = "Изящные и удобные для жаркого климата латные поножи, искусно сочетающие укрепленную кожу, шелк и прочные черносталевые плиты. \
	Они берегут своего владыку от раскаленного ветра дюн и коварных клинков неприятеля. </br>‎  </br>Величие империи измеряется не длиной границ, а стойкостью того, кто их охраняет. Не сворачивай с избранного пути, сколь бы тяжелым он ни был."

/obj/item/clothing/suit/roguetown/armor/brigandine/agha
	name = "agha scale"
	desc = "Fine armor made of treated animal scales, denoting an esteemd career in the dunes."
	icon_state = "huus"
	item_state = "huus"
	blocksound = SOFTHIT
	slot_flags = ITEM_SLOT_ARMOR
	blade_dulling = DULLING_BASHCHOP
	body_parts_covered = CHEST|GROIN|LEGS|VITALS|ARMS
	break_sound = 'sound/foley/cloth_rip.ogg'
	drop_sound = 'sound/foley/dropsound/cloth_drop.ogg'
	sewrepair = TRUE
	armor_class = ARMOR_CLASS_MEDIUM

/obj/item/clothing/suit/roguetown/armor/brigandine/agha/mushir
	name = "mushir's scale"
	color = "#514339"

//armorhelmets

/obj/item/clothing/head/roguetown/helmet/heavy/cataphract
	name = "cataphracts helm"
	desc = "A helmet with a menacing visage."
	icon_state = "cathelm"
	item_state = "cathelm"
	icon = 'modular_deserttown/icons/clothing/head32x48.dmi'
	mob_overlay_icon = 'modular_deserttown/icons/clothing/onmob/head32x48.dmi'
	emote_environment = 3
	flags_inv = HIDEEARS|HIDEFACE|HIDEHAIR|HIDEFACIALHAIR
	block2add = FOV_BEHIND
	smeltresult = /obj/item/ingot/steel

/obj/item/clothing/head/roguetown/helmet/janissaryhelm
	name = "janissary helmet"
	desc = "A helmet with too much style."
	icon = 'modular_deserttown/icons/clothing/head.dmi'
	mob_overlay_icon = 'modular_deserttown/icons/clothing/onmob/head.dmi'
	icon_state = "mamhelm"
	max_integrity = 320
	body_parts_covered = HEAD|HAIR|EARS
	flags_inv = HIDEEARS|HIDEHAIR

///VEST

/obj/item/clothing/suit/roguetown/armor/leather/vest/open
	name = "open vest"
	desc = "A leather vest. Not very protective when worn like this."
	icon = 'modular_deserttown/icons/clothing/armor.dmi'
	mob_overlay_icon = 'modular_deserttown/icons/clothing/onmob/armor.dmi'
	icon_state = "openvest"
	sleeved = 'modular_twilight_axis/icons/roguetown/clothing/onmob/helpers/sleeves_armor.dmi'
	body_parts_covered = CHEST|VITALS

/obj/item/clothing/suit/roguetown/armor/leather/vest/open/purple
	color = CLOTHING_PURPLE

/obj/item/clothing/suit/roguetown/armor/leather/vest/open/blue
	color = "#2f51b8"

/obj/item/clothing/suit/roguetown/armor/leather/vest/open/red
	color = CLOTHING_RED

/obj/item/clothing/suit/roguetown/armor/leather/vest/open/orange
	color = CLOTHING_ORANGE

/obj/item/clothing/suit/roguetown/armor/leather/vest/open/green
	color = CLOTHING_GREEN

/obj/item/clothing/suit/roguetown/armor/leather/vest/open/brown
	color = "#514339"

/obj/item/clothing/suit/roguetown/armor/leather/vest/open/random

/obj/item/clothing/suit/roguetown/armor/leather/vest/open/random/Initialize()
	color = pick("#2f51b8", CLOTHING_RED, CLOTHING_ORANGE, CLOTHING_GREEN, CLOTHING_PURPLE)
	..()

/obj/item/clothing/suit/roguetown/shirt/robe/bisht
	slot_flags = ITEM_SLOT_ARMOR|ITEM_SLOT_SHIRT
	name = "bisht"
	desc = "A long robe typical in Zybantine."
	icon = 'modular_deserttown/icons/clothing/easternclothes.dmi'
	mob_overlay_icon = 'modular_deserttown/icons/clothing/onmob/easternclothes.dmi'
	sleeved = 'modular_twilight_axis/icons/roguetown/clothing/onmob/helpers/sleeves_armor.dmi'
	icon_state = "greythawb"
	item_state = "greythawb"
	color = null
	body_parts_covered = CHEST|GROIN|LEGS|ARMS|VITALS
	break_sound = 'sound/foley/cloth_rip.ogg'
	drop_sound = 'sound/foley/dropsound/cloth_drop.ogg'

/obj/item/clothing/suit/roguetown/shirt/robe/bisht/grey
	color = "#989898"

/obj/item/clothing/suit/roguetown/shirt/robe/bisht/red
	color = "#9c4744"

/obj/item/clothing/suit/roguetown/shirt/robe/bisht/blue
	color = "#2f51b8"

/obj/item/clothing/suit/roguetown/shirt/robe/bisht/brown
	color = "#846145"

/obj/item/clothing/suit/roguetown/shirt/robe/bisht/beige
	color = "#e9c792"

/obj/item/clothing/suit/roguetown/shirt/robe/bisht/black
	color = CLOTHING_BLACK

/obj/item/clothing/suit/roguetown/shirt/robe/bisht/random

/obj/item/clothing/suit/roguetown/shirt/robe/bisht/random/Initialize()
	color = pick("#989898", "#FFFFFF", "#9c4744", "#2f51b8", "#846145", "#e9c792", CLOTHING_BLACK)
	..()

/obj/item/clothing/suit/roguetown/shirt/robe/bisht/bluegrey
	slot_flags = ITEM_SLOT_ARMOR|ITEM_SLOT_SHIRT
	name = "grey bisht"
	icon_state = "bluethawb"
	item_state = "bluethawb"
	sleeved = 'modular_twilight_axis/icons/roguetown/clothing/onmob/helpers/sleeves_armor.dmi'

/obj/item/clothing/suit/roguetown/shirt/robe/bisht/purple
	slot_flags = ITEM_SLOT_ARMOR|ITEM_SLOT_SHIRT
	name = "purple bisht"
	icon_state = "purplethawb"
	item_state = "purplethawb"
	sleeved = 'modular_twilight_axis/icons/roguetown/clothing/onmob/helpers/sleeves_armor.dmi'

/obj/item/clothing/suit/roguetown/shirt/robe/bisht/merchantbisht
	slot_flags = ITEM_SLOT_ARMOR|ITEM_SLOT_SHIRT
	body_parts_covered = CHEST|VITALS
	icon = 'modular_deserttown/icons/clothing/armor.dmi'
	mob_overlay_icon = 'modular_deserttown/icons/clothing/onmob/armor.dmi'
	name = "guild bisht"
	desc = "An open robe, made from luxurious silks."
	armor = ARMOR_PADDED
	icon_state = "merbisht"
	item_state = "merbisht"
	sleeved = 'modular_twilight_axis/icons/roguetown/clothing/onmob/helpers/sleeves_armor.dmi'
	color = null

/datum/crafting_recipe/roguetown/sewing/bisht
	name = "bisht"
	result = list(/obj/item/clothing/suit/roguetown/shirt/robe/bisht/beige)
	reqs = list(/obj/item/natural/cloth = 3)
	craftdiff = 2

/datum/crafting_recipe/roguetown/sewing/bisht/fancy
	name = "fine bisht"
	result = list(/obj/item/clothing/suit/roguetown/shirt/robe/bisht/bluegrey)
	reqs = list(/obj/item/natural/cloth = 2, /obj/item/natural/silk = 1)
	craftdiff = 4

//SHIRTS

//Easternclothes
/obj/item/clothing/suit/roguetown/shirt/dress/thawb
	slot_flags = ITEM_SLOT_ARMOR|ITEM_SLOT_SHIRT
	name = "thawb"
	desc = "A long, loose Zybantine robe."
	armor = ARMOR_CLOTHING
	body_parts_covered = CHEST|GROIN|LEGS|VITALS
	icon = 'modular_deserttown/icons/clothing/shirts.dmi'
	mob_overlay_icon = 'modular_deserttown/icons/clothing/onmob/shirts.dmi'
	sleeved = 'modular_twilight_axis/icons/roguetown/clothing/onmob/helpers/sleeves_armor.dmi'
	icon_state = "thawb"
	item_state = "thawb"

/obj/item/clothing/suit/roguetown/shirt/dress/thawb/black
	color = CLOTHING_BLACK

/obj/item/clothing/suit/roguetown/shirt/dress/thawb/blue
	color = "#2f51b8"

/obj/item/clothing/suit/roguetown/shirt/dress/thawb/red
	color = "#9c4744"

/obj/item/clothing/suit/roguetown/shirt/dress/thawb/beige
	color = "#e9c792"

/obj/item/clothing/suit/roguetown/shirt/dress/thawb/brown
	color = "#846145"

/obj/item/clothing/suit/roguetown/shirt/dress/thawb/grey
	color = "#989898"

/obj/item/clothing/suit/roguetown/shirt/dress/thawb/random

/obj/item/clothing/suit/roguetown/shirt/dress/thawb/random/Initialize()
	color = pick("#989898", "#FFFFFF", "#9c4744", "#2f51b8", "#846145", "#e9c792", CLOTHING_BLACK)
	..()

/datum/crafting_recipe/roguetown/sewing/thawb
	name = "thawb"
	result = list(/obj/item/clothing/suit/roguetown/shirt/dress/thawb/beige)
	reqs = list(/obj/item/natural/cloth = 2)
	craftdiff = 2

/obj/item/clothing/suit/roguetown/shirt/dress/thawb/gold
	slot_flags = ITEM_SLOT_ARMOR|ITEM_SLOT_SHIRT
	name = "gold-trimmed thawb"
	desc = "A long, loose Zybantine robe. This one is trimmed with gold-silk thread."
	body_parts_covered = CHEST|GROIN|LEGS|VITALS
	icon = 'modular_deserttown/icons/clothing/shirts.dmi'
	mob_overlay_icon = 'modular_deserttown/icons/clothing/onmob/shirts.dmi'
	sleeved = 'modular_twilight_axis/icons/roguetown/clothing/onmob/helpers/sleeves_armor.dmi'
	icon_state = "thawbgold"
	item_state = "thawbgold"

/obj/item/clothing/suit/roguetown/shirt/dress/amiradress
	slot_flags = ITEM_SLOT_ARMOR|ITEM_SLOT_SHIRT
	name = "amira's dress"
	desc = "A red skirt and binder, embroidened with infinitely intricate gold-thread patterns, and made of silk as light as air. Fit for a princess of Zybantine."
	body_parts_covered = CHEST|GROIN|LEGS|VITALS
	icon = 'modular_deserttown/icons/clothing/shirts.dmi'
	mob_overlay_icon = 'modular_deserttown/icons/clothing/onmob/shirts.dmi'
	icon_state = "dprince"
	item_state = "dprince"


/obj/item/clothing/suit/roguetown/shirt/sultan
	slot_flags = ITEM_SLOT_SHIRT|ITEM_SLOT_ARMOR
	name = "sultans robes"
	desc = "A Zybantine Sultans noble robes."
	body_parts_covered = CHEST|GROIN|VITALS|LEGS|ARMS
	boobed = FALSE
	icon = 'modular_deserttown/icons/clothing/shirts.dmi'
	mob_overlay_icon = 'modular_deserttown/icons/clothing/onmob/shirts.dmi'
	sleeved = 'icons/roguetown/clothing/onmob/helpers/sleeves_shirts.dmi'
	icon_state = "sultan"
	item_state = "sultan"
	flags_inv = HIDECROTCH|HIDEBOOB
	r_sleeve_status = SLEEVE_NORMAL
	l_sleeve_status = SLEEVE_NORMAL
	armor = ARMOR_PADDED

/obj/item/clothing/suit/roguetown/shirt/sultana
	slot_flags = ITEM_SLOT_SHIRT|ITEM_SLOT_ARMOR
	name = "sultanas dress"
	desc = "A Zybantine Sultanas noble Dress."
	body_parts_covered = CHEST|GROIN|VITALS|LEGS|ARMS
	boobed = FALSE
	icon = 'modular_deserttown/icons/clothing/shirts.dmi'
	mob_overlay_icon = 'modular_deserttown/icons/clothing/onmob/shirts.dmi'
	sleeved = 'icons/roguetown/clothing/onmob/helpers/sleeves_shirts.dmi'
	icon_state = "sultana"
	item_state = "sultana"
	flags_inv = HIDECROTCH|HIDEBOOB
	r_sleeve_status = SLEEVE_NORMAL
	l_sleeve_status = SLEEVE_NORMAL
	armor = ARMOR_PADDED

/obj/item/clothing/suit/roguetown/shirt/jafar
	slot_flags = ITEM_SLOT_SHIRT|ITEM_SLOT_ARMOR
	name = "zybantine magos robes"
	desc = "A Zybantine magos noble robes."
	body_parts_covered = CHEST|GROIN|VITALS|LEGS|ARMS
	boobed = FALSE
	icon = 'modular_deserttown/icons/clothing/shirts.dmi'
	mob_overlay_icon = 'modular_deserttown/icons/clothing/onmob/shirts.dmi'
	sleeved = 'modular_twilight_axis/icons/roguetown/clothing/onmob/helpers/sleeves_armor.dmi'
	icon_state = "jafar"
	item_state = "jafar"
	flags_inv = HIDECROTCH|HIDEBOOB
	r_sleeve_status = SLEEVE_NORMAL
	l_sleeve_status = SLEEVE_NORMAL
	armor = ARMOR_PADDED


//Eastern Clothing by Infrared Baron

/obj/item/clothing/head/roguetown/turban
	name = "turban"
	desc = "A long cloth, wound around the head."
	color = null
	body_parts_covered = HEAD|HAIR|EARS|NECK
	flags_inv = HIDEHAIR|HIDEEARS
	icon = 'modular_deserttown/icons/clothing/easternclothes.dmi'
	mob_overlay_icon = 'modular_deserttown/icons/clothing/onmob/easternclothes.dmi'
	icon_state = "turban"
	item_state = "turban"

/obj/item/clothing/head/roguetown/turban/mushir
	name = "Mushir's turban"
	desc = "A noble's turban made for the local Mushir. \"How terribly unfortunate you are!\""

/obj/item/clothing/head/roguetown/turban/tan
	color = "#93714b"

/obj/item/clothing/head/roguetown/turban/brown
	color = "#684f41"

/obj/item/clothing/head/roguetown/turban/dark
	color = "#414141"

/obj/item/clothing/head/roguetown/turban/grey
	color = "#848484"

/obj/item/clothing/head/roguetown/turban/red
	color = CLOTHING_RED

/obj/item/clothing/head/roguetown/turban/random

/obj/item/clothing/head/roguetown/turban/random/Initialize()
	color = pick("#414141", "#684f41", "#93714b", "#FFFFFF", "#848484", "#8b2323", )
	..()

/datum/crafting_recipe/roguetown/sewing/turban
	name = "turban"
	result = list(/obj/item/clothing/head/roguetown/turban)
	reqs = list(/obj/item/natural/cloth = 2)
	craftdiff = 1

/obj/item/clothing/head/roguetown/turban/fancypurple
	name = "fancy purple turban"
	desc = "A long, luxurious cloth, wound around the head."
	icon = 'modular_deserttown/icons/clothing/easternclothes.dmi'
	mob_overlay_icon = 'modular_deserttown/icons/clothing/onmob/easternclothes.dmi'
	icon_state = "purple_hood"
	item_state = "purple_hood"

/datum/crafting_recipe/roguetown/sewing/turban/fancy
	name = "fancy turban"
	result = list(/obj/item/clothing/head/roguetown/turban)
	reqs = list(
		/obj/item/natural/silk = 2,
		/obj/item/natural/cloth = 1
		)
	craftdiff = 4

/obj/item/clothing/head/roguetown/tagelmust
	name = "tagelmust"
	desc = "A long cloth, wound around the head, and a veil."
	body_parts_covered = HEAD|EARS|HAIR|NECK|NOSE|MOUTH
	flags_inv = HIDEEARS|HIDEFACE|HIDEHAIR|HIDEFACIALHAIR
	icon = 'modular_deserttown/icons/clothing/easternclothes.dmi'
	mob_overlay_icon = 'modular_deserttown/icons/clothing/onmob/easternclothes.dmi'
	icon_state = "blue_hood"
	item_state = "blue_hood"

/datum/crafting_recipe/roguetown/sewing/tagelmust
	name = "tagelmust"
	result = list(/obj/item/clothing/head/roguetown/turban)
	reqs = list(
		/obj/item/natural/silk = 2,
		/obj/item/natural/cloth = 1
		)
	craftdiff = 3
//
/obj/item/clothing/head/roguetown/sultan
	name = "sultan's turban"
	desc = "Bask in its noble size and granduer!"
	icon = 'modular_deserttown/icons/clothing/head.dmi'
	mob_overlay_icon = 'modular_deserttown/icons/clothing/onmob/head32x48.dmi'
	icon_state = "sultan"
	item_state = "sultan"
	dynamic_hair_suffix = "+generic"
	flags_inv = HIDEEARS
	slot_flags = ITEM_SLOT_MASK|ITEM_SLOT_HEAD

/obj/item/clothing/head/roguetown/sultan/merchant
	name = "merchant's turban"
	desc = "A turban, large and elaborate, made of the finest silk money can buy."
	icon_state = "merchant"
	item_state = "merchant"
	slot_flags = ITEM_SLOT_MASK|ITEM_SLOT_HEAD

/obj/item/clothing/head/roguetown/sultan/amir
	name = "amir's turban"
	desc = "Soft, decadent, grandiouse, but above all - princely."
	icon_state = "amir"
	item_state = "amir"
	slot_flags = ITEM_SLOT_MASK|ITEM_SLOT_HEAD

/obj/item/clothing/head/roguetown/sultana
	name = "sultana's headdress"
	desc = "Silky smooth Zybantine silk headress!"
	icon = 'modular_deserttown/icons/clothing/head.dmi'
	mob_overlay_icon = 'modular_deserttown/icons/clothing/onmob/head.dmi'
	icon_state = "sultana"
	item_state = "sultana"
	dynamic_hair_suffix = "+generic"
	flags_inv = HIDEEARS|HIDEHAIR
	slot_flags = ITEM_SLOT_MASK|ITEM_SLOT_HEAD

/obj/item/clothing/head/roguetown/jafar
	name = "zybantine magos hat"
	desc = "Bask in its noble size and granduer!"
	icon = 'modular_deserttown/icons/clothing/head.dmi'
	mob_overlay_icon = 'modular_deserttown/icons/clothing/onmob/head32x48.dmi'
	icon_state = "jafar"
	item_state = "jafar"
	dynamic_hair_suffix = "+generic"
	flags_inv = HIDEEARS|HIDEHAIR
	slot_flags = ITEM_SLOT_MASK|ITEM_SLOT_HEAD
//pants


/obj/item/clothing/under/roguetown/sirwal
	name = "sirwal"
	desc = "Long, baggy trousers from Zybantium."
	color = null
	icon = 'modular_deserttown/icons/clothing/pants.dmi'
	mob_overlay_icon = 'modular_deserttown/icons/clothing/onmob/pants.dmi'
	icon_state = "sirwal"
	item_state = "sirwal"

/obj/item/clothing/under/roguetown/sirwal/beige
	color = "#edc6a5"

/obj/item/clothing/under/roguetown/sirwal/brown
	color = "#927351"

/obj/item/clothing/under/roguetown/sirwal/black
	color = CLOTHING_BLACK

/obj/item/clothing/under/roguetown/sirwal/plainrandom

/obj/item/clothing/under/roguetown/sirwal/plainrandom/Initialize()
	color = pick("#FFFFFF", "#edc6a5", "#927351", CLOTHING_BLACK)
	..()

/obj/item/clothing/under/roguetown/sirwal/fancy
	color = null
	name = "fancy sirwal"
	desc = "Long, baggy trousers from Zybantine dyed in expensive, exotic colours."

/obj/item/clothing/under/roguetown/sirwal/fancy/red
	color = CLOTHING_RED

/obj/item/clothing/under/roguetown/sirwal/fancy/blue
	color = CLOTHING_BLUE

/obj/item/clothing/under/roguetown/sirwal/fancy/purple
	color = CLOTHING_PURPLE

/obj/item/clothing/under/roguetown/sirwal/fancy/yellow
	color = CLOTHING_YELLOW

/obj/item/clothing/under/roguetown/sirwal/fancy/random

/obj/item/clothing/under/roguetown/sirwal/fancy/random/Initialize()
	color = pick(CLOTHING_BLACK, CLOTHING_BLUE, CLOTHING_PURPLE, CLOTHING_RED, CLOTHING_YELLOW)
	..()

/datum/crafting_recipe/roguetown/sewing/sirwal
	name = "sirwal"
	result = list(/obj/item/clothing/under/roguetown/sirwal)
	reqs = list(/obj/item/natural/cloth = 2)
	craftdiff = 1

/obj/item/clothing/under/roguetown/thong
	name = "thong"
	desc = "Underwear so thin it barely covers ones bits. Barely."
	gender = PLURAL
	icon = 'modular_deserttown/icons/clothing/pants.dmi'
	mob_overlay_icon = 'modular_deserttown/icons/clothing/onmob/pants.dmi'
	icon_state = "thong"
	item_state = "thong"
	body_parts_covered = GROIN

/datum/crafting_recipe/roguetown/sewing/thong
	name = "thong"
	result = list(/obj/item/clothing/under/roguetown/thong)
	reqs = list(/obj/item/natural/cloth = 2)
	craftdiff = 2

//cloak
/obj/item/clothing/cloak/catcloak
	name = "cataphract's cloak"
	desc = "Noble red cloak of a Zybantine Cataphract"
	icon = 'modular_deserttown/icons/clothing/cloaks.dmi'
	mob_overlay_icon = 'modular_deserttown/icons/clothing/onmob/cloaks.dmi'
	icon_state = "catcloak"
	body_parts_covered = CHEST|GROIN|VITALS|ARMS
	sleeved = 'modular_deserttown/icons/clothing/onmob/cloaks.dmi'
	sleevetype = "shirt"
	slot_flags = ITEM_SLOT_CLOAK
	sellprice = 250
	nodismemsleeves = TRUE

/obj/item/clothing/cloak/catcloak/cataphract_rais
    name = "Rais-Cataphract's cloak"
    desc = "Безумно красиво и не менее безумно дорогой плащ, выполненный из лучшего шёлка и окрашенный в пурпурный цвет. Ловцы багрянок - так называют людей добывающих пурпур - трудятся не менее месяца ради одного такого плаща. Носить такое - признак авторитета и богатства."
    icon = 'icons/roguetown/clothing/special/captain.dmi'
    mob_overlay_icon = 'icons/roguetown/clothing/special/onmob/captain.dmi'
    sleeved = 'icons/roguetown/clothing/special/onmob/captain.dmi'
    icon_state = "capcloak"
    detail_tag = "_detail"
    alternate_worn_layer = CLOAK_BEHIND_LAYER
    detail_color = "#8747B1"
    color = "#FFFFFF"
    sellprice = 500

/obj/item/clothing/cloak/catcloak/jancap
	name = "janissary sergeant's cloak"
	desc = "A most handsome cloak, of royal red, denoting the authority of a leader."

/obj/item/clothing/cloak/raincloak/amir
	name = "amir's cloak"
	desc = "A silky red cloak as light as a feather, embroidened with gold patterns. Fit for a prince of Zybantine."
	icon = 'modular_deserttown/icons/clothing/cloaks.dmi'
	mob_overlay_icon = 'modular_deserttown/icons/clothing/onmob/cloaks.dmi'
	icon_state = "dprince"
	item_state = "dprince"
	sleeved = 'modular_deserttown/icons/clothing/onmob/cloaks.dmi'
	sleevetype = "shirt"
	inhand_mod = FALSE
	hoodtype = /obj/item/clothing/head/hooded/rainhood/amirhood
	salvage_result = /obj/item/natural/silk

/obj/item/clothing/head/hooded/rainhood/amirhood
	name = "amir's hood"
	desc = "A silky red hood as light as a feather, embroidened with gold patterns. Fit for a prince of Zybantine."
	icon = 'modular_deserttown/icons/clothing/head.dmi'
	mob_overlay_icon = 'modular_deserttown/icons/clothing/onmob/head.dmi'
	icon_state = "dprince"
	item_state = "dprince"
	block2add = FOV_BEHIND
	flags_inv = HIDEHAIR

/obj/item/clothing/cloak/dunestalker
	name = "dunestalker cloak"
	desc = "A heavy leather cloak held together by a gilded pin, depicting the Grand Sultan's house. The sign of a faithful servant."
	icon = 'modular_deserttown/icons/clothing/shadowcloak.dmi'
	mob_overlay_icon = 'modular_deserttown/icons/clothing/onmob/shadowcloak.dmi'
	icon_state = "shadowcloak"
	sleeved = 'modular_deserttown/icons/clothing/onmob/shadowcloak.dmi'
	sleevetype = "shirt"
	alternate_worn_layer = CLOAK_BEHIND_LAYER
	slot_flags = ITEM_SLOT_BACK_R|ITEM_SLOT_CLOAK
//	body_parts_covered = ARMS|CHEST
	boobed = TRUE
	nodismemsleeves = TRUE
	inhand_mod = TRUE
	hoodtype = null
	toggle_icon_state = FALSE
	allowed_sex = list(MALE, FEMALE)
	flags_inv = null

/obj/item/clothing/cloak/citywatch/janissary
	name = "janissary cape"
	desc = "A light cloak held together by a gilded badge, depicting the Grand Sultan's house. The sign of a faithful servant."
	icon = 'modular_deserttown/icons/clothing/shadowcloak.dmi'
	mob_overlay_icon = 'modular_deserttown/icons/clothing/onmob/shadowcloak.dmi'
	icon_state = "jan"
	item_state = "jan"

//////BELTS

/obj/item/storage/belt/rogue/leather/cloth/sash
	name = "simple zybantine sash"
	desc = "A simple cloth sash."
	color = null
	icon = 'modular_deserttown/icons/clothing/belts.dmi'
	mob_overlay_icon = 'modular_deserttown/icons/clothing/onmob/belts.dmi'
	icon_state = "sashgrey"
	item_state = "sashgrey"

/datum/crafting_recipe/roguetown/sewing/zybsash
	name = "sash (zybantine)"
	result = list(/obj/item/storage/belt/rogue/leather/cloth/sash)
	reqs = list(/obj/item/natural/cloth = 2)
	craftdiff = 2

/obj/item/storage/belt/rogue/leather/cloth/sash/yellow
	color = CLOTHING_YELLOW

/obj/item/storage/belt/rogue/leather/cloth/sash/red
	color = CLOTHING_RED

/obj/item/storage/belt/rogue/leather/cloth/sash/orange
	color = CLOTHING_ORANGE

/obj/item/storage/belt/rogue/leather/cloth/sash/brown
	color = CLOTHING_BROWN

/obj/item/storage/belt/rogue/leather/cloth/sash/purple
	color = CLOTHING_PURPLE

/obj/item/storage/belt/rogue/leather/cloth/sash/random

/obj/item/storage/belt/rogue/leather/cloth/sash/random/Initialize()
	color = pick(CLOTHING_BROWN, CLOTHING_RED, CLOTHING_ORANGE, CLOTHING_YELLOW, CLOTHING_WHITE, CLOTHING_PURPLE)
	..()

/obj/item/storage/belt/rogue/leather/noblesash
	name = "zybantine noble sash"
	icon = 'modular_deserttown/icons/clothing/belts.dmi'
	mob_overlay_icon = 'modular_deserttown/icons/clothing/onmob/belts.dmi'
	icon_state = "noblesash"

/datum/crafting_recipe/roguetown/sewing/zybnoblesash
	name = "sash (zybantine noble)"
	result = list(/obj/item/storage/belt/rogue/leather/noblesash)
	reqs = list(/obj/item/natural/silk = 2)
	craftdiff = 4

/obj/item/storage/belt/rogue/leather/sultbelt
	name = "zybantine sultan sash"
	icon = 'modular_deserttown/icons/clothing/belts.dmi'
	mob_overlay_icon = 'modular_deserttown/icons/clothing/onmob/belts.dmi'
	icon_state = "sultbelt"
	sellprice = 30

/obj/item/storage/belt/rogue/leather/jafar
	name = "zybantine magos sash"
	icon = 'modular_deserttown/icons/clothing/belts.dmi'
	mob_overlay_icon = 'modular_deserttown/icons/clothing/onmob/belts.dmi'
	icon_state = "jafar"
	sellprice = 30

/obj/item/storage/belt/rogue/leather/exoticsilkbelt/skirtgreen
	name = "green exotic silk skirt"
	desc = "A gold adorned belt with the softest of silk skirts barely concealing one's bits."
	icon = 'modular_deserttown/icons/clothing/belts.dmi'
	mob_overlay_icon = 'modular_deserttown/icons/clothing/onmob/belts.dmi'
	icon_state = "exoticsilkskirt2"
	item_state = "exoticsilkskirt2"

/datum/crafting_recipe/roguetown/sewing/skirtgreen
	name = "exotic silk belt (green)"
	result = list(/obj/item/storage/belt/rogue/leather/exoticsilkbelt/skirtgreen)
	reqs = list(/obj/item/natural/silk = 2)
	craftdiff = 4

/obj/item/storage/belt/rogue/leather/exoticsilkbelt/skirtred
	name = "red exotic silk skirt"
	desc = "A gold adorned belt with the softest of silk skirts barely concealing one's bits."
	icon = 'modular_deserttown/icons/clothing/belts.dmi'
	mob_overlay_icon = 'modular_deserttown/icons/clothing/onmob/belts.dmi'
	icon_state = "exoticsilkskirt"
	item_state = "exoticsilkskirt"

/datum/crafting_recipe/roguetown/sewing/skirtred
	name = "exotic silk belt (red)"
	result = list(/obj/item/storage/belt/rogue/leather/exoticsilkbelt/skirtred)
	reqs = list(/obj/item/natural/silk = 2)
	craftdiff = 4

////////

/obj/item/clothing/suit/roguetown/shirt/exoticsilkbra/green
	name = "exotic silk bra(green)"
	icon = 'modular_deserttown/icons/clothing/shirts.dmi'
	mob_overlay_icon = 'modular_deserttown/icons/clothing/onmob/shirts.dmi'
	icon_state = "exoticsilkbrag"
	item_state = "exoticsilkbrag"

/datum/crafting_recipe/roguetown/sewing/bragreen
	name = "exotic silk bra(green)"
	result = list(/obj/item/clothing/suit/roguetown/shirt/exoticsilkbra/green)
	reqs = list(
		/obj/item/natural/silk = 2,
		/obj/item/natural/cloth = 2
	)
	craftdiff = 4

/obj/item/clothing/suit/roguetown/shirt/exoticsilkbra/red
	name = "exotic silk bra (red)"
	desc = "Fanciful gold laced silks barely able to conceal what little it covers. Long, flowing sleeves droop from the upper arms to a ring on each hand, fluttering in the wind and with every movement."
	icon = 'modular_deserttown/icons/clothing/shirts.dmi'
	mob_overlay_icon = 'modular_deserttown/icons/clothing/onmob/shirts.dmi'
	icon_state = "exoticsilkbrar"
	item_state = "exoticsilkbrar"

/datum/crafting_recipe/roguetown/sewing/brared
	name = "exotic silk bra (red)"
	result = list(/obj/item/clothing/suit/roguetown/shirt/exoticsilkbra/red)
	reqs = list(
		/obj/item/natural/silk = 2,
		/obj/item/natural/cloth = 2
	)
	craftdiff = 4

/obj/item/clothing/mask/rogue/exoticsilkmask/green
	name = "exotic silk mask (green)"
	icon = 'modular_deserttown/icons/clothing/masks.dmi'
	mob_overlay_icon = 'modular_deserttown/icons/clothing/onmob/masks.dmi'
	icon_state = "exoticsilkmaskg"
	item_state = "exoticsilkmaskg"

/datum/crafting_recipe/roguetown/sewing/maskgreen
	name = "exotic silk mask (green)"
	result = list(/obj/item/clothing/mask/rogue/exoticsilkmask/green)
	reqs = list(
		/obj/item/natural/silk = 2,
		/obj/item/natural/cloth = 1
	)
	craftdiff = 4

/obj/item/clothing/mask/rogue/exoticsilkmask/red
	name = "exotic silk mask (red)"
	icon = 'modular_deserttown/icons/clothing/masks.dmi'
	mob_overlay_icon = 'modular_deserttown/icons/clothing/onmob/masks.dmi'
	icon_state = "exoticsilkmaskr"
	item_state = "exoticsilkmaskr"

/datum/crafting_recipe/roguetown/sewing/maskred
	name = "exotic silk mask (red)"
	result = list(/obj/item/clothing/mask/rogue/exoticsilkmask/red)
	reqs = list(
		/obj/item/natural/silk = 2,
		/obj/item/natural/cloth = 1
	)
	craftdiff = 4

//Because some people can't live without BiS
/obj/item/clothing/shoes/roguetown/shalal/reinforced
	name = "fine babouche"
	desc = "Sturdy boots stitched together from cured leather. Stylish, firm, and sport a satisfying 'squeek' with each step."
	icon_state = "shalal"//change when I get around to it
	item_state = "shalal"
	color = "#d4c7bf"
	armor = ARMOR_LEATHER
	max_integrity = 200			//Half that of iron boots


/obj/item/clothing/shoes/roguetown/boots/armor/shalal
	name = "plated babouche"
	desc = "Sturdy boots stitched together from cured leather. Stylish, firm, and sport a satisfying 'squeek' with each step."
	icon_state = "shalal"//change when I get around to it
	item_state = "shalal"

/obj/item/clothing/suit/roguetown/armor/gambeson/zyb
	name = "desert coat"
	desc = "A slim-fitting sherwani, a Zybantine-styled coat meant to endure in the desert's climate."
	icon_state = "sherwani"
	color = "#7c6d5c"

/datum/crafting_recipe/roguetown/sewing/desertcoat
	name = "desert coat"
	category = "Gambesons"
	display_category = ITEM_CAT_ARMOR_LIGHT
	result = /obj/item/clothing/suit/roguetown/armor/gambeson/zyb
	reqs = list(/obj/item/natural/cloth = 4,
				/obj/item/natural/fibers = 1)
	tools = list(/obj/item/needle)
	craftdiff = 3
