import { useEffect, useMemo, useState } from 'react';
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
  bonus?: number;
  invested?: number;
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

type SlotSummary = {
  stats: number;
  skills: number;
  traits: number;
  items: number;
};

type TatSlotEntry = {
  id: number;
  name: string;
  active?: boolean;
  summary?: SlotSummary;
};

type TatPresetEntry = {
  id: string;
  name: string;
  summary?: SlotSummary;
};

type ItemCachePacket = {
  full?: boolean;
  catalog?: Record<string, ItemEntry> | null;
  states?: Record<string, ItemState> | null;
};

type SkillDomainKey =
  | 'combat'
  | 'magic'
  | 'wandering'
  | 'gathering'
  | 'crafting'
  | 'misc';

type Data = {
  stats: Record<string, number>;
  skills: Record<string, SkillState>;
  traits: string[];
  items: Record<string, ItemState> | null;
  loadout: Record<string, LoadoutState>;

  available_stats: Record<string, StatEntry>;
  available_skills: Record<string, SkillEntry>;
  available_traits: Record<string, TraitEntry>;
  available_items: Record<string, ItemEntry> | null;

  item_cache?: ItemCachePacket | null;

  points_stats: number;
  points_stats_remaining: number;
  points_skills: number;
  points_skills_remaining: number;
  points_traits: number;
  points_traits_remaining: number;
  points_items: number;
  points_items_remaining: number;

  skill_points_by_domain?: Partial<Record<SkillDomainKey, number>>;
  skill_points_remaining_by_domain?: Partial<Record<SkillDomainKey, number>>;

  tat_slots?: TatSlotEntry[] | Record<string, TatSlotEntry>;
  tat_presets?: TatPresetEntry[] | null;
  active_tat_slot?: number;

  can_save: boolean;
  validation_issues?: string[];
  dirty: boolean;
};

type TabKey = 'control' | 'stats' | 'skills' | 'traits' | 'items' | 'loadout';
type BackendAct = (action: string, payload?: Record<string, unknown>) => void;

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

type SkillHoverData = {
  name: string;
  desc?: string;
  category?: string;
  level: number;
  cap: number;
  cost: number;
  bonus: number;
  invested: number;
  domainRemaining: number | null;
};

type ItemViewEntry = ItemEntry & ItemState;
type LoadoutViewEntry = ItemEntry & LoadoutState;

const MAX_RENDERED_ITEMS_PER_SLOT = 80;

const SKILL_DOMAIN_TITLES: Record<SkillDomainKey, string> = {
  combat: 'Combat',
  magic: 'Magic',
  wandering: 'Wandering',
  gathering: 'Gathering',
  crafting: 'Crafting',
  misc: 'Misc',
};

const SKILL_DOMAIN_ORDER: SkillDomainKey[] = [
  'combat',
  'magic',
  'wandering',
  'gathering',
  'crafting',
  'misc',
];

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

const normalizePresetSummary = (summary?: SlotSummary): SlotSummary => ({
  stats: Number(summary?.stats) || 0,
  skills: Number(summary?.skills) || 0,
  traits: Number(summary?.traits) || 0,
  items: Number(summary?.items) || 0,
});

const normalizeTatPresets = (raw?: TatPresetEntry[] | null): TatPresetEntry[] => {
  if (!Array.isArray(raw)) {
    return [];
  }

  return raw
    .filter(Boolean)
    .map((preset, index) => ({
      id: String(preset?.id || `preset_${index + 1}`),
      name: String(preset?.name || `Preset ${index + 1}`),
      summary: normalizePresetSummary(preset?.summary),
    }))
    .sort((a, b) => a.name.localeCompare(b.name));
};

