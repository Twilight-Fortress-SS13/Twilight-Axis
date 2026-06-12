#define TAT_TRADER_LOOTBOX_POTION 4
#define TAT_TRADER_LOOTBOX_CLOTHES 5

// Base merchant chest goods. This is the only always-visible market pool.
GLOBAL_LIST_INIT(tat_trader_chest_base_pool, list(
	/obj/item/clothing/suit/roguetown/armor/plate/full/bronze = 4,
	/obj/item/clothing/suit/roguetown/armor/plate/full/bronze/alt = 4,
	/obj/item/clothing/neck/roguetown/bevor/bronze = 10,
	/obj/item/clothing/neck/roguetown/gorget/bronze = 10,
	/obj/item/clothing/neck/roguetown/gorget/copper = 10,
	/obj/item/clothing/neck/roguetown/luckcharm = 10,
	/obj/item/clothing/neck/roguetown/psicross/shell = 10,
	/obj/item/clothing/neck/roguetown/psicross/shell/bracelet = 10,
	/obj/item/clothing/neck/roguetown/shalal = 10,
	/obj/item/storage/gadget/messkit = 13,
	/obj/item/mobilestove = 13,
	/obj/item/tent_kit = 11,
	/obj/item/tent_kit/ger = 12,
	/obj/item/tent_kit/yurt = 9,
	/obj/item/folding_table_stored = 13,
	/obj/item/clothing/ring/aalloy = 10,
	/obj/item/clothing/ring/amber = 10,
	/obj/item/clothing/ring/band = 10,
	/obj/item/clothing/ring/band/aalloy = 10,
	/obj/item/clothing/ring/band/bronze = 10,
	/obj/item/clothing/ring/band/gold = 10,
	/obj/item/clothing/ring/band/paalloy = 10,
	/obj/item/clothing/ring/bronze = 10,
	/obj/item/clothing/ring/rose = 10,
	/obj/item/clothing/ring/shell = 10,
	/obj/item/clothing/ring/silver = 10,
	/obj/item/clothing/suit/roguetown/armor/chainmail/aalloy = 10,
	/obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/aalloy = 10,
	/obj/item/clothing/suit/roguetown/armor/plate/bronze = 10,
	/obj/item/clothing/suit/roguetown/armor/plate/bronze/light = 10,
	/obj/item/clothing/suit/roguetown/armor/plate/cuirass/copper = 10,
	/obj/item/reagent_containers/glass/cup/tin = 10,
	/obj/item/reagent_containers/glass/cup/tin/small = 10,
	/obj/item/clothing/neck/roguetown/psicross/astrata/bronze = 12,
	/obj/item/clothing/neck/roguetown/psicross/bronze = 12,
	/obj/item/clothing/neck/roguetown/psicross/inhumen/bronze = 12,
	/obj/item/clothing/neck/roguetown/psicross/inhumen/graggar/bronze = 12,
	/obj/item/clothing/neck/roguetown/psicross/malum/bronze = 12,
	/obj/item/clothing/neck/roguetown/psicross/noc/bronze = 12,
	/obj/item/clothing/neck/roguetown/psicross/ravox/bronze = 12,
	/obj/item/flashlight/flare/torch/lantern/bronzelamptern = 12,
	/obj/item/folding_alchcauldron_stored = 5,
	/obj/item/folding_alchstation_stored = 5,
	/obj/item/grapplinghook = 4,
	/obj/item/quiver/bolt/bronze = 9,
	/obj/item/quiver/bolt/heavy/bronze = 9,
	/obj/item/quiver/javelin/bronze = 5,
	/obj/item/quiver/sling/bronze = 12,
	/obj/item/rogueweapon/flail/bronze = 9,
	/obj/item/rogueweapon/greataxe/bronze = 5,
	/obj/item/rogueweapon/huntingknife/bronze = 12,
	/obj/item/rogueweapon/huntingknife/combat/bronze = 9,
	/obj/item/rogueweapon/katar/bronze = 9,
	/obj/item/rogueweapon/katar/bronze/gladiator = 9,
	/obj/item/rogueweapon/mace/bronze = 9,
	/obj/item/rogueweapon/mace/warhammer/bronze = 9,
	/obj/item/rogueweapon/pick/bronze = 9,
	/obj/item/rogueweapon/shield/bronze = 9,
	/obj/item/rogueweapon/shield/bronze/great = 5,
	/obj/item/rogueweapon/spear/bronze = 9,
	/obj/item/rogueweapon/spear/bronze/strapless = 9,
	/obj/item/rogueweapon/spear/bronze/winged = 5,
	/obj/item/rogueweapon/spear/bronze/winged/strapless = 5,
	/obj/item/rogueweapon/spear/trident = 2,
	/obj/item/rogueweapon/stoneaxe/woodcut/bronzebattleaxe = 9,
	/obj/item/rogueweapon/sword/bronze = 9,
	/obj/item/rogueweapon/sword/falchion/militia/bronze = 9,
	/obj/item/rogueweapon/sword/long/broadsword/bronze = 5,
	/obj/item/rogueweapon/sword/sabre/bronzekhopesh = 5,
	/obj/item/rogueweapon/sword/short/gladius = 9,
	/obj/item/rogueweapon/sword/short/messer/bronze = 9,
	/obj/item/rogueweapon/whip/bronze = 9,
	/obj/item/storage/hip/headhook/bronze = 9,
	/obj/item/clothing/neck/roguetown/bevor = 7,
	/obj/item/clothing/neck/roguetown/chaincoif = 7,
	/obj/item/clothing/neck/roguetown/chaincoif/chainmantle = 7,
	/obj/item/clothing/neck/roguetown/chaincoif/full = 7,
	/obj/item/clothing/neck/roguetown/chaincoif/iron = 7,
	/obj/item/clothing/neck/roguetown/fencerguard = 7,
	/obj/item/clothing/neck/roguetown/gorget/steel = 7,
	/obj/item/clothing/neck/roguetown/horus = 7,
	/obj/item/clothing/neck/roguetown/ornateamulet = 7,
	/obj/item/clothing/neck/roguetown/ornateamulet/noble = 7,
	/obj/item/clothing/neck/roguetown/psicross/g = 7,
	/obj/item/clothing/neck/roguetown/psicross/malum = 7,
	/obj/item/clothing/neck/roguetown/psicross/silver = 7,
	/obj/item/clothing/neck/roguetown/psicross/silver/astrata = 7,
	/obj/item/clothing/neck/roguetown/psicross/silver/necra = 7,
	/obj/item/clothing/neck/roguetown/psicross/silver/noc = 7,
	/obj/item/clothing/neck/roguetown/psicross/silver/undivided = 7,
	/obj/item/clothing/neck/roguetown/skullamulet = 7,
	/obj/item/clothing/neck/roguetown/talkstone = 7,
	/obj/item/clothing/ring/coral = 7,
	/obj/item/clothing/ring/diamond = 7,
	/obj/item/clothing/ring/diamonds = 7,
	/obj/item/clothing/ring/duelist = 7,
	/obj/item/clothing/ring/emerald = 7,
	/obj/item/clothing/ring/emeralds = 7,
	/obj/item/clothing/ring/gold = 7,
	/obj/item/clothing/ring/jade = 7,
	/obj/item/clothing/ring/onyxa = 7,
	/obj/item/clothing/ring/opal = 7,
	/obj/item/clothing/ring/quartz = 7,
	/obj/item/clothing/ring/quartzs = 7,
	/obj/item/clothing/ring/ruby = 7,
	/obj/item/clothing/ring/rubys = 7,
	/obj/item/clothing/ring/sapphire = 7,
	/obj/item/clothing/ring/sapphires = 7,
	/obj/item/clothing/ring/signet = 7,
	/obj/item/clothing/ring/signet/silver = 7,
	/obj/item/clothing/ring/silver/cleric = 7,
	/obj/item/clothing/ring/topaz = 7,
	/obj/item/clothing/ring/topazs = 7,
	/obj/item/clothing/ring/turq = 7,
	/obj/item/clothing/suit/roguetown/armor/brigandine = 7,
	/obj/item/clothing/suit/roguetown/armor/brigandine/heavy = 7,
	/obj/item/clothing/suit/roguetown/armor/brigandine/light = 7,
	/obj/item/clothing/suit/roguetown/armor/chainmail = 7,
	/obj/item/clothing/suit/roguetown/armor/chainmail/bikini = 7,
	/obj/item/clothing/suit/roguetown/armor/chainmail/hauberk = 7,
	/obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/heavy = 7,
	/obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/iron = 7,
	/obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/iron/heavy = 7,
	/obj/item/clothing/suit/roguetown/armor/chainmail/iron = 7,
	/obj/item/clothing/suit/roguetown/armor/chainmail/light = 7,
	/obj/item/clothing/suit/roguetown/armor/chainmail/light/fencer = 7,
	/obj/item/clothing/suit/roguetown/armor/plate = 7,
	/obj/item/clothing/suit/roguetown/armor/plate/bikini = 7,
	/obj/item/clothing/suit/roguetown/armor/plate/cuirass = 7,
	/obj/item/clothing/suit/roguetown/armor/plate/cuirass/fencer = 7,
	/obj/item/clothing/suit/roguetown/armor/plate/cuirass/fluted = 7,
	/obj/item/clothing/suit/roguetown/armor/plate/cuirass/iron = 7,
	/obj/item/clothing/suit/roguetown/armor/plate/iron = 7,
	/obj/item/clothing/suit/roguetown/armor/plate/iron/banded = 7,
	/obj/item/clothing/suit/roguetown/armor/plate/scale = 7,
	/obj/item/clothing/gloves/roguetown/knuckles = 6,
	/obj/item/gun/ballistic/revolver/grenadelauncher/crossbow = 6,
	/obj/item/gun/ballistic/revolver/grenadelauncher/crossbow/heavy = 5,
	/obj/item/gun/ballistic/revolver/grenadelauncher/crossbow/slurbow = 9,
	/obj/item/quiver/bodkin = 6,
	/obj/item/quiver/bolt/heavy/standard = 9,
	/obj/item/quiver/javelin/steel = 8,
	/obj/item/quiver/sling/steel = 9,
	/obj/item/rogueweapon/eaglebeak = 6,
	/obj/item/rogueweapon/estoc = 3,
	/obj/item/rogueweapon/flail/alt = 9,
	/obj/item/rogueweapon/flail/peasantwarflail = 9,
	/obj/item/rogueweapon/flail/sflail = 6,
	/obj/item/rogueweapon/greataxe/steel = 3,
	/obj/item/rogueweapon/greataxe/steel/doublehead = 3,
	/obj/item/rogueweapon/greataxe/steel/knight = 3,
	/obj/item/rogueweapon/greatsword = 6,
	/obj/item/rogueweapon/greatsword/grenz = 3,
	/obj/item/rogueweapon/greatsword/grenz/flamberge = 3,
	/obj/item/rogueweapon/greatsword/miaodao = 1,
	/obj/item/rogueweapon/halberd = 3,
	/obj/item/rogueweapon/halberd/bardiche = 3,
	/obj/item/rogueweapon/halberd/glaive = 1,
	/obj/item/rogueweapon/hammer/steel = 9,
	/obj/item/rogueweapon/handclaw = 3,
	/obj/item/rogueweapon/handclaw/steel = 1,
	/obj/item/rogueweapon/huntingknife/chefknife = 9,
	/obj/item/rogueweapon/huntingknife/chefknife/cleaver = 9,
	/obj/item/rogueweapon/huntingknife/combat/fencerguy = 9,
	/obj/item/rogueweapon/huntingknife/idagger/navaja = 6,
	/obj/item/rogueweapon/huntingknife/idagger/steel = 9,
	/obj/item/rogueweapon/huntingknife/idagger/steel/parrying = 6,
	/obj/item/rogueweapon/huntingknife/scissors/steel = 9,
	/obj/item/rogueweapon/katar = 9,
	/obj/item/rogueweapon/katar/punchdagger = 9,
	/obj/item/rogueweapon/mace/cudgel/flanged = 6,
	/obj/item/rogueweapon/mace/cudgel/psy/old = 6,
	/obj/item/rogueweapon/mace/cudgel/psyclassic/old = 6,
	/obj/item/rogueweapon/mace/goden/steel/kanabo = 6,
	/obj/item/rogueweapon/mace/goden/steel = 6,
	/obj/item/rogueweapon/mace/maul/grand = 3,
	/obj/item/rogueweapon/mace/steel = 6,
	/obj/item/rogueweapon/mace/steel/morningstar = 6,
	/obj/item/rogueweapon/mace/warhammer/steel = 6,
	/obj/item/rogueweapon/pick/steel = 6,
	/obj/item/rogueweapon/shield/tower/metal = 6,
	/obj/item/rogueweapon/spear/assegai = 6,
	/obj/item/rogueweapon/spear/billhook = 6,
	/obj/item/rogueweapon/spear/boar = 6,
	/obj/item/rogueweapon/spear/naginata = 6,
	/obj/item/rogueweapon/spear/partizan = 3,
	/obj/item/rogueweapon/spear/psyspear/old = 6,
	/obj/item/rogueweapon/stoneaxe/battle = 6,
	/obj/item/rogueweapon/stoneaxe/oath = 1,
	/obj/item/rogueweapon/stoneaxe/woodcut/troll = 6,
	/obj/item/rogueweapon/sword/cutlass = 6,
	/obj/item/rogueweapon/sword/falx = 6,
	/obj/item/rogueweapon/sword/long/broadsword/steel = 6,
	/obj/item/rogueweapon/sword/long/greatkhopesh = 6,
	/obj/item/rogueweapon/sword/long/kriegmesser = 3,
	/obj/item/rogueweapon/sword/long/kriegmesser/ssangsudo = 3,
	/obj/item/rogueweapon/sword/long/oldpsysword = 6,
	/obj/item/rogueweapon/sword/rapier = 6,
	/obj/item/rogueweapon/sword/sabre = 6,
	/obj/item/rogueweapon/sword/sabre/mulyeog = 6,
	/obj/item/rogueweapon/sword/short/falchion = 6,
	/obj/item/rogueweapon/sword/short/messer = 9,
	/obj/item/rogueweapon/sword/short/messer/alt = 9,
	/obj/item/rogueweapon/woodstaff/quarterstaff/steel = 6,
	/obj/item/storage/belt/rogue/leather/knifebelt/black/steel = 9,
	/obj/item/reagent_containers/food/snacks/grown/apple/gold = 1,
	/obj/item/clothing/gloves/roguetown/chain/psydon = 2,
	/obj/item/clothing/shoes/roguetown/boots/psydonboots = 2,
))

