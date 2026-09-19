#define GENE_GROUP_BODY_SIZE "body_size"
#define GENE_GROUP_SPEED "speed"
#define GENE_GROUP_CONSTITUTION "constitution"
#define GENE_GROUP_TEMPERAMENT "temperament"
#define GENE_GROUP_DIET "diet"
#define GENE_GROUP_HIDE "hide"
#define GENE_GROUP_BREEDING "breeding"
#define GENE_GROUP_PROGENY "progeny"
#define GENE_GROUP_METABOLISM "metabolism"
#define GENE_GROUP_PRODUCTIVITY "productivity"
#define GENE_GROUP_LINEAGE "lineage"

#define GENETICS_MUTATION_CHANCE 15
#define GENETICS_MAX_GENES 4
#define GENETICS_INTENSITY_NOISE 1
#define GENETICS_INTENSITY_FLOOR 0.9
#define GENETICS_DOMINANT_PASS_CHANCE 70
#define GENETICS_RECESSIVE_PASS_CHANCE 40

#define RECESSIVE_NONE 0
#define RECESSIVE_CARRIED 1
#define RECESSIVE_EXPRESSED 2

#define LINEAGE_MOTHER "mother"
#define LINEAGE_FATHER "father"

/datum/animal_gene
	var/name = "Unknown Gene"
	var/desc = "An unknown hereditary trait."
	var/rarity = 10
	var/exclusion_group
	var/dominant = TRUE
	var/recessive_state = RECESSIVE_NONE
	var/intensity = 1
	var/intensity_min = 10
	var/intensity_max = 10
	var/list/type_whitelist

/datum/animal_gene/New()
	. = ..()
	if(intensity_min != intensity_max)
		intensity = rand(intensity_min, intensity_max) * 0.1
	else
		intensity = intensity_min * 0.1

/datum/animal_gene/proc/allowed_for(mob/living/simple_animal/target)
	if(!type_whitelist)
		return TRUE
	for(var/allowed_type in type_whitelist)
		if(istype(target, allowed_type))
			return TRUE
	return FALSE

/datum/animal_gene/proc/apply_to(mob/living/simple_animal/target)
	return

/datum/animal_gene/proc/breed_with(datum/animal_gene/other)
	var/datum/animal_gene/offspring = new type()
	offspring.dominant = dominant
	if(!offspring.dominant)
		offspring.recessive_state = RECESSIVE_CARRIED

	var/minimum_intensity = intensity_min * 0.1 * GENETICS_INTENSITY_FLOOR
	var/maximum_intensity = intensity_max * 0.1
	if(!other)
		var/noise = rand(-GENETICS_INTENSITY_NOISE, GENETICS_INTENSITY_NOISE) * 0.1 * intensity
		offspring.intensity = clamp(intensity + noise, minimum_intensity, maximum_intensity)
		return offspring

	var/low = min(intensity, other.intensity)
	var/high = max(intensity, other.intensity)
	var/base = low + (rand(4, 10) * 0.1) * (high - low)
	var/noise = rand(-GENETICS_INTENSITY_NOISE, GENETICS_INTENSITY_NOISE) * 0.1 * high
	offspring.intensity = clamp(base + noise, minimum_intensity, maximum_intensity)
	return offspring

/datum/animal_genetics
	var/datum/weakref/owner_ref
	var/list/datum/animal_gene/genes = list()

/datum/animal_genetics/New(mob/living/simple_animal/owner)
	. = ..()
	owner_ref = WEAKREF(owner)

/datum/animal_genetics/Destroy()
	QDEL_LIST(genes)
	genes = null
	owner_ref = null
	return ..()

/datum/animal_genetics/proc/should_express(datum/animal_gene/gene)
	var/mob/living/simple_animal/owner = owner_ref?.resolve()
	if(!owner || !gene.allowed_for(owner))
		return FALSE
	if(gene.dominant)
		return TRUE
	return gene.recessive_state == RECESSIVE_EXPRESSED

