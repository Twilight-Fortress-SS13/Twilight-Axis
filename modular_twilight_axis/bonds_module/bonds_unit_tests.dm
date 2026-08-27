#if defined(UNIT_TESTS) || defined(SPACEMAN_DMM)

#define BD_SOURCE replacetext(__FILE__, "\\", "/")
#define BD_ASSERT(assertion, reason) if(!(assertion)) { return Fail("Assertion failed: [reason || "no reason"]", BD_SOURCE, __LINE__) }
#define BD_ASSERT_EQUAL(a, b, reason) do { var/_lhs = ##a; var/_rhs = ##b; if(_lhs != _rhs) { return Fail("Expected [isnull(_lhs) ? "null" : _lhs] == [isnull(_rhs) ? "null" : _rhs]: [reason || "no reason"]", BD_SOURCE, __LINE__) } } while(FALSE)
#define BD_ASSERT_NOTNULL(a, reason) if(isnull(a)) { return Fail("Expected non-null: [reason || "no reason"]", BD_SOURCE, __LINE__) }
#define BD_ASSERT_NULL(a, reason) if(!isnull(a)) { return Fail("Expected null: [reason || "no reason"]", BD_SOURCE, __LINE__) }

#define BD_DEEP_EVENT_REPEATS 3
#define BD_DEEP_FUZZ_SEQUENCES 80
#define BD_DEEP_FUZZ_STEPS 25

/datum/unit_test/bonds
	abstract_type = /datum/unit_test/bonds
	var/static/bd_test_serial = 0
	var/list/bd_test_minds

/datum/unit_test/bonds/proc/bd_make_mind()
	bd_test_serial++
	var/datum/mind/created = new /datum/mind("BDTEST_[bd_test_serial]")
	created.name = "Test Subject [bd_test_serial]"
	LAZYADD(bd_test_minds, created)
	return created

/datum/unit_test/bonds/Destroy()
	for(var/datum/mind/tracked as anything in bd_test_minds)
		SSbonds.drop_actor(SSbonds.resolve_actor(tracked))
	bd_test_minds = null
	return ..()

/datum/unit_test/bonds/prototypes_built/Run()
	BD_ASSERT(SSbonds.event_prototypes.len > 0, "event prototypes must be built at init")
	BD_ASSERT(SSbonds.stage_prototypes.len > 0, "stage prototypes must be built at init")
	BD_ASSERT_NOTNULL(SSbonds.get_event_prototype(/datum/bond_event/struck_by), "struck_by prototype missing")

/datum/unit_test/bonds/stage_priority_order/Run()
	var/last_priority = null
	for(var/datum/bond_stage/stage as anything in SSbonds.stage_prototypes)
		if(!isnull(last_priority))
			BD_ASSERT(stage.priority <= last_priority, "stage prototypes must be sorted by descending priority")
		last_priority = stage.priority

/datum/unit_test/bonds/bond_creation_is_directed/Run()
	var/datum/mind/a = bd_make_mind()
	var/datum/mind/b = bd_make_mind()
	var/datum/social_bond/forward = SSbonds.get_or_create_bond(a, b)
	BD_ASSERT_NOTNULL(forward, "forward bond must be created")
	BD_ASSERT_NULL(SSbonds.get_bond(b, a), "creating one direction must not create the reverse")
	BD_ASSERT_NULL(SSbonds.get_or_create_bond(a, a), "self bonds must be refused")

/datum/unit_test/bonds/event_applies_transient_and_commit/Run()
	var/datum/mind/a = bd_make_mind()
	var/datum/mind/b = bd_make_mind()
	var/datum/social_bond/bond = SSbonds.get_or_create_bond(a, b)
	bond.attach_event(/datum/bond_event/struck_by)
	var/datum/bond_event/prototype = SSbonds.get_event_prototype(/datum/bond_event/struck_by)
	BD_ASSERT(bond.warmth < 0, "a hostile event must push warmth negative")
	BD_ASSERT(bond.weight > 0, "a hostile event must raise weight")
	BD_ASSERT_EQUAL(bond.warmth_committed, prototype.warmth_commit, "first commit must apply at full scale")
	BD_ASSERT(bond.tags & BOND_TAG_SHED_BLOOD, "struck_by must set the blood tag")
	BD_ASSERT_EQUAL(LAZYLEN(bond.history), 1, "an applied event must record one history entry")

/datum/unit_test/bonds/commit_cooldown_blocks_second_commit/Run()
	var/datum/mind/a = bd_make_mind()
	var/datum/mind/b = bd_make_mind()
	var/datum/social_bond/bond = SSbonds.get_or_create_bond(a, b)
	bond.attach_event(/datum/bond_event/struck_by)
	var/committed_after_first = bond.warmth_committed
	bond.attach_event(/datum/bond_event/struck_by)
	BD_ASSERT_EQUAL(bond.warmth_committed, committed_after_first, "a repeat inside the cooldown must not commit again")
	BD_ASSERT_EQUAL(LAZYLEN(bond.active_events), 1, "same-category repeats must refresh, not stack")

/datum/unit_test/bonds/commit_scale_falls_off/Run()
	var/datum/mind/a = bd_make_mind()
	var/datum/mind/b = bd_make_mind()
	var/datum/social_bond/bond = SSbonds.get_or_create_bond(a, b)
	BD_ASSERT_EQUAL(bond.commit_scale(BOND_CATEGORY_VIOLENCE), 1, "first commit must be unscaled")
	bond.attach_event(/datum/bond_event/struck_by)
	BD_ASSERT(bond.commit_scale(BOND_CATEGORY_VIOLENCE) < 1, "subsequent commits must be scaled down")

/datum/unit_test/bonds/transient_expiry_restores_axes/Run()
	var/datum/mind/a = bd_make_mind()
	var/datum/mind/b = bd_make_mind()
	var/datum/social_bond/bond = SSbonds.get_or_create_bond(a, b)
	bond.attach_event(/datum/bond_event/struck_by)
	var/warmth_with_transient = bond.warmth
	var/datum/bond_event/active = bond.active_events[BOND_CATEGORY_VIOLENCE]
	BD_ASSERT_NOTNULL(active, "event must be active before expiry")
	active.expire()
	BD_ASSERT(bond.warmth > warmth_with_transient, "expiring the transient part must relax warmth back toward the committed value")
	BD_ASSERT_EQUAL(bond.warmth, bond.warmth_committed, "after expiry only the committed residue remains")

/datum/unit_test/bonds/stage_resolves_from_axes/Run()
	var/datum/mind/a = bd_make_mind()
	var/datum/mind/b = bd_make_mind()
	var/datum/social_bond/bond = SSbonds.get_or_create_bond(a, b)
	BD_ASSERT_EQUAL(bond.stage_group(), BOND_GROUP_KNOWN, "a fresh bond must be a stranger")
	bond.warmth_committed = 80
	bond.weight_committed = 60
	bond.recalculate()
	BD_ASSERT_EQUAL(bond.stage_group(), BOND_GROUP_WARM, "high warmth and weight must resolve to a warm stage")
	bond.warmth_committed = -80
	bond.recalculate()
	BD_ASSERT_EQUAL(bond.stage_group(), BOND_GROUP_HOSTILE, "deep negative warmth at high weight must resolve to hostile")

/datum/unit_test/bonds/node_cap_evicts_weakest/Run()
	var/datum/mind/owner = bd_make_mind()
	var/datum/bond_node/node = SSbonds.get_or_create_node(owner)
	for(var/i in 1 to BOND_MAX_PER_MIND + 5)
		var/datum/mind/target = bd_make_mind()
		var/datum/social_bond/bond = SSbonds.get_or_create_bond(owner, target)
		bond.weight_committed = i
		bond.recalculate()
	BD_ASSERT(length(node.bonds) <= BOND_MAX_PER_MIND, "the node cap must bound outgoing bonds")

/datum/unit_test/bonds/a_full_node_still_accepts_newcomers/Run()
	var/datum/mind/owner = bd_make_mind()
	for(var/i in 1 to BOND_MAX_PER_MIND + 2)
		var/datum/mind/filler = bd_make_mind()
		var/datum/social_bond/bond = SSbonds.get_or_create_bond(owner, filler)
		BD_ASSERT_NOTNULL(bond, "creating a bond must return it")
		bond.weight_committed = 50
		bond.recalculate()

	var/datum/mind/newcomer = bd_make_mind()
	var/datum/social_bond/fresh = SSbonds.get_or_create_bond(owner, newcomer)
	BD_ASSERT_NOTNULL(SSbonds.get_bond(owner, newcomer), "a full node must still make room for someone new")
	BD_ASSERT_EQUAL(fresh, SSbonds.get_bond(owner, newcomer), "and must not hand back a bond it already dropped")

