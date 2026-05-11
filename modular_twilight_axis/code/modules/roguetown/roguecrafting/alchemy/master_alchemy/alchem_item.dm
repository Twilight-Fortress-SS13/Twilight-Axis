/obj/item/alch/mirror_clay
	name = "Зеркальная Глина"
	desc = "Кусок пульсирующей массы. Прижмите её к лицу человека, чтобы снять слепок."
	icon = 'icons/roguetown/items/natural.dmi' 
	icon_state = "clay"
	w_class = WEIGHT_CLASS_SMALL
	var/clay_primed = FALSE
	var/mob/living/carbon/human/template_human = null

/obj/item/alch/mirror_clay/attack(mob/living/carbon/human/target, mob/living/carbon/human/user)
	if(!istype(target)) return ..()
	
	if(clay_primed)
		to_chat(user, span_warning("Глина уже содержит слепок!"))
		return TRUE

	if(target.stat == DEAD)
		to_chat(user, span_warning("Глина не может скопировать мертвую материю!"))
		return TRUE

	user.visible_message(span_danger("[user] прижимает [src.name] к лицу [target]!"), \
						span_notice("Вы снимаете слепок [target]..."))
	
	if(do_after(user, 30, target = target))
		template_human = target
		
		clay_primed = TRUE
		name = "Слепок ([target.real_name])"
		desc = "Глина приняла форму лица [target.real_name]."
		
		to_chat(user, span_boldnotice("Слепок готов. Теперь глине нужна душа."))

	return TRUE

/obj/item/alch/mirror_clay/attack_self(mob/living/carbon/human/user)
	if(!clay_primed || !template_human)
		to_chat(user, span_warning("Сначала снимите слепок с живого человека!"))
		return
	
	if(QDELETED(template_human))
		user.visible_message(span_danger("Глина в руках [user] внезапно высыхает и рассыпается в пыль..."), \
							span_warning("Связь с оригиналом утеряна! Слепок рассыпается в ваших руках."))
		qdel(src)
		return

	user.visible_message(span_danger("[user] начинает шептать древние заклинания над слепком [template_human.real_name]..."))

	INVOKE_ASYNC(src, PROC_REF(poll_for_homunculus), user)

