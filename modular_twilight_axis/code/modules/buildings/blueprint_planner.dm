GLOBAL_LIST_INIT(blueprint_buildable_types, list(
	"wood_floor" = list(
		"name" = "Деревянный пол",
		"category" = "Полы и Дорожки",
		"layer_type" = "floor",
		"build_order" = 1,
		"path" = /turf/open/floor/rogue/ruinedwood,
		"reqs" = /datum/crafting_recipe/roguetown/turfs/wood/floor,
		"icon_file" = 'icons/turf/roguefloor.dmi',
		"icon_state" = "wooden_floor"
	),
	"wood_floor_polished" = list(
		"name" = "Полированный пол",
		"category" = "Полы и Дорожки",
		"layer_type" = "floor",
		"build_order" = 1,
		"path" = /turf/open/floor/rogue/wood,
		"reqs" = /datum/crafting_recipe/roguetown/turfs/wood/floor,
		"icon_file" = 'icons/turf/roguefloor.dmi',
		"icon_state" = "wooden_floor2"
	),
	"floor_herringbone_light" = list(
		"name" = "Паркет (Светлая ёлочка)",
		"category" = "Полы и Дорожки",
		"layer_type" = "floor",
		"build_order" = 1,
		"path" = /turf/open/floor/rogue/ruinedwood/herringbone_clear,
		"reqs" = /datum/crafting_recipe/roguetown/turfs/wood/floorhl,
		"icon_file" = 'icons/turf/roguefloor.dmi',
		"icon_state" = "herringbonewood2"
	),
	"floor_herringbone_weathered" = list(
		"name" = "Паркет (Состаренная ёлочка)",
		"category" = "Полы и Дорожки",
		"layer_type" = "floor",
		"build_order" = 1,
		"path" = /turf/open/floor/rogue/ruinedwood/herringbone,
		"reqs" = /datum/crafting_recipe/roguetown/turfs/wood/floorhw,
		"icon_file" = 'icons/turf/roguefloor.dmi',
		"icon_state" = "herringbonewood"
	),
	"floor_herringbone_stamped" = list(
		"name" = "Паркет (Тисненый)",
		"category" = "Полы и Дорожки",
		"layer_type" = "floor",
		"build_order" = 1,
		"path" = /turf/open/floor/rogue/ruinedwood/chevron,
		"reqs" = /datum/crafting_recipe/roguetown/turfs/wood/floorhs,
		"icon_file" = 'icons/turf/roguefloor.dmi',
		"icon_state" = "weird2"
	),
	"floor_slanted" = list(
		"name" = "Паркет (Диагональный)",
		"category" = "Полы и Дорожки",
		"layer_type" = "floor",
		"build_order" = 1,
		"path" = /turf/open/floor/rogue/ruinedwood/spiral,
		"reqs" = /datum/crafting_recipe/roguetown/turfs/wood/floorslanted,
		"icon_file" = 'icons/turf/roguefloor.dmi',
		"icon_state" = "weird1"
	),
	"platform_wood" = list(
		"name" = "Деревянная платформа",
		"category" = "Полы и Дорожки",
		"layer_type" = "floor",
		"build_order" = 1,
		"path" = /turf/open/floor/rogue/ruinedwood/platform,
		"reqs" = /datum/crafting_recipe/roguetown/turfs/wood/platform,
		"icon_file" = 'icons/turf/roguefloor.dmi',
		"icon_state" = "wooden_floor"
	),
	"floor_hay" = list(
		"name" = "Соломенный настил",
		"category" = "Полы и Дорожки",
		"layer_type" = "floor",
		"build_order" = 1,
		"path" = /turf/open/floor/rogue/hay,
		"reqs" = /datum/crafting_recipe/roguetown/turfs/hay,
		"icon_file" = 'icons/turf/roguefloor.dmi',
		"icon_state" = "hay"
	),
	"floor_twig" = list(
		"name" = "Настил из хвороста",
		"category" = "Полы и Дорожки",
		"layer_type" = "floor",
		"build_order" = 1,
		"path" = /turf/open/floor/rogue/twig,
		"reqs" = /datum/crafting_recipe/roguetown/turfs/twig,
		"icon_file" = 'icons/turf/roguefloor.dmi',
		"icon_state" = "twig"
	),
	"stone_floor" = list(
		"name" = "Каменный пол (Плиты)",
		"category" = "Полы и Дорожки",
		"layer_type" = "floor",
		"build_order" = 1,
		"path" = /turf/open/floor/rogue/blocks,
		"reqs" = /datum/crafting_recipe/roguetown/turfs/stone/block,
		"icon_file" = 'icons/turf/roguefloor.dmi',
		"icon_state" = "blocks"
	),
	"stone_hex_floor" = list(
		"name" = "Шестиугольная плитка",
		"category" = "Полы и Дорожки",
		"layer_type" = "floor",
		"build_order" = 1,
		"path" = /turf/open/floor/rogue/hexstone,
		"reqs" = /datum/crafting_recipe/roguetown/turfs/stone/hexstone,
		"icon_file" = 'icons/turf/roguefloor.dmi',
		"icon_state" = "hexstone"
	),
	"stone_herringbone_floor" = list(
		"name" = "Каменная ёлочка",
		"category" = "Полы и Дорожки",
		"layer_type" = "floor",
		"build_order" = 1,
		"path" = /turf/open/floor/rogue/herringbone,
		"reqs" = /datum/crafting_recipe/roguetown/turfs/stone/herringbone,
		"icon_file" = 'icons/turf/roguefloor.dmi',
		"icon_state" = "herringbone"
	),
	"cobblestone_floor" = list(
		"name" = "Булыжная мостовая",
		"category" = "Полы и Дорожки",
		"layer_type" = "floor",
		"build_order" = 1,
		"path" = /turf/open/floor/rogue/cobble,
		"reqs" = /datum/crafting_recipe/roguetown/turfs/stone/cobble,
		"icon_file" = 'icons/turf/roguefloor.dmi',
		"icon_state" = "cobblestone1"
	),
	"cobblerock_road" = list(
		"name" = "Каменистая дорога",
		"category" = "Полы и Дорожки",
		"layer_type" = "floor",
		"build_order" = 1,
		"path" = /turf/open/floor/rogue/cobblerock,
		"reqs" = /datum/crafting_recipe/roguetown/turfs/stone/cobblerock,
		"icon_file" = 'icons/turf/roguefloor.dmi',
		"icon_state" = "cobblerock"
	),
	"redstone_floor" = list(
		"name" = "Терракотовая плитка (Крупная)",
		"category" = "Полы и Дорожки",
		"layer_type" = "floor",
		"build_order" = 1,
		"path" = /turf/open/floor/rogue/blocks/stonered,
		"reqs" = /datum/crafting_recipe/roguetown/turfs/stone/redstone,
		"icon_file" = 'icons/turf/roguefloor.dmi',
		"icon_state" = "stoneredlarge"
	),
	"tiny_redstone_floor" = list(
		"name" = "Терракотовая плитка (Мелкая)",
		"category" = "Полы и Дорожки",
		"layer_type" = "floor",
		"build_order" = 1,
		"path" = /turf/open/floor/rogue/blocks/stonered/tiny,
		"reqs" = /datum/crafting_recipe/roguetown/turfs/stone/tinyredstone,
		"icon_file" = 'icons/turf/roguefloor.dmi',
		"icon_state" = "stoneredtiny"
	),
	"floor_brick" = list(
		"name" = "Кирпичный пол",
		"category" = "Полы и Дорожки",
		"layer_type" = "floor",
		"build_order" = 1,
		"path" = /turf/open/floor/rogue/tile/brick,
		"reqs" = /datum/crafting_recipe/roguetown/turfs/brick/floor,
		"icon_file" = 'icons/turf/roguefloor.dmi',
		"icon_state" = "bricktile"
	),
	"carpet_inn" = list(
		"name" = "Ковер (Трактирный)",
		"category" = "Полы и Дорожки",
		"layer_type" = "floor",
		"build_order" = 1,
		"path" = /turf/open/floor/carpet/inn,
		"reqs" = /datum/crafting_recipe/roguetown/turfs/carpet,
		"icon_file" = 'icons/turf/roguefloor.dmi',
		"icon_state" = "carpet"
	),
	"carpet_purple" = list(
		"name" = "Ковер (Пурпурный)",
		"category" = "Полы и Дорожки",
		"layer_type" = "floor",
		"build_order" = 1,
		"path" = /turf/open/floor/carpet/purple,
		"reqs" = /datum/crafting_recipe/roguetown/turfs/carpet/purple,
		"icon_file" = 'icons/turf/floors/carpet_purple.dmi',
		"icon_state" = "carpet"
	),
	"carpet_red" = list(
		"name" = "Ковер (Красный)",
		"category" = "Полы и Дорожки",
		"layer_type" = "floor",
		"build_order" = 1,
		"path" = /turf/open/floor/carpet/red,
		"reqs" = /datum/crafting_recipe/roguetown/turfs/carpet/red,
		"icon_file" = 'icons/turf/floors/carpet_red.dmi',
		"icon_state" = "carpet"
	),
	"carpet_royal" = list(
		"name" = "Ковер (Королевский черный)",
		"category" = "Полы и Дорожки",
		"layer_type" = "floor",
		"build_order" = 1,
		"path" = /turf/open/floor/carpet/royalblack,
		"reqs" = /datum/crafting_recipe/roguetown/turfs/carpet/royalblack,
		"icon_file" = 'icons/turf/floors/carpet_royalblack.dmi',
		"icon_state" = "carpet"
	),
	"carpet_stellar" = list(
		"name" = "Ковер (Звездный)",
		"category" = "Полы и Дорожки",
		"layer_type" = "floor",
		"build_order" = 1,
		"path" = /turf/open/floor/carpet/stellar,
		"reqs" = /datum/crafting_recipe/roguetown/turfs/carpet/stellar,
		"icon_file" = 'icons/turf/floors/carpet_stellar.dmi',
		"icon_state" = "carpet"
	),
	"bear_rug" = list(
		"name" = "Шкура медведя",
		"category" = "Полы и Дорожки",
		"layer_type" = "floor",
		"build_order" = 1,
		"path" = /obj/structure/bearpelt,
		"reqs" = /datum/crafting_recipe/roguetown/structure/bearrug,
		"icon_file" = 'icons/turf/floors/bear.dmi',
		"icon_state" = "bear"
	),
	"fox_rug" = list(
		"name" = "Шкура лисы",
		"category" = "Полы и Дорожки",
		"layer_type" = "floor",
		"build_order" = 1,
		"path" = /obj/structure/foxpelt,
		"reqs" = /datum/crafting_recipe/roguetown/structure/foxrug,
		"icon_file" = 'icons/turf/floors/animal_rugs.dmi',
		"icon_state" = "fox"
	),
	"lynx_rug" = list(
		"name" = "Шкура рыси",
		"category" = "Полы и Дорожки",
		"layer_type" = "floor",
		"build_order" = 1,
		"path" = /obj/structure/bobcatpelt,
		"reqs" = /datum/crafting_recipe/roguetown/structure/bobcatrug,
		"icon_file" = 'icons/turf/floors/animal_rugs.dmi',
		"icon_state" = "bobcat"
	),


	"wood_wall" = list(
		"name" = "Деревянная стена",
		"category" = "Стены и Крыша",
		"layer_type" = "wall",
		"build_order" = 2,
		"path" = /turf/closed/wall/mineral/rogue/wood,
		"reqs" = /datum/crafting_recipe/roguetown/turfs/wood/wall,
		"icon_file" = 'icons/turf/walls/roguewood.dmi',
		"icon_state" = "wood"
	),
	"wood_wall_fancy" = list(
		"name" = "Резная деревянная стена",
		"category" = "Стены и Крыша",
		"layer_type" = "wall",
		"build_order" = 2,
		"path" = /turf/closed/wall/mineral/rogue/decowood,
		"reqs" = /datum/crafting_recipe/roguetown/turfs/wood/fancy,
		"icon_file" = 'icons/turf/roguewall.dmi',
		"icon_state" = "decowood"
	),
	"tent_wall" = list(
		"name" = "Палаточная стена",
		"category" = "Стены и Крыша",
		"layer_type" = "wall",
		"build_order" = 2,
		"path" = /turf/closed/wall/mineral/rogue/tent,
		"reqs" = /datum/crafting_recipe/roguetown/turfs/tentwall,
		"icon_file" = 'icons/turf/roguewall.dmi',
		"icon_state" = "tent"
	),
	"stone_wall" = list(
		"name" = "Каменная стена",
		"category" = "Стены и Крыша",
		"layer_type" = "wall",
		"build_order" = 2,
		"path" = /turf/closed/wall/mineral/rogue/stone,
		"reqs" = /datum/crafting_recipe/roguetown/turfs/stone/wall,
		"icon_file" = 'icons/turf/walls/stone_wall.dmi',
		"icon_state" = "stone"
	),
	"stone_wall_brick" = list(
		"name" = "Стена из каменного кирпича",
		"category" = "Стены и Крыша",
		"layer_type" = "wall",
		"build_order" = 2,
		"path" = /turf/closed/wall/mineral/rogue/stonebrick,
		"reqs" = /datum/crafting_recipe/roguetown/turfs/stone/brick,
		"icon_file" = 'icons/turf/walls/stonebrick.dmi',
		"icon_state" = "stonebrick"
	),
	"stone_wall_craft" = list(
		"name" = "Стена из тесаного камня",
		"category" = "Стены и Крыша",
		"layer_type" = "wall",
		"build_order" = 2,
		"path" = /turf/closed/wall/mineral/rogue/craftstone,
		"reqs" = /datum/crafting_recipe/roguetown/turfs/stone/craft,
		"icon_file" = 'icons/turf/walls/craftstone.dmi',
		"icon_state" = "box"
	),
	"stone_wall_deco" = list(
		"name" = "Декорированная каменная стена",
		"category" = "Стены и Крыша",
		"layer_type" = "wall",
		"build_order" = 2,
		"path" = /turf/closed/wall/mineral/rogue/decostone,
		"reqs" = /datum/crafting_recipe/roguetown/turfs/stone/decorated,
		"icon_file" = 'icons/turf/roguewall.dmi',
		"icon_state" = "decostone-b"
	),
	"brick_wall" = list(
		"name" = "Кирпичная стена",
		"category" = "Стены и Крыша",
		"layer_type" = "wall",
		"build_order" = 2,
		"path" = /turf/closed/wall/mineral/rogue/brick,
		"reqs" = /datum/crafting_recipe/roguetown/turfs/brick/wall,
		"icon_file" = 'icons/turf/walls/brick_wall.dmi',
		"icon_state" = "brick"
	),
	"roof_wood" = list(
		"name" = "Деревянная крыша",
		"category" = "Стены и Крыша",
		"layer_type" = "wall",
		"build_order" = 4,
		"path" = /turf/open/floor/rogue/rooftop,
		"reqs" = list(/obj/item/natural/wood/plank = 1),
		"icon_file" = 'icons/turf/roguefloor.dmi',
		"icon_state" = "roof"
	),


	"wood_window_murderhole" = list(
		"name" = "Деревянная бойница",
		"category" = "Окна и Витражи",
		"layer_type" = "wall",
		"build_order" = 2,
		"path" = /turf/closed/wall/mineral/rogue/wood/window,
		"reqs" = /datum/crafting_recipe/roguetown/turfs/wood/murderhole,
		"icon_file" = 'icons/turf/walls/roguewood.dmi',
		"icon_state" = "woodwindow"
	),
	"stone_window_murderhole" = list(
		"name" = "Каменная бойница",
		"category" = "Окна и Витражи",
		"layer_type" = "wall",
		"build_order" = 2,
		"path" = /turf/closed/wall/mineral/rogue/stone/window,
		"reqs" = /datum/crafting_recipe/roguetown/turfs/stone/window,
		"icon_file" = 'icons/turf/walls/stone_wall.dmi',
		"icon_state" = "stonewindow"
	),
	"brick_window_murderhole" = list(
		"name" = "Кирпичная бойница",
		"category" = "Окна и Витражи",
		"layer_type" = "wall",
		"build_order" = 2,
		"path" = /turf/closed/wall/mineral/rogue/brick/window,
		"reqs" = /datum/crafting_recipe/roguetown/turfs/brick/window,
		"icon_file" = 'icons/turf/walls/brick_wall.dmi',
		"icon_state" = "brickwindow"
	),
	"window_glass_static" = list(
		"name" = "Окно со стеклом (Глухое)",
		"category" = "Окна и Витражи",
		"layer_type" = "obj",
		"build_order" = 2,
		"path" = /obj/structure/roguewindow,
		"reqs" = /datum/crafting_recipe/roguetown/turfs/roguewindow,
		"icon_file" = 'icons/roguetown/misc/roguewindow.dmi',
		"icon_state" = "window-solid"
	),
	"window_glass_openable" = list(
		"name" = "Открывающееся окно",
		"category" = "Окна и Витражи",
		"layer_type" = "obj",
		"build_order" = 2,
		"path" = /obj/structure/roguewindow/openclose,
		"reqs" = /datum/crafting_recipe/roguetown/turfs/roguewindow/dynamic,
		"icon_file" = 'icons/roguetown/misc/roguewindow.dmi',
		"icon_state" = "woodwindowdir"
	),
	"window_glass_reinforced" = list(
		"name" = "Усиленное решеткой окно",
		"category" = "Окна и Витражи",
		"layer_type" = "obj",
		"build_order" = 2,
		"path" = /obj/structure/roguewindow/openclose/reinforced,
		"reqs" = /datum/crafting_recipe/roguetown/turfs/roguewindow/reinforced,
		"icon_file" = 'icons/roguetown/misc/roguewindow.dmi',
		"icon_state" = "reinforcedwindowdir"
	),
	"window_stained_psydon" = list(
		"name" = "Витраж Псидонии (Серебро)",
		"category" = "Окна и Витражи",
		"layer_type" = "obj",
		"build_order" = 2,
		"path" = /obj/structure/roguewindow/stained/silver,
		"reqs" = /datum/crafting_recipe/roguetown/turfs/roguewindow/stone_psydon,
		"icon_file" = 'icons/roguetown/misc/roguewindow.dmi',
		"icon_state" = "stained-silver"
	),
	"window_stained_astrata" = list(
		"name" = "Витраж Астраты (Золото)",
		"category" = "Окна и Витражи",
		"layer_type" = "obj",
		"build_order" = 2,
		"path" = /obj/structure/roguewindow/stained/yellow,
		"reqs" = /datum/crafting_recipe/roguetown/turfs/roguewindow/stone_astrata,
		"icon_file" = 'icons/roguetown/misc/roguewindow.dmi',
		"icon_state" = "stained-yellow"
	),
	"window_stained_zizo" = list(
		"name" = "Витраж Зизо",
		"category" = "Окна и Витражи",
		"layer_type" = "obj",
		"build_order" = 2,
		"path" = /obj/structure/roguewindow/stained/zizo,
		"reqs" = /datum/crafting_recipe/roguetown/turfs/roguewindow/stone_zizo,
		"icon_file" = 'icons/roguetown/misc/roguewindow.dmi',
		"icon_state" = "stained-zizo"
	),

	"stairs_wood" = list(
		"name" = "Деревянная лестница (Вверх)",
		"category" = "Двери и Лестницы",
		"layer_type" = "obj",
		"build_order" = 2,
		"path" = /obj/structure/stairs,
		"reqs" = list(/obj/item/grown/log/tree/small = 2),
		"icon_file" = 'icons/obj/stairs.dmi',
		"icon_state" = "stairs"
	),
	"stairs_wood_down" = list(
		"name" = "Деревянная лестница (Вниз)",
		"category" = "Двери и Лестницы",
		"layer_type" = "obj",
		"build_order" = 2,
		"path" = /obj/structure/stairs/d,
		"reqs" = /datum/crafting_recipe/roguetown/structure/stairsd,
		"icon_file" = 'icons/obj/stairs.dmi',
		"icon_state" = "stairs"
	),
	"stairs_stone" = list(
		"name" = "Каменная лестница (Вверх)",
		"category" = "Двери и Лестницы",
		"layer_type" = "obj",
		"build_order" = 2,
		"path" = /obj/structure/stairs/stone,
		"reqs" = list(/obj/item/natural/stone = 2),
		"icon_file" = 'icons/obj/stairs.dmi',
		"icon_state" = "stonestairs"
	),
	"stairs_stone_down" = list(
		"name" = "Каменная лестница (Вниз)",
		"category" = "Двери и Лестницы",
		"layer_type" = "obj",
		"build_order" = 2,
		"path" = /obj/structure/stairs/stone/d,
		"reqs" = /datum/crafting_recipe/roguetown/structure/stonestairsd,
		"icon_file" = 'icons/obj/stairs.dmi',
		"icon_state" = "stonestairs"
	),
	"ladder" = list(
		"name" = "Лестница",
		"category" = "Двери и Лестницы",
		"layer_type" = "obj",
		"build_order" = 2,
		"path" = /obj/structure/ladder,
		"reqs" = list(/obj/item/grown/log/tree/small = 2),
		"icon_file" = 'icons/roguetown/misc/structure.dmi',
		"icon_state" = "ladder11"
	),
	"door_wood" = list(
		"name" = "Деревянная дверь",
		"category" = "Двери и Лестницы",
		"layer_type" = "obj",
		"build_order" = 2,
		"path" = /obj/structure/mineral_door/wood,
		"reqs" = /datum/crafting_recipe/roguetown/structure/door,
		"icon_file" = 'icons/roguetown/misc/doors.dmi',
		"icon_state" = "woodhandle"
	),
	"door_wood_deadbolt" = list(
		"name" = "Дверь с задвижкой",
		"category" = "Двери и Лестницы",
		"layer_type" = "obj",
		"build_order" = 2,
		"path" = /obj/structure/mineral_door/wood/deadbolt,
		"reqs" = /datum/crafting_recipe/roguetown/structure/doorbolt,
		"icon_file" = 'icons/roguetown/misc/doors.dmi',
		"icon_state" = "wooddir"
	),
	"door_wood_fancy" = list(
		"name" = "Резная дверь",
		"category" = "Двери и Лестницы",
		"layer_type" = "obj",
		"build_order" = 2,
		"path" = /obj/structure/mineral_door/wood/fancywood,
		"reqs" = /datum/crafting_recipe/roguetown/structure/fancydoor,
		"icon_file" = 'icons/roguetown/misc/doors.dmi',
		"icon_state" = "fancy_wood"
	),
	"door_swing" = list(
		"name" = "Распашная дверь (Бар)",
		"category" = "Двери и Лестницы",
		"layer_type" = "obj",
		"build_order" = 2,
		"path" = /obj/structure/mineral_door/swing_door,
		"reqs" = /datum/crafting_recipe/roguetown/structure/swing_door,
		"icon_file" = 'icons/roguetown/misc/doors.dmi',
		"icon_state" = "woodhandle"
	),
	"door_stone" = list(
		"name" = "Каменная дверь",
		"category" = "Двери и Лестницы",
		"layer_type" = "obj",
		"build_order" = 2,
		"path" = /obj/structure/mineral_door/wood/donjon/stone,
		"reqs" = /datum/crafting_recipe/roguetown/structure/stonedoor,
		"icon_file" = 'icons/roguetown/misc/doors.dmi',
		"icon_state" = "stone"
	),
	"tent_door" = list(
		"name" = "Тканевый проход (Палатка)",
		"category" = "Двери и Лестницы",
		"layer_type" = "obj",
		"build_order" = 2,
		"path" = /obj/structure/roguetent,
		"reqs" = /datum/crafting_recipe/roguetown/turfs/tentdoor,
		"icon_file" = 'icons/turf/roguewall.dmi',
		"icon_state" = "tent_door1"
	),
	"fence_palisade" = list(
		"name" = "Частокол / Забор",
		"category" = "Двери и Лестницы",
		"layer_type" = "border",
		"build_order" = 3,
		"path" = /obj/structure/fluff/railing/fence,
		"reqs" = /datum/crafting_recipe/roguetown/structure/fence,
		"icon_file" = 'icons/roguetown/misc/structure.dmi',
		"icon_state" = "fence"
	),
	"railing_wood" = list(
		"name" = "Деревянные перила",
		"category" = "Двери и Лестницы",
		"layer_type" = "border",
		"build_order" = 3,
		"path" = /obj/structure/fluff/railing/wood,
		"reqs" = /datum/crafting_recipe/roguetown/structure/railing,
		"icon_file" = 'icons/obj/railing.dmi',
		"icon_state" = "woodrailing"
	),
	"border_wood" = list(
		"name" = "Деревянный бордюр",
		"category" = "Двери и Лестницы",
		"layer_type" = "border",
		"build_order" = 3,
		"path" = /obj/structure/fluff/railing/border,
		"reqs" = /datum/crafting_recipe/roguetown/structure/border,
		"icon_file" = 'icons/obj/railing.dmi',
		"icon_state" = "border"
	),
	"wall_ladder" = list(
		"name" = "Настенная лестница",
		"category" = "Двери и Лестницы",
		"layer_type" = "obj",
		"build_order" = 3,
		"path" = /obj/structure/wallladder,
		"reqs" = /datum/crafting_recipe/roguetown/structure/wallladder,
		"icon_file" = 'icons/roguetown/misc/structure.dmi',
		"icon_state" = "ladderwall"
	),


	"table_wood" = list(
		"name" = "Деревянный стол",
		"category" = "Мебель",
		"layer_type" = "obj",
		"build_order" = 3,
		"path" = /obj/structure/table/wood/crafted,
		"reqs" = /datum/crafting_recipe/roguetown/structure/table,
		"icon_file" = 'icons/roguetown/misc/tables.dmi',
		"icon_state" = "tablewood1"
	),
	"table_long" = list(
		"name" = "Длинный стол",
		"category" = "Мебель",
		"layer_type" = "obj",
		"build_order" = 3,
		"path" = /obj/structure/table/wood/long_table,
		"reqs" = /datum/crafting_recipe/roguetown/structure/longtable,
		"icon_file" = 'icons/roguetown/misc/tables.dmi',
		"icon_state" = "longtable"
	),
	"table_large" = list(
		"name" = "Большой стол",
		"category" = "Мебель",
		"layer_type" = "obj",
		"build_order" = 3,
		"path" = /obj/structure/table/wood/large_table,
		"reqs" = /datum/crafting_recipe/roguetown/structure/largetable,
		"icon_file" = 'icons/roguetown/misc/tables.dmi',
		"icon_state" = "largetable"
	),
	"table_stone" = list(
		"name" = "Каменный стол",
		"category" = "Мебель",
		"layer_type" = "obj",
		"build_order" = 3,
		"path" = /obj/structure/table/church,
		"reqs" = /datum/crafting_recipe/roguetown/structure/stonetable,
		"icon_file" = 'icons/roguetown/misc/tables.dmi',
		"icon_state" = "churchtable"
	),
	"table_finestone" = list(
		"name" = "Полированный каменный стол",
		"category" = "Мебель",
		"layer_type" = "obj",
		"build_order" = 3,
		"path" = /obj/structure/table/finestone,
		"reqs" = /datum/crafting_recipe/roguetown/structure/finestonetable,
		"icon_file" = 'icons/roguetown/misc/tables.dmi',
		"icon_state" = "stonetable_small"
	),
	"table_operating" = list(
		"name" = "Хирургический стол",
		"category" = "Мебель",
		"layer_type" = "obj",
		"build_order" = 3,
		"path" = /obj/structure/table/optable,
		"reqs" = /datum/crafting_recipe/roguetown/structure/operatingtable,
		"icon_file" = 'icons/obj/surgery.dmi',
		"icon_state" = "optable"
	),
	"chair_wood" = list(
		"name" = "Деревянный стул",
		"category" = "Мебель",
		"layer_type" = "obj",
		"build_order" = 3,
		"path" = /obj/item/chair/rogue/crafted,
		"reqs" = /datum/crafting_recipe/roguetown/structure/chair,
		"icon_file" = 'icons/roguetown/misc/structure.dmi',
		"icon_state" = "chair2"
	),
	"chair_fancy" = list(
		"name" = "Богатый мягкий стул",
		"category" = "Мебель",
		"layer_type" = "obj",
		"build_order" = 3,
		"path" = /obj/item/chair/rogue/fancy/crafted,
		"reqs" = /datum/crafting_recipe/roguetown/structure/fancychair,
		"icon_file" = 'icons/roguetown/misc/structure.dmi',
		"icon_state" = "chair1"
	),
	"stool_wood" = list(
		"name" = "Барный табурет",
		"category" = "Мебель",
		"layer_type" = "obj",
		"build_order" = 3,
		"path" = /obj/item/chair/stool/bar/rogue/crafted,
		"reqs" = /datum/crafting_recipe/roguetown/structure/stool,
		"icon_file" = 'icons/roguetown/misc/structure.dmi',
		"icon_state" = "barstool"
	),
	"throne_small" = list(
		"name" = "Малый трон",
		"category" = "Мебель",
		"layer_type" = "obj",
		"build_order" = 3,
		"path" = /obj/structure/chair/wood/rogue/throne,
		"reqs" = /datum/crafting_recipe/roguetown/structure/chairthrone,
		"icon_file" = 'icons/roguetown/misc/structure.dmi',
		"icon_state" = "thronechair"
	),
	"bench_park" = list(
		"name" = "Парковая скамья",
		"category" = "Мебель",
		"layer_type" = "obj",
		"build_order" = 3,
		"path" = /obj/structure/chair/hotspring_bench,
		"reqs" = /datum/crafting_recipe/roguetown/structure/parkbenchmiddle,
		"icon_file" = 'icons/roguetown/misc/structure.dmi',
		"icon_state" = "bench"
	),
	"couch_red" = list(
		"name" = "Красный диван",
		"category" = "Мебель",
		"layer_type" = "obj",
		"build_order" = 3,
		"path" = /obj/structure/chair/bench/couch,
		"reqs" = /datum/crafting_recipe/roguetown/structure/couchleft,
		"icon_file" = 'icons/roguetown/misc/structure.dmi',
		"icon_state" = "redcouch"
	),
	"couch_black" = list(
		"name" = "Черный диван",
		"category" = "Мебель",
		"layer_type" = "obj",
		"build_order" = 3,
		"path" = /obj/structure/chair/bench/couchablack,
		"reqs" = /datum/crafting_recipe/roguetown/structure/blackcouchleft,
		"icon_file" = 'icons/roguetown/misc/structure.dmi',
		"icon_state" = "couchablackaleft"
	),
	"bed_straw" = list(
		"name" = "Соломенная кровать",
		"category" = "Мебель",
		"layer_type" = "obj",
		"build_order" = 3,
		"path" = /obj/structure/bed/rogue/shit,
		"reqs" = /datum/crafting_recipe/roguetown/structure/strawbed,
		"icon_file" = 'icons/roguetown/misc/beds.dmi',
		"icon_state" = "shitbed"
	),
	"bed_inn" = list(
		"name" = "Мягкая кровать",
		"category" = "Мебель",
		"layer_type" = "obj",
		"build_order" = 3,
		"path" = /obj/structure/bed/rogue/inn,
		"reqs" = /datum/crafting_recipe/roguetown/structure/bed,
		"icon_file" = 'icons/roguetown/misc/beds.dmi',
		"icon_state" = "inn_bed"
	),
	"bed_wool" = list(
		"name" = "Шерстяная кровать",
		"category" = "Мебель",
		"layer_type" = "obj",
		"build_order" = 3,
		"path" = /obj/structure/bed/rogue/inn/wool,
		"reqs" = /datum/crafting_recipe/roguetown/structure/woolbed,
		"icon_file" = 'icons/roguetown/misc/beds.dmi',
		"icon_state" = "woolbed"
	),
	"bed_double" = list(
		"name" = "Двуспальная кровать",
		"category" = "Мебель",
		"layer_type" = "obj",
		"build_order" = 3,
		"path" = /obj/structure/bed/rogue/inn/double,
		"reqs" = /datum/crafting_recipe/roguetown/structure/doublebed,
		"icon_file" = 'icons/roguetown/misc/beds.dmi',
		"icon_state" = "double"
	),
	"curtain_red" = list(
		"name" = "Шторы (Красные)",
		"category" = "Мебель",
		"layer_type" = "obj",
		"build_order" = 3,
		"path" = /obj/structure/curtain/red,
		"reqs" = /datum/crafting_recipe/roguetown/structure/curtainred,
		"icon_file" = 'icons/roguetown/misc/structure.dmi',
		"icon_state" = "curtain-open"
	),
	"curtain_blue" = list(
		"name" = "Шторы (Синие)",
		"category" = "Мебель",
		"layer_type" = "obj",
		"build_order" = 3,
		"path" = /obj/structure/curtain/blue,
		"reqs" = /datum/crafting_recipe/roguetown/structure/curtainblue,
		"icon_file" = 'icons/roguetown/misc/structure.dmi',
		"icon_state" = "curtain-open"
	),
	"mirror_wood" = list(
		"name" = "Настенное зеркало",
		"category" = "Мебель",
		"layer_type" = "obj",
		"build_order" = 3,
		"path" = /obj/structure/mirror,
		"reqs" = /datum/crafting_recipe/roguetown/structure/mirror,
		"icon_file" = 'icons/roguetown/misc/structure.dmi',
		"icon_state" = "mirror"
	),
	"display_stand" = list(
		"name" = "Стойка манекена",
		"category" = "Мебель",
		"layer_type" = "obj",
		"build_order" = 3,
		"path" = /obj/structure/mannequin,
		"reqs" = /datum/crafting_recipe/roguetown/structure/display_stand,
		"icon_file" = 'icons/obj/mannequin.dmi',
		"icon_state" = "coat_hanger"
	),


	"chest_wood" = list(
		"name" = "Сундук",
		"category" = "Хранилища",
		"layer_type" = "obj",
		"build_order" = 3,
		"path" = /obj/structure/closet/crate/chest/crafted,
		"reqs" = /datum/crafting_recipe/roguetown/structure/chest,
		"icon_file" = 'icons/roguetown/misc/structure.dmi',
		"icon_state" = "chest3s"
	),
	"closet_wood" = list(
		"name" = "Шкаф",
		"category" = "Хранилища",
		"layer_type" = "obj",
		"build_order" = 3,
		"path" = /obj/structure/closet/crate/roguecloset,
		"reqs" = /datum/crafting_recipe/roguetown/structure/closet,
		"icon_file" = 'icons/roguetown/misc/structure.dmi',
		"icon_state" = "closet"
	),
	"rack_wood" = list(
		"name" = "Оружейная стойка",
		"category" = "Хранилища",
		"layer_type" = "obj",
		"build_order" = 3,
		"path" = /obj/structure/rack/rogue,
		"reqs" = /datum/crafting_recipe/roguetown/structure/rack,
		"icon_file" = 'icons/roguetown/misc/structure.dmi',
		"icon_state" = "rack"
	),
	"barrel_wood" = list(
		"name" = "Деревянная бочка",
		"category" = "Хранилища",
		"layer_type" = "obj",
		"build_order" = 3,
		"path" = /obj/structure/fermentation_keg/crafted,
		"reqs" = /datum/crafting_recipe/roguetown/structure/barrel,
		"icon_file" = 'icons/obj/brewing.dmi',
		"icon_state" = "barrel_tapless"
	),
	"coffin_wood" = list(
		"name" = "Гроб",
		"category" = "Хранилища",
		"layer_type" = "obj",
		"build_order" = 3,
		"path" = /obj/structure/closet/crate/coffin,
		"reqs" = /datum/crafting_recipe/roguetown/structure/coffin,
		"icon_file" = 'icons/roguetown/misc/structure.dmi',
		"icon_state" = "casket"
	),
	"wicker_basket" = list(
		"name" = "Плетеная корзина",
		"category" = "Хранилища",
		"layer_type" = "obj",
		"build_order" = 3,
		"path" = /obj/structure/closet/crate/chest/wicker,
		"reqs" = /datum/crafting_recipe/roguetown/structure/wicker,
		"icon_file" = 'icons/roguetown/misc/structure.dmi',
		"icon_state" = "wicker"
	),

	"fireplace_north" = list(
		"name" = "Настенный камин",
		"category" = "Отопление и Свет",
		"layer_type" = "obj",
		"build_order" = 3,
		"path" = /obj/machinery/light/rogue/campfire/fireplace,
		"reqs" = /datum/crafting_recipe/roguetown/structure/fireplace,
		"icon_file" = 'icons/roguetown/misc/lighting.dmi',
		"icon_state" = "wallfire1"
	),
	"torch_holder" = list(
		"name" = "Настенный факел",
		"category" = "Отопление и Свет",
		"layer_type" = "obj",
		"build_order" = 3,
		"path" = /obj/machinery/light/rogue/torchholder,
		"reqs" = /datum/crafting_recipe/roguetown/structure/torchholder,
		"icon_file" = 'icons/roguetown/misc/lighting.dmi',
		"icon_state" = "torchwall1"
	),
	"lanternpost" = list(
		"name" = "Уличный Фонарь",
		"category" = "Отопление и Свет",
		"layer_type" = "obj",
		"build_order" = 3,
		"path" = /obj/machinery/light/rogue/lanternpost,
		"reqs" = list(/obj/item/ingot/iron = 1, /obj/item/grown/log/tree/small = 2, /obj/item/natural/wood/plank = 2),
		"icon_file" = 'icons/roguetown/misc/tallstructure.dmi',
		"icon_state" = "streetlantern1"
	),
	"torch_standing" = list(
		"name" = "Стоячий факел",
		"category" = "Отопление и Свет",
		"layer_type" = "obj",
		"build_order" = 3,
		"path" = /obj/machinery/light/rogue/firebowl/standing,
		"reqs" = /datum/crafting_recipe/roguetown/structure/standing,
		"icon_file" = 'icons/roguetown/misc/lighting.dmi',
		"icon_state" = "standing1"
	),
	"firebowl" = list(
		"name" = "Жирник",
		"category" = "Отопление и Свет",
		"layer_type" = "obj",
		"build_order" = 3,
		"path" = /obj/machinery/light/rogue/firebowl,
		"reqs" = list(/obj/item/natural/stone = 2),
		"icon_file" = 'icons/roguetown/misc/lighting.dmi',
		"icon_state" = "stonefire1"
	),
	"torch_lantern_standing" = list(
		"name" = "Каменный фонарь",
		"category" = "Отопление и Свет",
		"layer_type" = "obj",
		"build_order" = 3,
		"path" = /obj/machinery/light/rogue/torchholder/hotspring/standing,
		"reqs" = /datum/crafting_recipe/roguetown/structure/stonelanternstanding,
		"icon_file" = 'icons/obj/structures/hotspring.dmi',
		"icon_state" = "stonelantern_standing1"
	),
	"wall_candles" = list(
		"name" = "Настенные свечи",
		"category" = "Отопление и Свет",
		"layer_type" = "obj",
		"build_order" = 3,
		"path" = /obj/machinery/light/rogue/candle,
		"reqs" = /datum/crafting_recipe/roguetown/structure/wallcandle,
		"icon_file" = 'icons/roguetown/misc/lighting.dmi',
		"icon_state" = "wallcandle1"
	),
	"campfire" = list(
		"name" = "Костер",
		"category" = "Отопление и Свет",
		"layer_type" = "obj",
		"build_order" = 3,
		"path" = /obj/machinery/light/rogue/campfire,
		"reqs" = /datum/crafting_recipe/roguetown/structure/campfire,
		"icon_file" = 'icons/roguetown/misc/lighting.dmi',
		"icon_state" = "badfire1"
	),
	"hearth" = list(
		"name" = "Очаг",
		"category" = "Отопление и Свет",
		"layer_type" = "obj",
		"build_order" = 3,
		"path" = /obj/machinery/light/rogue/hearth,
		"reqs" = /datum/crafting_recipe/roguetown/structure/cookpit,
		"icon_file" = 'icons/roguetown/misc/lighting.dmi',
		"icon_state" = "hearth1"
	),
	"oven" = list(
		"name" = "Печь",
		"category" = "Отопление и Свет",
		"layer_type" = "obj",
		"build_order" = 3,
		"path" = /obj/machinery/light/rogue/oven,
		"reqs" = /datum/crafting_recipe/roguetown/structure/oven,
		"icon_file" = 'icons/roguetown/misc/lighting.dmi',
		"icon_state" = "oven1"
	),

	"anvil_iron" = list(
		"name" = "Железная наковальня",
		"category" = "Ремесло и Станки",
		"layer_type" = "obj",
		"build_order" = 3,
		"path" = /obj/machinery/anvil,
		"reqs" = /datum/crafting_recipe/roguetown/structure/anvil,
		"icon_file" = 'icons/roguetown/misc/forge.dmi',
		"icon_state" = "anvil"
	),
	"anvil_bronze" = list(
		"name" = "Бронзовая наковальня",
		"category" = "Ремесло и Станки",
		"layer_type" = "obj",
		"build_order" = 3,
		"path" = /obj/machinery/anvil/bronze,
		"reqs" = /datum/crafting_recipe/roguetown/structure/anvil/bronze,
		"icon_file" = 'icons/roguetown/misc/forge.dmi',
		"icon_state" = "broanvil"
	),
	"forge" = list(
		"name" = "Кузнечный горн",
		"category" = "Ремесло и Станки",
		"layer_type" = "obj",
		"build_order" = 3,
		"path" = /obj/machinery/light/rogue/forge,
		"reqs" = /datum/crafting_recipe/roguetown/structure/forge,
		"icon_file" = 'icons/roguetown/misc/forge.dmi',
		"icon_state" = "forge0"
	),
	"smelter_ore" = list(
		"name" = "Плавильная печь для руды",
		"category" = "Ремесло и Станки",
		"layer_type" = "obj",
		"build_order" = 3,
		"path" = /obj/machinery/light/rogue/smelter,
		"reqs" = /datum/crafting_recipe/roguetown/structure/smelter,
		"icon_file" = 'icons/roguetown/misc/forge.dmi',
		"icon_state" = "cavesmelter0"
	),
	"smelter_bloomery" = list(
		"name" = "Сыродутный горн (Железо)",
		"category" = "Ремесло и Станки",
		"layer_type" = "obj",
		"build_order" = 3,
		"path" = /obj/machinery/light/rogue/smelter/hiron,
		"reqs" = /datum/crafting_recipe/roguetown/structure/smelterhiron,
		"icon_file" = 'icons/roguetown/misc/forge.dmi',
		"icon_state" = "hironsmelter0"
	),
	"smelter_great" = list(
		"name" = "Великая сталеплавильня",
		"category" = "Ремесло и Станки",
		"layer_type" = "obj",
		"build_order" = 3,
		"path" = /obj/machinery/light/rogue/smelter/great,
		"reqs" = /datum/crafting_recipe/roguetown/structure/greatsmelter,
		"icon_file" = 'icons/roguetown/misc/forge.dmi',
		"icon_state" = "smelter0"
	),
	"grindwheel" = list(
		"name" = "Точильный круг",
		"category" = "Ремесло и Станки",
		"layer_type" = "obj",
		"build_order" = 3,
		"path" = /obj/structure/fluff/grindwheel,
		"reqs" = /datum/crafting_recipe/roguetown/structure/sharpwheel,
		"icon_file" = 'icons/roguetown/misc/forge.dmi',
		"icon_state" = "grindwheel"
	),
	"loom" = list(
		"name" = "Ткацкий станок",
		"category" = "Ремесло и Станки",
		"layer_type" = "obj",
		"build_order" = 3,
		"path" = /obj/machinery/loom,
		"reqs" = /datum/crafting_recipe/roguetown/structure/loom,
		"icon_file" = 'icons/roguetown/misc/structure.dmi',
		"icon_state" = "loom"
	),
	"potters_wheel" = list(
		"name" = "Гончарный круг",
		"category" = "Ремесло и Станки",
		"layer_type" = "obj",
		"build_order" = 3,
		"path" = /obj/structure/fluff/ceramicswheel,
		"reqs" = /datum/crafting_recipe/roguetown/structure/ceramicswheel,
		"icon_file" = 'icons/roguetown/misc/structure.dmi',
		"icon_state" = "potwheel"
	),
	"dye_station" = list(
		"name" = "Красильня",
		"category" = "Ремесло и Станки",
		"layer_type" = "obj",
		"build_order" = 3,
		"path" = /obj/machinery/gear_painter,
		"reqs" = /datum/crafting_recipe/roguetown/structure/dyestation,
		"icon_file" = 'icons/roguetown/misc/structure.dmi',
		"icon_state" = "dyestation"
	),
	"alchemy_station" = list(
		"name" = "Алхимический стол",
		"category" = "Ремесло и Станки",
		"layer_type" = "obj",
		"build_order" = 3,
		"path" = /obj/structure/fluff/alch,
		"reqs" = /datum/crafting_recipe/roguetown/structure/alch,
		"icon_file" = 'icons/roguetown/misc/structure.dmi',
		"icon_state" = "alch"
	),
	"cooling_table" = list(
		"name" = "Охлаждающий стол для погреба",
		"category" = "Ремесло и Станки",
		"layer_type" = "obj",
		"build_order" = 3,
		"path" = /obj/structure/table/cooling,
		"reqs" = /datum/crafting_recipe/roguetown/engineering/coolingtable,
		"icon_file" = 'icons/roguetown/misc/tables.dmi',
		"icon_state" = "tablewood_alt"
	),
	"bakers_trough" = list(
		"name" = "Корыто пекаря",
		"category" = "Ремесло и Станки",
		"layer_type" = "obj",
		"build_order" = 3,
		"path" = /obj/structure/bakers_trough,
		"reqs" = /datum/crafting_recipe/roguetown/structure/bakers_trough,
		"icon_file" = 'modular/Neu_Food/icons/cookware/bakers_trough.dmi',
		"icon_state" = "through_empty"
	),
	"grille" = list(
		"name" = "Половая Решетка",
		"category" = "Ремесло и Станки",
		"layer_type" = "obj",
		"build_order" = 3,
		"path" = /obj/structure/bars/grille,
		"reqs" = /datum/crafting_recipe/roguetown/engineering/floorgrille,
		"icon_file" = 'icons/roguetown/misc/structure.dmi',
		"icon_state" = "floorgrille"
	),
	"minecart_rail" = list(
		"name" = "Рельсы",
		"category" = "Ремесло и Станки",
		"layer_type" = "obj",
		"build_order" = 3,
		"path" = /obj/structure/minecart_rail,
		"reqs" = list(/obj/item/ingot/iron = 1),
		"icon_file" = 'icons/obj/track.dmi',
		"icon_state" = "track"
	),
	),
	"floordoor" = list(
		"name" = "Половая дверь",
		"category" = "Ремесло и Станки",
		"layer_type" = "obj",
		"build_order" = 3,
		"path" = /obj/structure/floordoor,
		"reqs" = /datum/crafting_recipe/roguetown/engineering/trapdoor,
		"icon_file" = 'icons/roguetown/misc/structure.dmi',
		"icon_state" = "floorhatch1"
	),
	"lever" = list(
		"name" = "Рычаг",
		"category" = "Ремесло и Станки",
		"layer_type" = "obj",
		"build_order" = 3,
		"path" = /obj/structure/lever/wall,
		"reqs" = list(/obj/item/ingot/iron = 1),
		"icon_file" = 'icons/roguetown/misc/structure.dmi',
		"icon_state" = "leverwall0"
	),
	"millstone" = list(
		"name" = "Жернова",
		"category" = "Ремесло и Станки",
		"layer_type" = "obj",
		"build_order" = 3,
		"path" = /obj/item/millstone,
		"reqs" = /datum/crafting_recipe/roguetown/structure/millstone,
		"icon_file" = 'icons/roguetown/misc/structure.dmi',
		"icon_state" = "millstone"
	),
	"tanning_rack" = list(
		"name" = "Стойка сушки шкур",
		"category" = "Ремесло и Станки",
		"layer_type" = "obj",
		"build_order" = 3,
		"path" = /obj/machinery/tanningrack,
		"reqs" = /datum/crafting_recipe/roguetown/structure/tanningrack,
		"icon_file" = 'icons/roguetown/misc/structure.dmi',
		"icon_state" = "dryrack"
	),
	"apiary_beehive" = list(
		"name" = "Пасека / Улей",
		"category" = "Ремесло и Станки",
		"layer_type" = "obj",
		"build_order" = 3,
		"path" = /obj/structure/apiary,
		"reqs" = /datum/crafting_recipe/roguetown/structure/apiary,
		"icon_file" = 'icons/obj/structures/apiary.dmi',
		"icon_state" = "beebox-empty"
	),

	"statue_stone" = list(
		"name" = "Каменная статуя девы",
		"category" = "Религия и Статуи",
		"layer_type" = "obj",
		"build_order" = 3,
		"path" = /obj/structure/fluff/statue/femalestatue,
		"reqs" = /datum/crafting_recipe/roguetown/structure/statue,
		"icon_file" = 'icons/roguetown/misc/ay.dmi',
		"icon_state" = "1"
	),
	"cross_pantheon_wood" = list(
		"name" = "Крест Пантеона (Дерево)",
		"category" = "Религия и Статуи",
		"layer_type" = "obj",
		"build_order" = 3,
		"path" = /obj/structure/fluff/psycross/crafted,
		"reqs" = /datum/crafting_recipe/roguetown/structure/pantheon_cross,
		"icon_file" = 'icons/roguetown/misc/tallstructure.dmi',
		"icon_state" = "cross_undivided"
	),
	"cross_pantheon_stone" = list(
		"name" = "Крест Пантеона (Камень)",
		"category" = "Религия и Статуи",
		"layer_type" = "obj",
		"build_order" = 3,
		"path" = /obj/structure/fluff/psycross,
		"reqs" = /datum/crafting_recipe/roguetown/structure/pantheon_cross_stone,
		"icon_file" = 'icons/roguetown/misc/tallstructure.dmi',
		"icon_state" = "cross_undivided_r"
	),
	"cross_psydon_wood" = list(
		"name" = "Распятие Псидона (Дерево)",
		"category" = "Религия и Статуи",
		"layer_type" = "obj",
		"build_order" = 3,
		"path" = /obj/structure/fluff/psycross/psycrucifix,
		"reqs" = /datum/crafting_recipe/roguetown/structure/psydon_cross,
		"icon_file" = 'icons/roguetown/misc/tallstructure.dmi',
		"icon_state" = "cross_psy"
	),
	"cross_psydon_stone" = list(
		"name" = "Распятие Псидона (Камень)",
		"category" = "Религия и Статуи",
		"layer_type" = "obj",
		"build_order" = 3,
		"path" = /obj/structure/fluff/psycross/psycrucifix/stone,
		"reqs" = /datum/crafting_recipe/roguetown/structure/psydon_cross_stone,
		"icon_file" = 'icons/roguetown/misc/tallstructure.dmi',
		"icon_state" = "cross_psy_r"
	),
	"cross_psydon_silver" = list(
		"name" = "Распятие Псидона (Серебро)",
		"category" = "Религия и Статуи",
		"layer_type" = "obj",
		"build_order" = 3,
		"path" = /obj/structure/fluff/psycross/psycrucifix/silver,
		"reqs" = /datum/crafting_recipe/roguetown/structure/psydon_cross_silver,
		"icon_file" = 'icons/roguetown/misc/tallstructure.dmi',
		"icon_state" = "cross_psy_s"
	),
	"cross_astrata_wood" = list(
		"name" = "Крест Астраты (Дерево)",
		"category" = "Религия и Статуи",
		"layer_type" = "obj",
		"build_order" = 3,
		"path" = /obj/structure/fluff/psycross/astrata,
		"reqs" = /datum/crafting_recipe/roguetown/structure/astrata_cross,
		"icon_file" = 'icons/roguetown/misc/tallstructure.dmi',
		"icon_state" = "cross_astrata"
	),
	"cross_astrata_stone" = list(
		"name" = "Крест Астраты (Камень)",
		"category" = "Религия и Статуи",
		"layer_type" = "obj",
		"build_order" = 3,
		"path" = /obj/structure/fluff/psycross/astrata/stone,
		"reqs" = /datum/crafting_recipe/roguetown/structure/astrata_cross_stone,
		"icon_file" = 'icons/roguetown/misc/tallstructure.dmi',
		"icon_state" = "cross_astrata_r"
	),
	"cross_astrata_gold" = list(
		"name" = "Крест Астраты (Позолота)",
		"category" = "Религия и Статуи",
		"layer_type" = "obj",
		"build_order" = 3,
		"path" = /obj/structure/fluff/psycross/astrata/golden,
		"reqs" = /datum/crafting_recipe/roguetown/structure/astrata_cross_gold,
		"icon_file" = 'icons/roguetown/misc/tallstructure.dmi',
		"icon_state" = "cross_astrata_u"
	),
	"cross_necra_stone" = list(
		"name" = "Крест Некры (Камень)",
		"category" = "Религия и Статуи",
		"layer_type" = "obj",
		"build_order" = 3,
		"path" = /obj/structure/fluff/psycross/necra,
		"reqs" = /datum/crafting_recipe/roguetown/structure/necra_cross,
		"icon_file" = 'icons/roguetown/misc/tallstructure.dmi',
		"icon_state" = "cross_necra"
	),
	"cross_zizo_wood" = list(
		"name" = "Оскверненный крест Зизо (Дерево)",
		"category" = "Религия и Статуи",
		"layer_type" = "obj",
		"build_order" = 3,
		"path" = /obj/structure/fluff/psycross/zizocross,
		"reqs" = /datum/crafting_recipe/roguetown/structure/zizo_cross,
		"icon_file" = 'icons/roguetown/misc/tallstructure.dmi',
		"icon_state" = "cross_zizo"
	),
	"cross_zizo_stone" = list(
		"name" = "Оскверненный крест Зизо (Камень)",
		"category" = "Религия и Статуи",
		"layer_type" = "obj",
		"build_order" = 3,
		"path" = /obj/structure/fluff/psycross/zizocross/stone,
		"reqs" = /datum/crafting_recipe/roguetown/structure/zizo_cross_stone,
		"icon_file" = 'icons/roguetown/misc/tallstructure.dmi',
		"icon_state" = "cross_zizo_r"
	),
	"cross_zizo_gold" = list(
		"name" = "Оскверненный крест Зизо (Золото)",
		"category" = "Религия и Статуи",
		"layer_type" = "obj",
		"build_order" = 3,
		"path" = /obj/structure/fluff/psycross/zizocross/golden,
		"reqs" = /datum/crafting_recipe/roguetown/structure/zizo_cross_gold,
		"icon_file" = 'icons/roguetown/misc/tallstructure.dmi',
		"icon_state" = "cross_zizo_u"
	),
	"cross_graggar_stone" = list(
		"name" = "Кровавый крест Граггара",
		"category" = "Религия и Статуи",
		"layer_type" = "obj",
		"build_order" = 3,
		"path" = /obj/structure/fluff/psycross/graggar,
		"reqs" = /datum/crafting_recipe/roguetown/structure/graggar_cross_stone,
		"icon_file" = 'icons/roguetown/misc/tallstructure.dmi',
		"icon_state" = "cross_graggar"
	),
	"cross_matthios_stone" = list(
		"name" = "Ухмыляющийся крест Маттиоса",
		"category" = "Религия и Статуи",
		"layer_type" = "obj",
		"build_order" = 3,
		"path" = /obj/structure/fluff/psycross/matthios,
		"reqs" = /datum/crafting_recipe/roguetown/structure/matthios_cross_stone,
		"icon_file" = 'icons/roguetown/misc/tallstructure.dmi',
		"icon_state" = "cross_matthios"
	),
	"cross_baotha_stone" = list(
		"name" = "Паучий крест Баоты",
		"category" = "Религия и Статуи",
		"layer_type" = "obj",
		"build_order" = 3,
		"path" = /obj/structure/fluff/psycross/baotha,
		"reqs" = /datum/crafting_recipe/roguetown/structure/baotha_cross_stone,
		"icon_file" = 'icons/roguetown/misc/tallstructure.dmi',
		"icon_state" = "cross_baotha"
	),
	"training_dummy" = list(
		"name" = "Тренировочный манекен",
		"category" = "Религия и Статуи",
		"layer_type" = "obj",
		"build_order" = 3,
		"path" = /obj/structure/fluff/statue/tdummy,
		"reqs" = /datum/crafting_recipe/roguetown/structure/dummy,
		"icon_file" = 'icons/roguetown/misc/structure.dmi',
		"icon_state" = "p_dummy"
	),
	"custom_sign" = list(
		"name" = "Деревянная вывеска (Табличка)",
		"category" = "Религия и Статуи",
		"layer_type" = "obj",
		"build_order" = 3,
		"path" = /obj/structure/fluff/customsign,
		"reqs" = /datum/crafting_recipe/roguetown/structure/sign,
		"icon_file" = 'icons/roguetown/misc/structure.dmi',
		"icon_state" = "sign"
	),

	"spike_pit_trap" = list(
		"name" = "Яма с кольями (Ловушка)",
		"category" = "Оборона и Ловушки",
		"layer_type" = "obj",
		"build_order" = 3,
		"path" = /obj/structure/spike_pit,
		"reqs" = /datum/crafting_recipe/roguetown/structure/spike_pit,
		"icon_file" = 'icons/turf/roguefloor.dmi',
		"icon_state" = "spike_pit"
	),
	"head_stake" = list(
		"name" = "Кол с головой (Устрашение)",
		"category" = "Оборона и Ловушки",
		"layer_type" = "obj",
		"build_order" = 3,
		"path" = /obj/structure/fluff/headstake,
		"reqs" = /datum/crafting_recipe/roguetown/structure/headstake,
		"icon_file" = 'icons/roguetown/items/natural.dmi',
		"icon_state" = "headstake"
	),
	"pillory_stocks" = list(
		"name" = "Позорный столб (Колодки)",
		"category" = "Оборона и Ловушки",
		"layer_type" = "obj",
		"build_order" = 3,
		"path" = /obj/structure/pillory/crafted,
		"reqs" = /datum/crafting_recipe/roguetown/structure/pillory,
		"icon_file" = 'modular/icons/obj/pillory.dmi',
		"icon_state" = "pillory_single"
	),
	"meathook_hanging" = list(
		"name" = "Мясницкий подвесной крюк",
		"category" = "Оборона и Ловушки",
		"layer_type" = "obj",
		"build_order" = 3,
		"path" = /obj/structure/meathook,
		"reqs" = /datum/crafting_recipe/roguetown/structure/meathook,
		"icon_file" = 'icons/roguetown/misc/tallstructure.dmi',
		"icon_state" = "meathook"
	),
	"noose_hanging" = list(
		"name" = "Виселица (Петля)",
		"category" = "Оборона и Ловушки",
		"layer_type" = "obj",
		"build_order" = 3,
		"path" = /obj/structure/noose,
		"reqs" = /datum/crafting_recipe/roguetown/structure/noose,
		"icon_file" = 'modular/icons/obj/gallows.dmi',
		"icon_state" = "noose"
	),
	"handcart_wagon" = list(
		"name" = "Ручная тележка",
		"category" = "Оборона и Ловушки",
		"layer_type" = "obj",
		"build_order" = 3,
		"path" = /obj/structure/handcart,
		"reqs" = /datum/crafting_recipe/roguetown/structure/handcart,
		"icon_file" = 'icons/roguetown/misc/structure.dmi',
		"icon_state" = "cart-empty"
	),

	"artificer_table" = list(
		"name" = "Стол артефактора",
		"category" = "Ремесло и Станки",
		"layer_type" = "obj",
		"build_order" = 3,
		"path" = /obj/structure/artificer_table,
		"reqs" = /datum/crafting_recipe/roguetown/engineering/art_table,
		"icon_file" = 'icons/roguetown/misc/tables.dmi',
		"icon_state" = "art_table"
	),
	"cauldron_alchemy" = list(
		"name" = "Алхимический котел",
		"category" = "Ремесло и Станки",
		"layer_type" = "obj",
		"build_order" = 3,
		"path" = /obj/machinery/light/rogue/cauldron,
		"reqs" = /datum/crafting_recipe/roguetown/structure/cauldronalchemy,
		"icon_file" = 'icons/roguetown/misc/alchemy.dmi',
		"icon_state" = "cauldron1"
	),
	"smoker_meat" = list(
		"name" = "Коптильня",
		"category" = "Ремесло и Станки",
		"layer_type" = "obj",
		"build_order" = 3,
		"path" = /obj/machinery/light/rogue/smoker,
		"reqs" = /datum/crafting_recipe/roguetown/structure/smoker,
		"icon_file" = 'icons/roguetown/misc/smoker.dmi',
		"icon_state" = "smoker"
	),
	"sleep_coffin" = list(
		"name" = "Обитый гроб",
		"category" = "Хранилища",
		"layer_type" = "obj",
		"build_order" = 3,
		"path" = /obj/structure/closet/crate/coffin/vampire,
		"reqs" = /datum/crafting_recipe/roguetown/structure/sleepcoffin,
		"icon_file" = 'icons/roguetown/misc/structure.dmi',
		"icon_state" = "vcasket"
	),
	"minecart" = list(
		"name" = "Шахтерская вагонетка",
		"category" = "Оборона и Ловушки",
		"layer_type" = "obj",
		"build_order" = 3,
		"path" = /obj/structure/closet/crate/miningcar,
		"reqs" = /datum/crafting_recipe/roguetown/engineering/minecart,
		"icon_file" = 'icons/obj/track.dmi',
		"icon_state" = "minecart"
	),
	"iron_gate" = list(
		"name" = "Металлические ворота",
		"category" = "Двери и Лестницы",
		"layer_type" = "obj",
		"build_order" = 2,
		"path" = /obj/structure/bars/passage,
		"reqs" = /datum/crafting_recipe/roguetown/engineering/gate,
		"icon_file" = 'icons/roguetown/misc/structure.dmi',
		"icon_state" = "passage0"
	),
	"iron_shutters" = list(
		"name" = "Жалюзи-решетка",
		"category" = "Окна и Витражи",
		"layer_type" = "obj",
		"build_order" = 2,
		"path" = /obj/structure/bars/passage/shutter,
		"reqs" = /datum/crafting_recipe/roguetown/engineering/shutters,
		"icon_file" = 'icons/roguetown/misc/structure.dmi',
		"icon_state" = "shutter0"
	),
	"rock_trap" = list(
		"name" = "Камнепад (Ловушка)",
		"category" = "Оборона и Ловушки",
		"layer_type" = "obj",
		"build_order" = 3,
		"path" = /obj/structure/trap/rock_fall,
		"reqs" = /datum/crafting_recipe/roguetown/engineering/rocktrap,
		"icon_file" = 'icons/roguetown/misc/traps.dmi',
		"icon_state" = "rockfall_trap_plate"
	),
	"flame_trap" = list(
		"name" = "Огнеметная труба (Ловушка)",
		"category" = "Оборона и Ловушки",
		"layer_type" = "obj",
		"build_order" = 3,
		"path" = /obj/structure/trap/flame,
		"reqs" = /datum/crafting_recipe/roguetown/engineering/flametrap,
		"icon_file" = 'icons/roguetown/misc/traps.dmi',
		"icon_state" = "trap_plate"
	)
))