// Premium merchant chest goods. This pool is sampled into the rotating premium market.
GLOBAL_LIST_INIT(tat_trader_chest_premium_pool, list(
	/obj/item/clothing/ring/amber = 10,
	/obj/item/clothing/neck/roguetown/gorget/gold = 4,
	/obj/item/clothing/neck/roguetown/gorget/gold/king = 4,
	/obj/item/clothing/neck/roguetown/gorget/steel/kazengun = 4,
	/obj/item/clothing/neck/roguetown/psicross/bpearl = 4,
	/obj/item/clothing/neck/roguetown/psicross/inhumen/g = 4,
	/obj/item/clothing/ring/active/nomag = 4,
	/obj/item/clothing/suit/roguetown/armor/plate/cuirass/blacksteel = 3,
	/obj/item/clothing/suit/roguetown/armor/brigandine/banneret = 4,
	/obj/item/clothing/suit/roguetown/armor/brigandine/captain = 4,
	/obj/item/clothing/suit/roguetown/armor/brigandine/haraate = 4,
	/obj/item/clothing/suit/roguetown/armor/heartfelt = 4,
	/obj/item/clothing/suit/roguetown/armor/heartfelt/hand = 4,
	/obj/item/clothing/suit/roguetown/armor/plate/cuirass/fluted/gold = 4,
	/obj/item/clothing/suit/roguetown/armor/plate/cuirass/fluted/gold/heroic = 4,
	/obj/item/clothing/suit/roguetown/armor/plate/cuirass/fluted/gold/king = 4,
	/obj/item/clothing/suit/roguetown/armor/plate/fluted = 4,
	/obj/item/clothing/suit/roguetown/armor/plate/full = 4,
	/obj/item/clothing/suit/roguetown/armor/plate/full/bikini = 4,
	/obj/item/clothing/suit/roguetown/armor/plate/full/fluted = 4,
	/obj/item/clothing/suit/roguetown/armor/plate/otavan = 4,
	/obj/item/clothing/suit/roguetown/armor/plate/silver = 4,
	/obj/item/reagent_containers/glass/cup/golden/psydon = 4,
	/obj/item/rogueweapon/mace/mushroom = 4,
	/obj/item/rogueweapon/shield/tower/metal/psy = 4,
	/obj/item/rogueweapon/stoneaxe/battle/ice = 4,
	/obj/item/rogueweapon/sword/sabre/bane = 4,
	/obj/item/clothing/suit/roguetown/armor/plate/cuirass/fencer/psydon = 2,
	/obj/item/quiver/bolt/heavy/silver = 5,
	/obj/item/quiver/bolt/silver = 5,
	/obj/item/quiver/silver = 5,
	/obj/item/quiver/twilight_bullet/silver = 5,
	/obj/item/rogueweapon/flail/sflail/silver = 3,
	/obj/item/rogueweapon/greataxe/steel/knight/psy = 3,
	/obj/item/rogueweapon/greatsword/bsword/psy = 5,
	/obj/item/rogueweapon/greatsword/silver = 3,
	/obj/item/rogueweapon/handclaw/gronn/silver = 3,
	/obj/item/rogueweapon/huntingknife/idagger/silver = 5,
	/obj/item/rogueweapon/huntingknife/idagger/silver/stake = 8,
	/obj/item/rogueweapon/katar/silver = 5,
	/obj/item/rogueweapon/mace/cudgel/flanged/silver = 3,
	/obj/item/rogueweapon/mace/goden/psymace = 3,
	/obj/item/rogueweapon/mace/steel/silver = 3,
	/obj/item/rogueweapon/mace/warhammer/steel/silver = 3,
	/obj/item/rogueweapon/shovel/silver/preblessed = 8,
	/obj/item/rogueweapon/spear/silver = 3,
	/obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/grenzelhoft = 3,
	/obj/item/rogueweapon/stoneaxe/woodcut/silver = 3,
	/obj/item/rogueweapon/sword/long/exe/silver = 3,
	/obj/item/rogueweapon/sword/long/kriegmesser/silver = 3,
	/obj/item/rogueweapon/sword/long/silver = 3,
	/obj/item/rogueweapon/sword/rapier/silver = 3,
	/obj/item/rogueweapon/sword/short/silver = 5,
	/obj/item/clothing/suit/roguetown/armor/plate/cuirass/legacy = 2,
	/obj/item/rogueweapon/sword/silver = 3,
	/obj/item/rogueweapon/whip/psywhip_lesser = 5,
	/obj/item/rogueweapon/whip/silver = 5,
	/obj/item/rogueweapon/woodstaff/quarterstaff/silver = 5,
	/obj/item/storage/belt/rogue/leather/knifebelt/black/silver = 5,
	/obj/item/reagent_containers/glass/bucket/pot/kettle/tankard/silver = 8,
	/obj/item/clothing/suit/roguetown/armor/plate/full/legacy = 2,
	/obj/item/clothing/suit/roguetown/armor/plate/legacy = 2,
	/obj/item/clothing/suit/roguetown/armor/plate/full/fluted/legacy = 2,
	/obj/item/clothing/suit/roguetown/armor/plate/aalloy = 2,
	/obj/item/clothing/head/roguetown/helmet/blacksteel/modern = 1,
	/obj/item/clothing/gloves/roguetown/plate/blacksteel/modern = 3,
	/obj/item/clothing/under/roguetown/platelegs/blacksteel = 2,
	/obj/item/rogueweapon/greatsword/grenz/flamberge/blacksteel = 2,
	/obj/item/clothing/head/roguetown/helmet/heavy/ordinatorhelm = 1,
	/obj/item/clothing/shoes/roguetown/boots/armor/blacksteel/modern = 2,
	/obj/item/clothing/suit/roguetown/armor/plate/blacksteel/modern = 1,
	/obj/item/clothing/ring/blacksteel = 1,
	/obj/item/clothing/ring/diamondbs = 1,
	/obj/item/clothing/ring/emeraldbs = 1,
	/obj/item/clothing/ring/quartzbs = 1,
	/obj/item/clothing/ring/rubybs = 1,
	/obj/item/clothing/ring/sapphirebs = 1,
	/obj/item/clothing/ring/topazbs = 1,
	/obj/item/clothing/shoes/roguetown/boots/armor/gold = 2,
	/obj/item/clothing/suit/roguetown/armor/plate/cuirass/fluted/ornate = 1,
	/obj/item/clothing/suit/roguetown/armor/plate/fluted/ornate = 2,
	/obj/item/clothing/suit/roguetown/armor/plate/full/fluted/ornate = 2,
	/obj/item/clothing/suit/roguetown/armor/plate/full/fluted/ornate/ordinator = 2,
	/obj/item/clothing/suit/roguetown/armor/plate/paalloy/artificer = 3,
	/obj/item/reagent_containers/glass/bucket/pot/kettle/tankard/blacksteel = 5,
	/obj/item/clothing/gloves/roguetown/chain/contraption/voltic = 3,
	/obj/item/clothing/ring/active/shimmeringlens = 4,
	/obj/item/flashlight/flare/torch/lantern/bronzelamptern/malums_lamptern = 2,
	/obj/item/rogueweapon/huntingknife/idagger/steel/fire = 3,
	/obj/item/rogueweapon/mace/goden/deepduke = 3,

	// Moved from the base market: potions, powders, and national/regional gear.
	/obj/item/rogueweapon/huntingknife/idagger/steel/kazengun = 9,
	/obj/item/rogueweapon/scabbard/sheath/kazengun = 9,
	/obj/item/rogueweapon/scabbard/sword/kazengun = 3,
	/obj/item/rogueweapon/scabbard/sword/kazengun/kodachi = 9,
	/obj/item/rogueweapon/sword/short/kazengun = 6,
	/obj/item/storage/belt/rogue/leather/knifebelt/black/kazengun = 9,
	/obj/item/reagent_containers/glass/bottle/rogue/healthpot = 3,
	/obj/item/reagent_containers/glass/bottle/rogue/healthpotnew = 2,
	/obj/item/reagent_containers/glass/bottle/rogue/manapot = 3,
	/obj/item/reagent_containers/glass/bottle/rogue/strongmanapot = 2,
	/obj/item/reagent_containers/glass/bottle/rogue/stampot = 3,
	/obj/item/reagent_containers/glass/bottle/rogue/strongstampot = 2,
	/obj/item/reagent_containers/glass/bottle/alchemical/strpot = 2,
	/obj/item/reagent_containers/glass/bottle/alchemical/perpot = 2,
	/obj/item/reagent_containers/glass/bottle/alchemical/conpot = 2,
	/obj/item/reagent_containers/glass/bottle/alchemical/spdpot = 2,
	/obj/item/reagent_containers/glass/bottle/alchemical/lucpot = 2,
	/obj/item/reagent_containers/powder/ozium = 3,
	/obj/item/reagent_containers/powder/moondust = 3,
	/obj/item/reagent_containers/powder/moondust_purest = 3,
	/obj/item/reagent_containers/powder/spice = 3,
	/obj/item/reagent_containers/powder/starsugar = 3,
	/obj/item/reagent_containers/powder/herozium = 3,
	/obj/item/reagent_containers/glass/bottle/rogue/stampoison = 3,
	/obj/item/reagent_containers/glass/bottle/rogue/strongpoison = 3,
	/obj/item/reagent_containers/glass/bottle/rogue/poison = 1,
	/obj/item/reagent_containers/glass/bottle/rogue/berrypoison = 4,
	/obj/item/reagent_containers/powder/sleep_powder = 2,
	/obj/item/reagent_containers/powder/corps_dust = 2,
	/obj/item/reagent_containers/powder/grave_powder = 2,
	/obj/item/reagent_containers/powder/inferrum = 2,
	/obj/item/clothing/gloves/roguetown/angle/grenzelgloves = 2,
	/obj/item/clothing/shoes/roguetown/grenzelhoft = 2,
	/obj/item/clothing/under/roguetown/heavy_leather_pants/grenzelpants = 2,
	/obj/item/clothing/suit/roguetown/armor/gambeson/heavy/grenzelhoft = 2,
	/obj/item/clothing/head/roguetown/grenzelhofthat = 2,
	/obj/item/clothing/suit/roguetown/armor/basiceast/captainrobe = 1,
	/obj/item/clothing/shoes/roguetown/armor/rumaclan = 2,
	/obj/item/clothing/shoes/roguetown/grenzelhoft/freifechter = 2,

	// Regional/national sets and potion goods moved from the base market.
	/obj/item/rogueweapon/stoneaxe/battle/steppesman/chupa = 3,
	/obj/item/clothing/gloves/roguetown/eastgloves1 = 2,
	/obj/item/clothing/gloves/roguetown/eastgloves2 = 2,
	/obj/item/clothing/head/roguetown/mentorhat = 2,
	/obj/item/clothing/suit/roguetown/armor/basiceast/mentorsuit = 2,
	/obj/item/clothing/suit/roguetown/armor/basiceast = 2,
	/obj/item/clothing/cloak/eastcloak1 = 2,
	/obj/item/clothing/suit/roguetown/shirt/undershirt/eastshirt1 = 1,
	/obj/item/clothing/suit/roguetown/shirt/undershirt/eastshirt2 = 1,
	/obj/item/clothing/under/roguetown/heavy_leather_pants/otavan/shepherd = 2,
	/obj/item/clothing/suit/roguetown/armor/leather/heavy/shepherd = 2,
	/obj/item/clothing/gloves/roguetown/angle/freifechter = 2,
	/obj/item/clothing/shoes/roguetown/boots/nobleboot/steppesman = 2,
	/obj/item/clothing/suit/roguetown/armor/leather/heavy/coat/steppe = 2,
	/obj/item/clothing/suit/roguetown/shirt/freifechter = 1,
	/obj/item/clothing/under/roguetown/heavy_leather_pants/otavan/generic = 2,
	/obj/item/clothing/suit/roguetown/armor/leather/heavy/gronn = 2,
	/obj/item/clothing/gloves/roguetown/angle/gronn = 2,
	/obj/item/clothing/under/roguetown/trou/leather/gronn = 2,
	/obj/item/clothing/shoes/roguetown/boots/leather/atgervi = 2,
	/obj/item/clothing/gloves/roguetown/angle/atgervi = 2,
	/obj/item/clothing/suit/roguetown/armor/gambeson/heavy/otavan = 2,
	/obj/item/clothing/gloves/roguetown/otavan = 2,
	/obj/item/clothing/shoes/roguetown/boots/otavan = 2,
	/obj/item/clothing/under/roguetown/heavy_leather_pants/otavan = 2
))

