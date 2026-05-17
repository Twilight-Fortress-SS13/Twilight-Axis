import { useEffect, useMemo, useState } from 'react';
import { ReactNode } from 'react';
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
  TextArea,
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
  repeatable?: boolean;
  maximum?: number;
};

type TraitState = {
  amount: number;
  can_add?: boolean;
  maximum?: number;
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
  maximum?: number;
  can_add?: boolean;
};

type LoadoutPaintState = {
  primary?: string;
  detail?: string;
  altdetail?: string;
};

type LoadoutState = {
  amount: number;
  equip: number;
  bag: number;
  stash: number;
  slots?: Record<string, boolean>;
  valid_slots?: string[];
  sources?: Record<string, number>;
  paint?: LoadoutPaintState | null;
  icon?: string | null;
  icon_state?: string | null;
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

type SkillDomainKey =
  | 'combat'
  | 'wandering'
  | 'gathering'
  | 'crafting'
  | 'misc';

type SkillConversionDomainState = {
  can_give?: boolean;
  can_take?: boolean;
  give_text?: string;
  take_text?: string;
};

type Data = {
  stats: Record<string, number>;
  skills: Record<string, SkillState>;
  traits: string[];
  trait_counts?: Record<string, number>;
  traits_state?: Record<string, TraitState>;
  items_state: Record<string, ItemState>;
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

  skill_points_by_domain?: Partial<Record<SkillDomainKey, number>>;
  skill_points_remaining_by_domain?: Partial<Record<SkillDomainKey, number>>;
  skill_conversion_pool?: number;
  skill_conversion_state?: Partial<Record<SkillDomainKey, SkillConversionDomainState>>;

  tat_slots?: TatSlotEntry[] | Record<string, TatSlotEntry>;
  active_tat_slot?: number;

  build_json?: string | null;
  last_json_error?: string | null;
  last_json_notice?: string | null;

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
  extra?: ReactNode;
};

type HoverCardData = {
  name: string;
  desc?: string;
  slot?: string | null;
  category?: string | null;
  costText?: string;
  total?: number;
  bag?: number;
  stash?: number;
  equip?: number;
  level?: number;
  cap?: number;
  bonus?: number;
  invested?: number;
  domainRemaining?: number | null;
  maximum?: number;
  canAdd?: boolean;
  leftHelp?: string;
  rightHelp?: string;
};

type ItemViewEntry = ItemEntry & ItemState;
type LoadoutViewEntry = ItemEntry & LoadoutState;

const MAX_RENDERED_ITEMS_PER_SLOT = 80;

const SKILL_DOMAIN_TITLES: Record<SkillDomainKey, string> = {
  combat: 'Combat',
  wandering: 'Wandering',
  gathering: 'Gathering',
  crafting: 'Crafting',
  misc: 'Misc',
};

const SKILL_DOMAIN_ORDER: SkillDomainKey[] = [
  'combat',
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
  misc: 'Misc',
};

const CATEGORY_ORDER: Record<string, number> = {
  clothing: 0,
  weapon: 1,
  misc: 2,
  other: 3,
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

const getTraitAmount = (data: Data, traitId: string): number => {
  const stateAmount = Number(data.traits_state?.[traitId]?.amount);
  if (Number.isFinite(stateAmount) && stateAmount > 0) {
    return stateAmount;
  }

  const countAmount = Number(data.trait_counts?.[traitId]);
  if (Number.isFinite(countAmount) && countAmount > 0) {
    return countAmount;
  }

  return (data.traits || []).filter((id) => id === traitId).length;
};

const canAddTrait = (data: Data, traitId: string, entry: TraitEntry): boolean => {
  const state = data.traits_state?.[traitId];
  if (typeof state?.can_add === 'boolean') {
    return state.can_add;
  }

  const amount = getTraitAmount(data, traitId);
  const maximum = Number(state?.maximum ?? entry.maximum);
  const repeatable = !!entry.repeatable;

  if (!repeatable && amount > 0) {
    return false;
  }

  if (Number.isFinite(maximum) && maximum >= 0 && amount >= maximum) {
    return false;
  }

  return data.points_traits_remaining >= (Number(entry.cost) || 0);
};

type LoadoutDollSlot = {
  id: string;
  label: string;
  shortLabel?: string;
  top: string;
  left: string;
  width: string;
  height: string;
};

const LOADOUT_DOLL_SLOTS: LoadoutDollSlot[] = [
  { id: 'mask', label: 'Mask', shortLabel: 'Mask', top: '16px', left: '24px', width: '88px', height: '88px' },
  { id: 'head', label: 'Head', shortLabel: 'Head', top: '16px', left: '144px', width: '88px', height: '88px' },
  { id: 'mouth', label: 'Mouth', shortLabel: 'Mouth', top: '16px', left: '264px', width: '88px', height: '88px' },
  { id: 'shoulder_r', label: 'Right Shoulder', shortLabel: 'R Sh', top: '114px', left: '24px', width: '88px', height: '88px' },
  { id: 'cloak', label: 'Cloak', shortLabel: 'Cloak', top: '114px', left: '144px', width: '88px', height: '88px' },
  { id: 'shoulder_l', label: 'Left Shoulder', shortLabel: 'L Sh', top: '114px', left: '264px', width: '88px', height: '88px' },
  { id: 'neck', label: 'Neck', shortLabel: 'Neck', top: '212px', left: '24px', width: '88px', height: '88px' },
  { id: 'armor', label: 'Armor', shortLabel: 'Armor', top: '212px', left: '144px', width: '88px', height: '88px' },
  { id: 'wrists', label: 'Wrists', shortLabel: 'Wrst', top: '212px', left: '264px', width: '88px', height: '88px' },
  { id: 'ring', label: 'Ring', shortLabel: 'Ring', top: '310px', left: '24px', width: '88px', height: '88px' },
  { id: 'suit', label: 'Suit', shortLabel: 'Suit', top: '310px', left: '144px', width: '88px', height: '88px' },
  { id: 'gloves', label: 'Gloves', shortLabel: 'Glv', top: '310px', left: '264px', width: '88px', height: '88px' },
  { id: 'belt_r', label: 'Right Belt Pocket', shortLabel: 'R Belt', top: '408px', left: '24px', width: '88px', height: '88px' },
  { id: 'belt', label: 'Belt', shortLabel: 'Belt', top: '408px', left: '144px', width: '88px', height: '88px' },
  { id: 'belt_l', label: 'Left Belt Pocket', shortLabel: 'L Belt', top: '408px', left: '264px', width: '88px', height: '88px' },
  { id: 'hand_r', label: 'Right Hand', shortLabel: 'R Hand', top: '506px', left: '24px', width: '88px', height: '88px' },
  { id: 'legs', label: 'Legs', shortLabel: 'Legs', top: '506px', left: '144px', width: '88px', height: '88px' },
  { id: 'hand_l', label: 'Left Hand', shortLabel: 'L Hand', top: '506px', left: '264px', width: '88px', height: '88px' },
  { id: 'boots', label: 'Boots', shortLabel: 'Boots', top: '604px', left: '144px', width: '88px', height: '88px' },
];

const getLoadoutValidSlots = (entry?: LoadoutViewEntry): string[] => {
  if (!Array.isArray(entry?.valid_slots)) {
    return [];
  }
  return entry.valid_slots.map((slot) => String(slot));
};

const entryCanUseLoadoutSlot = (entry: LoadoutViewEntry, slotId: string): boolean =>
  getLoadoutValidSlots(entry).includes(slotId);

const entryIsAssignedToLoadoutSlot = (entry: LoadoutViewEntry, slotId: string): boolean =>
  !!entry.slots?.[slotId];

const getAssignedEntryForLoadoutSlot = (
  entries: Array<[string, LoadoutViewEntry]>,
  slotId: string
): [string, LoadoutViewEntry] | null => {
  return entries.find(([, entry]) => entryIsAssignedToLoadoutSlot(entry, slotId)) || null;
};

const getLoadoutSlotCounts = (
  entries: Array<[string, LoadoutViewEntry]>,
  slot: LoadoutDollSlot
) => {
  return entries.reduce(
    (acc, [, entry]) => {
      if (!entryCanUseLoadoutSlot(entry, slot.id)) {
        return acc;
      }
      acc.total += Number(entry.amount) || 0;
      if (entryIsAssignedToLoadoutSlot(entry, slot.id)) {
        acc.equip += 1;
      }
      acc.bag += Number(entry.bag) || 0;
      acc.stash += Number(entry.stash) || 0;
      return acc;
    },
    { total: 0, equip: 0, bag: 0, stash: 0 }
  );
};

const getLoadoutSlotLabel = (slotId: string): string => {
  const slot = LOADOUT_DOLL_SLOTS.find((entry) => entry.id === slotId);
  return slot?.shortLabel || slot?.label || slotId;
};

const getLoadoutSourceText = (entry: LoadoutViewEntry): string => {
  const sources = entry.sources || {};
  const parts: string[] = [];
  if (sources.tat) {
    parts.push(`TAT ${sources.tat}`);
  }
  if (sources.trait) {
    parts.push(`Trait ${sources.trait}`);
  }
  if (sources.donor_loadout) {
    parts.push(`Donor`);
  }
  return parts.join(' · ');
};

const getLoadoutPaintText = (entry: LoadoutViewEntry): string => {
  const paint = entry.paint;
  if (!paint) {
    return '';
  }
  const parts: string[] = [];
  if (paint.primary) {
    parts.push(`P ${paint.primary}`);
  }
  if (paint.detail) {
    parts.push(`D ${paint.detail}`);
  }
  if (paint.altdetail) {
    parts.push(`A ${paint.altdetail}`);
  }
  return parts.join(' · ');
};

const groupEntriesByCategoryAndSlot = <
  T extends { slot_group?: string | null; category?: string | null; name?: string },
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
        lineHeight: 0,
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
            display: 'block',
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
        left: '50%',
        top: '72px',
        transform: 'translateX(-50%)',
        width: '720px',
        maxWidth: 'calc(100vw - 48px)',
        padding: '10px 12px',
        borderRadius: '8px',
        background: 'rgba(10, 12, 22, 0.96)',
        border: '1px solid rgba(255,255,255,0.08)',
        boxShadow: '0 8px 20px rgba(0,0,0,0.45)',
        zIndex: 1000,
        pointerEvents: 'none',
      }}>
      <Stack>
        <Stack.Item grow basis="55%">
          <Box bold style={{ fontSize: '15px', marginBottom: '6px', color: '#f0c35a' }}>
            {data.name}
          </Box>

          {!!data.desc && (
            <Box mb={0.75} style={{ opacity: 0.9, lineHeight: 1.35, whiteSpace: 'pre-line' }}>
              {data.desc}
            </Box>
          )}

          {!!data.slot && (
            <Box style={{ opacity: 0.9 }}>
              <b>Slot:</b> {data.slot}
            </Box>
          )}

          {!!data.category && (
            <Box style={{ opacity: 0.9 }}>
              <b>Type:</b> {data.category}
            </Box>
          )}

          {typeof data.level === 'number' && (
            <Box style={{ opacity: 0.9 }}>
              <b>Level:</b> {data.level} / {data.cap}
            </Box>
          )}

          {typeof data.bonus === 'number' && data.bonus > 0 && (
            <Box style={{ color: '#9fd6a8' }}>
              <b>Bonus:</b> +{data.bonus}
            </Box>
          )}
        </Stack.Item>

        <Stack.Item grow basis="45%">
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

          {typeof data.maximum === 'number' && data.maximum >= 0 && (
            <Box style={{ opacity: 0.9 }}>
              <b>Maximum:</b> {data.maximum}
            </Box>
          )}

          {typeof data.canAdd === 'boolean' && (
            <Box style={{ color: data.canAdd ? '#9fd6a8' : '#e8a0a0' }}>
              <b>Can add:</b> {data.canAdd ? 'Yes' : 'No'}
            </Box>
          )}

          {typeof data.bag === 'number' && typeof data.equip === 'number' && (
            <Box style={{ opacity: 0.9 }}>
              <b>Bag:</b> {data.bag} | <b>Stash:</b> {data.stash || 0} | <b>Equip:</b>{' '}
              {data.equip}
            </Box>
          )}

          {typeof data.invested === 'number' && (
            <Box style={{ opacity: 0.9 }}>
              <b>Invested:</b> {data.invested}
            </Box>
          )}

          {typeof data.domainRemaining === 'number' && (
            <Box style={{ opacity: 0.9 }}>
              <b>Free:</b> {data.domainRemaining}
            </Box>
          )}

          {!!data.leftHelp && (
            <Box mt={0.75} style={{ color: '#f0c35a' }}>
              {data.leftHelp}
            </Box>
          )}

          {!!data.rightHelp && (
            <Box style={{ color: '#d7d7d7' }}>
              {data.rightHelp}
            </Box>
          )}
        </Stack.Item>
      </Stack>
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
  disabled,
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
  disabled?: boolean;
}) => {
  return (
    <Box style={{ margin: '2px' }}>
      <div
        onClick={() => {
          if (!disabled) {
            onLeftClick();
          }
        }}
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
          background: disabled ? 'rgba(80,80,80,0.08)' : 'rgba(255,255,255,0.03)',
          border: disabled
            ? '1px solid rgba(255,255,255,0.04)'
            : '1px solid rgba(255,255,255,0.08)',
          boxShadow: glow ? `inset 0 0 0 1px ${glow}` : 'none',
          cursor: disabled ? 'not-allowed' : 'pointer',
          userSelect: 'none',
          overflow: 'hidden',
          opacity: disabled ? 0.55 : 1,
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

const SectionTitleWithMeta = ({
  title,
  meta,
}: {
  title: string;
  meta?: ReactNode;
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

const SlotCards = ({ slots, act }: { slots: TatSlotEntry[]; act: BackendAct }) => {
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
            const summary = slot.summary || { stats: 0, skills: 0, traits: 0, items: 0 };

            return (
              <Stack.Item key={slot.id} grow basis="31%" style={{ minWidth: '220px', maxWidth: '32%' }}>
                <Box
                  style={{
                    minHeight: '98px',
                    padding: '6px',
                    borderRadius: '6px',
                    background: slot.active ? 'rgba(120, 180, 120, 0.08)' : 'rgba(255,255,255,0.02)',
                    border: slot.active ? '1px solid rgba(120, 180, 120, 0.45)' : '1px solid rgba(255,255,255,0.08)',
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
                        setRenameDrafts((prev) => ({ ...prev, [slot.id]: String(value) }))
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
                            name: String(renameDrafts[slot.id] ?? slot.name ?? `Slot ${slot.id}`).trim(),
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

const JsonExchangePanel = ({
  act,
  buildJson,
  lastJsonError,
  lastJsonNotice,
}: {
  act: BackendAct;
  buildJson?: string | null;
  lastJsonError?: string | null;
  lastJsonNotice?: string | null;
}) => {
  const [jsonDraft, setJsonDraft] = useState('');

  useEffect(() => {
    if (typeof buildJson === 'string' && buildJson.length > 0) {
      setJsonDraft(buildJson);
    }
  }, [buildJson]);

  return (
    <Section
      title="JSON Exchange"
      buttons={
        <Stack>
          <Stack.Item>
            <Button onClick={() => act('export_json')}>Export current build</Button>
          </Stack.Item>
          <Stack.Item>
            <Button color="good" disabled={!jsonDraft.trim()} onClick={() => act('import_json', { json: jsonDraft })}>
              Import from text
            </Button>
          </Stack.Item>
        </Stack>
      }>
      {!!lastJsonNotice && <NoticeBox color="good">{lastJsonNotice}</NoticeBox>}
      {!!lastJsonError && <NoticeBox color="bad">{lastJsonError}</NoticeBox>}

      <Box mb={0.75} style={{ opacity: 0.85 }}>
        Export creates a portable JSON build. Import rebuilds the current build through backend
        validation, so invalid or outdated entries should be sanitized by the server.
      </Box>

      <TextArea
        fluid
        height="180px"
        value={jsonDraft}
        placeholder="Paste exported TAT build JSON here, or press Export current build."
        onChange={(value) => setJsonDraft(String(value))}
      />

      <Stack mt={0.75} justify="space-between">
        <Stack.Item>
          <Button disabled={!jsonDraft} onClick={() => setJsonDraft('')}>
            Clear JSON
          </Button>
        </Stack.Item>
        <Stack.Item>
          <Box style={{ opacity: 0.75, fontSize: '11px' }}>Length: {jsonDraft.length} chars</Box>
        </Stack.Item>
      </Stack>
    </Section>
  );
};

const ControlTab = ({
  slots,
  act,
  buildJson,
  lastJsonError,
  lastJsonNotice,
}: {
  slots: TatSlotEntry[];
  act: BackendAct;
  buildJson?: string | null;
  lastJsonError?: string | null;
  lastJsonNotice?: string | null;
}) => {
  return (
    <Stack vertical>
      <SlotCards slots={slots} act={act} />
      <JsonExchangePanel
        act={act}
        buildJson={buildJson}
        lastJsonError={lastJsonError}
        lastJsonNotice={lastJsonNotice}
      />
    </Stack>
  );
};

const StatsTab = ({ data, act, search }: { data: Data; act: BackendAct; search: string }) => {
  const rows = useMemo(
    () =>
      Object.entries(data.available_stats || {}).filter(([statId, entry]) =>
        matchesSearch(search, entry.name, statId)
      ),
    [data.available_stats, search]
  );

  return (
    <Section title={<SectionTitleWithMeta title="Stats" meta={`Free: ${data.points_stats_remaining} / ${data.points_stats}`} />}>
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
                disabledAdd={value >= entry.max || data.points_stats_remaining < entry.cost}
                disabledRemove={value <= 1}
                extra={<Box>Base: {entry.base} | Refund floor: {entry.min} | Max: {entry.max} | Cost per step: {entry.cost}</Box>}
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
  setHoveredItem,
}: {
  skillPath: string;
  entry: SkillEntry;
  state?: SkillState;
  act: BackendAct;
  domainRemaining: number | null;
  setHoveredItem: (value: HoverCardData | null) => void;
}) => {
  const totalLevel = Number(state?.level) || 0;
  const invested = Number(state?.invested) || 0;
  const cap = Number(state?.cap) || 0;
  const nextCost = Number(state?.next_cost) || 0;
  const bonus = Number(state?.bonus) || 0;
  const displayValue = formatSkillDisplayValue(state);

  const disableRemove = invested <= 0;
  const disableAdd = totalLevel >= cap || nextCost <= 0 || (domainRemaining !== null && domainRemaining < nextCost);

  return (
    <div
      onMouseEnter={() =>
        setHoveredItem({
          name: entry.name || skillPath,
          desc: entry.desc,
          category: entry.category,
          level: totalLevel,
          cap,
          costText: `${nextCost} pts`,
          bonus,
          invested,
          domainRemaining,
          leftHelp: 'Press + to increase',
          rightHelp: 'Press - to refund',
        })
      }
      onMouseLeave={() => setHoveredItem(null)}>
      <Stack
        align="center"
        justify="space-between"
        style={{ padding: '4px 0', borderBottom: '1px solid rgba(255,255,255,0.05)', minHeight: '34px' }}>
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
              <Button compact onClick={() => act('remove_skill', { path: skillPath, amount: 1 })} disabled={disableRemove}>
                -
              </Button>
            </Stack.Item>
            <Stack.Item>
              <Box width="56px" textAlign="center" bold style={{ fontSize: '13px' }}>
                {displayValue}
              </Box>
            </Stack.Item>
            <Stack.Item>
              <Button compact onClick={() => act('add_skill', { path: skillPath, amount: 1 })} disabled={disableAdd}>
                +
              </Button>
            </Stack.Item>
          </Stack>
        </Stack.Item>
      </Stack>
    </div>
  );
};

const SkillDomainTitle = ({
  domain,
  data,
  act,
}: {
  domain: SkillDomainKey;
  data: Data;
  act: BackendAct;
}) => {
  const domainState = data.skill_conversion_state?.[domain];
  const pool = Number(data.skill_conversion_pool) || 0;
  const remaining = getDomainRemainingPoints(data, domain) || 0;
  const canGive = typeof domainState?.can_give === 'boolean' ? domainState.can_give : remaining > 0;
  const canTake =
    typeof domainState?.can_take === 'boolean'
      ? domainState.can_take
      : domain !== 'combat' && pool > 0;

  return (
    <Stack align="center" justify="space-between">
      <Stack.Item>
        <Box bold>{SKILL_DOMAIN_TITLES[domain]}</Box>
      </Stack.Item>
      <Stack.Item>
        <Stack align="center">
          <Stack.Item>
            <Box style={{ opacity: 0.8, fontSize: '12px' }}>
              {formatDomainPoints(data, domain)}
            </Box>
          </Stack.Item>
          <Stack.Item>
            <Button
              compact
              tooltip={domainState?.give_text || 'Give 1 free point from this domain to conversion pool'}
              disabled={!canGive}
              onClick={() => act('give_skill_domain_points', { domain })}>
              -
            </Button>
          </Stack.Item>
          {domain !== 'combat' && (
            <Stack.Item>
              <Button
                compact
                tooltip={domainState?.take_text || 'Take 1 point from conversion pool into this domain'}
                disabled={!canTake}
                onClick={() => act('take_skill_domain_points', { domain })}>
                +
              </Button>
            </Stack.Item>
          )}
        </Stack>
      </Stack.Item>
    </Stack>
  );
};

const SkillsDomainPanel = ({
  domain,
  rows,
  data,
  act,
  setHoveredItem,
}: {
  domain: SkillDomainKey;
  rows: Array<[string, SkillEntry]>;
  data: Data;
  act: BackendAct;
  setHoveredItem: (value: HoverCardData | null) => void;
}) => {
  const domainRemaining = getDomainRemainingPoints(data, domain);

  return (
    <Stack.Item grow basis="32%" style={{ minWidth: '270px' }}>
      <Section
        title={<SkillDomainTitle domain={domain} data={data} act={act} />}
        fill
        style={{ height: '320px' }}>
        {!rows.length ? (
          <NoticeBox>No skills in this group.</NoticeBox>
        ) : (
          <Box style={{ maxHeight: '260px', overflowY: 'auto', paddingRight: '4px' }}>
            {rows.map(([skillPath, entry]) => (
              <SkillRow
                key={skillPath}
                skillPath={skillPath}
                entry={entry}
                state={data.skills?.[skillPath]}
                act={act}
                domainRemaining={domainRemaining}
                setHoveredItem={setHoveredItem}
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
  setHoveredItem,
}: {
  data: Data;
  act: BackendAct;
  search: string;
  setHoveredItem: (value: HoverCardData | null) => void;
}) => {
  const groups = useMemo(() => {
    const byDomain: Record<SkillDomainKey, Array<[string, SkillEntry]>> = {
      combat: [],
      wandering: [],
      gathering: [],
      crafting: [],
      misc: [],
    };

    Object.entries(data.available_skills || {}).forEach(([skillPath, entry]) => {
      if (!matchesSearch(search, skillPath, entry.name, entry.desc, entry.category, entry.is_combat ? 'combat' : 'non-combat')) {
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
    <Section
      title={
        <SectionTitleWithMeta
          title="Skills"
          meta={`Conversion pool: ${Number(data.skill_conversion_pool) || 0}`}
        />
      }>
      {!hasAny ? (
        <NoticeBox>No matches found.</NoticeBox>
      ) : (
        <Stack wrap align="stretch">
          {SKILL_DOMAIN_ORDER.map((domain) => (
            <SkillsDomainPanel key={domain} domain={domain} rows={groups[domain]} data={data} act={act} setHoveredItem={setHoveredItem} />
          ))}
        </Stack>
      )}
    </Section>
  );
};

const TraitPill = ({
  title,
  cost,
  amount,
  repeatable,
  selected,
  disabledAdd,
  disabledRemove,
  onAdd,
  onRemove,
  onHoverStart,
  onHoverEnd,
}: {
  title: string;
  cost: number;
  amount?: number;
  repeatable?: boolean;
  selected?: boolean;
  disabledAdd?: boolean;
  disabledRemove?: boolean;
  onAdd: () => void;
  onRemove: () => void;
  onHoverStart?: () => void;
  onHoverEnd?: () => void;
}) => {
  const countText = repeatable && amount && amount > 0 ? ` x${amount}` : '';
  const fullyDisabled = !!disabledAdd && !!disabledRemove;

  return (
    <div
      onContextMenu={(event) => {
        event.preventDefault();
        event.stopPropagation();
        if (!disabledRemove) {
          onRemove();
        }
      }}
      onMouseEnter={onHoverStart}
      onMouseLeave={onHoverEnd}
      style={{ display: 'inline-block' }}>
      <Button
        selected={selected}
        color={selected ? 'good' : undefined}
        disabled={fullyDisabled}
        onClick={() => {
          if (!disabledAdd) {
            onAdd();
          }
        }}>
        {title}{countText} ({cost})
      </Button>
    </div>
  );
};

const TraitsTab = ({
  data,
  act,
  search,
  setHoveredItem,
}: {
  data: Data;
  act: BackendAct;
  search: string;
  setHoveredItem: (value: HoverCardData | null) => void;
}) => {
  const grouped = useMemo(() => {
    const groups: Record<string, { categoryName: string; available: Array<[string, TraitEntry]>; selected: Array<[string, TraitEntry]> }> = {};

    Object.entries(data.available_traits || {})
      .filter(([traitId, entry]) => matchesSearch(search, traitId, entry.name, entry.desc, entry.category, entry.category_name))
      .forEach(([traitId, entry]) => {
        const category = entry.category || 'other';
        const categoryName = entry.category_name || 'Other';
        if (!groups[category]) {
          groups[category] = { categoryName, available: [], selected: [] };
        }
        if (getTraitAmount(data, traitId) > 0) {
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
  }, [data, search]);

  const buildTraitHover = (traitId: string, entry: TraitEntry): HoverCardData => {
    const amount = getTraitAmount(data, traitId);
    const canAdd = canAddTrait(data, traitId, entry);
    return {
      name: entry.name || traitId,
      desc: entry.desc,
      category: entry.category_name || entry.category,
      costText: `${entry.cost || 0} pts`,
      total: amount,
      canAdd,
      leftHelp: canAdd ? 'LMB: add trait / increase stack' : 'Cannot add more',
      rightHelp: amount > 0 ? 'RMB: remove trait / decrease stack' : 'RMB: nothing to remove',
    };
  };

  return (
    <Section title={<SectionTitleWithMeta title="Traits" meta={`Free: ${data.points_traits_remaining} / ${data.points_traits}`} />}>
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
                  {group.available.map(([traitId, entry]) => {
                    const amount = getTraitAmount(data, traitId);
                    const canAdd = canAddTrait(data, traitId, entry);
                    return (
                      <Stack.Item key={traitId}>
                        <TraitPill
                          title={entry.name || traitId}
                          cost={entry.cost || 0}
                          amount={amount}
                          repeatable={!!entry.repeatable}
                          disabledAdd={!canAdd}
                          disabledRemove={amount <= 0}
                          onAdd={() => act('add_trait', { id: traitId, amount: 1 })}
                          onRemove={() => act('remove_trait', { id: traitId, amount: 1 })}
                          onHoverStart={() => setHoveredItem(buildTraitHover(traitId, entry))}
                          onHoverEnd={() => setHoveredItem(null)}
                        />
                      </Stack.Item>
                    );
                  })}
                </Stack>
              ) : (
                <NoticeBox>No available traits in this group.</NoticeBox>
              )}

              <Box bold mt={1} mb={0.5}>Selected</Box>
              {group.selected.length ? (
                <Stack wrap>
                  {group.selected.map(([traitId, entry]) => {
                    const amount = getTraitAmount(data, traitId);
                    const canAdd = canAddTrait(data, traitId, entry);
                    return (
                      <Stack.Item key={traitId}>
                        <TraitPill
                          title={entry.name || traitId}
                          cost={entry.cost || 0}
                          amount={amount}
                          repeatable={!!entry.repeatable}
                          selected
                          disabledAdd={!canAdd}
                          disabledRemove={amount <= 0}
                          onAdd={() => act('add_trait', { id: traitId, amount: 1 })}
                          onRemove={() => act('remove_trait', { id: traitId, amount: 1 })}
                          onHoverStart={() => setHoveredItem(buildTraitHover(traitId, entry))}
                          onHoverEnd={() => setHoveredItem(null)}
                        />
                      </Stack.Item>
                    );
                  })}
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
  itemsAvailable,
  data,
}: {
  itemEntries: Record<string, ItemViewEntry>;
  act: BackendAct;
  search: string;
  setHoveredItem: (value: HoverCardData | null) => void;
  itemsAvailable: boolean;
  data: Data;
}) => {
  const groups = useMemo(() => {
    return groupEntriesByCategoryAndSlot(
      itemEntries || {},
      (itemPath, entry) =>
        !!entry.unlocked && matchesSearch(search, itemPath, entry.name, entry.category, entry.slot_group, entry.unlock_type, entry.unlock_key)
    );
  }, [itemEntries, search]);

  return (
    <Section title={<SectionTitleWithMeta title="Items" meta={`Free: ${data.points_items_remaining} / ${data.points_items}`} />}>
      {!itemsAvailable ? (
        <NoticeBox>Loading items...</NoticeBox>
      ) : !groups.length ? (
        <NoticeBox>No matches found.</NoticeBox>
      ) : (
        <Stack vertical>
          {groups.map(([categoryKey, slotGroups]) => (
            <Box key={categoryKey} mb={2}>
              <Box bold mb={1} style={{ fontSize: '16px', letterSpacing: '0.5px', color: '#f0c35a' }}>
                {getCategoryLabel(categoryKey)}
              </Box>

              {slotGroups.map(([slotKey, items]) => {
                const visibleItems = items.slice(0, MAX_RENDERED_ITEMS_PER_SLOT);
                return (
                  <Box key={`${categoryKey}-${slotKey}`} mb={1}>
                    <Box bold mb={0.5} style={{ fontSize: '14px', letterSpacing: '0.5px', opacity: 0.9 }}>
                      {getSlotLabel(slotKey)}
                    </Box>

                    <Stack wrap>
                      {visibleItems.map(([itemPath, entry]) => {
                        const canAdd = entry.can_add !== false;
                        const maximum = Number(entry.maximum);
                        const amount = Number(entry.amount) || 0;
                        return (
                          <ItemTile
                            key={itemPath}
                            name={entry.name || itemPath}
                            topRightText={`${entry.cost || 0} pts`}
                            bottomLeftText={amount > 0 ? amount : undefined}
                            bottomRightText={!canAdd ? 'MAX' : undefined}
                            icon={entry.icon}
                            disabled={!canAdd}
                            onLeftClick={() => act('add_item', { path: itemPath, amount: 1 })}
                            onRightClick={() => act('remove_item', { path: itemPath, amount: 1 })}
                            onHoverStart={() =>
                              setHoveredItem({
                                name: entry.name || itemPath,
                                slot: getSlotLabel(entry.slot_group),
                                category: getCategoryLabel(entry.category),
                                costText: `${entry.cost || 0} pts`,
                                total: amount,
                                maximum: Number.isFinite(maximum) ? maximum : undefined,
                                canAdd,
                                leftHelp: canAdd ? 'LMB: add item' : 'Cannot add more',
                                rightHelp: 'RMB: remove item',
                              })
                            }
                            onHoverEnd={() => setHoveredItem(null)}
                          />
                        );
                      })}
                    </Stack>

                    {items.length > MAX_RENDERED_ITEMS_PER_SLOT && (
                      <NoticeBox>Showing first {MAX_RENDERED_ITEMS_PER_SLOT} items. Use search to narrow results.</NoticeBox>
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
  const [selectedSlotId, setSelectedSlotId] = useState<string>(LOADOUT_DOLL_SLOTS[0].id);
  const [chooserOpen, setChooserOpen] = useState<boolean>(false);

  const visibleEntries = useMemo(
    () =>
      Object.entries(loadoutEntries || {}).filter(([itemPath, entry]) =>
        matchesSearch(search, itemPath, entry.name, entry.category, entry.slot_group)
      ),
    [loadoutEntries, search]
  );

  const selectedSlot = LOADOUT_DOLL_SLOTS.find((slot) => slot.id === selectedSlotId) || LOADOUT_DOLL_SLOTS[0];

  const selectedSlotEntries = useMemo(
    () =>
      visibleEntries
        .filter(([, entry]) => {
          if (!entryCanUseLoadoutSlot(entry, selectedSlot.id)) {
            return false;
          }
          return (Number(entry.bag) || 0) > 0 || entryIsAssignedToLoadoutSlot(entry, selectedSlot.id);
        })
        .sort((a, b) => {
          const assignedA = entryIsAssignedToLoadoutSlot(a[1], selectedSlot.id) ? 1 : 0;
          const assignedB = entryIsAssignedToLoadoutSlot(b[1], selectedSlot.id) ? 1 : 0;
          if (assignedA !== assignedB) {
            return assignedB - assignedA;
          }
          const bagDiff = (Number(b[1].bag) || 0) - (Number(a[1].bag) || 0);
          if (bagDiff !== 0) {
            return bagDiff;
          }
          return (a[1].name || a[0]).localeCompare(b[1].name || b[0]);
        }),
    [visibleEntries, selectedSlot]
  );

  const backpackEntries = useMemo(
    () =>
      visibleEntries
        .filter(([, entry]) => (Number(entry.bag) || 0) > 0)
        .sort((a, b) => (a[1].name || a[0]).localeCompare(b[1].name || b[0])),
    [visibleEntries]
  );

  const stashEntries = useMemo(
    () =>
      visibleEntries
        .filter(([, entry]) => (Number(entry.stash) || 0) > 0)
        .sort((a, b) => (a[1].name || a[0]).localeCompare(b[1].name || b[0])),
    [visibleEntries]
  );

  const hasAnyEntries = visibleEntries.length > 0;
  const selectedAssignedEntry = getAssignedEntryForLoadoutSlot(visibleEntries, selectedSlot.id);

  const openSlotChooser = (slotId: string) => {
    setSelectedSlotId(slotId);
    setChooserOpen(true);
  };

  const buildInventoryHover = (itemPath: string, entry: LoadoutViewEntry, area: 'bag' | 'stash'): HoverCardData => {
    const amount = Number(entry.amount) || 0;
    const bag = Math.max(0, Math.min(Number(entry.bag) || 0, amount));
    const stash = Math.max(0, Math.min(Number(entry.stash) || 0, amount));
    const equip = Math.max(0, Number(entry.equip) || 0);
    const sourceText = getLoadoutSourceText(entry);
    const paintText = getLoadoutPaintText(entry);

    return {
      name: entry.name || itemPath,
      slot: area === 'bag' ? 'Backpack' : 'Stash',
      category: getCategoryLabel(entry.category),
      total: amount,
      bag,
      stash,
      equip,
      desc: [sourceText, paintText].filter(Boolean).join('\n'),
      leftHelp: area === 'bag' ? 'LMB: move to stash' : 'LMB: move to backpack',
      rightHelp: 'RMB: dye / repaint item',
    };
  };

  const renderInventoryRow = (itemPath: string, entry: LoadoutViewEntry, area: 'bag' | 'stash') => {
    const amount = Number(entry.amount) || 0;
    const bag = Math.max(0, Math.min(Number(entry.bag) || 0, amount));
    const stash = Math.max(0, Math.min(Number(entry.stash) || 0, amount));
    const equip = Math.max(0, Number(entry.equip) || 0);
    const validSlotLabels = getLoadoutValidSlots(entry).map(getLoadoutSlotLabel).join(', ');
    const sourceText = getLoadoutSourceText(entry);
    const paintText = getLoadoutPaintText(entry);
    const count = area === 'bag' ? bag : stash;

    return (
      <div
        key={`${area}-${itemPath}`}
        onClick={() =>
          act(area === 'bag' ? 'move_item_to_stash' : 'move_item_to_bag', { path: itemPath, amount: 1 })
        }
        onContextMenu={(event) => {
          event.preventDefault();
          event.stopPropagation();
          act('paint_loadout_item', { path: itemPath });
        }}
        onMouseEnter={() => setHoveredItem(buildInventoryHover(itemPath, entry, area))}
        onMouseLeave={() => setHoveredItem(null)}
        style={{
          display: 'flex',
          alignItems: 'center',
          minHeight: '82px',
          gap: '10px',
          padding: '6px 8px',
          marginBottom: '8px',
          borderRadius: '6px',
          background: area === 'bag' ? 'rgba(80,110,170,0.12)' : 'rgba(150,120,70,0.12)',
          border: area === 'bag' ? '1px solid rgba(130,160,220,0.4)' : '1px solid rgba(220,180,110,0.35)',
          cursor: 'pointer',
          userSelect: 'none',
        }}>
        <div style={{ width: '68px', height: '68px', flex: '0 0 68px', display: 'flex', alignItems: 'center', justifyContent: 'center', overflow: 'hidden' }}>
          <TileIcon icon={entry.icon} name={entry.name || itemPath} />
        </div>

        <div style={{ flex: 1, minWidth: 0 }}>
          <div style={{ fontWeight: 700, fontSize: '13px' }}>{entry.name || itemPath}</div>
          <div style={{ fontSize: '11px', opacity: 0.78 }}>
            Bag {bag} · Stash {stash} · Equip {equip} · Total {amount}
          </div>
          {!!validSlotLabels && <div style={{ fontSize: '10px', opacity: 0.62 }}>Slots: {validSlotLabels}</div>}
          {!!sourceText && <div style={{ fontSize: '10px', opacity: 0.7 }}>{sourceText}</div>}
          {!!paintText && <div style={{ fontSize: '10px', opacity: 0.72 }}>Paint: {paintText}</div>}
        </div>

        <div style={{ textAlign: 'right', fontSize: '11px', lineHeight: 1.35, opacity: 0.9, minWidth: '84px' }}>
          <div>{count} here</div>
          <div>{area === 'bag' ? 'LMB: stash' : 'LMB: bag'}</div>
          <div>RMB: dye</div>
        </div>
      </div>
    );
  };

  return (
    <Section title="Loadout">
      {!hasAnyEntries ? (
        <NoticeBox>No matches found.</NoticeBox>
      ) : (
        <div style={{ display: 'flex', alignItems: 'stretch', gap: '10px', flexWrap: 'nowrap' }}>
          <div style={{ flex: '0 0 414px', minWidth: '414px' }}>
            <Section title={<SectionTitleWithMeta title="Paper Doll" meta="LMB slot: choose · RMB equipped item: dye" />}>
              <Box
                style={{
                  position: 'relative',
                  width: '376px',
                  height: '708px',
                  margin: '0 auto',
                  borderRadius: '10px',
                  background: 'linear-gradient(180deg, rgba(255,255,255,0.025), rgba(255,255,255,0.01))',
                  border: '1px solid rgba(255,255,255,0.08)',
                  overflow: 'hidden',
                }}>
                {LOADOUT_DOLL_SLOTS.map((slot) => {
                  const counts = getLoadoutSlotCounts(visibleEntries, slot);
                  const isSelected = selectedSlot.id === slot.id;
                  const assigned = getAssignedEntryForLoadoutSlot(visibleEntries, slot.id);
                  const hasCompatible = counts.total > 0;
                  const hasEquipped = !!assigned;

                  return (
                    <div
                      key={slot.id}
                      onClick={() => openSlotChooser(slot.id)}
                      onContextMenu={(event) => {
                        event.preventDefault();
                        event.stopPropagation();
                        setSelectedSlotId(slot.id);
                        if (assigned) {
                          act('paint_loadout_item', { path: assigned[0] });
                        }
                      }}
                      onMouseEnter={() => {
                        if (assigned) {
                          setHoveredItem({
                            name: assigned[1].name || assigned[0],
                            slot: slot.label,
                            category: getCategoryLabel(assigned[1].category),
                            total: Number(assigned[1].amount) || 0,
                            bag: Number(assigned[1].bag) || 0,
                            stash: Number(assigned[1].stash) || 0,
                            equip: Number(assigned[1].equip) || 0,
                            desc: [getLoadoutSourceText(assigned[1]), getLoadoutPaintText(assigned[1])].filter(Boolean).join('\n'),
                            leftHelp: `LMB: choose item for ${slot.label}`,
                            rightHelp: 'RMB: dye / repaint equipped item',
                          });
                        } else {
                          setHoveredItem({
                            name: slot.label,
                            slot: slot.label,
                            category: 'Loadout slot',
                            total: counts.total,
                            bag: counts.bag,
                            stash: counts.stash,
                            equip: counts.equip,
                            leftHelp: `LMB: choose item for ${slot.label}`,
                          });
                        }
                      }}
                      onMouseLeave={() => setHoveredItem(null)}
                      style={{
                        position: 'absolute',
                        top: slot.top,
                        left: slot.left,
                        width: slot.width,
                        height: slot.height,
                        borderRadius: '6px',
                        border: isSelected
                          ? '1px solid rgba(240,195,90,0.95)'
                          : hasEquipped
                            ? '1px solid rgba(120,200,120,0.65)'
                            : hasCompatible
                              ? '1px solid rgba(130,160,220,0.45)'
                              : '1px solid rgba(255,255,255,0.10)',
                        background: isSelected
                          ? 'rgba(240,195,90,0.16)'
                          : hasEquipped
                            ? 'rgba(80,160,90,0.14)'
                            : hasCompatible
                              ? 'rgba(80,110,170,0.12)'
                              : 'rgba(20,26,38,0.65)',
                        cursor: 'pointer',
                        boxShadow: isSelected ? '0 0 0 1px rgba(240,195,90,0.25)' : 'none',
                        overflow: 'hidden',
                      }}>
                      <div style={{ position: 'absolute', inset: '0', display: 'flex', alignItems: 'center', justifyContent: 'center', pointerEvents: 'none' }}>
                        {assigned ? (
                          <div style={{ width: '72px', height: '72px', display: 'flex', alignItems: 'center', justifyContent: 'center', overflow: 'hidden' }}>
                            <TileIcon icon={assigned[1].icon} name={assigned[1].name || assigned[0]} />
                          </div>
                        ) : (
                          <div style={{ fontSize: '11px', fontWeight: 700, opacity: 0.9 }}>{slot.shortLabel || slot.label}</div>
                        )}
                      </div>

                      <div style={{ position: 'absolute', top: '4px', left: '5px', fontSize: '10px', fontWeight: 700, textShadow: '0 1px 2px rgba(0,0,0,0.95)', pointerEvents: 'none' }}>
                        {slot.shortLabel || slot.label}
                      </div>

                      {hasCompatible && (
                        <div style={{ position: 'absolute', right: '5px', bottom: '3px', fontSize: '10px', fontWeight: 700, color: hasEquipped ? '#9fd6a8' : '#d9d9d9', textShadow: '0 1px 2px rgba(0,0,0,0.95)', pointerEvents: 'none' }}>
                          {hasEquipped ? 'EQ' : counts.total}
                        </div>
                      )}
                    </div>
                  );
                })}

                {chooserOpen && (
                  <div
                    style={{
                      position: 'absolute',
                      inset: '10px',
                      zIndex: 3,
                      borderRadius: '10px',
                      background: 'rgba(8,12,18,0.96)',
                      border: '1px solid rgba(240,195,90,0.35)',
                      boxShadow: '0 8px 22px rgba(0,0,0,0.45)',
                      padding: '10px',
                      display: 'flex',
                      flexDirection: 'column',
                    }}>
                    <Stack align="center" justify="space-between">
                      <Stack.Item>
                        <Box bold>{selectedSlot.label}</Box>
                        <Box style={{ opacity: 0.72, fontSize: '11px' }}>{selectedSlotEntries.length} compatible bag item(s)</Box>
                      </Stack.Item>
                      <Stack.Item>
                        <Stack>
                          {!!selectedAssignedEntry && (
                            <Stack.Item>
                              <Button compact onClick={() => act('clear_loadout_slot', { slot_id: selectedSlot.id })}>
                                Clear slot
                              </Button>
                            </Stack.Item>
                          )}
                          <Stack.Item>
                            <Button compact onClick={() => setChooserOpen(false)}>Close</Button>
                          </Stack.Item>
                        </Stack>
                      </Stack.Item>
                    </Stack>

                    {!selectedSlotEntries.length ? (
                      <NoticeBox mt={1}>No backpack items can be equipped into this slot.</NoticeBox>
                    ) : (
                      <Box mt={1} style={{ flex: 1, overflowY: 'auto', display: 'flex', flexWrap: 'wrap', alignContent: 'flex-start', justifyContent: 'center' }}>
                        {selectedSlotEntries.slice(0, MAX_RENDERED_ITEMS_PER_SLOT).map(([itemPath, entry]) => {
                          const assigned = entryIsAssignedToLoadoutSlot(entry, selectedSlot.id);
                          const bag = Number(entry.bag) || 0;
                          const equip = Number(entry.equip) || 0;
                          return (
                            <ItemTile
                              key={`chooser-${selectedSlot.id}-${itemPath}`}
                              name={entry.name || itemPath}
                              icon={entry.icon}
                              topRightText={assigned ? 'EQ' : bag > 0 ? `B${bag}` : ''}
                              bottomLeftText={equip > 0 ? `E${equip}` : ''}
                              bottomRightText={assigned ? selectedSlot.shortLabel || 'SET' : ''}
                              glow={assigned ? 'rgba(120,200,120,0.65)' : 'rgba(130,160,220,0.35)'}
                              disabled={!assigned && bag <= 0}
                              onLeftClick={() => {
                                if (bag > 0 || assigned) {
                                  act('assign_item_to_loadout_slot', { path: itemPath, slot_id: selectedSlot.id });
                                  setChooserOpen(false);
                                }
                              }}
                              onRightClick={() => act('paint_loadout_item', { path: itemPath })}
                              onHoverStart={() =>
                                setHoveredItem({
                                  name: entry.name || itemPath,
                                  slot: selectedSlot.label,
                                  category: getCategoryLabel(entry.category),
                                  total: Number(entry.amount) || 0,
                                  bag,
                                  stash: Number(entry.stash) || 0,
                                  equip,
                                  desc: [getLoadoutSourceText(entry), getLoadoutPaintText(entry)].filter(Boolean).join('\n'),
                                  leftHelp: bag > 0 ? `LMB: equip to ${selectedSlot.label}` : 'No copy in backpack',
                                  rightHelp: 'RMB: dye / repaint item',
                                })
                              }
                              onHoverEnd={() => setHoveredItem(null)}
                            />
                          );
                        })}
                      </Box>
                    )}

                    <Box mt={0.5} style={{ opacity: 0.76, fontSize: '11px' }}>
                      LMB item: equip from backpack. Clear slot: moves equipped item back to backpack. RMB item: dye.
                    </Box>
                  </div>
                )}
              </Box>
            </Section>
          </div>

          <div style={{ flex: '1 1 auto', minWidth: '410px', height: '764px' }}>
            <div style={{ display: 'flex', flexDirection: 'column', gap: '10px', height: '100%' }}>
              <div style={{ flex: '2 1 0', minHeight: 0 }}>
                <Section title={<SectionTitleWithMeta title="Backpack" meta={`${backpackEntries.length} item type(s) · LMB moves to stash`} />} fill>
                  {!backpackEntries.length ? (
                    <NoticeBox>Backpack is empty.</NoticeBox>
                  ) : (
                    <Box style={{ height: '100%', maxHeight: '456px', overflowY: 'auto' }}>
                      {backpackEntries.map(([itemPath, entry]) => renderInventoryRow(itemPath, entry, 'bag'))}
                    </Box>
                  )}
                </Section>
              </div>

              <div style={{ flex: '1 1 0', minHeight: 0 }}>
                <Section title={<SectionTitleWithMeta title="Stash" meta={`${stashEntries.length} item type(s) · LMB moves to backpack`} />} fill>
                  {!stashEntries.length ? (
                    <NoticeBox>Stash is empty.</NoticeBox>
                  ) : (
                    <Box style={{ height: '100%', maxHeight: '218px', overflowY: 'auto' }}>
                      {stashEntries.map(([itemPath, entry]) => renderInventoryRow(itemPath, entry, 'stash'))}
                    </Box>
                  )}
                </Section>
              </div>
            </div>
          </div>
        </div>
      )}
    </Section>
  );
};

export const TATBuild = () => {
  const { act, data } = useBackend<Data>();
  const [tab, setTab] = useState<TabKey>('control');
  const [search, setSearch] = useState('');
  const [hoveredItem, setHoveredItem] = useState<HoverCardData | null>(null);

  const tatSlots = useMemo<TatSlotEntry[]>(() => normalizeTatSlots(data.tat_slots, data.active_tat_slot), [data.tat_slots, data.active_tat_slot]);

  const itemEntries = useMemo<Record<string, ItemViewEntry>>(() => {
    const result: Record<string, ItemViewEntry> = {};
    const staticEntries = data.available_items || {};
    const states = data.items_state || {};

    Object.entries(staticEntries).forEach(([itemPath, entry]) => {
      const state = states[itemPath];
      result[itemPath] = {
        ...entry,
        amount: state?.amount || 0,
        unlocked: !!state?.unlocked,
        maximum: state?.maximum,
        can_add: state?.can_add,
      };
    });

    return result;
  }, [data.available_items, data.items_state]);

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
        stash: state.stash || 0,
        slots: state.slots || {},
        valid_slots: state.valid_slots || [],
        sources: state.sources || {},
        paint: state.paint || null,
        icon: state.icon || entry.icon,
        icon_state: state.icon_state || entry.icon_state,
      };
    });

    return result;
  }, [data.available_items, data.loadout]);

  const itemsAvailable = !!data.available_items && Object.keys(data.available_items).length > 0;
  const searchPlaceholder = tab === 'control' ? 'Search legacy presets...' : `Search in ${tab}...`;

  return (
    <Window title="TAT Build" width={1040} height={900}>
      <Window.Content scrollable>
        <Stack vertical>
          <Section title="Search">
            <Stack align="center">
              <Stack.Item grow>
                <Input fluid placeholder={searchPlaceholder} value={search} onChange={(value) => setSearch(String(value))} />
              </Stack.Item>
              <Stack.Item>
                <Button disabled={!search} onClick={() => setSearch('')}>Clear</Button>
              </Stack.Item>
            </Stack>
          </Section>

          {data.dirty ? <NoticeBox>Build has unsaved changes.</NoticeBox> : <NoticeBox>Build is saved.</NoticeBox>}

          {!data.can_save && (
            <NoticeBox>
              <Box bold mb={0.5}>Current build is invalid:</Box>
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
            buttons={<Box style={{ opacity: 0.8, fontSize: '12px' }}>Save writes current build into the active slot</Box>}>
            <Tabs fluid>
              <Tabs.Tab selected={tab === 'control'} onClick={() => setTab('control')}>Control</Tabs.Tab>
              <Tabs.Tab selected={tab === 'stats'} onClick={() => setTab('stats')}>Stats</Tabs.Tab>
              <Tabs.Tab selected={tab === 'skills'} onClick={() => setTab('skills')}>Skills</Tabs.Tab>
              <Tabs.Tab selected={tab === 'traits'} onClick={() => setTab('traits')}>Traits</Tabs.Tab>
              <Tabs.Tab selected={tab === 'items'} onClick={() => setTab('items')}>Items</Tabs.Tab>
              <Tabs.Tab selected={tab === 'loadout'} onClick={() => setTab('loadout')}>Loadout</Tabs.Tab>
            </Tabs>
          </Section>

          {tab === 'control' && (
            <ControlTab
              slots={tatSlots}
              act={act}
              buildJson={data.build_json}
              lastJsonError={data.last_json_error}
              lastJsonNotice={data.last_json_notice}
            />
          )}
          {tab === 'stats' && <StatsTab data={data} act={act} search={search} />}
          {tab === 'skills' && <SkillsTab data={data} act={act} search={search} setHoveredItem={setHoveredItem} />}
          {tab === 'traits' && <TraitsTab data={data} act={act} search={search} setHoveredItem={setHoveredItem} />}
          {tab === 'items' && (
            <ItemsTab
              itemEntries={itemEntries}
              act={act}
              search={search}
              setHoveredItem={setHoveredItem}
              itemsAvailable={itemsAvailable}
              data={data}
            />
          )}
          {tab === 'loadout' && (
            <LoadoutTab loadoutEntries={loadoutEntries} act={act} search={search} setHoveredItem={setHoveredItem} />
          )}

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
                  <Stack.Item>
                    <Button color="average" onClick={() => act('reset_all')}>Reset All</Button>
                  </Stack.Item>
                  <Stack.Item>
                    <Button color="good" disabled={!data.can_save} onClick={() => act('save')}>Save Active Slot</Button>
                  </Stack.Item>
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