#define MAX_PLANNER_RADIUS 6
#define MAX_SPELL_RADIUS 13

/proc/init_blueprint_icons()
	for(var/key in GLOB.blueprint_buildable_types)
		var/list/info = GLOB.blueprint_buildable_types[key]
		if(info["image"]) continue

		var/atom/build_path = info["path"]
		var/i_file = info["icon_file"] || initial(build_path.icon)
		var/i_state = info["icon_state"] || initial(build_path.icon_state)

		var/icon/I = icon(i_file, i_state, SOUTH, 1)
		info["image"] = icon2base64(I)

		CHECK_TICK


/proc/get_blueprint_tgui_data()
	var/list/data = list()
	var/list/types_data = list()

	for(var/key in GLOB.blueprint_buildable_types)
		var/list/info = GLOB.blueprint_buildable_types[key]
		var/atom/build_path = info["path"]

		var/i_file = info["icon_file"] || initial(build_path.icon)
		var/i_state = info["icon_state"] || initial(build_path.icon_state)

		if(!info["image"])
			var/icon/I = icon(i_file, i_state, SOUTH, 1)
			info["image"] = icon2base64(I)

		var/list/reqs_list = get_blueprint_reqs(info)
		var/reqs_text = ""
		for(var/r_path in reqs_list)
			var/obj/item/temp = r_path
			reqs_text += "[initial(temp.name)] x[reqs_list[r_path]], "
		if(length(reqs_text) > 2)
			reqs_text = copytext(reqs_text, 1, length(reqs_text) - 1)

		types_data[key] = list(
			"name" = info["name"],
			"category" = info["category"],
			"layer_type" = info["layer_type"],
			"reqs_text" = reqs_text,
			"image" = info["image"]
		)

	data["buildable_types"] = types_data
	return data