/proc/tat_pick_weighted_lootbox_path(list/weighted_paths)
	if(!islist(weighted_paths) || !length(weighted_paths))
		return null

	var/total_weight = 0
	for(var/item_path in weighted_paths)
		var/weight = round(weighted_paths[item_path] || 0)
		if(weight > 0)
			total_weight += weight

	if(total_weight <= 0)
		return null

	var/roll = rand(1, total_weight)
	for(var/item_path in weighted_paths)
		var/weight = round(weighted_paths[item_path] || 0)
		if(weight <= 0)
			continue
		roll -= weight
		if(roll <= 0)
			return item_path

	return null

/proc/tat_add_weighted_lootbox_reward(list/rewards, list/weighted_paths, amount = 1)
	if(!islist(rewards) || amount <= 0)
		return FALSE

	for(var/i in 1 to amount)
		var/item_path = tat_pick_weighted_lootbox_path(weighted_paths)
		if(item_path)
			rewards += item_path

	return TRUE


#define TAT_TRADER_CHEST_DEFAULT_WITHDRAW 10
#define TAT_TRADER_CHEST_MAX_WITHDRAW 5000
#define TAT_TRADER_CHEST_MIN_LIST_PRICE 2
#define TAT_TRADER_CHEST_WRIT_PRICE 1000
#define TAT_TRADER_CHEST_ARTIFACT_BEARER_ITEM_PRICE 800
#define TAT_TRADER_CHEST_SOON_ITEM_PRICE 800
#define TAT_TRADER_CHEST_RARE_PREMIUM_ITEM_PRICE 800
#define TAT_TRADER_CHEST_PRICE_REROLL_INTERVAL (12 MINUTES)
#define TAT_TRADER_CHEST_PRICE_SWING_MIN -50
#define TAT_TRADER_CHEST_PRICE_SWING_MAX 50
#define TAT_TRADER_CHEST_PREMIUM_MARKET_COUNT 10
#define TAT_TRADER_CHEST_PREMIUM_HISTORY_ITERATIONS 4
#define TAT_TRADER_CHEST_SEEN_WEIGHT_DIVISOR 2
#define TAT_TRADER_CHEST_SPECIAL_PREMIUM_PRICE_MULTIPLIER 1.75
#define TAT_TRADER_CHEST_ITEM_DEPOSIT_MULTIPLIER 0.75
#define TAT_TRADER_CHEST_MAX_COIN_STACK 20
#define TAT_TRADER_CHEST_ROCKHILL_KRONA_VALUE 14
#define TAT_TRADER_CHEST_ZENAR_VALUE 10
#define TAT_TRADER_CHEST_ZILIQUA_VALUE 5
#define TAT_TRADER_CHEST_ZENNY_VALUE 1

