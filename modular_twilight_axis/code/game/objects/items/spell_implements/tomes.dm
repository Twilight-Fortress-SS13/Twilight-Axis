/obj/item/rogueweapon/spellbook
	gem_socketable = TRUE
	starting_gem_type = /obj/item/roguegem/amethyst
	implement_noun = "tome"
	desc = "A crackling, glowing book filled with runes and symbols that hurt the mind to stare at, with a setting for a focus-gem in its cover. It can rebind aspect spells and hastens spell incantations."
	force = 25
	max_integrity = 120
	sellprice = 12
	implement_tier = 0
	implement_refund = 0
	implement_cast_speed = 0

/obj/item/rogueweapon/spellbook/apply_gem_stats(list/stats)
	implement_cast_speed = stats ? stats["cast_speed"] : 0
	implement_refund = 0

// Сохраняем название после рескина
/obj/item/rogueweapon/spellbook/update_gem_name(list/stats)
	var/label = stats ? stats["label"] : "unfitted"
	var/quality = get_quality_name_prefix()
	base_implement_name = "[quality][label] [implement_noun]"
	if(!picked)
		name = "\improper [quality][label] [implement_noun] of the arcyne"

/obj/item/rogueweapon/spellbook/empty
	starting_gem_type = null
	sellprice = 0

/obj/item/rogueweapon/spellbook/toper
	starting_gem_type = /obj/item/roguegem/yellow

/obj/item/rogueweapon/spellbook/greater
	desc = "A well-bound arcyne tome with a setting for a focus-gem in its cover. It can rebind aspect spells and significantly hastens spell incantations"
	starting_gem_type = /obj/item/roguegem/green
	force = 25
	max_integrity = 120
	sellprice = 12

/obj/item/rogueweapon/spellbook/sapphire
	starting_gem_type = /obj/item/roguegem/violet

/obj/item/rogueweapon/spellbook/quartz
	starting_gem_type = /obj/item/roguegem/blue

/obj/item/rogueweapon/spellbook/ruby
	starting_gem_type = /obj/item/roguegem/ruby

/obj/item/rogueweapon/spellbook/grand
	desc = "A masterwork arcyne tome with a setting for a focus-gem in its cover. It can rebind aspect spells and greatly hastens spell incantations."
	starting_gem_type = /obj/item/roguegem/diamond
	force = 25
	max_integrity = 120
	sellprice = 12

/obj/item/rogueweapon/spellbook/riddle
	starting_gem_type = /obj/item/riddleofsteel