/obj/item/blueprint_planner
	name = "архитектурный чертеж"
	desc = "Позволяет спроектировать здание с мебелью и возвести его молотком."
	icon_state = "skub"
	w_class = WEIGHT_CLASS_SMALL
	var/list/design_data = list()
	var/is_designed = FALSE
	var/max_floors = 2
	var/list/scanned_grid = list()

/proc/get_blueprint_target_turf(turf/origin, dx, dy, dz)
	if(!origin) return null
	var/turf/base_turf = locate(origin.x + dx, origin.y + dy, origin.z)
	if(!base_turf) return null

	var/turf/target_turf = base_turf
	if(dz > 0)
		for(var/i = 1 to dz)
			var/turf/above = get_step_multiz(target_turf, UP)
			if(!above)
				above = locate(target_turf.x, target_turf.y, target_turf.z + 1)
			target_turf = above
			if(!target_turf || target_turf.z > world.maxz) break

	if(target_turf && target_turf.z > world.maxz)
		return null

	return target_turf

/obj/item/blueprint_planner/attack_self(mob/user)
	ui_interact(user)

/obj/item/blueprint_planner/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "BlueprintPlanner", name)
		ui.open()

/obj/item/blueprint_planner/ui_static_data(mob/user)
	return get_blueprint_static_tgui_data()