GLOBAL_LIST_EMPTY(tat_trader_chest_catalog_cache)
GLOBAL_LIST_EMPTY(tat_trader_chest_premium_catalog_cache)
GLOBAL_LIST_EMPTY(tat_trader_chest_icon_cache)
GLOBAL_LIST_EMPTY(tat_trader_chest_base_price_cache)
GLOBAL_LIST_EMPTY(tat_trader_chest_price_overrides_cache)
GLOBAL_LIST_EMPTY(tat_trader_chest_round_sold_special_premium)
// Explicit merchant-sale blocklist. Items here are filtered out even if a dynamic
// premium source, such as TAT artifacts or "soon..." entries, would collect them.
GLOBAL_LIST_INIT(tat_trader_chest_disabled_premium_items, list(
	/obj/item/clothing/neck/roguetown/psicross/weeping,
	/obj/item/clothing/ring/statamythortz,
	/obj/item/clothing/ring/statdorpel,
	/obj/item/clothing/ring/statgemerald,
	/obj/item/clothing/ring/statonyx,
	/obj/item/clothing/ring/statrontz,
	/obj/item/clothing/ring/dragon_ring,
	/obj/item/rogueweapon/sword/long/exe/berserk,
))
GLOBAL_LIST_INIT(tat_trader_chest_special_premium_items, list(
))

/proc/tat_trader_chest_check_user(mob/living/user, silent = FALSE)
	if(!ishuman(user))
		if(!silent)
			to_chat(user, span_warning("Only a living person can use this merchant chest."))
		return FALSE

	if(!HAS_TRAIT(user, TAT_TRAIT_TRADER_LICENSE))
		if(!silent)
			to_chat(user, span_warning("You need a Merchant's Writ to use this merchant chest."))
		return FALSE

	return TRUE

/proc/tat_trader_chest_add_unique_path(list/paths, item_path)
	if(!islist(paths) || !ispath(item_path, /obj/item))
		return FALSE
	if(!(item_path in paths))
		paths += item_path
	return TRUE

/proc/tat_trader_chest_collect_pool_paths(list/paths, list/pool)
	if(!islist(paths) || !islist(pool))
		return FALSE

	for(var/item_path in pool)
		tat_trader_chest_add_unique_path(paths, item_path)

	return TRUE

/proc/tat_trader_chest_collect_enchantment_scroll_paths(list/paths)
	if(!islist(paths))
		return FALSE

	var/random_scroll_path = text2path("/obj/item/book/granter/spell/random")
	if(ispath(random_scroll_path, /obj/item))
		tat_trader_chest_add_unique_path(paths, random_scroll_path)

	// Some codebases expose concrete spell/enchantment scroll subtypes under this parent.
	// Use text2path/typesof so this file stays safe on builds where the parent is absent.
	var/granter_parent = text2path("/obj/item/book/granter/spell")
	if(ispath(granter_parent, /obj/item))
		for(var/scroll_path as anything in typesof(granter_parent))
			if(scroll_path == granter_parent)
				continue
			tat_trader_chest_add_unique_path(paths, scroll_path)

	return TRUE

/proc/tat_trader_chest_collect_tat_items_by_unlock(list/paths, unlock_type, unlock_key)
	if(!islist(paths) || !islist(GLOB.tat_available_items))
		return FALSE

	for(var/item_path in GLOB.tat_available_items)
		var/list/entry = GLOB.tat_available_items[item_path]
		if(!islist(entry))
			continue
		if(entry["unlock_type"] != unlock_type)
			continue
		if(entry["unlock_key"] != unlock_key)
			continue
		tat_trader_chest_add_unique_path(paths, item_path)

	return TRUE

/proc/tat_trader_chest_collect_tat_items_by_slot_group(list/paths, slot_group)
	if(!islist(paths) || !islist(GLOB.tat_available_items))
		return FALSE

	for(var/item_path in GLOB.tat_available_items)
		var/list/entry = GLOB.tat_available_items[item_path]
		if(!islist(entry))
			continue
		if(lowertext("[entry["slot_group"]]") != lowertext("[slot_group]"))
			continue
		tat_trader_chest_add_unique_path(paths, item_path)

	return TRUE

/proc/tat_trader_chest_item_is_rare_silver_or_enduring(item_path, list/entry)
	if(!ispath(item_path, /obj/item) || !islist(entry))
		return FALSE

	var/cost = entry["cost"]
	if(!isnum(cost))
		cost = text2num("[cost]")
	cost = round(cost || 0)

	var/path_text = lowertext("[item_path]")
	var/name_text = lowertext("[entry["name"]]")
	var/category = lowertext("[entry["category"]]")
	var/slot_group = lowertext("[entry["slot_group"]]")

	// Enduring gear is normally named that way in the TAT catalog, while several
	// old Psydonic paths carry the old/oldpsy marker instead. Keep this broad enough
	// for forks, but still limited to paid/rare entries.
	if(cost >= 3 && (findtext(name_text, "enduring") || findtext(path_text, "oldpsy") || findtext(path_text, "/old")))
		return TRUE

	if(entry["unlock_type"] == TAT_UNLOCK_TYPE_WEAPON_SUPPLY && entry["unlock_key"] == TAT_SUPPLY_SILVER)
		if(cost >= 3)
			return TRUE

	if(cost >= 3 && findtext(path_text, "/silver"))
		if(category == TAT_ITEM_CATEGORY_WEAPON || category == TAT_ITEM_CATEGORY_CLOTHING)
			return TRUE
		if(slot_group in list("knife", "sword", "greatsword", "axe", "blunt", "polearm", "whip", "ranged", "munition", "shield", "armor", "head", "neck", "gloves", "shoes", "wrists", "pants", "suit"))
			return TRUE

	return FALSE

/proc/tat_trader_chest_collect_rare_silver_and_enduring_tat_items(list/paths)
	if(!islist(paths) || !islist(GLOB.tat_available_items))
		return FALSE

	for(var/item_path in GLOB.tat_available_items)
		var/list/entry = GLOB.tat_available_items[item_path]
		if(!tat_trader_chest_item_is_rare_silver_or_enduring(item_path, entry))
			continue
		tat_trader_chest_add_unique_path(paths, item_path)

	return TRUE

