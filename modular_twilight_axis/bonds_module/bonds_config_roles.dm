/datum/bond_archetype/warrior
	flag = BOND_ARCH_WARRIOR
	jobs = list(
		/datum/job/roguetown/knight,
		/datum/job/roguetown/knight_enigma,
		/datum/job/roguetown/heartfelt/knight,
		/datum/job/roguetown/heartfelt/retinue,
		/datum/job/roguetown/cataphract,
		/datum/job/roguetown/templar,
		/datum/job/roguetown/martyr,
		/datum/job/roguetown/sergeant,
		/datum/job/roguetown/royal_sergeant,
		/datum/job/roguetown/royal_guard,
		/datum/job/roguetown/manorguard,
		/datum/job/roguetown/mercenary,
		/datum/job/roguetown/veteran,
		/datum/job/roguetown/squire,
		/datum/job/roguetown/vanguard,
		/datum/job/roguetown/janissary,
		/datum/job/roguetown/janissarysergeant,
		/datum/job/roguetown/azeb,
		/datum/job/roguetown/azebagha,
		/datum/job/roguetown/town_watch,
		/datum/job/roguetown/watchman,
		/datum/job/roguetown/adventurer,
		/datum/job/roguetown/marshal,
	)

/datum/bond_archetype/lawman
	flag = BOND_ARCH_LAWMAN
	jobs = list(
		/datum/job/roguetown/sheriff,
		/datum/job/roguetown/bailiff,
		/datum/job/roguetown/warden,
		/datum/job/roguetown/marshal,
		/datum/job/roguetown/overseer,
		/datum/job/roguetown/town_watch,
		/datum/job/roguetown/watchman,
		/datum/job/roguetown/inquisitor,
		/datum/job/roguetown/absolver,
		/datum/job/roguetown/slavemaster,
		/datum/job/roguetown/headslave,
	)

/datum/bond_archetype/devout
	flag = BOND_ARCH_DEVOUT
	jobs = list(
		/datum/job/roguetown/priest,
		/datum/job/roguetown/monk,
		/datum/job/roguetown/sexton,
		/datum/job/roguetown/orthodoxist,
		/datum/job/roguetown/templar,
		/datum/job/roguetown/martyr,
		/datum/job/roguetown/inquisitor,
		/datum/job/roguetown/absolver,
		/datum/job/roguetown/pilgrim,
		/datum/job/roguetown/druid,
		/datum/job/roguetown/keeper,
	)

/datum/bond_archetype/noble
	flag = BOND_ARCH_NOBLE
	jobs = list(
		/datum/job/roguetown/lord,
		/datum/job/roguetown/lady,
		/datum/job/roguetown/exlady,
		/datum/job/roguetown/prince,
		/datum/job/roguetown/sultan,
		/datum/job/roguetown/sheikh,
		/datum/job/roguetown/heartfelt/lord,
		/datum/job/roguetown/heartfelt/hand,
		/datum/job/roguetown/hand,
		/datum/job/roguetown/vizier,
		/datum/job/roguetown/councillor,
		/datum/job/roguetown/seneschal,
		/datum/job/roguetown/steward,
		/datum/job/roguetown/mayor,
		/datum/job/roguetown/suitor,
	)

/datum/bond_archetype/scholar
	flag = BOND_ARCH_SCHOLAR
	jobs = list(
		/datum/job/roguetown/archivist,
		/datum/job/roguetown/clerk,
		/datum/job/roguetown/magician,
		/datum/job/roguetown/wapprentice,
		/datum/job/roguetown/apothecary,
		/datum/job/roguetown/courtphysician,
		/datum/job/roguetown/keeper,
		/datum/job/roguetown/jester,
	)

/datum/bond_archetype/healer
	flag = BOND_ARCH_HEALER
	jobs = list(
		/datum/job/roguetown/physician,
		/datum/job/roguetown/courtphysician,
		/datum/job/roguetown/apothecary,
		/datum/job/roguetown/druid,
	)

