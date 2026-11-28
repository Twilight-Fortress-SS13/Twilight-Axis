// К сожалению, мы не можем просто указать gem_socketable = TRUE в базовом классе,
// иначе это унаследовал бы любой новый посох или донаторский скин от оффов.
// Это решение может и не самое элегантное, но наиболее future-proof.
GLOBAL_LIST_INIT(socketable_staves, typecacheof(list(
	/obj/item/rogueweapon/woodstaff/implement,
	/obj/item/rogueweapon/woodstaff/implement/empty,
	/obj/item/rogueweapon/woodstaff/implement/amethyst,
	/obj/item/rogueweapon/woodstaff/implement/greater,
	/obj/item/rogueweapon/woodstaff/implement/greater/sapphire,
	/obj/item/rogueweapon/woodstaff/implement/greater/quartz,
	/obj/item/rogueweapon/woodstaff/implement/greater/ruby,
	/obj/item/rogueweapon/woodstaff/implement/grand,
	/obj/item/rogueweapon/woodstaff/implement/grand/riddle,
	/obj/item/rogueweapon/woodstaff/implement/greater/blacksteel,
	/obj/item/rogueweapon/woodstaff/implement/greater/blacksteel/ruby,
	/obj/item/rogueweapon/woodstaff/implement/greater/blacksteel/empty,
), only_root_path = TRUE))

/obj/item/rogueweapon/woodstaff/implement
	starting_gem_type = /obj/item/roguegem/yellow
	implement_noun = "staff"
	desc = "A mage's staff with a setting for a focus-gem. The gem captures excess energy dissipated into the air when a spell is cast, giving a share of it back to the wielder."
	force_wielded = 25

	// Префикс модульных спрайтов "[gem_state_base]_[гем]"
	var/gem_state_base
	// Ключ набора рескинов в GLOB.staff_skins, безопасно наследуется оффовскими.
	var/skin_set = "wooden"

/obj/item/rogueweapon/woodstaff/implement/Initialize(mapload)
	// См. причину в начале файла
	gem_socketable = !!GLOB.socketable_staves[type]
	return ..()

/obj/item/rogueweapon/woodstaff/implement/apply_gem_stats(list/stats)
	implement_refund = stats ? stats["refund"] : 0

/obj/item/rogueweapon/woodstaff/implement/proc/get_gem_icon_state(key)
	if(gem_state_base)  // Дефолтимся на оффовские стейты
		return "[gem_state_base]_[key || "gemless"]"
	return key ? "[key]staff" : "gemless"

/obj/item/rogueweapon/woodstaff/implement/update_gem_icon(list/stats)
	var/new_state = get_gem_icon_state(stats ? stats["key"] : null)
	override_state = new_state
	icon_state = new_state
	update_transform()
	update_icon()

/obj/item/rogueweapon/woodstaff/implement/empty
	starting_gem_type = null
	icon_state = "gemless"
	sellprice = 0 // Crafted: the pricing engine derives it from the recipe.

/obj/item/rogueweapon/woodstaff/implement/amethyst
	starting_gem_type = /obj/item/roguegem/amethyst

/obj/item/rogueweapon/woodstaff/implement/greater
	desc = "A fine mage's staff with a setting for a focus-gem. The gem captures excess energy dissipated into the air when a spell is cast, giving a generous share of it back to the wielder."
	starting_gem_type = /obj/item/roguegem/green
	force_wielded = 25
	max_integrity = 200
	sellprice = 12

/obj/item/rogueweapon/woodstaff/implement/greater/sapphire
	starting_gem_type = /obj/item/roguegem/violet

/obj/item/rogueweapon/woodstaff/implement/greater/quartz
	starting_gem_type = /obj/item/roguegem/blue

/obj/item/rogueweapon/woodstaff/implement/greater/ruby
	starting_gem_type = /obj/item/roguegem/ruby

/obj/item/rogueweapon/woodstaff/implement/grand
	desc = "A masterwork staff with a setting for a focus-gem. The gem captures excess energy dissipated into the air when a spell is cast, giving most of it back to the wielder - arcyne economy refined to an art."
	starting_gem_type = /obj/item/roguegem/diamond
	force_wielded = 25
	max_integrity = 200
	sellprice = 12

/obj/item/rogueweapon/woodstaff/implement/grand/riddle
	starting_gem_type = /obj/item/riddleofsteel

// Черносталевая основа

/obj/item/rogueweapon/woodstaff/implement/greater/blacksteel
	icon = 'modular_twilight_axis/icons/obj/items/staffs.dmi'
	icon_state = "blacksteelstaff_diamond"
	gem_state_base = "blacksteelstaff"
	skin_set = null  // Пока у нас нет скинов на черносталь
	starting_gem_type = /obj/item/roguegem/diamond
	implement_noun = "blacksteel staff"
	desc = "A fine wood staff reinforced with blacksteel rivets and furnishings, carried by War-Magos who graduated from the Celestial Academy of Magos. Its crown holds a focus-gem."
	force_wielded = 30
	max_integrity = 300
	sellprice = 25

/obj/item/rogueweapon/woodstaff/implement/greater/blacksteel/ruby
	icon_state = "blacksteelstaff_ruby"
	starting_gem_type = /obj/item/roguegem/ruby

/obj/item/rogueweapon/woodstaff/implement/greater/blacksteel/empty
	icon_state = "blacksteelstaff_gemless"
	starting_gem_type = null

// Посох придворного мага считается черносталевым с загадкой стали по умолчанию,
// однако было решено оставить его уникальным несоставным посохом.
/obj/item/rogueweapon/woodstaff/implement/grand/magos
	force_wielded = 30
	max_integrity = 300