/proc/tat_trader_chest_get_price_overrides()
	if(length(GLOB.tat_trader_chest_price_overrides_cache))
		return GLOB.tat_trader_chest_price_overrides_cache

	var/list/result = list()

	if(islist(GLOB.tat_available_items))
		for(var/item_path in GLOB.tat_available_items)
			var/list/entry = GLOB.tat_available_items[item_path]
			if(!islist(entry))
				continue

			if(entry["unlock_type"] == TAT_UNLOCK_TYPE_WEAPON_SUPPLY && entry["unlock_key"] == TAT_SUPPLY_ARTIFACTS)
				result[item_path] = TAT_TRADER_CHEST_ARTIFACT_BEARER_ITEM_PRICE
				continue

			if(lowertext("[entry["slot_group"]]") == "soon...")
				result[item_path] = TAT_TRADER_CHEST_SOON_ITEM_PRICE
				continue

			if(tat_trader_chest_item_is_rare_silver_or_enduring(item_path, entry))
				result[item_path] = TAT_TRADER_CHEST_RARE_PREMIUM_ITEM_PRICE

	result[/obj/item/tat_trader_writ] = TAT_TRADER_CHEST_WRIT_PRICE
	GLOB.tat_trader_chest_price_overrides_cache = result
	return result

/proc/tat_trader_chest_get_price_override(item_path)
	var/list/overrides = tat_trader_chest_get_price_overrides()
	if(!islist(overrides) || !(item_path in overrides))
		return null
	return round(overrides[item_path] || 0)

/proc/tat_trader_chest_path_uses_fixed_market_price(item_path)
	return item_path == /obj/item/tat_trader_writ || tat_trader_chest_is_special_premium_item(item_path)

/proc/tat_trader_chest_is_disabled_premium_item(item_path)
	if(!ispath(item_path, /obj/item))
		return FALSE
	for(var/blocked_path in GLOB.tat_trader_chest_disabled_premium_items)
		if(ispath(item_path, blocked_path))
			return TRUE
	return FALSE

/proc/tat_trader_chest_is_special_premium_item(item_path)
	if(!ispath(item_path, /obj/item))
		return FALSE
	for(var/special_path in GLOB.tat_trader_chest_special_premium_items)
		if(ispath(item_path, special_path))
			return TRUE
	return FALSE

/proc/tat_trader_chest_special_premium_sold_this_round(item_path)
	return tat_trader_chest_is_special_premium_item(item_path) && (item_path in GLOB.tat_trader_chest_round_sold_special_premium)

/proc/tat_trader_chest_get_catalog_paths()
	if(length(GLOB.tat_trader_chest_catalog_cache))
		return GLOB.tat_trader_chest_catalog_cache.Copy()

	var/list/result = list()

	// Base market goods. There are exactly two merchant market pools:
	// base goods and premium goods. Nothing else should be sampled directly.
	tat_trader_chest_collect_pool_paths(result, GLOB.tat_trader_chest_base_pool)

	GLOB.tat_trader_chest_catalog_cache = result.Copy()
	return result

/proc/tat_trader_chest_get_premium_catalog_paths()
	if(length(GLOB.tat_trader_chest_premium_catalog_cache))
		return GLOB.tat_trader_chest_premium_catalog_cache.Copy()

	var/list/result = list()

	// Premium market goods. This is the only rotating premium market pool.
	// Dynamic premium sources are folded into the same list below.
	tat_trader_chest_collect_pool_paths(result, GLOB.tat_trader_chest_premium_pool)
	tat_trader_chest_collect_tat_items_by_unlock(result, TAT_UNLOCK_TYPE_WEAPON_SUPPLY, TAT_SUPPLY_ARTIFACTS)
	tat_trader_chest_collect_rare_silver_and_enduring_tat_items(result)
	tat_trader_chest_collect_tat_items_by_slot_group(result, "soon...")
	tat_trader_chest_collect_enchantment_scroll_paths(result)

	for(var/item_path in GLOB.tat_trader_chest_disabled_premium_items)
		result -= item_path

	GLOB.tat_trader_chest_premium_catalog_cache = result.Copy()
	return result

/proc/tat_trader_chest_get_premium_catalog_weights()
	var/list/result = list()

	if(islist(GLOB.tat_trader_chest_premium_pool))
		for(var/item_path in GLOB.tat_trader_chest_premium_pool)
			if(!ispath(item_path, /obj/item))
				continue
			if(tat_trader_chest_is_disabled_premium_item(item_path))
				continue
			result[item_path] = max(1, round(GLOB.tat_trader_chest_premium_pool[item_path] || 1))

	for(var/item_path in tat_trader_chest_get_premium_catalog_paths())
		if(!ispath(item_path, /obj/item))
			continue
		if(item_path in result)
			continue
		if(tat_trader_chest_is_disabled_premium_item(item_path))
			continue
		result[item_path] = 1

	return result

/proc/tat_trader_chest_item_name(item_path)
	if(!ispath(item_path, /obj/item))
		return "[item_path]"

	var/obj/item/I = item_path
	return initial(I.name) || "[item_path]"

/proc/tat_trader_chest_item_type_text(item_path)
	if(!ispath(item_path, /obj/item))
		return "misc"

	var/granter_parent = text2path("/obj/item/book/granter/spell")
	if(granter_parent && ispath(item_path, granter_parent))
		return "enchantment"
	if(item_path == /obj/item/tat_trader_writ)
		return "market"
	if(ispath(item_path, /obj/item/roguecoin))
		return "coin"
	if(ispath(item_path, /obj/item/clothing))
		return "clothing"
	if(ispath(item_path, /obj/item/rogueweapon) || ispath(item_path, /obj/item/gun) || ispath(item_path, /obj/item/ammo_casing) || ispath(item_path, /obj/item/quiver))
		return "weapon"
	if(ispath(item_path, /obj/item/reagent_containers))
		return "alchemy"
	if(ispath(item_path, /obj/item/storage))
		return "storage"
	return "misc"

/proc/tat_trader_chest_get_item_value(obj/item/I)
	if(!I || QDELETED(I))
		return 0

	if(istype(I, /obj/item/roguecoin))
		var/obj/item/roguecoin/C = I
		return max(0, round(C.get_real_price() || 0))

	if("sellprice" in I.vars)
		return max(0, round(I.vars["sellprice"] || 0))

	if("price" in I.vars)
		return max(0, round(I.vars["price"] || 0))

	return 0

/proc/tat_trader_chest_get_item_path_base_price(item_path)
	if(!ispath(item_path, /obj/item))
		return 0

	var/cache_key = "[item_path]"
	if(cache_key in GLOB.tat_trader_chest_base_price_cache)
		return GLOB.tat_trader_chest_base_price_cache[cache_key]

	var/override_price = tat_trader_chest_get_price_override(item_path)
	if(!isnull(override_price))
		GLOB.tat_trader_chest_base_price_cache[cache_key] = max(0, round(override_price || 0))
		return max(0, round(override_price || 0))

	var/obj/item/I = new item_path(null)
	if(!I)
		return 0

	var/value = tat_trader_chest_get_item_value(I)
	qdel(I)

	value = max(0, round(value || 0))
	GLOB.tat_trader_chest_base_price_cache[cache_key] = value
	return value

/proc/tat_trader_chest_build_item_icon_payload(item_path)
	if(!ispath(item_path, /obj/item))
		return null

	var/cache_key = "[item_path]"
	if(cache_key in GLOB.tat_trader_chest_icon_cache)
		return GLOB.tat_trader_chest_icon_cache[cache_key]

	if(islist(GLOB.tat_item_catalog_cache) && (cache_key in GLOB.tat_item_catalog_cache))
		var/list/tat_entry = GLOB.tat_item_catalog_cache[cache_key]
		if(islist(tat_entry) && tat_entry["icon"])
			GLOB.tat_trader_chest_icon_cache[cache_key] = tat_entry["icon"]
			return tat_entry["icon"]

	if(islist(GLOB.tat_available_items) && (item_path in GLOB.tat_available_items))
		var/list/tat_payload = build_tat_item_icon_payload(item_path)
		if(islist(tat_payload) && tat_payload["icon"])
			GLOB.tat_trader_chest_icon_cache[cache_key] = tat_payload["icon"]
			return tat_payload["icon"]

	var/obj/item/preview_item = new item_path(null)
	if(!preview_item)
		return null

	preview_item.update_icon()

	var/icon/preview_icon = new /icon(preview_item.icon, preview_item.icon_state, SOUTH)
	if(!preview_icon)
		qdel(preview_item)
		return null

	preview_icon.Scale(32, 32)
	var/icon_payload = icon2base64(preview_icon)
	GLOB.tat_trader_chest_icon_cache[cache_key] = icon_payload
	qdel(preview_item)
	return icon_payload

/proc/tat_trader_coin_value_list()
	if(SSmapping.config.map_name == "Rockhill")
		return list(
			list("path" = /obj/item/roguecoin/goldkrona, "value" = TAT_TRADER_CHEST_ROCKHILL_KRONA_VALUE),
			list("path" = /obj/item/roguecoin/copper, "value" = TAT_TRADER_CHEST_ZENNY_VALUE),
		)

	return list(
		list("path" = /obj/item/roguecoin/gold, "value" = TAT_TRADER_CHEST_ZENAR_VALUE),
		list("path" = /obj/item/roguecoin/silver, "value" = TAT_TRADER_CHEST_ZILIQUA_VALUE),
		list("path" = /obj/item/roguecoin/copper, "value" = TAT_TRADER_CHEST_ZENNY_VALUE),
	)