/datum/animal_genetics/proc/get_gene_count()
	return length(genes)

/datum/animal_genetics/proc/get_gene_by_group(group)
	for(var/datum/animal_gene/gene in genes)
		if(gene.exclusion_group == group)
			return gene
	return null

/datum/animal_genetics/proc/_insert_gene(datum/animal_gene/new_gene)
	if(!new_gene)
		return FALSE
	if(length(genes) >= GENETICS_MAX_GENES)
		return FALSE
	if(new_gene.exclusion_group)
		for(var/datum/animal_gene/existing in genes)
			if(existing.exclusion_group != new_gene.exclusion_group)
				continue
			genes -= existing
			qdel(existing)
			break
	genes += new_gene
	return TRUE

/datum/animal_genetics/proc/refresh()
	var/mob/living/simple_animal/owner = owner_ref?.resolve()
	if(!owner)
		return
	owner.reset_genetic_modifiers()
	for(var/datum/animal_gene/gene in genes)
		if(should_express(gene))
			gene.apply_to(owner)
	owner.apply_genetic_modifiers()

/datum/animal_genetics/proc/get_gene_names()
	var/list/names = list()
	var/mob/living/simple_animal/owner = owner_ref?.resolve()
	for(var/datum/animal_gene/gene in genes)
		var/max_intensity = max(0.1, gene.intensity_max * 0.1)
		var/percent = round((gene.intensity / max_intensity) * 100)
		var/display_name
		var/tooltip = gene.desc
		if(owner && !gene.allowed_for(owner))
			display_name = "[gene.name] [percent]% (dormant)"
			tooltip += " This trait is dormant in this species and currently has no effect."
		else if(should_express(gene))
			display_name = "[gene.name] [percent]%"
		else
			display_name = "[gene.name] [percent]% (recessive)"
			tooltip += " This recessive trait is carried but currently has no effect."
		names += SPAN_TOOLTIP(tooltip, display_name)
	return names

/datum/animal_genetics/proc/get_natural_armor_for_type(type_string)
	var/total = 0
	for(var/datum/animal_gene/hide/gene in genes)
		if(!should_express(gene))
			continue
		if(type_string in gene.armor_covered)
			total += round(gene.intensity)
	return total

/mob/living/simple_animal/run_armor_check(def_zone = null, attack_flag = "blunt", absorb_text = null, soften_text = null, armor_penetration = PEN_NONE, penetrated_text, damage, blade_dulling, intdamfactor, used_weapon = null, pen_info, no_debuff = FALSE)
	. = ..()
	if(!isnum(damage) || damage <= 0 || !genetics || ispath(genetics))
		return
	var/natural_armor_percent = genetics.get_natural_armor_for_type(attack_flag)
	if(natural_armor_percent <= 0)
		return
	var/unblocked_damage = max(0, damage - .)
	if(unblocked_damage <= 0)
		return
	. += unblocked_damage * (clamp(natural_armor_percent, 0, 100) * 0.01)

/datum/animal_genetics/proc/_build_allele_pool()
	var/list/pool = list()
	for(var/datum/animal_gene/gene in genes)
		var/pass_chance = gene.dominant ? GENETICS_DOMINANT_PASS_CHANCE : GENETICS_RECESSIVE_PASS_CHANCE
		if(!prob(pass_chance))
			continue
		var/key = gene.exclusion_group ? gene.exclusion_group : "[gene.type]"
		pool[key] = gene
	return pool