/datum/unit_test/bonds/tagged_bonds_survive_eviction/Run()
	var/datum/mind/owner = bd_make_mind()
	var/datum/mind/protected = bd_make_mind()
	var/datum/social_bond/tagged = SSbonds.get_or_create_bond(owner, protected)
	tagged.tags |= BOND_TAG_KILLED_ME
	for(var/i in 1 to BOND_MAX_PER_MIND + 5)
		var/datum/mind/target = bd_make_mind()
		var/datum/social_bond/bond = SSbonds.get_or_create_bond(owner, target)
		bond.weight_committed = 50
		bond.recalculate()
	BD_ASSERT_NOTNULL(SSbonds.get_bond(owner, protected), "a tagged bond must never be evicted by the cap")
	var/datum/bond_node/node = SSbonds.get_node(owner)
	BD_ASSERT(length(node.bonds) <= BOND_MAX_PER_MIND, "the cap must still hold while protecting it")

/datum/unit_test/bonds/seed_flavors_are_pickable_only/Run()
	var/list/flavors = SSbonds.valid_seed_flavors()
	BD_ASSERT(length(flavors) > 0, "there must be at least one pickable seed flavor")
	var/datum/bond_event/seed/creditor = SSbonds.get_event_prototype(/datum/bond_event/seed/creditor)
	BD_ASSERT(!creditor.pickable, "the creditor side is applied as an opposite, never picked directly")

/datum/unit_test/bonds/asymmetric_seed_has_opposite/Run()
	var/datum/bond_event/seed/debtor = SSbonds.get_event_prototype(/datum/bond_event/seed/debtor)
	BD_ASSERT_EQUAL(debtor.opposite_type, /datum/bond_event/seed/creditor, "debtor must map to creditor on the other side")
	var/datum/bond_event/seed/served = SSbonds.get_event_prototype(/datum/bond_event/seed/served_together)
	BD_ASSERT_NULL(served.opposite_type, "symmetric seeds must not define an opposite")

/datum/unit_test/bonds/record_requires_visible_identity/Run()
	var/datum/mind/a = bd_make_mind()
	var/datum/mind/b = bd_make_mind()
	BD_ASSERT_NULL(SSbonds.record(a, b, /datum/bond_event/struck_by, null), "a concealed or absent body must not form a bond")
	BD_ASSERT_NOTNULL(SSbonds.record(a, b, /datum/bond_event/struck_by, null, TRUE), "forced records bypass the identity gate for seeding")

/datum/unit_test/bonds/kin_link_is_reciprocal/Run()
	var/datum/mind/child = bd_make_mind()
	var/datum/mind/parent = bd_make_mind()
	SSbonds.add_kin(child, parent, BOND_KIN_PARENT, FALSE, null)
	BD_ASSERT_NOTNULL(SSbonds.find_kin(child, parent, BOND_KIN_PARENT), "forward parent link missing")
	BD_ASSERT_NOTNULL(SSbonds.find_kin(parent, child, BOND_KIN_CHILD), "reciprocal child link must be written automatically")
	BD_ASSERT_EQUAL(bonds_kin_reciprocal(BOND_KIN_SPOUSE), BOND_KIN_SPOUSE, "spouse-like kinds mirror themselves")

/datum/unit_test/bonds/kin_removal_clears_both_sides/Run()
	var/datum/mind/child = bd_make_mind()
	var/datum/mind/parent = bd_make_mind()
	SSbonds.add_kin(child, parent, BOND_KIN_PARENT, FALSE, null)
	SSbonds.remove_kin(child, parent, BOND_KIN_PARENT)
	BD_ASSERT_NULL(SSbonds.find_kin(child, parent, BOND_KIN_PARENT), "forward link must be gone")
	BD_ASSERT_NULL(SSbonds.find_kin(parent, child, BOND_KIN_CHILD), "reciprocal link must be gone")

/datum/unit_test/bonds/kin_is_unscored_and_unevictable/Run()
	var/datum/mind/child = bd_make_mind()
	var/datum/mind/parent = bd_make_mind()
	var/datum/social_bond/kin/link = SSbonds.add_kin(child, parent, BOND_KIN_PARENT, FALSE, null)
	BD_ASSERT(!link.scored, "kinship carries no sentiment")
	BD_ASSERT(!link.evictable, "kinship must never be dropped by the node cap")
	BD_ASSERT_NULL(link.attach_event(/datum/bond_event/struck_by), "an unscored link must refuse sentiment events")
	BD_ASSERT_EQUAL(link.warmth, 0, "kin axes stay untouched")

/datum/unit_test/bonds/kin_and_sentiment_coexist/Run()
	var/datum/mind/a = bd_make_mind()
	var/datum/mind/b = bd_make_mind()
	SSbonds.add_kin(a, b, BOND_KIN_SWORN_SIBLING, FALSE, null)
	var/datum/social_bond/feeling = SSbonds.get_or_create_bond(a, b)
	feeling.attach_event(/datum/bond_event/struck_by)
	BD_ASSERT_NOTNULL(SSbonds.find_kin(a, b, BOND_KIN_SWORN_SIBLING), "kinship survives alongside sentiment")
	BD_ASSERT(feeling.warmth < 0, "you can hate a brother")

/datum/unit_test/bonds/kin_adoption_mirrors/Run()
	var/datum/mind/child = bd_make_mind()
	var/datum/mind/parent = bd_make_mind()
	SSbonds.add_kin(child, parent, BOND_KIN_PARENT, FALSE, null)
	SSbonds.set_kin_adopted(child, parent, BOND_KIN_PARENT, TRUE)
	var/datum/social_bond/kin/forward = SSbonds.find_kin(child, parent, BOND_KIN_PARENT)
	var/datum/social_bond/kin/backward = SSbonds.find_kin(parent, child, BOND_KIN_CHILD)
	BD_ASSERT(forward.adopted, "adoption must be set on the forward link")
	BD_ASSERT(backward.adopted, "adoption must mirror to the reciprocal link")

/datum/unit_test/bonds/kin_cycle_is_detected/Run()
	var/datum/mind/grandparent = bd_make_mind()
	var/datum/mind/parent = bd_make_mind()
	var/datum/mind/child = bd_make_mind()
	SSbonds.add_kin(parent, grandparent, BOND_KIN_PARENT, FALSE, null)
	SSbonds.add_kin(child, parent, BOND_KIN_PARENT, FALSE, null)
	BD_ASSERT(SSbonds.kin_would_cycle(grandparent, child), "making a descendant into an ancestor must be refused")
	BD_ASSERT(!SSbonds.kin_would_cycle(child, grandparent), "an ordinary ancestor link is fine")

/datum/unit_test/bonds/dropping_an_actor_leaves_nothing_behind/Run()
	var/datum/mind/a = bd_make_mind()
	var/datum/mind/b = bd_make_mind()
	SSbonds.add_kin(a, b, BOND_KIN_PARENT, FALSE, null)
	var/datum/social_bond/feeling = SSbonds.get_or_create_bond(b, a)
	feeling.attach_event(/datum/bond_event/struck_by)
	var/datum/bond_actor/actor_a = SSbonds.resolve_actor(a)
	SSbonds.spend_influence(actor_a)
	BD_ASSERT_NOTNULL(SSbonds.influence_pools[actor_a], "the pool entry must exist before the drop")

	SSbonds.drop_actor(actor_a)

	BD_ASSERT_NULL(SSbonds.influence_pools[actor_a], "a dropped actor must not stay a key in the influence pool")
	BD_ASSERT_NULL(SSbonds.find_kin(b, actor_a, BOND_KIN_CHILD), "the reciprocal kin link must go with it")
	BD_ASSERT_NULL(SSbonds.get_bond(b, actor_a), "and so must anyone's sentiment toward it")