/obj/item/blueprint_planner/ui_data(mob/user)
	var/list/data = list()
	data["saved_grid"] = design_data
	data["saved_floors"] = max_floors
	data["scanned_grid"] = scanned_grid
	return data


/obj/item/blueprint_planner/ui_act(action, params)
	. = ..()
	if(.) return

	if(action == "scan_terrain")
		var/radius = min(params["radius"] || 6, MAX_PLANNER_RADIUS)
		var/max_z = clamp(text2num(params["max_floors"]) || 2, 2, 4)
		var/turf/center = get_turf(src)
		var/list/scanned = list()
		for(var/dx in -radius to radius)
			for(var/dy in -radius to radius)
				for(var/dz in 0 to max_z - 1)
					var/turf/T = get_blueprint_target_turf(center, dx, dy, dz)
					if(!T) continue

					var/is_blocked = FALSE
					if(isclosedturf(T))
						is_blocked = TRUE
					else
						for(var/obj/O in T)
							if(O.density && (istype(O, /obj/structure) || istype(O, /obj/machinery)))
								is_blocked = TRUE
								break

					if(is_blocked)
						scanned += list(list("x"=dx, "y"=dy, "z"=dz, "layer"="wall"))
					else if(!istype(T, /turf/open/openspace) && !istype(T, /turf/open/water))
						scanned += list(list("x"=dx, "y"=dy, "z"=dz, "layer"="floor"))

		scanned_grid = scanned
		return TRUE

	if(action == "save_design")
		var/list/packed_data = params["packed_data"]
		var/list/safe_data = list()

		for(var/b_type in packed_data)
			var/list/coords = packed_data[b_type]
			for(var/coord_str in coords)
				var/list/parts = splittext(coord_str, ",")
				if(length(parts) < 3) continue

				var/dx = text2num(parts[1])
				var/dy = text2num(parts[2])
				var/dz = text2num(parts[3])
				var/ddir = length(parts) >= 4 ? text2num(parts[4]) : 2

				if(abs(dx) > MAX_PLANNER_RADIUS || abs(dy) > MAX_PLANNER_RADIUS)
					continue

				safe_data += list(list(
					"x" = dx,
					"y" = dy,
					"z" = dz,
					"type" = b_type,
					"dir" = ddir
				))

		design_data = safe_data
		max_floors = clamp(text2num(params["max_floors"]) || 2, 2, 4)
		if(length(design_data))
			is_designed = TRUE
			to_chat(usr, span_notice("Проект на [max_floors] эт. сохранен! Кликните им по земле для размещения."))
			SStgui.close_uis(src)
		else
			is_designed = FALSE
			to_chat(usr, span_warning("Чертеж пуст."))
		return TRUE

	if(action == "clear_design")
		design_data = list()
		is_designed = FALSE
		to_chat(usr, span_notice("Чертеж очищен."))
		return TRUE

