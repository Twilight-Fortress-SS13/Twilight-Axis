SUBSYSTEM_DEF(disease)
	name = "Disease"
	flags = SS_NO_FIRE

	var/list/active_diseases = list() //List of Active disease in all mobs; purely for quick referencing.
	var/list/diseases
	var/list/archive_diseases = list()

/datum/controller/subsystem/disease/PreInit()
	if(!diseases)
		diseases = subtypesof(/datum/disease)

/datum/controller/subsystem/disease/Initialize(timeofday)
	for(var/disease_type in diseases)
		var/datum/disease/prototype = new disease_type()
		archive_diseases[prototype.GetDiseaseID()] = prototype
	return ..()

/datum/controller/subsystem/disease/stat_entry(msg)
	msg = "P:[length(active_diseases)]"
	return ..()

/datum/controller/subsystem/disease/proc/get_disease_name(id)
	var/datum/disease/D = archive_diseases[id]
	if(D?.name)
		return D.name
	else
		return "Unknown"