/datum/unit_test/bonds/actor_identity_is_stable/Run()
	var/datum/mind/subject = bd_make_mind()
	var/datum/bond_actor/first = SSbonds.resolve_actor(subject)
	BD_ASSERT_NOTNULL(first, "a mind must resolve to an actor")
	BD_ASSERT_EQUAL(SSbonds.resolve_actor(subject), first, "resolving the same mind twice must give the same actor")
	BD_ASSERT_EQUAL(SSbonds.resolve_actor(first), first, "an actor resolves to itself")
	BD_ASSERT_NULL(SSbonds.resolve_actor(null), "nothing resolves to nothing")

/datum/unit_test/bonds/phantom_gets_graph_identity/Run()
	var/datum/family_member/phantom = new /datum/family_member(null, null)
	phantom.phantom = TRUE
	var/datum/bond_actor/actor = SSbonds.resolve_actor(phantom)
	BD_ASSERT_NOTNULL(actor, "a bodiless phantom relative must still get an actor")
	BD_ASSERT(actor.is_phantom(), "phantom actors must be marked as such")
	BD_ASSERT_EQUAL(actor.family_member_of(), phantom, "the actor must resolve back to its member")

	var/datum/mind/child = bd_make_mind()
	SSbonds.add_kin(child, phantom, BOND_KIN_PARENT, FALSE, null)
	BD_ASSERT_NOTNULL(SSbonds.find_kin(child, phantom, BOND_KIN_PARENT), "a phantom must be usable as a parent")
	BD_ASSERT_NOTNULL(SSbonds.find_kin(phantom, child, BOND_KIN_CHILD), "the reciprocal must land on the phantom too")

	SSbonds.remove_kin(child, phantom, BOND_KIN_PARENT)
	SSbonds.drop_actor(actor)
	qdel(phantom)

/datum/unit_test/bonds/clan_index_resolves/Run()
	BD_ASSERT(SSbonds.clan_index.len > 0, "clan index must be built at init")
	var/datum/bond_faction/clan/nosferatu = SSbonds.clan_index[/datum/clan/nosferatu]
	BD_ASSERT_NOTNULL(nosferatu, "nosferatu must map to a clan faction")
	BD_ASSERT_EQUAL(nosferatu.id, BOND_CLAN_NOSFERATU, "clan faction id drifted")
	BD_ASSERT_EQUAL(length(nosferatu.titles()), 0, "clans must contribute no job titles")

/datum/unit_test/bonds/clan_pairs_share_the_stance_matrix/Run()
	var/forward = SSbonds.stance_warmth(BOND_CLAN_ABYSS, BOND_CLAN_CRIMSON)
	var/backward = SSbonds.stance_warmth(BOND_CLAN_CRIMSON, BOND_CLAN_ABYSS)
	BD_ASSERT_EQUAL(forward, backward, "clan stances must be order independent like faction ones")
	BD_ASSERT_NOTNULL(SSbonds.get_stance(BOND_CLAN_ABYSS, BOND_CLAN_CRIMSON), "declared clan baselines must be present")

/datum/unit_test/bonds/arena_is_a_sanctioned_ground/Run()
	BD_ASSERT(SSbonds.zone_lenses.len > 0, "zone lenses must be built")
	var/datum/bond_zone_lens/arena = SSbonds.zone_lenses[1]
	BD_ASSERT_EQUAL(arena.type, /datum/bond_zone_lens/arena, "the arena must sort first by priority")
	BD_ASSERT_EQUAL(arena.weight, 0, "duelling ground must not move faction politics")

/datum/unit_test/bonds/masochist_takes_no_offence/Run()
	BD_ASSERT(SSbonds.dispositions.len > 0, "dispositions must be built")
	var/datum/bond_disposition/masochist = locate(/datum/bond_disposition/masochist) in SSbonds.dispositions
	BD_ASSERT_NOTNULL(masochist, "the masochist disposition must load")
	BD_ASSERT_EQUAL(masochist.category_scales[BOND_CATEGORY_VIOLENCE], 0, "being struck must not build a masochist a grudge")
	BD_ASSERT_NULL(masochist.category_scales[BOND_CATEGORY_KINDNESS], "kindness is untouched by that flaw")

/datum/unit_test/bonds/unscaled_event_never_lands/Run()
	var/datum/mind/a = bd_make_mind()
	var/datum/mind/b = bd_make_mind()
	var/datum/social_bond/bond = SSbonds.get_or_create_bond(a, b)
	BD_ASSERT_NULL(bond.attach_event(/datum/bond_event/struck_by, 0), "a zeroed disposition must drop the event entirely")
	BD_ASSERT_EQUAL(bond.warmth, 0, "and leave the bond untouched")

/datum/unit_test/bonds/ancestry_walk_is_directional/Run()
	var/datum/mind/grandparent = bd_make_mind()
	var/datum/mind/parent = bd_make_mind()
	var/datum/mind/child = bd_make_mind()
	SSbonds.add_kin(parent, grandparent, BOND_KIN_PARENT, FALSE, null)
	SSbonds.add_kin(child, parent, BOND_KIN_PARENT, FALSE, null)

	BD_ASSERT(SSbonds.kin_reaches(child, grandparent, BOND_KIN_PARENT), "walking up must reach a grandparent")
	BD_ASSERT(SSbonds.kin_reaches(grandparent, child, BOND_KIN_CHILD), "walking down must reach a grandchild")
	BD_ASSERT(!SSbonds.kin_reaches(child, grandparent, BOND_KIN_CHILD), "the walk must respect direction")
	BD_ASSERT(!SSbonds.kin_reaches(child, child, BOND_KIN_PARENT), "nobody is their own ancestor")

/datum/unit_test/bonds/influence_pool_depletes_then_mutes/Run()
	var/datum/mind/subject = bd_make_mind()
	var/datum/bond_actor/actor = SSbonds.resolve_actor(subject)
	for(var/i in 1 to BOND_INFLUENCE_POOL)
		BD_ASSERT(SSbonds.spend_influence(actor), "the pool must allow its first [BOND_INFLUENCE_POOL] acts")
	BD_ASSERT(!SSbonds.spend_influence(actor), "an exhausted pool must stop counting")
	BD_ASSERT(SSbonds.influence_muted(actor), "exhausting the pool mutes the actor")
	SSbonds.influence_pools -= actor

/datum/unit_test/bonds/role_weight_scales_by_office/Run()
	BD_ASSERT_EQUAL(SSbonds.role_weights[/datum/job/roguetown/priest], 2.5, "high office weight drifted")
	BD_ASSERT(SSbonds.role_weights[/datum/job/roguetown/hand] > SSbonds.role_weights[/datum/job/roguetown/marshal], "the Hand outranks the Marshal: they command every noble")
	BD_ASSERT(SSbonds.role_weights[/datum/job/roguetown/lord] > SSbonds.role_weights[/datum/job/roguetown/hand], "the ruler still has absolute priority")
	BD_ASSERT_EQUAL(SSbonds.role_weights[/datum/job/roguetown/knight], 1.8, "notable weight drifted")
	BD_ASSERT_NULL(SSbonds.role_weights[/datum/job/roguetown/villager], "ordinary jobs carry no declared weight")

/datum/unit_test/bonds/map_lens_is_inert_at_zero/Run()
	BD_ASSERT(SSbonds.map_lenses.len > 0, "map lenses must be built")
	BD_ASSERT_EQUAL(SSbonds.map_weight(), 1, "a zero-weight lens must fall back to neutral")

/datum/unit_test/bonds/origins_never_enter_the_live_matrix/Run()
	for(var/key in SSbonds.faction_stances)
		var/datum/faction_stance/stance = SSbonds.faction_stances[key]
		BD_ASSERT_NULL(SSbonds.origin_prototypes[stance.faction_a], "country standing is static lore and must never become a live stance")
		BD_ASSERT_NULL(SSbonds.origin_prototypes[stance.faction_b], "country standing is static lore and must never become a live stance")
	BD_ASSERT(SSbonds.origin_lore.len > 0, "origin lore itself must still be loaded as a read-only modifier table")