/obj/item/blueprint_planner/proc/can_place_blueprint(turf/origin_turf, mob/user)
	return check_blueprint_placement_valid(origin_turf, user, design_data, max_floors)


/obj/item/blueprint_planner/afterattack(atom/target, mob/user, proximity_flag, click_parameters)
	if(!proximity_flag || !is_designed) return

	var/turf/T = get_turf(target)
	if(!isturf(T)) return

	if(!can_place_blueprint(T, user))
		return

	var/obj/structure/blueprint_site/site = new(T)
	site.max_floors = src.max_floors
	site.setup_design(design_data, user)
	to_chat(user, span_notice("Вы разместили стройплощадку на [max_floors] эт.! Положите ресурсы рядом и бейте молотком."))
	qdel(src)
	return TRUE

/obj/effect/blueprint_ghost
	name = "план конструкции"
	desc = "Голографический каркас будущей постройки."
	anchored = TRUE
	density = FALSE
	alpha = 140
	color = "#4da6ff"
	layer = ABOVE_NORMAL_TURF_LAYER
	mouse_opacity = 0
	var/obj/structure/blueprint_site/master
	var/list/entry_data

/obj/structure/blueprint_site
	name = "строительная площадка"
	desc = "Бейте молотком для постройки. Положите нужные ресурсы рядом."
	icon = 'icons/turf/roguewall.dmi'
	icon_state = "decowood"
	density = FALSE
	anchored = TRUE

	var/list/unbuilt_entries = list()
	var/list/active_ghosts = list()
	var/list/required_resources = list()
	var/total_tiles_count = 0
	var/built_tiles_count = 0
	var/max_floors = 2

