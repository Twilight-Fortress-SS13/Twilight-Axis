/datum/charflaw/lawless
    name = "Lawless"
    desc = "I've always felt the rules were a bit more like guidelines than actual rules, and have accrued enough notoriety to have a bounty out on my head."
    var/required_pq = 20
    var/static/list/allowed_jobs = list(
        "Adventurer",
        "Trader",
    )

/datum/charflaw/lawless/apply_post_equipment(mob/living/carbon/human/user)
    if(!istype(user) || !user.mind || !user.ckey)
        return

    if(get_playerquality(user.ckey, FALSE) < required_pq || (!(user.job in allowed_jobs)))
        user.charflaw = new /datum/charflaw/randflaw
        user.charflaw.apply_post_equipment(user)
        return
    
    var/list/states = list(
        "The Justiciary of Azuria" = GLOB.outlawed_players,
        "The Grenzelhoftian Holy See" = GLOB.excommunicated_players,
        "The Otavan Holy See" = GLOB.excommunicated_players,
        )

    var/chosen_state = tgui_input_list(user, "Who placed a bounty on you?", "Bounty Poster", states)

    if(!chosen_state)
        chosen_state = pick(states)
    
    var/my_crime = tgui_input_text(user, "What is your crime?", "Crime")

    if(!my_crime)
        my_crime = "crimes against the Crown"
    
    var/list/bounty_cats = list(
        "Misdeed" = rand(51, 100),
        "Worrisome" = rand(101, 150),
        "Atrocious" = rand(150, 200),
        )
    
    var/bounty_key = tgui_input_list(user, "How grave are your crimes?", "Blooded Gold", bounty_cats)
    var/bounty_amount = bounty_key ? bounty_cats[bounty_key] : rand(51, 200)

    var/race = user.dna.species
    var/gender = user.gender
    var/list/d_list = user.get_mob_descriptors()
    var/descriptor_height = build_coalesce_description_nofluff(d_list, user, list(MOB_DESCRIPTOR_SLOT_HEIGHT), "%DESC1%")
    var/descriptor_body = build_coalesce_description_nofluff(d_list, user, list(MOB_DESCRIPTOR_SLOT_BODY), "%DESC1%")
    var/descriptor_voice = build_coalesce_description_nofluff(d_list, user, list(MOB_DESCRIPTOR_SLOT_VOICE), "%DESC1%")

    add_bounty(user.real_name, race, gender, descriptor_height, descriptor_body, descriptor_voice, bounty_amount, FALSE, my_crime, chosen_state)

    var/list/to_add = states[chosen_state]
    to_add += user.real_name

    to_chat(user, span_notice("I'm on the run from the law, and there's a sum of mammons out on my head... better lay low."))
