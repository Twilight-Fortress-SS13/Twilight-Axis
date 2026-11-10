/obj/item/rogueweapon/spellbook
	base_implement_name = "amythortz tome"
	name = "\improper amythortz tome of the arcyne"
	desc = "A crackling, glowing book with an amythortz set into its cover, filled with runes and symbols that hurt the mind to stare at. It can rebind aspect spells and hastens spell incantations."
	force = 25
	max_integrity = 120
	implement_tier = 1
	implement_refund = 0
	implement_cast_speed = IMPLEMENT_CAST_SPEED_AMETHYST

/obj/item/rogueweapon/spellbook/toper
	base_implement_name = "toper tome"
	name = "\improper toper tome of the arcyne"
	desc = "A crackling, glowing book with a toper set into its cover, filled with runes and symbols that hurt the mind to stare at. It can rebind aspect spells and hastens spell incantations."
	implement_cast_speed = IMPLEMENT_CAST_SPEED_TOPER

/obj/item/rogueweapon/spellbook/greater
	base_implement_name = "gemerald tome"
	name = "\improper gemerald tome of the arcyne"
	desc = "A well-bound arcyne tome with a gemerald set into its cover. It can rebind aspect spells and hastens spell incantations."
	implement_tier = 2
	implement_refund = 0
	implement_cast_speed = IMPLEMENT_CAST_SPEED_GEMERALD

/obj/item/rogueweapon/spellbook/sapphire
	base_implement_name = "saffira tome"
	name = "\improper saffira tome of the arcyne"
	desc = "A well-bound arcyne tome with a saffira set into its cover. It can rebind aspect spells and hastens spell incantations."
	sellprice = 25
	implement_tier = 2
	implement_cast_speed = IMPLEMENT_CAST_SPEED_SAFFIRA

/obj/item/rogueweapon/spellbook/quartz
	base_implement_name = "blortz tome"
	name = "\improper blortz tome of the arcyne"
	desc = "A well-bound arcyne tome with a blortz set into its cover. It can rebind aspect spells and hastens spell incantations."
	sellprice = 25
	implement_tier = 2
	implement_cast_speed = IMPLEMENT_CAST_SPEED_BLORTZ

/obj/item/rogueweapon/spellbook/ruby
	base_implement_name = "rontz tome"
	name = "\improper rontz tome of the arcyne"
	desc = "A well-bound arcyne tome with a rontz set into its cover. It can rebind aspect spells and hastens spell incantations."
	sellprice = 25
	implement_tier = 2
	implement_cast_speed = IMPLEMENT_CAST_SPEED_RONTZ

/obj/item/rogueweapon/spellbook/grand
	base_implement_name = "dorpel tome"
	name = "\improper dorpel tome of the arcyne"
	desc = "A masterwork arcyne tome with a dorpel set into its cover. It can rebind aspect spells and greatly hastens spell incantations."
	implement_tier = 3
	implement_refund = 0
	implement_cast_speed = IMPLEMENT_CAST_SPEED_DORPEL

/obj/item/rogueweapon/spellbook/riddle
	base_implement_name = "riddlesteel tome"
	name = "\improper riddlesteel tome of the arcyne"
	desc = "A masterwork arcyne tome with a riddle of steel set into its cover. It hastens the gathering of a spell like nothing else."
	sellprice = 50
	implement_tier = 3
	implement_cast_speed = IMPLEMENT_CAST_SPEED_RIDDLE

/obj/item/rogueweapon/spellbook/examine(mob/user)
	. = ..()
	if(implement_cast_speed)
		. += span_notice("When held while casting, this implement shortens the time needed to gather a spell by [round(implement_cast_speed * 100)]%.")