/proc/tat_trader_spawn_coin_stack(mob/living/carbon/human/user, coin_path, amount)
	if(!user || !ispath(coin_path, /obj/item/roguecoin))
		return FALSE

	amount = max(0, round(amount || 0))
	if(amount <= 0)
		return FALSE

	var/success = FALSE
	while(amount > 0)
		var/stack_amount = min(amount, TAT_TRADER_CHEST_MAX_COIN_STACK)
		var/obj/item/roguecoin/coin = new coin_path(get_turf(user))
		if(!coin)
			return success

		coin.set_quantity(stack_amount)

		if(!user.put_in_hands(coin))
			coin.forceMove(get_turf(user))

		success = TRUE
		amount -= stack_amount

	return success

/proc/tat_trader_spawn_money_value(mob/living/carbon/human/user, value)
	if(!user)
		return FALSE

	value = max(0, round(value || 0))
	if(value <= 0)
		return FALSE

	var/success = FALSE
	for(var/list/coin_data in tat_trader_coin_value_list())
		if(value <= 0)
			break

		var/coin_value = round(coin_data["value"] || 0)
		var/coin_path = coin_data["path"]
		if(coin_value <= 0 || !ispath(coin_path, /obj/item/roguecoin))
			continue

		var/coin_amount = floor(value / coin_value)
		if(coin_amount <= 0)
			continue

		if(tat_trader_spawn_coin_stack(user, coin_path, coin_amount))
			success = TRUE

		value -= coin_amount * coin_value

	return success

/obj/item/tat_trader_writ
	name = "stranger's writ"
	desc = "A sealed market writ. Press it into a merchant's chest to force a new market and restart the half-day timer."
	icon = 'modular_twilight_axis/icons/obj/trader.dmi'
	icon_state = "veksel"
	w_class = WEIGHT_CLASS_SMALL

/obj/item/tat_trader_writ/Initialize(mapload)
	. = ..()
	var/letter_path = text2path("/obj/item/paper/letter")
	if(!ispath(letter_path, /obj/item))
		letter_path = text2path("/obj/item/paper")
	if(ispath(letter_path, /obj/item))
		var/obj/item/letter_preview = new letter_path(null)
		if(letter_preview)
			icon = letter_preview.icon
			icon_state = letter_preview.icon_state
			qdel(letter_preview)

/obj/item/tat_trader_chest
	name = "merchant's chest"
	desc = "A folded trader's chest. Right-click it to unpack it into a fixed merchant structure."
	icon = 'modular_twilight_axis/icons/obj/trader.dmi'
	icon_state = "trader_chest_off"
	w_class = WEIGHT_CLASS_BULKY
	var/bank_value = 0
	var/list/market_price_modifiers
	var/list/market_prices
	var/list/current_premium_paths
	var/list/sold_premium_paths
	var/list/premium_market_history
	var/list/premium_seen_paths
	var/next_market_reroll = 0
	var/last_market_reroll = 0

/obj/item/tat_trader_chest/attack_self(mob/living/user)
	return unfold(user)

/obj/item/tat_trader_chest/attack_right(mob/living/user)
	return unfold(user)

/obj/item/tat_trader_chest/proc/unfold(mob/living/user)
	if(!tat_trader_chest_check_user(user))
		return FALSE

	var/turf/target_turf = get_step(user, user.dir)
	if(!target_turf || !isopenturf(target_turf) || target_turf.is_blocked_turf(TRUE) || (locate(/mob/living) in target_turf))
		to_chat(user, span_warning("There is no room to unfold [src] there."))
		return FALSE

	var/obj/structure/tat_trader_chest/chest = new(target_turf)
	if(!chest)
		return FALSE

	chest.load_state_from_item(src)
	if(!chest.ensure_display_case(user.dir))
		to_chat(user, span_warning("[src] needs an open adjacent space for its display case."))
		qdel(chest)
		return FALSE

	user.visible_message(span_notice("[user] unfolds [src] into [chest]."), span_notice("You unfold [src] into [chest]."))
	chest.ensure_market_catalog_warm_async()
	qdel(src)
	return TRUE

/obj/structure/tat_trader_chest
	name = "merchant's chest"
	desc = "A locked trader's chest. A merchant can deposit money or wares, then buy goods from its sealed catalogue."
	icon = 'modular_twilight_axis/icons/obj/trader.dmi'
	icon_state = "trader_chest_on"
	anchored = TRUE
	density = TRUE
	var/bank_value = 0
	var/list/market_price_modifiers = list()
	var/list/market_prices = list()
	var/list/current_premium_paths = list()
	var/list/sold_premium_paths = list()
	var/list/premium_market_history = list()
	var/list/premium_seen_paths = list()
	var/next_market_reroll = 0
	var/last_market_reroll = 0
	var/obj/structure/tat_trader_display_case/display_case
	var/list/cached_market_catalog
	var/list/cached_display_catalog
	var/market_catalog_warming = FALSE

/obj/structure/tat_trader_chest/Initialize(mapload)
	. = ..()

/obj/structure/tat_trader_chest/Destroy()
	if(display_case)
		var/obj/structure/tat_trader_display_case/old_display = display_case
		display_case = null
		if(old_display.linked_chest == src)
			old_display.linked_chest = null
			qdel(old_display)
	return ..()

/obj/structure/tat_trader_chest/examine(mob/user)
	. = ..()
	. += span_info("Current banked value: [bank_value] coins.")
	. += span_info("Use in hand to open the trader interface. Use coins or goods on it to deposit value. Press a stranger's writ into it to force a market reroll. Right-click to fold it.")

/obj/structure/tat_trader_chest/proc/load_state_from_item(obj/item/tat_trader_chest/source)
	if(!source)
		return FALSE

	bank_value = max(0, round(source.bank_value || 0))
	if(islist(source.market_price_modifiers) && length(source.market_price_modifiers))
		market_price_modifiers = source.market_price_modifiers.Copy()
	if(islist(source.market_prices) && length(source.market_prices))
		market_prices = source.market_prices.Copy()
	if(islist(source.current_premium_paths) && length(source.current_premium_paths))
		current_premium_paths = source.current_premium_paths.Copy()
	if(islist(source.sold_premium_paths) && length(source.sold_premium_paths))
		sold_premium_paths = source.sold_premium_paths.Copy()
	if(islist(source.premium_market_history) && length(source.premium_market_history))
		premium_market_history = source.premium_market_history.Copy()
	if(islist(source.premium_seen_paths) && length(source.premium_seen_paths))
		premium_seen_paths = source.premium_seen_paths.Copy()
	if(source.next_market_reroll)
		next_market_reroll = source.next_market_reroll
	if(source.last_market_reroll)
		last_market_reroll = source.last_market_reroll
	return TRUE

/obj/structure/tat_trader_chest/proc/save_state_to_item(obj/item/tat_trader_chest/target)
	if(!target)
		return FALSE

	target.bank_value = bank_value
	target.market_price_modifiers = islist(market_price_modifiers) ? market_price_modifiers.Copy() : list()
	target.market_prices = islist(market_prices) ? market_prices.Copy() : list()
	target.current_premium_paths = islist(current_premium_paths) ? current_premium_paths.Copy() : list()
	target.sold_premium_paths = islist(sold_premium_paths) ? sold_premium_paths.Copy() : list()
	target.premium_market_history = islist(premium_market_history) ? premium_market_history.Copy() : list()
	target.premium_seen_paths = islist(premium_seen_paths) ? premium_seen_paths.Copy() : list()
	target.next_market_reroll = next_market_reroll
	target.last_market_reroll = last_market_reroll
	return TRUE

/obj/structure/tat_trader_chest/proc/invalidate_market_catalog_cache()
	cached_market_catalog = null
	cached_display_catalog = null

/obj/structure/tat_trader_chest/proc/ensure_market_catalog_warm_async()
	if(cached_market_catalog || market_catalog_warming)
		return FALSE
	market_catalog_warming = TRUE
	INVOKE_ASYNC(src, PROC_REF(warm_market_catalog))
	return TRUE

/obj/structure/tat_trader_chest/proc/warm_market_catalog()
	if(cached_market_catalog)
		market_catalog_warming = FALSE
		return FALSE

	build_market_catalog(TRUE)
	build_display_catalog()
	market_catalog_warming = FALSE
	SStgui.update_uis(src)
	if(display_case && !QDELETED(display_case))
		SStgui.update_uis(display_case)
	return TRUE

/obj/structure/tat_trader_chest/proc/can_place_display_case(turf/target_turf)
	if(!target_turf || !isopenturf(target_turf))
		return FALSE
	if(target_turf.is_blocked_turf(TRUE) || (locate(/mob/living) in target_turf))
		return FALSE
	return TRUE

/obj/structure/tat_trader_chest/proc/get_display_case_turf(preferred_dir)
	var/list/directions = list()
	if(preferred_dir)
		directions += preferred_dir
	for(var/direction in list(NORTH, SOUTH, EAST, WEST))
		if(direction in directions)
			continue
		directions += direction

	for(var/direction in directions)
		var/turf/target_turf = get_step(src, direction)
		if(can_place_display_case(target_turf))
			return target_turf

	return null

/obj/structure/tat_trader_chest/proc/ensure_display_case(preferred_dir)
	if(display_case && !QDELETED(display_case))
		if(get_dist(src, display_case) <= 1)
			return TRUE
		return FALSE

	var/turf/display_turf = get_display_case_turf(preferred_dir)
	if(!display_turf)
		return FALSE

	display_case = new(display_turf)
	display_case.linked_chest = src
	return TRUE

