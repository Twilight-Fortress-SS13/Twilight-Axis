import { useMemo, useState } from 'react';
import { useBackend } from 'tgui/backend';
import { Window } from 'tgui/layouts';
import {
  Box,
  Button,
  Input,
  NoticeBox,
  Section,
  Stack,
  Tabs,
} from 'tgui-core/components';

type StatEntry = {
  name: string;
  cost: number;
  base: number;
  min: number;
  max: number;
};

type SkillEntry = {
  name: string;
  desc?: string;
  is_combat: boolean;
  category?: string;
};

type SkillState = {
  level: number;
  cap: number;
  next_cost: number;
};

type TraitEntry = {
  name: string;
  cost: number;
  category: string;
  category_name: string;
  desc?: string;
};

type ItemEntry = {
  name: string;
  cost: number;
  category?: string;
  unlock_type?: string;
  unlock_key?: string;
  slot_group?: string | null;
  icon?: string | null;
  icon_state?: string | null;
};

type ItemState = {
  amount: number;
  unlocked: boolean;
};

type LoadoutState = {
  amount: number;
  equip: number;
  bag: number;
};

type Data = {
  stats: Record<string, number>;
  skills: Record<string, SkillState>;
  traits: string[];
  items: Record<string, ItemState>;
  loadout: Record<string, LoadoutState>;

  available_stats: Record<string, StatEntry>;
  available_skills: Record<string, SkillEntry>;
  available_traits: Record<string, TraitEntry>;
  available_items: Record<string, ItemEntry>;

  points_stats: number;
  points_stats_remaining: number;
  points_skills: number;
  points_skills_remaining: number;
  points_traits: number;
  points_traits_remaining: number;
  points_items: number;
  points_items_remaining: number;

  can_save: boolean;
  dirty: boolean;
};

type TabKey = 'stats' | 'skills' | 'traits' | 'items' | 'loadout';

type NumericRowProps = {
  title: string;
  value: number;
  onAdd: () => void;
  onRemove: () => void;
  disabledAdd?: boolean;
  disabledRemove?: boolean;
  extra?: React.ReactNode;
};

type HoverCardData = {
  name: string;
  slot?: string | null;
  category?: string | null;
  costText?: string;
  total?: number;
  bag?: number;
  equip?: number;
  leftHelp: string;
  rightHelp: string;
};

type ItemViewEntry = ItemEntry & ItemState;
type LoadoutViewEntry = ItemEntry & LoadoutState;

const normalizeSearch = (value: unknown): string =>
  String(value ?? '')
    .toLowerCase()
    .trim();

const matchesSearch = (search: string, ...parts: Array<unknown>): boolean => {
  if (!search) {
    return true;
  }

  const normalized = normalizeSearch(search);
  return parts.some((part) => normalizeSearch(part).includes(normalized));
};

const SLOT_LABELS: Record<string, string> = {
  head: 'Head',
  mask: 'Mask',
  neck: 'Neck',
  cloak: 'Cloak',
  armor: 'Armor',
  suit: 'Suit',
  shirt: 'Shirt',
  pants: 'Pants',
  under: 'Under',
  gloves: 'Gloves',
  shoes: 'Shoes',
  wrists: 'Wrists',
  ring: 'Ring',
  belt: 'Belt',
  belt_l: 'Belt Left',
  belt_r: 'Belt Right',
  back: 'Back',
  back_l: 'Back Left',
  back_r: 'Back Right',
  mouth: 'Mouth',
  blackpowder: 'Blackpowder',
  ranged: 'Ranged',
  munition: 'Munition',
  knife: 'Knives',
  sword: 'Swords',
  greatsword: 'Greatswords',
  axe: 'Axes',
  blunt: 'Blunt',
  polearm: 'Polearms',
  whip: 'Whips',
  misc: 'Misc',
  other: 'Other',
};

const CATEGORY_LABELS: Record<string, string> = {
  clothing: 'Clothing',
  weapon: 'Weapons',
  other: 'Other',
};

