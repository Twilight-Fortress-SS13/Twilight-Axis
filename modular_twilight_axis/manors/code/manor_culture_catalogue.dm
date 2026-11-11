/proc/getManorCulturalRecipeOrigins()
	var/static/list/origins_by_recipe = list(
		/datum/anvil_recipe/weapons/steel/kriegmesser = list(
			/datum/virtue/origin/grenzelhoft
		),
		/datum/anvil_recipe/weapons/steel/combatknifemesser = list(
			/datum/virtue/origin/grenzelhoft
		),
		/datum/anvil_recipe/weapons/steel/partizan = list(
			/datum/virtue/origin/grenzelhoft
		),
		/datum/crafting_recipe/roguetown/sewing/tailor/grenzelhat = list(
			/datum/virtue/origin/grenzelhoft
		),
		/datum/crafting_recipe/roguetown/sewing/tailor/grenzelshirt = list(
			/datum/virtue/origin/grenzelhoft
		),
		/datum/crafting_recipe/roguetown/sewing/tailor/grenzelpants = list(
			/datum/virtue/origin/grenzelhoft
		),
		/datum/crafting_recipe/roguetown/leather/unique/grenzelboots = list(
			/datum/virtue/origin/grenzelhoft
		),
		/datum/crafting_recipe/roguetown/leather/unique/grenzelgloves = list(
			/datum/virtue/origin/grenzelhoft
		),
		/datum/crafting_recipe/roguetown/sewing/grenzelsallet_visor = list(
			/datum/virtue/origin/grenzelhoft
		),
		/datum/crafting_recipe/roguetown/sewing/grenzelarmet = list(
			/datum/virtue/origin/grenzelhoft
		),
		/datum/crafting_recipe/roguetown/sewing/grenzelskettle = list(
			/datum/virtue/origin/grenzelhoft
		),
		/datum/crafting_recipe/roguetown/survival/grenzelchain_legs = list(
			/datum/virtue/origin/grenzelhoft
		),
		/datum/crafting_recipe/roguetown/survival/grenzelhauberk = list(
			/datum/virtue/origin/grenzelhoft
		),

		/datum/anvil_recipe/armor/iron/breastplate_legacy = list(
			/datum/virtue/origin/valorian
		),
		/datum/anvil_recipe/armor/iron/halfplate_legacy = list(
			/datum/virtue/origin/valorian
		),
		/datum/anvil_recipe/armor/iron/fullplate_legacy = list(
			/datum/virtue/origin/valorian
		),
		/datum/anvil_recipe/armor/iron/kettle_legacy = list(
			/datum/virtue/origin/valorian
		),
		/datum/anvil_recipe/armor/iron/sallet_legacy = list(
			/datum/virtue/origin/valorian
		),
		/datum/anvil_recipe/armor/iron/sallet/visor_legacy = list(
			/datum/virtue/origin/valorian
		),
		/datum/anvil_recipe/armor/steel/halfplate_legacy = list(
			/datum/virtue/origin/valorian
		),
		/datum/anvil_recipe/armor/steel/fullplate_legacy = list(
			/datum/virtue/origin/valorian
		),
		/datum/anvil_recipe/armor/steel/fullplate/fluted_legacy = list(
			/datum/virtue/origin/valorian
		),
		/datum/anvil_recipe/armor/steel/cuirass/legacy = list(
			/datum/virtue/origin/valorian
		),
		/datum/anvil_recipe/armor/steel/helmetkettle_legacy = list(
			/datum/virtue/origin/valorian
		),
		/datum/anvil_recipe/armor/steel/helmetsall_legacy = list(
			/datum/virtue/origin/valorian
		),
		/datum/anvil_recipe/armor/steel/helmetsallv_legacy = list(
			/datum/virtue/origin/valorian
		),
		/datum/crafting_recipe/roguetown/sewing/valorian_maidband = list(
			/datum/virtue/origin/valorian
		),
		/datum/crafting_recipe/roguetown/sewing/valorian_maiddress = list(
			/datum/virtue/origin/valorian
		),
		/datum/crafting_recipe/roguetown/sewing/valorian_maidapron = list(
			/datum/virtue/origin/valorian
		),

		/datum/anvil_recipe/weapons/steel/flamb = list(
			/datum/virtue/origin/otava
		),
		/datum/anvil_recipe/weapons/steel/swarhammer = list(
			/datum/virtue/origin/otava
		),
		/datum/crafting_recipe/roguetown/sewing/tailor/otavangambeson = list(
			/datum/virtue/origin/otava
		),
		/datum/crafting_recipe/roguetown/leather/unique/otavanleatherpants = \
			list(/datum/virtue/origin/otava),
		/datum/crafting_recipe/roguetown/leather/unique/otavanleathergloves = \
			list(/datum/virtue/origin/otava),
		/datum/crafting_recipe/roguetown/leather/unique/otavanboots = list(
			/datum/virtue/origin/otava
		),

		/datum/anvil_recipe/armor/iron/etruscanbascinet = list(
			/datum/virtue/origin/etrusca
		),
		/datum/anvil_recipe/armor/steel/etruscanbascinet = list(
			/datum/virtue/origin/etrusca
		),
		/datum/anvil_recipe/weapons/steel/xbow = list(
			/datum/virtue/origin/etrusca
		),
		/datum/crafting_recipe/roguetown/engineering/crossbow = list(
			/datum/virtue/origin/etrusca
		),

		/datum/anvil_recipe/weapons/silver/claws = list(
			/datum/virtue/origin/gronn
		),
		/datum/crafting_recipe/roguetown/leather/unique/openrobes = list(
			/datum/virtue/origin/gronn
		),
		/datum/crafting_recipe/roguetown/leather/unique/gronnpants = list(
			/datum/virtue/origin/gronn
		),
		/datum/crafting_recipe/roguetown/leather/unique/gronngloves = list(
			/datum/virtue/origin/gronn
		),
		/datum/crafting_recipe/roguetown/leather/unique/gronnboots = list(
			/datum/virtue/origin/gronn
		),

		/datum/crafting_recipe/roguetown/sewing/tailor/naledisash = list(
			/datum/virtue/origin/naledi
		),
		/datum/crafting_recipe/roguetown/sewing/tailor/halfrobe = list(
			/datum/virtue/origin/naledi
		),
		/datum/crafting_recipe/roguetown/sewing/tailor/monkrobe = list(
			/datum/virtue/origin/naledi
		),
		/datum/crafting_recipe/roguetown/sewing/tailor/desertgown = list(
			/datum/virtue/origin/naledi
		),
		/datum/crafting_recipe/roguetown/sewing/hijab = list(
			/datum/virtue/origin/naledi
		),
		/datum/crafting_recipe/roguetown/leather/unique/monkleather = list(
			/datum/virtue/origin/naledi
		),
		/datum/crafting_recipe/roguetown/leather/unique/baggyleatherpants = \
			list(/datum/virtue/origin/naledi),
		/datum/crafting_recipe/roguetown/survival/naledymask_up = list(
			/datum/virtue/origin/naledi
		),
		/datum/crafting_recipe/roguetown/survival/naledymask_up_decorative = \
			list(/datum/virtue/origin/naledi),

		/datum/anvil_recipe/armor/steel/raneshi_hmamluk = list(
			/datum/virtue/origin/raneshen
		),
		/datum/anvil_recipe/armor/steel/raneshi_vmamluk = list(
			/datum/virtue/origin/raneshen
		),
		/datum/anvil_recipe/armor/steel/raneshi_jarhelmet = list(
			/datum/virtue/origin/raneshen
		),
		/datum/anvil_recipe/armor/steel/raneshen_plated = list(
			/datum/virtue/origin/raneshen
		),
		/datum/anvil_recipe/armor/steel/raneshen_scale = list(
			/datum/virtue/origin/raneshen
		),
		/datum/crafting_recipe/roguetown/sewing/keffiyeh = list(
			/datum/virtue/origin/raneshen
		),
		/datum/anvil_recipe/weapons/steel/kriegmesser/zybantine = list(
			/datum/virtue/origin/zybantian
		),
		/datum/anvil_recipe/weapons/steel/naginata = list(
			/datum/virtue/origin/kazengun
		),

		/datum/crafting_recipe/roguetown/leather/armor/freivest = \
			list(/datum/virtue/origin/avar),
		/datum/crafting_recipe/roguetown/sewing/hgambeson/fencer = \
			list(/datum/virtue/origin/avar),
		/datum/crafting_recipe/roguetown/leather/unique/fencingbreeches = \
			list(/datum/virtue/origin/avar),

		/datum/crafting_recipe/roguetown/sewing/shadowshirt = list(
			/datum/virtue/origin/racial/underdark,
			/datum/virtue/origin/racial/underdark_drow,
		),
		/datum/crafting_recipe/roguetown/weaving/webbing = list(
			/datum/virtue/origin/racial/underdark,
			/datum/virtue/origin/racial/underdark_drow,
		),
		/datum/crafting_recipe/roguetown/weaving/rags = list(
			/datum/virtue/origin/racial/underdark,
			/datum/virtue/origin/racial/underdark_drow,
		),
	)
	return origins_by_recipe