/obj/structure/tat_trader_chest/proc/fold_into_item(mob/living/user)
	if(!tat_trader_chest_check_user(user))
		return FALSE

	var/obj/item/tat_trader_chest/folded_chest = new(drop_location())
	save_state_to_item(folded_chest)
	user.visible_message(span_notice("[user] folds [src] into [folded_chest]."), span_notice("You fold [src] into [folded_chest]."))

	var/obj/structure/tat_trader_display_case/old_display = display_case
	display_case = null
	if(old_display && !QDELETED(old_display))
		old_display.linked_chest = null
		qdel(old_display)
	qdel(src)
	return TRUE

/obj/structure/tat_trader_chest/proc/get_recent_premium_market_paths()
	var/list/recent = list()
	if(!islist(premium_market_history))
		premium_market_history = list()

	for(var/list/iteration as anything in premium_market_history)
		if(!islist(iteration))
			continue
		for(var/item_path in iteration)
			tat_trader_chest_add_unique_path(recent, item_path)

	return recent

/obj/structure/tat_trader_chest/proc/trim_premium_market_history()
	if(!islist(premium_market_history))
		premium_market_history = list()

	while(length(premium_market_history) > TAT_TRADER_CHEST_PREMIUM_HISTORY_ITERATIONS)
		premium_market_history.Cut(1, 2)

	return TRUE

/obj/structure/tat_trader_chest/proc/select_premium_market_paths()
	var/list/all_candidates = tat_trader_chest_get_premium_catalog_paths()
	var/list/catalog_weights = tat_trader_chest_get_premium_catalog_weights()
	var/list/valid_candidates = list()

	for(var/item_path in all_candidates)
		if(!ispath(item_path, /obj/item))
			continue
		if(tat_trader_chest_is_disabled_premium_item(item_path))
			continue
		if(tat_trader_chest_special_premium_sold_this_round(item_path))
			continue
		if(tat_trader_chest_get_item_path_base_price(item_path) < TAT_TRADER_CHEST_MIN_LIST_PRICE)
			continue
		var/weight = max(1, round(catalog_weights[item_path] || 1))
		if(tat_trader_chest_is_special_premium_item(item_path))
			weight = 1
		else if(islist(premium_seen_paths) && (item_path in premium_seen_paths))
			weight = max(1, round(weight / TAT_TRADER_CHEST_SEEN_WEIGHT_DIVISOR))
		valid_candidates[item_path] = weight
		CHECK_TICK

	if(!length(valid_candidates))
		return list()

	var/list/recent = get_recent_premium_market_paths()
	var/list/available = list()

	for(var/item_path in valid_candidates)
		if(item_path in recent)
			continue
		available[item_path] = valid_candidates[item_path]
		CHECK_TICK

	var/list/selected = list()

	while(length(selected) < TAT_TRADER_CHEST_PREMIUM_MARKET_COUNT && length(available))
		var/item_path = pickweight(available)
		available -= item_path
		tat_trader_chest_add_unique_path(selected, item_path)
		CHECK_TICK

	// If the premium pool is too small to obey the rotation cooldown, fill
	// the remaining slots from the full valid pool. Never index or pick an empty
	// list: a tiny/misconfigured pool should produce fewer offers, not a runtime.
	var/list/fallback = valid_candidates.Copy()
	for(var/item_path in selected)
		fallback -= item_path

	while(length(selected) < TAT_TRADER_CHEST_PREMIUM_MARKET_COUNT && length(fallback))
		var/item_path = pickweight(fallback)
		fallback -= item_path
		tat_trader_chest_add_unique_path(selected, item_path)
		CHECK_TICK

	if(length(selected))
		record_premium_market_history(selected)

	return selected

/obj/structure/tat_trader_chest/proc/record_premium_market_history(list/selected_paths)
	if(!islist(selected_paths) || !length(selected_paths))
		return FALSE

	if(!islist(premium_market_history))
		premium_market_history = list()

	var/list/history_entry = list()
	for(var/item_path in selected_paths)
		if(!ispath(item_path, /obj/item))
			continue
		tat_trader_chest_add_unique_path(history_entry, item_path)
		tat_trader_chest_add_unique_path(premium_seen_paths, item_path)

	if(!length(history_entry))
		return FALSE

	premium_market_history += list(history_entry)
	trim_premium_market_history()
	return TRUE

/obj/structure/tat_trader_chest/proc/add_market_item(item_path, premium = FALSE)
	if(premium && tat_trader_chest_is_disabled_premium_item(item_path))
		return FALSE

	var/base_price = tat_trader_chest_get_item_path_base_price(item_path)
	if(base_price < TAT_TRADER_CHEST_MIN_LIST_PRICE)
		return FALSE

	var/uses_fixed_price = tat_trader_chest_path_uses_fixed_market_price(item_path)
	var/change_percent = uses_fixed_price ? 0 : rand(TAT_TRADER_CHEST_PRICE_SWING_MIN, TAT_TRADER_CHEST_PRICE_SWING_MAX)
	var/market_price = uses_fixed_price ? base_price : max(TAT_TRADER_CHEST_MIN_LIST_PRICE, round(base_price * (100 + change_percent) / 100))
	if(premium && tat_trader_chest_is_special_premium_item(item_path))
		market_price = max(TAT_TRADER_CHEST_MIN_LIST_PRICE, round(base_price * TAT_TRADER_CHEST_SPECIAL_PREMIUM_PRICE_MULTIPLIER))
	market_price_modifiers[item_path] = change_percent
	market_prices[item_path] = market_price
	return TRUE

/obj/structure/tat_trader_chest/proc/refresh_market_prices(force = FALSE)
	if(!force && length(market_prices) && world.time < next_market_reroll)
		return FALSE

	invalidate_market_catalog_cache()
	market_price_modifiers = list()
	market_prices = list()
	sold_premium_paths = list()
	current_premium_paths = select_premium_market_paths()

	for(var/item_path in tat_trader_chest_get_catalog_paths())
		add_market_item(item_path, FALSE)
		CHECK_TICK

	for(var/item_path in current_premium_paths)
		add_market_item(item_path, TRUE)
		CHECK_TICK

	// Stranger's writ is always sold by the chest for a fixed price. It is not a
	// capital item; it is a paid forced-reroll token.
	add_market_item(/obj/item/tat_trader_writ, FALSE)

	last_market_reroll = world.time
	next_market_reroll = world.time + TAT_TRADER_CHEST_PRICE_REROLL_INTERVAL
	SStgui.update_uis(src)
	return TRUE

/obj/structure/tat_trader_chest/proc/get_market_price(item_path)
	refresh_market_prices(FALSE)
	if(!(item_path in market_prices))
		return 0
	return max(0, round(market_prices[item_path] || 0))

/obj/structure/tat_trader_chest/proc/get_deposit_value(obj/item/I)
	if(!I || QDELETED(I))
		return 0

	if(istype(I, /obj/item/roguecoin))
		return tat_trader_chest_get_item_value(I)

	var/item_path = I.type
	refresh_market_prices(FALSE)

	var/base_price = tat_trader_chest_get_item_path_base_price(item_path)
	if(base_price <= 0)
		return 0

	var/store_price = 0
	if(item_path in market_prices)
		store_price = get_market_price(item_path)
	else
		store_price = base_price

	if(store_price <= 0)
		return 0

	var/deposit_cap = max(1, round(base_price * TAT_TRADER_CHEST_ITEM_DEPOSIT_MULTIPLIER))
	return max(1, min(store_price, deposit_cap))

/obj/structure/tat_trader_chest/proc/build_market_catalog(force_rebuild = FALSE)
	if(!force_rebuild && islist(cached_market_catalog))
		return cached_market_catalog

	refresh_market_prices(FALSE)

	var/list/catalog = list()
	var/list/paths = list()
	for(var/item_path in tat_trader_chest_get_catalog_paths())
		tat_trader_chest_add_unique_path(paths, item_path)
	for(var/item_path in current_premium_paths)
		tat_trader_chest_add_unique_path(paths, item_path)
	tat_trader_chest_add_unique_path(paths, /obj/item/tat_trader_writ)

	for(var/item_path in paths)
		if(!(item_path in market_prices))
			continue
		var/is_premium = (item_path in current_premium_paths)
		if(is_premium && islist(sold_premium_paths) && (item_path in sold_premium_paths))
			continue
		if(is_premium && tat_trader_chest_special_premium_sold_this_round(item_path))
			continue

		var/base_price = tat_trader_chest_get_item_path_base_price(item_path)
		if(base_price < TAT_TRADER_CHEST_MIN_LIST_PRICE)
			continue

		catalog += list(list(
			"path" = "[item_path]",
			"name" = tat_trader_chest_item_name(item_path),
			"base_price" = base_price,
			"price" = get_market_price(item_path),
			"price_change" = round(market_price_modifiers[item_path] || 0),
			"type" = tat_trader_chest_item_type_text(item_path),
			"premium" = is_premium,
			"icon" = tat_trader_chest_build_item_icon_payload(item_path),
		))
		CHECK_TICK

	cached_market_catalog = catalog
	return catalog