/datum/unit_test/bonds/origin_lore_is_symmetric/Run()
	BD_ASSERT_EQUAL(bonds_origin_key("zybantu", "grenzelhoft"), bonds_origin_key("grenzelhoft", "zybantu"), "origin keys must not depend on order")
	var/datum/origin_lore/lore = SSbonds.origin_lore[bonds_origin_key("zybantu", "grenzelhoft")]
	BD_ASSERT_NOTNULL(lore, "the declared Zybantu/Grenzelhoft grudge must load")
	BD_ASSERT(lore.bias < 0, "the losers of the Twilight War and its victors start sour")
	BD_ASSERT(lore.weight_scale > 1, "and incidents between them land harder")

	var/datum/origin_lore/friendly = SSbonds.origin_lore[bonds_origin_key("azuria", "grenzelhoft")]
	BD_ASSERT_NOTNULL(friendly, "Azuria and Grenzelhoft have a declared position too")
	BD_ASSERT(friendly.bias > 0, "wartime neutrality and dynastic kinship make them friendly, not hostile")
	BD_ASSERT(friendly.weight_scale < 1, "so their incidents matter less, not more")

/datum/unit_test/bonds/seeding_goes_idle_when_nobody_waits/Run()
	BD_ASSERT(!SSbonds.anyone_still_wants_seeds(), "no synthetic ckey declares seeds, so nothing should be pending")
	SSbonds.stop_seeding("unit test")
	BD_ASSERT(SSbonds.seeding_idle, "with nothing pending the loop must park itself")
	BD_ASSERT(SSbonds.wake_seeding(), "a newcomer must be able to wake it")
	BD_ASSERT(!SSbonds.seeding_idle, "and waking clears the idle flag")
	BD_ASSERT(!SSbonds.wake_seeding(), "waking an already-running loop must be a no-op")
	SSbonds.stop_seeding("unit test cleanup")

/datum/unit_test/bonds/weight_shares_sum_to_one/Run()
	var/total = 0
	for(var/share_id in SSbonds.weight_shares)
		var/datum/bond_weight_share/entry = SSbonds.weight_shares[share_id]
		total += entry.share
	BD_ASSERT(total > 0.999 && total < 1.001, "template shares must sum to exactly 1, got [total]")

/datum/unit_test/bonds/blend_is_neutral_at_rest/Run()
	var/neutral = SSbonds.blend_weights(list(
		BOND_SHARE_ROLE = 1,
		BOND_SHARE_LORE = 1,
		BOND_SHARE_STORYTELLER = 1,
		BOND_SHARE_ZONE = 1,
		BOND_SHARE_MAP = 1,
	))
	BD_ASSERT(neutral > 0.999 && neutral < 1.001, "an all-neutral incident must blend to 1, got [neutral]")
	var/partial = SSbonds.blend_weights(list(BOND_SHARE_ROLE = 1))
	BD_ASSERT(partial > 0.999 && partial < 1.001, "an unmentioned template must default to neutral, got [partial]")

/datum/unit_test/bonds/blend_bounds_a_stacked_incident/Run()
	var/stacked = SSbonds.blend_weights(list(
		BOND_SHARE_ROLE = 4.5,
		BOND_SHARE_LORE = 1.8,
		BOND_SHARE_STORYTELLER = 1.8,
		BOND_SHARE_ZONE = 1,
		BOND_SHARE_MAP = 1,
	))
	BD_ASSERT(stacked < 3, "the blend must bound a stacked incident well below the 14x a raw product would give, got [stacked]")
	BD_ASSERT(stacked > 1, "but it must still amplify it")

/datum/unit_test/bonds/faction_presence_follows_the_map_blacklist/Run()
	var/list/present = SSbonds.present_faction_ids()
	BD_ASSERT(length(present) > 0, "some factions must exist on any map")
	var/list/blacklist = SSbonds.map_blacklist()
	for(var/faction_id in present)
		var/datum/bond_faction/faction = SSbonds.get_faction(faction_id)
		var/any_live = FALSE
		var/any_job = FALSE
		for(var/job_type in SSbonds.faction_index)
			if(SSbonds.faction_index[job_type] != faction)
				continue
			any_job = TRUE
			if(!(job_type in blacklist))
				any_live = TRUE
				break
		BD_ASSERT(any_live || !any_job, "[faction_id] is listed as present but every one of its jobs is blacklisted on this map")

/datum/unit_test/bonds/hierarchy_has_one_leader_per_faction/Run()
	BD_ASSERT(SSbonds.hierarchy_by_faction.len > 0, "hierarchy must be built at init")
	for(var/faction_id in SSbonds.hierarchy_by_faction)
		var/list/ranks = SSbonds.hierarchy_by_faction[faction_id]
		var/datum/bond_rank/first = ranks[1]
		BD_ASSERT_EQUAL(first.level, 1, "[faction_id] must start at level 1 after sorting")
		var/last_level = 0
		for(var/datum/bond_rank/rank as anything in ranks)
			BD_ASSERT(rank.level >= last_level, "[faction_id] ranks must be sorted by level")
			last_level = rank.level

/datum/unit_test/bonds/rank_titles_do_not_collide/Run()
	var/list/seen = list()
	for(var/faction_id in SSbonds.hierarchy_by_faction)
		for(var/datum/bond_rank/rank as anything in SSbonds.hierarchy_by_faction[faction_id])
			for(var/title in rank.titles)
				BD_ASSERT(!seen[title], "title [title] is claimed by two ranks: [seen[title]] and [rank.label]")
				seen[title] = rank.label

/datum/unit_test/bonds/inquisitor_leads_the_mission/Run()
	var/datum/bond_rank/rank = SSbonds.rank_for_title("Inquisitor")
	BD_ASSERT_NOTNULL(rank, "the Inquisitor must have a rank")
	BD_ASSERT_EQUAL(rank.level, 1, "everyone in the Otavan mission answers to the Inquisitor without exception")
	var/datum/bond_rank/deputy = SSbonds.rank_for_title("Absolver")
	BD_ASSERT_EQUAL(deputy.level, 2, "the Absolver stands in when the Inquisitor falls")

/datum/unit_test/bonds/faction_index_has_no_collisions/Run()
	var/list/seen = list()
	for(var/faction_id in SSbonds.faction_prototypes)
		var/datum/bond_faction/faction = SSbonds.faction_prototypes[faction_id]
		for(var/title in faction.titles())
			BD_ASSERT(!seen[title], "title [title] belongs to two factions: [seen[title]] and [faction_id]")
			seen[title] = faction_id

/datum/unit_test/bonds/venue_titles_resolve_to_class_factions/Run()
	BD_ASSERT_EQUAL(SSbonds.faction_for_job(/datum/job/roguetown/bathmaster)?.id, BOND_FACTION_BURGHER, "venue owners belong to the burghers")
	BD_ASSERT_EQUAL(SSbonds.faction_for_job(/datum/job/roguetown/innkeeper)?.id, BOND_FACTION_BURGHER, "venue owners belong to the burghers")
	BD_ASSERT_EQUAL(SSbonds.faction_for_job(/datum/job/roguetown/servant)?.id, BOND_FACTION_PEASANT, "venue staff are commoners")

/datum/unit_test/bonds/stance_key_is_symmetric/Run()
	BD_ASSERT_EQUAL(bonds_stance_key(BOND_FACTION_CHURCH, BOND_FACTION_NOBLE), bonds_stance_key(BOND_FACTION_NOBLE, BOND_FACTION_CHURCH), "stance keys must not depend on argument order")
	BD_ASSERT_NULL(bonds_stance_key(BOND_FACTION_NOBLE, null), "an incomplete pair has no key")

/datum/unit_test/bonds/baselines_loaded_and_symmetric/Run()
	BD_ASSERT(SSbonds.faction_stances.len > 0, "declared baselines must populate the stance matrix")
	var/forward = SSbonds.stance_warmth(BOND_FACTION_CHURCH, BOND_FACTION_INQUISITION)
	var/backward = SSbonds.stance_warmth(BOND_FACTION_INQUISITION, BOND_FACTION_CHURCH)
	BD_ASSERT_EQUAL(forward, backward, "stance lookup must be order independent")
	BD_ASSERT_EQUAL(SSbonds.stance_warmth(BOND_FACTION_NOBLE, BOND_FACTION_NOBLE), BOND_STANCE_SAME_FACTION_WARMTH, "same faction resolves without a stored pair")

	var/list/template = SSbonds.current_realm_template()
	BD_ASSERT_NOTNULL(template, "the running map's realm has no template, so every faction pair sits at flat zero")
	if(!template)
		return
	var/list/overrides = template["overrides"]
	for(var/key in overrides)
		var/list/declared = overrides[key]
		var/list/sides = splittext(key, "|")
		if(length(sides) != 2)
			continue
		BD_ASSERT_EQUAL(SSbonds.stance_warmth(sides[1], sides[2]), declared[1], "[key] is declared as an override but the live matrix disagrees, so the template never reached seeding")

