// Modular extension: Add "Cure All Diseases" option to VV menu for carbon mobs

#define VV_HK_CURE_DISEASES "cure_diseases"

/mob/living/carbon/vv_get_dropdown()
	. = ..()
	VV_DROPDOWN_OPTION(VV_HK_CURE_DISEASES, "Cure All Diseases")

/mob/living/carbon/vv_do_topic(list/href_list)
	. = ..()
	if(href_list[VV_HK_CURE_DISEASES])
		if(!check_rights(NONE))
			return
		if(!length(diseases))
			to_chat(usr, "<span class='warning'>[src] has no diseases.</span>")
			return
		var/disease_count = length(diseases)
		for(var/datum/disease/D in diseases)
			D.cure(TRUE)
		log_admin("[key_name(usr)] has cured all diseases ([disease_count]) from [key_name(src)] and granted immunity.")
		message_admins("<span class='notice'>[key_name_admin(usr)] has cured all diseases ([disease_count]) from [key_name_admin(src)].</span>")