/datum/animal_genetics/proc/_breed_pools(list/mother_pool, list/father_pool, mob/living/simple_animal/father)
	var/lineage_weight = 0.5
	var/datum/animal_gene/dominant_lineage/lineage_gene
	for(var/datum/animal_gene/dominant_lineage/candidate in genes)
		if(should_express(candidate))
			lineage_gene = candidate
			break
	if(!lineage_gene && father?.genetics)
		for(var/datum/animal_gene/dominant_lineage/candidate in father.genetics.genes)
			if(father.genetics.should_express(candidate))
				lineage_gene = candidate
				break
	if(lineage_gene)
		var/skew = clamp(lineage_gene.intensity * 0.5, 0.05, 0.5)
		lineage_weight = lineage_gene.favored_side == LINEAGE_MOTHER ? 0.5 + skew : 0.5 - skew

	var/list/result = list()
	var/list/all_keys = list()
	for(var/key in mother_pool)
		all_keys |= key
	for(var/key in father_pool)
		all_keys |= key

	for(var/key in all_keys)
		var/datum/animal_gene/mother_gene = mother_pool[key]
		var/datum/animal_gene/father_gene = father_pool[key]
		var/datum/animal_gene/offspring
		if(mother_gene && father_gene)
			if(prob(lineage_weight * 100))
				offspring = mother_gene.breed_with(father_gene)
			else
				offspring = father_gene.breed_with(mother_gene)
			if(!offspring.dominant)
				offspring.recessive_state = RECESSIVE_EXPRESSED
		else
			var/datum/animal_gene/source = mother_gene ? mother_gene : father_gene
			if(lineage_gene)
				var/from_mother = !!mother_gene
				var/favors_mother = lineage_gene.favored_side == LINEAGE_MOTHER
				if(from_mother != favors_mother && !prob((1 - abs(lineage_weight - 0.5) * 2) * 100))
					continue
			offspring = source.breed_with(null)
			if(!offspring.dominant)
				offspring.recessive_state = RECESSIVE_CARRIED
		result += offspring
	return result

/datum/animal_genetics/proc/inherit_to(mob/living/simple_animal/baby, mob/living/simple_animal/father)
	if(!baby)
		return
	if(!baby.genetics || ispath(baby.genetics))
		baby.genetics = new /datum/animal_genetics(baby)
	else
		QDEL_LIST(baby.genetics.genes)
		baby.genetics.genes = list()

	var/list/mother_pool = _build_allele_pool()
	var/list/father_pool = list()
	if(father && father.genetics && !ispath(father.genetics))
		father_pool = father.genetics._build_allele_pool()
	var/list/candidates = _breed_pools(mother_pool, father_pool, father)
	candidates = shuffle(candidates)
	for(var/datum/animal_gene/gene in candidates)
		if(!baby.genetics._insert_gene(gene))
			qdel(gene)

	if(length(baby.genetics.genes) < GENETICS_MAX_GENES && prob(GENETICS_MUTATION_CHANCE))
		var/datum/animal_gene/mutation = genetics_roll_mutation(baby)
		if(mutation && !baby.genetics._insert_gene(mutation))
			qdel(mutation)

	baby.genetics.refresh()
	var/list/expressed = list()
	for(var/datum/animal_gene/gene in baby.genetics.genes)
		if(baby.genetics.should_express(gene))
			expressed += gene.name
	if(length(expressed))
		baby.visible_message(span_notice("[baby] is born showing distinct traits: [english_list(expressed)]."))

/datum/animal_genetics/proc/copy_to(mob/living/simple_animal/target)
	if(!target)
		return
	if(!target.genetics || ispath(target.genetics))
		target.genetics = new /datum/animal_genetics(target)
	else
		QDEL_LIST(target.genetics.genes)
		target.genetics.genes = list()
	for(var/datum/animal_gene/gene in genes)
		var/datum/animal_gene/copy = new gene.type()
		copy.dominant = gene.dominant
		copy.recessive_state = gene.recessive_state
		copy.intensity = gene.intensity
		if(istype(gene, /datum/animal_gene/dominant_lineage))
			var/datum/animal_gene/dominant_lineage/source_lineage = gene
			var/datum/animal_gene/dominant_lineage/copy_lineage = copy
			copy_lineage.favored_side = source_lineage.favored_side
		if(!target.genetics._insert_gene(copy))
			qdel(copy)
	target.genetics.refresh()