const CATEGORY_ORDER: Record<string, number> = {
  clothing: 0,
  weapon: 1,
  other: 2,
};

const SLOT_ORDER: Record<string, number> = {
  head: 0,
  mask: 1,
  neck: 2,
  cloak: 3,
  armor: 4,
  suit: 5,
  shirt: 6,
  under: 7,
  gloves: 8,
  wrists: 9,
  belt: 10,
  shoes: 11,
  back: 12,
  blackpowder: 20,
  ranged: 21,
  munition: 22,
  knife: 23,
  sword: 24,
  greatsword: 25,
  axe: 26,
  blunt: 27,
  polearm: 28,
  whip: 29,
  misc: 30,
  other: 999,
};

const getSlotLabel = (slot?: string | null) => {
  if (!slot) {
    return 'Other';
  }
  return SLOT_LABELS[slot.toLowerCase()] || slot;
};

const getCategoryLabel = (category?: string | null) => {
  if (!category) {
    return 'Other';
  }
  return CATEGORY_LABELS[category.toLowerCase()] || category;
};

const groupEntriesByCategoryAndSlot = <
  T extends { slot_group?: string | null; category?: string | null; name?: string }
>(
  entries: Record<string, T>,
  matcher: (path: string, entry: T) => boolean
) => {
  const grouped: Record<string, Record<string, Array<[string, T]>>> = {};

  Object.entries(entries || {})
    .filter(([path, entry]) => matcher(path, entry))
    .forEach(([path, entry]) => {
      const categoryKey = (entry.category || 'other').toLowerCase();
      const slotKey = (entry.slot_group || 'other').toLowerCase();

      if (!grouped[categoryKey]) {
        grouped[categoryKey] = {};
      }
      if (!grouped[categoryKey][slotKey]) {
        grouped[categoryKey][slotKey] = [];
      }

      grouped[categoryKey][slotKey].push([path, entry]);
    });

  Object.values(grouped).forEach((slotGroups) => {
    Object.values(slotGroups).forEach((items) => {
      items.sort((a, b) => (a[1].name || a[0]).localeCompare(b[1].name || b[0]));
    });
  });

  return Object.entries(grouped)
    .sort(([catA], [catB]) => {
      const aOrder = CATEGORY_ORDER[catA] ?? CATEGORY_ORDER.other;
      const bOrder = CATEGORY_ORDER[catB] ?? CATEGORY_ORDER.other;
      if (aOrder !== bOrder) {
        return aOrder - bOrder;
      }
      return getCategoryLabel(catA).localeCompare(getCategoryLabel(catB));
    })
    .map(([categoryKey, slotGroups]) => {
      const sortedSlots = Object.entries(slotGroups).sort(([slotA], [slotB]) => {
        const aOrder = SLOT_ORDER[slotA] ?? SLOT_ORDER.other;
        const bOrder = SLOT_ORDER[slotB] ?? SLOT_ORDER.other;
        if (aOrder !== bOrder) {
          return aOrder - bOrder;
        }
        return getSlotLabel(slotA).localeCompare(getSlotLabel(slotB));
      });

      return [categoryKey, sortedSlots] as const;
    });
};

const NumericRow = ({
  title,
  value,
  onAdd,
  onRemove,
  disabledAdd,
  disabledRemove,
  extra,
}: NumericRowProps) => {
  return (
    <Stack
      align="center"
      justify="space-between"
      style={{
        padding: '6px 0',
        borderBottom: '1px solid rgba(255,255,255,0.06)',
      }}>
      <Stack.Item grow>
        <Box bold>{title}</Box>
        {!!extra && (
          <Box mt={0.5} style={{ opacity: 0.85 }}>
            {extra}
          </Box>
        )}
      </Stack.Item>

      <Stack.Item>
        <Stack align="center">
          <Stack.Item>
            <Button compact onClick={onAdd} disabled={disabledAdd}>
              +
            </Button>
          </Stack.Item>

          <Stack.Item>
            <Box width="34px" textAlign="center" bold>
              {value}
            </Box>
          </Stack.Item>

          <Stack.Item>
            <Button compact onClick={onRemove} disabled={disabledRemove}>
              -
            </Button>
          </Stack.Item>
        </Stack>
      </Stack.Item>
    </Stack>
  );
};

