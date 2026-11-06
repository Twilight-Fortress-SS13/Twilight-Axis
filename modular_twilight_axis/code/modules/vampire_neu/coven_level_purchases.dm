#define TA_COVEN_LEVEL_PURCHASE_ACTION "purchase_coven_level"
#define TA_COVEN_LEVEL_VITAE_RESERVE 400

/datum/coven/proc/ta_level_blood_cost(target_level)
	if(target_level < 1 || target_level > max_level || target_level > 5)
		return 0
	return target_level * 500

/datum/coven/proc/ta_next_level()
	if(level >= max_level)
		return 0
	return level + 1

/datum/coven/proc/ta_purchase_nodes_for_level(target_level)
	if(!research_interface)
		initialize_research_tree()

	var/list/purchase_nodes = list()
	for(var/research_type in research_interface.research_nodes)
		if(research_type in unlocked_research)
			continue
		var/datum/coven_research_node/node = research_interface.get_research_node(research_type)
		if(!node || node.required_level != target_level)
			continue
		purchase_nodes += research_type
	return purchase_nodes

/datum/coven/proc/ta_level_research_cost(target_level, list/purchase_nodes = null)
	var/total_cost = 0
	if(purchase_nodes)
		for(var/research_type in purchase_nodes)
			var/datum/coven_research_node/node = research_interface.get_research_node(research_type)
			if(node?.research_cost)
				total_cost += max(node.research_cost, 0)
		return total_cost

	for(var/power_type in all_powers)
		if(has_power(power_type))
			continue
		var/datum/coven_power/power = new power_type(src)
		if(power.level == target_level)
			total_cost += max(power.research_cost, 0)
		qdel(power)
	return total_cost

/datum/coven/proc/ta_validate_purchase_nodes(mob/living/carbon/human/buyer, list/purchase_nodes, silent = FALSE)
	for(var/research_type in purchase_nodes)
		var/datum/coven_research_node/node = research_interface.get_research_node(research_type)
		if(!node)
			continue
		if(node.minimal_generation > buyer.get_vampire_generation())
			if(!silent)
				to_chat(buyer, span_warning("[node.name] requires [GLOB.vamp_generation_to_text[node.minimal_generation]]."))
			return FALSE
		for(var/prereq in node.prerequisites)
			if((prereq in unlocked_research) || (prereq in purchase_nodes))
				continue
			var/datum/coven_research_node/prereq_node = research_interface.get_research_node(prereq)
			var/prereq_name = prereq_node ? prereq_node.name : "another power"
			if(!silent)
				to_chat(buyer, span_warning("[node.name] requires [prereq_name] first."))
			return FALSE
	return TRUE

/datum/coven/proc/ta_purchase_next_level(mob/living/carbon/human/buyer)
	if(!istype(buyer) || buyer != owner)
		return FALSE

	var/datum/antagonist/vampire/vampire = buyer.mind?.has_antag_datum(/datum/antagonist/vampire)
	if(!vampire)
		return FALSE

	var/target_level = ta_next_level()
	if(!target_level)
		to_chat(buyer, span_notice("[name] is already mastered."))
		return FALSE

	var/blood_cost = ta_level_blood_cost(target_level)
	if(blood_cost <= 0)
		to_chat(buyer, span_warning("[name] cannot be purchased beyond its natural limits."))
		return FALSE

	var/list/purchase_nodes = ta_purchase_nodes_for_level(target_level)
	if(!ta_validate_purchase_nodes(buyer, purchase_nodes))
		return FALSE

	var/research_cost = ta_level_research_cost(target_level, purchase_nodes)
	var/vitae_reserve = TA_COVEN_LEVEL_VITAE_RESERVE
	if(buyer.bloodpool - blood_cost < vitae_reserve)
		to_chat(buyer, span_warning("I need [blood_cost] spendable Vitae to raise [name] to level [target_level], while keeping [vitae_reserve] Vitae in reserve."))
		return FALSE
	if(vampire.research_points < research_cost)
		to_chat(buyer, span_warning("I need [research_cost] RP to raise [name] to level [target_level]."))
		return FALSE

	buyer.adjust_bloodpool(-blood_cost)
	vampire.research_points -= research_cost
	vampire.research_spent += research_cost
	level = target_level
	experience = 0

	var/datum/coven_power/last_granted_power
	for(var/research_type in purchase_nodes)
		var/datum/coven_research_node/node = research_interface.get_research_node(research_type)
		if(!node || (research_type in unlocked_research))
			continue

		unlocked_research += research_type
		if(node.unlocks_power)
			if(grant_power(node.unlocks_power, "level_unlock"))
				last_granted_power = get_power(node.unlocks_power)
		if(node.special_effect)
			apply_research_effect(node.special_effect)

	if(last_granted_power)
		current_power = last_granted_power
		level_casting = known_powers.Find(last_granted_power)

	coven_action?.build_all_button_icons(force = TRUE)
	to_chat(buyer, span_boldnotice("I raise [name] to level [level] for [blood_cost] Vitae and [research_cost] RP."))
	return TRUE