/proc/genetics_roll_mutation(mob/living/simple_animal/target)
	if(!target || !length(GLOB.ta_animal_genes_weighted))
		return null
	var/list/valid = list()
	for(var/gene_type in GLOB.ta_animal_genes_weighted)
		var/datum/animal_gene/test_gene = new gene_type()
		if(test_gene.allowed_for(target))
			valid[gene_type] = GLOB.ta_animal_genes_weighted[gene_type]
		qdel(test_gene)
	if(!length(valid))
		return null
	var/gene_path = pickweight(valid)
	return new gene_path()

/mob/living/simple_animal
	var/datum/animal_genetics/genetics = /datum/animal_genetics
	var/generate_genetics = FALSE
	var/genetic_butcher_scale = 1
	var/genetic_speed_delta = 0
	var/genetic_health_multiplier = 1
	var/genetic_melee_multiplier = 1
	var/genetic_breed_multiplier = 1
	var/genetic_production_multiplier = 1
	var/genetic_food_consumption_multiplier = 1
	var/genetic_tame_chance_bonus = 0
	var/genetic_bonus_tame_bonus = 0
	var/genetic_extra_litter_chance = 0
	var/genetic_max_extra_litter = 0
	var/list/genetic_added_foods = list()
	var/list/genetic_removed_foods = list()
	var/list/genetic_base_foods
	var/can_receive_livestock_commands = FALSE

/mob/living/simple_animal/proc/ta_supports_animal_genetics()
	if(istype(src, /mob/living/simple_animal/hostile/retaliate/rogue/cow))
		return TRUE
	if(istype(src, /mob/living/simple_animal/hostile/retaliate/rogue/bull))
		return TRUE
	if(istype(src, /mob/living/simple_animal/hostile/retaliate/rogue/goat))
		return TRUE
	if(istype(src, /mob/living/simple_animal/hostile/retaliate/rogue/goatmale))
		return TRUE
	if(istype(src, /mob/living/simple_animal/hostile/retaliate/rogue/swine))
		return TRUE
	if(istype(src, /mob/living/simple_animal/hostile/retaliate/rogue/saiga))
		return TRUE
	if(istype(src, /mob/living/simple_animal/hostile/retaliate/rogue/fogbeast))
		return TRUE
	if(istype(src, /mob/living/simple_animal/hostile/retaliate/rogue/wolf))
		return TRUE
	if(istype(src, /mob/living/simple_animal/hostile/retaliate/rogue/spider))
		return TRUE
	if(istype(src, /mob/living/simple_animal/hostile/retaliate/rogue/mirespider))
		return TRUE
	return FALSE

/mob/living/simple_animal/proc/initialize_animal_genetics()
	if(adult_growth)
		return
	var/supported_species = ta_supports_animal_genetics()
	if(!generate_genetics && !supported_species)
		return
	if(supported_species)
		generate_genetics = TRUE
		can_receive_livestock_commands = TRUE
	if(!genetics || ispath(genetics))
		var/genetics_type = ispath(genetics) ? genetics : /datum/animal_genetics
		genetics = new genetics_type(src)
	roll_initial_genetics()

/mob/living/simple_animal/proc/roll_initial_genetics(max_genes = 2, intensity_bound_cap = 0.4, recessive_bias = 30)
	if(!genetics || ispath(genetics))
		genetics = new /datum/animal_genetics(src)
	var/attempts = 0
	while(genetics.get_gene_count() < max_genes && attempts < max_genes * 5)
		attempts++
		var/datum/animal_gene/gene = genetics_roll_mutation(src)
		if(!gene)
			continue
		var/capped_max = max(gene.intensity_min, round(gene.intensity_max * intensity_bound_cap))
		gene.intensity = rand(gene.intensity_min, capped_max) * 0.1
		if(prob(recessive_bias))
			gene.dominant = FALSE
			gene.recessive_state = RECESSIVE_CARRIED
		if(!genetics._insert_gene(gene))
			qdel(gene)
	genetics.refresh()