const TileIcon = ({ icon, name }: { icon?: string | null; name: string }) => {
  return (
    <div
      style={{
        width: '64px',
        height: '64px',
        display: 'flex',
        alignItems: 'center',
        justifyContent: 'center',
        overflow: 'hidden',
      }}>
      {icon ? (
        <img
          src={`data:image/png;base64,${icon}`}
          alt={name}
          style={{
            width: '100%',
            height: '100%',
            objectFit: 'contain',
            imageRendering: 'pixelated',
            pointerEvents: 'none',
          }}
        />
      ) : (
        <div style={{ opacity: 0.45, fontSize: '10px' }}>No icon</div>
      )}
    </div>
  );
};

const HoverCard = ({ data }: { data: HoverCardData | null }) => {
  if (!data) {
    return null;
  }

  return (
    <Box
      style={{
        position: 'fixed',
        right: '24px',
        top: '120px',
        width: '250px',
        padding: '10px 12px',
        borderRadius: '8px',
        background: 'rgba(10, 12, 22, 0.96)',
        border: '1px solid rgba(255,255,255,0.08)',
        boxShadow: '0 8px 20px rgba(0,0,0,0.45)',
        zIndex: 1000,
        pointerEvents: 'none',
      }}>
      <Box bold style={{ fontSize: '15px', marginBottom: '6px' }}>
        {data.name}
      </Box>

      <Box style={{ opacity: 0.9 }}>
        <b>Slot:</b> {data.slot || 'None'}
      </Box>

      <Box style={{ opacity: 0.9 }}>
        <b>Type:</b> {data.category || 'Unknown'}
      </Box>

      {!!data.costText && (
        <Box style={{ opacity: 0.9 }}>
          <b>Cost:</b> {data.costText}
        </Box>
      )}

      {typeof data.total === 'number' && (
        <Box style={{ opacity: 0.9 }}>
          <b>Total:</b> {data.total}
        </Box>
      )}

      {typeof data.bag === 'number' && typeof data.equip === 'number' && (
        <Box style={{ opacity: 0.9 }}>
          <b>Bag:</b> {data.bag} | <b>Equip:</b> {data.equip}
        </Box>
      )}

      <Box mt={1} style={{ color: '#f0c35a' }}>
        LMB: {data.leftHelp}
      </Box>
      <Box style={{ color: '#d7d7d7' }}>
        RMB: {data.rightHelp}
      </Box>
    </Box>
  );
};