/obj/structure/blueprint_site/examine(mob/user)
	. = ..()
	var/percent = total_tiles_count > 0 ? round((built_tiles_count / total_tiles_count) * 100) : 0
	. += span_notice("Готовность постройки: <b>[percent]%</b> ([built_tiles_count]/[total_tiles_count] деталей).")

	var/missing = ""
	for(var/res in required_resources)
		if(required_resources[res] > 0)
			var/obj/item/temp = res
			missing += "[initial(temp.name)]: [required_resources[res]] шт. "

	if(missing != "")
		. += span_warning("Не хватает ресурсов: [missing]")
	else
		. += span_info("Все ресурсы поглощены! Продолжайте забивать гвозди молотком.")

/obj/structure/blueprint_site/proc/setup_design(list/data, mob/user)
	total_tiles_count = length(data)
	built_tiles_count = 0

	for(var/entry in data)
		var/b_type = entry["type"]
		var/dz = isnum(entry["z"]) ? entry["z"] : (text2num(entry["z"]) || 0)
		if(dz >= max_floors) continue

		var/list/info = GLOB.blueprint_buildable_types[b_type]
		if(!info) continue

		var/list/reqs_list = get_blueprint_reqs(info)
		for(var/res_path in reqs_list)
			var/cost = reqs_list[res_path]
			if(!required_resources[res_path])
				required_resources[res_path] = 0
			required_resources[res_path] += cost

		unbuilt_entries += list(entry)

	sortTim(unbuilt_entries, GLOBAL_PROC_REF(cmp_build_priority))