/datum/coven/gain_experience(amount)
	return FALSE

/datum/coven/check_level_up()
	return FALSE

/datum/coven/level_up()
	return FALSE

/datum/coven/gain_experience_from_source(amount, source, datum/coven_power/power_used = null, multiplier = 1)
	return FALSE

/datum/coven/on_power_use_success(datum/coven_power/power, is_critical = FALSE, exp_multiplier = 1, vitae_spent = 0)
	return FALSE

/datum/coven/on_discovery_event(discovery_type)
	return FALSE

/datum/coven/on_teaching_event(mob/student, datum/coven_power/power_taught)
	return FALSE

/datum/coven/on_meditation_complete(duration_minutes)
	return FALSE

/datum/coven/on_combat_power_use(datum/coven_power/power, target)
	return FALSE

/datum/coven/on_roleplay_moment(intensity = 1)
	return FALSE

/datum/coven_power/grant_usage_xp(atom/target, is_refresh = FALSE)
	return

/datum/coven_power/admin_grant_xp(amount, reason)
	if(owner)
		to_chat(owner, span_warning("Coven XP is disabled. Coven levels are purchased with Vitae and RP."))
	log_admin("[key_name(usr)] attempted to grant disabled coven XP to [key_name(owner)] in [discipline?.name] for: [reason]")

/datum/coven_power/admin_view_xp_stats()
	if(!discipline)
		return "No discipline found"

	var/target_level = discipline.ta_next_level()
	var/stats = ""
	stats += "=== COVEN LEVEL PURCHASES FOR [discipline.name] ===\n"
	stats += "Current Level: [discipline.level]/[discipline.max_level]\n"
	if(target_level)
		stats += "Next Level Cost: [discipline.ta_level_blood_cost(target_level)] Vitae, [discipline.ta_level_research_cost(target_level)] RP\n"
	else
		stats += "Next Level Cost: mastered\n"
	stats += "Powers Known: [length(discipline.known_powers)]\n"
	return stats

/datum/coven_research_interface/get_experience_percentage()
	if(!parent_coven || parent_coven.max_level <= 0)
		return 100
	return round((parent_coven.level / parent_coven.max_level) * 100, 1)