const ItemTile = ({
  name,
  topRightText,
  bottomLeftText,
  bottomRightText,
  icon,
  onLeftClick,
  onRightClick,
  onHoverStart,
  onHoverEnd,
  glow,
}: {
  name: string;
  topRightText?: string | number;
  bottomLeftText?: string | number;
  bottomRightText?: string | number;
  icon?: string | null;
  onLeftClick: () => void;
  onRightClick?: () => void;
  onHoverStart?: () => void;
  onHoverEnd?: () => void;
  glow?: string;
}) => {
  return (
    <Box style={{ margin: '2px' }}>
      <div
        onClick={onLeftClick}
        onContextMenu={(event) => {
          event.preventDefault();
          event.stopPropagation();
          onRightClick?.();
        }}
        onMouseEnter={onHoverStart}
        onMouseLeave={onHoverEnd}
        style={{
          position: 'relative',
          width: '88px',
          height: '88px',
          borderRadius: '6px',
          background: 'rgba(255,255,255,0.03)',
          border: '1px solid rgba(255,255,255,0.08)',
          boxShadow: glow ? `inset 0 0 0 1px ${glow}` : 'none',
          cursor: 'pointer',
          userSelect: 'none',
          overflow: 'hidden',
        }}>
        <div
          style={{
            position: 'absolute',
            inset: '0',
            display: 'flex',
            alignItems: 'center',
            justifyContent: 'center',
            pointerEvents: 'none',
          }}>
          <TileIcon icon={icon} name={name} />
        </div>

        {topRightText !== undefined && topRightText !== null && topRightText !== '' && (
          <div
            style={{
              position: 'absolute',
              top: '4px',
              right: '6px',
              fontWeight: 700,
              fontSize: '11px',
              color: '#f0c35a',
              textShadow: '0 1px 2px rgba(0,0,0,0.95)',
              pointerEvents: 'none',
            }}>
            {topRightText}
          </div>
        )}

        {bottomLeftText !== undefined && bottomLeftText !== null && bottomLeftText !== '' && (
          <div
            style={{
              position: 'absolute',
              left: '6px',
              bottom: '4px',
              fontWeight: 700,
              fontSize: '11px',
              color: '#d9d9d9',
              textShadow: '0 1px 2px rgba(0,0,0,0.95)',
              pointerEvents: 'none',
            }}>
            {bottomLeftText}
          </div>
        )}

        {bottomRightText !== undefined && bottomRightText !== null && bottomRightText !== '' && (
          <div
            style={{
              position: 'absolute',
              right: '6px',
              bottom: '4px',
              fontWeight: 700,
              fontSize: '11px',
              color: '#9fd6a8',
              textShadow: '0 1px 2px rgba(0,0,0,0.95)',
              pointerEvents: 'none',
            }}>
            {bottomRightText}
          </div>
        )}
      </div>
    </Box>
  );
};

const PointsPanel = ({ data }: { data: Data }) => {
  return (
    <Section title="Points">
      <Stack>
        <Stack.Item grow>
          <Box>Stats: {data.points_stats_remaining} / {data.points_stats}</Box>
        </Stack.Item>
        <Stack.Item grow>
          <Box>Skills: {data.points_skills_remaining} / {data.points_skills}</Box>
        </Stack.Item>
      </Stack>
      <Stack mt={1}>
        <Stack.Item grow>
          <Box>Traits: {data.points_traits_remaining} / {data.points_traits}</Box>
        </Stack.Item>
        <Stack.Item grow>
          <Box>Items: {data.points_items_remaining} / {data.points_items}</Box>
        </Stack.Item>
      </Stack>
    </Section>
  );
};

const StatsTab = ({
  data,
  act,
  search,
}: {
  data: Data;
  act: (action: string, payload?: object) => void;
  search: string;
}) => {
  const rows = useMemo(() => {
    return Object.entries(data.available_stats || {}).filter(([statId, entry]) =>
      matchesSearch(search, entry.name, statId)
    );
  }, [data.available_stats, search]);

  return (
    <Section title="Stats">
      {!rows.length ? (
        <NoticeBox>No matches found.</NoticeBox>
      ) : (
        <Stack vertical>
          {rows.map(([statId, entry]) => {
            const value = data.stats?.[statId] ?? entry.base;
            return (
              <NumericRow
                key={statId}
                title={entry.name || statId}
                value={value}
                onAdd={() => act('add_stat', { id: statId, amount: 1 })}
                onRemove={() => act('remove_stat', { id: statId, amount: 1 })}
                disabledAdd={value >= entry.max}
                disabledRemove={value <= entry.min}
                extra={
                  <Box>
                    Base: {entry.base} | Min: {entry.min} | Max: {entry.max} | Cost per step: {entry.cost}
                  </Box>
                }
              />
            );
          })}
        </Stack>
      )}
    </Section>
  );
};

