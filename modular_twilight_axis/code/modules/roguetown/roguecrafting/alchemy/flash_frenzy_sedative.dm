// SEDATIVE - cauldron recipe and reagent

/obj/item/reagent_containers/glass/bottle/rogue/sedative
	name = "bottle of sedative"
	list_reagents = list(/datum/reagent/medicine/flash_frenzy_sedative = 50)
	desc = "A glass bottle containing a heavy sedative draught that forces the body into deep sleep."

/datum/reagent/medicine/flash_frenzy_sedative
	name = "Sedative"
	description = "A heavy draught that forces the body into sleep."
	reagent_state = LIQUID
	color = "#6b7d8a"
	taste_description = "bitter herbs"
	scent_description = "damp roots"
	metabolization_rate = 0.42 * REAGENTS_METABOLISM

/datum/reagent/medicine/flash_frenzy_sedative/on_mob_life(mob/living/carbon/M)
	if(volume > 0.99)
		M.Sleeping(2 SECONDS)
	// Cure Flash Frenzy disease when sedative is consumed
	if(M.mind)
		for(var/datum/disease/flash_frenzy/disease in M.diseases)
			disease.cure()
	..()
	. = 1

/datum/alch_cauldron_recipe/flash_frenzy_sedative
	name = "Sedative"
	smells_like = "damp roots"
	skill_required = SKILL_LEVEL_EXPERT
	output_reagents = list(/datum/reagent/medicine/flash_frenzy_sedative = 50)

/obj/item/alch/soporific_dust
	name = "soporific dust"
	desc = "A fine blend of rare herbs that induces deep sleep."
	icon_state = "swampdust"
	major_pot = /datum/alch_cauldron_recipe/flash_frenzy_sedative

/obj/item/alch/drowse_dust
	name = "drowse dust"
	desc = "A drowsy-smelling powder used in sedative brews."
	icon_state = "tobaccodust"
	major_pot = /datum/alch_cauldron_recipe/flash_frenzy_sedative

/datum/crafting_recipe/roguetown/alch/soporific_dust
	name = "soporific dust"
	result = list(/obj/item/alch/soporific_dust = 1)
	reqs = list(
		/obj/item/alch/valeriana = 1,
		/obj/item/alch/artemisia = 1
	)
	structurecraft = /obj/structure/table/wood
	verbage = "mixes"
	craftsound = 'sound/foley/scribble.ogg'
	skillcraft = /datum/skill/craft/alchemy
	craftdiff = 1

/datum/crafting_recipe/roguetown/alch/drowse_dust
	name = "drowse dust"
	result = list(/obj/item/alch/drowse_dust = 1)
	reqs = list(
		/obj/item/alch/atropa = 1,
		/obj/item/alch/valeriana = 1
	)
	structurecraft = /obj/structure/table/wood
	verbage = "mixes"
	craftsound = 'sound/foley/scribble.ogg'
	skillcraft = /datum/skill/craft/alchemy
	craftdiff = 1