const normalizeTatSlots = (
  raw: Data['tat_slots'],
  activeSlotId?: number
): TatSlotEntry[] => {
  const makeSummary = (summary?: SlotSummary): SlotSummary => ({
    stats: Number(summary?.stats) || 0,
    skills: Number(summary?.skills) || 0,
    traits: Number(summary?.traits) || 0,
    items: Number(summary?.items) || 0,
  });

  if (!raw) {
    return [];
  }

  if (Array.isArray(raw)) {
    return raw
      .filter(Boolean)
      .map((slot, index) => {
        const id = Number(slot?.id) || index + 1;
        return {
          id,
          name: String(slot?.name || `Slot ${id}`),
          active: Number(activeSlotId) === id || !!slot?.active,
          summary: makeSummary(slot?.summary),
        };
      })
      .sort((a, b) => a.id - b.id);
  }

  return Object.entries(raw)
    .map(([key, slot], index) => {
      const id = Number(slot?.id) || Number(key) || index + 1;
      return {
        id,
        name: String(slot?.name || `Slot ${id}`),
        active: Number(activeSlotId) === id || !!slot?.active,
        summary: makeSummary(slot?.summary),
      };
    })
    .sort((a, b) => a.id - b.id);
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

const normalizeSkillDomain = (value?: string | null): SkillDomainKey => {
  const normalized = normalizeSearch(value);
  if (
    normalized === 'combat' ||
    normalized === 'magic' ||
    normalized === 'wandering' ||
    normalized === 'gathering' ||
    normalized === 'crafting' ||
    normalized === 'misc'
  ) {
    return normalized;
  }
  return 'misc';
};

const formatSkillDisplayValue = (state?: SkillState) => {
  const total = Number(state?.level) || 0;
  const bonus = Number(state?.bonus) || 0;
  return bonus > 0 ? `${total}(${bonus})` : `${total}`;
};

const formatDomainPoints = (data: Data, domain: SkillDomainKey) => {
  const total = data.skill_points_by_domain?.[domain];
  const remaining = data.skill_points_remaining_by_domain?.[domain];

  if (typeof total === 'number' && typeof remaining === 'number') {
    return `${remaining} / ${total}`;
  }

  return '? / ?';
};

const getDomainRemainingPoints = (data: Data, domain: SkillDomainKey) => {
  const remaining = data.skill_points_remaining_by_domain?.[domain];
  return typeof remaining === 'number' ? remaining : null;
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
            <Button compact onClick={onRemove} disabled={disabledRemove}>
              -
            </Button>
          </Stack.Item>

          <Stack.Item>
            <Box width="34px" textAlign="center" bold>
              {value}
            </Box>
          </Stack.Item>

          <Stack.Item>
            <Button compact onClick={onAdd} disabled={disabledAdd}>
              +
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

const SkillHoverCard = ({ data }: { data: SkillHoverData | null }) => {
  if (!data) {
    return null;
  }

  return (
    <Box
      style={{
        position: 'fixed',
        right: '24px',
        top: '120px',
        width: '280px',
        padding: '10px 12px',
        borderRadius: '8px',
        background: 'rgba(10, 12, 22, 0.96)',
        border: '1px solid rgba(255,255,255,0.08)',
        boxShadow: '0 8px 20px rgba(0,0,0,0.45)',
        zIndex: 1001,
        pointerEvents: 'none',
      }}>
      <Box bold style={{ fontSize: '15px', marginBottom: '6px', color: '#f0c35a' }}>
        {data.name}
      </Box>

      {!!data.desc && (
        <Box mb={1} style={{ opacity: 0.9, lineHeight: 1.35 }}>
          {data.desc}
        </Box>
      )}

      <Box style={{ opacity: 0.9 }}>
        <b>Type:</b> {data.category || 'unknown'}
      </Box>
      <Box style={{ opacity: 0.9 }}>
        <b>Level:</b> {data.level} / {data.cap}
      </Box>
      <Box style={{ opacity: 0.9 }}>
        <b>Next cost:</b> {data.cost}
      </Box>
      <Box style={{ opacity: 0.9 }}>
        <b>Invested:</b> {data.invested}
      </Box>
      <Box style={{ opacity: 0.9 }}>
        <b>Domain points left:</b>{' '}
        {data.domainRemaining === null ? '?' : data.domainRemaining}
      </Box>

      {data.bonus > 0 && (
        <Box mt={0.75} style={{ color: '#9fd6a8' }}>
          Bonus: +{data.bonus}
        </Box>
      )}
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

        {bottomRightText !== undefined &&
          bottomRightText !== null &&
          bottomRightText !== '' && (
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

const SectionTitleWithMeta = ({
  title,
  meta,
}: {
  title: string;
  meta?: React.ReactNode;
}) => {
  return (
    <Stack align="center" justify="space-between">
      <Stack.Item>
        <Box bold>{title}</Box>
      </Stack.Item>
      <Stack.Item>
        <Box style={{ opacity: 0.8, fontSize: '12px' }}>{meta}</Box>
      </Stack.Item>
    </Stack>
  );
};

const SlotCards = ({
  slots,
  act,
}: {
  slots: TatSlotEntry[];
  act: BackendAct;
}) => {
  const [renameDrafts, setRenameDrafts] = useState<Record<number, string>>({});

  useEffect(() => {
    setRenameDrafts((prev) => {
      const next = { ...prev };
      const validIds = new Set<number>();

      slots.forEach((slot) => {
        validIds.add(slot.id);
        if (!(slot.id in next)) {
          next[slot.id] = slot.name || `Slot ${slot.id}`;
        }
      });

      Object.keys(next).forEach((key) => {
        const id = Number(key);
        if (!validIds.has(id)) {
          delete next[id];
        }
      });

      return next;
    });
  }, [slots]);

  return (
    <Section
      title="Slots"
      buttons={
        <Box style={{ opacity: 0.8, fontSize: '12px' }}>
          Activate = load slot into current build
        </Box>
      }>
      {!slots.length ? (
        <NoticeBox>No slot data received from backend.</NoticeBox>
      ) : (
        <Stack wrap>
          {slots.map((slot) => {
            const draftName = renameDrafts[slot.id] ?? slot.name ?? `Slot ${slot.id}`;
            const summary = slot.summary || {
              stats: 0,
              skills: 0,
              traits: 0,
              items: 0,
            };

            return (
              <Stack.Item
                key={slot.id}
                grow
                basis="31%"
                style={{
                  minWidth: '220px',
                  maxWidth: '32%',
                }}>
                <Box
                  style={{
                    minHeight: '98px',
                    padding: '6px',
                    borderRadius: '6px',
                    background: slot.active
                      ? 'rgba(120, 180, 120, 0.08)'
                      : 'rgba(255,255,255,0.02)',
                    border: slot.active
                      ? '1px solid rgba(120, 180, 120, 0.45)'
                      : '1px solid rgba(255,255,255,0.08)',
                  }}>
                  <Stack justify="space-between" align="center">
                    <Stack.Item>
                      <Box bold>{slot.name}</Box>
                    </Stack.Item>
                    <Stack.Item>
                      {slot.active ? (
                        <Box
                          px={0.75}
                          py={0.2}
                          style={{
                            borderRadius: '4px',
                            background: 'rgba(120,180,120,0.18)',
                            border: '1px solid rgba(120,180,120,0.35)',
                            fontSize: '10px',
                            fontWeight: 700,
                            letterSpacing: '0.3px',
                          }}>
                          ACTIVE
                        </Box>
                      ) : null}
                    </Stack.Item>
                  </Stack>

                  <Box mt={0.5} style={{ fontSize: '11px', opacity: 0.88 }}>
                    Spent: Stats - {summary.stats} | Skills - {summary.skills} | Traits -{' '}
                    {summary.traits} | Items - {summary.items}
                  </Box>

                  <Box mt={0.75}>
                    <Input
                      fluid
                      value={draftName}
                      onChange={(value) =>
                        setRenameDrafts((prev) => ({
                          ...prev,
                          [slot.id]: String(value),
                        }))
                      }
                    />
                  </Box>

                  <Stack mt={0.75}>
                    <Stack.Item grow>
                      <Button
                        fluid
                        selected={slot.active}
                        color={slot.active ? 'good' : undefined}
                        onClick={() => act('activate_tat_slot', { slot_id: slot.id })}>
                        Activate
                      </Button>
                    </Stack.Item>
                    <Stack.Item grow>
                      <Button
                        fluid
                        onClick={() =>
                          act('rename_tat_slot', {
                            slot_id: slot.id,
                            name: String(
                              renameDrafts[slot.id] ?? slot.name ?? `Slot ${slot.id}`
                            ).trim(),
                          })
                        }>
                        Rename
                      </Button>
                    </Stack.Item>
                  </Stack>
                </Box>
              </Stack.Item>
            );
          })}
        </Stack>
      )}
    </Section>
  );
};

const PresetList = ({
  presets,
  act,
  search,
}: {
  presets: TatPresetEntry[];
  act: BackendAct;
  search: string;
}) => {
  const rows = useMemo(
    () => presets.filter((preset) => matchesSearch(search, preset.id, preset.name)),
    [presets, search]
  );

  return (
    <Section title="Presets">
      {!rows.length ? (
        <NoticeBox>No presets found.</NoticeBox>
      ) : (
        <Stack vertical>
          {rows.map((preset) => {
            const summary = preset.summary || {
              stats: 0,
              skills: 0,
              traits: 0,
              items: 0,
            };

            return (
              <Box
                key={preset.id}
                mb={1}
                style={{
                  padding: '8px',
                  borderRadius: '6px',
                  background: 'rgba(255,255,255,0.02)',
                  border: '1px solid rgba(255,255,255,0.08)',
                }}>
                <Stack align="center" justify="space-between">
                  <Stack.Item grow>
                    <Box bold>{preset.name}</Box>
                    <Box mt={0.5} style={{ fontSize: '11px', opacity: 0.85 }}>
                      Spent: Stats - {summary.stats} | Skills - {summary.skills} | Traits -{' '}
                      {summary.traits} | Items - {summary.items}
                    </Box>
                  </Stack.Item>
                  <Stack.Item>
                    <Button
                      color="good"
                      onClick={() => act('load_tat_preset', { preset_id: preset.id })}>
                      Load
                    </Button>
                  </Stack.Item>
                </Stack>
              </Box>
            );
          })}
        </Stack>
      )}
    </Section>
  );
};

const ControlTab = ({
  slots,
  presets,
  act,
  search,
}: {
  slots: TatSlotEntry[];
  presets: TatPresetEntry[];
  act: BackendAct;
  search: string;
}) => {
  const [showPresets, setShowPresets] = useState(false);

  return (
    <Stack vertical>
      <SlotCards slots={slots} act={act} />
      <Section
        title="Preset Management"
        buttons={
          <Button onClick={() => setShowPresets((prev) => !prev)}>
            {showPresets ? 'Hide presets' : 'Show presets'}
          </Button>
        }>
        {showPresets ? (
          <PresetList presets={presets} act={act} search={search} />
        ) : (
          <NoticeBox>Presets are hidden. Open them with the button above.</NoticeBox>
        )}
      </Section>
    </Stack>
  );
};

const StatsTab = ({
  data,
  act,
  search,
}: {
  data: Data;
  act: BackendAct;
  search: string;
}) => {
  const rows = useMemo(
    () =>
      Object.entries(data.available_stats || {}).filter(([statId, entry]) =>
        matchesSearch(search, entry.name, statId)
      ),
    [data.available_stats, search]
  );

  return (
    <Section
      title={
        <SectionTitleWithMeta
          title="Stats"
          meta={`Free: ${data.points_stats_remaining} / ${data.points_stats}`}
        />
      }>
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
                disabledRemove={value <= 1}
                extra={
                  <Box>
                    Base: {entry.base} | Refund floor: {entry.min} | Max: {entry.max} | Cost per
                    step: {entry.cost}
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

const SkillRow = ({
  skillPath,
  entry,
  state,
  act,
  domainRemaining,
  setHoveredSkill,
}: {
  skillPath: string;
  entry: SkillEntry;
  state?: SkillState;
  act: BackendAct;
  domainRemaining: number | null;
  setHoveredSkill: (value: SkillHoverData | null) => void;
}) => {
  const totalLevel = Number(state?.level) || 0;
  const invested = Number(state?.invested) || 0;
  const cap = Number(state?.cap) || 0;
  const nextCost = Number(state?.next_cost) || 0;
  const bonus = Number(state?.bonus) || 0;
  const displayValue = formatSkillDisplayValue(state);

  const disableRemove = invested <= 0;
  const disableAdd =
    totalLevel >= cap ||
    (domainRemaining !== null && domainRemaining < nextCost);

  return (
    <div
    onMouseEnter={() =>
      setHoveredSkill({
        name: entry.name || skillPath,
        desc: entry.desc,
        category: entry.category,
        level: totalLevel,
        cap,
        cost: nextCost,
        bonus,
        invested,
        domainRemaining,
      })
    }
    onMouseLeave={() => setHoveredSkill(null)}>
    <Stack
      align="center"
      justify="space-between"
      style={{
        padding: '4px 0',
        borderBottom: '1px solid rgba(255,255,255,0.05)',
        minHeight: '34px',
      }}>
      <Stack.Item grow>
        <Box bold>{entry.name || skillPath}</Box>
        <Box style={{ opacity: 0.72, fontSize: '11px' }}>
          Cost: {nextCost} | Type: {entry.category || 'unknown'} | Cap: {cap}
          {bonus > 0 ? ` | Bonus: ${bonus}` : ''}
        </Box>
      </Stack.Item>

      <Stack.Item>
        <Stack align="center">
          <Stack.Item>
            <Button
              compact
              onClick={() => act('remove_skill', { path: skillPath, amount: 1 })}
              disabled={disableRemove}>
              -
            </Button>
          </Stack.Item>

          <Stack.Item>
            <Box
              width="56px"
              textAlign="center"
              bold
              style={{
                fontSize: '13px',
              }}>
              {displayValue}
            </Box>
          </Stack.Item>

          <Stack.Item>
            <Button
              compact
              onClick={() => act('add_skill', { path: skillPath, amount: 1 })}
              disabled={disableAdd}>
              +
            </Button>
          </Stack.Item>
        </Stack>
      </Stack.Item>
    </Stack>
    </div>
  );
};

const SkillsDomainPanel = ({
  domain,
  rows,
  data,
  act,
  setHoveredSkill,
}: {
  domain: SkillDomainKey;
  rows: Array<[string, SkillEntry]>;
  data: Data;
  act: BackendAct;
  setHoveredSkill: (value: SkillHoverData | null) => void;
}) => {
  const domainRemaining = getDomainRemainingPoints(data, domain);

  return (
    <Stack.Item grow basis="32%" style={{ minWidth: '270px' }}>
      <Section
        title={
          <SectionTitleWithMeta
            title={SKILL_DOMAIN_TITLES[domain]}
            meta={formatDomainPoints(data, domain)}
          />
        }
        fill
        style={{
          height: '320px',
        }}>
        {!rows.length ? (
          <NoticeBox>No skills in this group.</NoticeBox>
        ) : (
          <Box
            style={{
              maxHeight: '260px',
              overflowY: 'auto',
              paddingRight: '4px',
            }}>
            {rows.map(([skillPath, entry]) => (
              <SkillRow
                key={skillPath}
                skillPath={skillPath}
                entry={entry}
                state={data.skills?.[skillPath]}
                act={act}
                domainRemaining={domainRemaining}
                setHoveredSkill={setHoveredSkill}
              />
            ))}
          </Box>
        )}
      </Section>
    </Stack.Item>
  );
};

const SkillsTab = ({
  data,
  act,
  search,
  setHoveredSkill,
}: {
  data: Data;
  act: BackendAct;
  search: string;
  setHoveredSkill: (value: SkillHoverData | null) => void;
}) => {
  const groups = useMemo(() => {
    const byDomain: Record<SkillDomainKey, Array<[string, SkillEntry]>> = {
      combat: [],
      magic: [],
      wandering: [],
      gathering: [],
      crafting: [],
      misc: [],
    };

    Object.entries(data.available_skills || {}).forEach(([skillPath, entry]) => {
      if (
        !matchesSearch(
          search,
          skillPath,
          entry.name,
          entry.desc,
          entry.category,
          entry.is_combat ? 'combat' : 'non-combat'
        )
      ) {
        return;
      }

      const domain = normalizeSkillDomain(entry.category);
      byDomain[domain].push([skillPath, entry]);
    });

    SKILL_DOMAIN_ORDER.forEach((domain) => {
      byDomain[domain].sort((a, b) => (a[1].name || a[0]).localeCompare(b[1].name || b[0]));
    });

    return byDomain;
  }, [data.available_skills, search]);

  const hasAny = SKILL_DOMAIN_ORDER.some((domain) => groups[domain].length > 0);

  return (
    <Section title="Skills">
      {!hasAny ? (
        <NoticeBox>No matches found.</NoticeBox>
      ) : (
        <Stack wrap align="stretch">
          {SKILL_DOMAIN_ORDER.map((domain) => (
            <SkillsDomainPanel
              key={domain}
              domain={domain}
              rows={groups[domain]}
              data={data}
              act={act}
              setHoveredSkill={setHoveredSkill}
            />
          ))}
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
    <Button
      selected={selected}
      color={selected ? 'good' : undefined}
      tooltip={desc || undefined}
      onClick={onClick}>
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
  act: BackendAct;
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
        if (!groups[category]) {
          groups[category] = {
            categoryName,
            available: [],
            selected: [],
          };
        }
        if (selectedTraits.has(traitId)) {
          groups[category].selected.push([traitId, entry]);
        } else {
          groups[category].available.push([traitId, entry]);
        }
      });

    Object.values(groups).forEach((group) => {
      group.available.sort((a, b) => (a[1].name || a[0]).localeCompare(b[1].name || b[0]));
      group.selected.sort((a, b) => (a[1].name || a[0]).localeCompare(b[1].name || b[0]));
    });

    return Object.entries(groups).sort((a, b) => a[1].categoryName.localeCompare(b[1].categoryName));
  }, [data.available_traits, search, selectedTraits]);

  return (
    <Section
      title={
        <SectionTitleWithMeta
          title="Traits"
          meta={`Free: ${data.points_traits_remaining} / ${data.points_traits}`}
        />
      }>
      {!grouped.length ? (
        <NoticeBox>No matches found.</NoticeBox>
      ) : (
        <Stack vertical>
          {grouped.map(([categoryKey, group]) => (
            <Box
              key={categoryKey}
              mb={2}
              style={{
                borderBottom: '1px solid rgba(255,255,255,0.08)',
                paddingBottom: '10px',
              }}>
              <Box bold mb={1} style={{ fontSize: '18px', letterSpacing: '1px' }}>
                {group.categoryName}
              </Box>

              <Box bold mb={0.5}>
                Pool
              </Box>
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

              <Box bold mt={1} mb={0.5}>
                Selected
              </Box>
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
  itemCacheLoaded,
  data,
}: {
  itemEntries: Record<string, ItemViewEntry>;
  act: BackendAct;
  search: string;
  setHoveredItem: (value: HoverCardData | null) => void;
  itemCacheLoaded: boolean;
  data: Data;
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
    <Section
      title={
        <SectionTitleWithMeta
          title="Items"
          meta={`Free: ${data.points_items_remaining} / ${data.points_items}`}
        />
      }>
      {!itemCacheLoaded ? (
        <NoticeBox>Loading item cache...</NoticeBox>
      ) : !groups.length ? (
        <NoticeBox>No matches found.</NoticeBox>
      ) : (
        <Stack vertical>
          {groups.map(([categoryKey, slotGroups]) => (
            <Box key={categoryKey} mb={2}>
              <Box
                bold
                mb={1}
                style={{ fontSize: '16px', letterSpacing: '0.5px', color: '#f0c35a' }}>
                {getCategoryLabel(categoryKey)}
              </Box>

              {slotGroups.map(([slotKey, items]) => {
                const visibleItems = items.slice(0, MAX_RENDERED_ITEMS_PER_SLOT);

                return (
                  <Box key={`${categoryKey}-${slotKey}`} mb={1}>
                    <Box
                      bold
                      mb={0.5}
                      style={{ fontSize: '14px', letterSpacing: '0.5px', opacity: 0.9 }}>
                      {getSlotLabel(slotKey)} ({items.length})
                    </Box>

                    <Stack wrap>
                      {visibleItems.map(([itemPath, entry]) => (
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

                    {items.length > MAX_RENDERED_ITEMS_PER_SLOT && (
                      <NoticeBox>
                        Showing first {MAX_RENDERED_ITEMS_PER_SLOT} items. Use search to narrow
                        results.
                      </NoticeBox>
                    )}
                  </Box>
                );
              })}
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
  act: BackendAct;
  search: string;
  setHoveredItem: (value: HoverCardData | null) => void;
}) => {
  const groups = useMemo(() => {
    return groupEntriesByCategoryAndSlot(
      loadoutEntries || {},
      (itemPath, entry) =>
        matchesSearch(search, itemPath, entry.name, entry.category, entry.slot_group)
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

              {slotGroups.map(([slotKey, items]) => {
                const visibleItems = items.slice(0, MAX_RENDERED_ITEMS_PER_SLOT);

                return (
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
                      {visibleItems.map(([itemPath, entry]) => {
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
                            onRightClick={() =>
                              act('move_item_to_equip', { path: itemPath, amount: 1 })
                            }
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

                    {items.length > MAX_RENDERED_ITEMS_PER_SLOT && (
                      <NoticeBox>
                        Showing first {MAX_RENDERED_ITEMS_PER_SLOT} items. Use search to narrow
                        results.
                      </NoticeBox>
                    )}
                  </Box>
                );
              })}
            </Box>
          ))}
        </Stack>
      )}
    </Section>
  );
};

export const TATBuild = () => {
  const { act, data } = useBackend<Data>();
  const [tab, setTab] = useState<TabKey>('control');
  const [search, setSearch] = useState('');
  const [hoveredItem, setHoveredItem] = useState<HoverCardData | null>(null);
  const [hoveredSkill, setHoveredSkill] = useState<SkillHoverData | null>(null);

  const [cachedAvailableItems, setCachedAvailableItems] = useState<Record<string, ItemEntry>>({});
  const [cachedItemStates, setCachedItemStates] = useState<Record<string, ItemState>>({});

  const tatSlots = useMemo<TatSlotEntry[]>(
    () => normalizeTatSlots(data.tat_slots, data.active_tat_slot),
    [data.tat_slots, data.active_tat_slot]
  );

  const tatPresets = useMemo<TatPresetEntry[]>(
    () => normalizeTatPresets(data.tat_presets),
    [data.tat_presets]
  );

  const hasCachedItems = Object.keys(cachedAvailableItems).length > 0;

  useEffect(() => {
    if (tab !== 'items' && tab !== 'loadout') {
      return;
    }

    if (hasCachedItems) {
      act('request_item_cache', { full: 0 });
      return;
    }

    act('request_item_cache', { full: 1 });
  }, [tab, hasCachedItems]);

  useEffect(() => {
    const packet = data.item_cache;
    if (!packet) {
      return;
    }

    if (packet.catalog) {
      setCachedAvailableItems((prev) => ({
        ...prev,
        ...packet.catalog,
      }));
    }

    if (packet.states) {
      setCachedItemStates(packet.states || {});
    }
  }, [data.item_cache]);

  const itemEntries = useMemo<Record<string, ItemViewEntry>>(() => {
    const result: Record<string, ItemViewEntry> = {};
    const staticEntries = cachedAvailableItems || {};
    const states = cachedItemStates || {};

    Object.entries(staticEntries).forEach(([itemPath, entry]) => {
      const state = states[itemPath];
      result[itemPath] = {
        ...entry,
        amount: state?.amount || 0,
        unlocked: !!state?.unlocked,
      };
    });

    return result;
  }, [cachedAvailableItems, cachedItemStates]);

  const loadoutEntries = useMemo<Record<string, LoadoutViewEntry>>(() => {
    const result: Record<string, LoadoutViewEntry> = {};
    const staticEntries = cachedAvailableItems || {};
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
  }, [cachedAvailableItems, data.loadout]);

  const itemCacheLoaded = Object.keys(cachedAvailableItems).length > 0;
  const searchPlaceholder = tab === 'control' ? 'Search presets...' : `Search in ${tab}...`;

  return (
    <Window title="TAT Build" width={980} height={900}>
      <Window.Content scrollable>
        <Stack vertical>
          <Section title="Search">
            <Stack align="center">
              <Stack.Item grow>
                <Input
                  fluid
                  placeholder={searchPlaceholder}
                  value={search}
                  onChange={(value) => setSearch(String(value))}
                />
              </Stack.Item>
              <Stack.Item>
                <Button disabled={!search} onClick={() => setSearch('')}>
                  Clear
                </Button>
              </Stack.Item>
            </Stack>
          </Section>

          {data.dirty ? (
            <NoticeBox>Build has unsaved changes.</NoticeBox>
          ) : (
            <NoticeBox>Build is saved.</NoticeBox>
          )}

          {!data.can_save && (
            <NoticeBox>
              <Box bold mb={0.5}>
                Current build is invalid:
              </Box>

              {data.validation_issues?.length ? (
                <Stack vertical>
                  {data.validation_issues.map((issue, index) => (
                    <Box key={index}>• {issue}</Box>
                  ))}
                </Stack>
              ) : (
                <Box>Current build is invalid or exceeds available points.</Box>
              )}
            </NoticeBox>
          )}

          <Section
            title="Build"
            buttons={
              <Box style={{ opacity: 0.8, fontSize: '12px' }}>
                Save writes current build into the active slot
              </Box>
            }>
            <Tabs fluid>
              <Tabs.Tab selected={tab === 'control'} onClick={() => setTab('control')}>
                Control
              </Tabs.Tab>
              <Tabs.Tab selected={tab === 'stats'} onClick={() => setTab('stats')}>
                Stats
              </Tabs.Tab>
              <Tabs.Tab selected={tab === 'skills'} onClick={() => setTab('skills')}>
                Skills
              </Tabs.Tab>
              <Tabs.Tab selected={tab === 'traits'} onClick={() => setTab('traits')}>
                Traits
              </Tabs.Tab>
              <Tabs.Tab selected={tab === 'items'} onClick={() => setTab('items')}>
                Items
              </Tabs.Tab>
              <Tabs.Tab selected={tab === 'loadout'} onClick={() => setTab('loadout')}>
                Loadout
              </Tabs.Tab>
            </Tabs>
          </Section>

          {tab === 'control' && (
            <ControlTab slots={tatSlots} presets={tatPresets} act={act} search={search} />
          )}
          {tab === 'stats' && <StatsTab data={data} act={act} search={search} />}
          {tab === 'skills' && (
            <SkillsTab
              data={data}
              act={act}
              search={search}
              setHoveredSkill={setHoveredSkill}
            />
          )}
          {tab === 'traits' && <TraitsTab data={data} act={act} search={search} />}
          {tab === 'items' && (
            <ItemsTab
              itemEntries={itemEntries}
              act={act}
              search={search}
              setHoveredItem={setHoveredItem}
              itemCacheLoaded={itemCacheLoaded}
              data={data}
            />
          )}
          {tab === 'loadout' && (
            <LoadoutTab
              loadoutEntries={loadoutEntries}
              act={act}
              search={search}
              setHoveredItem={setHoveredItem}
            />
          )}

          <Section>
            <Stack justify="space-between" wrap>
              <Stack.Item>
                <Stack wrap>
                  <Stack.Item>
                    <Button onClick={() => act('reset_stats')}>Reset Stats</Button>
                  </Stack.Item>
                  <Stack.Item>
                    <Button onClick={() => act('reset_skills')}>Reset Skills</Button>
                  </Stack.Item>
                  <Stack.Item>
                    <Button onClick={() => act('reset_traits')}>Reset Traits</Button>
                  </Stack.Item>
                  <Stack.Item>
                    <Button onClick={() => act('reset_items')}>Reset Items</Button>
                  </Stack.Item>
                </Stack>
              </Stack.Item>

              <Stack.Item>
                <Stack>
                  <Stack.Item>
                    <Button color="average" onClick={() => act('reset_all')}>
                      Reset All
                    </Button>
                  </Stack.Item>
                  <Stack.Item>
                    <Button color="good" disabled={!data.can_save} onClick={() => act('save')}>
                      Save Active Slot
                    </Button>
                  </Stack.Item>
                </Stack>
              </Stack.Item>
            </Stack>
          </Section>
        </Stack>

        <HoverCard data={hoveredItem} />
        <SkillHoverCard data={hoveredSkill} />
      </Window.Content>
    </Window>
  );
};

export default TATBuild;