const SkillsTab = ({
  data,
  act,
  search,
}: {
  data: Data;
  act: Function;
  search: string;
}) => {
  const rows = useMemo(() => {
    return Object.entries(data.available_skills || {})
      .filter(([skillPath, entry]) =>
        matchesSearch(
          search,
          skillPath,
          entry.name,
          entry.desc,
          entry.is_combat ? 'combat' : 'non-combat',
          entry.category
        )
      )
      .sort((a, b) => {
        const aCombat = a[1].is_combat ? 0 : 1;
        const bCombat = b[1].is_combat ? 0 : 1;
        if (aCombat !== bCombat) return aCombat - bCombat;
        return (a[1].name || a[0]).localeCompare(b[1].name || b[0]);
      });
  }, [data.available_skills, search]);

  return (
    <Section title="Skills">
      {!rows.length ? (
        <NoticeBox>No matches found.</NoticeBox>
      ) : (
        <Stack vertical>
          {rows.map(([skillPath, entry]) => {
            const state = data.skills?.[skillPath];
            const level = state?.level || 0;
            const cap = state?.cap || 0;
            const nextCost = state?.next_cost || 1;

            return (
              <NumericRow
                key={skillPath}
                title={entry.name || skillPath}
                value={level}
                onAdd={() => act('add_skill', { path: skillPath, amount: 1 })}
                onRemove={() => act('remove_skill', { path: skillPath, amount: 1 })}
                disabledAdd={level >= cap}
                disabledRemove={level <= 0}
                extra={
                  <>
                    <Box>
                      {entry.is_combat ? 'Combat' : 'Non-combat'} | Cap: {cap} | Next cost: {nextCost}
                    </Box>
                    {!!entry.desc && <Box mt={0.5}>{entry.desc}</Box>}
                  </>
                }
              />
            );
          })}
        </Stack>
      )}
    </Section>
  );
};

const TraitPill = ({
  title,
  cost,
  desc,
  selected,
  onClick,
}: {
  title: string;
  cost: number;
  desc?: string;
  selected?: boolean;
  onClick: () => void;
}) => (
  <Box>
    <Button selected={selected} color={selected ? 'good' : undefined} tooltip={desc || undefined} onClick={onClick}>
      {title} ({cost})
    </Button>
  </Box>
);

const TraitsTab = ({
  data,
  act,
  search,
}: {
  data: Data;
  act: Function;
  search: string;
}) => {
  const selectedTraits = useMemo(() => new Set(data.traits || []), [data.traits]);

  const grouped = useMemo(() => {
    const groups: Record<
      string,
      {
        categoryName: string;
        available: Array<[string, TraitEntry]>;
        selected: Array<[string, TraitEntry]>;
      }
    > = {};

    Object.entries(data.available_traits || {})
      .filter(([traitId, entry]) =>
        matchesSearch(search, traitId, entry.name, entry.desc, entry.category, entry.category_name)
      )
      .forEach(([traitId, entry]) => {
        const category = entry.category || 'other';
        const categoryName = entry.category_name || 'Other';
        if (!groups[category]) groups[category] = { categoryName, available: [], selected: [] };
        if (selectedTraits.has(traitId)) groups[category].selected.push([traitId, entry]);
        else groups[category].available.push([traitId, entry]);
      });

    Object.values(groups).forEach((group) => {
      group.available.sort((a, b) => (a[1].name || a[0]).localeCompare(b[1].name || b[0]));
      group.selected.sort((a, b) => (a[1].name || a[0]).localeCompare(b[1].name || b[0]));
    });

    return Object.entries(groups).sort((a, b) => a[1].categoryName.localeCompare(b[1].categoryName));
  }, [data.available_traits, search, selectedTraits]);

  return (
    <Section title="Traits">
      {!grouped.length ? (
        <NoticeBox>No matches found.</NoticeBox>
      ) : (
        <Stack vertical>
          {grouped.map(([categoryKey, group]) => (
            <Box key={categoryKey} mb={2} style={{ borderBottom: '1px solid rgba(255,255,255,0.08)', paddingBottom: '10px' }}>
              <Box bold mb={1} style={{ fontSize: '18px', letterSpacing: '1px' }}>
                {group.categoryName}
              </Box>
              <Box bold mb={0.5}>Pool</Box>
              {group.available.length ? (
                <Stack wrap>
                  {group.available.map(([traitId, entry]) => (
                    <Stack.Item key={traitId}>
                      <TraitPill
                        title={entry.name || traitId}
                        cost={entry.cost || 0}
                        desc={entry.desc}
                        onClick={() => act('add_trait', { id: traitId })}
                      />
                    </Stack.Item>
                  ))}
                </Stack>
              ) : (
                <NoticeBox>No available traits in this group.</NoticeBox>
              )}

              <Box bold mt={1} mb={0.5}>Selected</Box>
              {group.selected.length ? (
                <Stack wrap>
                  {group.selected.map(([traitId, entry]) => (
                    <Stack.Item key={traitId}>
                      <TraitPill
                        title={entry.name || traitId}
                        cost={entry.cost || 0}
                        desc={entry.desc}
                        selected
                        onClick={() => act('remove_trait', { id: traitId })}
                      />
                    </Stack.Item>
                  ))}
                </Stack>
              ) : (
                <NoticeBox>No selected traits in this group.</NoticeBox>
              )}
            </Box>
          ))}
        </Stack>
      )}
    </Section>
  );
};