/proc/cmp_build_priority(list/a, list/b)
	var/za = isnum(a["z"]) ? a["z"] : (text2num(a["z"]) || 0)
	var/zb = isnum(b["z"]) ? b["z"] : (text2num(b["z"]) || 0)
	if(za != zb)
		return za - zb

	var/info_a = GLOB.blueprint_buildable_types[a["type"]]
	var/info_b = GLOB.blueprint_buildable_types[b["type"]]
	var/cat_a = info_a ? info_a["build_order"] : 9
	var/cat_b = info_b ? info_b["build_order"] : 9
	return cat_a - cat_b

/obj/structure/blueprint_site/proc/can_solidify_target(turf/target_turf, mob/user, list/entry)
	if(!target_turf) return FALSE

	var/b_type = entry ? entry["type"] : null
	var/list/info = b_type ? GLOB.blueprint_buildable_types[b_type] : null
	var/incoming_dir = entry && isnum(entry["dir"]) ? entry["dir"] : (text2num(entry?["dir"]) || 2)
	var/is_border_build = (info && info["layer_type"] == "border")

	for(var/mob/living/M in target_turf)
		to_chat(user, span_warning("Строительству мешает существо ([M.name]) на клетке ([target_turf.x], [target_turf.y])! Попросите его отойти."))
		return FALSE

	for(var/obj/item/I in target_turf)
		to_chat(user, span_warning("Строительству мешает предмет ([I.name]) на клетке ([target_turf.x], [target_turf.y])! Расчистите место."))
		return FALSE

	for(var/obj/structure/S in target_turf)
		if(S == src || istype(S, /obj/effect/blueprint_ghost))
			continue

		if(is_border_build && ((S.flags_1 & ON_BORDER_1) || istype(S, /obj/structure/fluff/railing)))
			if(S.dir != incoming_dir)
				continue

		if(((S.flags_1 & ON_BORDER_1) || istype(S, /obj/structure/fluff/railing)) && !is_border_build)
			continue

		if(S.density)
			to_chat(user, span_warning("Строительству мешает объект ([S.name]) на клетке ([target_turf.x], [target_turf.y])!"))
			return FALSE

	return TRUE

/obj/structure/blueprint_site/attackby(obj/item/I, mob/living/user, params)
	if(istype(I, /obj/item/rogueweapon/hammer))
		user.changeNext_move(CLICK_CD_MELEE)

		pull_resources()

		var/missing = ""
		for(var/res in required_resources)
			if(required_resources[res] > 0)
				var/obj/item/temp = res
				missing += "[initial(temp.name)]: [required_resources[res]] шт. "

		if(missing != "")
			to_chat(user, span_warning("Не хватает ресурсов! Положите рядом на пол: [missing]"))
			playsound(src, 'sound/items/bsmithfail.ogg', 50, 1)
			return TRUE

		var/batch_size = 1

		if(length(active_ghosts))
			for(var/i in 1 to batch_size)
				if(!length(active_ghosts)) break

				var/obj/effect/blueprint_ghost/G = active_ghosts[1]
				var/turf/target_turf = get_turf(G)

				if(!can_solidify_target(target_turf, user, G.entry_data))
					playsound(src, 'sound/items/bsmithfail.ogg', 50, 1)
					return TRUE

				solidify_ghost()

		if(length(unbuilt_entries))
			for(var/i in 1 to batch_size)
				if(!length(unbuilt_entries)) break
				spawn_next_ghost()

		if(user.mind)
			user.mind.add_sleep_experience(/datum/skill/craft/carpentry, (user.STAINT * 0.3))

		playsound(src, 'sound/items/bsmith4.ogg', 100, 1)

		var/percent = total_tiles_count > 0 ? round((built_tiles_count / total_tiles_count) * 100) : 0
		user.visible_message(span_notice("[user] стучит молотком по конструкции."), span_notice("Вы строите... (<b>[percent]%</b>)"))

		if(!length(active_ghosts) && !length(unbuilt_entries))
			finish_site(user)

		return TRUE
	return ..()

/obj/structure/blueprint_site/attack_hand(mob/living/user)
	. = ..()
	if(.)
		return
	if(!isliving(user) || user.incapacitated())
		return

	user.visible_message(
		span_warning("[user] начинает разбирать [src]..."),
		span_notice("Вы начинаете разбирать [src]...")
	)

	if(do_after(user, 10 SECONDS, target = src))
		user.visible_message(
			span_warning("[user] полностью разбирает [src]!"),
			span_notice("Вы разобрали строительную площадку.")
		)
		qdel(src)

/obj/structure/blueprint_site/proc/spawn_next_ghost()
	if(!length(unbuilt_entries)) return

	var/list/entry = unbuilt_entries[1]
	unbuilt_entries.Cut(1, 2)

	var/b_type = entry["type"]
	var/dx = isnum(entry["x"]) ? entry["x"] : text2num(entry["x"])
	var/dy = isnum(entry["y"]) ? entry["y"] : text2num(entry["y"])
	var/dz = isnum(entry["z"]) ? entry["z"] : (text2num(entry["z"]) || 0)
	var/chosen_dir = isnum(entry["dir"]) ? entry["dir"] : (text2num(entry["dir"]) || 2)

	var/list/info = GLOB.blueprint_buildable_types[b_type]
	if(!info) return

	var/atom/build_path = info["path"]
	var/i_file = info["icon_file"] || initial(build_path.icon)
	var/i_state = info["icon_state"] || initial(build_path.icon_state)

	var/turf/target_turf = get_blueprint_target_turf(get_turf(src), dx, dy, dz)
	if(target_turf)
		var/obj/effect/blueprint_ghost/G = new(target_turf)
		G.icon = i_file
		G.icon_state = i_state
		G.setDir(chosen_dir)
		G.name = "план: [info["name"]]"
		G.master = src
		G.entry_data = entry
		active_ghosts += G

/obj/structure/blueprint_site/proc/solidify_ghost()
	if(!length(active_ghosts)) return

	var/obj/effect/blueprint_ghost/G = active_ghosts[1]
	active_ghosts.Cut(1, 2)

	if(QDELETED(G)) return

	var/list/entry = G.entry_data
	var/b_type = entry["type"]
	var/chosen_dir = isnum(entry["dir"]) ? entry["dir"] : (text2num(entry["dir"]) || 2)
	var/list/info = GLOB.blueprint_buildable_types[b_type]
	var/turf/target_turf = get_turf(G)

	qdel(G)

	if(target_turf && info)
		var/build_path = info["path"]

		if(ispath(build_path, /turf))
			if(!(ispath(build_path, /turf/closed) && isclosedturf(target_turf)))
				target_turf.ChangeTurf(build_path, flags = CHANGETURF_INHERIT_AIR)
				target_turf.setDir(chosen_dir)
		else if(ispath(build_path, /atom/movable))
			var/atom/movable/AM = new build_path(target_turf)
			AM.setDir(chosen_dir)
			if(hascall(AM, "OnCrafted"))
				AM.OnCrafted(chosen_dir)

		built_tiles_count++

/obj/structure/blueprint_site/proc/pull_resources()
	var/has_needed = FALSE
	for(var/res in required_resources)
		if(required_resources[res] > 0)
			has_needed = TRUE
			break
	if(!has_needed) return

	for(var/obj/item/I in range(3, src))
		if(!isturf(I.loc))
			continue

		if(istype(I, /obj/item/natural/bundle))
			var/obj/item/natural/bundle/B = I
			if(required_resources[B.stacktype] && required_resources[B.stacktype] > 0)
				var/needed = required_resources[B.stacktype]
				var/take = min(B.amount, needed)
				B.amount -= take
				required_resources[B.stacktype] -= take
				if(B.amount <= 0)
					qdel(B)
				else
					B.update_bundle()

		else
			for(var/res_path in required_resources)
				if(required_resources[res_path] > 0 && istype(I, res_path))
					required_resources[res_path] -= 1
					qdel(I)
					break