/obj/item/alch/mirror_clay/proc/poll_for_homunculus(mob/living/carbon/human/user)
	var/poll_message = "Алхимик [user.real_name] создает глиняную копию [template_human.real_name]. Хотите вселиться в клона?"
	var/list/candidates = pollGhostCandidates(poll_message, "Homunculus", null, null, 15 SECONDS, "homunculus")

	if(QDELETED(src) || QDELETED(user) || !template_human) return

	if(!LAZYLEN(candidates))
		to_chat(user, span_warning("Духи отвергают эту форму."))
		return

	if(QDELETED(template_human))
		to_chat(user, span_warning("Нить души оборвалась во время ритуала. Глина рассыпается в прах."))
		qdel(src)
		return
	
	var/mob/C = pick(candidates)
	if(!C) return

	if(istype(C, /mob/dead/new_player))
		var/mob/dead/new_player/N = C
		N.close_spawn_windows()

	user.visible_message(span_userdanger("Глина вырывается из рук [user] и начинает стремительно обрастать плотью!"))

	var/mob/living/carbon/human/clone = new template_human.type(get_turf(user))
	clone.key = C.key 
	
	template_human.dna.transfer_identity(clone)

	if(clone.dna && clone.dna.body_markings)
		apply_markings_to_body_parts(clone.dna.body_markings, clone)

	clone.real_name = template_human.real_name
	clone.name = clone.real_name
	clone.nickname = template_human.nickname
	clone.pronouns = template_human.pronouns
	clone.titles_pref = template_human.titles_pref
	clone.clothes_pref = template_human.clothes_pref
	clone.voice_type = template_human.voice_type
	clone.voice_color = template_human.voice_color
	clone.voice_pitch = template_human.voice_pitch
	clone.highlight_color = template_human.highlight_color
	clone.char_accent = template_human.char_accent
	clone.age = template_human.age
	clone.gender = template_human.gender
	clone.skin_tone = template_human.skin_tone
	clone.hair_color = template_human.hair_color
	clone.facial_hair_color = template_human.facial_hair_color
	clone.eye_color = template_human.eye_color
	clone.hairstyle = template_human.hairstyle
	clone.facial_hairstyle = template_human.facial_hairstyle

	if(template_human.statpack)
		clone.statpack = new template_human.statpack.type()
	
	clone.set_patron(template_human.patron)
	
	if(template_human.charflaws)
		clone.charflaws = list()
		for(var/datum/charflaw/cf in template_human.charflaws)
			var/datum/charflaw/new_flaw = new cf.type()
			clone.charflaws.Add(new_flaw)
			new_flaw.on_mob_creation(clone)

	clone.headshot_link = template_human.headshot_link
	clone.vampire_headshot_link = template_human.vampire_headshot_link
	clone.lich_headshot_link = template_human.lich_headshot_link
	
	if(template_human.img_gallery) clone.img_gallery = template_human.img_gallery.Copy()
	if(template_human.nsfw_img_gallery) clone.nsfw_img_gallery = template_human.nsfw_img_gallery.Copy()
	
	clone.ooc_extra = template_human.ooc_extra
	clone.song_title = template_human.song_title
	clone.song_artist = template_human.song_artist
	clone.ooc_extra_img = template_human.ooc_extra_img
	clone.ooc_extra_img_link = template_human.ooc_extra_img_link
	clone.nsfw_ooc_extra_img = template_human.nsfw_ooc_extra_img
	clone.nsfw_ooc_extra_img_link = template_human.nsfw_ooc_extra_img_link
	clone.examine_theme = template_human.examine_theme
	clone.rumour = template_human.rumour
	clone.noble_gossip = template_human.noble_gossip
	clone.erpprefs = template_human.erpprefs
	clone.erpprefs_cached = template_human.erpprefs_cached

	var/flavor = template_human.flavortext
	if(flavor)
		clone.flavortext = flavor
		clone.flavortext_cached = parsemarkdown_basic(html_encode(flavor), hyperlink = TRUE)

	if(template_human.ooc_notes)
		clone.ooc_notes = template_human.ooc_notes
		clone.ooc_notes_cached = parsemarkdown_basic(html_encode(clone.ooc_notes), hyperlink = TRUE)

	if(template_human.nsfwflavortext)
		clone.nsfwflavortext = template_human.nsfwflavortext
		clone.nsfwflavortext_cached = parsemarkdown_basic(html_encode(clone.nsfwflavortext), hyperlink = TRUE)

	var/target_job = "Unassigned"
	if(template_human.mind && template_human.mind.assigned_role)
		target_job = template_human.mind.assigned_role
	
	clone.job = target_job
	if(clone.mind)
		clone.mind.assigned_role = target_job
		clone.mind.special_role = "Homunculus"

	if(!clone.skills)
		clone.skills = new /datum/skill_holder()
		clone.skills.set_current(clone)

	if(template_human.skills && clone.skills)
		clone.skills.known_skills = template_human.skills.known_skills.Copy()
		clone.skills.skill_experience = template_human.skills.skill_experience.Copy()
	
	if(template_human.mind && template_human.mind.sleep_adv && clone.mind)
		for(var/skill_path in template_human.skills.known_skills)
			if(template_human.skills.known_skills[skill_path] >= SKILL_LEVEL_APPRENTICE)
				var/datum/sleep_adv/sadv = template_human.mind.sleep_adv
				if(hascall(sadv, "get_sleep_xp"))
					var/xp_amount = call(sadv, "get_sleep_xp")(skill_path)
					if(xp_amount > 0)
						clone.mind.add_sleep_experience(skill_path, xp_amount, silent = TRUE, show_xp = FALSE)
	
	if(template_human.mob_descriptors)
		clone.mob_descriptors = template_human.mob_descriptors.Copy()

	if(length(template_human.custom_descriptors))
		clone.custom_descriptors = list()
		for(var/datum/custom_descriptor_entry/E in template_human.custom_descriptors)
			var/datum/custom_descriptor_entry/new_E = new /datum/custom_descriptor_entry()
			new_E.prefix_type = E.prefix_type
			new_E.content_text = E.content_text
			clone.custom_descriptors += new_E

	clone.STASTR = max(1, template_human.STASTR - 3)
	clone.STACON = max(1, template_human.STACON - 3)
	clone.STASPD = max(1, template_human.STASPD - 3)
	clone.STAINT = max(1, template_human.STAINT - 3)
	clone.STAPER = max(1, template_human.STAPER - 3)
	clone.STAWIL = max(1, template_human.STAWIL - 3)
	clone.STALUC = max(1, template_human.STALUC - 3)

	if(template_human.status_traits)
		for(var/trait_id in template_human.status_traits)
			if(trait_id in list(TRAIT_DNR, TRAIT_BLIND, TRAIT_MUTE, TRAIT_DEAF))
				continue
			ADD_TRAIT(clone, trait_id, "homunculus_copy")

	ADD_TRAIT(clone, TRAIT_DNR, "homunculus_copy")

	clone.copy_known_languages_from(template_human, TRUE)
	clone.update_body()
	clone.update_hair()
	clone.update_body_parts(TRUE)
	to_chat(clone, span_userdanger("Вы были созданы из алхимической глины. Вы — несовершенная копия [template_human.real_name]. Ваша воля свободна, но плоть хрупка. Ваш создатель — [user.real_name]."))

	qdel(src)