const ItemsTab = ({
  itemEntries,
  act,
  search,
  setHoveredItem,
}: {
  itemEntries: Record<string, ItemViewEntry>;
  act: Function;
  search: string;
  setHoveredItem: (value: HoverCardData | null) => void;
}) => {
  const groups = useMemo(() => {
    return groupEntriesByCategoryAndSlot(
      itemEntries || {},
      (itemPath, entry) =>
        !!entry.unlocked &&
        matchesSearch(
          search,
          itemPath,
          entry.name,
          entry.category,
          entry.slot_group,
          entry.unlock_type,
          entry.unlock_key
        )
    );
  }, [itemEntries, search]);

  return (
    <Section title="Items">
      {!groups.length ? (
        <NoticeBox>No matches found.</NoticeBox>
      ) : (
        <Stack vertical>
          {groups.map(([categoryKey, slotGroups]) => (
            <Box key={categoryKey} mb={2}>
              <Box bold mb={1} style={{ fontSize: '16px', letterSpacing: '0.5px', color: '#f0c35a' }}>
                {getCategoryLabel(categoryKey)}
              </Box>

              {slotGroups.map(([slotKey, items]) => (
                <Box key={`${categoryKey}-${slotKey}`} mb={1}>
                  <Box bold mb={0.5} style={{ fontSize: '14px', letterSpacing: '0.5px', opacity: 0.9 }}>
                    {getSlotLabel(slotKey)}
                  </Box>

                  <Stack wrap>
                    {items.map(([itemPath, entry]) => (
                      <ItemTile
                        key={itemPath}
                        name={entry.name || itemPath}
                        topRightText={`${entry.cost || 0} pts`}
                        bottomLeftText={(entry.amount || 0) > 0 ? entry.amount : undefined}
                        icon={entry.icon}
                        onLeftClick={() => act('add_item', { path: itemPath, amount: 1 })}
                        onRightClick={() => act('remove_item', { path: itemPath, amount: 1 })}
                        onHoverStart={() =>
                          setHoveredItem({
                            name: entry.name || itemPath,
                            slot: getSlotLabel(entry.slot_group),
                            category: getCategoryLabel(entry.category),
                            costText: `${entry.cost || 0} pts`,
                            total: entry.amount || 0,
                            leftHelp: 'add item',
                            rightHelp: 'remove item',
                          })
                        }
                        onHoverEnd={() => setHoveredItem(null)}
                      />
                    ))}
                  </Stack>
                </Box>
              ))}
            </Box>
          ))}
        </Stack>
      )}
    </Section>
  );
};