/mob/living/simple_animal/proc/ensure_genetic_baselines()
	if(isnull(genetic_base_foods))
		genetic_base_foods = islist(food_type) ? food_type.Copy() : list()

/mob/living/simple_animal/proc/reset_genetic_modifiers()
	genetic_butcher_scale = 1
	genetic_speed_delta = 0
	genetic_health_multiplier = 1
	genetic_melee_multiplier = 1
	genetic_breed_multiplier = 1
	genetic_production_multiplier = 1
	genetic_food_consumption_multiplier = 1
	genetic_tame_chance_bonus = 0
	genetic_bonus_tame_bonus = 0
	genetic_extra_litter_chance = 0
	genetic_max_extra_litter = 0
	genetic_added_foods = list()
	genetic_removed_foods = list()

/mob/living/simple_animal/proc/apply_genetic_modifiers()
	ensure_genetic_baselines()
	var/old_max_health = max(1, maxHealth)
	var/health_ratio = clamp(health / old_max_health, 0, 1)
	maxHealth = max(5, round(initial(maxHealth) * genetic_health_multiplier))
	health = min(maxHealth, round(maxHealth * health_ratio))
	melee_damage_lower = max(0, round(initial(melee_damage_lower) * genetic_melee_multiplier))
	melee_damage_upper = max(melee_damage_lower, round(initial(melee_damage_upper) * genetic_melee_multiplier))

	food_type = genetic_base_foods.Copy()
	for(var/food_path in genetic_removed_foods)
		food_type -= food_path
	for(var/food_path in genetic_added_foods)
		food_type |= food_path
	food_typecache = length(food_type) ? typecacheof(food_type) : null
	if(ai_controller && length(food_type))
		ai_controller.set_blackboard_key(BB_BASIC_FOODS, typecacheof(food_type))
	update_move_intent_slowdown()

/mob/living/simple_animal/proc/get_genetic_breed_cooldown()
	return max(10 SECONDS, breedcd * genetic_breed_multiplier)

/mob/living/simple_animal/proc/get_genetic_litter_size(maximum_total = 3)
	var/total = 1
	if(genetic_max_extra_litter > 0 && genetic_extra_litter_chance > 0)
		for(var/i in 1 to genetic_max_extra_litter)
			if(!prob(genetic_extra_litter_chance))
				break
			total++
	return clamp(total, 1, max(1, maximum_total))

/mob/living/simple_animal/proc/get_genetics_examine()
	if(!genetics || ispath(genetics) || !length(genetics.genes))
		return null
	return span_notice("Genetic traits: [english_list(genetics.get_gene_names())].")

/mob/living/simple_animal/proc/get_breeding_failure_reason(mob/living/simple_animal/partner, maximum_local_children = 3)
	if(gender != FEMALE)
		return "Only a female can give birth."
	if(adult_growth)
		return "[src] is still too young to breed."
	if(stat != CONSCIOUS)
		return "[src] must be conscious to breed."
	if(!partner)
		return "No breeding partner was selected."
	if(partner == src)
		return "An animal cannot breed with itself."
	if(partner.adult_growth)
		return "[partner] is still too young to breed."
	if(partner.stat != CONSCIOUS)
		return "[partner] must be conscious to breed."
	if(partner.gender != MALE)
		return "The breeding partner must be male."
	if(next_scan_time > world.time)
		return "[src] is not ready to breed again yet."
	if(!childtype)
		return "[src] cannot produce offspring."
	if(!animal_species)
		return "[src] has no compatible breeding species."
	if(!SSticker.IsRoundInProgress())
		return "Animals can only breed during an active round."
	if(GLOB.farm_animals >= get_max_farm_animals())
		return "There are already too many farm animals in the world."
	if(food < 10)
		return "[src] is too hungry to breed."
	if(breedchildren <= 0)
		return "[src] can no longer breed."
	if(partner.breedchildren <= 0)
		return "[partner] can no longer breed."
	if(partner.ckey)
		return "[partner] is currently player-controlled and cannot breed."
	if(partner.flags_1 & HOLOGRAM_1)
		return "Holograms cannot breed."
	if(!istype(partner, animal_species))
		return "[partner] is not a compatible breeding partner for [src]."
	if(get_dist(src, partner) > 7)
		return "The pair is too far apart to breed."
	if(!can_see(src, partner, 7))
		return "The pair cannot see each other."

	var/nearby_children = 0
	for(var/mob/living/simple_animal/nearby in view(7, src))
		if(nearby == src || nearby == partner)
			continue
		for(var/child_path in childtype)
			if(istype(nearby, child_path))
				nearby_children++
				break
	if(nearby_children >= maximum_local_children)
		return "There are already too many young animals nearby."
	if(!get_turf(src))
		return "There is nowhere for the offspring to be born."
	return null