/datum/unit_test/bonds/stance_nudge_clamps/Run()
	BD_ASSERT_NULL(SSbonds.get_stance(BOND_CLAN_CAITIFF, BOND_FACTION_WANDERER), "this pair must start undeclared for the test to mean anything")
	SSbonds.nudge_stance(BOND_CLAN_CAITIFF, BOND_FACTION_WANDERER, 500, 500, "unit test")
	var/datum/faction_stance/stance = SSbonds.get_stance(BOND_CLAN_CAITIFF, BOND_FACTION_WANDERER)
	BD_ASSERT_NOTNULL(stance, "nudging must create the pair on demand")
	BD_ASSERT_EQUAL(stance.warmth, BOND_WARMTH_MAX, "stance warmth must clamp")
	BD_ASSERT_EQUAL(stance.weight, BOND_WEIGHT_MAX, "stance weight must clamp")
	BD_ASSERT_EQUAL(LAZYLEN(stance.history), 1, "a reasoned nudge records history")
	SSbonds.faction_stances -= bonds_stance_key(BOND_CLAN_CAITIFF, BOND_FACTION_WANDERER)
	qdel(stance)

/datum/unit_test/bonds/violence_outlives_its_transient/Run()
	var/datum/mind/victim = bd_make_mind()
	var/datum/mind/aggressor = bd_make_mind()
	var/datum/social_bond/bond = SSbonds.get_or_create_bond(victim, aggressor)
	BD_ASSERT_NOTNULL(bond, "the pair must be able to hold a bond")

	bond.attach_event(/datum/bond_event/struck_by)
	var/hot_warmth = bond.warmth
	BD_ASSERT(hot_warmth < 0, "being struck must read as hostile while it is fresh")

	for(var/category in bond.active_events.Copy())
		var/datum/bond_event/live = bond.active_events[category]
		live.expire()

	BD_ASSERT_EQUAL(length(bond.active_events), 0, "every transient must be gone")
	BD_ASSERT(bond.warmth < 0, "the grudge must survive its transient, not snap back to neutral")
	BD_ASSERT(bond.weight >= BOND_VISIBLE_WEIGHT, "an assault must leave the attacker visible in the panel afterwards, or the bond reads as a reset")

/datum/unit_test/bonds/archetypes_resolve_through_the_type_tree/Run()
	BD_ASSERT(SSbonds.archetypes_for_job(/datum/job/roguetown/knight) & BOND_ARCH_WARRIOR, "a knight must read as a warrior")
	BD_ASSERT(SSbonds.archetypes_for_job(/datum/job/roguetown/priest) & BOND_ARCH_DEVOUT, "a priest must read as devout")
	BD_ASSERT(!(SSbonds.archetypes_for_job(/datum/job/roguetown/priest) & BOND_ARCH_WARRIOR), "a priest is not a man-at-arms")
	BD_ASSERT(SSbonds.archetypes_for_job(/datum/job/roguetown/templar) & BOND_ARCH_WARRIOR, "a templar is both")
	BD_ASSERT(SSbonds.archetypes_for_job(/datum/job/roguetown/templar) & BOND_ARCH_DEVOUT, "a templar is both")
	BD_ASSERT(SSbonds.archetypes_for_job(/datum/job/roguetown/greater_skeleton/lich) & BOND_ARCH_UNDEAD, "an unlisted subtype must inherit its parent's archetypes")
	BD_ASSERT_EQUAL(SSbonds.archetypes_for_job(null), 0, "no job means no archetype")

/datum/unit_test/bonds/dreams_refuse_implausible_pairs/Run()
	var/datum/bond_event/dream/wall = SSbonds.get_event_prototype(/datum/bond_event/dream/shield_wall)
	BD_ASSERT_NOTNULL(wall, "the shield wall dream must exist")
	BD_ASSERT(wall.fits(BOND_ARCH_WARRIOR, BOND_ARCH_WARRIOR, BOND_DREAM_SCOPE_OWN), "two men-at-arms may remember the same line")
	BD_ASSERT(!wall.fits(BOND_ARCH_DEVOUT, BOND_ARCH_WARRIOR, BOND_DREAM_SCOPE_OWN), "a priest must never wake up a brother in arms")
	BD_ASSERT(!wall.fits(BOND_ARCH_WARRIOR, BOND_ARCH_SCHOLAR, BOND_DREAM_SCOPE_OWN), "and never about someone who never stood in one")
	BD_ASSERT(!wall.fits(BOND_ARCH_WARRIOR, BOND_ARCH_WARRIOR, BOND_DREAM_SCOPE_FOREIGN), "a shared line is a thing between your own")

/datum/unit_test/bonds/dreams_are_permanent/Run()
	var/found = 0
	for(var/event_type in SSbonds.event_prototypes)
		var/datum/bond_event/dream/prototype = SSbonds.event_prototypes[event_type]
		if(!istype(prototype))
			continue
		found++
		BD_ASSERT_EQUAL(prototype.timeout, 0, "[event_type] must not expire - a memory is not a mood")
		BD_ASSERT_EQUAL(prototype.warmth_transient, 0, "[event_type] must carry no transient, or it would vanish on its own")
		BD_ASSERT(prototype.warmth_commit != 0, "[event_type] must move warmth permanently")
		BD_ASSERT(prototype.weight_commit > 0, "[event_type] must make the other person matter more")
	BD_ASSERT(found >= 100, "the dream table lost entries: expected the baseline twenty plus the storyteller and map sets")

/datum/unit_test/bonds/every_dream_has_two_sides/Run()
	var/datum/mind/dreamer = bd_make_mind()
	var/datum/mind/other = bd_make_mind()
	var/datum/social_bond/bond = SSbonds.get_or_create_bond(dreamer, other)
	BD_ASSERT_NOTNULL(bond, "need a bond to render stories against")
	for(var/event_type in SSbonds.dream_prototypes)
		var/datum/bond_event/dream/prototype = SSbonds.event_prototypes[event_type]
		var/story = prototype.build_story(bond)
		var/echo = prototype.build_echo(bond)
		BD_ASSERT(length(story) > 0, "[event_type] has no dream text")
		BD_ASSERT(story != echo, "[event_type] never overrode build_echo, so the other side would be told the sleeper's own dream verbatim")

/datum/unit_test/bonds/dream_groups_are_namespaces/Run()
	BD_ASSERT_NULL(SSbonds.event_prototypes[/datum/bond_event/dream], "the dream base must stay abstract")
	BD_ASSERT_NULL(SSbonds.event_prototypes[/datum/bond_event/dream/azuria], "a map group is a namespace, not a memory anyone can dream")
	BD_ASSERT_NULL(SSbonds.event_prototypes[/datum/bond_event/dream/astrata], "a storyteller group is a namespace, not a memory anyone can dream")

	var/datum/bond_event/dream/pass = SSbonds.get_event_prototype(/datum/bond_event/dream/azuria/over_the_pass)
	BD_ASSERT_EQUAL(length(pass.maps), 1, "map gating must come down from the group instead of being repeated on every memory")
	var/datum/bond_event/dream/prayer = SSbonds.get_event_prototype(/datum/bond_event/dream/astrata/shared_prayer)
	BD_ASSERT_EQUAL(prayer.storyteller_type, /datum/storyteller/astrata, "storyteller gating must come down from the group too")

/datum/unit_test/bonds/dream_echo_lands_at_half/Run()
	var/datum/mind/dreamer = bd_make_mind()
	var/datum/mind/other = bd_make_mind()
	var/datum/bond_event/dream/prototype = SSbonds.get_event_prototype(/datum/bond_event/dream/shared_bread)
	BD_ASSERT_NOTNULL(prototype, "the bread memory must exist")

	var/datum/bond_history/entry = SSbonds.apply_echo(other, dreamer, /datum/bond_event/dream/shared_bread)
	BD_ASSERT_NOTNULL(entry, "the other side must receive a history entry of its own")
	var/datum/social_bond/echoed = SSbonds.get_bond(other, dreamer)
	BD_ASSERT_NOTNULL(echoed, "and a bond pointing back at the sleeper")
	BD_ASSERT_EQUAL(echoed.warmth_committed, prototype.warmth_commit * BOND_DREAM_ECHO_SCALE, "the echo must land at exactly the configured share")
	BD_ASSERT(echoed.warmth_committed < prototype.warmth_commit, "and must always be softer than what the sleeper felt")
	BD_ASSERT(echoed.weight >= echoed.weight_committed, "the echo must be reflected in the live axes, not only the committed ones")