const LoadoutTab = ({
  loadoutEntries,
  act,
  search,
  setHoveredItem,
}: {
  loadoutEntries: Record<string, LoadoutViewEntry>;
  act: Function;
  search: string;
  setHoveredItem: (value: HoverCardData | null) => void;
}) => {
  const groups = useMemo(() => {
    return groupEntriesByCategoryAndSlot(
      loadoutEntries || {},
      (itemPath, entry) => matchesSearch(search, itemPath, entry.name, entry.category, entry.slot_group)
    );
  }, [loadoutEntries, search]);

  return (
    <Section title="Loadout">
      {!groups.length ? (
        <NoticeBox>No matches found.</NoticeBox>
      ) : (
        <Stack vertical>
          {groups.map(([categoryKey, slotGroups]) => (
            <Box
              key={categoryKey}
              mb={1.5}
              style={{
                borderTop: '1px solid rgba(255,255,255,0.08)',
                paddingTop: '8px',
              }}>
              <Box
                bold
                mb={0.75}
                style={{
                  fontSize: '14px',
                  letterSpacing: '0.4px',
                  color: 'rgba(240,195,90,0.9)',
                  textTransform: 'uppercase',
                }}>
                {getCategoryLabel(categoryKey)}
              </Box>

              {slotGroups.map(([slotKey, items]) => (
                <Box
                  key={`${categoryKey}-${slotKey}`}
                  mb={0.75}
                  style={{
                    background: 'rgba(255,255,255,0.02)',
                    border: '1px solid rgba(255,255,255,0.06)',
                    borderRadius: '6px',
                    padding: '6px 8px 8px 8px',
                  }}>
                  <Box
                    bold
                    mb={0.5}
                    style={{
                      fontSize: '12px',
                      letterSpacing: '0.35px',
                      opacity: 0.88,
                    }}>
                    {getSlotLabel(slotKey)} ({items.length})
                  </Box>

                  <Stack wrap>
                    {items.map(([itemPath, entry]) => {
                      const amount = entry.amount || 0;
                      const bag = Math.max(0, Math.min(entry.bag || 0, amount));
                      const equip = Math.max(0, entry.equip || 0);

                      const glow =
                        bag <= 0
                          ? 'rgba(80, 220, 120, 0.45)'
                          : bag >= amount
                            ? 'rgba(255, 160, 64, 0.45)'
                            : 'rgba(180, 180, 180, 0.3)';

                      return (
                        <ItemTile
                          key={itemPath}
                          name={entry.name || itemPath}
                          topRightText={`x${amount}`}
                          bottomLeftText={bag > 0 ? `B${bag}` : undefined}
                          bottomRightText={equip > 0 ? `E${equip}` : undefined}
                          icon={entry.icon}
                          glow={glow}
                          onLeftClick={() => act('move_item_to_bag', { path: itemPath, amount: 1 })}
                          onRightClick={() => act('move_item_to_equip', { path: itemPath, amount: 1 })}
                          onHoverStart={() =>
                            setHoveredItem({
                              name: entry.name || itemPath,
                              slot: getSlotLabel(entry.slot_group),
                              category: getCategoryLabel(entry.category),
                              total: amount,
                              bag,
                              equip,
                              leftHelp: '+1 to bag',
                              rightHelp: '-1 from bag / back to equip',
                            })
                          }
                          onHoverEnd={() => setHoveredItem(null)}
                        />
                      );
                    })}
                  </Stack>
                </Box>
              ))}
            </Box>
          ))}
        </Stack>
      )}
    </Section>
  );
};