/mob/living/simple_animal/proc/make_babies_with(mob/living/simple_animal/partner, maximum_local_children = 3)
	if(get_breeding_failure_reason(partner, maximum_local_children))
		return 0

	var/nearby_children = 0
	for(var/mob/living/simple_animal/nearby in view(7, src))
		if(nearby == src || nearby == partner)
			continue
		for(var/child_path in childtype)
			if(istype(nearby, child_path))
				nearby_children++
				break

	var/available_local = maximum_local_children - nearby_children
	var/available_global = get_max_farm_animals() - GLOB.farm_animals
	var/available_lifetime = max(0, breedchildren)
	var/wanted = get_genetic_litter_size(min(available_local, min(available_global, available_lifetime)))
	var/turf/target = get_turf(src)
	if(!target || wanted <= 0)
		return 0

	next_scan_time = world.time + get_genetic_breed_cooldown()
	var/spawned = 0
	for(var/i in 1 to wanted)
		if(GLOB.farm_animals >= get_max_farm_animals())
			break
		var/childspawn = pickweight(childtype)
		var/mob/living/simple_animal/baby = new childspawn(target)
		if(!baby)
			continue
		if(genetics && !ispath(genetics))
			genetics.inherit_to(baby, partner)
		if(tame || partner.tame)
			var/mob/living/inherited_owner = (tame && owner) ? owner : (partner.tame ? partner.owner : null)
			baby.tamed(inherited_owner)
		spawned++
	if(spawned)
		breedchildren = max(0, breedchildren - spawned)
	if(spawned > 1)
		visible_message(span_notice("[src] gives birth to a litter of [spawned]!"))
	return spawned

/mob/living/simple_animal/hostile/retaliate/rogue/cow
	generate_genetics = TRUE
	can_receive_livestock_commands = TRUE

/mob/living/simple_animal/hostile/retaliate/rogue/bull
	generate_genetics = TRUE
	can_receive_livestock_commands = TRUE

/mob/living/simple_animal/hostile/retaliate/rogue/goat
	generate_genetics = TRUE
	can_receive_livestock_commands = TRUE

/mob/living/simple_animal/hostile/retaliate/rogue/goatmale
	generate_genetics = TRUE
	can_receive_livestock_commands = TRUE

/mob/living/simple_animal/hostile/retaliate/rogue/swine
	generate_genetics = TRUE
	can_receive_livestock_commands = TRUE

/mob/living/simple_animal/hostile/retaliate/rogue/saiga
	generate_genetics = TRUE
	can_receive_livestock_commands = TRUE

/mob/living/simple_animal/hostile/retaliate/rogue/fogbeast
	generate_genetics = TRUE
	can_receive_livestock_commands = TRUE

/mob/living/simple_animal/hostile/retaliate/rogue/wolf
	generate_genetics = TRUE
	can_receive_livestock_commands = TRUE

/mob/living/simple_animal/hostile/retaliate/rogue/spider
	generate_genetics = TRUE
	can_receive_livestock_commands = TRUE

/mob/living/simple_animal/hostile/retaliate/rogue/mirespider
	generate_genetics = TRUE
	can_receive_livestock_commands = TRUE