/datum/unit_test/bonds/map_memories_stay_on_their_map/Run()
	var/datum/bond_event/dream/pass = SSbonds.get_event_prototype(/datum/bond_event/dream/azuria/over_the_pass)
	var/datum/bond_event/dream/water = SSbonds.get_event_prototype(/datum/bond_event/dream/ranesh/shared_water)
	BD_ASSERT_NOTNULL(pass, "the mountain pass memory must exist")
	BD_ASSERT_NOTNULL(water, "the waterskin memory must exist")
	BD_ASSERT(pass.fits_round(/datum/map_adjustment/template/dunworld, null), "a mountain pass belongs to the Azurian valley")
	BD_ASSERT(!pass.fits_round(/datum/map_adjustment/template/deserttown, null), "and must never be dreamt in the sands")
	BD_ASSERT(water.fits_round(/datum/map_adjustment/template/deserttown, null), "a waterskin between wells belongs to the sands")
	BD_ASSERT(!water.fits_round(/datum/map_adjustment/template/rockhill, null), "and has no business on an island under siege")

/datum/unit_test/bonds/divine_memories_follow_the_ruling_god/Run()
	var/datum/bond_event/dream/prayer = SSbonds.get_event_prototype(/datum/bond_event/dream/astrata/shared_prayer)
	BD_ASSERT_NOTNULL(prayer, "the dawn prayer memory must exist")
	BD_ASSERT_EQUAL(prayer.storyteller_type, /datum/storyteller/astrata, "divine memories key on the round's god")
	BD_ASSERT(prayer.fits_round(null, /datum/storyteller/astrata), "it must be drawable while Astrata reigns")
	BD_ASSERT(!prayer.fits_round(null, /datum/storyteller/graggar), "and never while another god does")
	BD_ASSERT(!prayer.fits_round(null, /datum/storyteller/gamemode/no_antag), "a gamemode preset is not a deity and must never unlock divine memories")

	var/datum/bond_event/dream/wall = SSbonds.get_event_prototype(/datum/bond_event/dream/shield_wall)
	BD_ASSERT(wall.fits_round(null, null), "the baseline memories belong to no god and stay available to everyone")

	var/list/gods = list()
	for(var/event_type in SSbonds.dream_prototypes)
		var/datum/bond_event/dream/prototype = SSbonds.event_prototypes[event_type]
		if(!prototype.storyteller_type)
			continue
		BD_ASSERT(ispath(prototype.storyteller_type, /datum/storyteller), "[event_type] is gated on something that is not a storyteller path")
		BD_ASSERT(!ispath(prototype.storyteller_type, /datum/storyteller/gamemode), "[event_type] is gated on a gamemode preset, which update_ruling_god explicitly never crowns, so it could never fire")
		gods[prototype.storyteller_type] = TRUE
	BD_ASSERT_EQUAL(length(gods), 15, "every god in the pantheon must own a set of memories, or that god's round has none")

/datum/unit_test/bonds/storyteller_reads_the_ruling_god/Run()
	BD_ASSERT_EQUAL(SSbonds.ruling_god_type(), SSgamemode?.ruling_god, "the module must read the crowned deity, not the gamemode preset: current_storyteller holds the antagonist intensity and never matches a god lens")
	var/teller_type = SSbonds.ruling_god_type()
	if(!teller_type)
		return
	BD_ASSERT(!ispath(teller_type, /datum/storyteller/gamemode), "update_ruling_god never crowns a gamemode preset")
	BD_ASSERT_NOTNULL(SSbonds.active_storyteller(), "a crowned deity must resolve to its storyteller datum")

/datum/unit_test/bonds/blood_memory_needs_a_vampire/Run()
	var/datum/bond_event/dream/blood = SSbonds.get_event_prototype(/datum/bond_event/dream/rockhill/shared_blood)
	BD_ASSERT_NOTNULL(blood, "the shared blood memory must exist")
	BD_ASSERT_EQUAL(blood.vampire_rule, BOND_DREAM_VAMPIRE_DREAMER, "only the one who drank may dream it")
	BD_ASSERT(blood.rarity < 10, "it must be rarer than an ordinary memory")
	BD_ASSERT(!blood.fits_blood(null, null), "with nobody to check, it must refuse rather than fire")
	var/list/pool = SSbonds.dream_pool(BOND_DREAM_POSITIVE, BOND_DREAM_SCOPE_OWN, 0, 0)
	BD_ASSERT(!(/datum/bond_event/dream/rockhill/shared_blood in pool), "a pool drawn without both mobs must never offer a blood-gated memory")

/datum/unit_test/bonds/every_dream_bucket_can_fire/Run()
	var/every_archetype = BOND_ARCH_WARRIOR | BOND_ARCH_LAWMAN | BOND_ARCH_DEVOUT | BOND_ARCH_NOBLE | BOND_ARCH_SCHOLAR | BOND_ARCH_HEALER | BOND_ARCH_CRAFTER | BOND_ARCH_MERCHANT | BOND_ARCH_OUTLAW | BOND_ARCH_SERVILE | BOND_ARCH_WANDERER | BOND_ARCH_UNDEAD
	var/list/valences = list(BOND_DREAM_NEGATIVE, BOND_DREAM_NEGATIVE, BOND_DREAM_POSITIVE, BOND_DREAM_POSITIVE)
	var/list/scopes = list(BOND_DREAM_SCOPE_OWN, BOND_DREAM_SCOPE_FOREIGN, BOND_DREAM_SCOPE_OWN, BOND_DREAM_SCOPE_FOREIGN)
	for(var/i in 1 to 4)
		var/list/pool = SSbonds.dream_pool(valences[i], scopes[i], every_archetype, every_archetype)
		BD_ASSERT(length(pool) > 0, "bucket [i] can never draw a dream, so its share of the roll is silently wasted")

/datum/unit_test/bonds/seed_flavor_scan_is_cached/Run()
	var/list/first = SSbonds.valid_seed_flavors()
	var/list/second = SSbonds.valid_seed_flavors()
	BD_ASSERT(length(first) > 0, "there must be flavours to hand out")
	BD_ASSERT_EQUAL(first, second, "the flavour scan walks every event prototype and seeding calls it per pair, so it must be cached rather than rebuilt")

/datum/unit_test/bonds/dream_buckets_partition_the_table/Run()
	var/list/positive = SSbonds.dream_buckets["[BOND_DREAM_POSITIVE]"]
	var/list/negative = SSbonds.dream_buckets["[BOND_DREAM_NEGATIVE]"]
	BD_ASSERT(length(positive) > 0, "the positive bucket must be built at init")
	BD_ASSERT(length(negative) > 0, "the negative bucket must be built at init")
	BD_ASSERT_EQUAL(length(positive) + length(negative), length(SSbonds.dream_prototypes), "every memory must land in exactly one valence bucket, or the per-candidate scan silently skips it")

	var/list/round_pool = SSbonds.round_dream_pool(BOND_DREAM_POSITIVE, BOND_DREAM_SCOPE_OWN)
	BD_ASSERT(length(round_pool) <= length(positive), "round filtering must only ever narrow the bucket")
	for(var/event_type in round_pool)
		BD_ASSERT(event_type in positive, "the round pool must never leak a memory of the wrong valence")

