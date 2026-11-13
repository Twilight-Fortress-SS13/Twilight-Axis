/obj/item/rogueweapon/woodstaff/implement
	gem_socketable = TRUE
	starting_gem_type = /obj/item/roguegem/yellow
	implement_noun = "staff"
	desc = "A mage's staff with a setting for a focus-gem. The gem captures excess energy dissipated into the air when a spell is cast, giving a share of it back to the wielder."
	implement_refund = 0
	implement_tier = 0
	force_wielded = 25

/obj/item/rogueweapon/woodstaff/implement/apply_gem_stats(list/stats)
	implement_refund = stats ? stats["refund"] : 0
	implement_cast_speed = 0

// Получаем стейт для
/obj/item/rogueweapon/woodstaff/implement/proc/get_gem_icon_state(key)
	return key ? "[key]staff" : "gemless"

/obj/item/rogueweapon/woodstaff/implement/update_gem_icon(list/stats)
	var/new_state = get_gem_icon_state(stats ? stats["key"] : null)
	override_state = new_state // Wielded sprites are "[override_state]1".
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
	starting_gem_type = /obj/item/roguegem/diamond
	implement_noun = "blacksteel staff"
	desc = "A fine wood staff reinforced with blacksteel rivets and furnishings, carried by War-Magos who graduated from the Celestial Academy of Magos. Its crown holds a focus-gem."
	force_wielded = 30
	max_integrity = 300
	sellprice = 25

// Спрайты наших модульных посохов названы по-человечески "[base]_[gem]", а не "[gem]staff" как у оффов
/obj/item/rogueweapon/woodstaff/implement/greater/blacksteel/get_gem_icon_state(key)
	return key ? "blacksteelstaff_[key]" : "blacksteelstaff_gemless"

/obj/item/rogueweapon/woodstaff/implement/greater/blacksteel/ruby
	icon_state = "blacksteelstaff_ruby"
	starting_gem_type = /obj/item/roguegem/ruby

/obj/item/rogueweapon/woodstaff/implement/greater/blacksteel/empty
	icon_state = "blacksteelstaff_gemless"
	starting_gem_type = null

// Все случаи посохов внизу рассматриваются как уникальные и не являются составными посохами

// Посох придворного мага считается черносталевым с загадкой стали по умолчанию
/obj/item/rogueweapon/woodstaff/implement/grand/magos
	gem_socketable = FALSE
	starting_gem_type = null
	implement_tier = 3
	implement_refund = IMPLEMENT_REFUND_RIDDLE
	force_wielded = 30
	max_integrity = 300

/obj/item/rogueweapon/woodstaff/implement/grand/naledi
	gem_socketable = FALSE
	starting_gem_type = null
	implement_tier = 2
	implement_refund = IMPLEMENT_REFUND_RONTZ

/obj/item/rogueweapon/scabbard/sheath/courtphysician/hand
	implement_tier = 2
	implement_refund = IMPLEMENT_REFUND_RONTZ

// Посохи-фамильяры

/obj/item/rogueweapon/woodstaff/implement/greater/elemental
	gem_socketable = FALSE
	starting_gem_type = null
	implement_tier = 2
	implement_refund = IMPLEMENT_REFUND_BLORTZ

/obj/item/rogueweapon/woodstaff/implement/greater/infernal
	gem_socketable = FALSE
	starting_gem_type = null
	implement_tier = 2
	implement_refund = IMPLEMENT_REFUND_RONTZ

// Донатерские рескины

/obj/item/rogueweapon/woodstaff/implement/morto
	gem_socketable = FALSE
	starting_gem_type = null
	implement_tier = 1
	implement_refund = IMPLEMENT_REFUND_TOPER

/obj/item/rogueweapon/woodstaff/implement/racobio
	gem_socketable = FALSE
	starting_gem_type = null
	implement_tier = 1
	implement_refund = IMPLEMENT_REFUND_TOPER

/obj/item/rogueweapon/woodstaff/implement/greater/blacksteel/donator_rhynn
	gem_socketable = FALSE
	starting_gem_type = null
	implement_tier = 3
	implement_refund = IMPLEMENT_REFUND_DORPEL