/obj/structure/tat_trader_chest/proc/build_display_catalog()
	if(islist(cached_display_catalog))
		return cached_display_catalog

	var/list/catalog = list()
	for(var/list/entry as anything in build_market_catalog())
		if(!islist(entry))
			continue
		catalog += list(list(
			"path" = entry["path"],
			"name" = entry["name"],
			"premium" = entry["premium"],
			"icon" = entry["icon"],
		))
		CHECK_TICK
	cached_display_catalog = catalog
	return catalog

/obj/structure/tat_trader_chest/attack_hand(mob/living/user)
	. = ..()
	if(!tat_trader_chest_check_user(user))
		return

	ui_interact(user)

/obj/structure/tat_trader_chest/attack_right(mob/living/user)
	. = ..()
	fold_into_item(user)

/obj/structure/tat_trader_chest/attackby(obj/item/I, mob/living/user, params)
	if(!I || !user)
		return ..()

	if(!tat_trader_chest_check_user(user))
		return TRUE

	if(I == src)
		to_chat(user, span_warning("The chest cannot deposit itself."))
		return TRUE

	if(istype(I, /obj/item/tat_trader_writ))
		user.visible_message(span_notice("[user] presses [I] into [src]. The market seals crackle and rearrange."), span_notice("You spend [I] to reroll [src]'s market."))
		qdel(I)
		refresh_market_prices(TRUE)
		SStgui.update_uis(src)
		return TRUE

	var/value = get_deposit_value(I)
	if(value <= 0)
		to_chat(user, span_warning("[I] has no trade value for this chest."))
		return TRUE

	bank_value += value
	user.visible_message(span_notice("[user] deposits [I] into [src]."), span_notice("You deposit [I] for [value] coins. Banked value is now [bank_value]."))
	qdel(I)
	SStgui.update_uis(src)
	return TRUE

/obj/structure/tat_trader_chest/ui_state(mob/user)
	return GLOB.physical_state

/obj/structure/tat_trader_chest/ui_interact(mob/user, datum/tgui/ui)
	if(!tat_trader_chest_check_user(user, TRUE))
		return

	ensure_market_catalog_warm_async()
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "TatTraderChest")
		ui.open()

/obj/structure/tat_trader_chest/ui_data(mob/user)
	ensure_market_catalog_warm_async()
	var/list/data = list()
	data["bank_value"] = bank_value
	data["catalog"] = islist(cached_market_catalog) ? cached_market_catalog : list()
	data["catalog_warming"] = !islist(cached_market_catalog)
	data["can_use"] = tat_trader_chest_check_user(user, TRUE)
	data["default_withdraw"] = min(TAT_TRADER_CHEST_DEFAULT_WITHDRAW, bank_value)
	data["next_market_reroll"] = max(0, round((next_market_reroll - world.time) / 10))
	data["last_market_reroll"] = last_market_reroll
	return data

/obj/structure/tat_trader_chest/ui_act(action, list/params)
	. = ..()
	if(.)
		return

	if(!tat_trader_chest_check_user(usr))
		return FALSE

	refresh_market_prices(FALSE)

	switch(action)
		if("buy")
			var/item_path = text2path("[params["path"]]")
			if(!ispath(item_path, /obj/item))
				return FALSE

			if(!(item_path in market_prices))
				to_chat(usr, span_warning("That item is not sold by this chest."))
				return FALSE

			var/is_premium = (item_path in current_premium_paths)
			if(is_premium && islist(sold_premium_paths) && (item_path in sold_premium_paths))
				to_chat(usr, span_warning("That premium item has already been sold."))
				return FALSE
			if(is_premium && tat_trader_chest_special_premium_sold_this_round(item_path))
				to_chat(usr, span_warning("That premium item has already left the market."))
				return FALSE

			var/price = get_market_price(item_path)
			if(price <= 0)
				return FALSE

			if(bank_value < price)
				to_chat(usr, span_warning("The chest needs [price] coins, but only has [bank_value]."))
				return FALSE

			var/obj/item/purchased = new item_path(get_turf(usr))
			if(!purchased)
				return FALSE

			bank_value -= price
			if(is_premium)
				tat_trader_chest_add_unique_path(sold_premium_paths, item_path)
				if(tat_trader_chest_is_special_premium_item(item_path))
					tat_trader_chest_add_unique_path(GLOB.tat_trader_chest_round_sold_special_premium, item_path)
				invalidate_market_catalog_cache()

			if(!usr.put_in_hands(purchased))
				purchased.forceMove(get_turf(usr))

			to_chat(usr, span_notice("You buy [purchased] for [price] coins. Banked value: [bank_value]."))
			SStgui.update_uis(src)
			return TRUE

		if("withdraw")
			var/amount = max(1, round(text2num("[params["amount"]]") || TAT_TRADER_CHEST_DEFAULT_WITHDRAW))
			amount = min(amount, TAT_TRADER_CHEST_MAX_WITHDRAW, bank_value)

			if(amount <= 0)
				return FALSE

			if(!tat_trader_spawn_money_value(usr, amount))
				return FALSE

			bank_value -= amount
			to_chat(usr, span_notice("You withdraw [amount] coins from [src]. Banked value: [bank_value]."))
			SStgui.update_uis(src)
			return TRUE

	return FALSE

/obj/structure/tat_trader_display_case
	name = "merchant's display case"
	desc = "A small display case showing the merchant's wares. It lists items only; prices are for the merchant to name. It can be moved with the help of a wooden stake."
	icon = 'modular_twilight_axis/icons/obj/trader.dmi'
	icon_state = "trader_display"
	anchored = TRUE
	density = FALSE
	drag_slowdown = 2
	var/obj/structure/tat_trader_chest/linked_chest

/obj/structure/tat_trader_display_case/Destroy()
	if(linked_chest && linked_chest.display_case == src)
		linked_chest.display_case = null
	linked_chest = null
	return ..()

/obj/structure/tat_trader_display_case/examine(mob/user)
	. = ..()
	. += span_info("Click it to inspect the displayed goods. Prices are not shown here.")
	if(!anchored)
		. += span_warning("It is un-anchored and able to be moved.")

/obj/structure/tat_trader_display_case/attackby(obj/item/I, mob/living/user, params)
	if(istype(I, /obj/item/grown/log/tree/stake))
		if(anchored)
			anchored = FALSE
			to_chat(user, span_warning("The [src] can now be moved."))
		else
			anchored = TRUE
			to_chat(user, span_warning("You anchor [src]."))
		playsound(src, pick('sound/foley/woodclimb.ogg'), 100, TRUE)
		return TRUE
	return ..()

/obj/structure/tat_trader_display_case/attack_hand(mob/living/user)
	. = ..()
	ui_interact(user)

/obj/structure/tat_trader_display_case/ui_state(mob/user)
	return GLOB.physical_state

/obj/structure/tat_trader_display_case/ui_interact(mob/user, datum/tgui/ui)
	if(!linked_chest || QDELETED(linked_chest))
		to_chat(user, span_warning("[src] is not linked to a merchant's chest."))
		return

	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "TatTraderDisplayCase")
		ui.open()

/obj/structure/tat_trader_display_case/ui_data(mob/user)
	var/list/data = list()
	if(linked_chest)
		linked_chest.ensure_market_catalog_warm_async()
		data["catalog"] = islist(linked_chest.cached_display_catalog) ? linked_chest.cached_display_catalog : list()
		data["catalog_warming"] = !islist(linked_chest.cached_display_catalog)
	else
		data["catalog"] = list()
		data["catalog_warming"] = FALSE
	return data

#undef TAT_TRADER_CHEST_DEFAULT_WITHDRAW
#undef TAT_TRADER_CHEST_MAX_WITHDRAW
#undef TAT_TRADER_CHEST_MIN_LIST_PRICE
#undef TAT_TRADER_CHEST_WRIT_PRICE
#undef TAT_TRADER_CHEST_ARTIFACT_BEARER_ITEM_PRICE
#undef TAT_TRADER_CHEST_SOON_ITEM_PRICE
#undef TAT_TRADER_CHEST_RARE_PREMIUM_ITEM_PRICE
#undef TAT_TRADER_CHEST_PRICE_REROLL_INTERVAL
#undef TAT_TRADER_CHEST_PRICE_SWING_MIN
#undef TAT_TRADER_CHEST_PRICE_SWING_MAX
#undef TAT_TRADER_CHEST_PREMIUM_MARKET_COUNT
#undef TAT_TRADER_CHEST_PREMIUM_HISTORY_ITERATIONS
#undef TAT_TRADER_CHEST_SEEN_WEIGHT_DIVISOR
#undef TAT_TRADER_CHEST_SPECIAL_PREMIUM_PRICE_MULTIPLIER
#undef TAT_TRADER_CHEST_ITEM_DEPOSIT_MULTIPLIER
#undef TAT_TRADER_CHEST_MAX_COIN_STACK
#undef TAT_TRADER_CHEST_ROCKHILL_KRONA_VALUE
#undef TAT_TRADER_CHEST_ZENAR_VALUE
#undef TAT_TRADER_CHEST_ZILIQUA_VALUE
#undef TAT_TRADER_CHEST_ZENNY_VALUE