/datum/clan_menu_interface/proc/ta_generate_coven_purchase_panel(datum/coven/selected_coven, in_preview = FALSE)
	if(in_preview || !selected_coven)
		return ""

	var/target_level = selected_coven.ta_next_level()
	var/datum/antagonist/vampire/vampire = user.mind?.has_antag_datum(/datum/antagonist/vampire)
	var/current_rp = vampire ? vampire.research_points : 0

	if(!target_level)
		return {"
		<div style='position:absolute; top:16px; left:16px; z-index:20; width:280px; background:rgba(18,12,10,0.92); border:1px solid #8B4513; padding:14px; color:#eee; box-shadow:0 4px 18px rgba(0,0,0,0.45);'>
			<div style='color:#FFD700; font-weight:bold; margin-bottom:6px;'>[selected_coven.name]</div>
			<div style='font-size:12px; color:#ccc;'>Level [selected_coven.level]/[selected_coven.max_level]</div>
			<div style='margin-top:10px; color:#90EE90;'>Mastered</div>
		</div>
		"}

	var/blood_cost = selected_coven.ta_level_blood_cost(target_level)
	var/research_cost = selected_coven.ta_level_research_cost(target_level)
	var/vitae_reserve = TA_COVEN_LEVEL_VITAE_RESERVE
	var/spendable_vitae = max(user.bloodpool - vitae_reserve, 0)
	var/can_afford = spendable_vitae >= blood_cost && current_rp >= research_cost
	var/button_html
	if(can_afford)
		button_html = "<a href='byond://?src=[REF(src)];action=purchase_coven_level' style='display:inline-block; margin-top:10px; padding:8px 12px; background:#7a1f1f; color:#fff; text-decoration:none; border:1px solid #d69b5f;'>Purchase level [target_level]</a>"
	else
		button_html = "<div style='margin-top:10px; padding:8px 12px; background:#333; color:#aaa; border:1px solid #555; display:inline-block;'>Insufficient Vitae or RP</div>"

	return {"
	<div style='position:absolute; top:16px; left:16px; z-index:20; width:300px; background:rgba(18,12,10,0.92); border:1px solid #8B4513; padding:14px; color:#eee; box-shadow:0 4px 18px rgba(0,0,0,0.45);'>
		<div style='color:#FFD700; font-weight:bold; margin-bottom:6px;'>[selected_coven.name]</div>
		<div style='font-size:12px; color:#ccc;'>Level [selected_coven.level]/[selected_coven.max_level]</div>
		<div style='margin-top:8px; font-size:13px;'>Next level: <b>[target_level]</b></div>
		<div style='font-size:12px; color:#ddd;'>Cost: [blood_cost] Vitae + [research_cost] RP</div>
		<div style='font-size:11px; color:#aaa;'>You have: [spendable_vitae] spendable Vitae + [current_rp] RP</div>
		<div style='font-size:11px; color:#777;'>[vitae_reserve] Vitae is kept in reserve</div>
		[button_html]
	</div>
	"}

/datum/clan_menu_interface/generate_coven_list_html()
	var/html = ""

	if(!user_covens || !length(user_covens))
		return "<li style='color: #999; padding: 20px; text-align: center;'>No covens available</li>"

	for(var/coven_name in user_covens)
		var/datum/coven/coven = user_covens[coven_name]
		var/level_percent = coven.max_level > 0 ? round((coven.level / coven.max_level) * 100, 1) : 100
		var/next_level = coven.ta_next_level()
		var/next_cost_text = "Mastered"
		if(next_level)
			next_cost_text = "[coven.ta_level_blood_cost(next_level)] Vitae / [coven.ta_level_research_cost(next_level)] RP"

		html += {"
		<li class="coven-item" onclick="selectCoven('[coven_name]')">
			<div class="coven-name">[coven.name]</div>
			<div class="coven-stats">
				<span>Level [coven.level]/[coven.max_level]</span>
				<span>[next_cost_text]</span>
			</div>
			<div class="coven-progress">
				<div class="coven-progress-fill" style="width: [level_percent]%"></div>
			</div>
		</li>
		"}

	return html

/datum/clan_menu_interface/load_coven_research_tree(coven_name, preview = FALSE)
	if(isnull(coven_name))
		return

	if(!(coven_name in user_covens) && !preview)
		return

	var/datum/coven/selected_coven

	if(preview)
		selected_coven = new coven_name()
		current_coven = selected_coven.name
	else
		selected_coven = user_covens[coven_name]
		current_coven = coven_name

	if(!selected_coven.research_interface)
		selected_coven.initialize_research_tree()

	var/research_html = {"
	<div class="parallax-container">
		<div class="parallax-layer parallax-bg" id="parallax-bg"></div>
		<div class="parallax-layer parallax-stars-1" id="parallax-stars-1"></div>
		<div class="parallax-layer parallax-neb" id="parallax-neb"></div>
	</div>

	[ta_generate_coven_purchase_panel(selected_coven, preview)]

	<div class="research-container" id="container">
		<div class="research-canvas" id="canvas">
			[selected_coven.research_interface.generate_coven_connections_html()]
			[selected_coven.research_interface.generate_coven_nodes_html()]
		</div>
	</div>

	<div class="tooltip" id="tooltip" style="display: none;"></div>
	"}

	user << browse(generate_combined_html(research_html, in_preview = TRUE), "window=clan_menu")

/datum/clan_menu_interface/Topic(href, href_list)
	if(href_list["action"] == TA_COVEN_LEVEL_PURCHASE_ACTION)
		if(!user || !current_coven || !(current_coven in user_covens))
			return
		var/datum/coven/coven = user_covens[current_coven]
		coven?.ta_purchase_next_level(user)
		load_coven_research_tree(current_coven)
		return

	return ..()

#undef TA_COVEN_LEVEL_PURCHASE_ACTION
#undef TA_COVEN_LEVEL_VITAE_RESERVE