/datum/bond_archetype/crafter
	flag = BOND_ARCH_CRAFTER
	jobs = list(
		/datum/job/roguetown/tailor,
		/datum/job/roguetown/cook,
		/datum/job/roguetown/farmer,
		/datum/job/roguetown/guildsman,
		/datum/job/roguetown/freeman,
		/datum/job/roguetown/villager,
		/datum/job/roguetown/tapster,
		/datum/job/roguetown/innkeeper,
		/datum/job/roguetown/bathmaster,
	)

/datum/bond_archetype/merchant
	flag = BOND_ARCH_MERCHANT
	jobs = list(
		/datum/job/roguetown/merchant,
		/datum/job/roguetown/trader,
		/datum/job/roguetown/guildmaster,
		/datum/job/roguetown/innkeeper,
		/datum/job/roguetown/clerk,
	)

/datum/bond_archetype/outlaw
	flag = BOND_ARCH_OUTLAW
	jobs = list(
		/datum/job/roguetown/bandit,
		/datum/job/roguetown/assassin,
		/datum/job/roguetown/wretch,
		/datum/job/roguetown/lunatic,
		/datum/job/roguetown/vagabond,
		/datum/job/roguetown/hag,
	)

/datum/bond_archetype/servile
	flag = BOND_ARCH_SERVILE
	jobs = list(
		/datum/job/roguetown/servant,
		/datum/job/roguetown/slave,
		/datum/job/roguetown/harem,
		/datum/job/roguetown/bathworker,
		/datum/job/roguetown/shophand,
		/datum/job/roguetown/squire,
		/datum/job/roguetown/migrant,
	)

/datum/bond_archetype/wanderer
	flag = BOND_ARCH_WANDERER
	jobs = list(
		/datum/job/roguetown/adventurer,
		/datum/job/roguetown/pilgrim,
		/datum/job/roguetown/migrant,
		/datum/job/roguetown/vagabond,
		/datum/job/roguetown/mercenary,
	)

/datum/bond_archetype/undead
	flag = BOND_ARCH_UNDEAD
	jobs = list(
		/datum/job/roguetown/skeleton,
		/datum/job/roguetown/greater_skeleton,
		/datum/job/roguetown/cult/skeleton,
		/datum/job/roguetown/vampire_guard,
		/datum/job/roguetown/vampire_servant,
		/datum/job/roguetown/vampire_spawn,
		/datum/job/roguetown/gnoll,
		/datum/job/roguetown/goblin,
	)

/datum/bond_role_tier/crown
	weight = 3
	jobs = list(
		/datum/job/roguetown/lord,
		/datum/job/roguetown/sultan,
		/datum/job/roguetown/lady,
		/datum/job/roguetown/prince,
	)

/datum/bond_role_tier/regent
	weight = 2.8
	jobs = list(
		/datum/job/roguetown/hand,
		/datum/job/roguetown/vizier,
	)

/datum/bond_role_tier/high_office
	weight = 2.5
	jobs = list(
		/datum/job/roguetown/steward,
		/datum/job/roguetown/seneschal,
		/datum/job/roguetown/councillor,
		/datum/job/roguetown/priest,
		/datum/job/roguetown/marshal,
		/datum/job/roguetown/inquisitor,
		/datum/job/roguetown/mayor,
	)

/datum/bond_role_tier/notable
	weight = 1.8
	jobs = list(
		/datum/job/roguetown/knight,
		/datum/job/roguetown/knight_enigma,
		/datum/job/roguetown/cataphract,
		/datum/job/roguetown/templar,
		/datum/job/roguetown/guildmaster,
		/datum/job/roguetown/merchant,
		/datum/job/roguetown/sergeant,
		/datum/job/roguetown/royal_sergeant,
		/datum/job/roguetown/sheriff,
		/datum/job/roguetown/overseer,
		/datum/job/roguetown/magician,
		/datum/job/roguetown/courtphysician,
	)