/datum/unit_test/bonds/baseline_table_is_well_formed/Run()
	var/list/seen = list()
	for(var/list/block as anything in SSbonds.stance_blocks())
		var/list/axis = block[1]
		var/list/warmth_rows = block[2]
		var/list/weight_rows = block[3]
		var/count = length(axis)
		BD_ASSERT(count > 0, "a stance block must name its axis, or the whole block silently seeds nothing")
		BD_ASSERT_EQUAL(length(warmth_rows), count, "the warmth matrix must carry one row per faction on the axis")
		BD_ASSERT_EQUAL(length(weight_rows), count, "the weight matrix must carry one row per faction on the axis")
		for(var/i in 1 to count)
			BD_ASSERT(istext(axis[i]), "every axis entry must be a faction id")
			var/list/warmth_row = warmth_rows[i]
			var/list/weight_row = weight_rows[i]
			BD_ASSERT_EQUAL(length(warmth_row), count - i, "warmth row [axis[i]] must hold exactly the columns to its right; a short row shifts every later faction's standing onto the wrong pair")
			BD_ASSERT_EQUAL(length(weight_row), count - i, "weight row [axis[i]] must hold exactly the columns to its right")
			for(var/j in (i + 1) to count)
				var/warmth = warmth_row[j - i]
				var/weight = weight_row[j - i]
				var/key = bonds_stance_key(axis[i], axis[j])
				BD_ASSERT_NULL(seen[key], "[key] is reachable from two cells: one of them is a lie")
				seen[key] = TRUE
				BD_ASSERT_EQUAL(isnull(warmth), isnull(weight), "[axis[i]]|[axis[j]] carries one axis and not the other, so the cell was half-parsed")
				if(isnull(warmth))
					continue
				BD_ASSERT(isnum(warmth) && isnum(weight), "[axis[i]]|[axis[j]] must declare numbers on both axes")
				BD_ASSERT(warmth >= BOND_WARMTH_MIN && warmth <= BOND_WARMTH_MAX, "[axis[i]]|[axis[j]] declares warmth outside the axis")
				BD_ASSERT(weight >= BOND_WEIGHT_MIN && weight <= BOND_WEIGHT_MAX, "[axis[i]]|[axis[j]] declares weight outside the axis")

/datum/unit_test/bonds/realm_templates_are_well_formed/Run()
	var/list/templates = SSbonds.realm_templates()
	BD_ASSERT(length(templates) > 0, "no realm template parsed at all, so every map would run on flat zero")

	for(var/realm in templates)
		var/list/template = templates[realm]
		var/list/blocs = template["blocs"]
		var/list/inner = template["inner"]
		var/list/bloc_axis = template["bloc_axis"]
		var/list/between = template["between"]

		BD_ASSERT(length(blocs) > 0, "[realm] declares no bloc")
		BD_ASSERT_NOTNULL(template["default"], "[realm] declares no default, so any pair its blocs miss falls to flat zero")

		var/list/claimed = list()
		for(var/bloc_id in blocs)
			for(var/faction_id in blocs[bloc_id])
				BD_ASSERT_NULL(claimed[faction_id], "[realm] puts [faction_id] in both [claimed[faction_id]] and [bloc_id]; one of the two matrices would silently lose")
				claimed[faction_id] = bloc_id
				BD_ASSERT_NOTNULL(SSbonds.faction_prototypes[faction_id], "[realm] bloc [bloc_id] names [faction_id], which is not a faction")

		for(var/bloc_id in blocs)
			var/list/members = blocs[bloc_id]
			if(length(members) < 2)
				continue
			var/list/triangle = inner[bloc_id]
			BD_ASSERT_NOTNULL(triangle, "[realm] bloc [bloc_id] holds [length(members)] factions but declares no matrix")
			if(!triangle)
				continue
			for(var/i in 1 to length(members))
				var/list/row = triangle[1][i]
				BD_ASSERT_EQUAL(length(row), length(members) - i, "[realm] matrix [bloc_id] row [members[i]] is the wrong width, so every later pair reads a neighbour's number")

		if(length(bloc_axis) > 1)
			BD_ASSERT_NOTNULL(between, "[realm] has [length(bloc_axis)] blocs but no 'matrix blocs', so nothing crosses a border")
			if(between)
				for(var/i in 1 to length(bloc_axis))
					var/list/row = between[1][i]
					BD_ASSERT_EQUAL(length(row), length(bloc_axis) - i, "[realm] matrix blocs row [bloc_axis[i]] is the wrong width")
					for(var/j in (i + 1) to length(bloc_axis))
						BD_ASSERT_NOTNULL(row[j - i], "[realm] never says how [bloc_axis[i]] stands to [bloc_axis[j]]")

/datum/unit_test/bonds/every_map_realm_has_a_template/Run()
	var/list/templates = SSbonds.realm_templates()
	var/list/missing = list()
	for(var/datum/map_adjustment/adjustment_type as anything in subtypesof(/datum/map_adjustment))
		var/datum/map_adjustment/adjustment = new adjustment_type()
		var/realm = adjustment.realm_name
		var/map_file = adjustment.map_file_name
		qdel(adjustment)
		if(!realm || !map_file)
			continue
		if(!templates[realm])
			missing += "[map_file] wants [realm]"
	BD_ASSERT_EQUAL(length(missing), 0, "a map whose realm has no template runs its whole faction layer on the default: [missing.Join(", ")]")

/datum/unit_test/bonds/every_faction_pair_is_declared/Run()
	var/list/mortal = list()
	for(var/faction_id in SSbonds.faction_prototypes)
		var/datum/bond_faction/faction = SSbonds.faction_prototypes[faction_id]
		if(istype(faction, /datum/bond_faction/clan))
			continue
		mortal += faction_id
	BD_ASSERT(length(mortal) >= 14, "the mortal faction roster shrank below the fourteen the matrices were written for")

	var/list/templates = SSbonds.realm_templates()
	for(var/realm in templates)
		var/list/template = templates[realm]
		var/list/blocs = template["blocs"]
		var/list/bloc_of = list()
		for(var/bloc_id in blocs)
			for(var/faction_id in blocs[bloc_id])
				bloc_of[faction_id] = bloc_id
		var/list/unplaced = list()
		for(var/faction_id in mortal)
			if(!bloc_of[faction_id])
				unplaced += faction_id
		BD_ASSERT(length(unplaced) <= 3, "[realm] leaves [length(unplaced)] factions outside every bloc ([unplaced.Join(", ")]); each of them meets the whole map on the bare default")

/datum/unit_test/bonds/faction_map_is_cached_until_a_stance_moves/Run()
	var/list/first = SSbonds.faction_map_shape()
	var/list/second = SSbonds.faction_map_shape()
	BD_ASSERT_NOTNULL(first, "the map shape must build")
	BD_ASSERT_EQUAL(first, second, "the faction map does not depend on the viewer and must be reused: rebuilding it walks every job type once per faction and allocates a stance key per pair")

	var/list/present_first = SSbonds.present_faction_ids()
	BD_ASSERT_EQUAL(present_first, SSbonds.present_faction_ids(), "faction presence is fixed for the round and must not be rescanned")

	SSbonds.nudge_stance(BOND_FACTION_BURGHER, BOND_FACTION_ATC, 1, 0, "")
	var/moved = SSbonds.faction_map_shape()
	SSbonds.nudge_stance(BOND_FACTION_BURGHER, BOND_FACTION_ATC, -1, 0, "")
	BD_ASSERT(moved != first, "moving a stance must invalidate the cached map, or the panel would show stale standings")

/datum/unit_test/bonds/fast_blend_matches_the_general_one/Run()
	BD_ASSERT_EQUAL(SSbonds.blend_impact(1, 1, 1, 1, 1), 1, "with every lens neutral the blend must be exactly 1")
	var/list/cases = list(
		list(2, 1, 1, 1, 1),
		list(1, 0.5, 1.4, 1, 1),
		list(0.25, 2, 0.6, 0, 1.2),
		list(3, 3, 3, 3, 3),
	)
	for(var/list/one as anything in cases)
		var/fast = SSbonds.blend_impact(one[1], one[2], one[3], one[4], one[5])
		var/slow = SSbonds.blend_weights(list(
			BOND_SHARE_ROLE = one[1],
			BOND_SHARE_LORE = one[2],
			BOND_SHARE_STORYTELLER = one[3],
			BOND_SHARE_ZONE = one[4],
			BOND_SHARE_MAP = one[5],
		))
		BD_ASSERT(abs(fast - slow) < 0.0001, "the hot path skips the assoc list and must stay numerically identical to blend_weights: got [fast] vs [slow]")