export const TATBuild = () => {
  const { act, data } = useBackend<Data>();
  const [tab, setTab] = useState<TabKey>('stats');
  const [search, setSearch] = useState('');
  const [hoveredItem, setHoveredItem] = useState<HoverCardData | null>(null);

  const itemEntries = useMemo<Record<string, ItemViewEntry>>(() => {
    const result: Record<string, ItemViewEntry> = {};
    const staticEntries = data.available_items || {};
    const states = data.items || {};

    Object.entries(staticEntries).forEach(([itemPath, entry]) => {
      const state = states[itemPath];
      result[itemPath] = {
        ...entry,
        amount: state?.amount || 0,
        unlocked: !!state?.unlocked,
      };
    });

    return result;
  }, [data.available_items, data.items]);

  const loadoutEntries = useMemo<Record<string, LoadoutViewEntry>>(() => {
    const result: Record<string, LoadoutViewEntry> = {};
    const staticEntries = data.available_items || {};
    const loadoutStates = data.loadout || {};

    Object.entries(loadoutStates).forEach(([itemPath, state]) => {
      const entry = staticEntries[itemPath];
      if (!entry) {
        return;
      }

      result[itemPath] = {
        ...entry,
        amount: state.amount || 0,
        equip: state.equip || 0,
        bag: state.bag || 0,
      };
    });

    return result;
  }, [data.available_items, data.loadout]);

  return (
    <Window title="TAT Build" width={900} height={790}>
      <Window.Content scrollable>
        <Stack vertical>
          <PointsPanel data={data} />

          <Section title="Search">
            <Stack align="center">
              <Stack.Item grow>
                <Input fluid placeholder={`Search in ${tab}...`} value={search} onChange={(value) => setSearch(String(value))} />
              </Stack.Item>
              <Stack.Item>
                <Button disabled={!search} onClick={() => setSearch('')}>
                  Clear
                </Button>
              </Stack.Item>
            </Stack>
          </Section>

          {data.dirty ? <NoticeBox>Build has unsaved changes.</NoticeBox> : <NoticeBox>Build is saved.</NoticeBox>}
          {!data.can_save && <NoticeBox>Current build is invalid or exceeds available points.</NoticeBox>}

          <Section>
            <Tabs fluid>
              <Tabs.Tab selected={tab === 'stats'} onClick={() => setTab('stats')}>Stats</Tabs.Tab>
              <Tabs.Tab selected={tab === 'skills'} onClick={() => setTab('skills')}>Skills</Tabs.Tab>
              <Tabs.Tab selected={tab === 'traits'} onClick={() => setTab('traits')}>Traits</Tabs.Tab>
              <Tabs.Tab selected={tab === 'items'} onClick={() => setTab('items')}>Items</Tabs.Tab>
              <Tabs.Tab selected={tab === 'loadout'} onClick={() => setTab('loadout')}>Loadout</Tabs.Tab>
            </Tabs>
          </Section>

          {tab === 'stats' && <StatsTab data={data} act={act} search={search} />}
          {tab === 'skills' && <SkillsTab data={data} act={act} search={search} />}
          {tab === 'traits' && <TraitsTab data={data} act={act} search={search} />}
          {tab === 'items' && <ItemsTab itemEntries={itemEntries} act={act} search={search} setHoveredItem={setHoveredItem} />}
          {tab === 'loadout' && <LoadoutTab loadoutEntries={loadoutEntries} act={act} search={search} setHoveredItem={setHoveredItem} />}

          <Section>
            <Stack justify="space-between" wrap>
              <Stack.Item>
                <Stack wrap>
                  <Stack.Item><Button onClick={() => act('reset_stats')}>Reset Stats</Button></Stack.Item>
                  <Stack.Item><Button onClick={() => act('reset_skills')}>Reset Skills</Button></Stack.Item>
                  <Stack.Item><Button onClick={() => act('reset_traits')}>Reset Traits</Button></Stack.Item>
                  <Stack.Item><Button onClick={() => act('reset_items')}>Reset Items</Button></Stack.Item>
                </Stack>
              </Stack.Item>

              <Stack.Item>
                <Stack>
                  <Stack.Item><Button color="average" onClick={() => act('reset_all')}>Reset All</Button></Stack.Item>
                  <Stack.Item><Button color="good" disabled={!data.can_save} onClick={() => act('save')}>Save</Button></Stack.Item>
                </Stack>
              </Stack.Item>
            </Stack>
          </Section>
        </Stack>

        <HoverCard data={hoveredItem} />
      </Window.Content>
    </Window>
  );
};

export default TATBuild;