/obj/structure/blueprint_site/proc/finish_site(mob/user)
	visible_message(span_notice("<b>[src] завершена! Здание полностью возведено!</b>"))
	playsound(src, 'sound/foley/Building-01.ogg', 100, 1)
	qdel(src)

/obj/structure/blueprint_site/Destroy()
	for(var/obj/effect/blueprint_ghost/G in active_ghosts)
		qdel(G)
	active_ghosts.Cut()
	unbuilt_entries.Cut()
	return ..()

/mob
	var/list/arcyne_blueprint_data = list()
	var/arcyne_blueprint_floors = 2

/datum/action/cooldown/spell/architect_plan
	name = "Тайное Проектирование"
	desc = "Открывает ментальный чертеж для планировки здания. Проект сохраняется в памяти."
	button_icon = 'icons/mob/actions/roguespells.dmi'
	button_icon_state = "spell0"
	panel = "Spells"
	click_to_activate = FALSE
	charge_required = FALSE
	cooldown_time = 0
	primary_resource_type = SPELL_COST_NONE
	spell_flags = SPELL_IGNORE_SPELLBLOCK
	var/list/scanned_grid = list()

/datum/action/cooldown/spell/architect_plan/ui_host(mob/user)
	return user || owner

/datum/action/cooldown/spell/architect_plan/ui_state(mob/user)
	return GLOB.always_state

/datum/action/cooldown/spell/architect_plan/Trigger(trigger_flags, atom/target)
	var/mob/living/caster = owner || target || usr
	if(caster)
		ui_interact(caster)
	return TRUE

/datum/action/cooldown/spell/architect_plan/cast(atom/cast_on)
	. = ..()
	var/mob/living/caster = owner || cast_on || usr
	if(caster)
		ui_interact(caster)
	return TRUE

/datum/action/cooldown/spell/architect_plan/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "BlueprintPlanner", name)
		ui.open()

/datum/action/cooldown/spell/architect_plan/ui_static_data(mob/user)
	return get_blueprint_static_tgui_data()

/datum/action/cooldown/spell/architect_plan/ui_data(mob/user)
	var/mob/living/L = owner || user
	var/list/data = list()
	if(istype(L))
		data["saved_grid"] = L.arcyne_blueprint_data
		data["saved_floors"] = L.arcyne_blueprint_floors
		data["scanned_grid"] = scanned_grid
	return data

/datum/action/cooldown/spell/architect_plan/ui_act(action, params)
	. = ..()
	if(.) return

	var/mob/living/L = owner || usr
	if(!istype(L)) return

	if(action == "scan_terrain")
		var/radius = min(params["radius"] || 13, MAX_SPELL_RADIUS)
		var/max_z = clamp(text2num(params["max_floors"]) || 2, 2, 4)
		var/turf/center = get_turf(L)
		var/list/scanned = list()
		for(var/dx in -radius to radius)
			for(var/dy in -radius to radius)
				for(var/dz in 0 to max_z - 1)
					var/turf/T = get_blueprint_target_turf(center, dx, dy, dz)
					if(!T) continue

					var/is_blocked = FALSE
					if(isclosedturf(T))
						is_blocked = TRUE
					else
						for(var/obj/O in T)
							if(O.density && (istype(O, /obj/structure) || istype(O, /obj/machinery)))
								is_blocked = TRUE
								break

					if(is_blocked)
						scanned += list(list("x"=dx, "y"=dy, "z"=dz, "layer"="wall"))
					else if(!istype(T, /turf/open/openspace) && !istype(T, /turf/open/water))
						scanned += list(list("x"=dx, "y"=dy, "z"=dz, "layer"="floor"))

		scanned_grid = scanned
		return TRUE

	if(action == "save_design")
		var/list/packed_data = params["packed_data"]
		var/list/safe_data = list()
		for(var/b_type in packed_data)
			var/list/coords = packed_data[b_type]
			for(var/coord_str in coords)
				var/list/parts = splittext(coord_str, ",")
				if(length(parts) < 3) continue

				var/dx = text2num(parts[1])
				var/dy = text2num(parts[2])
				var/dz = text2num(parts[3])
				var/ddir = length(parts) >= 4 ? text2num(parts[4]) : 2

				if(abs(dx) > MAX_SPELL_RADIUS || abs(dy) > MAX_SPELL_RADIUS)
					continue

				safe_data += list(list(
					"x" = dx,
					"y" = dy,
					"z" = dz,
					"type" = b_type,
					"dir" = ddir
				))

		L.arcyne_blueprint_data = safe_data
		L.arcyne_blueprint_floors = clamp(text2num(params["max_floors"]) || 2, 2, 4)
		to_chat(L, span_notice("Архитектурный план сохранен в памяти!"))
		L.balloon_alert(L, "План сохранен в памяти!")
		SStgui.close_uis(src)
		return TRUE
	if(action == "clear_design")
		L.arcyne_blueprint_data = list()
		to_chat(L, span_notice("План в памяти стерт."))
		return TRUE

/datum/action/cooldown/spell/architect_conjure
	name = "Материализация Матрицы"
	desc = "Сотворяет сохраненный строительный план на указанном участке земли."
	button_icon = 'icons/mob/actions/roguespells.dmi'
	button_icon_state = "shieldsparkles"
	panel = "Spells"
	spell_color = "#00e1ff"
	click_to_activate = TRUE
	charge_required = FALSE
	cast_range = 7
	cooldown_time = 30 SECONDS
	primary_resource_type = SPELL_COST_ENERGY
	primary_resource_cost = 10
	sound = 'sound/magic/charge_ready.ogg'
	sparks_amt = 2
	invocation_type = INVOCATION_WHISPER
	invocations = list("Struo et Creo...", "Forma Materia...")

/datum/action/cooldown/spell/architect_conjure/is_valid_target(atom/cast_on)
	. = ..()
	if(!.) return FALSE
	if(!owner) return FALSE

	var/turf/T = get_turf(cast_on)
	if(!isturf(T))
		return FALSE

	return TRUE

/datum/action/cooldown/spell/architect_conjure/cast(atom/cast_on)
	. = ..()
	var/turf/T = get_turf(cast_on)
	if(!T || !owner)
		return

	if(!length(owner.arcyne_blueprint_data))
		owner.balloon_alert(owner, "Нет проекта в памяти!")
		to_chat(owner, span_warning("Ваш разум пуст... Магическая энергия рассеялась впустую! Сначала используйте 'Тайное Проектирование'."))
		return

	if(!check_blueprint_placement_valid(T, owner, owner.arcyne_blueprint_data, owner.arcyne_blueprint_floors))
		owner.balloon_alert(owner, "Ошибка материализации!")
		to_chat(owner, span_warning("Неверное расположение! Матрица с треском разрушилась, потратив вашу энергию."))
		return

	var/obj/structure/blueprint_site/site = new(T)
	site.max_floors = owner.arcyne_blueprint_floors
	site.setup_design(owner.arcyne_blueprint_data, owner)

	owner.balloon_alert(owner, "Матрица создана!")
	owner.visible_message(
		span_notice("[owner] материализует строительную матрицу на [owner.arcyne_blueprint_floors] эт.!"),
		span_notice("Вы сплели тайные потоки, успешно материализовав матрицу на [owner.arcyne_blueprint_floors] эт.!")
	)
	return TRUE


/proc/check_blueprint_placement_valid(turf/origin_turf, mob/user, list/design_data, max_floors)
	if(!origin_turf || !length(design_data))
		return FALSE

	var/list/future_grid = list()
	var/list/future_types = list()

	for(var/entry in design_data)
		var/dx = isnum(entry["x"]) ? entry["x"] : text2num(entry["x"])
		var/dy = isnum(entry["y"]) ? entry["y"] : text2num(entry["y"])
		var/dz = isnum(entry["z"]) ? entry["z"] : (text2num(entry["z"]) || 0)
		if(dz >= max_floors) continue

		var/b_type = entry["type"]
		var/list/info = GLOB.blueprint_buildable_types[b_type]
		if(!info) continue

		var/key = "[dx]_[dy]_[dz]"
		if(!future_grid[key])
			future_grid[key] = list()
			future_types[key] = list()
		future_grid[key] += info["layer_type"]
		future_types[key] += b_type

	for(var/entry in design_data)
		var/dx = isnum(entry["x"]) ? entry["x"] : text2num(entry["x"])
		var/dy = isnum(entry["y"]) ? entry["y"] : text2num(entry["y"])
		var/dz = isnum(entry["z"]) ? entry["z"] : (text2num(entry["z"]) || 0)
		if(dz >= max_floors) continue

		var/b_type = entry["type"]
		var/list/info = GLOB.blueprint_buildable_types[b_type]
		if(!info) continue

		var/turf/target_turf = get_blueprint_target_turf(origin_turf, dx, dy, dz)
		if(!target_turf)
			to_chat(user, span_warning("Недостаточно места: план выходит за пределы мира!"))
			return FALSE

		if(isclosedturf(target_turf))
			to_chat(user, span_warning("Нельзя строить: на клетке ([target_turf.x], [target_turf.y]) уже стоит стена ([target_turf.name])!"))
			return FALSE

		for(var/obj/structure/S in target_turf)
			if(S.density || istype(S, /obj/structure/mineral_door) || istype(S, /obj/structure/stairs) || istype(S, /obj/structure/blueprint_site))
				to_chat(user, span_warning("Недостаточно места: на клетке ([target_turf.x], [target_turf.y]) находится препятствие ([S.name])!"))
				return FALSE

		for(var/obj/machinery/M in target_turf)
			if(M.density)
				to_chat(user, span_warning("Недостаточно места: на пути находится станок ([M.name])!"))
				return FALSE

	return TRUE

/proc/get_blueprint_static_tgui_data()
	var/list/data = list()
	var/list/types_data = list()

	for(var/key in GLOB.blueprint_buildable_types)
		var/list/info = GLOB.blueprint_buildable_types[key]
		var/atom/build_path = info["path"]

		var/i_file = info["icon_file"] || initial(build_path.icon)
		var/i_state = info["icon_state"] || initial(build_path.icon_state)

		if(!info["image"])
			var/icon/I = icon(i_file, i_state, SOUTH, 1)
			info["image"] = icon2base64(I)

		var/list/reqs_list = get_blueprint_reqs(info)
		var/reqs_text = ""
		for(var/r_path in reqs_list)
			var/obj/item/temp = r_path
			reqs_text += "[initial(temp.name)] x[reqs_list[r_path]], "
		if(length(reqs_text) > 2)
			reqs_text = copytext(reqs_text, 1, length(reqs_text) - 1)

		types_data[key] = list(
			"name" = info["name"],
			"category" = info["category"],
			"layer_type" = info["layer_type"],
			"reqs_text" = reqs_text,
			"image" = info["image"]
		)

	data["buildable_types"] = types_data
	return data

/proc/get_blueprint_reqs(list/info)
	if(islist(info["reqs"]))
		return info["reqs"]

	if(ispath(info["reqs"], /datum/crafting_recipe))
		var/craft_path = info["reqs"]
		var/datum/crafting_recipe/dummy = new craft_path()
		var/list/actual_reqs = list()
		for(var/req_key in dummy.reqs)
			actual_reqs[req_key] = dummy.reqs[req_key]

		info["reqs"] = actual_reqs
		qdel(dummy)

		return actual_reqs

	return list()

#undef MAX_PLANNER_RADIUS
#undef MAX_SPELL_RADIUS