/datum/unit_test/bonds/stance_history_is_bounded/Run()
	var/datum/faction_stance/stance = SSbonds.get_or_create_stance(BOND_FACTION_PEASANT, BOND_FACTION_WANDERER)
	BD_ASSERT_NOTNULL(stance, "the pair must resolve to a stance")
	var/started_with = LAZYLEN(stance.history)
	for(var/i in 1 to BOND_MAX_HISTORY * 3)
		SSbonds.nudge_stance(BOND_FACTION_PEASANT, BOND_FACTION_WANDERER, 0, 0, "bench entry [i]")
	BD_ASSERT(LAZYLEN(stance.history) <= BOND_MAX_HISTORY, "faction stance history must be trimmed like every other history: it is appended on every propagated combat event and would otherwise grow all round")
	BD_ASSERT(LAZYLEN(stance.history) >= min(started_with, BOND_MAX_HISTORY), "trimming must drop the oldest, not everything")

/datum/unit_test/bonds/cap_holds_when_every_bond_is_tagged/Run()
	var/datum/mind/owner = bd_make_mind()
	var/datum/bond_node/node = SSbonds.get_or_create_node(owner)
	for(var/i in 1 to BOND_MAX_PER_MIND * 2)
		var/datum/mind/target = bd_make_mind()
		var/datum/social_bond/bond = SSbonds.get_or_create_bond(owner, target)
		bond.tags |= BOND_TAG_SHED_BLOOD
		bond.weight_committed = i
		bond.recalculate()
	BD_ASSERT(length(node.bonds) <= BOND_MAX_PER_MIND, "the blood tag must not switch the cap off: got [length(node.bonds)] against a cap of [BOND_MAX_PER_MIND]")

/datum/unit_test/bonds/a_death_outlives_cap_pressure/Run()
	var/datum/mind/owner = bd_make_mind()
	var/datum/mind/killer = bd_make_mind()
	var/datum/social_bond/murder = SSbonds.get_or_create_bond(owner, killer)
	murder.tags |= BOND_TAG_KILLED_ME
	murder.weight_committed = 1
	murder.recalculate()
	for(var/i in 1 to BOND_MAX_PER_MIND * 2)
		var/datum/mind/target = bd_make_mind()
		var/datum/social_bond/bond = SSbonds.get_or_create_bond(owner, target)
		bond.tags |= BOND_TAG_SHED_BLOOD
		bond.weight_committed = 50
		bond.recalculate()
	BD_ASSERT_NOTNULL(SSbonds.get_bond(owner, killer), "being killed by someone is the one memory the cap may never take, even as the lightest bond on the node")
	var/datum/bond_node/node = SSbonds.get_node(owner)
	BD_ASSERT(length(node.bonds) <= BOND_MAX_PER_MIND, "and the cap must still hold around it")

/datum/unit_test/bonds/every_point_of_the_axes_has_a_stage/Run()
	var/list/holes = list()
	var/datum/mind/owner = bd_make_mind()
	var/datum/mind/target = bd_make_mind()
	var/datum/social_bond/probe = SSbonds.get_or_create_bond(owner, target)
	for(var/step in (BOND_WARMTH_MIN * 2) to (BOND_WARMTH_MAX * 2))
		if(length(holes) >= 8)
			break
		var/warmth = step / 2
		for(var/weight_step in (BOND_WEIGHT_MIN * 2) to (BOND_WEIGHT_MAX * 2))
			var/weight = weight_step / 2
			probe.warmth = warmth
			probe.weight = weight
			if(SSbonds.resolve_stage(probe))
				continue
			holes += "([warmth],[weight])"
			if(length(holes) >= 8)
				break
	BD_ASSERT_EQUAL(length(holes), 0, "every warmth/weight coordinate must land on a stage: [holes.Join(" ")]")

/datum/unit_test/bonds/ecosystem_every_event_survives_a_bond/Run()
	var/datum/bond_probe/probe = new()
	probe.run_event_sweep(BD_DEEP_EVENT_REPEATS)
	var/list/faults = probe.violations.Copy()
	var/applied = probe.events_applied
	SSbonds.bondlog("PROBE sweep: [probe.summary()]", BONDLOG_INFO)
	qdel(probe)
	BD_ASSERT_EQUAL(length(faults), 0, "the event sweep found faults: [faults.Join(" | ")]")
	BD_ASSERT(applied > 0, "the sweep applied no events at all, so it proved nothing")

/datum/unit_test/bonds/ecosystem_every_dream_renders/Run()
	var/datum/bond_probe/probe = new()
	probe.run_dream_sweep()
	var/list/faults = probe.violations.Copy()
	var/rendered = probe.dreams_rendered
	qdel(probe)
	BD_ASSERT_EQUAL(length(faults), 0, "the dream sweep found faults: [faults.Join(" | ")]")
	BD_ASSERT_EQUAL(rendered, length(SSbonds.dream_prototypes), "every indexed dream must render both of its sides")

/datum/unit_test/bonds/ecosystem_every_realm_is_coherent/Run()
	var/datum/bond_probe/probe = new()
	probe.run_stance_sweep()
	var/list/faults = probe.violations.Copy()
	qdel(probe)
	BD_ASSERT_EQUAL(length(faults), 0, "the stance sweep found faults: [faults.Join(" | ")]")

/datum/unit_test/bonds/ecosystem_roster_is_coherent/Run()
	var/datum/bond_probe/probe = new()
	probe.run_roster_sweep()
	var/list/faults = probe.violations.Copy()
	qdel(probe)
	BD_ASSERT_EQUAL(length(faults), 0, "the roster sweep found faults: [faults.Join(" | ")]")

/datum/unit_test/bonds/deep_graph_survives_random_event_sequences/Run()
	var/datum/bond_probe/probe = new()
	probe.run_event_fuzz(BD_DEEP_FUZZ_SEQUENCES, BD_DEEP_FUZZ_STEPS)
	probe.run_direction_probe()
	probe.run_cap_probe()
	probe.run_kin_probe()
	var/list/faults = probe.violations.Copy()
	var/steps = probe.fuzz_steps
	SSbonds.bondlog("PROBE fuzz: [probe.summary()]", BONDLOG_INFO)
	qdel(probe)
	BD_ASSERT_EQUAL(length(faults), 0, "the graph fuzz found faults: [faults.Join(" | ")]")
	BD_ASSERT(steps > 0, "the fuzz applied no events at all")

/datum/unit_test/bonds/deep_every_dream_gate_can_be_satisfied/Run()
	var/datum/bond_probe/probe = new()
	probe.run_dream_gate_probe()
	var/list/faults = probe.violations.Copy()
	var/checked = probe.gates_checked
	qdel(probe)
	BD_ASSERT_EQUAL(length(faults), 0, "a memory is gated on something nobody can ever be: [faults.Join(" | ")]")
	BD_ASSERT(checked > 0, "no dream gates were checked")

/datum/unit_test/bonds/deep_stance_layers_apply_in_order/Run()
	var/datum/bond_probe/probe = new()
	probe.run_stance_layering_probe()
	var/list/faults = probe.violations.Copy()
	qdel(probe)
	BD_ASSERT_EQUAL(length(faults), 0, "the stance layers do not resolve in declared order: [faults.Join(" | ")]")

/datum/unit_test/bonds/deep_seeding_is_idempotent/Run()
	var/datum/bond_probe/probe = new()
	probe.run_seeding_idempotence_probe()
	var/list/faults = probe.violations.Copy()
	qdel(probe)
	BD_ASSERT_EQUAL(length(faults), 0, "seeding the faction matrix twice does not land in the same place: [faults.Join(" | ")]")

/datum/unit_test/bonds/deep_attitude_is_the_sum_memory_is_only_part/Run()
	var/datum/bond_probe/probe = new()
	probe.run_memory_probe(40)
	var/list/faults = probe.violations.Copy()
	var/peak = probe.memory_peak
	qdel(probe)
	BD_ASSERT_EQUAL(length(faults), 0, "attitude must be the sum of what happened while memory keeps only part: [faults.Join(" | ")]")
	BD_ASSERT(peak > 0 && peak <= BOND_MAX_HISTORY, "forty events must leave between one and [BOND_MAX_HISTORY] remembered entries, not [peak]")

#undef BD_DEEP_EVENT_REPEATS
#undef BD_DEEP_FUZZ_SEQUENCES
#undef BD_DEEP_FUZZ_STEPS
#undef BD_SOURCE
#undef BD_ASSERT
#undef BD_ASSERT_EQUAL
#undef BD_ASSERT_NOTNULL
#undef BD_ASSERT_NULL

#endif
